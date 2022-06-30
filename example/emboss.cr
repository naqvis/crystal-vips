require "../src/vips"

# Emboss

if ARGV.size < 2
  puts "Usage: #{__FILE__} input_image output"
  exit(1)
end

im = Vips::Image.new_from_file(ARGV[0])

kernel1 = Vips::Image.new_from_array([
  [0, 1, 0],
  [0, 0, 0],
  [0, -1, 0],
], offset: 128)

kernel2 = Vips::Image.new_from_array([
  [1, 0, 0],
  [0, 0, 0],
  [0, 0, -1],
], offset: 128)

kernel3 = kernel1.rot270
kernel4 = kernel2.rot90

# Apply the emboss kernels
conv1 = im.conv(kernel1, precision: Vips::Enums::Precision::Float)
conv2 = im.conv(kernel2, precision: Vips::Enums::Precision::Float)
conv3 = im.conv(kernel3, precision: Vips::Enums::Precision::Float)
conv4 = im.conv(kernel4, precision: Vips::Enums::Precision::Float)

images = [conv1, conv2, conv3, conv4]
joined = Vips::Image.arrayjoin(images, across: 2)
joined.write_to_file(ARGV[1])
