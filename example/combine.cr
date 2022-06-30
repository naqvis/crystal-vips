require "../src/vips"

# Conversion
# Reference: https://github.com/libvips/lua-vips/blob/master/example/combine.lua

if ARGV.size < 3
  puts "Usage: #{__FILE__} input_image watermark_image output"
  exit(1)
end

LEFT = 100
TOP  = 100

im = Vips::Image.new_from_file(ARGV[0], access: Vips::Enums::Access::Sequential)
wm = Vips::Image.new_from_file(ARGV[1], access: Vips::Enums::Access::Sequential)

width = wm.width
height = wm.height

# extract related area from main image
base = im.crop(LEFT, TOP, width, height)

# composite the two areas using the PDF "over" mode
composite = base.composite(wm, Vips::Enums::BlendMode::Over)

# the result will have an alpha, and our base image does not .. we must flatten
# out the alpha before we can insert it back into a plain RGB JPG image
rgb = composite.flatten

# insert composite back in to main image on related area
combined = im.insert(rgb, LEFT, TOP)
combined.write_to_file(ARGV[2])
