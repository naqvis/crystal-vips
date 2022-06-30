require "../src/vips"

# Thumbnail

if ARGV.size < 2
  puts "Usage: #{__FILE__} input_image output"
  exit(1)
end

image = Vips::Image.thumbnail(ARGV[0], 300, height: 300)
image.write_to_file(ARGV[1])
