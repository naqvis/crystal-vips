require "./lib"

module Vips
  class VipsBlob
    def initialize(@handle : LibVips::VipsBlob*)
      @blob = @handle.value
    end

    def get_data
      data = LibVips.vips_blob_get(self, out size)
      {data, size}
    end

    def length
      @blob.area.length
    end

    def ref_count
      @blob.area.count
    end

    def release
      return if @handle.null?
      LibVips.vips_area_unref(Box.box(@blob.area))
    end

    def invalid?
      @handle.null?
    end

    # :nodoc:
    def to_unsafe
      @handle
    end
  end
end
