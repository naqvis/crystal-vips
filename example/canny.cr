require "../src/vips"

# Edge detection

if ARGV.size < 2
  puts "Usage: #{__FILE__} input_image output"
  exit(1)
end

im = Vips::Image.new_from_file(ARGV[0], access: Vips::Enums::Access::Sequential)

# optionall convert to greyscale
# mono = im.colourspace(Vips::Enums::Interpretation::Bw)
# canny = mono.canny(sigma: 1.4, precision: Vips::Enums::Precision::Integer)

# Canny edge detector
canny = im.canny(sigma: 1.4, precision: Vips::Enums::Precision::Integer)

# Canny makes a float image, scale the output up to make it visible
scale = canny * 64

scale.write_to_file(ARGV[1])
