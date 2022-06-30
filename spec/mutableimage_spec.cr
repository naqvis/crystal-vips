require "./spec_helper"

describe Vips::MutableImage do
  it "can draw circle" do
    im = Vips::Image.black(100, 100)
    im = im.mutate { |x| x.draw_circle([100.0], 50, 50, 25) }
    pixel = im[25, 50]
    pixel.size.should eq(1)
    pixel[0].should eq(100)
    pixel = im[26, 50]
    pixel.size.should eq(1)
    pixel[0].should eq(0)

    im = Vips::Image.black(100, 100)
    im = im.mutate { |x| x.draw_circle([100.0], 50, 50, 25, fill: true) }
    pixel = im[25, 50]
    pixel.size.should eq(1)
    pixel[0].should eq(100)
    pixel = im[26, 50]
    pixel.size.should eq(1)
    pixel[0].should eq(100)
    pixel = im[24, 50]
    pixel[0].should eq(0)
  end

  it "can draw flood" do
    im = Vips::Image.black(100, 100)
    im = im.mutate { |x|
      x.draw_circle([100.0], 50, 50, 25)
      x.draw_flood([100.0], 50, 50)
    }

    im2 = Vips::Image.black(100, 100)
    im2 = im2.mutate { |x| x.draw_circle([100.0], 50, 50, 25, fill: true) }

    diff = (im - im2).abs.max
    diff[0].should eq(0)
  end

  it "can draw image" do
    im = Vips::Image.black(100, 100)
    im = im.mutate { |x| x.draw_circle([100.0], 25, 25, 25, fill: true) }

    im2 = Vips::Image.black(100, 100)
    im2 = im2.mutate { |x| x.draw_image(im, 25, 25) }

    im3 = Vips::Image.black(100, 100)
    im3 = im3.mutate { |x| x.draw_circle([100.0], 50, 50, 25, fill: true) }

    diff = (im2 - im3).abs.max
    diff[0].should eq(0)
  end

  it "can draw line" do
    im = Vips::Image.black(100, 100)
    im = im.mutate { |x| x.draw_line([100.0], 0, 0, 100, 0) }
    pixel = im[0, 0]
    pixel.size.should eq(1)
    pixel[0].should eq(100)

    pixel = im[0, 1]
    pixel.size.should eq(1)
    pixel[0].should eq(0)
  end

  it "can draw mask" do
    mask = Vips::Image.black(51, 51)
    mask = mask.mutate { |x| x.draw_circle([128.0], 25, 25, 25, fill: true) }

    im = Vips::Image.black(100, 100)
    im = im.mutate { |x| x.draw_mask([200.0], mask, 25, 25) }

    im2 = Vips::Image.black(100, 100)
    im2 = im2.mutate { |x| x.draw_circle([100.0], 50, 50, 25, fill: true) }

    diff = (im - im2).abs.max
    diff[0].should eq(0)
  end

  it "can draw rect" do
    im = Vips::Image.black(100, 100)
    im = im.mutate { |x| x.draw_rect([100.0], 25, 25, 50, 50, fill: true) }

    im2 = Vips::Image.black(100, 100)
    im2 = im2.mutate { |x|
      (25...75).each { |y| x.draw_line([100.0], 25, y, 74, y) }
    }

    diff = (im - im2).abs.max
    diff[0].should eq(0)
  end

  it "can draw smudge" do
    im = Vips::Image.black(100, 100)
    im = im.mutate { |x| x.draw_circle([100.0], 50, 50, 25) }

    im2 = im.extract_area(10, 10, 50, 50)

    im3 = im.mutate do |x|
      x.draw_smudge(10, 10, 50, 50)
      x.draw_image(im2, 10, 10)
    end

    diff = (im3 - im).abs.max
    diff[0].should eq(0)
  end

  it "test countlines" do
    im = Vips::Image.black(100, 100)
    im = im.mutate { |x| x.draw_line([255.0], 0, 50, 100, 50) }
    nlines = im.countlines(Vips::Enums::Direction::Horizontal)
    nlines.to_i.should eq(1)
  end

  if Vips.at_least_libvips?(8, 10)
    it "test labelregions" do
      im = Vips::Image.black(100, 100)
      im = im.mutate { |x| x.draw_circle([100.0], 50, 50, 25, fill: true) }

      mask, segments = im.labelregions
      segments.should eq(3)
      mask.max[0].should eq(2)
    end

    it "test rank" do
      im = Vips::Image.black(100, 100)
      im = im.mutate { |x| x.draw_circle([100.0], 50, 50, 25, fill: true) }
      im2 = im.rank(3, 3, 8)
      im.width.should eq(im2.width)
      im.height.should eq(im2.height)
      im.bands.should eq(im2.bands)
      im2.avg.should be > im.avg
    end

    it "can set metadata in mutate" do
      image = Vips::Image.black(16, 16)
      image = image.mutate { |x| x.set(Vips::GValue::GInt, "banana", 12) }

      image.get("banana").as_i32.should eq(12)
    end

    it "can remove metadata in mutate" do
      image = Vips::Image.black(16, 16)
      image = image.mutate { |x| x.set(Vips::GValue::GInt, "banana", 12) }

      image = image.mutate { |x| x.remove("banana") }
      image.get_typeof("banana").should eq(0)
    end
  end

  it "cannot call non-destructive operations in mutate" do
    image = Vips::Image.black(16, 16)
    expect_raises(Vips::VipsException, "operation must be mutable") do
      image.mutate { |x| x.invert }
    end
  end
end
