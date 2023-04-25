require "./spec_helper"

describe Vips::Connection do
  describe Vips::Source do
    it "can create a source from a descriptor" do
      source = Vips::Source.new_from_descriptor(0)
      source.should_not be(nil)
    end

    it "can create a source from a filename" do
      source = Vips::Source.new_from_file(simg("wagon.jpg"))
      source.should_not be(nil)
    end

    it "can't create a source from a bad filename" do
      expect_raises(Vips::VipsException, "can't create source from filename ") do
        Vips::Source.new_from_file(simg("banana.jpg"))
      end
    end

    it "can create a source from an area of memory" do
      str = File.read(simg("wagon.jpg"))
      source = Vips::Source.new_from_memory(str)
      source.should_not be(nil)
    end

    it "should have filenames and nicks" do
      source = Vips::Source.new_from_file(simg("wagon.jpg"))

      source.filename.should eq(simg("wagon.jpg"))
      source.nick.should_not be(nil)
    end

    it "can load an image from filename source" do
      source = Vips::Source.new_from_file(simg("wagon.jpg"))
      image = Vips::Image.new_from_source(source)

      image.width.should eq(685)
      image.height.should eq(478)
      image.bands.should eq(3)
      (image.avg - 109.789).should be <= 0.001
    end
  end

  describe Vips::Target do
    it "can create a target to a filename" do
      Vips::Target.new_to_file(timg("x.jpg"))
    end

    it "can create a target to a descriptor" do
      Vips::Target.new_to_descriptor(1)
    end

    it "can create a target to a memory area" do
      Vips::Target.new_to_memory
    end

    it "can't create a target to a bad filename" do
      expect_raises(Vips::VipsException) do
        Vips::Target.new_to_file("/banana/monkey")
      end
    end

    it "can save an image to a filename target" do
      source = Vips::Source.new_from_file(simg("wagon.jpg"))
      image = Vips::Image.new_from_source(source)
      target = Vips::Target.new_to_memory
      image.write_to_target(target, "%.png")
      memory = target.blob

      image = Vips::Image.new_from_buffer(memory)
      image.width.should eq(685)
      image.height.should eq(478)
      image.bands.should eq(3)
      (image.avg - 109.789).should be <= 0.001
    end
  end

  describe Vips::SourceCustom do
    it "can create a custom source" do
      source = Vips::SourceCustom.new
    end

    it "can load a custom source" do
      file = File.open(simg("wagon.jpg"), "rb")
      source = Vips::SourceCustom.new
      source.on_read { |buff| file.read(buff) }
      source.on_seek { |offset, whence|
        file.seek(offset, whence)
        file.pos
      }

      image = Vips::Image.new_from_source(source)

      image.width.should eq(685)
      image.height.should eq(478)
      image.bands.should eq(3)
      (image.avg - 109.789).should be <= 0.001
    end

    it "can load a source stream" do
      file = File.open(simg("wagon.jpg"), "rb")
      source = Vips::SourceStream.new_from_stream(file)

      image = Vips::Image.new_from_source(source)

      image.width.should eq(685)
      image.height.should eq(478)
      image.bands.should eq(3)
      (image.avg - 109.789).should be <= 0.001
    end

    it "can create a user output stream" do
      Vips::TargetCustom.new
    end

    pending "can write an image to a user output stream" do
      filename = timg("x5.png")
      file = File.open(filename, "wb")
      target = Vips::TargetCustom.new
      target.on_write { |slice| file.write(slice); slice.size.to_i64 }
      target.on_finish { file.close }

      image = Vips::Image.new_from_file(simg("wagon.jpg"))
      image.write_to_target(target, "%.png")

      image = Vips::Image.new_from_file(filename)

      image.width.should eq(685)
      image.height.should eq(478)
      image.bands.should eq(3)
      (image.avg - 109.789).should be <= 0.001
    end

    it "can write an image via target stream" do
      filename = timg("x5.png")
      file = File.open(filename, "wb")
      target = Vips::TargetStream.new_from_stream(file)

      image = Vips::Image.new_from_file(simg("wagon.jpg"))
      image.write_to_target(target, "%.png")

      image = Vips::Image.new_from_file(filename)

      image.width.should eq(685)
      image.height.should eq(478)
      image.bands.should eq(3)
      (image.avg - 109.789).should be <= 0.001
    end
  end
end
