require "../src/vips"

# Leak test

if ARGV.size < 1
  puts "Usage: #{__FILE__} output_image"
  exit(1)
end

im = Vips::Image.black(500, 500)
im = im.mutate do |x|
  (0..1).step 0.01 do |i|
    x.draw_line([255.0], (x.width * i).to_i, 0, 0, (x.height * (1 - i)).to_i)
  end
end
im.write_to_file(ARGV[0])
