# CrystalVips

[![crystal-vips CI](https://github.com/naqvis/crystal-vips/actions/workflows/ci.yml/badge.svg)](https://github.com/naqvis/crystal-vips/actions/workflows/ci.yml)
[![Latest release](https://img.shields.io/github/release/naqvis/crystal-vips.svg)](https://github.com/naqvis/crystal-vips/releases)
[![Docs](https://img.shields.io/badge/docs-available-brightgreen.svg)](https://naqvis.github.io/crystal-vips/)

Provides Crystal language interface to the [libvips](https://github.com/libvips/libvips) image processing library.
Programs that use `CrystalVips` don't manipulate images directly, instead they create pipelines of image processing operations starting from a source image. When the pipe is connected to a destination, the whole pipeline executes at once and in parallel, streaming the image from source to destination in a set of small fragments.

Because `CrystalVips` is parallel, its' quick, and because it doesn't need to keep entire images in memory, its light. For example, the libvips speed and memory use benchmark:

[https://github.com/libvips/libvips/wiki/Speed-and-memory-use](https://github.com/libvips/libvips/wiki/Speed-and-memory-use)

## Pre-requisites

You need to [install the libvips
library](https://www.libvips.org/install.html). It's in the linux package managers, homebrew and MacPorts, and there are Windows binaries on the vips website. For example, on Debian:

```
sudo apt-get install --no-install-recommends libvips42
```

(`--no-install-recommends` stops Debian installing a *lot* of extra packages)

Or macOS:

```
brew install vips
```

## Installation

1. Add the dependency to your `shard.yml`:

   ```yaml
   dependencies:
     vips:
       github: naqvis/crystal-vips
   ```

2. Run `shards install`

## Usage

```crystal
require "vips"

im = Vips::Image.new_from_file("image.jpg")

# put im at position (100, 100) in a 3000 x 3000 pixel image, 
# make the other pixels in the image by mirroring im up / down / 
# left / right, see
# https://libvips.github.io/libvips/API/current/libvips-conversion.html#vips-embed
im = im.embed(100, 100, 3000, 3000, extend: Vips::Enums::Extend::Mirror)

# multiply the green (middle) band by 2, leave the other two alone
im *= [1, 2, 1]

# make an image from an array constant, convolve with it
mask = Vips::Image.new_from_array([
    [-1, -1, -1],
    [-1, 16, -1],
    [-1, -1, -1]], 8)
im = im.conv(mask, precision: Vips::Enums::Precision::Integer)

# finally, write the result back to a file on disk
im.write_to_file("output.jpg")
```

Refer to [samples](samples) folder for more samples

## Development

To run all tests:

```
crystal spec
```

# Getting more help

The libvips website has a handy table of [all the libvips
operators](http://libvips.github.io/libvips/API/current/func-list.html). Each
one links to the main API docs so you can see what you need to pass to it.

A simple way to see the arguments for an operation is to try running it
from the command-line. For example:

```bash
$ vips embed
embed an image in a larger image
usage:
   embed in out x y width height
where:
   in           - Input image, input VipsImage
   out          - Output image, output VipsImage
   x            - Left edge of input in output, input gint
			default: 0
			min: -1000000000, max: 1000000000
   y            - Top edge of input in output, input gint
			default: 0
			min: -1000000000, max: 1000000000
   width        - Image width in pixels, input gint
			default: 1
			min: 1, max: 1000000000
   height       - Image height in pixels, input gint
			default: 1
			min: 1, max: 1000000000
optional arguments:
   extend       - How to generate the extra pixels, input VipsExtend
			default: black
			allowed: black, copy, repeat, mirror, white, background
   background   - Color for background pixels, input VipsArrayDouble
operation flags: sequential 
```

## Contributing

1. Fork it (<https://github.com/naqvis/crystal-vips/fork>)
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create a new Pull Request

## Contributors

- [Ali Naqvi](https://github.com/naqvis) - creator and maintainer
