# This script generates the files src/vips/ext/image.cr and src/vips/ext/mutableimage.cr
require "ecr"
require "compiler/crystal/formatter"
require "../src/vips"
require "./init"

G_to_Crystal = {
  Vips::GValue::GBool                               => "Bool",
  Vips::GValue::GInt                                => "Int32",
  Vips::GValue::GUint64                             => "UInt32",
  Vips::GValue::GDouble                             => "Float64",
  Vips::GValue::GString                             => "String",
  Vips::GValue::GObject                             => "GObject",
  Vips::GValue::VImageType                          => "Image",
  Vips::GValue::VArrayInt                           => "Array(Int32)",
  Vips::GValue::VArrayDouble                        => "Array(Float64)",
  Vips::GValue::VArrayImage                         => "Array(Image)",
  Vips::GValue::VRefStr                             => "String",
  Vips::GValue::VBlob                               => "Bytes",
  Vips::GValue::VSource                             => "Source",
  Vips::GValue::VTarget                             => "Target",
  Vips.type_from_name("VipsInterpolate")            => "Interpolate",
  Vips.type_from_name("VipsFailOn")                 => "Enums::FailOn",
  Vips.type_from_name("VipsAccess")                 => "Enums::Access",
  Vips.type_from_name("VipsAlign")                  => "Enums::Align",
  Vips.type_from_name("VipsAngle")                  => "Enums::Angle",
  Vips.type_from_name("VipsAngle45")                => "Enums::Angle45",
  Vips.type_from_name("VipsBandFormat")             => "Enums::BandFormat",
  Vips.type_from_name("VipsBlendMode")              => "Enums::BlendMode",
  Vips.type_from_name("VipsCoding")                 => "Enums::Coding",
  Vips.type_from_name("VipsCombine")                => "Enums::Combine",
  Vips.type_from_name("VipsCombineMode")            => "Enums::CombineMode",
  Vips.type_from_name("VipsCompassDirection")       => "Enums::CompassDirection",
  Vips.type_from_name("VipsDemandStyle")            => "Enums::DemandStyle",
  Vips.type_from_name("VipsDirection")              => "Enums::Direction",
  Vips.type_from_name("VipsExtend")                 => "Enums::Extend",
  Vips.type_from_name("VipsForeignDzContainer")     => "Enums::ForeignDzContainer",
  Vips.type_from_name("VipsForeignDzDepth")         => "Enums::ForeignDzDepth",
  Vips.type_from_name("VipsForeignDzLayout")        => "Enums::ForeignDzLayout",
  Vips.type_from_name("VipsForeignHeifCompression") => "Enums::ForeignHeifCompression",
  Vips.type_from_name("VipsForeignPpmFormat")       => "Enums::ForeignPpmFormat",
  Vips.type_from_name("VipsForeignSubsample")       => "Enums::ForeignSubsample",
  Vips.type_from_name("VipsForeignTiffCompression") => "Enums::ForeignTiffCompression",
  Vips.type_from_name("VipsForeignTiffPredictor")   => "Enums::ForeignTiffPredictor",
  Vips.type_from_name("VipsForeignTiffResunit")     => "Enums::ForeignTiffResunit",
  Vips.type_from_name("VipsForeignWebpPreset")      => "Enums::ForeignWebpPreset",
  Vips.type_from_name("VipsIntent")                 => "Enums::Intent",
  Vips.type_from_name("VipsInteresting")            => "Enums::Interesting",
  Vips.type_from_name("VipsInterpretation")         => "Enums::Interpretation",
  Vips.type_from_name("VipsKernel")                 => "Enums::Kernel",
  Vips.type_from_name("VipsOperationBoolean")       => "Enums::OperationBoolean",
  Vips.type_from_name("VipsOperationComplex")       => "Enums::OperationComplex",
  Vips.type_from_name("VipsOperationComplex2")      => "Enums::OperationComplex2",
  Vips.type_from_name("VipsOperationComplexget")    => "Enums::OperationComplexget",
  Vips.type_from_name("VipsOperationMath")          => "Enums::OperationMath",
  Vips.type_from_name("VipsOperationMath2")         => "Enums::OperationMath2",
  Vips.type_from_name("VipsOperationMorphology")    => "Enums::OperationMorphology",
  Vips.type_from_name("VipsOperationRelational")    => "Enums::OperationRelational",
  Vips.type_from_name("VipsOperationRound")         => "Enums::OperationRound",
  Vips.type_from_name("VipsPCS")                    => "Enums::PCS",
  Vips.type_from_name("VipsPrecision")              => "Enums::Precision",
  Vips.type_from_name("VipsRegionShrink")           => "Enums::RegionShrink",
  Vips.type_from_name("VipsSize")                   => "Enums::Size",
  Vips.type_from_name("VipsForeignFlags")           => "Enums::ForeignFlags",
  Vips.type_from_name("VipsForeignPngFilter")       => "Enums::ForeignPngFilter",

}

