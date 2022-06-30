module Vips::Cache
  # Gets the maximum number of operations libvips keep in cache
  def self.max : Int32
    LibVips.vips_cache_get_max
  end

  # Sets the maximum number of operations libvips keep in cache
  def self.max=(value : Int32)
    LibVips.vips_cache_set_max(value)
  end

  # Gets the maximum amount of tracked memory allowed.
  def self.max_mem
    LibVips.vips_cache_get_max_mem
  end

  # Sets the maximum amount of tracked memory allowed.
  def self.max_mem=(value : LibC::SizeT)
    LibVips.vips_cache_set_max_mem(value)
  end

  # Gets the maximum amount of tracked files allowed.
  def self.max_files
    LibVips.vips_cache_get_max_files
  end

  # Sets the maximum amount of tracked files allowed.
  def self.max_files=(value : Int32)
    LibVips.vips_cache_set_max_files(value)
  end

  # Gets the current number of operations in cache.
  def self.size
    LibVips.vips_cache_get_size
  end

  # Enable or disable libvips cache tracing.
  def self.trace=(value : Bool)
    LibVips.vips_cache_set_trace(value)
  end
end
