@[Link("vips")]
lib LibVips
  alias Gint = LibC::Int
  alias Gboolean = Gint
  alias VaList = LibC::VaList

  alias Gsize = LibC::ULong
  alias GType = Gsize
  alias Guint = LibC::UInt
  alias Glong = LibC::Long
  alias Gulong = LibC::ULong
  alias Gint64 = LibC::LongLong
  alias Guint64 = LibC::ULongLong
  alias Gfloat = LibC::Float
  alias Gdouble = LibC::Double
  alias Gpointer = Void*
  alias OffT = LibC::LongLong
  alias Guint32 = LibC::UInt

  struct VipsBuf
    base : LibC::Char*
    mx : LibC::Int
    i : LibC::Int
    full : Gboolean
    lasti : LibC::Int
    dynamic : Gboolean
  end

  struct GValue
    g_type : GType
    data : GValueData[2]
  end

  fun g_value_init(value : GValue*, g_type : GType) : GValue*
  fun g_value_unset(value : GValue*)
  fun g_value_set_boolean(value : GValue*, v_boolean : Gboolean)
  fun g_value_get_boolean(value : GValue*) : Gboolean
  fun g_value_set_int(value : GValue*, v_int : Gint)
  fun g_value_get_int(value : GValue*) : Gint
  fun g_value_set_uint64(value : GValue*, v_uint64 : Guint64)
  fun g_value_get_uint64(value : GValue*) : Guint64
  fun g_value_set_double(value : GValue*, v_double : Gdouble)
  fun g_value_get_double(value : GValue*) : Gdouble
  fun g_value_set_string(value : GValue*, v_string : Gchar*)
  fun g_value_get_string(value : GValue*) : Gchar*

  fun g_value_set_enum(value : GValue*, v_enum : Gint)
  fun g_value_get_enum(value : GValue*) : Gint

  fun g_value_set_flags(value : GValue*, v_flags : Gint)
  fun g_value_get_flags(value : GValue*) : Gint
  fun g_value_set_object(value : GValue*, object : Gpointer)
  fun g_value_get_object(value : GValue*) : Gpointer

  fun g_value_set_boxed(value : GValue*, object : Gpointer)

  union GValueData
    v_int : Gint
    v_uint : Guint
    v_long : Glong
    v_ulong : Gulong
    v_int64 : Gint64
    v_uint64 : Guint64
    v_float : Gfloat
    v_double : Gdouble
    v_pointer : Gpointer
  end

  fun vips_path_filename7(path : LibC::Char*) : LibC::Char*
  fun vips_path_mode7(path : LibC::Char*) : LibC::Char*
  fun vips_buf_rewind(buf : VipsBuf*)

  fun vips_buf_destroy(buf : VipsBuf*)
  fun vips_buf_init(buf : VipsBuf*)
  fun vips_buf_set_static(buf : VipsBuf*, base : LibC::Char*, mx : LibC::Int)
  fun vips_buf_set_dynamic(buf : VipsBuf*, mx : LibC::Int)
  fun vips_buf_init_static(buf : VipsBuf*, base : LibC::Char*, mx : LibC::Int)
  fun vips_buf_init_dynamic(buf : VipsBuf*, mx : LibC::Int)
  fun vips_buf_appendns(buf : VipsBuf*, str : LibC::Char*, sz : LibC::Int) : Gboolean
  fun vips_buf_appends(buf : VipsBuf*, str : LibC::Char*) : Gboolean
  fun vips_buf_appendf(buf : VipsBuf*, fmt : LibC::Char*, ...) : Gboolean
  fun vips_buf_vappendf(buf : VipsBuf*, fmt : LibC::Char*, ap : VaList) : Gboolean

  fun vips_buf_appendc(buf : VipsBuf*, ch : LibC::Char) : Gboolean
  fun vips_buf_appendsc(buf : VipsBuf*, quote : Gboolean, str : LibC::Char*) : Gboolean
  fun vips_buf_appendgv(buf : VipsBuf*, value : GValue*) : Gboolean

  fun vips_buf_append_size(buf : VipsBuf*, n : LibC::SizeT) : Gboolean
  fun vips_buf_removec(buf : VipsBuf*, ch : LibC::Char) : Gboolean
  fun vips_buf_change(buf : VipsBuf*, o : LibC::Char*, n : LibC::Char*) : Gboolean
  fun vips_buf_is_empty(buf : VipsBuf*) : Gboolean
  fun vips_buf_is_full(buf : VipsBuf*) : Gboolean
  fun vips_buf_all(buf : VipsBuf*) : LibC::Char*
  fun vips_buf_firstline(buf : VipsBuf*) : LibC::Char*
  fun vips_buf_appendg(buf : VipsBuf*, g : LibC::Double) : Gboolean
  fun vips_buf_appendd(buf : VipsBuf*, d : LibC::Int) : Gboolean
  fun vips_buf_len(buf : VipsBuf*) : LibC::Int
  fun vips_dbuf_destroy(dbuf : VipsDbuf*)

  struct VipsDbuf
    data : UInt8*
    allocated_size : LibC::SizeT
    data_size : LibC::SizeT
    write_point : LibC::SizeT
  end

  fun vips_dbuf_init(dbuf : VipsDbuf*)
  fun vips_dbuf_allocate(dbuf : VipsDbuf*, size : LibC::SizeT) : Gboolean
  fun vips_dbuf_read(dbuf : VipsDbuf*, data : UInt8*, size : LibC::SizeT) : LibC::SizeT
  fun vips_dbuf_get_write(dbuf : VipsDbuf*, size : LibC::SizeT*) : UInt8*
  fun vips_dbuf_write(dbuf : VipsDbuf*, data : UInt8*, size : LibC::SizeT) : Gboolean
  fun vips_dbuf_writef(dbuf : VipsDbuf*, fmt : LibC::Char*, ...) : Gboolean
  fun vips_dbuf_write_amp(dbuf : VipsDbuf*, str : LibC::Char*) : Gboolean
  fun vips_dbuf_reset(dbuf : VipsDbuf*)
  fun vips_dbuf_destroy(dbuf : VipsDbuf*)
  fun vips_dbuf_seek(dbuf : VipsDbuf*, offset : OffT, whence : LibC::Int) : Gboolean

  fun vips_dbuf_truncate(dbuf : VipsDbuf*)
  fun vips_dbuf_tell(dbuf : VipsDbuf*) : OffT
  fun vips_dbuf_string(dbuf : VipsDbuf*, size : LibC::SizeT*) : UInt8*
  fun vips_dbuf_steal(dbuf : VipsDbuf*, size : LibC::SizeT*) : UInt8*
  fun vips_enum_string(enm : GType, value : LibC::Int) : LibC::Char*
  fun vips_enum_nick(enm : GType, value : LibC::Int) : LibC::Char*
  fun vips_enum_from_nick(domain : LibC::Char*, type : GType, str : LibC::Char*) : LibC::Int
  fun vips_flags_from_nick(domain : LibC::Char*, type : GType, nick : LibC::Char*) : LibC::Int
  fun vips_slist_equal(l1 : GsList*, l2 : GsList*) : Gboolean

  struct GsList
    data : Gpointer
    next : GsList*
  end

  fun vips_slist_map2(list : GsList*, fn : VipsSListMap2Fn, a : Void*, b : Void*) : Void*
  alias VipsSListMap2Fn = (Void*, Void*, Void* -> Void*)
  fun vips_slist_map2_rev(list : GsList*, fn : VipsSListMap2Fn, a : Void*, b : Void*) : Void*
  fun vips_slist_map4(list : GsList*, fn : VipsSListMap4Fn, a : Void*, b : Void*, c : Void*, d : Void*) : Void*
  alias VipsSListMap4Fn = (Void*, Void*, Void*, Void*, Void* -> Void*)
  fun vips_slist_fold2(list : GsList*, start : Void*, fn : VipsSListFold2Fn, a : Void*, b : Void*) : Void*
  alias VipsSListFold2Fn = (Void*, Void*, Void*, Void* -> Void*)
  fun vips_slist_filter(list : GsList*, fn : VipsSListMap2Fn, a : Void*, b : Void*) : GsList*
  fun vips_slist_free_all(list : GsList*)
  fun vips_map_equal(a : Void*, b : Void*) : Void*
  fun vips_hash_table_map(hash : GHashTable, fn : VipsSListMap2Fn, a : Void*, b : Void*) : Void*
  type GHashTable = Void*
  fun vips_strncpy(dest : LibC::Char*, src : LibC::Char*, n : LibC::Int) : LibC::Char*
  fun vips_strrstr(haystack : LibC::Char*, needle : LibC::Char*) : LibC::Char*
  fun vips_ispostfix(a : LibC::Char*, b : LibC::Char*) : Gboolean
  fun vips_iscasepostfix(a : LibC::Char*, b : LibC::Char*) : Gboolean
  fun vips_isprefix(a : LibC::Char*, b : LibC::Char*) : Gboolean
  fun vips_break_token(str : LibC::Char*, brk : LibC::Char*) : LibC::Char*
  fun vips__chomp(str : LibC::Char*)
  fun vips_vsnprintf(str : LibC::Char*, size : LibC::SizeT, format : LibC::Char*, ap : VaList) : LibC::Int
  fun vips_snprintf(str : LibC::Char*, size : LibC::SizeT, format : LibC::Char*, ...) : LibC::Int
  fun vips_filename_suffix_match(path : LibC::Char*, suffixes : LibC::Char**) : LibC::Int
  fun vips_file_length(fd : LibC::Int) : Gint64
  fun vips__write(fd : LibC::Int, buf : Void*, count : LibC::SizeT) : LibC::Int
  fun vips__open(filename : LibC::Char*, flags : LibC::Int, mode : LibC::Int) : LibC::Int
  fun vips__open_read(filename : LibC::Char*) : LibC::Int
  fun vips__fopen(filename : LibC::Char*, mode : LibC::Char*) : File*

  struct File
    _p : UInt8*
    _r : LibC::Int
    _w : LibC::Int
    _flags : LibC::Short
    _file : LibC::Short
    _bf : X__Sbuf
    _lbfsize : LibC::Int
    _cookie : Void*
    _close : (Void* -> LibC::Int)
    _read : (Void*, LibC::Char*, LibC::Int -> LibC::Int)
    _seek : (Void*, OffT, LibC::Int -> OffT)
    _write : (Void*, LibC::Char*, LibC::Int -> LibC::Int)
    _ub : X__Sbuf
    _extra : Void*
    _ur : LibC::Int
    _ubuf : UInt8[3]
    _nbuf : UInt8[1]
    _lb : X__Sbuf
    _blksize : LibC::Int
    _offset : OffT
  end

  struct X__Sbuf
    _base : UInt8*
    _size : LibC::Int
  end

  fun vips__file_open_read(filename : LibC::Char*, fallback_dir : LibC::Char*, text_mode : Gboolean) : File*
  fun vips__file_open_write(filename : LibC::Char*, text_mode : Gboolean) : File*
  fun vips__file_read(fp : File*, name : LibC::Char*, length_out : LibC::SizeT*) : LibC::Char*
  fun vips__file_read_name(name : LibC::Char*, fallback_dir : LibC::Char*, length_out : LibC::SizeT*) : LibC::Char*
  fun vips__file_write(data : Void*, size : LibC::SizeT, nmemb : LibC::SizeT, stream : File*) : LibC::Int
  fun vips__get_bytes(filename : LibC::Char*, buf : UInt8*, len : Gint64) : Gint64
  fun vips__fgetc(fp : File*) : LibC::Int
  fun vips__gvalue_ref_string_new(text : LibC::Char*) : GValue*
  fun vips__gslist_gvalue_free(list : GsList*)
  fun vips__gslist_gvalue_copy(list : GsList*) : GsList*
  fun vips__gslist_gvalue_merge(a : GsList*, b : GsList*) : GsList*
  fun vips__gslist_gvalue_get(list : GsList*) : LibC::Char*
  fun vips__seek_no_error(fd : LibC::Int, pos : Gint64, whence : LibC::Int) : Gint64
  fun vips__seek(fd : LibC::Int, pos : Gint64, whence : LibC::Int) : Gint64
  fun vips__ftruncate(fd : LibC::Int, pos : Gint64) : LibC::Int
  fun vips_existsf(name : LibC::Char*, ...) : LibC::Int
  fun vips_isdirf(name : LibC::Char*, ...) : LibC::Int
  fun vips_mkdirf(name : LibC::Char*, ...) : LibC::Int
  fun vips_rmdirf(name : LibC::Char*, ...) : LibC::Int
  fun vips_rename(old_name : LibC::Char*, new_name : LibC::Char*) : LibC::Int

  fun vips__token_get(buffer : LibC::Char*, token : VipsToken*, string : LibC::Char*, size : LibC::Int) : LibC::Char*
  enum VipsToken
    VipsTokenLeft   = 1
    VipsTokenRight  = 2
    VipsTokenString = 3
    VipsTokenEquals = 4
    VipsTokenComma  = 5
  end
  fun vips__token_must(buffer : LibC::Char*, token : VipsToken*, string : LibC::Char*, size : LibC::Int) : LibC::Char*
  fun vips__token_need(buffer : LibC::Char*, need_token : VipsToken, string : LibC::Char*, size : LibC::Int) : LibC::Char*
  fun vips__token_segment(p : LibC::Char*, token : VipsToken*, string : LibC::Char*, size : LibC::Int) : LibC::Char*
  fun vips__token_segment_need(p : LibC::Char*, need_token : VipsToken, string : LibC::Char*, size : LibC::Int) : LibC::Char*
  fun vips__find_rightmost_brackets(p : LibC::Char*) : LibC::Char*
  fun vips__filename_split8(name : LibC::Char*, filename : LibC::Char*, option_string : LibC::Char*)
  fun vips_ispoweroftwo(p : LibC::Int) : LibC::Int
  fun vips_ami_ms_bfirst = vips_amiMSBfirst : LibC::Int
  fun vips__temp_name(format : LibC::Char*) : LibC::Char*
  fun vips__change_suffix(name : LibC::Char*, out : LibC::Char*, mx : LibC::Int, new_suff : LibC::Char*, olds : LibC::Char**, nolds : LibC::Int)
  fun vips_realpath(path : LibC::Char*) : LibC::Char*
  fun vips__random(seed : Guint32) : Guint32

  fun vips__random_add(seed : Guint32, value : LibC::Int) : Guint32
  fun vips__icc_dir : LibC::Char*
  fun vips__windows_prefix : LibC::Char*
  fun vips__get_iso8601 : LibC::Char*
  fun vips_strtod(str : LibC::Char*, out : LibC::Double*) : LibC::Int

  fun vips_argument_get_id : LibC::Int
  fun vips__object_set_member(object : VipsObject*, pspec : GParamSpec*, member : GObject**, argument : GObject*)

  struct VipsObject
    parent_instance : GObject
    constructed : Gboolean
    static_object : Gboolean
    argument_table : VipsArgumentTable*
    nickname : LibC::Char*
    description : LibC::Char*
    preclose : Gboolean
    close : Gboolean
    postclose : Gboolean
    local_memory : LibC::SizeT
  end

  struct GObject
    g_type_instance : GTypeInstance
    ref_count : Guint
    qdata : GData
  end

  alias GWeakNotify = (Gpointer, GObject* ->)

  fun g_object_set_property(obj : GObject*, property_name : Gchar*, value : GValue*)
  fun g_object_get_property(obj : GObject*, property_name : Gchar*, value : GValue*)
  fun g_object_ref(obj : Gpointer) : Gpointer
  fun g_object_unref(obj : Gpointer)
  fun g_object_weak_ref(obj : GObject*, notify : GWeakNotify)

  struct GEnumValue
    value : LibC::Int
    value_name : LibC::Char*
    value_nick : LibC::Char*
  end

  struct GEnumClass
    g_type_class : GTypeClass*
    minimum : Gint
    maximum : Gint
    n_values : Guint
    values : GEnumValue**
  end

  fun g_type_name(type : GType) : Gchar*
  fun g_type_from_name(name : Gchar*) : GType
  fun g_type_fundamental(type_id : GType) : GType
  fun g_type_class_ref(type : GType) : Gpointer

  struct GTypeInstance
    g_class : GTypeClass*
  end

  struct GTypeClass
    g_type : GType
  end

  type GData = Void*
  alias VipsArgumentTable = Void

  struct GParamSpec
    g_type_instance : GTypeInstance
    name : Gchar*
    flags : GParamFlags
    value_type : GType
    owner_type : GType
    _nick : Gchar*
    _blurb : Gchar*
    qdata : GData
    ref_count : Guint
    param_id : Guint
  end

  fun g_param_spec_get_blurb(spec : GParamSpec) : Gchar*

  alias Gchar = LibC::Char
  enum GParamFlags
    GParamReadable       =  1
    GParamWritable       =  2
    GParamReadwrite      =  3
    GParamConstruct      =  4
    GParamConstructOnly  =  8
    GParamLaxValidation  = 16
    GParamStaticName     = 32
    GParamPrivate        = GParamStaticName
    GParamStaticNick     =          64
    GParamStaticBlurb    =         128
    GParamExplicitNotify =  1073741824
    GParamDeprecated     = -2147483648
  end
  fun vips_argument_map(object : VipsObject*, fn : VipsArgumentMapFn, a : Void*, b : Void*) : Void*

  struct VipsArgumentClass
    parent : VipsArgument
    object_class : VipsObjectClass*
    flags : VipsArgumentFlags
    priority : LibC::Int
    offset : Guint
  end

  struct VipsArgumentInstance
    parent : VipsArgument
    argument_class : VipsArgumentClass*
    object : VipsObject*
    assigned : Gboolean
    close_id : Gulong
    invalidate_id : Gulong
  end

  alias VipsArgumentMapFn = (VipsObject*, GParamSpec*, VipsArgumentClass*, VipsArgumentInstance*, Void*, Void* -> Void*)

  struct VipsArgument
    pspec : GParamSpec*
  end

  struct VipsObjectClass
    parent_class : GObjectClass
    build : (VipsObject* -> LibC::Int)
    postbuild : (VipsObject*, Void* -> LibC::Int)
    summary_class : (VipsObjectClass*, VipsBuf* -> Void)
    summary : (VipsObject*, VipsBuf* -> Void)
    dump : (VipsObject*, VipsBuf* -> Void)
    sanity : (VipsObject*, VipsBuf* -> Void)
    rewind : (VipsObject* -> Void)
    preclose : (VipsObject* -> Void)
    close : (VipsObject* -> Void)
    postclose : (VipsObject* -> Void)
    new_from_string : (LibC::Char* -> VipsObject*)
    to_string : (VipsObject*, VipsBuf* -> Void)
    output_needs_arg : Gboolean
    output_to_arg : (VipsObject*, LibC::Char* -> LibC::Int)
    nickname : LibC::Char*
    description : LibC::Char*
    argument_table : VipsArgumentTable*
    argument_table_traverse : GsList*
    argument_table_traverse_gtype : GType
    deprecated : Gboolean
    _vips_reserved1 : (-> Void)
    _vips_reserved2 : (-> Void)
    _vips_reserved3 : (-> Void)
    _vips_reserved4 : (-> Void)
  end

  struct GObjectClass
    g_type_class : GTypeClass
    construct_properties : GsList*
    constructor : (GType, Guint, GObjectConstructParam* -> GObject*)
    set_property : (GObject*, Guint, GValue*, GParamSpec* -> Void)
    get_property : (GObject*, Guint, GValue*, GParamSpec* -> Void)
    dispose : (GObject* -> Void)
    finalize : (GObject* -> Void)
    dispatch_properties_changed : (GObject*, Guint, GParamSpec** -> Void)
    notify : (GObject*, GParamSpec* -> Void)
    constructed : (GObject* -> Void)
    flags : Gsize
    pdummy : Gpointer[6]
  end

  struct GObjectConstructParam
    pspec : GParamSpec*
    value : GValue*
  end

  alias GCallback = (->)

  enum GConnectFlags
    GConnectAfter   = 1
    GConnectSwapped = 2
  end

  struct GClosure
    ref_count : Guint
    meta_marshal_nouse : Guint
    n_guards : Guint
    n_fnotifiers : Guint
    n_inotifiers : Guint
    in_inotify : Guint
    floating : Guint
    derivative_flag : Guint
    in_marshal : Guint
    is_invalid : Guint
    marshal : (GClosure*, GValue*, Guint, GValue*, Gpointer, Gpointer -> Void)
    data : Gpointer
    notifiers : GClosureNotifyData*
  end

  alias GClosureNotify = (Gpointer, GClosure* -> Void)

  struct GClosureNotifyData
    data : Gpointer
    notify : GClosureNotify
  end

  enum GSignalMatchType
    GSignalMatchId        =  1
    GSignalMatchDetail    =  2
    GSignalMatchClosure   =  4
    GSignalMatchFunc      =  8
    GSignalMatchData      = 16
    GSignalMatchUnblocked = 32
  end

  fun g_signal_connect_data1(instance : Gpointer, detailed_signal : Gchar*,
                             c_handler : GCallback, data : Gpointer, destroy_data : GClosureNotify,
                             connect_flags : GConnectFlags) : Gulong

  fun g_signal_connect_data(instance : Gpointer, detailed_signal : Gchar*,
                            c_handler : Void*, data : Gpointer, destroy_data : GClosureNotify,
                            connect_flags : GConnectFlags) : Gulong

  fun g_signal_handler_disconnect(instance : Gpointer, handler_id : Gulong)

  fun g_signal_handlers_disconnect_matched(instance : Gpointer, mask : GSignalMatchType, signal_id : Guint,
                                           detail : Guint, closure : GClosure*, func : Gpointer, data : Gpointer) : Guint

  fun g_free(mem : Gpointer)
  fun g_malloc(n_bytes : Gsize) : Gpointer

  fun g_log_set_handler(log_domain : Gchar*, log_levels : GLogLevelFlags, log_func : GLogFunc, user_data : Gpointer) : Guint
  fun g_log_remove_handler(log_domain : Gchar*, handler_id : Guint)
  fun g_log_set_always_fatal(fatal_mask : GLogLevelFlags) : GLogLevelFlags
  fun g_log_set_fatal_mask(log_domain : Gchar*, fatal_mask : GLogLevelFlags) : GLogLevelFlags

  @[Flags]
  enum GLogLevelFlags
    GLogFlagRecursion =   1
    GLogFlagFatal     =   2
    GLogLevelError    =   4
    GLogLevelCritical =   8
    GLogLevelWarning  =  16
    GLogLevelMessage  =  32
    GLogLevelInfo     =  64
    GLogLevelDebug    = 128
    GLogLevelMask     =  -4
  end
  alias GLogFunc = (Gchar*, GLogLevelFlags, Gchar*, Gpointer -> Void)

  @[Flags]
  enum VipsArgumentFlags
    Required   =   1
    Construct  =   2
    SetOnce    =   4
    SetAlways  =   8
    Input      =  16
    Output     =  32
    Deprecated =  64
    Modify     = 128
  end
  fun vips_object_get_args(object : VipsObject*, names : LibC::Char***, flags : LibC::Int**, n_args : LibC::Int*) : LibC::Int
  fun vips_argument_class_map(object_class : VipsObjectClass*, fn : VipsArgumentClassMapFn, a : Void*, b : Void*) : Void*
  alias VipsArgumentClassMapFn = (VipsObjectClass*, GParamSpec*, VipsArgumentClass*, Void*, Void* -> Void*)
  fun vips_argument_class_needsstring(argument_class : VipsArgumentClass*) : Gboolean
  fun vips_object_get_argument(object : VipsObject*, name : LibC::Char*, pspec : GParamSpec**, argument_class : VipsArgumentClass**, argument_instance : VipsArgumentInstance**) : LibC::Int
  fun vips_object_argument_isset(object : VipsObject*, name : LibC::Char*) : Gboolean
  fun vips_object_get_argument_flags(object : VipsObject*, name : LibC::Char*) : VipsArgumentFlags
  fun vips_object_get_argument_priority(object : VipsObject*, name : LibC::Char*) : LibC::Int
  fun vips_value_is_null(psoec : GParamSpec*, value : GValue*) : Gboolean
  fun vips_object_set_property(gobject : GObject*, property_id : Guint, value : GValue*, pspec : GParamSpec*)
  fun vips_object_get_property(gobject : GObject*, property_id : Guint, value : GValue*, pspec : GParamSpec*)
  fun vips_object_preclose(object : VipsObject*)
  fun vips_object_build(object : VipsObject*) : LibC::Int
  fun vips_object_summary_class(klass : VipsObjectClass*, buf : VipsBuf*)
  fun vips_object_summary(object : VipsObject*, buf : VipsBuf*)
  fun vips_object_dump(object : VipsObject*, buf : VipsBuf*)
  fun vips_object_print_summary_class(klass : VipsObjectClass*)
  fun vips_object_print_summary(object : VipsObject*)
  fun vips_object_print_dump(object : VipsObject*)
  fun vips_object_print_name(object : VipsObject*)
  fun vips_object_sanity(object : VipsObject*) : Gboolean
  fun vips_object_get_type : GType
  fun vips_object_class_install_argument(cls : VipsObjectClass*, pspec : GParamSpec*, flags : VipsArgumentFlags, priority : LibC::Int, offset : Guint)
  fun vips_object_set_argument_from_string(object : VipsObject*, name : LibC::Char*, value : LibC::Char*) : LibC::Int
  fun vips_object_argument_needsstring(object : VipsObject*, name : LibC::Char*) : Gboolean
  fun vips_object_get_argument_to_string(object : VipsObject*, name : LibC::Char*, arg : LibC::Char*) : LibC::Int
  fun vips_object_set_required(object : VipsObject*, value : LibC::Char*) : LibC::Int
  fun vips_object_new(type : GType, set : VipsObjectSetArguments, a : Void*, b : Void*) : VipsObject*
  alias VipsObjectSetArguments = (VipsObject*, Void*, Void* -> Void*)
  fun vips_object_set_valist(object : VipsObject*, ap : VaList) : LibC::Int
  fun vips_object_set(object : VipsObject*, ...) : LibC::Int
  fun vips_object_set_from_string(object : VipsObject*, string : LibC::Char*) : LibC::Int
  fun vips_object_new_from_string(object_class : VipsObjectClass*, p : LibC::Char*) : VipsObject*
  fun vips_object_to_string(object : VipsObject*, buf : VipsBuf*)
  fun vips_object_map(fn : VipsSListMap2Fn, a : Void*, b : Void*) : Void*
  fun vips_type_map(base : GType, fn : VipsTypeMap2Fn, a : Void*, b : Void*) : Void*
  alias VipsTypeMap2Fn = (GType, Void*, Void* -> Void*)
  fun vips_type_map_all(base : GType, fn : VipsTypeMapFn, a : Void*) : Void*
  alias VipsTypeMapFn = (GType, Void* -> Void*)
  fun vips_type_depth(type : GType) : LibC::Int
  fun vips_type_find(basename : LibC::Char*, nickname : LibC::Char*) : GType
  fun vips_nickname_find(type : GType) : LibC::Char*
  fun vips_class_map_all(type : GType, fn : VipsClassMapFn, a : Void*) : Void*
  alias VipsClassMapFn = (VipsObjectClass*, Void* -> Void*)
  fun vips_class_find(basename : LibC::Char*, nickname : LibC::Char*) : VipsObjectClass*
  fun vips_object_local_array(parent : VipsObject*, n : LibC::Int) : VipsObject**
  fun vips_object_local_cb(vobject : VipsObject*, gobject : GObject*)
  fun vips_object_set_static(object : VipsObject*, static_object : Gboolean)
  fun vips_object_print_all
  fun vips_object_sanity_all
  fun vips_object_rewind(object : VipsObject*)
  fun vips_object_unref_outputs(object : VipsObject*)
  fun vips_object_get_description(object : VipsObject*) : LibC::Char*
  fun vips_thing_get_type : GType
  fun vips_thing_new(i : LibC::Int) : VipsThing*

  struct VipsThing
    i : LibC::Int
  end

  fun vips_area_copy(area : VipsArea*) : VipsArea*

  struct VipsArea
    data : Void*
    length : LibC::SizeT
    n : LibC::Int
    count : LibC::Int
    lock : GMutex*
    free_fn : VipsCallbackFn
    client : Void*
    type : GType
    sizeof_type : LibC::SizeT
  end

  union GMutex
    p : Gpointer
    i : Guint[2]
  end

  alias VipsCallbackFn = (Void*, Void* -> LibC::Int)
  fun vips_area_free_cb(mem : Void*, area : VipsArea*) : LibC::Int
  fun vips_area_unref(area : VipsArea*)
  fun vips_area_new(free_fn : VipsCallbackFn, data : Void*) : VipsArea*
  fun vips_area_new_array(type : GType, sizeof_type : LibC::SizeT, n : LibC::Int) : VipsArea*
  fun vips_area_new_array_object(n : LibC::Int) : VipsArea*
  fun vips_area_get_data(area : VipsArea*, length : LibC::SizeT*, n : LibC::Int*, type : GType*, sizeof_type : LibC::SizeT*) : Void*
  fun vips_area_get_type : GType
  fun vips_save_string_get_type : GType
  fun vips_ref_string_new(str : LibC::Char*) : VipsRefString*

  struct VipsRefString
    area : VipsArea
  end

  fun vips_ref_string_get(refstr : VipsRefString*, length : LibC::SizeT*) : LibC::Char*
  fun vips_ref_string_get_type : GType
  fun vips_blob_new(free_fn : VipsCallbackFn, data : Void*, length : LibC::SizeT) : VipsBlob*

  struct VipsBlob
    area : VipsArea
  end

  fun vips_blob_copy(data : Void*, length : LibC::SizeT) : VipsBlob*
  fun vips_blob_get(blob : VipsBlob*, length : LibC::SizeT*) : Void*
  fun vips_blob_set(blob : VipsBlob*, free_fn : VipsCallbackFn, data : Void*, length : LibC::SizeT)
  fun vips_blob_get_type : GType
  fun vips_array_double_new(array : LibC::Double*, n : LibC::Int) : VipsArrayDouble*

  struct VipsArrayDouble
    area : VipsArea
  end

  fun vips_array_double_newv(n : LibC::Int, ...) : VipsArrayDouble*
  fun vips_array_double_get(array : VipsArrayDouble*, n : LibC::Int*) : LibC::Double*
  fun vips_array_double_get_type : GType
  fun vips_array_int_new(array : LibC::Int*, n : LibC::Int) : VipsArrayInt*

  struct VipsArrayInt
    area : VipsArea
  end

  fun vips_array_int_newv(n : LibC::Int, ...) : VipsArrayInt*
  fun vips_array_int_get(array : VipsArrayInt*, n : LibC::Int*) : LibC::Int*
  fun vips_array_int_get_type : GType
  fun vips_array_image_get_type : GType
  fun vips_value_set_area(value : GValue*, free_fn : VipsCallbackFn, data : Void*)
  fun vips_value_get_area(value : GValue*, length : LibC::SizeT*) : Void*
  fun vips_value_get_save_string(value : GValue*) : LibC::Char*
  fun vips_value_set_save_string(value : GValue*, str : LibC::Char*)
  fun vips_value_set_save_stringf(value : GValue*, fmt : LibC::Char*, ...)
  fun vips_value_get_ref_string(value : GValue*, length : LibC::SizeT*) : LibC::Char*
  fun vips_value_set_ref_string(value : GValue*, str : LibC::Char*)
  fun vips_value_get_blob(value : GValue*, length : LibC::SizeT*) : Void*
  fun vips_value_set_blob(value : GValue*, free_fn : VipsCallbackFn, data : Void*, length : LibC::SizeT)
  fun vips_value_set_blob_free(value : GValue*, data : Void*, length : LibC::SizeT)
  fun vips_value_set_array(value : GValue*, n : LibC::Int, type : GType, sizeof_type : LibC::SizeT)
  fun vips_value_get_array(value : GValue*, n : LibC::Int*, type : GType*, sizeof_type : LibC::SizeT*) : Void*
  fun vips_value_get_array_double(value : GValue*, n : LibC::Int*) : LibC::Double*
  fun vips_value_set_array_double(value : GValue*, array : LibC::Double*, n : LibC::Int)
  fun vips_value_get_array_int(value : GValue*, n : LibC::Int*) : LibC::Int*
  fun vips_value_set_array_int(value : GValue*, array : LibC::Int*, n : LibC::Int)
  fun vips_value_get_array_object(value : GValue*, n : LibC::Int*) : GObject**
  fun vips_value_set_array_object(value : GValue*, n : LibC::Int)
  fun vips_profile_set(profile : Gboolean)
  fun vips__thread_profile_attach(thread_name : LibC::Char*)
  fun vips__thread_profile_detach
  fun vips__thread_profile_stop
  fun vips__thread_gate_start(gate_name : LibC::Char*)
  fun vips__thread_gate_stop(gate_name : LibC::Char*)
  fun vips__thread_malloc_free(size : Gint64)
  fun vips_connection_get_type : GType
  fun vips_connection_filename(connection : VipsConnection*) : LibC::Char*

  struct VipsConnection
    parent_object : VipsObject
    descriptor : LibC::Int
    tracked_descriptor : LibC::Int
    close_descriptor : LibC::Int
    filename : LibC::Char*
  end

  fun vips_connection_nick(connection : VipsConnection*) : LibC::Char*
  fun vips_pipe_read_limit_set(limit : Gint64)
  fun vips_source_get_type : GType
  fun vips_source_new_from_descriptor(descriptor : LibC::Int) : VipsSource*

  struct VipsSource
    parent_object : VipsConnection
    decode : Gboolean
    have_tested_seek : Gboolean
    is_pipe : Gboolean
    read_position : Gint64
    length : Gint64
    data : Void*
    header_bytes : GByteArray*
    sniff : GByteArray*
    blob : VipsBlob*
    mmap_baseaddr : Void*
    mmap_length : LibC::SizeT
  end

  struct GByteArray
    data : Guint8*
    len : Guint
  end

  alias Guint8 = UInt8
  fun vips_source_new_from_file(filename : LibC::Char*) : VipsSource*
  fun vips_source_new_from_blob(blob : VipsBlob*) : VipsSource*
  fun vips_source_new_from_memory(data : Void*, size : LibC::SizeT) : VipsSource*
  fun vips_source_new_from_options(options : LibC::Char*) : VipsSource*
  fun vips_source_minimise(source : VipsSource*)
  fun vips_source_unminimise(source : VipsSource*) : LibC::Int
  fun vips_source_decode(source : VipsSource*) : LibC::Int
  fun vips_source_read(source : VipsSource*, data : Void*, length : LibC::SizeT) : Gint64
  fun vips_source_is_mappable(source : VipsSource*) : Gboolean
  fun vips_source_is_file(source : VipsSource*) : Gboolean
  fun vips_source_map(source : VipsSource*, length : LibC::SizeT*) : Void*
  fun vips_source_map_blob(source : VipsSource*) : VipsBlob*
  fun vips_source_seek(source : VipsSource*, offset : Gint64, whence : LibC::Int) : Gint64
  fun vips_source_rewind(source : VipsSource*) : LibC::Int
  fun vips_source_sniff_at_most(source : VipsSource*, data : UInt8**, length : LibC::SizeT) : Gint64
  fun vips_source_sniff(source : VipsSource*, length : LibC::SizeT) : UInt8*
  fun vips_source_length(source : VipsSource*) : Gint64
  fun vips_source_custom_get_type : GType
  fun vips_source_custom_new : VipsSourceCustom*

  struct VipsSourceCustom
    parent_object : VipsSource
  end

  fun vips_g_input_stream_new_from_source(source : VipsSource*) : GInputStream*

  struct GInputStream
    parent_instance : GObject
    priv : GInputStreamPrivate
  end

  type GInputStreamPrivate = Void*
  fun vips_source_g_input_stream_new(stream : GInputStream*) : VipsSourceGInputStream*

  struct VipsSourceGInputStream
    parent_instance : VipsSource
    stream : GInputStream*
    seekable : GSeekable
    info : GFileInfo
  end

  type GSeekable = Void*
  type GFileInfo = Void*
  fun vips_target_get_type : GType
  fun vips_target_new_to_descriptor(descriptor : LibC::Int) : VipsTarget*

  struct VipsTarget
    parent_object : VipsConnection
    memory : Gboolean
    finished : Gboolean
    memory_buffer : GByteArray*
    blob : VipsBlob*
    output_buffer : UInt8[8500]
    write_point : LibC::Int
  end

  fun vips_target_new_to_file(filename : LibC::Char*) : VipsTarget*
  fun vips_target_new_to_memory : VipsTarget*
  fun vips_target_write(target : VipsTarget*, data : Void*, length : LibC::SizeT) : LibC::Int
  fun vips_target_finish(target : VipsTarget*)
  fun vips_target_steal(target : VipsTarget*, length : LibC::SizeT*) : UInt8*
  fun vips_target_steal_text(target : VipsTarget*) : LibC::Char*
  fun vips_target_putc(target : VipsTarget*, ch : LibC::Int) : LibC::Int
  fun vips_target_writes(target : VipsTarget*, str : LibC::Char*) : LibC::Int
  fun vips_target_writef(target : VipsTarget*, fmt : LibC::Char*, ...) : LibC::Int
  fun vips_target_write_amp(target : VipsTarget*, str : LibC::Char*) : LibC::Int
  fun vips_target_custom_get_type : GType
  fun vips_target_custom_new : VipsTargetCustom*

  struct VipsTargetCustom
    parent_object : VipsTarget
  end

  fun vips_sbuf_get_type : GType
  fun vips_sbuf_new_from_source(source : VipsSource*) : VipsSbuf*

  struct VipsSbuf
    parent_object : VipsObject
    source : VipsSource*
    input_buffer : UInt8[4097]
    chars_in_buffer : LibC::Int
    read_point : LibC::Int
    line : UInt8[4097]
  end

  fun vips_sbuf_unbuffer(sbuf : VipsSbuf*)
  fun vips_sbuf_getc(sbuf : VipsSbuf*) : LibC::Int
  fun vips_sbuf_ungetc(sbuf : VipsSbuf*)
  fun vips_sbuf_require(sbuf : VipsSbuf*, require : LibC::Int) : LibC::Int
  fun vips_sbuf_get_line(sbuf : VipsSbuf*) : LibC::Char*
  fun vips_sbuf_get_line_copy(sbuf : VipsSbuf*) : LibC::Char*
  fun vips_sbuf_get_non_whitespace(sbuf : VipsSbuf*) : LibC::Char*
  fun vips_sbuf_skip_whitespace(sbuf : VipsSbuf*) : LibC::Int
  fun vips_rect_isempty(r : VipsRect*) : Gboolean

  struct VipsRect
    left : LibC::Int
    top : LibC::Int
    width : LibC::Int
    height : LibC::Int
  end

  fun vips_rect_includespoint(r : VipsRect*, x : LibC::Int, y : LibC::Int) : Gboolean
  fun vips_rect_includesrect(r1 : VipsRect*, r2 : VipsRect*) : Gboolean
  fun vips_rect_equalsrect(r1 : VipsRect*, r2 : VipsRect*) : Gboolean
  fun vips_rect_overlapsrect(r1 : VipsRect*, r2 : VipsRect*) : Gboolean
  fun vips_rect_marginadjust(r : VipsRect*, n : LibC::Int)
  fun vips_rect_intersectrect(r1 : VipsRect*, r2 : VipsRect*, out : VipsRect*)
  fun vips_rect_unionrect(r1 : VipsRect*, r2 : VipsRect*, out : VipsRect*)
  fun vips_rect_dup(r : VipsRect*) : VipsRect*
  fun vips_rect_normalise(r : VipsRect*)
  fun vips_window_unref(window : VipsWindow*) : LibC::Int

  struct VipsWindow
    ref_count : LibC::Int
    im : VipsImage*
    top : LibC::Int
    height : LibC::Int
    data : VipsPel*
    baseaddr : Void*
    length : LibC::SizeT
  end

  struct VipsImage
    parent_instance : VipsObject
    xsize : LibC::Int
    ysize : LibC::Int
    bands : LibC::Int
    band_fmt : VipsBandFormat
    coding : VipsCoding
    type : VipsInterpretation
    xres : LibC::Double
    yres : LibC::Double
    xoffset : LibC::Int
    yoffset : LibC::Int
    _length : LibC::Int
    compression : LibC::Short
    level : LibC::Short
    bbits : LibC::Int
    time : VipsProgress*
    hist : LibC::Char*
    filename : LibC::Char*
    data : VipsPel*
    kill : LibC::Int
    xres_float : LibC::Float
    yres_float : LibC::Float
    mode : LibC::Char*
    dtype : VipsImageType
    fd : LibC::Int
    baseaddr : Void*
    length : LibC::SizeT
    magic : Guint32
    start_fn : VipsStartFn
    generate_fn : VipsGenerateFn
    stop_fn : VipsStopFn
    client1 : Void*
    client2 : Void*
    sslock : GMutex*
    regions : GsList*
    dhint : VipsDemandStyle
    meta : GHashTable
    meta_traverse : GsList*
    sizeof_header : Gint64
    windows : GsList*
    upstream : GsList*
    downstream : GsList*
    serial : LibC::Int
    history_list : GsList*
    progress_signal : VipsImage*
    file_length : Gint64
    hint_set : Gboolean
    delete_on_close : Gboolean
    delete_on_close_filename : LibC::Char*
  end

  enum VipsBandFormat
    Notset    = -1
    Uchar     =  0
    Char      =  1
    Ushort    =  2
    Short     =  3
    Uint      =  4
    Int       =  5
    Float     =  6
    Complex   =  7
    Double    =  8
    Dpcomplex =  9
    Last      = 10
  end
  enum VipsCoding
    VipsCodingError = -1
    VipsCodingNone  =  0
    VipsCodingLabq  =  2
    VipsCodingRad   =  6
    VipsCodingLast  =  7
  end
  enum VipsInterpretation
    VipsInterpretationError     = -1
    VipsInterpretationMultiband =  0
    VipsInterpretationBW        =  1
    VipsInterpretationHistogram = 10
    VipsInterpretationXyz       = 12
    VipsInterpretationLab       = 13
    VipsInterpretationCmyk      = 15
    VipsInterpretationLabq      = 16
    VipsInterpretationRgb       = 17
    VipsInterpretationCmc       = 18
    VipsInterpretationLch       = 19
    VipsInterpretationLabs      = 21
    VipsInterpretationSRgb      = 22
    VipsInterpretationYxy       = 23
    VipsInterpretationFourier   = 24
    VipsInterpretationRgb16     = 25
    VipsInterpretationGrey16    = 26
    VipsInterpretationMatrix    = 27
    VipsInterpretationScRgb     = 28
    VipsInterpretationHsv       = 29
    VipsInterpretationLast      = 30
  end

  struct VipsProgress
    im : VipsImage*
    run : LibC::Int
    eta : LibC::Int
    tpels : Gint64
    npels : Gint64
    percent : LibC::Int
    start : GTimer
  end

  alias EvalSignal = (VipsImage*, VipsProgress*, Gpointer -> Void)

  type GTimer = Void*
  alias VipsPel = UInt8
  enum VipsImageType
    VipsImageError         = -1
    VipsImageNone          =  0
    VipsImageSetbuf        =  1
    VipsImageSetbufForeign =  2
    VipsImageOpenin        =  3
    VipsImageMmapin        =  4
    VipsImageMmapinrw      =  5
    VipsImageOpenout       =  6
    VipsImagePartial       =  7
  end
  alias VipsStartFn = (VipsImage*, Void*, Void* -> Void*)

  struct VipsRegion
    parent_object : VipsObject
    im : VipsImage*
    valid : VipsRect
    type : RegionType
    data : VipsPel*
    bpl : LibC::Int
    seq : Void*
    thread : GThread*
    window : VipsWindow*
    buffer : VipsBuffer*
    invalid : Gboolean
  end

  alias VipsGenerateFn = (VipsRegion*, Void*, Void*, Void*, Gboolean* -> LibC::Int)
  enum RegionType
    VipsRegionNone        = 0
    VipsRegionBuffer      = 1
    VipsRegionOtherRegion = 2
    VipsRegionOtherImage  = 3
    VipsRegionWindow      = 4
  end

  struct GThread
    func : GThreadFunc
    data : Gpointer
    joinable : Gboolean
    priority : GThreadPriority
  end

  alias GThreadFunc = (Gpointer -> Gpointer)
  enum GThreadPriority
    GThreadPriorityLow    = 0
    GThreadPriorityNormal = 1
    GThreadPriorityHigh   = 2
    GThreadPriorityUrgent = 3
  end

  struct VipsBuffer
    ref_count : LibC::Int
    im : VipsImage*
    area : VipsRect
    done : Gboolean
    cache : VipsBufferCache*
    buf : VipsPel*
    bsize : LibC::SizeT
  end

  struct VipsBufferCache
    buffers : GsList*
    thread : GThread*
    im : VipsImage*
    buffer_thread : VipsBufferThread*
    reserve : GsList*
    n_reserve : LibC::Int
  end

  struct VipsBufferThread
    hash : GHashTable
    thread : GThread*
  end

  alias VipsStopFn = (Void*, Void*, Void* -> LibC::Int)
  enum VipsDemandStyle
    VipsDemandStyleError     = -1
    VipsDemandStyleSmalltile =  0
    VipsDemandStyleFatstrip  =  1
    VipsDemandStyleThinstrip =  2
    VipsDemandStyleAny       =  3
  end
  fun vips_window_print(window : VipsWindow*)
  fun vips_buffer_dump_all
  fun vips_buffer_done(buffer : VipsBuffer*)
  fun vips_buffer_undone(buffer : VipsBuffer*)
  fun vips_buffer_unref(buffer : VipsBuffer*)
  fun vips_buffer_new(im : VipsImage*, area : VipsRect*) : VipsBuffer*
  fun vips_buffer_ref(im : VipsImage*, area : VipsRect*) : VipsBuffer*
  fun vips_buffer_unref_ref(buffer : VipsBuffer*, im : VipsImage*, area : VipsRect*) : VipsBuffer*
  fun vips_buffer_print(buffer : VipsBuffer*)
  fun vips__render_shutdown
  fun vips__region_take_ownership(reg : VipsRegion*)
  fun vips__region_check_ownership(reg : VipsRegion*)
  fun vips__region_no_ownership(reg : VipsRegion*)
  fun vips_region_fill(reg : VipsRegion*, r : VipsRect*, fn : VipsRegionFillFn, a : Void*) : LibC::Int
  alias VipsRegionFillFn = (VipsRegion*, Void* -> LibC::Int)
  fun vips__image_wio_output(image : VipsImage*) : LibC::Int
  fun vips__image_pio_output(image : VipsImage*) : LibC::Int
  fun vips__argument_get_instance(argument_class : VipsArgumentClass*, object : VipsObject*) : VipsArgumentInstance*
  fun vips__argument_table_lookup(table : VipsArgumentTable*, pspec : GParamSpec*) : VipsArgument*
  fun vips__demand_hint_array(image : VipsImage*, hint : LibC::Int, in : VipsImage**)
  fun vips__image_copy_fields_array(out : VipsImage*, in : VipsImage**) : LibC::Int
  fun vips__region_count_pixels(region : VipsRegion*, nickname : LibC::Char*)
  fun vips_region_dump_all
  fun vips__init(argv0 : LibC::Char*) : LibC::Int
  fun vips__get_sizeof_vipsobject : LibC::SizeT
  fun vips_region_prepare_many(reg : VipsRegion**, r : VipsRect*) : LibC::Int
  fun vips__view_image(image : VipsImage*) : LibC::Int
  fun vips__meta_init

  fun vips_image_get_type : GType
  fun vips_progress_set(progress : Gboolean)
  fun vips_image_invalidate_all(image : VipsImage*)
  fun vips_image_minimise_all(image : VipsImage*)
  fun vips_image_is_sequential(image : VipsImage*) : Gboolean
  fun vips_image_set_progress(image : VipsImage*, progress : Gboolean)
  fun vips_image_iskilled(image : VipsImage*) : Gboolean
  fun vips_image_set_kill(image : VipsImage*, kill : Gboolean)
  fun vips_filename_get_filename(vips_filename : LibC::Char*) : LibC::Char*
  fun vips_filename_get_options(vips_filename : LibC::Char*) : LibC::Char*
  fun vips_image_new : VipsImage*
  fun vips_image_new_memory : VipsImage*
  fun vips_image_memory : VipsImage*
  fun vips_image_new_from_file(name : LibC::Char*, ...) : VipsImage*
  fun vips_image_new_from_file_rw = vips_image_new_from_file_RW(filename : LibC::Char*) : VipsImage*
  fun vips_image_new_from_file_raw(filename : LibC::Char*, xsize : LibC::Int, ysize : LibC::Int, bands : LibC::Int, offset : Guint64) : VipsImage*
  fun vips_image_new_from_memory(data : Void*, size : LibC::SizeT, width : LibC::Int, height : LibC::Int, bands : LibC::Int, format : VipsBandFormat) : VipsImage*
  fun vips_image_new_from_memory_copy(data : Void*, size : LibC::SizeT, width : LibC::Int, height : LibC::Int, bands : LibC::Int, format : VipsBandFormat) : VipsImage*
  fun vips_image_new_from_buffer(buf : Void*, len : LibC::SizeT, option_string : LibC::Char*, ...) : VipsImage*
  fun vips_image_new_from_source(source : VipsSource*, option_string : LibC::Char*, ...) : VipsImage*
  fun vips_image_new_matrix(width : LibC::Int, height : LibC::Int) : VipsImage*
  fun vips_image_new_matrixv(width : LibC::Int, height : LibC::Int, ...) : VipsImage*
  fun vips_image_new_matrix_from_array(width : LibC::Int, height : LibC::Int, array : LibC::Double*, size : LibC::Int) : VipsImage*
  fun vips_image_matrix_from_array(width : LibC::Int, height : LibC::Int, array : LibC::Double*, size : LibC::Int) : VipsImage*
  fun vips_image_new_from_image(image : VipsImage*, c : LibC::Double*, n : LibC::Int) : VipsImage*
  fun vips_image_new_from_image1(image : VipsImage*, c : LibC::Double) : VipsImage*
  fun vips_image_set_delete_on_close(image : VipsImage*, delete_on_close : Gboolean)
  fun vips_get_disc_threshold : Guint64
  fun vips_image_new_temp_file(format : LibC::Char*) : VipsImage*
  fun vips_image_write(image : VipsImage*, out : VipsImage*) : LibC::Int
  fun vips_image_write_to_file(image : VipsImage*, name : LibC::Char*, ...) : LibC::Int
  fun vips_image_write_to_buffer(in : VipsImage*, suffix : LibC::Char*, buf : Void**, size : LibC::SizeT*, ...) : LibC::Int
  fun vips_image_write_to_target(in : VipsImage*, suffix : LibC::Char*, target : VipsTarget*, ...) : LibC::Int
  fun vips_image_write_to_memory(in : VipsImage*, size : LibC::SizeT*) : Void*
  fun vips_image_decode_predict(in : VipsImage*, bands : LibC::Int*, format : VipsBandFormat*) : LibC::Int
  fun vips_image_decode(in : VipsImage*, out : VipsImage**) : LibC::Int
  fun vips_image_encode(in : VipsImage*, out : VipsImage**, coding : VipsCoding) : LibC::Int
  fun vips_image_is_ms_bfirst = vips_image_isMSBfirst(image : VipsImage*) : Gboolean
  fun vips_image_isfile(image : VipsImage*) : Gboolean
  fun vips_image_ispartial(image : VipsImage*) : Gboolean
  fun vips_image_hasalpha(image : VipsImage*) : Gboolean
  fun vips_image_copy_memory(image : VipsImage*) : VipsImage*
  fun vips_image_wio_input(image : VipsImage*) : LibC::Int
  fun vips_image_pio_input(image : VipsImage*) : LibC::Int
  fun vips_image_pio_output(image : VipsImage*) : LibC::Int
  fun vips_image_inplace(image : VipsImage*) : LibC::Int
  fun vips_image_write_prepare(image : VipsImage*) : LibC::Int
  fun vips_image_write_line(image : VipsImage*, ypos : LibC::Int, linebuffer : VipsPel*) : LibC::Int
  fun vips_band_format_isint(format : VipsBandFormat) : Gboolean
  fun vips_band_format_isuint(format : VipsBandFormat) : Gboolean
  fun vips_band_format_is8bit(format : VipsBandFormat) : Gboolean
  fun vips_band_format_isfloat(format : VipsBandFormat) : Gboolean
  fun vips_band_format_iscomplex(format : VipsBandFormat) : Gboolean
  fun vips_system(cmd_format : LibC::Char*, ...) : LibC::Int
  fun vips_array_image_new(array : VipsImage**, n : LibC::Int) : VipsArrayImage*

  struct VipsArrayImage
    area : VipsArea
  end

  fun vips_array_image_newv(n : LibC::Int, ...) : VipsArrayImage*
  fun vips_array_image_new_from_string(string : LibC::Char*, flags : VipsAccess) : VipsArrayImage*
  enum VipsAccess
    VipsAccessRandom               = 0
    VipsAccessSequential           = 1
    VipsAccessSequentialUnbuffered = 2
    VipsAccessLast                 = 3
  end
  fun vips_array_image_empty : VipsArrayImage*
  fun vips_array_image_append(array : VipsArrayImage*, image : VipsImage*) : VipsArrayImage*
  fun vips_array_image_get(array : VipsArrayImage*, n : LibC::Int*) : VipsImage**
  fun vips_value_get_array_image(value : GValue*, n : LibC::Int*) : VipsImage**
  fun vips_value_set_array_image(value : GValue*, n : LibC::Int)
  fun vips_reorder_prepare_many(image : VipsImage*, regions : VipsRegion**, r : VipsRect*) : LibC::Int
  fun vips_reorder_margin_hint(image : VipsImage*, margin : LibC::Int)
  fun vips_image_free_buffer(image : VipsImage*, buffer : Void*)
  fun vips_malloc(object : VipsObject*, size : LibC::SizeT) : Void*
  fun vips_strdup(object : VipsObject*, str : LibC::Char*) : LibC::Char*
  fun vips_tracked_free(s : Void*)
  fun vips_tracked_malloc(size : LibC::SizeT) : Void*
  fun vips_tracked_get_mem : LibC::SizeT
  fun vips_tracked_get_mem_highwater : LibC::SizeT
  fun vips_tracked_get_allocs : LibC::Int
  fun vips_tracked_open(pathname : LibC::Char*, flags : LibC::Int, mode : LibC::Int) : LibC::Int
  fun vips_tracked_close(fd : LibC::Int) : LibC::Int
  fun vips_tracked_get_files : LibC::Int
  fun vips_error_buffer : LibC::Char*
  fun vips_error_buffer_copy : LibC::Char*
  fun vips_error_clear
  fun vips_error_freeze
  fun vips_error_thaw
  fun vips_error(domain : LibC::Char*, fmt : LibC::Char*, ...)
  fun vips_verror(domain : LibC::Char*, fmt : LibC::Char*, ap : VaList)
  fun vips_error_system(err : LibC::Int, domain : LibC::Char*, fmt : LibC::Char*, ...)
  fun vips_verror_system(err : LibC::Int, domain : LibC::Char*, fmt : LibC::Char*, ap : VaList)
  fun vips_error_g(error : GError**)

  struct GError
    domain : GQuark
    code : Gint
    message : Gchar*
  end

  alias GQuark = Guint32
  fun vips_g_error(error : GError**)
  fun vips_error_exit(fmt : LibC::Char*, ...)
  fun vips_check_uncoded(domain : LibC::Char*, im : VipsImage*) : LibC::Int
  fun vips_check_coding(domain : LibC::Char*, im : VipsImage*, coding : VipsCoding) : LibC::Int
  fun vips_check_coding_known(domain : LibC::Char*, im : VipsImage*) : LibC::Int
  fun vips_check_coding_noneorlabq(domain : LibC::Char*, im : VipsImage*) : LibC::Int
  fun vips_check_coding_same(domain : LibC::Char*, im1 : VipsImage*, im2 : VipsImage*) : LibC::Int
  fun vips_check_mono(domain : LibC::Char*, im : VipsImage*) : LibC::Int
  fun vips_check_bands(domain : LibC::Char*, im : VipsImage*, bands : LibC::Int) : LibC::Int
  fun vips_check_bands_1or3(domain : LibC::Char*, im : VipsImage*) : LibC::Int
  fun vips_check_bands_atleast(domain : LibC::Char*, im : VipsImage*, bands : LibC::Int) : LibC::Int
  fun vips_check_bands_1orn(domain : LibC::Char*, im1 : VipsImage*, im2 : VipsImage*) : LibC::Int
  fun vips_check_bands_1orn_unary(domain : LibC::Char*, im : VipsImage*, n : LibC::Int) : LibC::Int
  fun vips_check_bands_same(domain : LibC::Char*, im1 : VipsImage*, im2 : VipsImage*) : LibC::Int
  fun vips_check_bandno(domain : LibC::Char*, im : VipsImage*, bandno : LibC::Int) : LibC::Int
  fun vips_check_int(domain : LibC::Char*, im : VipsImage*) : LibC::Int
  fun vips_check_uint(domain : LibC::Char*, im : VipsImage*) : LibC::Int
  fun vips_check_uintorf(domain : LibC::Char*, im : VipsImage*) : LibC::Int
  fun vips_check_noncomplex(domain : LibC::Char*, im : VipsImage*) : LibC::Int
  fun vips_check_complex(domain : LibC::Char*, im : VipsImage*) : LibC::Int
  fun vips_check_twocomponents(domain : LibC::Char*, im : VipsImage*) : LibC::Int
  fun vips_check_format(domain : LibC::Char*, im : VipsImage*, fmt : VipsBandFormat) : LibC::Int
  fun vips_check_u8or16(domain : LibC::Char*, im : VipsImage*) : LibC::Int
  fun vips_check_8or16(domain : LibC::Char*, im : VipsImage*) : LibC::Int
  fun vips_check_u8or16orf(domain : LibC::Char*, im : VipsImage*) : LibC::Int
  fun vips_check_format_same(domain : LibC::Char*, im1 : VipsImage*, im2 : VipsImage*) : LibC::Int
  fun vips_check_size_same(domain : LibC::Char*, im1 : VipsImage*, im2 : VipsImage*) : LibC::Int
  fun vips_check_oddsquare(domain : LibC::Char*, im : VipsImage*) : LibC::Int
  fun vips_check_vector_length(domain : LibC::Char*, n : LibC::Int, len : LibC::Int) : LibC::Int
  fun vips_check_vector(domain : LibC::Char*, n : LibC::Int, im : VipsImage*) : LibC::Int
  fun vips_check_hist(domain : LibC::Char*, im : VipsImage*) : LibC::Int
  fun vips_check_matrix(domain : LibC::Char*, im : VipsImage*, out : VipsImage**) : LibC::Int
  fun vips_check_separable(domain : LibC::Char*, im : VipsImage*) : LibC::Int
  fun vips_check_precision_intfloat(domain : LibC::Char*, precision : VipsPrecision) : LibC::Int
  enum VipsPrecision
    VipsPrecisionInteger     = 0
    VipsPrecisionFloat       = 1
    VipsPrecisionApproximate = 2
    VipsPrecisionLast        = 3
  end
  VipsFormatNone      = 0_i64
  VipsFormatPartial   = 1_i64
  VipsFormatBigendian = 2_i64
  fun vips_format_get_type : GType
  fun vips_format_map(fn : VipsSListMap2Fn, a : Void*, b : Void*) : Void*
  fun vips_format_for_file(filename : LibC::Char*) : VipsFormatClass*

  struct VipsFormatClass
    parent_class : VipsObjectClass
    is_a : (LibC::Char* -> Gboolean)
    header : (LibC::Char*, VipsImage* -> LibC::Int)
    load : (LibC::Char*, VipsImage* -> LibC::Int)
    save : (VipsImage*, LibC::Char* -> LibC::Int)
    get_flags : (LibC::Char* -> VipsFormatFlags)
    priority : LibC::Int
    suffs : LibC::Char**
  end

  enum VipsFormatFlags
    VipsFormatNone      = 0
    VipsFormatPartial   = 1
    VipsFormatBigendian = 2
  end
  fun vips_format_for_name(filename : LibC::Char*) : VipsFormatClass*
  fun vips_format_get_flags(format : VipsFormatClass*, filename : LibC::Char*) : VipsFormatFlags
  fun vips_format_read(filename : LibC::Char*, out : VipsImage*) : LibC::Int
  fun vips_format_write(in : VipsImage*, filename : LibC::Char*) : LibC::Int
  VipsRegionShrinkMean    = 0_i64
  VipsRegionShrinkMedian  = 1_i64
  VipsRegionShrinkMode    = 2_i64
  VipsRegionShrinkMax     = 3_i64
  VipsRegionShrinkMin     = 4_i64
  VipsRegionShrinkNearest = 5_i64
  VipsRegionShrinkLast    = 6_i64
  fun vips_region_get_type : GType
  fun vips_region_new(image : VipsImage*) : VipsRegion*
  fun vips_region_buffer(reg : VipsRegion*, r : VipsRect*) : LibC::Int
  fun vips_region_image(reg : VipsRegion*, r : VipsRect*) : LibC::Int
  fun vips_region_region(reg : VipsRegion*, dest : VipsRegion*, r : VipsRect*, x : LibC::Int, y : LibC::Int) : LibC::Int
  fun vips_region_equalsregion(reg1 : VipsRegion*, reg2 : VipsRegion*) : LibC::Int
  fun vips_region_position(reg : VipsRegion*, x : LibC::Int, y : LibC::Int) : LibC::Int
  fun vips_region_paint(reg : VipsRegion*, r : VipsRect*, value : LibC::Int)
  fun vips_region_paint_pel(reg : VipsRegion*, r : VipsRect*, ink : VipsPel*)
  fun vips_region_black(reg : VipsRegion*)
  fun vips_region_copy(reg : VipsRegion*, dest : VipsRegion*, r : VipsRect*, x : LibC::Int, y : LibC::Int)
  fun vips_region_shrink_method(from : VipsRegion*, to : VipsRegion*, target : VipsRect*, method : VipsRegionShrink) : LibC::Int
  enum VipsRegionShrink
    VipsRegionShrinkMean    = 0
    VipsRegionShrinkMedian  = 1
    VipsRegionShrinkMode    = 2
    VipsRegionShrinkMax     = 3
    VipsRegionShrinkMin     = 4
    VipsRegionShrinkNearest = 5
    VipsRegionShrinkLast    = 6
  end
  fun vips_region_shrink(from : VipsRegion*, to : VipsRegion*, target : VipsRect*) : LibC::Int
  fun vips_region_prepare(reg : VipsRegion*, r : VipsRect*) : LibC::Int
  fun vips_region_prepare_to(reg : VipsRegion*, dest : VipsRegion*, r : VipsRect*, x : LibC::Int, y : LibC::Int) : LibC::Int
  fun vips_region_fetch(region : VipsRegion*, left : LibC::Int, top : LibC::Int, width : LibC::Int, height : LibC::Int, len : LibC::SizeT*) : VipsPel*
  fun vips_region_width(region : VipsRegion*) : LibC::Int
  fun vips_region_height(region : VipsRegion*) : LibC::Int
  fun vips_region_invalidate(reg : VipsRegion*)
  fun vips_sink_disc(im : VipsImage*, write_fn : VipsRegionWrite, a : Void*) : LibC::Int
  alias VipsRegionWrite = (VipsRegion*, VipsRect*, Void* -> LibC::Int)
  fun vips_sink(im : VipsImage*, start_fn : VipsStartFn, generate_fn : VipsGenerateFn, stop_fn : VipsStopFn, a : Void*, b : Void*) : LibC::Int
  fun vips_sink_tile(im : VipsImage*, tile_width : LibC::Int, tile_height : LibC::Int, start_fn : VipsStartFn, generate_fn : VipsGenerateFn, stop_fn : VipsStopFn, a : Void*, b : Void*) : LibC::Int
  fun vips_sink_screen(in : VipsImage*, out : VipsImage*, mask : VipsImage*, tile_width : LibC::Int, tile_height : LibC::Int, max_tiles : LibC::Int, priority : LibC::Int, notify_fn : VipsSinkNotify, a : Void*) : LibC::Int
  alias VipsSinkNotify = (VipsImage*, VipsRect*, Void* -> Void)
  fun vips_sink_memory(im : VipsImage*) : LibC::Int
  fun vips_start_one(out : VipsImage*, a : Void*, b : Void*) : Void*
  fun vips_stop_one(seq : Void*, a : Void*, b : Void*) : LibC::Int
  fun vips_start_many(out : VipsImage*, a : Void*, b : Void*) : Void*
  fun vips_stop_many(seq : Void*, a : Void*, b : Void*) : LibC::Int
  fun vips_allocate_input_array(out : VipsImage*, ...) : VipsImage**
  fun vips_image_generate(image : VipsImage*, start_fn : VipsStartFn, generate_fn : VipsGenerateFn, stop_fn : VipsStopFn, a : Void*, b : Void*) : LibC::Int
  fun vips_image_pipeline_array(image : VipsImage*, hint : VipsDemandStyle, in : VipsImage**) : LibC::Int
  fun vips_image_pipelinev(image : VipsImage*, hint : VipsDemandStyle, ...) : LibC::Int
  fun vips_interpolate_get_type : GType
  fun vips_interpolate(interpolate : VipsInterpolate*, out : Void*, in : VipsRegion*, x : LibC::Double, y : LibC::Double)

  struct VipsInterpolate
    parent_object : VipsObject
  end

  fun vips_interpolate_get_method(interpolate : VipsInterpolate*) : VipsInterpolateMethod
  alias VipsInterpolateMethod = (VipsInterpolate*, Void*, VipsRegion*, LibC::Double, LibC::Double -> Void)
  fun vips_interpolate_get_window_size(interpolate : VipsInterpolate*) : LibC::Int
  fun vips_interpolate_get_window_offset(interpolate : VipsInterpolate*) : LibC::Int
  fun vips_interpolate_nearest_static : VipsInterpolate*
  fun vips_interpolate_bilinear_static : VipsInterpolate*
  fun vips_interpolate_new(nickname : LibC::Char*) : VipsInterpolate*
  fun vips_g_mutex_new : GMutex*
  fun vips_g_mutex_free(x0 : GMutex*)
  fun vips_g_cond_new : GCond*

  struct GCond
    p : Gpointer
    i : Guint[2]
  end

  fun vips_g_cond_free(x0 : GCond*)
  fun vips_g_thread_new(x0 : LibC::Char*, x1 : GThreadFunc, x2 : Gpointer) : GThread*
  fun vips_g_thread_join(thread : GThread*) : Void*
  fun vips_thread_isworker : Gboolean
  fun vips_semaphore_up(s : VipsSemaphore*) : LibC::Int

  struct VipsSemaphore
    name : LibC::Char*
    v : LibC::Int
    mutex : GMutex*
    cond : GCond*
  end

  fun vips_semaphore_down(s : VipsSemaphore*) : LibC::Int
  fun vips_semaphore_upn(s : VipsSemaphore*, n : LibC::Int) : LibC::Int
  fun vips_semaphore_downn(s : VipsSemaphore*, n : LibC::Int) : LibC::Int
  fun vips_semaphore_destroy(s : VipsSemaphore*)
  fun vips_semaphore_init(s : VipsSemaphore*, v : LibC::Int, name : LibC::Char*)
  fun vips_thread_state_set(object : VipsObject*, a : Void*, b : Void*) : Void*
  fun vips_thread_state_get_type : GType
  fun vips_thread_state_new(im : VipsImage*, a : Void*) : VipsThreadState*

  struct VipsThreadState
    parent_object : VipsObject
    im : VipsImage*
    reg : VipsRegion*
    pos : VipsRect
    x : LibC::Int
    y : LibC::Int
    stop : Gboolean
    a : Void*
    stall : Gboolean
  end

  fun vips_threadpool_run(im : VipsImage*, start : VipsThreadStartFn, allocate : VipsThreadpoolAllocateFn, work : VipsThreadpoolWorkFn, progress : VipsThreadpoolProgressFn, a : Void*) : LibC::Int
  alias VipsThreadStartFn = (VipsImage*, Void* -> VipsThreadState*)
  alias VipsThreadpoolAllocateFn = (VipsThreadState*, Void*, Gboolean* -> LibC::Int)
  alias VipsThreadpoolWorkFn = (VipsThreadState*, Void* -> LibC::Int)
  alias VipsThreadpoolProgressFn = (Void* -> LibC::Int)
  fun vips_get_tile_size(im : VipsImage*, tile_width : LibC::Int*, tile_height : LibC::Int*, n_lines : LibC::Int*)
  fun vips_format_sizeof(format : VipsBandFormat) : Guint64
  fun vips_format_sizeof_unsafe(format : VipsBandFormat) : Guint64
  fun vips_image_get_width(image : VipsImage*) : LibC::Int
  fun vips_image_get_height(image : VipsImage*) : LibC::Int
  fun vips_image_get_bands(image : VipsImage*) : LibC::Int
  fun vips_image_get_format(image : VipsImage*) : VipsBandFormat
  fun vips_image_get_format_max(format : VipsBandFormat) : LibC::Double
  fun vips_image_guess_format(image : VipsImage*) : VipsBandFormat
  fun vips_image_get_coding(image : VipsImage*) : VipsCoding
  fun vips_image_get_interpretation(image : VipsImage*) : VipsInterpretation
  fun vips_image_guess_interpretation(image : VipsImage*) : VipsInterpretation
  fun vips_image_get_xres(image : VipsImage*) : LibC::Double
  fun vips_image_get_yres(image : VipsImage*) : LibC::Double
  fun vips_image_get_xoffset(image : VipsImage*) : LibC::Int
  fun vips_image_get_yoffset(image : VipsImage*) : LibC::Int
  fun vips_image_get_filename(image : VipsImage*) : LibC::Char*
  fun vips_image_get_mode(image : VipsImage*) : LibC::Char*
  fun vips_image_get_scale(image : VipsImage*) : LibC::Double
  fun vips_image_get_offset(image : VipsImage*) : LibC::Double
  fun vips_image_get_page_height(image : VipsImage*) : LibC::Int
  fun vips_image_get_n_pages(image : VipsImage*) : LibC::Int
  fun vips_image_get_n_subifds(image : VipsImage*) : LibC::Int
  fun vips_image_get_orientation(image : VipsImage*) : LibC::Int
  fun vips_image_get_orientation_swap(image : VipsImage*) : Gboolean
  fun vips_image_get_data(image : VipsImage*) : Void*
  fun vips_image_init_fields(image : VipsImage*, xsize : LibC::Int, ysize : LibC::Int, bands : LibC::Int, format : VipsBandFormat, coding : VipsCoding, interpretation : VipsInterpretation, xres : LibC::Double, yres : LibC::Double)
  fun vips_image_set(image : VipsImage*, name : LibC::Char*, value : GValue*)
  fun vips_image_get(image : VipsImage*, name : LibC::Char*, value_copy : GValue*) : LibC::Int
  fun vips_image_get_as_string(image : VipsImage*, name : LibC::Char*, out : LibC::Char**) : LibC::Int
  fun vips_image_get_typeof(image : VipsImage*, name : LibC::Char*) : GType
  fun vips_image_remove(image : VipsImage*, name : LibC::Char*) : Gboolean
  fun vips_image_map(image : VipsImage*, fn : VipsImageMapFn, a : Void*) : Void*
  alias VipsImageMapFn = (VipsImage*, LibC::Char*, GValue*, Void* -> Void*)
  fun vips_image_get_fields(image : VipsImage*) : Gchar**
  fun vips_image_set_area(image : VipsImage*, name : LibC::Char*, free_fn : VipsCallbackFn, data : Void*)
  fun vips_image_get_area(image : VipsImage*, name : LibC::Char*, data : Void**) : LibC::Int
  fun vips_image_set_blob(image : VipsImage*, name : LibC::Char*, free_fn : VipsCallbackFn, data : Void*, length : LibC::SizeT)
  fun vips_image_set_blob_copy(image : VipsImage*, name : LibC::Char*, data : Void*, length : LibC::SizeT)
  fun vips_image_get_blob(image : VipsImage*, name : LibC::Char*, data : Void**, length : LibC::SizeT*) : LibC::Int
  fun vips_image_get_int(image : VipsImage*, name : LibC::Char*, out : LibC::Int*) : LibC::Int
  fun vips_image_set_int(image : VipsImage*, name : LibC::Char*, i : LibC::Int)
  fun vips_image_get_double(image : VipsImage*, name : LibC::Char*, out : LibC::Double*) : LibC::Int
  fun vips_image_set_double(image : VipsImage*, name : LibC::Char*, d : LibC::Double)
  fun vips_image_get_string(image : VipsImage*, name : LibC::Char*, out : LibC::Char**) : LibC::Int
  fun vips_image_set_string(image : VipsImage*, name : LibC::Char*, str : LibC::Char*)
  fun vips_image_print_field(image : VipsImage*, field : LibC::Char*)
  fun vips_image_get_image(image : VipsImage*, name : LibC::Char*, out : VipsImage**) : LibC::Int
  fun vips_image_set_image(image : VipsImage*, name : LibC::Char*, im : VipsImage*)
  fun vips_image_set_array_int(image : VipsImage*, name : LibC::Char*, array : LibC::Int*, n : LibC::Int)
  fun vips_image_get_array_int(image : VipsImage*, name : LibC::Char*, out : LibC::Int**, n : LibC::Int*) : LibC::Int
  fun vips_image_get_array_double(image : VipsImage*, name : LibC::Char*, out : LibC::Double**, n : LibC::Int*) : LibC::Int
  fun vips_image_set_array_double(image : VipsImage*, name : LibC::Char*, array : LibC::Double*, n : LibC::Int)
  fun vips_image_history_printf(image : VipsImage*, format : LibC::Char*, ...) : LibC::Int
  fun vips_image_history_args(image : VipsImage*, name : LibC::Char*, argc : LibC::Int, argv : LibC::Char**) : LibC::Int
  fun vips_image_get_history(image : VipsImage*) : LibC::Char*

  fun vips_operation_get_type : GType
  fun vips_operation_get_flags(operation : VipsOperation*) : VipsOperationFlags

  struct VipsOperation
    parent_instance : VipsObject
    hash : Guint
    found_hash : Gboolean
    pixels : LibC::Int
  end

  enum VipsOperationFlags
    VipsOperationNone                 = 0
    VipsOperationSequential           = 1
    VipsOperationSequentialUnbuffered = 2
    VipsOperationNocache              = 4
    VipsOperationDeprecated           = 8
  end
  fun vips_operation_class_print_usage(operation_class : VipsOperationClass*)

  struct VipsOperationClass
    parent_class : VipsObjectClass
    usage : (VipsOperationClass*, VipsBuf* -> Void)
    get_flags : (VipsOperation* -> VipsOperationFlags)
    flags : VipsOperationFlags
    invalidate : (VipsOperation* -> Void)
  end

  fun vips_operation_invalidate(operation : VipsOperation*)
  fun vips_operation_call_valist(operation : VipsOperation*, ap : VaList) : LibC::Int
  fun vips_operation_new(name : LibC::Char*) : VipsOperation*
  fun vips_call_required_optional(operation : VipsOperation**, required : VaList, optional : VaList) : LibC::Int
  fun vips_call(operation_name : LibC::Char*, ...) : LibC::Int
  fun vips_call_split(operation_name : LibC::Char*, optional : VaList, ...) : LibC::Int
  fun vips_call_split_option_string(operation_name : LibC::Char*, option_string : LibC::Char*, optional : VaList, ...) : LibC::Int
  fun vips_call_options(group : GOptionGroup, operation : VipsOperation*)
  type GOptionGroup = Void*
  fun vips_call_argv(operation : VipsOperation*, argc : LibC::Int, argv : LibC::Char**) : LibC::Int
  fun vips_cache_drop_all
  fun vips_cache_operation_lookup(operation : VipsOperation*) : VipsOperation*
  fun vips_cache_operation_add(operation : VipsOperation*)
  fun vips_cache_operation_buildp(operation : VipsOperation**) : LibC::Int
  fun vips_cache_operation_build(operation : VipsOperation*) : VipsOperation*
  fun vips_cache_print
  fun vips_cache_set_max(max : LibC::Int)
  fun vips_cache_set_max_mem(max_mem : LibC::SizeT)
  fun vips_cache_get_max : LibC::Int
  fun vips_cache_get_size : LibC::Int
  fun vips_cache_get_max_mem : LibC::SizeT
  fun vips_cache_get_max_files : LibC::Int
  fun vips_cache_set_max_files(max_files : LibC::Int)
  fun vips_cache_set_dump(dump : Gboolean)
  fun vips_cache_set_trace(trace : Gboolean)
  fun vips_concurrency_set(concurrency : LibC::Int)
  fun vips_concurrency_get : LibC::Int
  fun vips_foreign_get_type : GType
  fun vips_foreign_map(base : LibC::Char*, fn : VipsSListMap2Fn, a : Void*, b : Void*) : Void*

  fun vips_foreign_load_get_type : GType
  fun vips_foreign_find_load(filename : LibC::Char*) : LibC::Char*
  fun vips_foreign_find_load_buffer(data : Void*, size : LibC::SizeT) : LibC::Char*
  fun vips_foreign_find_load_source(source : VipsSource*) : LibC::Char*
  fun vips_foreign_flags(loader : LibC::Char*, filename : LibC::Char*) : VipsForeignFlags
  enum VipsForeignFlags
    VipsForeignNone       = 0
    VipsForeignPartial    = 1
    VipsForeignBigendian  = 2
    VipsForeignSequential = 4
    VipsForeignAll        = 7
  end
  fun vips_foreign_is_a(loader : LibC::Char*, filename : LibC::Char*) : Gboolean
  fun vips_foreign_is_a_buffer(loader : LibC::Char*, data : Void*, size : LibC::SizeT) : Gboolean
  fun vips_foreign_is_a_source(loader : LibC::Char*, source : VipsSource*) : Gboolean
  fun vips_foreign_load_invalidate(image : VipsImage*)

  fun vips_foreign_save_get_type : GType
  fun vips_foreign_find_save(filename : LibC::Char*) : LibC::Char*
  fun vips_foreign_get_suffixes : Gchar**
  fun vips_foreign_find_save_buffer(suffix : LibC::Char*) : LibC::Char*
  fun vips_foreign_find_save_target(suffix : LibC::Char*) : LibC::Char*
  fun vips_vipsload(filename : LibC::Char*, out : VipsImage**, ...) : LibC::Int
  fun vips_vipsload_source(source : VipsSource*, out : VipsImage**, ...) : LibC::Int
  fun vips_vipssave(in : VipsImage*, filename : LibC::Char*, ...) : LibC::Int
  fun vips_vipssave_target(in : VipsImage*, target : VipsTarget*, ...) : LibC::Int
  fun vips_openslideload(filename : LibC::Char*, out : VipsImage**, ...) : LibC::Int
  fun vips_openslideload_source(source : VipsSource*, out : VipsImage**, ...) : LibC::Int

  fun vips_jpegload(filename : LibC::Char*, out : VipsImage**, ...) : LibC::Int
  fun vips_jpegload_buffer(buf : Void*, len : LibC::SizeT, out : VipsImage**, ...) : LibC::Int
  fun vips_jpegload_source(source : VipsSource*, out : VipsImage**, ...) : LibC::Int
  fun vips_jpegsave_target(in : VipsImage*, target : VipsTarget*, ...) : LibC::Int
  fun vips_jpegsave(in : VipsImage*, filename : LibC::Char*, ...) : LibC::Int
  fun vips_jpegsave_buffer(in : VipsImage*, buf : Void**, len : LibC::SizeT*, ...) : LibC::Int
  fun vips_jpegsave_mime(in : VipsImage*, ...) : LibC::Int

  fun vips_webpload_source(source : VipsSource*, out : VipsImage**, ...) : LibC::Int
  fun vips_webpload(filename : LibC::Char*, out : VipsImage**, ...) : LibC::Int
  fun vips_webpload_buffer(buf : Void*, len : LibC::SizeT, out : VipsImage**, ...) : LibC::Int
  fun vips_webpsave_target(in : VipsImage*, target : VipsTarget*, ...) : LibC::Int
  fun vips_webpsave(in : VipsImage*, filename : LibC::Char*, ...) : LibC::Int
  fun vips_webpsave_buffer(in : VipsImage*, buf : Void**, len : LibC::SizeT*, ...) : LibC::Int
  fun vips_webpsave_mime(in : VipsImage*, ...) : LibC::Int

  fun vips_tiffload(filename : LibC::Char*, out : VipsImage**, ...) : LibC::Int
  fun vips_tiffload_buffer(buf : Void*, len : LibC::SizeT, out : VipsImage**, ...) : LibC::Int
  fun vips_tiffload_source(source : VipsSource*, out : VipsImage**, ...) : LibC::Int
  fun vips_tiffsave(in : VipsImage*, filename : LibC::Char*, ...) : LibC::Int
  fun vips_tiffsave_buffer(in : VipsImage*, buf : Void**, len : LibC::SizeT*, ...) : LibC::Int
  fun vips_openexrload(filename : LibC::Char*, out : VipsImage**, ...) : LibC::Int
  fun vips_fitsload(filename : LibC::Char*, out : VipsImage**, ...) : LibC::Int
  fun vips_fitssave(in : VipsImage*, filename : LibC::Char*, ...) : LibC::Int
  fun vips_analyzeload(filename : LibC::Char*, out : VipsImage**, ...) : LibC::Int
  fun vips_rawload(filename : LibC::Char*, out : VipsImage**, width : LibC::Int, height : LibC::Int, bands : LibC::Int, ...) : LibC::Int
  fun vips_rawsave(in : VipsImage*, filename : LibC::Char*, ...) : LibC::Int
  fun vips_rawsave_fd(in : VipsImage*, fd : LibC::Int, ...) : LibC::Int
  fun vips_csvload(filename : LibC::Char*, out : VipsImage**, ...) : LibC::Int
  fun vips_csvload_source(source : VipsSource*, out : VipsImage**, ...) : LibC::Int
  fun vips_csvsave(in : VipsImage*, filename : LibC::Char*, ...) : LibC::Int
  fun vips_csvsave_target(in : VipsImage*, target : VipsTarget*, ...) : LibC::Int
  fun vips_matrixload(filename : LibC::Char*, out : VipsImage**, ...) : LibC::Int
  fun vips_matrixload_source(source : VipsSource*, out : VipsImage**, ...) : LibC::Int
  fun vips_matrixsave(in : VipsImage*, filename : LibC::Char*, ...) : LibC::Int
  fun vips_matrixsave_target(in : VipsImage*, target : VipsTarget*, ...) : LibC::Int
  fun vips_matrixprint(in : VipsImage*, ...) : LibC::Int
  fun vips_magickload(filename : LibC::Char*, out : VipsImage**, ...) : LibC::Int
  fun vips_magickload_buffer(buf : Void*, len : LibC::SizeT, out : VipsImage**, ...) : LibC::Int
  fun vips_magicksave(in : VipsImage*, filename : LibC::Char*, ...) : LibC::Int
  fun vips_magicksave_buffer(in : VipsImage*, buf : Void**, len : LibC::SizeT*, ...) : LibC::Int

  fun vips_pngload_source(source : VipsSource*, out : VipsImage**, ...) : LibC::Int
  fun vips_pngload(filename : LibC::Char*, out : VipsImage**, ...) : LibC::Int
  fun vips_pngload_buffer(buf : Void*, len : LibC::SizeT, out : VipsImage**, ...) : LibC::Int
  fun vips_pngsave_target(in : VipsImage*, target : VipsTarget*, ...) : LibC::Int
  fun vips_pngsave(in : VipsImage*, filename : LibC::Char*, ...) : LibC::Int
  fun vips_pngsave_buffer(in : VipsImage*, buf : Void**, len : LibC::SizeT*, ...) : LibC::Int

  fun vips_ppmload(filename : LibC::Char*, out : VipsImage**, ...) : LibC::Int
  fun vips_ppmload_source(source : VipsSource*, out : VipsImage**, ...) : LibC::Int
  fun vips_ppmsave(in : VipsImage*, filename : LibC::Char*, ...) : LibC::Int
  fun vips_ppmsave_target(in : VipsImage*, target : VipsTarget*, ...) : LibC::Int
  fun vips_matload(filename : LibC::Char*, out : VipsImage**, ...) : LibC::Int
  fun vips_radload_source(source : VipsSource*, out : VipsImage**, ...) : LibC::Int
  fun vips_radload(filename : LibC::Char*, out : VipsImage**, ...) : LibC::Int
  fun vips_radload_buffer(buf : Void*, len : LibC::SizeT, out : VipsImage**, ...) : LibC::Int
  fun vips_radsave(in : VipsImage*, filename : LibC::Char*, ...) : LibC::Int
  fun vips_radsave_buffer(in : VipsImage*, buf : Void**, len : LibC::SizeT*, ...) : LibC::Int
  fun vips_radsave_target(in : VipsImage*, target : VipsTarget*, ...) : LibC::Int
  fun vips_pdfload(filename : LibC::Char*, out : VipsImage**, ...) : LibC::Int
  fun vips_pdfload_buffer(buf : Void*, len : LibC::SizeT, out : VipsImage**, ...) : LibC::Int
  fun vips_pdfload_source(source : VipsSource*, out : VipsImage**, ...) : LibC::Int
  fun vips_svgload(filename : LibC::Char*, out : VipsImage**, ...) : LibC::Int
  fun vips_svgload_buffer(buf : Void*, len : LibC::SizeT, out : VipsImage**, ...) : LibC::Int
  fun vips_svgload_string(str : LibC::Char*, out : VipsImage**, ...) : LibC::Int
  fun vips_svgload_source(source : VipsSource*, out : VipsImage**, ...) : LibC::Int
  fun vips_gifload(filename : LibC::Char*, out : VipsImage**, ...) : LibC::Int
  fun vips_gifload_buffer(buf : Void*, len : LibC::SizeT, out : VipsImage**, ...) : LibC::Int
  fun vips_gifload_source(source : VipsSource*, out : VipsImage**, ...) : LibC::Int
  fun vips_gifsave(in : VipsImage*, filename : LibC::Char*, ...) : LibC::Int
  fun vips_gifsave_buffer(in : VipsImage*, buf : Void**, len : LibC::SizeT*, ...) : LibC::Int
  fun vips_gifsave_target(in : VipsImage*, target : VipsTarget*, ...) : LibC::Int
  fun vips_heifload(filename : LibC::Char*, out : VipsImage**, ...) : LibC::Int
  fun vips_heifload_buffer(buf : Void*, len : LibC::SizeT, out : VipsImage**, ...) : LibC::Int
  fun vips_heifload_source(source : VipsSource*, out : VipsImage**, ...) : LibC::Int
  fun vips_heifsave(in : VipsImage*, filename : LibC::Char*, ...) : LibC::Int
  fun vips_heifsave_buffer(in : VipsImage*, buf : Void**, len : LibC::SizeT*, ...) : LibC::Int
  fun vips_heifsave_target(in : VipsImage*, target : VipsTarget*, ...) : LibC::Int
  fun vips_niftiload(filename : LibC::Char*, out : VipsImage**, ...) : LibC::Int
  fun vips_niftiload_source(source : VipsSource*, out : VipsImage**, ...) : LibC::Int
  fun vips_niftisave(in : VipsImage*, filename : LibC::Char*, ...) : LibC::Int
  fun vips_jp2kload(filename : LibC::Char*, out : VipsImage**, ...) : LibC::Int
  fun vips_jp2kload_buffer(buf : Void*, len : LibC::SizeT, out : VipsImage**, ...) : LibC::Int
  fun vips_jp2kload_source(source : VipsSource*, out : VipsImage**, ...) : LibC::Int
  fun vips_jp2ksave(in : VipsImage*, filename : LibC::Char*, ...) : LibC::Int
  fun vips_jp2ksave_buffer(in : VipsImage*, buf : Void**, len : LibC::SizeT*, ...) : LibC::Int
  fun vips_jp2ksave_target(in : VipsImage*, target : VipsTarget*, ...) : LibC::Int
  fun vips_jxlload_source(source : VipsSource*, out : VipsImage**, ...) : LibC::Int
  fun vips_jxlload_buffer(buf : Void*, len : LibC::SizeT, out : VipsImage**, ...) : LibC::Int
  fun vips_jxlload(filename : LibC::Char*, out : VipsImage**, ...) : LibC::Int
  fun vips_jxlsave(in : VipsImage*, filename : LibC::Char*, ...) : LibC::Int
  fun vips_jxlsave_buffer(in : VipsImage*, buf : Void**, len : LibC::SizeT*, ...) : LibC::Int
  fun vips_jxlsave_target(in : VipsImage*, target : VipsTarget*, ...) : LibC::Int

  fun vips_dzsave(in : VipsImage*, name : LibC::Char*, ...) : LibC::Int

  fun vips_operation_math_get_type : GType
  fun vips_operation_math2_get_type : GType
  fun vips_operation_round_get_type : GType
  fun vips_operation_relational_get_type : GType
  fun vips_operation_boolean_get_type : GType
  fun vips_operation_complex_get_type : GType
  fun vips_operation_complex2_get_type : GType
  fun vips_operation_complexget_get_type : GType
  fun vips_precision_get_type : GType
  fun vips_intent_get_type : GType
  fun vips_pcs_get_type : GType
  fun vips_extend_get_type : GType
  fun vips_compass_direction_get_type : GType
  fun vips_direction_get_type : GType
  fun vips_align_get_type : GType
  fun vips_angle_get_type : GType
  fun vips_angle45_get_type : GType
  fun vips_interesting_get_type : GType
  fun vips_blend_mode_get_type : GType
  fun vips_combine_get_type : GType
  fun vips_combine_mode_get_type : GType
  fun vips_foreign_flags_get_type : GType
  fun vips_fail_on_get_type : GType
  fun vips_saveable_get_type : GType
  fun vips_foreign_subsample_get_type : GType
  fun vips_foreign_jpeg_subsample_get_type : GType
  fun vips_foreign_webp_preset_get_type : GType
  fun vips_foreign_tiff_compression_get_type : GType
  fun vips_foreign_tiff_predictor_get_type : GType
  fun vips_foreign_tiff_resunit_get_type : GType
  fun vips_foreign_png_filter_get_type : GType
  fun vips_foreign_ppm_format_get_type : GType
  fun vips_foreign_dz_layout_get_type : GType
  fun vips_foreign_dz_depth_get_type : GType
  fun vips_foreign_dz_container_get_type : GType
  fun vips_foreign_heif_compression_get_type : GType
  fun vips_demand_style_get_type : GType
  fun vips_image_type_get_type : GType
  fun vips_interpretation_get_type : GType
  fun vips_band_format_get_type : GType
  fun vips_coding_get_type : GType
  fun vips_access_get_type : GType
  fun vips_operation_morphology_get_type : GType
  fun vips_argument_flags_get_type : GType
  fun vips_operation_flags_get_type : GType
  fun vips_region_shrink_get_type : GType
  fun vips_kernel_get_type : GType
  fun vips_size_get_type : GType
  fun vips_token_get_type : GType

  fun vips_add(left : VipsImage*, right : VipsImage*, out : VipsImage**, ...) : LibC::Int
  fun vips_sum(in : VipsImage**, out : VipsImage**, n : LibC::Int, ...) : LibC::Int
  fun vips_subtract(in1 : VipsImage*, in2 : VipsImage*, out : VipsImage**, ...) : LibC::Int
  fun vips_multiply(left : VipsImage*, right : VipsImage*, out : VipsImage**, ...) : LibC::Int
  fun vips_divide(left : VipsImage*, right : VipsImage*, out : VipsImage**, ...) : LibC::Int
  fun vips_linear(in : VipsImage*, out : VipsImage**, a : LibC::Double*, b : LibC::Double*, n : LibC::Int, ...) : LibC::Int
  fun vips_linear1(in : VipsImage*, out : VipsImage**, a : LibC::Double, b : LibC::Double, ...) : LibC::Int
  fun vips_remainder(left : VipsImage*, right : VipsImage*, out : VipsImage**, ...) : LibC::Int
  fun vips_remainder_const(in : VipsImage*, out : VipsImage**, c : LibC::Double*, n : LibC::Int, ...) : LibC::Int
  fun vips_remainder_const1(in : VipsImage*, out : VipsImage**, c : LibC::Double, ...) : LibC::Int
  fun vips_invert(in : VipsImage*, out : VipsImage**, ...) : LibC::Int
  fun vips_abs(in : VipsImage*, out : VipsImage**, ...) : LibC::Int
  fun vips_sign(in : VipsImage*, out : VipsImage**, ...) : LibC::Int
  fun vips_round(in : VipsImage*, out : VipsImage**, round : VipsOperationRound, ...) : LibC::Int
  enum VipsOperationRound
    VipsOperationRoundRint  = 0
    VipsOperationRoundCeil  = 1
    VipsOperationRoundFloor = 2
    VipsOperationRoundLast  = 3
  end
  fun vips_floor(in : VipsImage*, out : VipsImage**, ...) : LibC::Int
  fun vips_ceil(in : VipsImage*, out : VipsImage**, ...) : LibC::Int
  fun vips_rint(in : VipsImage*, out : VipsImage**, ...) : LibC::Int
  fun vips_math(in : VipsImage*, out : VipsImage**, math : VipsOperationMath, ...) : LibC::Int
  enum VipsOperationMath
    VipsOperationMathSin   =  0
    VipsOperationMathCos   =  1
    VipsOperationMathTan   =  2
    VipsOperationMathAsin  =  3
    VipsOperationMathAcos  =  4
    VipsOperationMathAtan  =  5
    VipsOperationMathLog   =  6
    VipsOperationMathLog10 =  7
    VipsOperationMathExp   =  8
    VipsOperationMathExp10 =  9
    VipsOperationMathSinh  = 10
    VipsOperationMathCosh  = 11
    VipsOperationMathTanh  = 12
    VipsOperationMathAsinh = 13
    VipsOperationMathAcosh = 14
    VipsOperationMathAtanh = 15
    VipsOperationMathLast  = 16
  end
  fun vips_sin(in : VipsImage*, out : VipsImage**, ...) : LibC::Int
  fun vips_cos(in : VipsImage*, out : VipsImage**, ...) : LibC::Int
  fun vips_tan(in : VipsImage*, out : VipsImage**, ...) : LibC::Int
  fun vips_asin(in : VipsImage*, out : VipsImage**, ...) : LibC::Int
  fun vips_acos(in : VipsImage*, out : VipsImage**, ...) : LibC::Int
  fun vips_atan(in : VipsImage*, out : VipsImage**, ...) : LibC::Int
  fun vips_exp(in : VipsImage*, out : VipsImage**, ...) : LibC::Int
  fun vips_exp10(in : VipsImage*, out : VipsImage**, ...) : LibC::Int
  fun vips_log(in : VipsImage*, out : VipsImage**, ...) : LibC::Int
  fun vips_log10(in : VipsImage*, out : VipsImage**, ...) : LibC::Int
  fun vips_sinh(in : VipsImage*, out : VipsImage**, ...) : LibC::Int
  fun vips_cosh(in : VipsImage*, out : VipsImage**, ...) : LibC::Int
  fun vips_tanh(in : VipsImage*, out : VipsImage**, ...) : LibC::Int
  fun vips_asinh(in : VipsImage*, out : VipsImage**, ...) : LibC::Int
  fun vips_acosh(in : VipsImage*, out : VipsImage**, ...) : LibC::Int
  fun vips_atanh(in : VipsImage*, out : VipsImage**, ...) : LibC::Int
  fun vips_complex(in : VipsImage*, out : VipsImage**, cmplx : VipsOperationComplex, ...) : LibC::Int
  enum VipsOperationComplex
    VipsOperationComplexPolar = 0
    VipsOperationComplexRect  = 1
    VipsOperationComplexConj  = 2
    VipsOperationComplexLast  = 3
  end
  fun vips_polar(in : VipsImage*, out : VipsImage**, ...) : LibC::Int
  fun vips_rect(in : VipsImage*, out : VipsImage**, ...) : LibC::Int
  fun vips_conj(in : VipsImage*, out : VipsImage**, ...) : LibC::Int
  fun vips_complex2(left : VipsImage*, right : VipsImage*, out : VipsImage**, cmplx : VipsOperationComplex2, ...) : LibC::Int
  enum VipsOperationComplex2
    VipsOperationComplex2CrossPhase = 0
    VipsOperationComplex2Last       = 1
  end
  fun vips_cross_phase(left : VipsImage*, right : VipsImage*, out : VipsImage**, ...) : LibC::Int
  fun vips_complexget(in : VipsImage*, out : VipsImage**, get : VipsOperationComplexget, ...) : LibC::Int
  enum VipsOperationComplexget
    VipsOperationComplexgetReal = 0
    VipsOperationComplexgetImag = 1
    VipsOperationComplexgetLast = 2
  end
  fun vips_real(in : VipsImage*, out : VipsImage**, ...) : LibC::Int
  fun vips_imag(in : VipsImage*, out : VipsImage**, ...) : LibC::Int
  fun vips_complexform(left : VipsImage*, right : VipsImage*, out : VipsImage**, ...) : LibC::Int
  fun vips_relational(left : VipsImage*, right : VipsImage*, out : VipsImage**, relational : VipsOperationRelational, ...) : LibC::Int
  enum VipsOperationRelational
    VipsOperationRelationalEqual  = 0
    VipsOperationRelationalNoteq  = 1
    VipsOperationRelationalLess   = 2
    VipsOperationRelationalLesseq = 3
    VipsOperationRelationalMore   = 4
    VipsOperationRelationalMoreeq = 5
    VipsOperationRelationalLast   = 6
  end
  fun vips_equal(left : VipsImage*, right : VipsImage*, out : VipsImage**, ...) : LibC::Int
  fun vips_notequal(left : VipsImage*, right : VipsImage*, out : VipsImage**, ...) : LibC::Int
  fun vips_less(left : VipsImage*, right : VipsImage*, out : VipsImage**, ...) : LibC::Int
  fun vips_lesseq(left : VipsImage*, right : VipsImage*, out : VipsImage**, ...) : LibC::Int
  fun vips_more(left : VipsImage*, right : VipsImage*, out : VipsImage**, ...) : LibC::Int
  fun vips_moreeq(left : VipsImage*, right : VipsImage*, out : VipsImage**, ...) : LibC::Int
  fun vips_relational_const(in : VipsImage*, out : VipsImage**, relational : VipsOperationRelational, c : LibC::Double*, n : LibC::Int, ...) : LibC::Int
  fun vips_equal_const(in : VipsImage*, out : VipsImage**, c : LibC::Double*, n : LibC::Int, ...) : LibC::Int
  fun vips_notequal_const(in : VipsImage*, out : VipsImage**, c : LibC::Double*, n : LibC::Int, ...) : LibC::Int
  fun vips_less_const(in : VipsImage*, out : VipsImage**, c : LibC::Double*, n : LibC::Int, ...) : LibC::Int
  fun vips_lesseq_const(in : VipsImage*, out : VipsImage**, c : LibC::Double*, n : LibC::Int, ...) : LibC::Int
  fun vips_more_const(in : VipsImage*, out : VipsImage**, c : LibC::Double*, n : LibC::Int, ...) : LibC::Int
  fun vips_moreeq_const(in : VipsImage*, out : VipsImage**, c : LibC::Double*, n : LibC::Int, ...) : LibC::Int
  fun vips_relational_const1(in : VipsImage*, out : VipsImage**, relational : VipsOperationRelational, c : LibC::Double, ...) : LibC::Int
  fun vips_equal_const1(in : VipsImage*, out : VipsImage**, c : LibC::Double, ...) : LibC::Int
  fun vips_notequal_const1(in : VipsImage*, out : VipsImage**, c : LibC::Double, ...) : LibC::Int
  fun vips_less_const1(in : VipsImage*, out : VipsImage**, c : LibC::Double, ...) : LibC::Int
  fun vips_lesseq_const1(in : VipsImage*, out : VipsImage**, c : LibC::Double, ...) : LibC::Int
  fun vips_more_const1(in : VipsImage*, out : VipsImage**, c : LibC::Double, ...) : LibC::Int
  fun vips_moreeq_const1(in : VipsImage*, out : VipsImage**, c : LibC::Double, ...) : LibC::Int
  fun vips_boolean(left : VipsImage*, right : VipsImage*, out : VipsImage**, boolean : VipsOperationBoolean, ...) : LibC::Int
  enum VipsOperationBoolean
    VipsOperationBooleanAnd    = 0
    VipsOperationBooleanOr     = 1
    VipsOperationBooleanEor    = 2
    VipsOperationBooleanLshift = 3
    VipsOperationBooleanRshift = 4
    VipsOperationBooleanLast   = 5
  end
  fun vips_andimage(left : VipsImage*, right : VipsImage*, out : VipsImage**, ...) : LibC::Int
  fun vips_orimage(left : VipsImage*, right : VipsImage*, out : VipsImage**, ...) : LibC::Int
  fun vips_eorimage(left : VipsImage*, right : VipsImage*, out : VipsImage**, ...) : LibC::Int
  fun vips_lshift(left : VipsImage*, right : VipsImage*, out : VipsImage**, ...) : LibC::Int
  fun vips_rshift(left : VipsImage*, right : VipsImage*, out : VipsImage**, ...) : LibC::Int
  fun vips_boolean_const(in : VipsImage*, out : VipsImage**, boolean : VipsOperationBoolean, c : LibC::Double*, n : LibC::Int, ...) : LibC::Int
  fun vips_andimage_const(in : VipsImage*, out : VipsImage**, c : LibC::Double*, n : LibC::Int, ...) : LibC::Int
  fun vips_orimage_const(in : VipsImage*, out : VipsImage**, c : LibC::Double*, n : LibC::Int, ...) : LibC::Int
  fun vips_eorimage_const(in : VipsImage*, out : VipsImage**, c : LibC::Double*, n : LibC::Int, ...) : LibC::Int
  fun vips_lshift_const(in : VipsImage*, out : VipsImage**, c : LibC::Double*, n : LibC::Int, ...) : LibC::Int
  fun vips_rshift_const(in : VipsImage*, out : VipsImage**, c : LibC::Double*, n : LibC::Int, ...) : LibC::Int
  fun vips_boolean_const1(in : VipsImage*, out : VipsImage**, boolean : VipsOperationBoolean, c : LibC::Double, ...) : LibC::Int
  fun vips_andimage_const1(in : VipsImage*, out : VipsImage**, c : LibC::Double, ...) : LibC::Int
  fun vips_orimage_const1(in : VipsImage*, out : VipsImage**, c : LibC::Double, ...) : LibC::Int
  fun vips_eorimage_const1(in : VipsImage*, out : VipsImage**, c : LibC::Double, ...) : LibC::Int
  fun vips_lshift_const1(in : VipsImage*, out : VipsImage**, c : LibC::Double, ...) : LibC::Int
  fun vips_rshift_const1(in : VipsImage*, out : VipsImage**, c : LibC::Double, ...) : LibC::Int
  fun vips_math2(left : VipsImage*, right : VipsImage*, out : VipsImage**, math2 : VipsOperationMath2, ...) : LibC::Int
  enum VipsOperationMath2
    VipsOperationMath2Pow   = 0
    VipsOperationMath2Wop   = 1
    VipsOperationMath2Atan2 = 2
    VipsOperationMath2Last  = 3
  end
  fun vips_pow(left : VipsImage*, right : VipsImage*, out : VipsImage**, ...) : LibC::Int
  fun vips_wop(left : VipsImage*, right : VipsImage*, out : VipsImage**, ...) : LibC::Int
  fun vips_atan2(left : VipsImage*, right : VipsImage*, out : VipsImage**, ...) : LibC::Int
  fun vips_math2_const(in : VipsImage*, out : VipsImage**, math2 : VipsOperationMath2, c : LibC::Double*, n : LibC::Int, ...) : LibC::Int
  fun vips_pow_const(in : VipsImage*, out : VipsImage**, c : LibC::Double*, n : LibC::Int, ...) : LibC::Int
  fun vips_wop_const(in : VipsImage*, out : VipsImage**, c : LibC::Double*, n : LibC::Int, ...) : LibC::Int
  fun vips_atan2_const(in : VipsImage*, out : VipsImage**, c : LibC::Double*, n : LibC::Int, ...) : LibC::Int
  fun vips_math2_const1(in : VipsImage*, out : VipsImage**, math2 : VipsOperationMath2, c : LibC::Double, ...) : LibC::Int
  fun vips_pow_const1(in : VipsImage*, out : VipsImage**, c : LibC::Double, ...) : LibC::Int
  fun vips_wop_const1(in : VipsImage*, out : VipsImage**, c : LibC::Double, ...) : LibC::Int
  fun vips_atan2_const1(in : VipsImage*, out : VipsImage**, c : LibC::Double, ...) : LibC::Int
  fun vips_avg(in : VipsImage*, out : LibC::Double*, ...) : LibC::Int
  fun vips_deviate(in : VipsImage*, out : LibC::Double*, ...) : LibC::Int
  fun vips_min(in : VipsImage*, out : LibC::Double*, ...) : LibC::Int
  fun vips_max(in : VipsImage*, out : LibC::Double*, ...) : LibC::Int
  fun vips_stats(in : VipsImage*, out : VipsImage**, ...) : LibC::Int
  fun vips_measure(in : VipsImage*, out : VipsImage**, h : LibC::Int, v : LibC::Int, ...) : LibC::Int
  fun vips_find_trim(in : VipsImage*, left : LibC::Int*, top : LibC::Int*, width : LibC::Int*, height : LibC::Int*, ...) : LibC::Int
  fun vips_getpoint(in : VipsImage*, vector : LibC::Double**, n : LibC::Int*, x : LibC::Int, y : LibC::Int, ...) : LibC::Int
  fun vips_hist_find(in : VipsImage*, out : VipsImage**, ...) : LibC::Int
  fun vips_hist_find_ndim(in : VipsImage*, out : VipsImage**, ...) : LibC::Int
  fun vips_hist_find_indexed(in : VipsImage*, index : VipsImage*, out : VipsImage**, ...) : LibC::Int
  fun vips_hough_line(in : VipsImage*, out : VipsImage**, ...) : LibC::Int
  fun vips_hough_circle(in : VipsImage*, out : VipsImage**, ...) : LibC::Int
  fun vips_project(in : VipsImage*, columns : VipsImage**, rows : VipsImage**, ...) : LibC::Int
  fun vips_profile(in : VipsImage*, columns : VipsImage**, rows : VipsImage**, ...) : LibC::Int

  fun vips_copy(in : VipsImage*, out : VipsImage**, ...) : LibC::Int
  fun vips_tilecache(in : VipsImage*, out : VipsImage**, ...) : LibC::Int
  fun vips_linecache(in : VipsImage*, out : VipsImage**, ...) : LibC::Int
  fun vips_sequential(in : VipsImage*, out : VipsImage**, ...) : LibC::Int
  fun vips_cache(in : VipsImage*, out : VipsImage**, ...) : LibC::Int
  fun vips_copy_file(in : VipsImage*, out : VipsImage**, ...) : LibC::Int
  fun vips_embed(in : VipsImage*, out : VipsImage**, x : LibC::Int, y : LibC::Int, width : LibC::Int, height : LibC::Int, ...) : LibC::Int
  fun vips_gravity(in : VipsImage*, out : VipsImage**, direction : VipsCompassDirection, width : LibC::Int, height : LibC::Int, ...) : LibC::Int
  enum VipsCompassDirection
    VipsCompassDirectionCentre    = 0
    VipsCompassDirectionNorth     = 1
    VipsCompassDirectionEast      = 2
    VipsCompassDirectionSouth     = 3
    VipsCompassDirectionWest      = 4
    VipsCompassDirectionNorthEast = 5
    VipsCompassDirectionSouthEast = 6
    VipsCompassDirectionSouthWest = 7
    VipsCompassDirectionNorthWest = 8
    VipsCompassDirectionLast      = 9
  end
  fun vips_flip(in : VipsImage*, out : VipsImage**, direction : VipsDirection, ...) : LibC::Int
  enum VipsDirection
    VipsDirectionHorizontal = 0
    VipsDirectionVertical   = 1
    VipsDirectionLast       = 2
  end
  fun vips_insert(main : VipsImage*, sub : VipsImage*, out : VipsImage**, x : LibC::Int, y : LibC::Int, ...) : LibC::Int
  fun vips_join(in1 : VipsImage*, in2 : VipsImage*, out : VipsImage**, direction : VipsDirection, ...) : LibC::Int
  fun vips_arrayjoin(in : VipsImage**, out : VipsImage**, n : LibC::Int, ...) : LibC::Int
  fun vips_extract_area(in : VipsImage*, out : VipsImage**, left : LibC::Int, top : LibC::Int, width : LibC::Int, height : LibC::Int, ...) : LibC::Int
  fun vips_crop(in : VipsImage*, out : VipsImage**, left : LibC::Int, top : LibC::Int, width : LibC::Int, height : LibC::Int, ...) : LibC::Int
  fun vips_smartcrop(in : VipsImage*, out : VipsImage**, width : LibC::Int, height : LibC::Int, ...) : LibC::Int
  fun vips_extract_band(in : VipsImage*, out : VipsImage**, band : LibC::Int, ...) : LibC::Int
  fun vips_replicate(in : VipsImage*, out : VipsImage**, across : LibC::Int, down : LibC::Int, ...) : LibC::Int
  fun vips_grid(in : VipsImage*, out : VipsImage**, tile_height : LibC::Int, across : LibC::Int, down : LibC::Int, ...) : LibC::Int
  fun vips_transpose3d(in : VipsImage*, out : VipsImage**, ...) : LibC::Int
  fun vips_wrap(in : VipsImage*, out : VipsImage**, ...) : LibC::Int
  fun vips_rot(in : VipsImage*, out : VipsImage**, angle : VipsAngle, ...) : LibC::Int
  enum VipsAngle
    VipsAngleD0   = 0
    VipsAngleD90  = 1
    VipsAngleD180 = 2
    VipsAngleD270 = 3
    VipsAngleLast = 4
  end
  fun vips_rot90(in : VipsImage*, out : VipsImage**, ...) : LibC::Int
  fun vips_rot180(in : VipsImage*, out : VipsImage**, ...) : LibC::Int
  fun vips_rot270(in : VipsImage*, out : VipsImage**, ...) : LibC::Int
  fun vips_rot45(in : VipsImage*, out : VipsImage**, ...) : LibC::Int
  fun vips_autorot_remove_angle(image : VipsImage*)
  fun vips_autorot(in : VipsImage*, out : VipsImage**, ...) : LibC::Int
  fun vips_zoom(in : VipsImage*, out : VipsImage**, xfac : LibC::Int, yfac : LibC::Int, ...) : LibC::Int
  fun vips_subsample(in : VipsImage*, out : VipsImage**, xfac : LibC::Int, yfac : LibC::Int, ...) : LibC::Int
  fun vips_cast(in : VipsImage*, out : VipsImage**, format : VipsBandFormat, ...) : LibC::Int
  fun vips_cast_uchar(in : VipsImage*, out : VipsImage**, ...) : LibC::Int
  fun vips_cast_char(in : VipsImage*, out : VipsImage**, ...) : LibC::Int
  fun vips_cast_ushort(in : VipsImage*, out : VipsImage**, ...) : LibC::Int
  fun vips_cast_short(in : VipsImage*, out : VipsImage**, ...) : LibC::Int
  fun vips_cast_uint(in : VipsImage*, out : VipsImage**, ...) : LibC::Int
  fun vips_cast_int(in : VipsImage*, out : VipsImage**, ...) : LibC::Int
  fun vips_cast_float(in : VipsImage*, out : VipsImage**, ...) : LibC::Int
  fun vips_cast_double(in : VipsImage*, out : VipsImage**, ...) : LibC::Int
  fun vips_cast_complex(in : VipsImage*, out : VipsImage**, ...) : LibC::Int
  fun vips_cast_dpcomplex(in : VipsImage*, out : VipsImage**, ...) : LibC::Int
  fun vips_scale(in : VipsImage*, out : VipsImage**, ...) : LibC::Int
  fun vips_msb(in : VipsImage*, out : VipsImage**, ...) : LibC::Int
  fun vips_byteswap(in : VipsImage*, out : VipsImage**, ...) : LibC::Int
  fun vips_bandjoin(in : VipsImage**, out : VipsImage**, n : LibC::Int, ...) : LibC::Int
  fun vips_bandjoin2(in1 : VipsImage*, in2 : VipsImage*, out : VipsImage**, ...) : LibC::Int
  fun vips_bandjoin_const(in : VipsImage*, out : VipsImage**, c : LibC::Double*, n : LibC::Int, ...) : LibC::Int
  fun vips_bandjoin_const1(in : VipsImage*, out : VipsImage**, c : LibC::Double, ...) : LibC::Int
  fun vips_bandrank(in : VipsImage**, out : VipsImage**, n : LibC::Int, ...) : LibC::Int
  fun vips_bandfold(in : VipsImage*, out : VipsImage**, ...) : LibC::Int
  fun vips_bandunfold(in : VipsImage*, out : VipsImage**, ...) : LibC::Int
  fun vips_bandbool(in : VipsImage*, out : VipsImage**, boolean : VipsOperationBoolean, ...) : LibC::Int
  fun vips_bandand(in : VipsImage*, out : VipsImage**, ...) : LibC::Int
  fun vips_bandor(in : VipsImage*, out : VipsImage**, ...) : LibC::Int
  fun vips_bandeor(in : VipsImage*, out : VipsImage**, ...) : LibC::Int
  fun vips_bandmean(in : VipsImage*, out : VipsImage**, ...) : LibC::Int
  fun vips_recomb(in : VipsImage*, out : VipsImage**, m : VipsImage*, ...) : LibC::Int
  fun vips_ifthenelse(cond : VipsImage*, in1 : VipsImage*, in2 : VipsImage*, out : VipsImage**, ...) : LibC::Int
  fun vips_switch(tests : VipsImage**, out : VipsImage**, n : LibC::Int, ...) : LibC::Int
  fun vips_flatten(in : VipsImage*, out : VipsImage**, ...) : LibC::Int
  fun vips_addalpha(in : VipsImage*, out : VipsImage**, ...) : LibC::Int
  fun vips_premultiply(in : VipsImage*, out : VipsImage**, ...) : LibC::Int
  fun vips_unpremultiply(in : VipsImage*, out : VipsImage**, ...) : LibC::Int
  fun vips_composite(in : VipsImage**, out : VipsImage**, n : LibC::Int, mode : LibC::Int*, ...) : LibC::Int
  fun vips_composite2(base : VipsImage*, overlay : VipsImage*, out : VipsImage**, mode1 : VipsBlendMode, ...) : LibC::Int
  enum VipsBlendMode
    VipsBlendModeClear       =  0
    VipsBlendModeSource      =  1
    VipsBlendModeOver        =  2
    VipsBlendModeIn          =  3
    VipsBlendModeOut         =  4
    VipsBlendModeAtop        =  5
    VipsBlendModeDest        =  6
    VipsBlendModeDestOver    =  7
    VipsBlendModeDestIn      =  8
    VipsBlendModeDestOut     =  9
    VipsBlendModeDestAtop    = 10
    VipsBlendModeXor         = 11
    VipsBlendModeAdd         = 12
    VipsBlendModeSaturate    = 13
    VipsBlendModeMultiply    = 14
    VipsBlendModeScreen      = 15
    VipsBlendModeOverlay     = 16
    VipsBlendModeDarken      = 17
    VipsBlendModeLighten     = 18
    VipsBlendModeColourDodge = 19
    VipsBlendModeColourBurn  = 20
    VipsBlendModeHardLight   = 21
    VipsBlendModeSoftLight   = 22
    VipsBlendModeDifference  = 23
    VipsBlendModeExclusion   = 24
    VipsBlendModeLast        = 25
  end
  fun vips_falsecolour(in : VipsImage*, out : VipsImage**, ...) : LibC::Int
  fun vips_gamma(in : VipsImage*, out : VipsImage**, ...) : LibC::Int
  VipsCombineMax                = 0_i64
  VipsCombineSum                = 1_i64
  VipsCombineMin                = 2_i64
  VipsCombineLast               = 3_i64
  fun vips_conv(in : VipsImage*, out : VipsImage**, mask : VipsImage*, ...) : LibC::Int
  fun vips_convf(in : VipsImage*, out : VipsImage**, mask : VipsImage*, ...) : LibC::Int
  fun vips_convi(in : VipsImage*, out : VipsImage**, mask : VipsImage*, ...) : LibC::Int
  fun vips_conva(in : VipsImage*, out : VipsImage**, mask : VipsImage*, ...) : LibC::Int
  fun vips_convsep(in : VipsImage*, out : VipsImage**, mask : VipsImage*, ...) : LibC::Int
  fun vips_convasep(in : VipsImage*, out : VipsImage**, mask : VipsImage*, ...) : LibC::Int
  fun vips_compass(in : VipsImage*, out : VipsImage**, mask : VipsImage*, ...) : LibC::Int
  fun vips_gaussblur(in : VipsImage*, out : VipsImage**, sigma : LibC::Double, ...) : LibC::Int
  fun vips_sharpen(in : VipsImage*, out : VipsImage**, ...) : LibC::Int
  fun vips_spcor(in : VipsImage*, ref : VipsImage*, out : VipsImage**, ...) : LibC::Int
  fun vips_fastcor(in : VipsImage*, ref : VipsImage*, out : VipsImage**, ...) : LibC::Int
  fun vips_sobel(in : VipsImage*, out : VipsImage**, ...) : LibC::Int
  fun vips_canny(in : VipsImage*, out : VipsImage**, ...) : LibC::Int
  VipsOperationMorphologyErode = 0_i64
  VipsOperationMorphologyDilate = 1_i64
  VipsOperationMorphologyLast = 2_i64
  fun vips_morph(in : VipsImage*, out : VipsImage**, mask : VipsImage*, morph : VipsOperationMorphology, ...) : LibC::Int
  enum VipsOperationMorphology
    VipsOperationMorphologyErode  = 0
    VipsOperationMorphologyDilate = 1
    VipsOperationMorphologyLast   = 2
  end
  fun vips_rank(in : VipsImage*, out : VipsImage**, width : LibC::Int, height : LibC::Int, index : LibC::Int, ...) : LibC::Int
  fun vips_median(in : VipsImage*, out : VipsImage**, size : LibC::Int, ...) : LibC::Int
  fun vips_countlines(in : VipsImage*, nolines : LibC::Double*, direction : VipsDirection, ...) : LibC::Int
  fun vips_labelregions(in : VipsImage*, mask : VipsImage**, ...) : LibC::Int
  fun vips_fill_nearest(in : VipsImage*, out : VipsImage**, ...) : LibC::Int
  fun vips_merge(ref : VipsImage*, sec : VipsImage*, out : VipsImage**, direction : VipsDirection, dx : LibC::Int, dy : LibC::Int, ...) : LibC::Int
  fun vips_mosaic(ref : VipsImage*, sec : VipsImage*, out : VipsImage**, direction : VipsDirection, xref : LibC::Int, yref : LibC::Int, xsec : LibC::Int, ysec : LibC::Int, ...) : LibC::Int
  fun vips_mosaic1(ref : VipsImage*, sec : VipsImage*, out : VipsImage**, direction : VipsDirection, xr1 : LibC::Int, yr1 : LibC::Int, xs1 : LibC::Int, ys1 : LibC::Int, xr2 : LibC::Int, yr2 : LibC::Int, xs2 : LibC::Int, ys2 : LibC::Int, ...) : LibC::Int
  fun vips_match(ref : VipsImage*, sec : VipsImage*, out : VipsImage**, xr1 : LibC::Int, yr1 : LibC::Int, xs1 : LibC::Int, ys1 : LibC::Int, xr2 : LibC::Int, yr2 : LibC::Int, xs2 : LibC::Int, ys2 : LibC::Int, ...) : LibC::Int
  fun vips_globalbalance(in : VipsImage*, out : VipsImage**, ...) : LibC::Int
  fun vips_remosaic(in : VipsImage*, out : VipsImage**, old_str : LibC::Char*, new_str : LibC::Char*, ...) : LibC::Int
  fun vips_matrixinvert(m : VipsImage*, out : VipsImage**, ...) : LibC::Int
  fun vips_maplut(in : VipsImage*, out : VipsImage**, lut : VipsImage*, ...) : LibC::Int
  fun vips_percent(in : VipsImage*, percent : LibC::Double, threshold : LibC::Int*, ...) : LibC::Int
  fun vips_stdif(in : VipsImage*, out : VipsImage**, width : LibC::Int, height : LibC::Int, ...) : LibC::Int
  fun vips_hist_cum(in : VipsImage*, out : VipsImage**, ...) : LibC::Int
  fun vips_hist_norm(in : VipsImage*, out : VipsImage**, ...) : LibC::Int
  fun vips_hist_equal(in : VipsImage*, out : VipsImage**, ...) : LibC::Int
  fun vips_hist_plot(in : VipsImage*, out : VipsImage**, ...) : LibC::Int
  fun vips_hist_match(in : VipsImage*, ref : VipsImage*, out : VipsImage**, ...) : LibC::Int
  fun vips_hist_local(in : VipsImage*, out : VipsImage**, width : LibC::Int, height : LibC::Int, ...) : LibC::Int
  fun vips_hist_ismonotonic(in : VipsImage*, out : Gboolean*, ...) : LibC::Int
  fun vips_hist_entropy(in : VipsImage*, out : LibC::Double*, ...) : LibC::Int
  fun vips_case(index : VipsImage*, cases : VipsImage**, out : VipsImage**, n : LibC::Int, ...) : LibC::Int
  fun vips_fwfft(in : VipsImage*, out : VipsImage**, ...) : LibC::Int
  fun vips_invfft(in : VipsImage*, out : VipsImage**, ...) : LibC::Int
  fun vips_freqmult(in : VipsImage*, mask : VipsImage*, out : VipsImage**, ...) : LibC::Int
  fun vips_spectrum(in : VipsImage*, out : VipsImage**, ...) : LibC::Int
  fun vips_phasecor(in1 : VipsImage*, in2 : VipsImage*, out : VipsImage**, ...) : LibC::Int

  fun vips_shrink(in : VipsImage*, out : VipsImage**, hshrink : LibC::Double, vshrink : LibC::Double, ...) : LibC::Int
  fun vips_shrinkh(in : VipsImage*, out : VipsImage**, hshrink : LibC::Int, ...) : LibC::Int
  fun vips_shrinkv(in : VipsImage*, out : VipsImage**, vshrink : LibC::Int, ...) : LibC::Int
  fun vips_reduce(in : VipsImage*, out : VipsImage**, hshrink : LibC::Double, vshrink : LibC::Double, ...) : LibC::Int
  fun vips_reduceh(in : VipsImage*, out : VipsImage**, hshrink : LibC::Double, ...) : LibC::Int
  fun vips_reducev(in : VipsImage*, out : VipsImage**, vshrink : LibC::Double, ...) : LibC::Int
  fun vips_thumbnail(filename : LibC::Char*, out : VipsImage**, width : LibC::Int, ...) : LibC::Int
  fun vips_thumbnail_buffer(buf : Void*, len : LibC::SizeT, out : VipsImage**, width : LibC::Int, ...) : LibC::Int
  fun vips_thumbnail_image(in : VipsImage*, out : VipsImage**, width : LibC::Int, ...) : LibC::Int
  fun vips_thumbnail_source(source : VipsSource*, out : VipsImage**, width : LibC::Int, ...) : LibC::Int
  fun vips_similarity(in : VipsImage*, out : VipsImage**, ...) : LibC::Int
  fun vips_rotate(in : VipsImage*, out : VipsImage**, angle : LibC::Double, ...) : LibC::Int
  fun vips_affine(in : VipsImage*, out : VipsImage**, a : LibC::Double, b : LibC::Double, c : LibC::Double, d : LibC::Double, ...) : LibC::Int
  fun vips_resize(in : VipsImage*, out : VipsImage**, scale : LibC::Double, ...) : LibC::Int
  fun vips_mapim(in : VipsImage*, out : VipsImage**, index : VipsImage*, ...) : LibC::Int
  fun vips_quadratic(in : VipsImage*, out : VipsImage**, coeff : VipsImage*, ...) : LibC::Int

  fun vips_colourspace_issupported(image : VipsImage*) : Gboolean
  fun vips_colourspace(in : VipsImage*, out : VipsImage**, space : VipsInterpretation, ...) : LibC::Int
  fun vips_lab_q2s_rgb = vips_LabQ2sRGB(in : VipsImage*, out : VipsImage**, ...) : LibC::Int
  fun vips_rad2float(in : VipsImage*, out : VipsImage**, ...) : LibC::Int
  fun vips_float2rad(in : VipsImage*, out : VipsImage**, ...) : LibC::Int
  fun vips_lab_s2_lab_q = vips_LabS2LabQ(in : VipsImage*, out : VipsImage**, ...) : LibC::Int
  fun vips_lab_q2_lab_s = vips_LabQ2LabS(in : VipsImage*, out : VipsImage**, ...) : LibC::Int
  fun vips_lab_q2_lab = vips_LabQ2Lab(in : VipsImage*, out : VipsImage**, ...) : LibC::Int
  fun vips_lab2_lab_q = vips_Lab2LabQ(in : VipsImage*, out : VipsImage**, ...) : LibC::Int
  fun vips_l_ch2_lab = vips_LCh2Lab(in : VipsImage*, out : VipsImage**, ...) : LibC::Int
  fun vips_lab2_l_ch = vips_Lab2LCh(in : VipsImage*, out : VipsImage**, ...) : LibC::Int
  fun vips_yxy2_lab = vips_Yxy2Lab(in : VipsImage*, out : VipsImage**, ...) : LibC::Int
  fun vips_cmc2_xyz = vips_CMC2XYZ(in : VipsImage*, out : VipsImage**, ...) : LibC::Int
  fun vips_lab2_xyz = vips_Lab2XYZ(in : VipsImage*, out : VipsImage**, ...) : LibC::Int
  fun vips_xyz2_lab = vips_XYZ2Lab(in : VipsImage*, out : VipsImage**, ...) : LibC::Int
  fun vips_xyz2sc_rgb = vips_XYZ2scRGB(in : VipsImage*, out : VipsImage**, ...) : LibC::Int
  fun vips_sc_rgb2s_rgb = vips_scRGB2sRGB(in : VipsImage*, out : VipsImage**, ...) : LibC::Int
  fun vips_sc_rgb2_bw = vips_scRGB2BW(in : VipsImage*, out : VipsImage**, ...) : LibC::Int
  fun vips_s_rgb2sc_rgb = vips_sRGB2scRGB(in : VipsImage*, out : VipsImage**, ...) : LibC::Int
  fun vips_sc_rgb2_xyz = vips_scRGB2XYZ(in : VipsImage*, out : VipsImage**, ...) : LibC::Int
  fun vips_hsv2s_rgb = vips_HSV2sRGB(in : VipsImage*, out : VipsImage**, ...) : LibC::Int
  fun vips_s_rgb2_hsv = vips_sRGB2HSV(in : VipsImage*, out : VipsImage**, ...) : LibC::Int
  fun vips_l_ch2_cmc = vips_LCh2CMC(in : VipsImage*, out : VipsImage**, ...) : LibC::Int
  fun vips_cmc2_l_ch = vips_CMC2LCh(in : VipsImage*, out : VipsImage**, ...) : LibC::Int
  fun vips_xyz2_yxy = vips_XYZ2Yxy(in : VipsImage*, out : VipsImage**, ...) : LibC::Int
  fun vips_yxy2_xyz = vips_Yxy2XYZ(in : VipsImage*, out : VipsImage**, ...) : LibC::Int
  fun vips_lab_s2_lab = vips_LabS2Lab(in : VipsImage*, out : VipsImage**, ...) : LibC::Int
  fun vips_lab2_lab_s = vips_Lab2LabS(in : VipsImage*, out : VipsImage**, ...) : LibC::Int
  fun vips_cmyk2_xyz = vips_CMYK2XYZ(in : VipsImage*, out : VipsImage**, ...) : LibC::Int
  fun vips_xyz2_cmyk = vips_XYZ2CMYK(in : VipsImage*, out : VipsImage**, ...) : LibC::Int
  fun vips_profile_load(name : LibC::Char*, profile : VipsBlob**, ...) : LibC::Int
  fun vips_icc_present : LibC::Int
  fun vips_icc_transform(in : VipsImage*, out : VipsImage**, output_profile : LibC::Char*, ...) : LibC::Int
  fun vips_icc_import(in : VipsImage*, out : VipsImage**, ...) : LibC::Int
  fun vips_icc_export(in : VipsImage*, out : VipsImage**, ...) : LibC::Int
  fun vips_icc_ac2rc(in : VipsImage*, out : VipsImage**, profile_filename : LibC::Char*) : LibC::Int
  fun vips_icc_is_compatible_profile(image : VipsImage*, data : Void*, data_length : LibC::SizeT) : Gboolean
  fun vips_d_e76 = vips_dE76(left : VipsImage*, right : VipsImage*, out : VipsImage**, ...) : LibC::Int
  fun vips_d_e00 = vips_dE00(left : VipsImage*, right : VipsImage*, out : VipsImage**, ...) : LibC::Int
  fun vips_d_ecmc = vips_dECMC(left : VipsImage*, right : VipsImage*, out : VipsImage**, ...) : LibC::Int
  fun vips_col_lab2_xyz = vips_col_Lab2XYZ(l : LibC::Float, a : LibC::Float, b : LibC::Float, x : LibC::Float*, y : LibC::Float*, z : LibC::Float*)
  fun vips_col_xyz2_lab = vips_col_XYZ2Lab(x : LibC::Float, y : LibC::Float, z : LibC::Float, l : LibC::Float*, a : LibC::Float*, b : LibC::Float*)
  fun vips_col_ab2h(a : LibC::Double, b : LibC::Double) : LibC::Double
  fun vips_col_ab2_ch = vips_col_ab2Ch(a : LibC::Float, b : LibC::Float, c : LibC::Float*, h : LibC::Float*)
  fun vips_col_ch2ab = vips_col_Ch2ab(c : LibC::Float, h : LibC::Float, a : LibC::Float*, b : LibC::Float*)
  fun vips_col_l2_lcmc = vips_col_L2Lcmc(l : LibC::Float) : LibC::Float
  fun vips_col_c2_ccmc = vips_col_C2Ccmc(c : LibC::Float) : LibC::Float
  fun vips_col_ch2hcmc = vips_col_Ch2hcmc(c : LibC::Float, h : LibC::Float) : LibC::Float
  fun vips_col_make_tables_cmc = vips_col_make_tables_CMC
  fun vips_col_lcmc2_l = vips_col_Lcmc2L(lcmc : LibC::Float) : LibC::Float
  fun vips_col_ccmc2_c = vips_col_Ccmc2C(ccmc : LibC::Float) : LibC::Float
  fun vips_col_chcmc2h = vips_col_Chcmc2h(c : LibC::Float, hcmc : LibC::Float) : LibC::Float
  fun vips_col_s_rgb2sc_rgb_8 = vips_col_sRGB2scRGB_8(r : LibC::Int, g : LibC::Int, b : LibC::Int, r_ptr : LibC::Float*, g_ptr : LibC::Float*, b_ptr : LibC::Float*) : LibC::Int
  fun vips_col_s_rgb2sc_rgb_16 = vips_col_sRGB2scRGB_16(r : LibC::Int, g : LibC::Int, b : LibC::Int, r_ptr : LibC::Float*, g_ptr : LibC::Float*, b_ptr : LibC::Float*) : LibC::Int
  fun vips_col_s_rgb2sc_rgb_8_noclip = vips_col_sRGB2scRGB_8_noclip(r : LibC::Int, g : LibC::Int, b : LibC::Int, r_ptr : LibC::Float*, g_ptr : LibC::Float*, b_ptr : LibC::Float*) : LibC::Int
  fun vips_col_s_rgb2sc_rgb_16_noclip = vips_col_sRGB2scRGB_16_noclip(r : LibC::Int, g : LibC::Int, b : LibC::Int, r_ptr : LibC::Float*, g_ptr : LibC::Float*, b_ptr : LibC::Float*) : LibC::Int
  fun vips_col_sc_rgb2_xyz = vips_col_scRGB2XYZ(r : LibC::Float, g : LibC::Float, b : LibC::Float, x : LibC::Float*, y : LibC::Float*, z : LibC::Float*) : LibC::Int
  fun vips_col_xyz2sc_rgb = vips_col_XYZ2scRGB(x : LibC::Float, y : LibC::Float, z : LibC::Float, r : LibC::Float*, g : LibC::Float*, b : LibC::Float*) : LibC::Int
  fun vips_col_sc_rgb2s_rgb_8 = vips_col_scRGB2sRGB_8(r : LibC::Float, g : LibC::Float, b : LibC::Float, r_ptr : LibC::Int*, g_ptr : LibC::Int*, b_ptr : LibC::Int*, og : LibC::Int*) : LibC::Int
  fun vips_col_sc_rgb2s_rgb_16 = vips_col_scRGB2sRGB_16(r : LibC::Float, g : LibC::Float, b : LibC::Float, r_ptr : LibC::Int*, g_ptr : LibC::Int*, b_ptr : LibC::Int*, og : LibC::Int*) : LibC::Int
  fun vips_col_sc_rgb2_bw_16 = vips_col_scRGB2BW_16(r : LibC::Float, g : LibC::Float, b : LibC::Float, g_ptr : LibC::Int*, og : LibC::Int*) : LibC::Int
  fun vips_col_sc_rgb2_bw_8 = vips_col_scRGB2BW_8(r : LibC::Float, g : LibC::Float, b : LibC::Float, g_ptr : LibC::Int*, og : LibC::Int*) : LibC::Int
  fun vips_pythagoras(l1 : LibC::Float, a1 : LibC::Float, b1 : LibC::Float, l2 : LibC::Float, a2 : LibC::Float, b2 : LibC::Float) : LibC::Float
  fun vips_col_d_e00 = vips_col_dE00(l1 : LibC::Float, a1 : LibC::Float, b1 : LibC::Float, l2 : LibC::Float, a2 : LibC::Float, b2 : LibC::Float) : LibC::Float

  fun vips_draw_rect(image : VipsImage*, ink : LibC::Double*, n : LibC::Int, left : LibC::Int, top : LibC::Int, width : LibC::Int, height : LibC::Int, ...) : LibC::Int
  fun vips_draw_rect1(image : VipsImage*, ink : LibC::Double, left : LibC::Int, top : LibC::Int, width : LibC::Int, height : LibC::Int, ...) : LibC::Int
  fun vips_draw_point(image : VipsImage*, ink : LibC::Double*, n : LibC::Int, x : LibC::Int, y : LibC::Int, ...) : LibC::Int
  fun vips_draw_point1(image : VipsImage*, ink : LibC::Double, x : LibC::Int, y : LibC::Int, ...) : LibC::Int
  fun vips_draw_image(image : VipsImage*, sub : VipsImage*, x : LibC::Int, y : LibC::Int, ...) : LibC::Int
  fun vips_draw_mask(image : VipsImage*, ink : LibC::Double*, n : LibC::Int, mask : VipsImage*, x : LibC::Int, y : LibC::Int, ...) : LibC::Int
  fun vips_draw_mask1(image : VipsImage*, ink : LibC::Double, mask : VipsImage*, x : LibC::Int, y : LibC::Int, ...) : LibC::Int
  fun vips_draw_line(image : VipsImage*, ink : LibC::Double*, n : LibC::Int, x1 : LibC::Int, y1 : LibC::Int, x2 : LibC::Int, y2 : LibC::Int, ...) : LibC::Int
  fun vips_draw_line1(image : VipsImage*, ink : LibC::Double, x1 : LibC::Int, y1 : LibC::Int, x2 : LibC::Int, y2 : LibC::Int, ...) : LibC::Int
  fun vips_draw_circle(image : VipsImage*, ink : LibC::Double*, n : LibC::Int, cx : LibC::Int, cy : LibC::Int, radius : LibC::Int, ...) : LibC::Int
  fun vips_draw_circle1(image : VipsImage*, ink : LibC::Double, cx : LibC::Int, cy : LibC::Int, radius : LibC::Int, ...) : LibC::Int
  fun vips_draw_flood(image : VipsImage*, ink : LibC::Double*, n : LibC::Int, x : LibC::Int, y : LibC::Int, ...) : LibC::Int
  fun vips_draw_flood1(image : VipsImage*, ink : LibC::Double, x : LibC::Int, y : LibC::Int, ...) : LibC::Int
  fun vips_draw_smudge(image : VipsImage*, left : LibC::Int, top : LibC::Int, width : LibC::Int, height : LibC::Int, ...) : LibC::Int
  fun vips_black(out : VipsImage**, width : LibC::Int, height : LibC::Int, ...) : LibC::Int
  fun vips_xyz(out : VipsImage**, width : LibC::Int, height : LibC::Int, ...) : LibC::Int
  fun vips_grey(out : VipsImage**, width : LibC::Int, height : LibC::Int, ...) : LibC::Int
  fun vips_gaussmat(out : VipsImage**, sigma : LibC::Double, min_ampl : LibC::Double, ...) : LibC::Int
  fun vips_logmat(out : VipsImage**, sigma : LibC::Double, min_ampl : LibC::Double, ...) : LibC::Int
  fun vips_text(out : VipsImage**, text : LibC::Char*, ...) : LibC::Int
  fun vips_gaussnoise(out : VipsImage**, width : LibC::Int, height : LibC::Int, ...) : LibC::Int
  fun vips_eye(out : VipsImage**, width : LibC::Int, height : LibC::Int, ...) : LibC::Int
  fun vips_sines(out : VipsImage**, width : LibC::Int, height : LibC::Int, ...) : LibC::Int
  fun vips_zone(out : VipsImage**, width : LibC::Int, height : LibC::Int, ...) : LibC::Int
  fun vips_identity(out : VipsImage**, ...) : LibC::Int
  fun vips_buildlut(in : VipsImage*, out : VipsImage**, ...) : LibC::Int
  fun vips_invertlut(in : VipsImage*, out : VipsImage**, ...) : LibC::Int
  fun vips_tonelut(out : VipsImage**, ...) : LibC::Int
  fun vips_mask_ideal(out : VipsImage**, width : LibC::Int, height : LibC::Int, frequency_cutoff : LibC::Double, ...) : LibC::Int
  fun vips_mask_ideal_ring(out : VipsImage**, width : LibC::Int, height : LibC::Int, frequency_cutoff : LibC::Double, ringwidth : LibC::Double, ...) : LibC::Int
  fun vips_mask_ideal_band(out : VipsImage**, width : LibC::Int, height : LibC::Int, frequency_cutoff_x : LibC::Double, frequency_cutoff_y : LibC::Double, radius : LibC::Double, ...) : LibC::Int
  fun vips_mask_butterworth(out : VipsImage**, width : LibC::Int, height : LibC::Int, order : LibC::Double, frequency_cutoff : LibC::Double, amplitude_cutoff : LibC::Double, ...) : LibC::Int
  fun vips_mask_butterworth_ring(out : VipsImage**, width : LibC::Int, height : LibC::Int, order : LibC::Double, frequency_cutoff : LibC::Double, amplitude_cutoff : LibC::Double, ringwidth : LibC::Double, ...) : LibC::Int
  fun vips_mask_butterworth_band(out : VipsImage**, width : LibC::Int, height : LibC::Int, order : LibC::Double, frequency_cutoff_x : LibC::Double, frequency_cutoff_y : LibC::Double, radius : LibC::Double, amplitude_cutoff : LibC::Double, ...) : LibC::Int
  fun vips_mask_gaussian(out : VipsImage**, width : LibC::Int, height : LibC::Int, frequency_cutoff : LibC::Double, amplitude_cutoff : LibC::Double, ...) : LibC::Int
  fun vips_mask_gaussian_ring(out : VipsImage**, width : LibC::Int, height : LibC::Int, frequency_cutoff : LibC::Double, amplitude_cutoff : LibC::Double, ringwidth : LibC::Double, ...) : LibC::Int
  fun vips_mask_gaussian_band(out : VipsImage**, width : LibC::Int, height : LibC::Int, frequency_cutoff_x : LibC::Double, frequency_cutoff_y : LibC::Double, radius : LibC::Double, amplitude_cutoff : LibC::Double, ...) : LibC::Int
  fun vips_mask_fractal(out : VipsImage**, width : LibC::Int, height : LibC::Int, fractal_dimension : LibC::Double, ...) : LibC::Int
  fun vips_fractsurf(out : VipsImage**, width : LibC::Int, height : LibC::Int, fractal_dimension : LibC::Double, ...) : LibC::Int
  fun vips_worley(out : VipsImage**, width : LibC::Int, height : LibC::Int, ...) : LibC::Int
  fun vips_perlin(out : VipsImage**, width : LibC::Int, height : LibC::Int, ...) : LibC::Int
  fun vips_init(argv0 : LibC::Char*) : LibC::Int
  fun vips_get_argv0 : LibC::Char*
  fun vips_get_prgname : LibC::Char*
  fun vips_shutdown
  fun vips_thread_shutdown
  fun vips_add_option_entries(option_group : GOptionGroup)
  fun vips_leak_set(leak : Gboolean)
  fun vips_version_string : LibC::Char*
  fun vips_version(flag : LibC::Int) : LibC::Int
  fun vips_guess_prefix(argv0 : LibC::Char*, env_name : LibC::Char*) : LibC::Char*
  fun vips_guess_libdir(argv0 : LibC::Char*, env_name : LibC::Char*) : LibC::Char*

  fun vips_vector_isenabled : Gboolean
  fun vips_vector_set_enabled(enabled : Gboolean)

  $vips__thread_profile : Gboolean

  alias ReadCB = (Void*, Void*, Gint64, Void* -> Gint)
  alias SeekCB = (Void*, Gint64, Gint, Void* -> Gint64)
  alias WriteCB = (Void*, UInt8*, Gint, Void* -> Gint64)
  alias FinishCB = (Void*, Void* ->)
end
