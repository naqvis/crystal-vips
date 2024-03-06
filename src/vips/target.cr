module Vips
  # an output connection
  class Target < Connection
    protected def initialize(@thandle : LibVips::VipsTarget*)
      super(@thandle.as(LibVips::VipsConnection*))
    end

    # Make a new target to write to a file descriptor (a small integer).
    # ```
    # target = Vips::Target.new_to_descriptor(STDOUT)
    # ```
    # Makes a descriptor attached to `STDOUT`.
    #
    # You can pass this target to (for example) `write_to_target`
    def self.new_to_descriptor(descriptor : Int32)
      ptr = LibVips.vips_target_new_to_descriptor(descriptor).tap do |ret|
        raise VipsException.new("can't create output target to descriptor #{descriptor}") if ret.null?
      end
      new(ptr)
    end

    # Make a new target to write to a file.
    # ```
    # target = Vips::Target.new_to_file("myfile.jpg")
    # ```
    #
    # You can pass this target to (for example) `write_to_target`
    def self.new_to_file(filename : String)
      ptr = LibVips.vips_target_new_to_file(filename).tap do |ret|
        raise VipsException.new("can't create output target to file #{filename}") if ret.null?
      end
      new(ptr)
    end

    # Make a new target to write to an area of memory.
    # ```
    # target = Vips::Target.new_to_memory
    # ```
    #
    # You can pass this target to (for example) `write_to_target`
    #
    # After writing to target, fetch the bytes from the target object with:
    #
    # ```
    # bytes = target.blob
    # ```
    def self.new_to_memory
      ptr = LibVips.vips_target_new_to_memory.tap do |ret|
        raise VipsException.new("can't create output target to memory") if ret.null?
      end
      new(ptr)
    end

    # Get the memory object held by the target when using `new_to_memory`
    def blob : Bytes
      get("blob").as_bytes
    end

    # :nodoc:
    def to_unsafe
      @thandle
    end
  end

  # `Target` you can connect handlers to implement behavior.
  class TargetCustom < Target
    @@box : Array(Pointer(Void)?) = Array(Pointer(Void)?).new

    def initialize
      raise VipsException.new("At least libvips 8.9 is needed for TargetCustom") unless Vips.at_least_libvips?(8, 9)
      ptr = LibVips.vips_target_custom_new
      raise VipsException.new("unable to vips_target_custom_new") if ptr.null?
      super(ptr.as(LibVips::VipsTarget*))
    end

    # The block is executed to write data to the target. The interface is
    # exactly as IO::write, ie. it should write the bytes and return the
    # number of bytes written.
    def on_write(&block : Bytes -> Int64)
      boxed_data = Box.box(block)
      @@box << boxed_data

      signal_connect("write", LibVips::WriteCB.new { |source, buff, size, data|
        next -1_i64 if size <= 0
        callback = Box(typeof(block)).unbox(data)
        slice = Bytes.new(buff.as(UInt8*), size)
        @@box.delete(data)
        callback.call(slice)
      }, boxed_data)
    end

    # The block is executed at the end of write. It should do any necessary
    # finishing action, such as closing a file or flushing IO
    def on_finish(&block : ->)
      boxed_data = Box.box(block)
      @@box << boxed_data

      signal_connect("finish", LibVips::FinishCB.new { |_source, data|
        callback = Box(typeof(block)).unbox(data)
        callback.call
        @@box.delete(data)
        nil
      }, boxed_data)
    end
  end

  # Target connected to a writeable `IO`
  class TargetStream < TargetCustom
    protected def initialize(@io : IO)
      super()
      on_write &->(slice : Bytes) {
        @io.write(slice)
        slice.size.to_i64
      }
      on_finish &->{ @io.flush }
    end

    def self.new_from_stream(io : IO)
      raise VipsException.new("The stream should be write") if io.closed?
      new(io)
    end
  end
end
