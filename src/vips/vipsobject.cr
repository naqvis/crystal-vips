module Vips
  class VipsObject < GObject
    protected def initialize(@ohandle : LibVips::VipsObject*)
      super(@ohandle.as(LibVips::GObject*))
    end

    def post_close(&block : ->)
      signal_connect("postclose", block)
    end

    # Print a table of all active libvips objects. Handy for debugging.
    def print_all
      LibVips.vips_object_print_all
    end

    def get_pspec(name : String) : LibVips::GParamSpec?
      ret = LibVips.vips_object_get_argument(@ohandle, name, out pspec, out _, out _)
      ret != 0 ? nil : pspec.value
    end

    # Returns a GObject property
    def get(name : String)
      pspec = get_pspec(name)
      raise VipsException.new("Property not found") if pspec.nil?
      gtype = pspec.value_type
      gv = GValue.new
      gv.set_type(gtype)

      get(name, gv)
    end

    # Set a GObject property. Value is converted to the property type, if possible.
    def set(gtype, name, value)
      gv = GValue.new
      gv.set_type(gtype)
      gv.set(value)

      set(name, gv)
    end

    # Set a series of properties using a String
    def set(options : String)
      LibVips.vips_object_set_from_string(@ohandle, options) == 0
    end

    # Get the GType of a GObject property
    def get_typeof(name : String)
      if pspec = get_pspec(name)
        pspec.value_type
      else
        # need to clear any error, this is horrible
        Vips.clear_error
        nil
      end
    end

    # Get the blurb for a GObject property.
    def get_blurb(name : String)
      pspec = get_pspec(name)
      return "" if pspec.nil?
      String.new(LibVips.g_param_spec_get_blurb(pspec))
    end

    # Get the description of a GObject.
    def get_description
      String.new(LibVips.vips_object_get_description(@ohandle))
    end

    # :nodoc:
    def to_unsafe
      @ohandle
    end
  end
end
