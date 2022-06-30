require "../src/vips"

# Leak test

if ARGV.size < 1
  puts "Usage: #{__FILE__} input_image"
  exit(1)
end

# Load from memory buffer 10000 times.
Vips.leak = true
Vips::Cache.max = 0

data = File.read(ARGV[0]).to_slice

(1..10000).each { |_|
  img = Vips::Image.new_from_buffer(data)
  puts "memory processing #{img}"
}
