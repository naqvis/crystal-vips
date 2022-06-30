module Vips
  # Make interpolators for operators like `Image#affine`
  class Interpolate < VipsObject
    private def initialize(@ihandle : LibVips::VipsInterpolate*)
      super(@ihandle.as(LibVips::VipsObject*))
    end

    # Make a new interpolator by name.
    # Make a new interpolator from the libvips class nickname. For example:
    #
    # ```
    # inter = Vips::Interpolate.new_from_name("bicubic")
    # ```
    # You can get a list of all supported interpolators from the command-line with
    #
    # ```sh
    # vips -l interpolate
    # ```
    # See for example `Image#affine`
    def self.new_from_name(name : String)
      vi = LibVips.vips_interpolate_new(name)
      raise VipsException.new("no such interpolator #{name}") if vi.null?
      new(vi)
    end

    # :nodoc:
    def to_unsafe
      @ihandle
    end
  end
end
