module Vips
  class Image < VipsObject
    # Evaluation callback that can be used on the `Enums::Signal::PreEval`, `Enums::Signal::Eval`, and `Enums::Signal::PostEval` signals.
    # See `set_progress` to enable progress reporting on an image.
    alias EvalProc = (Image, LibVips::VipsProgress ->)

    protected def initialize(@ihandle : LibVips::VipsImage*)
      super(@ihandle.as(LibVips::VipsObject*))
      @references = Array(Bytes).new
    end

    # run a complex operation on a complex image, or an image with an even
    # number of bands ... handy for things like running .polar on .index
    # images
    def self.run_cmplx(image : Image, &block : Image -> Image)
      original_format = image.format
      if (image.format != Enums::BandFormat::Complex && image.format != Enums::BandFormat::Dpcomplex)
        if image.bands % 2 != 0
          raise VipsException.new("not an even number of bands")
        end

        if (image.format != Enums::BandFormat::Float && image.format != Enums::BandFormat::Double)
          image = image.cast(Enums::BandFormat::Float)
        end

        new_format = image.format == Enums::BandFormat::Double ? Enums::BandFormat::Dpcomplex : Enums::BandFormat::Complex
        image = image.copy(format: new_format, bands: image.bands / 2)
      end

      image = block.call(image)

      if (original_format != Enums::BandFormat::Complex && original_format != Enums::BandFormat::Dpcomplex)
        new_format = image.format == Enums::BandFormat::Dpcomplex ? Enums::BandFormat::Double : Enums::BandFormat::Float
        image = image.copy(format: new_format, bands: image.bands * 2)
      end

      image
    end

    # expand a constant into an image
    def self.imageize(match_image : Image, value) : Image
      case value
      when Image                 then value
      when Array(Array(Float64)) then new_from_array(value)
      when Array(Array(Int32))   then new_from_array(value)
      when Array(Float64)        then match_image.new_from_image(value)
      when Array(Int32)          then match_image.new_from_image(value)
      when Float64               then match_image.new_from_image(value)
      when Int32                 then match_image.new_from_image(value)
      else
        raise VipsException.new("unsupported value type #{typeof(value)} for imageize")
      end
    end

    # Find the name of the load operation vips will use to load a file.
    # For example "VipsForeignLoadJpegFile". You can use this to work out what
    # options to pass to `new_from_file`
    def self.find_load(filename : String)
      ptr = LibVips.vips_foreign_find_load(filename)
      ptr.null? ? nil : String.new(ptr)
    end

    # Find the name of the load operation vips will use to load a buffer.
    # For example "VipsForeignLoadJpegBuffer". You can use this to work out what
    # options to pass to `new_from_buffer`
    def self.find_load_buffer(data : Bytes)
      ptr = LibVips.vips_foreign_find_load_buffer(Box.box(data), data.size)
      ptr.null? ? nil : String.new(ptr)
    end

    # Find the name of the load operation vips will use to load a buffer.
    # For example "VipsForeignLoadJpegBuffer". You can use this to work out what
    # options to pass to `new_from_buffer`
    def self.find_load_buffer(data : String)
      find_load_buffer(data.to_slice)
    end

    #  Find the name of the load operation vips will use to load a source.
    # For example "VipsForeignLoadJpegSource". You can use this to work out what
    # options to pass to `new_from_source`
    def self.find_load_source(source : Source)
      ptr = LibVips.vips_foreign_find_load_source(source)
      ptr.null? ? nil : String.new(ptr)
    end

    # Find the name of the load operation vips will use to load a stream.
    # For example "VipsForeignLoadJpegSource". You can use this to work out what
    # options to pass to `new_from_stream`
    def self.find_load_stream(stream : Stream)
      source = SourceStream.new_from_stream(stream)
      find_load_source(source)
    end

    # Return a new `Image` for a file on disc. This method can load
    # images in any format supported by vips. The filename can include
    # load options, for example:
    #
    # ```
    # image = Vips::Image.new_from_file "fred.jpg[shrink=2]"
    # ```
    #
    # You can also supply options as keyword arguments (NamedTuple), for example:
    #
    # ```
    # image = Vips::Image.new_from_file "fred.jpg", shrink: 2
    # ```
    #
    # The full set of options available depend upon the load operation that
    # will be executed. Try something like:
    #
    # ```
    # $ vips jpegload
    # ```
    #
    # at the command-line to see a summary of the available options for the
    # JPEG loader.
    #
    # **Loading is fast**: only enough of the image is loaded to be able to fill
    # out the header. Pixels will only be decompressed when they are needed.
    def self.new_from_file(name : String, memory : Bool? = nil, access : Enums::Access? = nil,
                           failon : Enums::FailOn? = nil, **opts) : Image
      filename = String.new(LibVips.vips_filename_get_filename(name))
      file_options = String.new(LibVips.vips_filename_get_options(name))

      loader = String.new(LibVips.vips_foreign_find_load(filename) || Bytes.empty)
      raise VipsException.new("Unable to load from #{filename}") if loader.blank?

      options = Optional.new(**opts)

      options["memory"] = memory unless memory.nil?
      options["access"] = access.value unless access.nil?
      Enums.add_failon(options, failon)

      options["string_options"] = file_options

      Operation.call(loader, options, filename).as(Type).as_image
    end

    # Create a new `Image` for an image encoded in a format such as
    # JPEG in a binary `String`, `Bytes` or `IO`. Load options may be passed as
    # strings or appended as a keyword arguments. For example:
    #
    # ```
    # image = Vips::Image.new_from_buffer memory_buffer, "shrink=2"
    # ```
    #
    # or alternatively:
    #
    # ```
    # image = Vips::Image.new_from_buffer memory_buffer, "", shrink: 2
    # ```
    #
    # The options available depend on the file format. Try something like:
    #
    # ```
    # $ vips jpegload_buffer
    # ```
    #
    # at the command-line to see the available options. Not all loaders
    # support load from buffer, but at least JPEG, PNG and
    # TIFF images will work.
    #
    # **Loading is fast**: only enough of the image is loaded to be able to fill
    # out the header. Pixels will only be decompressed when they are needed.
    def self.new_from_buffer(data : String | Bytes | IO, option_string : String = "", access : Enums::Access? = nil,
                             failon : Enums::FailOn? = nil, **opts) : Image
      buffer = case data
               when String then data.to_slice
               when IO     then data.gets_to_end.to_slice
               else             data
               end
      loader = String.new(LibVips.vips_foreign_find_load_buffer(buffer, buffer.bytesize) || Bytes.empty)
      raise VipsException.new("Unable to load from buffer") if loader.blank?

      options = Optional.new(**opts)

      options["access"] = access.value unless access.nil?
      Enums.add_failon(options, failon)

      options["string_options"] = option_string

      Operation.call(loader, options, buffer).as(Type).as_image
    end

    # Create a new `Image` from a source. Load options may be passed as
    # strings or appended as a hash. For example:
    #
    # ```
    # source = Vips::Source.new_from_file("k2.jpg")
    # image = Vips::Image.new_from_source source, "shrink=2"
    # ```
    #
    # or alternatively:
    #
    # ```
    # image = Vips::Image.new_from_source source, shrink: 2
    # ```
    #
    # The options available depend on the file format. Try something like:
    #
    # ```
    # $ vips jpegload_source
    # ```
    #
    # at the command-line to see the available options. Not all loaders
    # support load from source, but at least JPEG, PNG and
    # TIFF images will work.
    #
    # **Loading is fast**: only enough data is read to be able to fill
    # out the header. Pixels will only be read and decompressed when they are
    # needed.
    def self.new_from_source(source : Source, option_string : String = "", access : Enums::Access? = nil,
                             failon : Enums::FailOn? = nil, **opts) : Image
      # Load with the new source API if we can. Fall back to the older
      # mechanism in case the loader we need has not been converted yet.
      # We need to hide any errors from this first phase.
      LibVips.vips_error_freeze
      opname = find_load_source(source)
      LibVips.vips_error_thaw

      options = Optional.new(**opts)

      options["access"] = access.value unless access.nil?
      Enums.add_failon(options, failon)

      options["string_options"] = option_string

      return Operation.call(opname, options, source).as(Type).as_image unless opname.nil?

      # fallback mechanism
      if (filename = source.filename)
        # Try with the old file-based loaders.
        opname = find_load(filename)
        raise VipsException.new("unable to load from source") if opname.nil?
        return Operation.call(opname, options, filename).as(Type).as_image
      end

      # Try with the old buffer-based loaders.
      ptr = LibVips.vips_source_map_blob(source)
      raise VipsException.new("unable to load from source") if ptr.null?
      blob = VipsBlob.new(ptr)
      buff, size = blob.get_data
      opname = LibVips.vips_foreign_find_load_buffer(buff, size)
      raise VipsException.new("unable to load from source") if opname.null?
      return Operation.call(String.new(opname), options, blob).as(Type).as_image
    end

    # Load a formatted image from a stream
    # This behaves exactly as `new_from_source`, but the image is loaded from a stream rathar than from a source.
    # Note: AT least libvips 8.9 is needed
    def self.new_from_stream(stream : IO, option_string : String = "", access : Enums::Access? = nil,
                             failon : Enums::FailOn? = nil, **opts) : Image
      source = SourceStream.new_from_stream(stream)
      new_from_source(source, option_string, access, failon, **opts)
    end

    # Create a new Image from a 1D or 2D array. A 1D array becomes an
    # image with height 1. Use `scale` and `offset` to set the scale and
    # offset fields in the header. These are useful for integer
    # convolutions.
    #
    # For example:
    #
    # ```
    # image = Vips::Image.new_from_array [1, 2, 3]
    # ```
    #
    # or
    #
    # ```
    # image = Vips::Image.new_from_array [
    #   [-1, -1, -1],
    #   [-1, 16, -1],
    #   [-1, -1, -1],
    # ], 8
    # ```
    #
    # for a simple sharpening mask.
    def self.new_from_array(array : Array, scale = 1.0, offset = 0.0) : Image
      if (darr = array[0].as?(Array))
        height = array.size
        width = darr.size
        unless array.all? { |x| x.is_a?(Array) }
          raise VipsException.new("Not a 2D array.")
        end
        unless array.all? { |x| x.as?(Array).try &.size == width }
          raise VipsException.new("Array not rectangular.")
        end

        array = array.flatten
      else
        height = 1
        width = array.size
      end

      unless array.size == width * height
        raise VipsException.new("Bad array dimensions.")
      end

      unless array.all? { |x| x.is_a?(Number) }
        raise VipsException.new("Not all array elements are Numeric.")
      end

      dblarr = Array(Float64).new(array.size) { |i| array[i].as(Number).to_f }
      vi = LibVips.vips_image_new_matrix_from_array(width, height, dblarr, dblarr.size)
      raise VipsException.new("unable to make image from matrix") if vi.null?

      image = new(vi)

      image.mutate do |mutable|
        # be careful to set them as double
        mutable.set(GValue::GDouble, "scale", scale)
        mutable.set(GValue::GDouble, "offset", offset)
      end
    end

    # Wraps an Image around an area of memory containing a C-style array. For
    # example, if the `data` memory array contains four bytes with the
    # values 1, 2, 3, 4, you can make a one-band, 2x2 uchar image from
    # it like this:
    # ```
    # image = Image.new_from_memory(data, 2, 2, 1, Enums::BandFormat::Uchar)
    # ```
    #
    # A reference is kept to the data object, so it will not be
    # garbage-collected until the returned image is garbage-collected.
    #
    # This method is useful for efficiently transferring images from GDI+
    # into libvips.
    def self.new_from_memory(data : Bytes, width : Int32, height : Int32, bands : Int32, format : Enums::BandFormat) : Image
      vi = LibVips.vips_image_new_from_memory(Box.box(data), data.size, width, height, bands, LibVips::VipsBandFormat.from_value(format.value))
      raise VipsException.new("unable to make image from memory") if vi.null?

      image = new(vi)
      # keep a secret ref to the underlying object .. this reference will be
      # inherited by things that in turn depend on us, so the memory we are
      # using will not be freed
      image.@references << data
      image
    end

    # Create a new `Image` from memory and copies the memory area. See
    # `new_from_memory` for a version of this method which does not copy the
    # memory area.
    def self.new_from_memory_copy(data : Void*, size : UInt64, width : Int32, height : Int32, bands : Int32, format : Enums::BandFormat) : Image
      vi = LibVips.vips_image_new_from_memory_copy(data, size, width, height, bands, LibVips::VipsBandFormat.from_value(format.value))
      raise VipsException.new("unable to make image from memory") if vi.null?
      new(vi)
    end

    # Make a new temporary image.
    # Returns an image backed by a temporary file. When written to with `write`, a temporary
    # file will be created on disc in the specified format. When the image is closed, the file will be deleted
    # automatically.
    #
    # The file is created in the temporary directory. This is set with the environment variable `TMPDIR`.
    # If this is not set, then on Unix systems, vips will default to `/tmp`. On Windows, vips uses
    # `GetTempPath()` to find the temporary director.
    #
    # vips uses `g_mkstemp()` to make the temporary filename. They generally look something like `vips-12-EJKFGH.v`
    # *format* is the format for the temp file, for example `%s.v` for a vips format file. The `%s` is
    # subsituted by the file path.
    #
    # Note: `VipsException` is raised, if unable to make temp file from *format*
    def self.new_temp_file(format : String) : Image
      vi = LibVips.vips_image_new_temp_file(format)
      raise VipsException.new("unable to make temp file") if vi.null?
      new(vi)
    end

    # A new image is created with the same width, height, format,
    # interpretation, resolution and offset as self, but with every pixel
    # set to the specified value.
    #
    # You can pass an array to make a many-band image, or a single value to
    # make a one-band image.
    def new_from_image(*value : Int32 | Float64)
      dblarr = Array(Float64).new(value.size) { |i| value.at(i).to_f }
      pixel = (Image.black(1, 1) + dblarr).cast(format)
      image = pixel.embed(0, 0, width, height, extend: Enums::Extend::Copy)
      image.copy(interpretation: interpretation, xres: xres, yres: yres,
        xoffset: xoffset, yoffset: yoffset)
    end

    # A new image is created with the same width, height, format,
    # interpretation, resolution and offset as self, but with every pixel
    # set to the specified value.
    #
    # You can pass an array to make a many-band image, or a single value to
    # make a one-band image.
    def new_from_image(value)
      pixel = (Image.black(1, 1) + value).cast(format)
      image = pixel.embed(0, 0, width, height, extend: Enums::Extend::Copy)
      image.copy(interpretation: interpretation, xres: xres, yres: yres,
        xoffset: xoffset, yoffset: yoffset)
    end

    # Copy an image to a memory area.
    #
    # This can be useful for reusing results, but can obviously use a lot of
    # memory for large images. See {Image#tilecache} for a way of caching
    # parts of an image.
    #
    # Returns new memory `Image`
    def copy_memory
      vi = LibVips.vips_image_copy_memory(self)
      raise VipsException.new("unable to copy to memory") if vi.null?
      new(vi)
    end

    # Write this image to a file. This method can save images in any format supported by vips. Save options may be encoded in the
    # filename or given as a keyword argument. For example:
    #
    # ```
    # image.write_to_file("fred.jpg[Q=95])"
    # ```
    #
    # or equivalently:
    #
    # ```
    # image.write_to_file("fred.jpg", Q: 95)
    # ```
    #
    # The full set of save options depend on the selected saver. Try
    # something like:
    #
    # ```
    # $ vips jpegsave
    # ```
    #
    # to see all the available options for JPEG save.
    #
    # Get the `GType` of a metadata field. The result is 0 if no such field
    # exists.
    def write_to_file(name : String, **kwargs)
      filename = String.new(LibVips.vips_filename_get_filename(name))
      file_options = String.new(LibVips.vips_filename_get_options(name))

      operation_name = String.new(LibVips.vips_foreign_find_save(filename) || Bytes.empty)
      raise VipsException.new("Unable to write to file #{filename}") if operation_name.blank?

      options = Optional.new(**kwargs)
      options["string_options"] = file_options

      call(operation_name, options, filename)
    end

    # Write this image to a memory buffer. This method can save images in any format supported by vips. Save options may be encoded in the
    # filename or given as a keyword argument. For example:
    #
    # ```
    # image.write_to_file("fred.jpg[Q=95])"
    # ```
    #
    # or equivalently:
    #
    # ```
    # image.write_to_file("fred.jpg", Q: 95)
    # ```
    #
    # The full set of save options depend on the selected saver. Try
    # something like:
    #
    # ```
    # $ vips jpegsave
    # ```
    #
    # to see all the available options for JPEG save.
    #
    # Get the `GType` of a metadata field. The result is 0 if no such field
    # exists.
    def write_to_buffer(format : String, **kwargs)
      buffer_options = String.new(LibVips.vips_filename_get_options(format))

      # try to save with the new target API first, only fall back to the old
      # buffer API if there's no target save for this filetype
      saver = Pointer(UInt8).null
      if Vips.at_least_libvips?(8, 9)
        LibVips.vips_error_freeze
        saver = LibVips.vips_foreign_find_save_target(filename)
        LibVips.vips_error_thaw
      end

      options = Optional.new(**kwargs)
      options["string_options"] = buffer_options

      if !saver.null?
        target = Target.new_to_memory
        call(String.new(saver), options, target)
        return target.blob
      end

      # fallback mechanism

      saver = LibVips.vips_foreign_find_save_buffer(format)
      raise VipsException.new("unable to write to buffer") if saver.nil?
      return call(String.new(saver), options).as(Type).as_bytes
    end

    # Write an image to a target.
    # This behaves exactly as `write_to_file`, but the image is
    # written to a *target* rather than a file.
    # Note: At least libvips 8.9 is needed.
    def write_to_target(target : Target, format : String, **kwargs)
      buffer_options = String.new(LibVips.vips_filename_get_options(format))

      operation_name = String.new(LibVips.vips_foreign_find_save_target(format) || Bytes.empty)
      raise VipsException.new("Unable to write to target") if operation_name.blank?

      options = Optional.new(**kwargs)
      options["string_options"] = buffer_options

      call(operation_name, options, target)
    end

    # Write an image to a stream.
    # This behaves exactly as `write_to_file`, but the image is
    # written to a *stream* rather than a file.
    # Note: At least libvips 8.9 is needed.
    def write_to_target(stream : IO, format : String, **kwargs)
      target = TargetStream.new_from_stream(stream)
      write_to_target(target, format, **kwargs)
    end

    # Write the image to memory as a simple, unformatted C-style array.
    # Note: The caller is responsible for freeing this memory with `Vips.free`
    # Returns {Void*, LibC::SizeT}
    def write_to_memory : {Void*, LibC::SizeT}
      ptr = LibVips.vips_image_write_to_memory(self, out size)
      raise VipsException.new("unable to write to memory") if ptr.null?
      {ptr, size}
    end

    # Write the image to a `Bytes`.
    # A large area of memory is allocated, the image is rendered to that
    # memory array, and the array is returned as a buffer.
    #
    # For example, if you have a 2x2 uchar image containing the bytes 1, 2,
    # 3, 4, read left-to-right, top-to-bottom, then:
    # ```
    # buf = image.write_to_memory # => return Bytes of size 4 containing values 1,2,3,4
    # ```
    # Returns `Bytes`
    def write_to_bytes : Bytes
      ptr, size = write_to_memory
      result = Bytes.new(size)
      # ptr.copy_to(result.to_unsafe.as(Void*), size)
      result.to_unsafe.copy_from(ptr.as(UInt8*), size)
      Vips.free(ptr)
      result
    end

    # Write an image to another image.
    # This function writes `self` to another image. Use something like
    # `new_temp_file` to make an image that can be written to.
    def write(other : Image)
      LibVips.vips_image_write(self, other.to_unsafe).tap do |ret|
        raise VipsException.new("unable to write to image") unless ret == 0
      end
    end

    def get_typeof(nam : String)
      # on libvips before 8.5, property types must be searched first,
      # since vips_image_get_typeof returned built-in enums as int
      unless Vips.at_least_libvips?(8, 5)
        gtype = super
        return gtype unless gtype.nil?
      end

      LibVips.vips_image_get_typeof(self, nam)
    end

    # Check if the underlying image contains an property of metadata.
    def contains(name : String)
      get_typeof(name) != 0
    end

    # Get a metadata item from an image. Crystal types are constructed
    # automatically from the `GValue`, if possible.
    #
    # For example, you can read the ICC profile from an image like this:
    #
    # ```
    # profile = image.get "icc-profile-data"
    # ```
    #
    # and profile will be an array containing the profile.
    def get(name : String)
      return Type.new(1.0) if name == "scale " && !contains("scale")
      return Type.new(0.0) if name == "offset" && !contains("offset")

      # with old libvips, we must fetch properties (as opposed to
      # metadata) via VipsObject
      unless Vips.at_least_libvips?(8, 5)
        return super if get_typeof(name: name) != 0
      end
      gv_copy = GValue.new
      raise VipsException.new("unable to get #{name}") if LibVips.vips_image_get(self, name, gv_copy) != 0
      gv = GValue.new(gv_copy)
      gv.get
    end

    # Get the names of all fields on an image. Use this to loop over all
    # image metadata.
    def get_fields
      names = Array(String).new
      # vips_image_get_fields() was added in libvips 8.5
      return names unless Vips.at_least_libvips?(8, 5)

      ptr = LibVips.vips_image_get_fields(self)
      aptr = ptr
      while (p = ptr.value)
        names << String.new(p)
        LibVips.g_free(p)
        ptr += 1
      end

      LibVips.g_free(aptr)
      names
    end

    # Mutate an image with a block. Inside the block, you can call methods
    # which modify the image, such as setting or removing metadata, or
    # modifying pixels.
    #
    # For example:
    #
    # ```
    # image = image.mutate do |x|
    #   (0..1).step 0.01 do |i|
    #     x.draw_line([255.0], (x.width * i).to_i, 0, 0, (x.height * (1 - i)).to_i)
    #   end
    # end
    # ```
    #
    # See `MutableImage`.
    def mutate
      mutable = MutableImage.new(self)
      yield mutable
      mutable.image
    end

    # Scale an image to 0 - 255. This is the libvips `scale` operation, but
    # renamed to avoid a clash with the `scale` for convolution masks.
    def scaleimage(**opts)
      options = Optional.new(**opts)
      call("scale", options).as(Type).as_image
    end

    # ifthenelse an image
    # Select pixels from `th` if `self` is non-zero and from `el` if
    # `self` is zero. Use the `:blend` option to fade smoothly
    # between `th` and `el`.
    #
    # *in1 : Image | Float64 | Array(Float64)*  true values
    #
    # *in2 : Image | Float64 | Array(Float64)* false values
    #
    # *blend : Bool* (false) Blend smoothly between *in1* and *in2*
    #
    # Returns merged `Image`
    def ifthenelse(in1, in2, blend = false)
      match_image = in1.is_a?(Image) ? in1.as(Image) : (in2.is_a?(Image) ? in2.as(Image) : self)

      unless in1.is_a?(Image)
        in1 = Image.imageize(match_image, in1.not_nil!)
      end
      unless in2.is_a?(Image)
        in2 = Image.imageize(match_image, in2.not_nil!)
      end
      options = Optional.new(**{blend: blend})
      call("ifthenelse", options, in1, in2).as(Type).as_image
    end

    # Use pixel values to pick cases from an array of constants
    def case(*args : Float64) : Image
      call("case", args.to_a).as(Type).as_image
    end

    # Use pixel values to pick cases from an array of constants
    def case(*args : Int32) : Image
      self.case(*args.map(&.to_f))
    end

    # Use pixel values to pick cases from an array of images.
    def case(*images : Image) : Image
      call("case", images.to_a).as(Type).as_image
    end

    # Use pixel values to pick cases from an a set of mixed images and constants.
    def case(*args) : Image
      call("case", args.to_a).as(Type).as_image
    end

    # Append a set of constants bandwise
    def bandjoin(*arr : Float64) : Image
      bandjoin(arr.to_a)
    end

    # Append a set of constants bandwise
    def bandjoin(*arr : Int32) : Image
      bandjoin(arr.to_a)
    end

    def bandjoin(arr : Array(Int32)) : Image
      bandjoin(arr.map(&.to_f))
    end

    def bandjoin(arr : Array(Float64)) : Image
      bandjoin_const(arr)
    end

    # Append a set of images bandwise
    def bandjoin(*arr : Image) : Image
      bandjoin(arr.to_a)
    end

    def bandjoin(arr : Array(Image)) : Image
      call("bandjoin", arr.unshift(self)).as(Type).as_image
    end

    # Append a set of mixed images and constants bandwise
    def bandjoin(*arr : Image | Number) : Image
      call("bandjoin", arr.to_a.unshift(self)).as(Type).as_image
    end

    # Band-wise rank a set of constants.
    #
    # _Optionals_
    #
    # *index* : Int32 - Select this band element from sorted list
    def bandrank(*vals : Float64, **kwargs)
      options = Optional.new(**kwargs)
      call("bandrank", options, vals.to_a).as(Type).as_image
    end

    # Band-wise rank a set of constants.
    #
    # _Optionals_
    #
    # *index* : Int32 - Select this band element from sorted list
    def bandrank(*vals : Int32, **kwargs)
      bandrank(*vals.map(&.to_f), **kwargs)
    end

    # Band-wise rank a set of images.
    #
    # _Optionals_
    #
    # *index* : Int32 - Select this band element from sorted list
    def bandrank(*vals : Image, **kwargs)
      options = Optional.new(**kwargs)
      call("bandrank", options, vals.to_a.unshift(self)).as(Type).as_image
    end

    # Band-wise rank a set of mixed images and constants.
    #
    # _Optionals_
    #
    # *index* : Int32 - Select this band element from sorted list
    def bandrank(*vals, **kwargs)
      options = Optional.new(**kwargs)
      call("bandrank", options, vals.to_a.unshift(self)).as(Type).as_image
    end

    # Blend an array of images with an array of blend modes
    #
    # ```
    # # out_ = Vips::Image.composite(images, modes, {x: Array(Int32), y: Array(Int32), compositing_space: Enums::Interpretation, premultiplied: Bool})
    # ```
    #
    # Input Parameters
    #
    # **Required**
    #
    # *images* : Array(Image) - Array of input images
    #
    # *modes* : Array(Enums::BlendMode) - Array of `Enums::BlendMode` to join with
    #
    # _Optionals_
    #
    # *x* : Array(Int32) - Array of x coordinates to join at
    #
    # *y* : Array(Int32) - Array of y coordinates to join at
    #
    # *compositing_space* : `Enums::Interpretation` - Composite images in this colour space
    #
    # *premultiplied* : Bool - Images have premultiplied alpha
    #
    # **Returns**
    #
    # Output `Image`
    def composite(images : Array(Image), modes : Array(Enums::BlendMode), **kwargs)
      options = Optional.new(**kwargs)

      Operation.call("composite", options, images.unshift(self), modes).as(Type).as_image
    end

    # A synonym for `composite2`
    #
    # ```
    # # out_ = Vips::Image.composite(overlay, mode, {x: Array(Int32), y: Array(Int32), compositing_space: Enums::Interpretation, premultiplied: Bool})
    # ```
    #
    # Input Parameters
    #
    # **Required**
    #
    # *overlay* : Image - Overlay image
    #
    # *modes : Enums::BlendMode - VipsBlendMode to join with
    #
    # _Optionals_
    #
    # *x* : Int32 - x position of overlay
    #
    # *y* : Int32 - y position of overlay
    #
    # *compositing_space* : `Enums::Interpretation` - Composite images in this colour space
    #
    # *premultiplied* : Bool - Images have premultiplied alpha
    #
    # **Returns**
    #
    # Output image
    def composite(image : Image, mode : Enums::BlendMode, **kwargs)
      composite2(image, mode, **kwargs)
    end

    # A synonym for `extract_area`
    def crop(left : Int32, top : Int32, width : Int32, height : Int32)
      extract_area(left, top, width, height)
    end

    # Return the coordinates of the image maximum.
    def maxpos
      v, x, y, _, _, _ = self.max
      {v, x.try &.to_f || 0_f64, y.try &.to_f || 0_f64}
    end

    # Return the coordinates of the image minimum.
    def minpos
      v, x, y, _, _, _ = self.min
      {v, x.try &.to_f || 0_f64, y.try &.to_f || 0_f64}
    end

    # Return the real part of a complex image.
    def real : Image
      complexget(Enums::OperationComplexget::Real)
    end

    # Return the imaginary part of a complex image.
    def imag : Image
      complexget(Enums::OperationComplexget::Imag)
    end

    # Return an image converted to polar coordinates.
    def polar : Image
      Image.run_cmplx(self) { |x| x.complex(Enums::OperationComplex::Polar) }
    end

    # Return an image converted to rectangular coordinates.
    def rect : Image
      Image.run_cmplx(self) { |x| x.complex(Enums::OperationComplex::Rect) }
    end

    # Return the complex conjugate of an image.
    def conj : Image
      complex(Enums::OperationComplex::Conj)
    end

    # Return the sine of an image in degrees.
    def sin : Image
      self.math(Enums::OperationMath::Sin)
    end

    # Return the cosine of an image in degrees.
    def cos : Image
      self.math(Enums::OperationMath::Cos)
    end

    # Return the tangent of an image in degrees.
    def tan : Image
      self.math(Enums::OperationMath::Tan)
    end

    # Return the inverse sine of an image in degrees.
    def asin : Image
      self.math(Enums::OperationMath::Asin)
    end

    # Return the inverse cosine of an image in degrees.
    def acos : Image
      self.math(Enums::OperationMath::Acos)
    end

    # Return the inverse tangent of an image in degrees.
    def atan : Image
      self.math(Enums::OperationMath::Atan)
    end

    # Return the hyperbolic sine of an image in degrees.
    def sinh : Image
      self.math(Enums::OperationMath::Sinh)
    end

    # Return the hyperbolic cosine of an image in degrees.
    def cosh : Image
      self.math(Enums::OperationMath::Cosh)
    end

    # Return the hyperbolic tangent of an image in degrees.
    def tanh : Image
      self.math(Enums::OperationMath::Tanh)
    end

    # Return the inverse hyperbolic sine of an image in degrees.
    def a_sinh : Image
      self.math(Enums::OperationMath::Asinh)
    end

    # Return the inverse hyperbolic cosine of an image in degrees.
    def a_cosh : Image
      self.math(Enums::OperationMath::Acosh)
    end

    # Return the inverse hyperbolic tangent of an image in degrees.
    def a_tanh : Image
      self.math(Enums::OperationMath::Atanh)
    end

    # Return the natural log of an image
    def log : Image
      self.math(Enums::OperationMath::Log)
    end

    # Return the log base 10 of an image
    def log10 : Image
      self.math(Enums::OperationMath::Log10)
    end

    # Returns e ** pixel
    def exp : Image
      self.math(Enums::OperationMath::Exp)
    end

    # Returns 10 ** pixel
    def exp10 : Image
      self.math(Enums::OperationMath::Exp10)
    end

    # Raise to the power of an image
    def **(exp : Image)
      self.math2(exp, Enums::OperationMath2::Pow)
    end

    # Raise to the power of a constant or an array of constants
    def **(*exp : Number)
      self.**(exp.to_a)
    end

    # Raise to the power of a constant or an array of constants
    def **(exp : Array(Number))
      self.math2_const(Enums::OperationMath2::Pow, exp.map(&.to_f))
    end

    # Arc tangent of an image in degrees.
    def a_tan2(x : Image)
      self.math2(x, Enums::OperationMath2::Atan2)
    end

    # Arc tangent of a constant or an array of constants in degrees
    def **(*exp : Number)
      self.math2_const(Enums::OperationMath2::Atan2, exp.map(&.to_f).to_a)
    end

    # Erode with a structuring element.
    def erode(mask : Image)
      morph(mask, Enums::OperationMorphology::Erode)
    end

    # Dilate with a structuring element.
    def dilate(mask : Image)
      morph(mask, Enums::OperationMorphology::Dilate)
    end

    # size x size median filter.
    def median(size = 3)
      rank(size, size, size*size // 2)
    end

    # Flip horizontally
    def fliphor
      flip(Enums::Direction::Horizontal)
    end

    # Flip vertically
    def flipver
      flip(Enums::Direction::Vertical)
    end

    # Rotate 90 degrees clockwise.
    def rot90
      rot(Enums::Angle::D90)
    end

    # Rotate 180 degrees clockwise.
    def rot180
      rot(Enums::Angle::D180)
    end

    # Rotate 270 degrees clockwise.
    def rot270
      rot(Enums::Angle::D270)
    end

    # Return the largest integral value not greater than the argument.
    def floor : Image
      self.call("round", Enums::OperationRound::Floor).as(Type).as_image
    end

    # Return the smallest integral value not less than the argument.
    def ceil : Image
      self.call("round", Enums::OperationRound::Ceil).as(Type).as_image
    end

    # Return the nearest integral value.
    def rint : Image
      self.call("round", Enums::OperationRound::Rint).as(Type).as_image
    end

    # AND the bands of an image together
    def bandand
      self.call("bandbool", Enums::OperationBoolean::And).as(Type).as_image
    end

    # OR the bands of an image together
    def bandor
      self.call("bandbool", Enums::OperationBoolean::Or).as(Type).as_image
    end

    # EOR the bands of an image together
    def bandeor
      self.call("bandbool", Enums::OperationBoolean::Eor).as(Type).as_image
    end

    def scale
      get("scale").as_f64
    end

    def offset
      get("offset").as_f64
    end

    # Get the image size
    def size
      [width, height]
    end

    def +(other)
      if other.is_a?(Image)
        add(other)
      else
        call("linear", 1.0, convert(other, "addition") { |x| x.to_f }).as(Type).as_image
      end
    end

    def -(other)
      if other.is_a?(Image)
        subtract(other)
      else
        call("linear", 1.0, convert(other, "subtraction") { |x| x.to_f * -1 }).as(Type).as_image
      end
    end

    def *(other)
      if other.is_a?(Image)
        subtract(other)
      else
        call("linear", convert(other, "multiplication") { |x| x.to_f }, 0.0).as(Type).as_image
      end
    end

    def /(other)
      if other.is_a?(Image)
        subtract(other)
      else
        call("linear", convert(other, "division") { |x| 1.0 / x }, 0.0).as(Type).as_image
      end
    end

    def %(other)
      if other.is_a?(Image)
        remainder(other)
      else
        call("remainder_const", other).as(Type).as_image
      end
    end

    def &(other)
      if other.is_a?(Image)
        boolean(other, Enums::OperationBoolean::And)
      else
        call("boolean_const", Enums::OperationBoolean::And, other).as(Type).as_image
      end
    end

    def |(other)
      if other.is_a?(Image)
        boolean(other, Enums::OperationBoolean::Or)
      else
        call("boolean_const", Enums::OperationBoolean::Or, other).as(Type).as_image
      end
    end

    def ^(other)
      if other.is_a?(Image)
        boolean(other, Enums::OperationBoolean::Eor)
      else
        call("boolean_const", Enums::OperationBoolean::Eor, other).as(Type).as_image
      end
    end

    def <<(other)
      if other.is_a?(Image)
        boolean(other, Enums::OperationBoolean::Lshift)
      else
        call("boolean_const", Enums::OperationBoolean::Lshift, other).as(Type).as_image
      end
    end

    def >>(other)
      if other.is_a?(Image)
        boolean(other, Enums::OperationBoolean::Rshift)
      else
        call("boolean_const", Enums::OperationBoolean::Rshift, other).as(Type).as_image
      end
    end

    def ==(other)
      if other.is_a?(Image)
        relational(other, Enums::OperationRelational::Equal)
      else
        call("relational_const", Enums::OperationRelational::Equal, other).as(Type).as_image
      end
    end

    def !=(other)
      if other.is_a?(Image)
        relational(other, Enums::OperationRelational::Noteq)
      else
        call("relational_const", Enums::OperationRelational::Noteq, other).as(Type).as_image
      end
    end

    def <(other)
      if other.is_a?(Image)
        relational(other, Enums::OperationRelational::Less)
      else
        call("relational_const", Enums::OperationRelational::Less, other).as(Type).as_image
      end
    end

    def >(other)
      if other.is_a?(Image)
        relational(other, Enums::OperationRelational::More)
      else
        call("relational_const", Enums::OperationRelational::More, other).as(Type).as_image
      end
    end

    def <=(other)
      if other.is_a?(Image)
        relational(other, Enums::OperationRelational::Lesseq)
      else
        call("relational_const", Enums::OperationRelational::Lesseq, other).as(Type).as_image
      end
    end

    def >=(other)
      if other.is_a?(Image)
        relational(other, Enums::OperationRelational::Moreeq)
      else
        call("relational_const", Enums::OperationRelational::Moreeq, other).as(Type).as_image
      end
    end

    # Does this image have an alpha channel?
    def has_alpha? : Bool
      # use `vips_image_hasalpha` on libvips >= 8.5
      return LibVips.vips_image_hasalpha(self) != 0 if Vips.at_least_libvips?(8, 5)

      bands == 2 || (bands == 4 && interpretation != Enums::Interpretation::Cmyk) || bands > 4
    end

    # Append an alpha channel to an image.
    def add_alpha : Image
      # use `vips_addalpha` on libvips >= 8.6.
      if Vips.at_least_libvips?(8, 6)
        LibVips.vips_addalpha(self, out vi).tap do |ret|
          raise VipsException.new("unable to append alpha channel to image") unless ret == 0
        end
        return Image.new(vi)
      end

      max_alpha = [Enums::Interpretation::Grey16, Enums::Interpretation::Rgb16].includes?(interpretation) ? 65535 : 255
      bandjoin(max_alpha)
    end

    # If image has been killed see `set_kill`, set an error message,
    # clear the `kill` flag and return true. Otherwise return false
    #
    # Handy for loops which need to run sets of threads which can fail.
    # At least libvips 8.8 is needed. If this version requirement is not met,
    # it will always return false.
    def killed?
      return false unless Vips.at_least_libvips?(8, 8)
      LibVips.vips_image_iskilled(self)
    end

    # Set the `kill` flag on an image. Handy for stopping sets of threads.
    # At least libvips 8.8 is needed.
    def set_kill(kill : Bool)
      return unless Vips.at_least_libvips?(8, 8)
      LibVips.vips_image_set_kill(self, kill)
    end

    # Connects a `EvalProc` callback to a signal on this image.
    # The callback will be triggered every time this signal is issued on this image.
    def signal_connect(signal : Enums::Signal, data : Pointer(Void) = Pointer(Void).null, &callback : EvalProc)
      signal_connect(signal.to_s.downcase, callback, data)
    end

    # Enable progress reporting on an image.
    # When progress reporting is enabled, evaluation of the most downstream
    # image from this image will report progress using the `Enums::Signal::PreEval`,
    # `Enums::Signal::Eval` and `Enums::Signal::PostEval` signals.
    def set_progress(enable : Bool)
      LibVips.vips_image_set_progress(self, enable)
    end

    # Enable progress reporting on an image and provide a block which will be executed on feedback.
    # You can use this function to update user-interfaces with progress feedback, for example
    #
    # ```
    # image = Vips::Image.new_from_file("huge.jpg", access: Enums::Access.Sequential)
    # image.set_progress { |percent| puts "#{percent} complete" }
    # image.dzsave("image-pyramid")
    # ```
    def set_progress(&block : Int32 -> Nil)
      last_percent = 0

      signal_connect(Enums::Signal::Eval) do |image, progress|
        block.call(progress.percent) unless progress.percent == last_percent
      end
    end

    # Multi-page images can have a page height.
    # If page-height is not set, it defaults to the image height.
    # Note: At least libvips 8.8 is needed.
    def page_height : Int32
      LibVips.vips_image_get_page_height(self)
    end

    # Does band exist in image.
    def band_exists?(i : Int32)
      i >= 0 && i <= bands - 1
    end

    # pull out band elements from an image
    def [](i : Int32)
      raise ArgumentError.new("Band index out of bounds") unless band_exists?(i)
      extract_band(i)
    end

    # Fetch bands using a range
    def [](index : Range)
      raise ArgumentError.new("Band index out of bounds for range start") unless band_exists?(index.begin)
      raise ArgumentError.new("Band index out of bounds for range start") unless band_exists?(index.end)
      extract_band(index.begin, n: index.end)
    end

    # A synonym for `getpoint`
    def [](x : Int32, y : Int32)
      getpoint(x, y)
    end

    # Split an n-band image into n separate images.
    def bandsplit : Array(Image)
      (0...bands).map { |i| extract_band(i) }
    end

    def to_s(io : IO)
      io << "<Image #{width}x#{height} #{format}, #{bands} bands, #{interpretation}>"
    end

    protected def call(operation_name : String)
      Operation.call(operation_name, nil, self)
    end

    protected def call(operation_name : String, options : Optional)
      Operation.call(operation_name, options, self)
    end

    protected def call(operation_name : String, options : Optional, *args)
      Operation.call(operation_name, options, self, *args)
    end

    protected def call(operation_name : String, *args)
      Operation.call(operation_name, nil, self, *args)
    end

    # :nodoc:
    def to_unsafe
      @ihandle
    end

    # :nodoc:
    def to_obj
      @ohandle
    end

    # :nodoc:
    def finalize
      @references.clear
    end

    private def convert(value, op, &block) # : Array
      if value.responds_to?(:map)
        if value.first.is_a?(Number)
          value.map { |v| yield v }
        else
          raise VipsException.new("unsupported Array(#{typeof(value.first)}) for image #{op}")
        end
      elsif value.is_a?(Number)
        # [yield value]
        yield value
      else
        raise VipsException.new("unsupported value type #{typeof(value)} for image #{op}")
      end
    end
  end
end
