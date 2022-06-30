module Vips
  abstract class Connection < VipsObject
    protected def initialize(@chandle : LibVips::VipsConnection*)
      super(@chandle.as(LibVips::VipsObject*))
    end

    # Get the filename associated with a connection or nil if there is no associated file
    def filename : String?
      ptr = LibVips.vips_connection_filename(@chandle)
      ptr.null? ? nil : String.new(ptr)
    end

    # Make a human-readable name for a connection suitable for error messages
    def nick : String?
      ptr = LibVips.vips_connection_nick(@chandle)
      ptr.null? ? nil : String.new(ptr)
    end
  end
end