all_nick_names = Vips.get_operations

excludes = [
  "scale",
  "ifthenelse",
  "bandjoin",
  "bandrank",
  "composite",
  "case",
]

def g2c(name, gtype) : String
  if v = G_to_Crystal[gtype]?
    return v
  end
  fundamental = Vips.fundamental_type(gtype)
  if v = G_to_Crystal[fundamental]?
    return v
  end
  raise "Unsupported type: #{Vips.typename(gtype)} name: #{name}"
end

def safe_cast(type : String)
  if type.starts_with?("Enums::")
    return "as_enum(#{type})"
  end

  case type
  when "GObject"        then "as_o"
  when "Image"          then "as_image"
  when "Array(Int32)"   then "as_a32"
  when "Array(Float64)" then "as_a64"
  when "Array(Image)"   then "as_aimg"
  when "Bytes"          then "as_bytes"
  when "Bool"           then "as_b"
  when "Int32"          then "as_i32"
  when "Float64"        then "as_f64"
  when "String"         then "as_s"
  when "UInt64"         then "as_u64"
  else
    raise "#{type} not supported"
  end
end

def generate_props
  result = String::Builder.new
  tmpfile = Vips::Image.new_temp_file("%s.v")
  all_props = tmpfile.get_fields
  all_props.each do |prop|
    type = g2c(prop, tmpfile.get_typeof(prop))
    type_str = "get(\"#{prop}\").#{safe_cast(type)}"
    result << "# " << tmpfile.get_blurb(prop) << "\n"
    result << "def " << prop.underscore << " : " << type << "\n"
    result << type_str
    result << "\nend\n"
    result << "\n"
  end
  result.to_s
end

