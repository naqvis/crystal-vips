require "spec"
require "file"

# Set default concurrency so we can check against it later. Must be set
# before Vips.init sets concurrency to the default.
DEFAULT_VIPS_CONCURRENCY = 5
ENV["VIPS_CONCURRENCY"] = DEFAULT_VIPS_CONCURRENCY.to_s

# Disable stderr output since we purposefully trigger warn-able behavior.
ENV["VIPS_WARNING"] = "1"

require "../src/vips"

def simg(name)
  File.join(__DIR__, "samples", name)
end

def timg(name)
  File.tempname(name)
end

def have(name)
  Vips.typefind("VipsOperation", name) != 0
end

def have_jpeg?
  have("jpegload")
end
