module Vips
  # Wrap libvips VipsRegion object.
  # A region is a small part of an image. You use regions to read pixels
  # out of images without storing the entire image in memory.
  # Note: At least libvips 8.8 is needed.
  class Region < VipsObject
    private def initialize(@rhandle : LibVips::VipsRegion*)
      super(@rhandle.as(LibVips::VipsObject*))
    end

    # Make a region on an image
    def self.new(image : Image)
      vi = LibVips.vips_region_new(image).tap do |ret|
        raise VipsException.new("unable to make region") if ret.null?
      end
      new(vi)
    end

    # width of pixels held by region
    def width : Int32
      LibVips.vips_region_width(self)
    end

    # height of pixels held by region
    def height : Int32
      LibVips.vips_region_height(self)
    end

    # Fetch an area of pixels.
    # *left* Left edge of area to fetch.
    # *top* Top edge of area to fetch.
    # *width* Width of area to fetch.
    # *height* Height of area to fetch.
    # Returns `Bytes` filled with pixel data.
    def fetch(left : Int32, top : Int32, width : Int32, height : Int32) : Bytes
      ptr = LibVips.vips_region_fetch(self, left, top, width, height, out size).tap do |ret|
        raise "unable to fetch from region" if ret.null?
      end

      result = Bytes.new(size)
      ptr.copy_to(result.to_unsafe, size)
      Vips.free(ptr.as(Void*))
      result
    end

    # :nodoc:
    def to_unsafe
      @rhandle
    end
  end
end
