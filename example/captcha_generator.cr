require "../src/vips"

# Captcha generator
# Reference: https://github.com/libvips/libvips/issues/898

def wobble(image)
  # a warp image is a 2D grid containing the new coordinates of each pixel with
  # the new x in band 0 and the new y in band 1
  #
  # you can also use a complex image
  #
  # start from a low-res XY image and distort it

  xy = Vips::Image.xyz(image.width // 20, image.height // 20)
  x_distort = Vips::Image.gaussnoise(xy.width, xy.height)
  y_distort = Vips::Image.gaussnoise(xy.width, xy.height)
  xy += (x_distort.bandjoin(y_distort) / 150)
  xy = xy.resize(20)
  xy *= 20

  # apply the warp
  image.mapim(xy)
end

if ARGV.size < 2
  puts "Usage: #{__FILE__} outputfile text"
  exit(1)
end

text_layer = Vips::Image.black 1, 1
x_position = 0

ARGV[1].each_char do |c|
  if c.ascii_whitespace?
    x_position += 50
    next
  end

  letter, _ = Vips::Image.text(c.to_s, dpi: 600)

  image = letter.gravity(Vips::Enums::CompassDirection::Centre, letter.width + 50, letter.height + 50)

  # random scale and rotate
  image = image.similarity(scale: Random.rand(0.2) + 0.8,
    angle: Random.rand(40) - 20)

  # random wobble
  image = wobble(image)

  # random color
  color = (1..3).map { Random.rand(255) }
  image = image.ifthenelse(color, 0, true)

  # tag as 9-bit srgb
  image = image.copy(interpretation: Vips::Enums::Interpretation::Srgb).cast(Vips::Enums::BandFormat::Uchar)

  # position at our write position in the image
  image = image.embed(x_position, 0, image.width + x_position, image.height)

  text_layer += image
  text_layer = text_layer.cast(Vips::Enums::BandFormat::Uchar)

  x_position += letter.width
end

# remove any unused edges
text_layer = text_layer.crop(*text_layer.find_trim(background: 0))

# make an alpha for the text layer: just a mono version of the image, but scaled
# up so letters themeselves are not transparent
alpha = (text_layer.colourspace(Vips::Enums::Interpretation::Bw) * 3).cast(Vips::Enums::BandFormat::Uchar)
text_layer = text_layer.bandjoin(alpha)

# make a white background with random speckles
speckles = Vips::Image.gaussnoise(text_layer.width, text_layer.height, mean: 400, sigma: 200)
background = (1..3).reduce(speckles) do |a, _|
  a.bandjoin(Vips::Image.gaussnoise(text_layer.width, text_layer.height, mean: 400, sigma: 200))
    .copy(interpretation: Vips::Enums::Interpretation::Srgb).cast(Vips::Enums::BandFormat::Uchar)
end

# composite the text over the background
final = background.composite(text_layer, Vips::Enums::BlendMode::Over)
final.write_to_file ARGV[0]
