require "ecr"
require "compiler/crystal/formatter"
require "../src/vips"
require "./init"

enums_str = String.build do |result|
  Vips.get_enums.each do |name|
    next if name.starts_with?("Gsf")
    gtype = Vips.type_from_name(name)
    vals = Vips.enum_values(gtype)
    result << " enum " << (name.starts_with?("Vips") ? name[4..] : name) << "\n"
    vals.each do |k, v|
      result << k.gsub('-', '_').camelcase << " = " << v << "\n"
    end
    result << "end\n\n"
  end
end

output = String.build do |str|
  ECR.embed "#{__DIR__}/enums.ecr", str
end
output = Crystal.format(output)

File.write("#{__DIR__}/enums.cr", output)
