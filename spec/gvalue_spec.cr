require "./spec_helper"

describe Vips::GValue do
  it "test bool" do
    gv = Vips::GValue.new
    gv.set_type(Vips::GValue::GBool)
    gv.set(true)
    gv.get.as_b.should be_true
  end

  it "test int" do
    gv = Vips::GValue.new
    gv.set_type(Vips::GValue::GInt)
    gv.set(12)
    gv.get.as_i32.should eq(12)
  end

  it "test Uint64" do
    gv = Vips::GValue.new
    gv.set_type(Vips::GValue::GUint64)
    gv.set(12_u64)
    gv.get.as_u64.should eq(12_u64)
  end

  it "test Double" do
    gv = Vips::GValue.new
    gv.set_type(Vips::GValue::GDouble)
    gv.set(12.1314)
    gv.get.as_f64.should eq(12.1314)
  end

  it "test Enum" do
    # the interpretation enum is created when the first image is made
    # make it ourselves in case we are run before the first image
    LibVips.vips_interpretation_get_type
    gtype = Vips.type_from_name("VipsInterpretation")

    gv = Vips::GValue.new
    gv.set_type(gtype)
    gv.set(Vips::Enums::Interpretation::Xyz)
    gv.get.as_enum(Vips::Enums::Interpretation).should eq(Vips::Enums::Interpretation::Xyz)
  end

  it "test flags" do
    # the OperationFlags enum is created when the first op is made
    # make it ourselves in case we are run before that
    LibVips.vips_operation_flags_get_type
    gtype = Vips.type_from_name("VipsOperationFlags")

    gv = Vips::GValue.new
    gv.set_type(gtype)
    gv.set(Vips::Enums::OperationFlags::Deprecated)

    gv.get.as_enum(Vips::Enums::OperationFlags).should eq(Vips::Enums::OperationFlags::Deprecated)
  end

  it "test string" do
    gv = Vips::GValue.new
    gv.set_type(Vips::GValue::GString)
    gv.set("hello world")
    gv.get.as_s.should eq("hello world")
  end

  it "test refstring" do
    gv = Vips::GValue.new
    gv.set_type(Vips::GValue::VRefStr)
    gv.set("hello world")
    gv.get.as_s.should eq("hello world")
  end

  it "test arrayint" do
    gv = Vips::GValue.new
    gv.set_type(Vips::GValue::VArrayInt)
    gv.set([1, 2, 3])
    gv.get.as_a32.should eq([1, 2, 3])
  end

  it "test arraydouble" do
    gv = Vips::GValue.new
    gv.set_type(Vips::GValue::VArrayDouble)
    gv.set([1.0, 2.0, 3.0])
    gv.get.as_a64.should eq([1.0, 2.0, 3.0])
  end

  it "test image" do
    image = Vips::Image.new_from_file(simg("wagon.jpg"))
    gv = Vips::GValue.new
    gv.set_type(Vips::GValue::VImageType)
    gv.set(image)

    gv.get.as_image.should eq(image)
  end

  it "test array image" do
    images = Vips::Image.new_from_file(simg("wagon.jpg")).bandsplit
    gv = Vips::GValue.new
    gv.set_type(Vips::GValue::VArrayImage)
    gv.set(images)

    gv.get.as_aimg.should eq(images)
  end

  it "test blob" do
    blob = File.read(simg("wagon.jpg")).to_slice
    gv = Vips::GValue.new
    gv.set_type(Vips::GValue::VBlob)
    gv.set(blob)

    gv.get.as_bytes.should eq(blob)
  end
end
