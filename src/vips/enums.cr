module Vips::Enums
  enum Access
    # Requests can come in any order
    Random = 0

    # Means requests will be top-to-bottom, but with some
    # amount of buffering behind the read point for small non-local
    # accesses.
    Sequential = 1

    # Top-to-bottom without a buffer.
    SequentialUnbuffered = 2
  end

  # Various types of alignment.
  enum Align
    # Align on the low coordinate edge
    Low = 0

    # Align on the centre.
    Centre = 1

    # Align on the high coordinate edge
    High = 2
  end

  enum Angle
    D0   = 0
    D90  = 1
    D180 = 2
    D270 = 3
  end

  enum Angle45
    D0   = 0
    D45  = 1
    D90  = 2
    D135 = 3
    D180 = 4
    D225 = 5
    D270 = 6
    D315 = 7
  end

  enum BandFormat
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
  end

  enum BlendMode
    Clear       =  0
    Source      =  1
    Over        =  2
    In          =  3
    Out         =  4
    Atop        =  5
    Dest        =  6
    DestOver    =  7
    DestIn      =  8
    DestOut     =  9
    DestAtop    = 10
    Xor         = 11
    Add         = 12
    Saturate    = 13
    Multiply    = 14
    Screen      = 15
    Overlay     = 16
    Darken      = 17
    Lighten     = 18
    ColourDodge = 19
    ColourBurn  = 20
    HardLight   = 21
    SoftLight   = 22
    Difference  = 23
    Exclusion   = 24
  end

  enum Coding
    Error = -1
    None  =  0
    Labq  =  2
    Rad   =  6
  end

  enum Combine
    Max = 0
    Sum = 1
    Min = 2
  end

  enum CombineMode
    Set = 0
    Add = 1
  end

  enum CompassDirection
    Centre    = 0
    North     = 1
    East      = 2
    South     = 3
    West      = 4
    NorthEast = 5
    SouthEast = 6
    SouthWest = 7
    NorthWest = 8
  end

  enum DemandStyle
    Error     = -1
    Smalltile =  0
    Fatstrip  =  1
    Thinstrip =  2
  end

  enum Direction
    Horizontal = 0
    Vertical   = 1
  end

  enum Extend
    Black      = 0
    Copy       = 1
    Repeat     = 2
    Mirror     = 3
    White      = 4
    Background = 5
  end

  # How sensitive loaders are to errors, from never stop (very insensitive), to
  # stop on the smallest warning (very sensitive).
  #
  # Each one implies the ones before it, so `Error` implies `Truncated`
  enum FailOn
    # Never stop
    None = 0

    # Stop on image truncated, nothing else
    Truncated = 1

    # Stop on serious error or truncation
    Error = 2

    # Stop on anything, even warnings
    Warning = 3
  end

  enum ForeignDzContainer
    Fs  = 0
    Zip = 1
    Szi = 2
  end

  enum ForeignDzDepth
    Onepixel = 0
    Onetile  = 1
    One      = 2
  end

  enum ForeignDzLayout
    Dz      = 0
    Zoomify = 1
    Google  = 2
    Iiif    = 3
    Iiif3   = 4
  end

  enum ForeignHeifCompression
    Hevc = 1
    Avc  = 2
    Jpeg = 3
    Av1  = 4
  end

  enum ForeignJpegSubsample
    Auto = 0
    On   = 1
    Off  = 2
  end

  enum ForeignPpmFormat
    Pbm = 0
    Pgm = 1
    Ppm = 2
    Pfm = 3
  end

  enum ForeignSubsample
    Auto = 0
    On   = 1
    Off  = 2
  end

  enum ForeignTiffCompression
    None      = 0
    Jpeg      = 1
    Deflate   = 2
    Packbits  = 3
    Ccittfax4 = 4
    Lzw       = 5
    Webp      = 6
    Zstd      = 7
    Jp2k      = 8
  end

  enum ForeignTiffPredictor
    None       = 1
    Horizontal = 2
    Float      = 3
  end

  enum ForeignTiffResunit
    Cm   = 0
    Inch = 1
  end

  enum ForeignWebpPreset
    Default = 0
    Picture = 1
    Photo   = 2
    Drawing = 3
    Icon    = 4
    Text    = 5
  end

  enum ImageType
    Error         = -1
    None          =  0
    Setbuf        =  1
    SetbufForeign =  2
    Openin        =  3
    Mmapin        =  4
    Mmapinrw      =  5
    Openout       =  6
  end

  enum Intent
    Perceptual = 0
    Relative   = 1
    Saturation = 2
    Absolute   = 3
  end

  enum Interesting
    None      = 0
    Centre    = 1
    Entropy   = 2
    Attention = 3
    Low       = 4
    High      = 5
    All       = 6
  end

  enum Interpretation
    Error     = -1
    Multiband =  0
    Bw        =  1
    Histogram = 10
    Xyz       = 12
    Lab       = 13
    Cmyk      = 15
    Labq      = 16
    Rgb       = 17
    Cmc       = 18
    Lch       = 19
    Labs      = 21
    Srgb      = 22
    Yxy       = 23
    Fourier   = 24
    Rgb16     = 25
    Grey16    = 26
    Matrix    = 27
    Scrgb     = 28
    Hsv       = 29
  end

  enum Kernel
    Nearest  = 0
    Linear   = 1
    Cubic    = 2
    Mitchell = 3
    Lanczos2 = 4
    Lanczos3 = 5
  end

  enum OperationBoolean
    And    = 0
    Or     = 1
    Eor    = 2
    Lshift = 3
    Rshift = 4
  end

  enum OperationComplex
    Polar = 0
    Rect  = 1
    Conj  = 2
  end

  enum OperationComplex2
    CrossPhase = 0
  end

  enum OperationComplexget
    Real = 0
    Imag = 1
  end

  enum OperationMath
    Sin   =  0
    Cos   =  1
    Tan   =  2
    Asin  =  3
    Acos  =  4
    Atan  =  5
    Log   =  6
    Log10 =  7
    Exp   =  8
    Exp10 =  9
    Sinh  = 10
    Cosh  = 11
    Tanh  = 12
    Asinh = 13
    Acosh = 14
    Atanh = 15
  end

  enum OperationMath2
    Pow   = 0
    Wop   = 1
    Atan2 = 2
  end

  enum OperationMorphology
    Erode  = 0
    Dilate = 1
  end

  enum OperationRelational
    Equal  = 0
    Noteq  = 1
    Less   = 2
    Lesseq = 3
    More   = 4
    Moreeq = 5
  end

  enum OperationRound
    Rint  = 0
    Ceil  = 1
    Floor = 2
  end

  enum PCS
    Lab = 0
    Xyz = 1
  end

  enum Precision
    Integer     = 0
    Float       = 1
    Approximate = 2
  end

  enum RegionShrink
    Mean    = 0
    Median  = 1
    Mode    = 2
    Max     = 3
    Min     = 4
    Nearest = 5
  end

  enum Saveable
    Mono     = 0
    Rgb      = 1
    Rgba     = 2
    RgbaOnly = 3
    RgbCmyk  = 4
    Any      = 5
  end

  enum Size
    Both  = 0
    Up    = 1
    Down  = 2
    Force = 3
  end

  enum Token
    Left   = 1
    Right  = 2
    String = 3
    Equals = 4
  end

  @[Flags]
  enum OperationFlags
    Sequential           = 1
    SequentialUnbuffered = 2
    Nocache              = 4
    Deprecated           = 8
  end

  @[Flags]
  enum ForeignFlags
    Partial    = 1
    Bigendian  = 2
    Sequential = 4
  end

  # Signals that can be used on an `Image`. See `GObject#signal_connect`
  enum Signal
    # Evaluation is starting
    # The preeval signal is emitted once before computation of `Image` starts.
    # It's a good place to set up evaluation feedback.
    PreEval = 0

    # The eval signal is emitted once per work unit (typically a 128 x 128 are of pixels)
    # during image computation
    #
    # You can use this signal to update user-interfaces with progress feedback.
    # Beware of updating too frequently: you will usually need some throttling mechanism
    Eval = 1

    # Ealuation is ending
    # The posteval signal is emitted once at the end of the computation of `Image`.
    # It's a good place to shut down evaluation feedback.
    PostEval = 2
  end

  # :nodoc:
  protected def self.add_failon(optionals : Optional, failon : Enums::FailOn?)
    return if failon.nil?
    if Vips.at_least_libvips?(8, 12)
      optionals["fail_on"] = failon.value
    else
      # The deprecated "fail" param was at the highest sensitivity (>= warning),
      # but for compat it would be more correct to set this to true only when
      # a non-permissive enum is given (> none).
      optionals["fail"] = failon > FailOn::None
    end
  end
end
