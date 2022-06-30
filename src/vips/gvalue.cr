module Vips
  # Class to wrap `LibVips::GValue` in a Crystal class.
  # This class wraps `LibVips::GValue` in a convenient interface. You can use
  # instances of this class to get and set `GObject` properties.
  # On construction, `LibVips::GValue` is all zero (empty). You can pass it to
  # a get function to have it filled by `GObject`, or use `initialize(gvalue)` to
  # set a type, `set` to set a value, then use it to set an object property.
  class GValue
    @value : LibVips::GValue

    # Initialize new instance of `GValue`
    def initialize
      @value = LibVips::GValue.new
      @initialized = false
    end

    # Initialize new instance with specified `GValue`
    def initialize(value : GValue)
      @value = value.@value
      @initialized = false
    end

    # Set the type of a GValue
    # GValues have a set type, fixed at creation time. Use this method to set
    # the type of GValue before assiging to it.
    #
    # GTypes are 32 or 64-bit integers (depending on platform).
    def set_type(type) : Nil
      LibVips.g_value_init(self, type)
      @initialized = true
    end

    # Set a GValue
    # The value is converted to the type of the GValue, if possible, and assigned
    def set(value)
      gtype = get_type
      fundamental = Vips.fundamental_type(gtype)
      if value.is_a?(Type)
        value = value.value
      end
      if gtype == GBool
        LibVips.g_value_set_boolean(self, (value ? 1 : 0))
      elsif gtype == GInt
        LibVips.g_value_set_int(self, Converter.to_i32(value))
      elsif gtype == GUint64
        LibVips.g_value_set_uint64(self, Converter.to_u64(value))
      elsif gtype == GDouble
        LibVips.g_value_set_double(self, Converter.to_double(value))
      elsif fundamental == GEnum
        LibVips.g_value_set_enum(self, Converter.to_i32(value))
      elsif fundamental == GFlags
        LibVips.g_value_set_flags(self, Converter.to_u32(value))
      elsif gtype == GString
        LibVips.g_value_set_string(self, Converter.to_string(value))
      elsif gtype == VRefStr
        LibVips.vips_value_set_ref_string(self, Converter.to_string(value))
      elsif fundamental == GObject && (obj = value.as?(Vips::GObject))
        LibVips.g_value_set_object(self, obj.handle)
      elsif gtype == VArrayInt
        aval = value.is_a?(Array) ? value : [value]
        intarr = case aval
                 when Array(Int32) then aval
                 when Array        then Array(Int32).new(aval.size) { |i| Converter.to_i32(aval[i]) }
                 else
                   raise VipsException.new("unsuported value type #{typeof(value)} for gtype #{Vips.typename(gtype)} ")
                 end
        LibVips.vips_value_set_array_int(self, intarr, intarr.size)
      elsif gtype == VArrayDouble
        aval = value.is_a?(Array) ? value : [value]
        intarr = case aval
                 when Array(Float64) then aval
                 when Array          then Array(Float64).new(aval.size) { |i| Converter.to_double(aval[i]) }
                 else
                   raise VipsException.new("unsuported value type #{typeof(value)} for gtype #{Vips.typename(gtype)} ")
                 end
        LibVips.vips_value_set_array_double(self, intarr, intarr.size)
      elsif gtype == VArrayImage && (images = value.as?(Array(Image)))
        size = images.size
        LibVips.vips_value_set_array_image(self, size)
        ptr = LibVips.vips_value_get_array_image(self, out _)
        ptr.map_with_index!(size) { |_, i| images[i].object_ref.as(LibVips::VipsImage*) }
      elsif gtype == VBlob && (blob = value.as?(VipsBlob))
        LibVips.g_value_set_boxed(self, blob)
      elsif gtype == VBlob
        mem = case value
              when String      then value.to_slice
              when Array(Char) then String.new(value).to_slice
              when Bytes       then value
              else
                raise VipsException.new("unsuported value type #{typeof(value)} for gtype #{Vips.typename(gtype)} ")
              end
        # We need to set the blob to a copy of the string that vips can own
        ptr = LibVips.g_malloc(mem.size)
        ptr.copy_from(mem.to_unsafe.as(Void*), mem.size)

        if Vips.at_least_libvips?(8, 6)
          LibVips.vips_value_set_blob_free(self, ptr, mem.size)
        else
          free = LibVips::VipsCallbackFn.new do |a, b|
            LibVips.g_free(a)
            0
          end

          LibVips.vips_value_set_blob(self, free, ptr, mem.size)
        end
      else
        raise VipsException.new("unsupported gtype for set #{Vips.typename(gtype)}, fundamental #{Vips.typename(fundamental)}, value type #{typeof(value)}")
      end
    end

    # Get the contents of a GValue
    # The contents of the GValue are read out as a Crystal type
    def get : Type
      gtype = get_type
      fundamental = Vips.fundamental_type(gtype)
      result =
        if gtype == GBool
          LibVips.g_value_get_boolean(self)
        elsif gtype == GInt
          LibVips.g_value_get_int(self)
        elsif gtype == GUint64
          LibVips.g_value_get_uint64(self)
        elsif gtype == GDouble
          LibVips.g_value_get_double(self)
        elsif fundamental == GEnum
          LibVips.g_value_get_enum(self)
        elsif fundamental == GFlags
          LibVips.g_value_get_flags(self)
        elsif gtype == GString
          String.new(LibVips.g_value_get_string(self) || Bytes.empty)
        elsif gtype == VRefStr
          res = LibVips.vips_value_get_ref_string(self, out size)
          String.new(res, size)
        elsif gtype == VImageType
          # g_value_get_object will not add a ref ... that is
          # held by the gvalue
          vi = LibVips.g_value_get_object(self)

          # we want a ref that will last with the life of the vi:
          # this ref is matched by the unref
          image = Image.new(vi.as(LibVips::VipsImage*))
          image.object_ref
          image
        elsif gtype == VArrayInt
          ptr = LibVips.vips_value_get_array_int(self, out vsize)
          Array(Int32).new(vsize) { |i| ptr[i] }
        elsif gtype == VArrayDouble
          ptr = LibVips.vips_value_get_array_double(self, out dsize)
          Array(Float64).new(dsize) { |i| ptr[i] }
        elsif gtype == VArrayImage
          ptr = LibVips.vips_value_get_array_image(self, out isize)
          Array(Image).new(isize) do |i|
            image = Image.new(ptr[i])
            image.object_ref
            image
          end
        elsif gtype == VBlob
          ptr = LibVips.vips_value_get_blob(self, out bsize)
          # Blob types are returned as an array of bytes.
          res = Bytes.new(bsize)
          res.to_unsafe.copy_from(ptr.as(UInt8*), bsize.to_i)
          res
        else
          raise VipsException.new("unsupported gtype for get #{Vips.typename(gtype)}, fundamental #{Vips.typename(fundamental)}")
        end
      Type.new(result)
    end

    # Get the GType of this GValue
    def get_type
      @value.g_type
    end

    # :nodoc:
    def finalize
      return unless @initialized
      LibVips.g_value_unset(self)
    end

    # :nodoc:
    def to_unsafe
      pointerof(@value)
    end

    # The fundamental type corresponding to gboolean
    GBool = Vips.type_from_name("gboolean")
    # The fundamental type corresponding to gint
    GInt = Vips.type_from_name("gint")
    # The fundamental type corresponding to guint64
    GUint64 = Vips.type_from_name("guint64")
    # The fundamental type from which all enumeration types are derived
    GEnum = Vips.type_from_name("GEnum")
    # The fundamental type from which all flags types are derived
    GFlags = Vips.type_from_name("GFlags")
    # The fundamental type corresponding to gdouble
    GDouble = Vips.type_from_name("gdouble")
    # The fundamental type corresponding to null-terminated C strings.
    GString = Vips.type_from_name("gchararray")
    # The fundamental type for GObject
    GObject = Vips.type_from_name("GObject")
    # The fundamental type for VipsImage
    VImageType = Vips.type_from_name("VipsImage")
    # The fundamental type for VipsArrayInt
    VArrayInt = Vips.type_from_name("VipsArrayInt")
    # The fundamental type for VipsArrayDouble
    VArrayDouble = Vips.type_from_name("VipsArrayDouble")
    # The fundamental type for VipsArrayImage
    VArrayImage = Vips.type_from_name("VipsArrayImage")
    # The fundamental type for VipsRefString
    VRefStr = Vips.type_from_name("VipsRefString")
    # The fundamental type for VipsBlob
    VBlob = Vips.type_from_name("VipsBlob")
    # The fundamental type for VipsBandFormat
    VBandFormat = LibVips.vips_band_format_get_type
    # The fundamental type for VipsBlendMode
    VBlendMode = Vips.at_least_libvips?(8, 6) ? LibVips.vips_blend_mode_get_type : 0
    # The fundamental type for VipsSource
    VSource = Vips.at_least_libvips?(8, 9) ? Vips.type_from_name("VipsSource") : 0
    # The fundamental type for VipsTarget
    VTarget = Vips.at_least_libvips?(8, 9) ? Vips.type_from_name("VipsTarget") : 0
  end

  # :nodoc:
  module Converter
    extend self

    def to_i32(value)
      if (v = value) && (v.responds_to?(:to_i))
        v.to_i
      else
        0
      end
    end

    def to_u32(value)
      if (v = value) && (v.responds_to?(:to_u32))
        v.to_u32
      else
        0_u32
      end
    end

    def to_u64(value)
      if (v = value) && (v.responds_to?(:to_u64))
        v.to_u64
      else
        0_u64
      end
    end

    def to_double(value)
      if (v = value) && (v.responds_to?(:to_f))
        v.to_f
      else
        0.0
      end
    end

    def to_string(value)
      if (v = value) && (v.responds_to?(:to_s))
        v.to_s
      else
        ""
      end
    end
  end
end
