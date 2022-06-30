module Vips
  class GObject
    protected def initialize(@handle : LibVips::GObject*)
    end

    # Connects a `callback` to a signal on this object.
    # The callback will be triggered every time this signal is issued on this instance.
    def signal_connect(signal : String, callback : Proc, data : Pointer(Void) = Pointer(Void).null) : LibVips::Gulong
      if (cb = callback.as?(Image::EvalProc))
        em = LibVips::EvalSignal.new { |imgptr, progressptr, data|
          next if imgptr.null? || progressptr.null?
          img = Image.new(imgptr)
          progress = progressptr.value
          cb.call(img, progress)
        }
        callback = em
      end

      box = Box.box(callback)
      CBHandler.register(box)
      LibVips.g_signal_connect_data(@handle, signal,
        callback.pointer,
        data,
        ->CBHandler.de_register, LibVips::GConnectFlags::GConnectAfter).tap do |ret|
        raise VipsException.new("Couldn't connect signal #{signal}") if ret == 0
      end
    end

    # Disconnects a handler from this object
    def signal_disconnect(handler_id : LibVips::Gulong)
      LibVips.g_signal_handler_disconnect(@handle, handler_id) unless handler_id == 0
    end

    # Disconnects all handlers from this object that match `func` and `data`
    def signal_disconnect(func : Proc, data : Void* = Pointer(Void).null)
      LibVips.g_signal_handlers_disconnect_matched(@handle,
        LibVips::GSignalMatchType::GSignalMatchFunc |
        LibVips::GSignalMatchType::GSignalMatchData,
        0, 0, Pointer(LibVips::GClosure).null, nil, data)
    end

    # Disconnects all handlers from this object that match
    def signal_disconnect(data : LibVips::Gpointer)
      LibVips.g_signal_handlers_disconnect_matched(@handle,
        LibVips::GSignalMatchType::GSignalMatchData,
        0, 0, Pointer(LibVips::GClosure).null, nil, data)
    end

    # Decreases the reference count of object.
    # When its reference count drops to 0, its memory is freed.
    def release_handle
      LibVips.g_object_unref(@handle) unless @handle.null?
      true
    end

    # Increases the reference count of object
    def object_ref
      LibVips.g_object_ref(@handle)
    end

    # Get the reference count of object.
    def ref_count
      @handle.value.ref_count
    end

    def get(name : String, gval : GValue)
      LibVips.g_object_get_property(@handle, name, gval)
      gval.get
    end

    def set(name : String, gval : GValue)
      LibVips.g_object_set_property(@handle, name, gval)
    end

    # :nodoc:
    def handle
      @handle
    end

    # :nodoc:
    private class CBHandler
      def self.instance
        @@instance ||= new
      end

      def initialize
        @closure_data = Hash(LibVips::Gpointer, Int32).new { |h, k| h[k] = 0 }
      end

      def self.register(data)
        instance.register(data)
      end

      def self.de_register(data, _closure)
        instance.de_register(data)
      end

      def register(data)
        @closure_data[data] += 1 if data
        data
      end

      def de_register(data)
        @closure_data[data] -= 1
        if @closure_data[data] <= 0
          @closure_data.delete(data)
        end
      end
    end
  end
end
