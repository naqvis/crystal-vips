require "./vips/lib"
require "./vips/vips"
require "./vips/gobject"
require "./vips/vipsobject"
require "./vips/gvalue"
require "./vips/operation"
require "./vips/introspect"
require "./vips/interpolate"
require "./vips/cache"
require "./vips/enums"
require "./vips/image"
require "./vips/mutableimage"
require "./vips/region"
require "./vips/vipsblob"
require "./vips/connection"
require "./vips/source"
require "./vips/target"
require "./vips/stats"
require "./vips/ext/**"

# Provides Crystal language interface to the [libvips](https://github.com/libvips/libvips) image processing library.
# Programs that use libvips don't manipulate images directly, instead they create pipelines of image processing
# operations starting from a source image. When the pipe is connected to a destination, the whole pipeline executes
# at once and in parallel, streaming the image from source to destination in a set of small fragments.
module Vips
  VERSION = "0.1.1"
end
