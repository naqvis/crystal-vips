require "math"

module Vips
  class MutableImage < Image
    # :nodoc:
    getter image : Image

    protected def initialize(image : Image)
      # We take a copy of the regular Image to ensure we have an unshared
      # (unique) object. We forward things like #width and #height to this, and
      # it's the thing we return at the end of the mutate block.
      @image = image.copy
      super(@image.object_ref.as(LibVips::VipsImage*))
    end

    # Sets the type and value of an item of metadata. Any old item of the
    # same name is removed. See `GValue` for types
    def set(gtype : LibVips::GType, name : String, value)
      gv = GValue.new
      gv.set_type(gtype)
      gv.set(value)
      LibVips.vips_image_set(self, name, gv)
    end

    # Sets the value of an item of metadata. The metadata item must already exists
    def set(name : String, value)
      gtype = get_typeof(name)
      raise VipsException.new("metadata item #{name} does not exist - use the set(gtype,name,value) overload to create and set") if gtype == 0
      set(gtype, name, value)
    end

    # Remove a metadata item from an image.
    # named metadata item is removed
    def remove(name : String)
      LibVips.vips_image_remove(self, name)
    end

    # Use `[]` to set band elements on an image. For example
    #
    # ```
    # img = image.mutate { |x| x[1] = green }
    # ```
    # will change band 1 ( the middle band)
    def []=(index, value)
      nleft = Math.min(bands, Math.max(0, index))
      nright = Math.min(bands, Math.max(0, bands - 1 - i))
      offset = bands - nright
      left = nleft > 0 ? image.extract_band(0, n: nleft) : nil
      right = nright > 0 ? image.extract_band(offset, n: nright) : nil
      if left.nil?
        @image = value.bandjoin(right.not_nil!)
      elsif right.nil?
        @image = left.not_nil!.bandjoin(value)
      else
        image = left.not_nil!.bandjoin(value, right.not_nil!)
      end
    end

    def mutate
      yield self
      image
    end

    def to_s(io : IO)
      io << "<MutableImage #{width}x#{height} #{format}, #{bands} bands, #{interpretation}>"
    end
  end
end
