module Vips
  class VipsException < Exception
    def initialize(message)
      super("#{message}\n#{vips_error}")
    end

    private def vips_error
      err = String.new(LibVips.vips_error_buffer || Bytes.empty)
      Vips.clear_error
      err
    end
  end

  # Starts up the world of VIPS.
  # this function is automatically called
  def self.init
    @@initialized ||= LibVips.vips_init("CrystalVips") == 0
    raise VipsException.new("unable to initialize libvips") unless @@initialized
    @@initialized
  end

  def self.shutdown
    LibVips.vips_shutdown
  end

  def self.leak=(@@leak)
    LibVips.vips_leak_set(@@leak)
  end

  def self.profile(@@profile)
    LibVips.vips_profile_set(@@profile)
  end

  # Returns the number of worker threads that vips uses for image evaluation.
  def self.concurrency
    LibVips.vips_concurrency_get
  end

  # Set the size of the pools of worker threads vips uses for image evaluation.
  def self.concurrency=(value : Int)
    value = default_concurrency unless value > 0
    LibVips.vips_concurrency_set(value)
  end

  # Get the major, minor or patch version number of the libvips library.
  # Pass 0 to get the major version number
  # 1 to get minor, 2 to get patch.
  def self.version(flag : Int)
    raise ArgumentError.new("Flag must be in the range of 0 to 2") unless (0..2).includes?(flag)
    LibVips.vips_version(flag).tap do |v|
      raise VipsException.new("Unable to get library version") if v < 0
    end
  end

  # Returns version of libvips in 3-byte integer
  def self.version
    raise VipsException.new("Unable to initialize libvips") unless initialized
    value = 0
    0.upto(2) do |flag|
      if flag == 0
        value = version(flag)
      else
        value = (value << 8) + version(flag)
      end
    end
    value
  end

  # Returns version string of libvips
  def self.version_string
    String.new(LibVips.vips_version_string)
  end

  # Returns if SIMD and the run-time compiler is enabled or not
  def self.vector?
    LibVips.vips_vector_isenabled == 1
  end

  # Enable SIMD and the run-time compiler.
  # This can give a nice speed-up, but can also be unstable on
  # some systems or with some versions of the run-time compiler.
  def self.vector=(val : Bool)
    LibVips.vips_vector_set_enabled(val)
  end

  # Is this at least libvips major.minor.[.patch]?
  def self.at_least_libvips?(x : Int, y : Int, z = 0)
    major = version(0)
    minor = version(1)
    patch = version(2)

    major > x || major == x && minor > y ||
      major == x && minor == y && patch >= z
  end

  # Get a list of all the filename suffixes supported by libvips
  # Note: At least libvips 8.8 is needed
  def self.get_suffixes
    names = [] of String
    return names unless at_least_libvips?(8, 8)

    ptr = LibVips.vips_foreign_get_suffixes
    count = 0
    while (strptr = (ptr + count).value)
      names << String.new(strptr)
      LibVips.g_free(strptr)
      count += 1
    end
    LibVips.g_free(ptr)
    names.uniq!.sort!
  end

  # Reports leaks (hopefully there are none) it also tracks and reports peak memory use.
  def self.report_leaks
    LibVips.vips_object_print_all
    puts "memory: #{Stats.allocations} allocations, #{Stats.mem} bytes"
    puts "files: #{Stats.open_files} open"
    puts "memory: high-water mark: #{Stats.mem_highwater}"
    errbuf = String.new(LibVips.vips_error_buffer)
    puts "error buffer: #{errbuf}" unless errbuf.blank?
  end

  # Get the GType for a name.
  # Looks up the GType for a nickname. Types below basename in the type
  # hierarchy are searched.
  def self.typefind(basename : String, nickname : String)
    LibVips.vips_type_find(basename, nickname)
  end

  # Returns the name for a GType
  def self.typename(type : LibC::ULong)
    String.new(LibVips.g_type_name(type) || Bytes.empty)
  end

  # Return the nickname for a GType.
  def self.nickname(type : LibC::ULong)
    String.new(LibVips.vips_nickname_find(type) || Bytes.empty)
  end

  # Get a list of operations available within the libvips library.
  # This can be useful for documentation generators
  def self.get_operations
    nicknames = Array(String).new
    LibVips.vips_type_map(type_from_name("VipsOperation"), ->ops_cb, Box.box(nicknames), nil)
    nicknames.uniq!.sort!
  end

  # Get a list of enums available within the libvips library.
  def self.get_enums
    enums = Array(String).new
    LibVips.vips_type_map(type_from_name("GEnum"), ->enum_cb, Box.box(enums), nil)
    enums.sort!
  end

  # Get all values for a enum (GType).
  def self.enum_values(type : LibC::ULong)
    typecls = LibVips.g_type_class_ref(type)
    values = Hash(String, Int32).new
    return values if typecls.null?
    enumcls = typecls.as(Pointer(LibVips::GEnumClass)).value

    ptr = enumcls.values.as(Pointer(LibVips::GEnumValue))
    # -1 since we always have "last" member
    0.upto(enumcls.n_values - 2) do |i|
      enumval = ptr[i]
      values[String.new(enumval.value_nick)] = enumval.value
    end
    values
  end

  # Frees the memory pointed to by `mem`
  def self.free(mem : Void*)
    LibVips.g_free(mem)
  end

  # Return the GType for a name.
  def self.type_from_name(nickname : String)
    LibVips.g_type_from_name(nickname)
  end

  # Extract the fundamental type ID portion.
  def self.fundamental_type(type : LibC::ULong)
    LibVips.g_type_fundamental(type)
  end

  def self.clear_error
    LibVips.vips_error_clear
  end

  # Flag to tell if libvips has been initialized or not.
  # initialization will happen at the load of module and you should only call
  # `Vips#init` if auto initialization failed.
  class_getter? initialized = false

  # Enable or disable libvips leak checking.
  # When enabled, libvips will check for object and area leaks on exit.
  # Enabling this option will make libvips run slightly more slowly.
  class_property? leak = false

  # Enable or disable libvips profile recording.
  # If set, vips will record profiling information, and dump it on program
  # exit. These profiles can be analyzed with the `vipsprofile` program.
  class_property? profile = false

  # Track the original default concurrency so we can reset to it.
  class_getter default_concurrency : Int32 { LibVips.vips_concurrency_get }

  private def self.ops_cb(type, a, b)
    nm = nickname(type)
    arr = Box(Array(String)).unbox(a)

    # exclude base classes, for e.g. 'jpegload_base'
    if typefind("VipsOperation", nm) != 0
      arr << nm
    end
    LibVips.vips_type_map(type, ->ops_cb, a, b)
  end

  private def self.enum_cb(type, a, b)
    enm = typename(type)
    arr = Box(Array(String)).unbox(a)
    arr << enm
    LibVips.vips_type_map(type, ->enum_cb, a, b)
  end

  struct Type
    # :nodoc:
    alias VALTYPE = Int32 | Float64 | UInt64 | String | Bool | Bytes | Image | GObject | Array(Int32) | Array(Float64) | Array(Image) | Optional

    getter value : VALTYPE

    def initialize(@value)
    end

    def as_b
      return as_i32 > 0 if @value.is_a?(Number)
      @value.as(Bool)
    end

    def as_i32
      @value.is_a?(Number) ? @value.as(Number).to_i : @value.as(Int32)
    end

    def as_f64
      @value.is_a?(Number) ? @value.as(Number).to_f : @value.as(Float64)
    end

    def as_u64
      @value.is_a?(Number) ? @value.as(Number).to_u64 : @value.as(UInt64)
    end

    def as_s
      return @value.as(String) if @value.is_a?(String)
      @value.to_s
    end

    def as_bytes
      @value.as(Bytes)
    end

    def as_a32
      @value.as(Array(Int32))
    end

    def as_a64
      @value.as(Array(Float64))
    end

    def as_image
      @value.as(Image)
    end

    def as_aimg
      @value.as(Array(Image))
    end

    def as_h
      @value.as(Optional)
    end

    def as_o
      @value.as(GObject)
    end

    def as_enum(cls : Enum.class)
      cls.from_value(as_i32)
    end
  end

  # :nodoc:
  class Optional
    def initialize(**opts)
      @val = Hash(String, Type).new
      opts.each do |k, v|
        # ignore nil values
        next if v.nil?

        if v.is_a?(Enum)
          v = v.value
        end
        @val[k.to_s] = Type.new(v)
      end
    end

    def []=(key : String, value)
      if value.is_a?(Enums::FailOn)
        Enums.add_failon(self, value)
      elsif value.is_a?(Type)
        @val[key] = value
      else
        @val[key] = Type.new(value)
      end
    end

    forward_missing_to @val
  end
end

Vips.init