def generate_method(opname, mutable = false) # , out_params = Array(Vips::Introspect::Argument).new)
  op = Vips::Operation.new(opname)
  intro = Vips::Introspect.get(opname)

  # we are only interested in non-deprecated args
  optional_input = intro.optional_input.values.select { |arg| (arg.flags & LibVips::VipsArgumentFlags::Deprecated).value == 0 }
  optional_output = intro.optional_output.values.select { |arg| (arg.flags & LibVips::VipsArgumentFlags::Deprecated).value == 0 }

  required_input = intro.required_input
  required_output = intro.required_output

  raise "Cannot generate #{opname} as this is a #{intro.mutable ? "" : "non-"}mutable operation." if (mutable ^ intro.mutable)

  reserved_keywords = %w[out case in]

  safe_identifier = ->(name : String) { reserved_keywords.includes?(name) ? "#{name}_" : name }
  safe_cast = ->(type : String) {
    case type
    when "GObject"        then "as_o"
    when "Image"          then "as_image"
    when "Array(Int32)"   then "as_a32"
    when "Array(Float64)" then "as_a64"
    when "Array(Image)"   then "as_aimg"
    when "Bytes"          then "as_bytes"
    when "Bool"           then "as_b"
    when "Int32"          then "as_i32"
    when "Float64"        then "as_f64"
    when "String"         then "as_s"
    when "UInt64"         then "as_u64"
    end
  }

  new_op_name = opname.underscore

  result = String::Builder.new
  description = op.get_description
  result << "# " << description.capitalize << '\n'
  result << " #
                #```crystal
    #"

  if required_output.size == 1
    arg = required_output.first
    result << "# " << safe_identifier.call(arg.name).underscore
  elsif required_output.size > 1
    result << "# output  "
  elsif intro.mutable && intro.member_x?
    result << "# image.mutate { |x| "
  end

  if optional_output.size > 0 && !intro.mutable
    result << ", " << optional_output.reduce([] of String) { |arr, arg| arr << safe_identifier.call(arg.name).underscore }.join(", ")
  end

  result << " = " if required_output.size > 0 || (optional_output.size > 0 && !intro.mutable)

  if (mx = intro.member_x?)
    result << (intro.mutable ? "x" : mx.name)
  else
    result << "Vips::Image"
  end

  result << "." << new_op_name << "("
  result << required_input.reduce([] of String) { |arr, arg| arr << safe_identifier.call(arg.name).underscore }.join(", ")

  if optional_input.size > 0
    result << ", " if required_input.size > 0
    result << "{"
    optional_input.each_with_index do |arg, i|
      result << safe_identifier.call(arg.name).underscore << ": " << g2c(arg.name, arg.type)
      result << ", " unless i == optional_input.size - 1
    end
    result << "}"
  end

  result << " }" if intro.mutable
  result << ")" unless intro.mutable
  result << "\n" << "#
            #```
            #
            "
  if required_input.size > 0 || optional_input.size > 0
    result << "#\n# Input Parameters\n#\n"
  end

  result << "# **Required** \n#\n" if required_input.size > 0
  required_input.each do |arg|
    result << "# *" << arg.name.underscore << "* : " << g2c(arg.name, arg.type) << " - " << op.get_blurb(arg.name) << "\n#\n"
  end

  result << "# _Optionals_\n#\n" if optional_input.size > 0
  optional_input.each do |arg|
    result << "# *" << arg.name.underscore << "* : " << g2c(arg.name, arg.type) << " - " << op.get_blurb(arg.name) << "\n#\n"
  end

  get_type = ->(types : Array(String)) {
    case types.size
    when 0 then "Nil"
    when 1 then types.first
    else
      types.any? { |v| v != types.first } ? "Array(Type)" : "Array(#{types.first})"
    end
  }

  output_types = required_output.reduce([] of String) { |arr, arg| arr << g2c(arg.name, arg.type) }
  opt_outtypes = optional_output.reduce([] of String) { |arr, arg| arr << g2c(arg.name, arg.type) }

  output_type = get_type.call(output_types)
  opt_outtype = get_type.call(opt_outtypes)

  if required_output.size > 0 || (optional_output.size > 0 && !intro.mutable)
    result << "#\n# **Returns**\n#\n"
    required_output.each do |arg|
      result << "# " << op.get_blurb(arg.name) << "\n#\n"
    end
    result << "# _Optionals_\n#\n" if optional_output.size > 0
    optional_output.each do |arg|
      result << "# *" << arg.name.underscore << "* : " << g2c(arg.name, arg.type) << "? - " << op.get_blurb(arg.name) << "\n#\n"
    end
  end

  result << "def "
  result << "self." unless intro.member_x?
  result << new_op_name
  if required_input.size == 1 && optional_output.size == 0 && optional_input.size == 0 && required_input.first.type == Vips::GValue::VArrayImage
    result << "(*" << safe_identifier.call(required_input.first.name) << " : Image)\n"
  else
    result << "("
    result << required_input.reduce([] of String) { |arr, arg| arr << safe_identifier.call(arg.name).underscore + " : " + g2c(arg.name, arg.type) }.join(", ")

    if optional_input.size > 0
      result << ", " if required_input.size > 0
      result << "**kwargs"
    end
    result << ")"
  end
  result << " : Nil" if intro.mutable
  result << "\n"
  if optional_input.size > 0
    result << "options = Optional.new(**kwargs)" << "\n"
  end

  if (required_output.size > 0 || optional_output.size > 0) && !intro.mutable
    if optional_input.size > 0
      optional_output.each do |arg|
        result << " options[\"" << arg.name << "\"] = true"
        result << "\n"
      end
    elsif optional_output.size > 0
      result << " optional_output = Optional.new(**{"
      optional_output.each_with_index do |arg, i|
        result << arg.name << ": " << "true"
        result << ", " unless i == optional_output.size - 1
      end
      result << "})" << "\n"
    end
    result << "\n"
    if required_output.size > 1 || optional_output.size > 0
      result << (required_output.size > 0 ? "results = " : "opts")
    end
    result << (intro.member_x? ? "self" : "Operation")
    result << ".call(\"" << opname << "\""
    result << (optional_input.size > 0 ? ", options" : ", optional_output") if (optional_input.size > 0 || optional_output.size > 0)
  else
    result << (intro.member_x? ? "self" : "Operation")
    result << ".call(\"" << opname << "\""
    result << ", options" if optional_input.size > 0
  end

  if required_input.size > 0
    result << ", "
    result << required_input.reduce([] of String) { |arr, arg| arr << safe_identifier.call(arg.name).underscore }.join(", ")
  end
  result << ")"

  unless intro.mutable
    if required_output.size > 0 && optional_output.size > 0
      result << ".as(Array(Type))" << "\n"
      result << "final_result = results.first"
      result << ".as(Type)." << safe_cast(output_type)
    elsif required_output.size > 1
      result << ".as(Array(Type))" << "\n"
    elsif required_output.size == 1
      result << ".as(Type)." << safe_cast(output_type)
    elsif optional_output.size > 0
      result << ".as(Type).as_h"
    end
  end
  result << "\n"

  unless intro.mutable
    if optional_output.size > 0
      if required_output.size > 0
        result << "\n" << "opts = results[1]?.try &.as_h" << "\n\n"
      end
      var_names = [] of String
      if output_type != "Nil"
        optional_output.each do |arg|
          name = safe_identifier.call(arg.name).underscore
          var_names << name
          arg_type = g2c(arg.name, arg.type)
          type_str = "val.#{safe_cast(arg_type)}"
          tmp_var = <<-VAR
               #{name} = ((o = opts) && (val = o["#{arg.name}"]?)) ? #{type_str} : nil
            VAR
          result << tmp_var << "\n"
        end
        result << ((required_output.size > 0) ? "{final_result," : "{")
        result << var_names.join(", ") << "}"
      end
    elsif required_output.size > 1
      var_names = [] of String
      required_output.each_with_index do |arg, i|
        arg_type = g2c(arg.name, arg.type)
        var_names << "results[#{i}].#{safe_cast(arg_type)}"
      end
      result << (var_names.size > 1 ? "{#{var_names.join(", ")}}" : var_names.first)
      result << "\n"
    end
  end
  result << "\nend"
  result << "\n"

  first_arg_type = required_input.size > 0 ? op.get_typeof(required_input.first.name) : -1
  if (first_arg_type == Vips::GValue::VSource) || (first_arg_type == Vips::GValue::VTarget)
    replace = first_arg_type == Vips::GValue::VSource ? "source" : "target"
    required_input = required_input.skip(1)
    old_opname = new_op_name
    new_op_name = new_op_name.gsub(replace, "stream")

    result << "\n# " << description.gsub(replace, "stream").capitalize << "\n#\n"
    result << "#```\n#"
    if required_output.size == 1
      arg = required_output.first
      result << "# " << safe_identifier.call(arg.name).underscore
    elsif required_output.size > 1
      result << "# output "
    end

    if optional_output.size > 0
      result << ", " << optional_output.reduce([] of String) { |arr, arg| arr << safe_identifier.call(arg.name).underscore }.join(", ")
    end

    result << " = " if required_output.size > 0 || optional_output.size > 0

    if (mx = intro.member_x?)
      result << (intro.mutable ? "x" : mx.name)
    else
      result << "Vips::Image"
    end

    result << "." << new_op_name << "(stream, "
    result << required_input.reduce([] of String) { |arr, arg| arr << safe_identifier.call(arg.name).underscore }.join(", ")

    if optional_input.size > 0
      result << ", " if required_input.size > 0
      result << "{"
      optional_input.each_with_index do |arg, i|
        result << safe_identifier.call(arg.name).underscore << ": " << g2c(arg.name, arg.type)
        result << ", " unless i == optional_input.size - 1
      end
      result << "}"
    end

    result << ")" << "\n" << "#
                #```
                #
                "
    result << "# **Input Parameters**\n" << "#\n" << "# _Required_\n"
    result << "#\n# *stream* : IO - Stream to " << (first_arg_type == Vips::GValue::VSource ? "load from" : "save to") << "\n"

    required_input.each do |arg|
      result << "#\n# *" << arg.name.underscore << " : " << g2c(arg.name, arg.type) << "* - " << op.get_blurb(arg.name) << "\n"
    end

    result << "# _Optionals_\n" if optional_input.size > 0
    optional_input.each do |arg|
      result << "#\n# *" << arg.name.underscore << "* : " << g2c(arg.name, arg.type) << " - " << op.get_blurb(arg.name) << "\n"
    end

    output_types = required_output.reduce([] of String) { |arr, arg| arr << g2c(arg.name, arg.type) }
    output_type = case output_types.size
                  when 0 then "Nil"
                  when 1 then output_types.first
                  else
                    output_types.any? { |v| v != output_types.first } ? "Array(#{output_types.first})" : "Array(Type)"
                  end

    if required_output.size > 0 || optional_output.size > 0
      result << "#\n# **Returns**\n"
      required_output.each do |arg|
        result << "#\n# *" << arg.name.underscore << "* : " << g2c(arg.name, arg.type) << " - " << op.get_blurb(arg.name) << "\n"
      end
      result << "# _Optionals_\n"
      optional_output.each do |arg|
        result << "#\n# *" << arg.name.underscore << "* : " << g2c(arg.name, arg.type) << "? - " << op.get_blurb(arg.name) << "\n"
      end
    end

    result << "def "
    result << "self." unless intro.member_x?
    result << new_op_name << "(stream : IO,"
    result << required_input.reduce([] of String) { |arr, arg| arr << safe_identifier.call(arg.name).underscore + " : " + g2c(arg.name, arg.type) }.join(", ")

    if optional_input.size > 0
      result << ", " if required_input.size > 0
      result << "**kwargs"
    end
    result << ")\n"
    result << (first_arg_type == Vips::GValue::VSource ? "source = SourceStream.new_from_stream(stream)\n" : "target = TargetStream.new_from_stream(stream)\n")
    result << old_opname << "(" << (first_arg_type == Vips::GValue::VSource ? "source" : "target")
    result << ", "
    result << required_input.reduce([] of String) { |arr, arg| arr << safe_identifier.call(arg.name).underscore }.join(", ")
    if optional_input.size > 0
      result << ", " if required_input.size > 0
      result << "**kwargs"
    end
    result << ")\n"

    result << "\nend"
    result << "\n"
  end

  result.to_s
end

# get the list of all nicknames we can generate docstrings for.
nick_names = (all_nick_names - excludes).map { |x| x.downcase }
nick_names.sort!

output = String.build do |str|
  ECR.embed "#{__DIR__}/image.ecr", str
end
output = Crystal.format(output)

File.write("#{__DIR__}/../src/vips/ext/image.cr", output)

output = String.build do |str|
  ECR.embed "#{__DIR__}/mutableimage.ecr", str
end
output = Crystal.format(output)

File.write("#{__DIR__}/../src/vips/ext/mutableimage.cr", output)
