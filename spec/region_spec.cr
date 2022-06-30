require "./spec_helper"

describe Vips::Region do
  it "can create a region on an image" do
    image = Vips::Image.black(100, 100)
    Vips::Region.new(image)
  end

  if Vips.at_least_libvips?(8, 8)
    it "can fetch pixels from a region" do
      image = Vips::Image.black(100, 100)
      region = Vips::Region.new(image)
      pixel_data = region.fetch(10, 20, 30, 40)

      pixel_data.should_not be_nil
      pixel_data.size.should eq(30 * 40)
    end

    it "can make regions with width and height" do
      image = Vips::Image.black(100, 100)
      region = Vips::Region.new(image)
      pixel_data = region.fetch(10, 20, 30, 40)

      pixel_data.should_not be_nil
      region.width.should eq(30)
      region.height.should eq(40)
    end
  end
end
