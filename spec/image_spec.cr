require "./spec_helper"

describe Vips::Image do
  it "can save an image to a file" do
    filename = timg("x.v")

    image = Vips::Image.black(16, 16) + 128
    image.write_to_file(filename)

    File.exists?(filename).should be_true
  end

  it "can load an image from a file" do
    filename = timg("x.v")

    image = Vips::Image.black(16, 16) + 128
    image.write_to_file(filename)

    x = Vips::Image.new_from_file(filename)

    x.width.should eq(16)
    x.height.should eq(16)
    x.bands.should eq(1)
  end

  it "can load an image from memory" do
    image = Vips::Image.new_from_file(simg("wagon.jpg")) # Vips::Image.black(16,16) + 128
    data = image.write_to_bytes

    x = Vips::Image.new_from_memory(data, image.width, image.height, image.bands, image.format)

    image.width.should eq(685)
    image.height.should eq(478)
    image.bands.should eq(3)
    (image.avg - 109.789).should be <= 0.001
  end

  it "can load an image from memory by size aware address pointer" do
    image = Vips::Image.black(16, 16) + 128
    data, size = image.write_to_memory

    x = Vips::Image.new_from_memory_copy(data, size, image.width, image.height, image.bands, image.format)

    x.width.should eq(16)
    x.height.should eq(16)
    x.bands.should eq(1)
    x.avg.should eq(128)
  end

  if have_jpeg?
    it "can save an image to buffer" do
      image = Vips::Image.black(16, 16) + 128
      buffer = image.write_to_buffer("%.jpg")
      buffer.size.should be > 100
    end

    it "can load an image from a buffer" do
      image = Vips::Image.black(16, 16) + 128
      buffer = image.write_to_buffer("%.jpg")
      x = Vips::Image.new_from_buffer(buffer)
      x.width.should eq(16)
      x.height.should eq(16)
    end

    it "can load a sample jpg image file" do
      image = Vips::Image.new_from_file(simg("wagon.jpg"))
      image.width.should eq(685)
      image.height.should eq(478)
      image.bands.should eq(3)
      (image.avg - 109.789).should be <= 0.001
    end

    it "can load a sample jpg image buffer" do
      str = File.read(simg("wagon.jpg"))
      image = Vips::Image.new_from_buffer(str)
      image.width.should eq(685)
      image.height.should eq(478)
      image.bands.should eq(3)
      (image.avg - 109.789).should be <= 0.001
    end

    it "can extract an ICC profile from a jpg image" do
      image = Vips::Image.new_from_file(simg("icc.jpg"))
      image.width.should eq(2800)
      image.height.should eq(2100)
      image.bands.should eq(3)
      (image.avg - 109.189).should be <= 0.001

      profile = image.get("icc-profile-data").as_bytes
      profile.size.should eq(2360)
    end

    if Vips.at_least_libvips?(8, 10)
      it "can set an ICC profile on a jpg image" do
        image = Vips::Image.new_from_file(simg("icc.jpg"))
        profile = File.read(simg("lcd.icc"))
        image = image.copy
        image = image.mutate { |x| x.set("icc-profile-data", profile) }
        filename = timg("x.jpg")
        image.write_to_file(filename)

        image = Vips::Image.new_from_file(filename)

        image.width.should eq(2800)
        image.height.should eq(2100)
        image.bands.should eq(3)
        (image.avg - 109.189).should be <= 0.001

        profile = image.get("icc-profile-data").as_bytes
        profile.size.should eq(3048)
      end
    end

    it "works with arguments containing -" do
      image = Vips::Image.black(16, 16) + 128
      buffer = image.write_to_buffer("%.jpg", optimize_coding: true)
      buffer.size.should be > 100
    end

    it "can read exif tags" do
      x = Vips::Image.new_from_file(simg("huge.jpg"))
      orientation = x.get("exif-ifd0-Orientation").as_s

      orientation.size.should be > 20
      orientation.split[0].should eq("1")
    end
  end

  it "can make an image from a 2d array" do
    image = Vips::Image.new_from_array([[1, 2], [3, 4]])
    image.width.should eq(2)
    image.height.should eq(2)
    image.bands.should eq(1)
    image.avg.should eq(2.5)
  end

  it "can make an image from a 1d array" do
    image = Vips::Image.new_from_array([1, 2])
    image.width.should eq(2)
    image.height.should eq(1)
    image.bands.should eq(1)
    image.avg.should eq(1.5)
  end

  it "can use array consts for image args" do
    r = Vips::Image.black(16, 16)
    r = r.mutate { |i| i.draw_rect([255.0], 10, 12, 1, 1) }
    g = Vips::Image.black(16, 16)
    g = g.mutate { |i| i.draw_rect([255.0], 10, 11, 1, 1) }
    b = Vips::Image.black(16, 16)
    b = b.mutate { |i| i.draw_rect([255.0], 10, 10, 1, 1) }
    im = r.bandjoin(g, b)

    im.width.should eq(16)
    im.height.should eq(16)
    im.bands.should eq(3)

    im = im.conv(Vips::Image.new_from_array([
      [0.11, 0.11, 0.11],
      [0.11, 0.11, 0.11],
      [0.11, 0.11, 0.11],
    ]), precision: Vips::Enums::Precision::Float)

    im.width.should eq(16)
    im.height.should eq(16)
    im.bands.should eq(3)
  end

  it "can set scale and offset on a convolution mask" do
    im = Vips::Image.new_from_array([1, 2], 8, 2)
    im.width.should eq(2)
    im.height.should eq(1)
    im.bands.should eq(1)
    if im.contains("scale") && im.contains("offset")
      im.scale.should eq(8)
      im.offset.should eq(2)
    end
    im.avg.should eq(1.5)
  end

  it "supports imagescale" do
    im = Vips::Image.new_from_array([1, 2], 8, 2)
    im = im.scaleimage
    im.width.should eq(2)
    im.height.should eq(1)
    im.max[0].should eq(255)
    im.min[0].should eq(0)
  end

  it "has binary arithmetic operator overloads with constants" do
    image = Vips::Image.black(16, 16) + 128

    image += 128
    image -= 128
    image *= 2
    image /= 2
    image %= 100
    image += 100
    image **= 2
    image <<= 1
    image >>= 1
    image |= 64
    image &= 32
    image ^= 128

    image.avg.should eq(128)
  end

  it "has binary arithmetic operator overloads with array constants" do
    image = Vips::Image.black(16, 16, bands: 3) + 128

    image += [128, 0, 0]
    image -= [128, 0, 0]
    image *= [2, 1, 1]
    image /= [2, 1, 1]
    image %= [100, 99, 98]
    image += [100, 99, 98]
    image **= [2, 3, 4]
    image **= [1.0 / 2.0, 1.0 / 3.0, 1.0 / 4.0]
    image <<= [1, 2, 3]
    image >>= [1, 2, 3]
    image |= [64, 128, 256]
    image &= [64, 128, 256]
    image ^= [64 + 128, 0, 256 + 128]

    image.avg.should eq(128)
  end

  it "has binary arithmetic operator overloads with image args" do
    image = Vips::Image.black(16, 16, bands: 3) + 128
    x = image

    x += image
    x -= image
    x *= image
    x /= image
    x %= image
    x += image
    x |= image
    x &= image
    x ^= image

    x.avg.should eq(0)
  end

  it "has relational operator overloads with constants" do
    image = Vips::Image.black(16, 16, bands: 3) + 128

    (image > 128).avg.should eq(0)
    (image >= 128).avg.should eq(255)
    (image < 128).avg.should eq(0)
    (image <= 128).avg.should eq(255)
    (image == 128).avg.should eq(255)
    (image != 128).avg.should eq(0)
  end

  it "has relational operator overloads with array constants" do
    image = Vips::Image.black(16, 16, bands: 3) + [100, 128, 130]

    (image > [100, 128, 130]).avg.should eq(0)
    (image >= [100, 128, 130]).avg.should eq(255)
    (image < [100, 128, 130]).avg.should eq(0)
    (image <= [100, 128, 130]).avg.should eq(255)
    (image == [100, 128, 130]).avg.should eq(255)
    (image != [100, 128, 130]).avg.should eq(0)
  end

  it "has relational operator overloads with image args" do
    image = Vips::Image.black(16, 16) + 128

    (image > image).avg.should eq(0)
    (image >= image).avg.should eq(255)
    (image < image).avg.should eq(0)
    (image <= image).avg.should eq(255)
    (image == image).avg.should eq(255)
    (image != image).avg.should eq(0)
  end

  it "has band extract with numeric arg" do
    image = Vips::Image.black(16, 16, bands: 3) + [100, 128, 130]
    x = image[1]

    x.width.should eq(16)
    x.height.should eq(16)
    x.bands.should eq(1)
    x.avg.should eq(128)
  end

  it "has band extract with range arg" do
    image = Vips::Image.black(16, 16, bands: 3) + [100, 128, 130]
    x = image[1..2]

    x.width.should eq(16)
    x.height.should eq(16)
    x.bands.should eq(2)
    x.avg.should eq(129)
  end

  it "has rounding members" do
    image = Vips::Image.black(16, 16) + 0.500001

    image.floor.avg.should eq(0)
    image.ceil.avg.should eq(1)
    image.rint.should eq(1)
  end

  it "has bandsplit and bandjoin" do
    image = Vips::Image.black(16, 16, bands: 3) + [100, 128, 130]

    split = image.bandsplit
    x = split[0].bandjoin(split[1..2])

    x[0].avg.should eq(100)
    x[1].avg.should eq(128)
    x[2].avg.should eq(130)
  end

  it "can bandjoin constants" do
    image = Vips::Image.black(16, 16, bands: 3) + [100, 128, 130]

    x = image.bandjoin(255)

    x[0].avg.should eq(100)
    x[1].avg.should eq(128)
    x[2].avg.should eq(130)
    x[3].avg.should eq(255)
    x.bands.should eq(4)

    x = image.bandjoin(1, 2)
    x[0].avg.should eq(100)
    x[1].avg.should eq(128)
    x[2].avg.should eq(130)
    x[3].avg.should eq(1)
    x[4].avg.should eq(2)
    x.bands.should eq(5)
  end

  if Vips.at_least_libvips?(8, 6)
    it "can composite" do
      image = Vips::Image.black(16, 16, bands: 3) + [100, 128, 130]
      image = image.copy(interpretation: Vips::Enums::Interpretation::Srgb)
      base = image + 10
      overlay = image.bandjoin(128)
      comb = base.composite(overlay, Vips::Enums::BlendMode::Over)
      pixel = comb[0, 0]

      (105 - pixel[0]).should be <= 0.1
      (133 - pixel[1]).should be <= 0.1
      (135 - pixel[2]).should be <= 0.1
      pixel[3].should eq(255)
    end

    it "can add_alpha" do
      x = Vips::Image.new_from_file(simg("no_alpha.png"))
      x.has_alpha?.should be_false

      y = x.add_alpha
      y.has_alpha?.should be_true
    end
  end

  it "has minpos/maxpos" do
    image = Vips::Image.black(16, 16) + 128
    image = image.mutate { |x| x.draw_rect([255.0], 10, 12, 1, 1) }
    v, x, y = image.maxpos

    v.should eq(255)
    x.should eq(10)
    y.should eq(12)

    image = Vips::Image.black(16, 16) + 128
    image = image.mutate { |x| x.draw_rect([12.0], 10, 12, 1, 1) }
    v, x, y = image.minpos

    v.should eq(12)
    x.should eq(10)
    y.should eq(12)
  end

  it "can form complex images" do
    r = Vips::Image.black(16, 16) + 128
    i = image = Vips::Image.black(16, 16) + 12
    cmplx = r.complexform(i)
    re = cmplx.real
    im = cmplx.imag

    re.avg.should eq(128)
    im.avg.should eq(12)
  end

  it "can convert complex polar <-> rectangular" do
    r = Vips::Image.black(16, 16) + 128
    i = Vips::Image.black(16, 16) + 12
    cmplx = r.complexform(i)

    cmplx = cmplx.rect.polar

    (128 - cmplx.real.avg).should be <= 0.01
    (12 - cmplx.imag.avg).should be <= 0.01
  end

  it "can take complex conjugate" do
    r = Vips::Image.black(16, 16) + 128
    i = Vips::Image.black(16, 16) + 12
    cmplx = r.complexform(i)

    cmplx = cmplx.conj

    (128 - cmplx.real.avg).should be <= 0.001
    (-12 - cmplx.imag.avg).should be <= 0.001
  end

  it "has working trig functions" do
    image = Vips::Image.black(16, 16) + 67

    image = image.sin.cos.tan
    image = image.atan.acos.asin

    (67 - image.avg).should be <= 0.01
  end

  it "has working log functions" do
    image = Vips::Image.black(16, 16) + 67

    image = image.log.exp.log10.exp10

    (67 - image.avg).should be <= 0.01
  end

  it "can flip" do
    a = Vips::Image.black(16, 16)
    a = a.mutate { |x| x.draw_rect([255.0], 10, 12, 1, 1) }
    b = Vips::Image.black(16, 16)
    b = b.mutate { |x| x.draw_rect([255.0], 15 - 10, 12, 1, 1) }

    (a - b.fliphor).abs.max[0].should eq(0.0)

    a = Vips::Image.black(16, 16)
    a = a.mutate { |x| x.draw_rect([255.0], 10, 15 - 12, 1, 1) }
    b = Vips::Image.black(16, 16)
    b = b.mutate { |x| x.draw_rect([255.0], 10, 12, 1, 1) }

    (a - b.flipver).abs.max[0].should eq(0.0)
  end

  it "can getpoint" do
    a = Vips::Image.black(16, 16)
    a = a.mutate { |x| x.draw_rect([255.0], 10, 12, 1, 1) }
    b = Vips::Image.black(16, 16)
    b = b.mutate { |x| x.draw_rect([255.0], 10, 10, 1, 1) }
    im = a.bandjoin(b)

    im[10, 12].should eq([255, 0])
    im[10, 10].should eq([0, 255])
  end

  it "can median" do
    a = Vips::Image.black(16, 16)
    a = a.mutate { |x| x.draw_rect([255.0], 10, 12, 1, 1) }
    im = a.median

    im.max[0].should eq(0)
  end

  it "can erode" do
    a = Vips::Image.black(16, 16)
    a = a.mutate { |x| x.draw_rect([255.0], 10, 12, 1, 1) }
    mask = Vips::Image.new_from_array([
      [128, 255, 128],
      [255, 255, 255],
      [128, 255, 128],
    ])
    im = a.erode(mask)

    im.max[0].should eq(0)
  end

  it "can dilate" do
    a = Vips::Image.black(16, 16)
    a = a.mutate { |x| x.draw_rect([255.0], 10, 12, 1, 1) }
    mask = Vips::Image.new_from_array([
      [128, 255, 128],
      [255, 255, 255],
      [128, 255, 128],
    ])
    im = a.dilate(mask)

    im[10, 12].should eq([255])
    im[11, 12].should eq([255])
    im[12, 12].should eq([0])
  end

  it "can rot" do
    a = Vips::Image.black(16, 16)
    a = a.mutate { |x| x.draw_rect([255.0], 10, 12, 1, 1) }

    im = a.rot90.rot90.rot90.rot90
    (a - im).abs.max[0].should eq(0)

    im = a.rot180.rot180
    (a - im).abs.max[0].should eq(0)

    im = a.rot270.rot270.rot270.rot270
    (a - im).abs.max[0].should eq(0)
  end

  it "can bandbool" do
    a = Vips::Image.black(16, 16)
    a = a.mutate { |x| x.draw_rect([255.0], 10, 12, 1, 1) }
    b = Vips::Image.black(16, 16)
    b = b.mutate { |x| x.draw_rect([255.0], 10, 10, 1, 1) }
    im = a.bandjoin(b)

    im.bandand[10, 12].should eq([0])
    im.bandor[10, 12].should eq([255])
    im.bandeor[10, 12].should eq([255])
  end

  it "ifthenelse with image arguments" do
    image = Vips::Image.black(16, 16)
    image = image.mutate { |x| x.draw_rect([255.0], 10, 12, 1, 1) }
    black = Vips::Image.black(16, 16)
    white = Vips::Image.black(16, 16) + 255

    result = image.ifthenelse(black, white)

    v, x, y = result.minpos

    v.should eq(0)
    x.should eq(10)
    y.should eq(12)
  end

  it "ifthenelse with vector arguments" do
    image = Vips::Image.black(16, 16)
    image = image.mutate { |x| x.draw_rect([255.0], 10, 12, 1, 1) }
    white = Vips::Image.black(16, 16) + 255

    result = image.ifthenelse([255, 0, 0], white)

    v, x, y = result.minpos

    v.should eq(0)
    x.should eq(10)
    y.should eq(12)
  end

  it "has a #size method" do
    image = Vips::Image.black(200, 100)
    image.size.should eq([image.width, image.height])
  end

  it "has a #new_from_image method" do
    image = Vips::Image.black(200, 100)

    image2 = image.new_from_image(12)
    image2.bands.should eq(1)
    image2.avg.should eq(12)

    image2 = image.new_from_image(1, 2, 3)
    image2.bands.should eq(3)
    image2.avg.should eq(2)
  end

  it "can make interpolate objects" do
    Vips::Interpolate.new_from_name("bilinear")
  end

  it "can call affine with a non-default interpolator" do
    image = Vips::Image.black(200, 100)
    inter = Vips::Interpolate.new_from_name("bilinear")
    result = image.affine([2.0, 0.0, 0.0, 2.0], interpolate: inter)

    result.width.should eq(400)
    result.height.should eq(200)
  end

  if Vips.at_least_libvips?(8, 5)
    it "can read field names" do
      x = Vips::Image.black(100, 100)
      y = x.get_fields

      y.size.should be > 10
      y[0].should eq("width")
    end
  end

  it "can has_alpha?" do
    x = Vips::Image.new_from_file(simg("alpha.png"))
    x.has_alpha?.should be_true
  end

  if Vips.at_least_libvips?(8, 10)
    it "test colourspace" do
      test = Vips::Image.black(100, 100) + [50, 0, 0, 42]
      test = test.copy(interpretation: Vips::Enums::Interpretation::Lab)
      colourspaces = [Vips::Enums::Interpretation::Xyz,
                      Vips::Enums::Interpretation::Lab,
                      Vips::Enums::Interpretation::Lch,
                      Vips::Enums::Interpretation::Cmc,
                      Vips::Enums::Interpretation::Labs,
                      Vips::Enums::Interpretation::Scrgb,
                      Vips::Enums::Interpretation::Hsv,
                      Vips::Enums::Interpretation::Srgb,
                      Vips::Enums::Interpretation::Yxy]

      im = test
      colourspaces.concat([Vips::Enums::Interpretation::Lab]).each do |col|
        im = im.colourspace(col)
        col.should eq(im.interpretation)
        (0...4).each do |i|
          im[i].min[0].should eq(im[i].max[0])
        end
        pixel = im[10, 10]
        pixel[3].should eq(42)
      end

      # alpha won't be equal for RGB16, but it should be preserved if we go
      # there and back
      im = im.colourspace(Vips::Enums::Interpretation::Rgb16)
      im = im.colourspace(Vips::Enums::Interpretation::Lab)

      before = test[10, 10]
      after = im[10, 10]
      before.each_with_index do |v, i|
        (v - after[i]).should be <= 0.1
      end

      # go between every pair of color spaces
      colourspaces.each do |s|
        colourspaces.each do |e|
          im = test.colourspace(s)
          im2 = im.colourspace(e)
          im3 = im2.colourspace(Vips::Enums::Interpretation::Lab)

          before = test[10, 10]
          after = im3[10, 10]
          before.each_with_index do |v, i|
            (v - after[i]).should be <= 0.1
          end
        end
      end

      # test Lab->XYZ on mid-grey
      # checked against http://www.brucelindbloom.com
      im = test.colourspace(Vips::Enums::Interpretation::Xyz)
      after = im[10, 10]
      [17.5064, 18.4187, 20.0547, 42.0].each_with_index do |v, i|
        (v - after[i]).should be <= 0.1
      end

      # grey->colour->grey should be equal
      [Vips::Enums::Interpretation::Bw].each do |mono|
        test_grey = test.colourspace(mono)
        im = test_grey
        colourspaces.concat([mono]).each do |col|
          im = im.colourspace(col)
          col.should eq(im.interpretation)
        end

        pixel_before = test_grey[10, 10]
        alpha_before = pixel_before[1]
        pixel_after = im[10, 10]
        alpha_after = pixel_after[1]

        (alpha_after - alpha_before).abs.should be < 1

        # GREY16 can wind up rather different due to rounding but 8-bit we should hit exactly
        (pixel_after[0] - pixel_before[0]).abs.should be < (mono == Vips::Enums::Interpretation::Grey16 ? 30 : 1)
      end
    end
  end

  it "test hist_cum" do
    im = Vips::Image.identity
    sum = im.avg * 256
    cum = im.hist_cum

    p = cum[255, 0]
    sum.should eq(p[0])
  end

  it "test hist_equal" do
    im = Vips::Image.new_from_file(simg("wagon.jpg"))
    im2 = im.hist_equal

    im.width.should eq(im2.width)
    im.height.should eq(im2.height)

    im.avg.should be < im2.avg
    im.deviate.should be < im2.deviate
  end

  it "test hist_ismonotonic" do
    im = Vips::Image.identity
    im.hist_ismonotonic.should be_true
  end

  it "test hist_local" do
    im = Vips::Image.new_from_file(simg("wagon.jpg"))
    im2 = im.hist_local(10, 10)

    im.width.should eq(im2.width)
    im.height.should eq(im2.height)

    im.avg.should be < im2.avg
    im.deviate.should be < im2.deviate

    if Vips.at_least_libvips?(8, 5)
      im3 = im.hist_local(10, 10, max_slope: 3)
      im.width.should eq(im3.width)
      im.height.should eq(im3.height)

      im3.deviate.should be < im2.deviate
    end
  end

  it "test hist_match" do
    im = Vips::Image.identity
    im2 = Vips::Image.identity

    matched = im.hist_match(im2)

    (im - matched).abs.max[0].should eq(0.0)
  end

  it "test hist_norm" do
    im = Vips::Image.identity
    im2 = im.hist_norm
    (im - im2).abs.max[0].should eq(0.0)
  end

  it "test hist_plot" do
    im = Vips::Image.identity
    im2 = im.hist_plot

    im2.width.should eq(256)
    im2.height.should eq(256)
    im2.format.should eq(Vips::Enums::BandFormat::Uchar)
    im2.bands.should eq(1)
  end

  it "test hist_map" do
    im = Vips::Image.identity
    im2 = im.maplut(im)
    (im - im2).abs.max[0].should eq(0.0)
  end

  it "test percent" do
    im = Vips::Image.new_from_file(simg("wagon.jpg"))[1]
    pc = im.percent(90)

    msk = im <= pc
    nset = (msk.avg * msk.width * msk.height) / 255.0
    pcset = 100 * nset / (msk.width * msk.height)

    (pcset - 90).abs.should be < 1
  end
end
