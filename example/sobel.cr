require "../src/vips"

# Edge detection

if ARGV.size < 2
  puts "Usage: #{__FILE__} input_image output"
  exit(1)
end

im = Vips::Image.new_from_file(ARGV[0], access: Vips::Enums::Access::Sequential)

# optionall, convert to greyscale
# mono = im.colourspace(Vips::Enums::Interpretation::Bw)

# Apply sobel operator
sobel = im.sobel

sobel.write_to_file(ARGV[1])
