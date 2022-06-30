module Vips
  # Input connection. For example
  # ```
  # source = Vips::Source.new_from_file("k2.jpg")
  # image = Vips::Image.new_from_source(source)
  # ```
  class Source < Connection
    protected def initialize(@shandle : LibVips::VipsSource*)
      super(@shandle.as(LibVips::VipsConnection*))
    end

    # Create a new source from a file descriptor. File descriptors are
    # small integers, for example 0 is stdin.
    #
    # Pass sources to `Image.new_from_source` to load images from
    # them.
    def self.new_from_descriptor(descriptor : Int)
      ptr = LibVips.vips_source_new_from_descriptor(descriptor)
      raise VipsException.new("can't create source from descriptor #{descriptor}") if ptr.null?
      new(ptr)
    end

    # Create a new source from a file name.
    #
    # Pass sources to `Image.new_from_source` to load images from
    # them.
    def self.new_from_file(filename : String)
      ptr = LibVips.vips_source_new_from_file(filename)
      raise VipsException.new("can't create source from filename #{filename}") if ptr.null?

      new(ptr)
    end

    # Create a new source from an area of memory. Memory areas can be
    # String, Bytes, or IO
    #
    # Pass sources to `Image.new_from_source` to load images from
    # them.
    def self.new_from_memory(data : String | Bytes | IO)
      buff = case data
             when String then data.to_slice
             when IO     then data.gets_to_end.to_slice
             else             data
             end

      ptr = LibVips.vips_source_new_from_memory(Box.box(buff), buff.bytesize)
      raise VipsException.new("can't create source from memory #{data}") if ptr.null?
      @@references << buff
      new(ptr)
    end

    def finalize
      @@references.clear
    end

    # :nodoc:
    def to_unsafe
      @shandle
    end

    # keep reference to bytes which are passed in new_from_memory
    @@references : Array(Bytes) = Array(Bytes).new
  end

  # A source you can attach action signal handlers to to implement
  # custom input types.
  #
  # For example:
  #
  # ```
  # file = File.open("some/file/name", "rb")
  # source = Vips::SourceCustom.new
  # source.on_read { |slice| file.read(slice) }
  # image = Vips::Image.new_from_source(source)
  # ```
  #
  # (just an example -- of course in practice you'd use `Source#new_from_file`
  # to read from a named file)
  class SourceCustom < Source
    @@box : Array(Pointer(Void)?) = Array(Pointer(Void)?).new

    def initialize
      raise VipsException.new("At least libvips 8.9 is needed for SourceCustom") unless Vips.at_least_libvips?(8, 9)
      ptr = LibVips.vips_source_custom_new
      raise VipsException.new("unable to vips_source_custome_new") if ptr.null?
      super(ptr.as(LibVips::VipsSource*))
    end

    # The block is executed to read data from the source. The interface is
    # exactly as IO::read, ie. it takes a slice and reads atmost `slice.size` and
    # returns a number of bytes read from the source, or 0 if the source is already
    # at end of file.
    def on_read(&block : Bytes ->)
      boxed_data = Box.box(block)
      @@box << boxed_data

      signal_connect("read", LibVips::ReadCB.new { |_source, buff, size, data|
        next 0 if size <= 0
        callback = Box(typeof(block)).unbox(data)
        slice = Bytes.new(buff.as(UInt8*), size)
        callback.call(slice) || 0
      }, boxed_data)
    end

    # The block is executed to seek the source. The interface is exactly as
    # IO::seek, ie. it should take an offset and whence, and return the
    # new read position.
    #
    # This handler is optional -- if you do not attach a seek handler,
    # `Source` will treat your source like an unseekable pipe object and
    # do extra caching.
    def on_seek(&block : (Int64, IO::Seek) -> Int64)
      boxed_data = Box.box(block)
      @@box << boxed_data

      signal_connect("seek", LibVips::SeekCB.new { |_source, offset, whence, data|
        callback = Box(typeof(block)).unbox(data)
        ret = callback.call(offset, IO::Seek.from_value(whence))
        ret.to_i64
      }, boxed_data)
    end
  end

  # Source connected to a readable `IO`
  class SourceStream < SourceCustom
    protected def initialize(@io : IO)
      super()
      on_read &->@io.read(Bytes)
      on_seek &->do_seek(Int64, IO::Seek)
    end

    def self.new_from_stream(io : IO)
      raise VipsException.new("The stream should be readable") if io.closed?
      new(io)
    end

    private def do_seek(offset, whence)
      val = @io.seek(offset, whence) rescue nil
      return -1_i64 if val.nil?
      @io.pos
    end
  end
end
