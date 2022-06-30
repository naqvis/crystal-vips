require "./lib"

# `Stats` module provides the statistics of memory usage and opened files.
# libvips watches the total amount of live tracked memory and
# uses this information to decide when to trim caches.
module Vips
  module Stats
    extend self

    # Get the number of active allocations.
    def allocations : Int
      LibVips.vips_tracked_get_allocs
    end

    # Get the number of bytes currently allocated `vips_malloc()` and friends.
    # libvips uses this figure to decide when to start dropping cache.
    def mem : Int
      LibVips.vips_tracked_get_mem
    end

    # Returns the largest number of bytes simultaneously allocated via vips_tracked_malloc().
    # Handy for estimating max memory requirements for a program.
    def mem_highwater : Int
      LibVips.vips_tracked_get_mem_highwater
    end

    # Get the number of open files.
    def open_files : Int
      LibVips.vips_tracked_get_files
    end
  end
end
