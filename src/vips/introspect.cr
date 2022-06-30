module Vips
  # Build introspection data for operations
  # Make an operation, introspect it, and build a structure representing
  # everything we know about it.
  class Introspect
    @@cache = Hash(String, Introspect).new
    # An object structure that encapsulate the metadata
    # required to specify arguments
    record Argument, name : String, flags : LibVips::VipsArgumentFlags, type : LibVips::GType

    # The first required input image or nil
    getter! member_x : Argument?

    # A bool indicating if this operation is mutable
    getter mutable : Bool = false

    # The required input for this operation
    getter required_input : Array(Argument) = Array(Argument).new

    # The optional input for this operation
    getter optional_input : Hash(String, Argument) = Hash(String, Argument).new

    # The required output for this operation
    getter required_output : Array(Argument) = Array(Argument).new

    # The optional output for this operation
    getter optional_output : Hash(String, Argument) = Hash(String, Argument).new

    protected def initialize(operation_name : String)
      op = Operation.new(operation_name)
      args = get_args(op)

      args.each do |arg|
        name = arg.first
        flag = arg.last
        gtype = op.get_typeof(name).not_nil!

        details = Argument.new(name, flag, gtype)

        if (flag & LibVips::VipsArgumentFlags::Input).value != 0
          if ((flag & LibVips::VipsArgumentFlags::Required).value != 0) &&
             ((flag & LibVips::VipsArgumentFlags::Deprecated).value == 0)
            # the first required input image arg will be self
            if (@member_x.nil? && gtype == GValue::VImageType)
              @member_x = details
            else
              required_input << details
            end
          else
            # we allow deprecated optional args
            optional_input[name] = details
          end

          # modified input arguments count as mutable
          if (flag & LibVips::VipsArgumentFlags::Modify).value != 0 &&
             (flag & LibVips::VipsArgumentFlags::Required).value != 0 &&
             (flag & LibVips::VipsArgumentFlags::Deprecated).value == 0
            @mutable = true
          end
        elsif (flag & LibVips::VipsArgumentFlags::Output).value != 0
          if (flag & LibVips::VipsArgumentFlags::Required).value != 0 &&
             (flag & LibVips::VipsArgumentFlags::Deprecated).value == 0
            required_output << details
          else
            # again, allow deprecated optional args
            optional_output[name] = details
          end
        end
      end
    end

    # Get all arguments for an operation.
    def get_args(op : Operation)
      args = Array(Tuple(String, LibVips::VipsArgumentFlags)).new

      add_arg = ->(name : String, flags : LibVips::VipsArgumentFlags) {
        # libvips uses '-' to separate parts of arg names, but we
        # need '_' for crystal
        name = name.gsub('-', '_')
        args << {name, flags}
        nil
      }

      # vips_object_get_args was added in 8.7
      if Vips.at_least_libvips?(8, 7)
        result = LibVips.vips_object_get_args(op.to_obj, out names, out flags_, out count)
        raise VipsException.new("unable to get arguments for operation") unless result == 0

        0.upto(count - 1) do |i|
          flag = LibVips::VipsArgumentFlags.from_value(flags_[i])
          next if (flag & LibVips::VipsArgumentFlags::Construct).value == 0
          name = String.new(names[i])
          add_arg.call(name, flag)
        end
      else
        proc = LibVips::VipsArgumentMapFn.new do |_self, pspec, argcls, arginst, a, b|
          flag = argcls.value.flags
          next Pointer(Void).null if (flag & LibVips::VipsArgumentFlags::Construct).value == 0

          name = String.new(pspec.value.name)
          handler = Box(Proc(String, LibVips::VipsArgumentFlags, Nil)).unbox(a)
          handler.call(name, flag)
          Pointer(Void).null
        end

        LibVips.vips_argument_map(op.to_obj, proc, Box.box(add_arg), Pointer(Void).null)
      end

      args
    end

    # Get introspection data for a specified operation name.
    def self.get(operation_name : String)
      @@cache[operation_name] ||= Introspect.new(operation_name)
    end
  end
end
