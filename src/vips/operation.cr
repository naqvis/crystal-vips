module Vips
  class Operation < VipsObject
    @ophandle : LibVips::VipsOperation*

    def initialize(@ophandle)
      super(@ophandle.as(LibVips::VipsObject*))
    end

    # Creates a new `VisOperation` with the specified nickname
    # You'll need to set any arguments and build the operation before you can use it.
    def self.new(operation_name : String)
      op = LibVips.vips_operation_new(operation_name)
      raise VipsException.new("no such operation #{operation_name}") if op.null?
      new(op)
    end

    def self.build(operation : Operation)
      op = LibVips.vips_cache_operation_build(operation)
      if op.null?
        LibVips.vips_object_unref_outputs(operation.to_obj)
        raise VipsException.new("unable to call operation")
      end

      new(op)
    end

    # Set a GObject property. The value is converted to the property type, if possible.
    protected def set(gtype : LibVips::GType, match_image : Image?, name : String, value)
      # If the object wants an image and we have a constant, Imageize it.
      #
      # If the objects wants an image array, Imageize any constants in the array
      if (image = match_image)
        if gtype == GValue::VImageType
          value = Image.imageize(image, value)
        elsif gtype == GValue::VArrayImage
          raise VipsException.new("unsupported value type #{typeof(value)} for VipsArrayImage") unless value.is_a?(Array)
          # value = Array(Image).new(value.size) {|i| Image.imageize(match_image, i)}
          images = Array(Image).new(value.size)
          value.each do |v|
            images << Image.imageize(match_image, v)
          end
          value = images
        end
      end
      set(gtype, name, value)
    end

    # Lookup the set of flags for this operation
    def flags
      LibVips.vips_operation_get_flags(self)
    end

    def self.call(operation_name : String, kwargs : Optional?, match_image : Image?, *args)
      # pull out the special string_options kwarg
      str_options = kwargs.try &.delete("string_options").try &.as_s
      intro = Introspect.get(operation_name)
      if intro.required_input.size != args.size
        raise VipsException.new("unable to call #{operation_name}: #{args.size} arguments given, but #{intro.required_input.size} required")
      end

      if !intro.mutable && match_image.is_a?(MutableImage)
        raise VipsException.new("unable to call #{operation_name}: operation must be mutable")
      end

      begin
        op = new(operation_name)
        # set any string options before any args so they can't be overriden
        if (stropt = str_options) && !op.set(stropt)
          raise VipsException.new("unable to call #{operation_name}")
        end

        # set all required inputs
        if (mi = match_image) && (mx = intro.member_x?)
          op.set(mx.type, mx.name, mi)
        end

        intro.required_input.each_with_index { |arg, i| op.set(arg.type, match_image, arg.name, args[i]) }

        # Set all optional inputs, if any
        if (kw = kwargs)
          kw.each do |key, val|
            if (arg = intro.optional_input[key]?)
              op.set(arg.type, match_image, key, val)
            elsif !intro.optional_output.has_key?(key)
              raise VipsException.new("#{operation_name} does not support optional argument: #{key}")
            end
          end
        end
      end

      # build operation
      vop = build(op)
      results = Array(Type).new(intro.required_output.size)
      begin
        # get all required results
        intro.required_output.each { |oarg| results << vop.get(oarg.name) }

        # fetch optional output args, if any
        if (kw = kwargs)
          optarg = Optional.new
          kw.each do |k, _|
            if intro.optional_output.has_key?(k)
              optarg[k] = vop.get(k)
            end
          end
          unless optarg.empty?
            results << Type.new(optarg)
          end

          LibVips.vips_object_unref_outputs(op.to_obj)
        end

        results.size == 1 ? results.first : results
      end
    end

    def self.call(operation_name : String, kwargs : Optional, *args)
      call(operation_name, kwargs, nil, *args)
    end

    def self.call(operation_name : String, *args)
      call(operation_name, nil, nil, *args)
    end

    # :nodoc:
    def to_unsafe
      @ophandle
    end

    def to_obj
      @ohandle
    end
  end
end
