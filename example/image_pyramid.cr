require "../src/vips"

# Image Pyramid

if ARGV.size < 2
  puts "Usage: #{__FILE__} input_image output"
  exit(1)
end

TileSize = 50

im = Vips::Image.new_from_file(ARGV[0], access: Vips::Enums::Access::Sequential)
test = im.replicate(TileSize, TileSize)

im.set_progress { |v| puts "#{v}% complete" }
test.dzsave(ARGV[1])
