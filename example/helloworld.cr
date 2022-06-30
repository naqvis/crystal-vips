require "../src/vips"

# Conversion
# Reference: https://github.com/libvips/lua-vips/blob/master/example/hello-world.lua

if ARGV.size < 1
  puts "Usage: #{__FILE__} output_image"
  exit(1)
end

image, _ = Vips::Image.text("Hello <i>World!</i>", dpi: 300)
image.write_to_file(ARGV[0])
