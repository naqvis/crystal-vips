require "./spec_helper"

describe Vips do
  it "can get default concurrency" do
    Vips.default_concurrency.should eq(DEFAULT_VIPS_CONCURRENCY)
  end

  it "can get concurrency" do
    Vips.concurrency.should eq(Vips.default_concurrency)
  end

  it "can set concurrency" do
    Vips.concurrency = 12
    Vips.concurrency.should eq(12)
  end

  it "clips concurrency to 1024" do
    Vips.concurrency = 1025
    Vips.concurrency.should eq(1024)
  end

  it "can set concurrency to 0 to reset to default" do
    Vips.concurrency = Random.new.rand(100)

    Vips.concurrency = 0
    Vips.concurrency.should eq(Vips.default_concurrency)
  end

  it "sets SIMD" do
    default = Vips.vector?
    Vips.vector = true
    Vips.vector?.should be_true

    Vips.vector = false
    Vips.vector?.should be_false

    Vips.vector = default
  end

  it "can enable leak testing" do
    Vips.leak = true
    Vips.leak = false
  end

  it "can get a set of filename suffixes" do
    suffs = Vips.get_suffixes
    (suffs.size > 10).should be_true unless suffs.empty?
  end

  describe Vips::Cache do
    it "can get and set the operation cache size" do
      default = Vips::Cache.max

      Vips::Cache.max = 0
      Vips::Cache.max.should eq(0)

      Vips::Cache.max = default
      Vips::Cache.max.should eq(default)
    end

    it "can get and set the operation cache memory limit" do
      default = Vips::Cache.max_mem

      Vips::Cache.max_mem = 0
      Vips::Cache.max_mem.should eq(0)

      Vips::Cache.max_mem = default
      Vips::Cache.max_mem.should eq(default)
    end

    it "can set the operation cache file limit" do
      default = Vips::Cache.max_files

      Vips::Cache.max_files = 0
      Vips::Cache.max_files.should eq(0)

      Vips::Cache.max_files = default
      Vips::Cache.max_files.should eq(default)
    end
  end

  describe Vips::Stats do
    it "can get allocated bytes" do
      Vips::Stats.mem.should be >= 0
    end

    it "can get allocated bytes high-water mark" do
      Vips::Stats.mem_highwater.should be >= 0
    end

    it "can get allocation count" do
      Vips::Stats.allocations.should be >= 0
    end

    it "can get open file count" do
      Vips::Stats.open_files.should be >= 0
    end
  end

  describe Vips::Operation do
    it "can make a black image" do
      image = Vips::Operation.call("black", 200, 200).as(Vips::Type).as_image
      image.width.should eq(200)
      image.height.should eq(200)
      image.bands.should eq(1)
    end

    it "can take an optional argument" do
      image = Vips::Operation.call("black", Vips::Optional.new(bands: 12), 200, 200).as(Vips::Type).as_image
      image.width.should eq(200)
      image.height.should eq(200)
      image.bands.should eq(12)
    end

    it "ignore optional arguments with nil values" do
      image = Vips::Operation.call("black", Vips::Optional.new(bands: nil), 200, 200).as(Vips::Type).as_image
      image.width.should eq(200)
      image.height.should eq(200)
      image.bands.should eq(1)
    end

    it "can handle enum arguments" do
      black = Vips::Operation.call("black", 200, 200).as(Vips::Type).as_image
      image = Vips::Operation.call("embed", Vips::Optional.new(extend: Vips::Enums::Extend::Mirror),
        black, 10, 10, 500, 500).as(Vips::Type).as_image

      image.width.should eq(500)
      image.height.should eq(500)
      image.bands.should eq(1)
    end

    it "can return optional output args" do
      point = Vips::Operation.call("black", 1, 1).as(Vips::Type).as_image
      test = Vips::Operation.call("embed", Vips::Optional.new(extend: Vips::Enums::Extend::White),
        point, 20, 10, 100, 100).as(Vips::Type).as_image

      value = Vips::Operation.call("min", Vips::Optional.new(x: true, y: true), test).as(Array(Vips::Type))
      opts = value[1].as_h
      value[0].as_i32.should eq(0)
      opts["x"].as_i32.should eq(20)
      opts["y"].as_i32.should eq(10)
    end

    it "can call draw operations" do
      black = Vips::Operation.call("black", 100, 100).as(Vips::Type).as_image
      max_black = Vips::Operation.call("max", nil, black).as(Vips::Type).as_f64
      Vips::Operation.call("draw_rect", nil, black, 255, 10, 10, 1, 1)
      max_test = Vips::Operation.call("max", nil, black).as(Vips::Type).as_f64

      max_black.should eq(0.0)
      max_test.should eq(255)
    end

    it "can throw errors for failed operations" do
      black = Vips::Operation.call("black", 100, 1).as(Vips::Type).as_image
      expect_raises(Vips::VipsException, "bad extract area") do
        black.crop(10, 10, 1, 1)
      end
    end
  end
end
