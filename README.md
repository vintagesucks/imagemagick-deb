# imagemagick-deb
[![Build](https://github.com/vintagesucks/imagemagick-deb/actions/workflows/build.yml/badge.svg)](https://github.com/vintagesucks/imagemagick-deb/actions/workflows/build.yml) [![Update ImageMagick](https://github.com/vintagesucks/imagemagick-deb/actions/workflows/update-imagemagick.yml/badge.svg)](https://github.com/vintagesucks/imagemagick-deb/actions/workflows/update-imagemagick.yml) [![Update libde265](https://github.com/vintagesucks/imagemagick-deb/actions/workflows/update-libde265.yml/badge.svg)](https://github.com/vintagesucks/imagemagick-deb/actions/workflows/update-libde265.yml) [![Update libheif](https://github.com/vintagesucks/imagemagick-deb/actions/workflows/update-libheif.yml/badge.svg)](https://github.com/vintagesucks/imagemagick-deb/actions/workflows/update-libheif.yml) [![Dependabot](https://badgen.net/badge/Dependabot/enabled/green?icon=dependabot)](https://dependabot.com/)

[ImageMagick](https://imagemagick.org/) packaging for Ubuntu 22.04 (amd64) built with [CheckInstall](https://asic-linux.com.mx/~izto/checkinstall/).

Goals:
* [x] Functionality on par with the [ImageMagick Homebrew Formula](https://github.com/Homebrew/homebrew-core/blob/master/Formula/imagemagick.rb)
* [x] Compatibility with the [Imagick php extension](https://pecl.php.net/package/imagick) (PECL)

> **Warning**  
> [Released packages](https://github.com/vintagesucks/imagemagick-deb/releases) are for demonstration purposes only and are not suitable for production use.

#### Building
Linux and Mac
```sh
DOCKER_BUILDKIT=1 docker build --tag imagemagick-deb --output binaries .
```

Windows
```ps1
$env:DOCKER_BUILDKIT = 1
docker build --tag imagemagick-deb --output binaries .
```

The packages can be found in the `./binaries` folder after the build.

#### Example Setup
```sh
apt-get update
apt install ./binaries/libde265_*.deb
apt install -y ./binaries/libheif_*.deb
apt install -y ./binaries/imagemagick_*.deb
ldconfig
```

The packages will automatically resolve their own dependencies when installed with `-y`.

#### Example Output
```sh
$ magick --version
Version: ImageMagick 7.1.1-17 Q16-HDRI x86_64 354c3e45e:20230919 https://imagemagick.org
Copyright: (C) 1999 ImageMagick Studio LLC
License: https://imagemagick.org/script/license.php
Features: Cipher DPC HDRI Modules OpenMP(4.5) 
Delegates (built-in): bzlib fontconfig freetype gslib heic jbig jng jp2 jpeg lcms lqr ltdl lzma openexr png ps raw tiff webp x xml zlib
Compiler: gcc (11.4)

$ magick -list format
   Format  Module    Mode  Description
-------------------------------------------------------------------------------
      3FR  DNG       r--   Hasselblad CFV/H3D39II (0.20.2-Release)
      3G2  VIDEO     r--   Media Container
      3GP  VIDEO     r--   Media Container
      AAI* AAI       rw+   AAI Dune image
       AI  PDF       rw-   Adobe Illustrator CS2
     APNG  VIDEO     rw+   Animated Portable Network Graphics
      ART* ART       rw-   PFS: 1st Publisher Clip Art
      ARW  DNG       r--   Sony Alpha Raw Image Format (0.20.2-Release)
   ASHLAR* ASHLAR    -w+   Image sequence laid out in continuous irregular courses
      AVI  VIDEO     r--   Microsoft Audio/Visual Interleaved
     AVIF  HEIC      rw+   AV1 Image File Format (1.16.2)
      AVS* AVS       rw+   AVS X image
    BAYER* BAYER     rw+   Raw mosaiced samples
   BAYERA* BAYER     rw+   Raw mosaiced and alpha samples
      BGR* BGR       rw+   Raw blue, green, and red samples
     BGRA* BGR       rw+   Raw blue, green, red, and alpha samples
     BGRO* BGR       rw+   Raw blue, green, red, and opacity samples
      BIE* JBIG      rw-   Joint Bi-level Image experts Group interchange format (2.1)
      BMP* BMP       rw-   Microsoft Windows bitmap image
     BMP2* BMP       rw-   Microsoft Windows bitmap image (V2)
     BMP3* BMP       rw-   Microsoft Windows bitmap image (V3)
      BRF* BRAILLE   -w-   BRF ASCII Braille format
      CAL* CALS      rw-   Continuous Acquisition and Life-cycle Support Type 1
             Specified in MIL-R-28002 and MIL-PRF-28002
     CALS* CALS      rw-   Continuous Acquisition and Life-cycle Support Type 1
             Specified in MIL-R-28002 and MIL-PRF-28002
   CANVAS* XC        r--   Constant image uniform color
  CAPTION* CAPTION   r--   Caption
      CIN* CIN       rw-   Cineon Image File
      CIP* CIP       -w-   Cisco IP phone image format
     CLIP* CLIP      rw+   Image Clip Mask
     CMYK* CMYK      rw+   Raw cyan, magenta, yellow, and black samples
    CMYKA* CMYK      rw+   Raw cyan, magenta, yellow, black, and alpha samples
      CR2  DNG       r--   Canon Digital Camera Raw Image Format (0.20.2-Release)
      CR3  DNG       r--   Canon Digital Camera Raw Image Format (0.20.2-Release)
      CRW  DNG       r--   Canon Digital Camera Raw Image Format (0.20.2-Release)
     CUBE* CUBE      r--   Cube LUT
      CUR* ICON      rw-   Microsoft icon
      CUT* CUT       r--   DR Halo
     DATA* INLINE    rw+   Base64-encoded inline images
      DCM* DCM       r--   Digital Imaging and Communications in Medicine image
             DICOM is used by the medical community for images like X-rays.  The
             specification, "Digital Imaging and Communications in Medicine
             (DICOM)", is available at http://medical.nema.org/.  In particular,
             see part 5 which describes the image encoding (RLE, JPEG, JPEG-LS),
             and supplement 61 which adds JPEG-2000 encoding.
      DCR  DNG       r--   Kodak Digital Camera Raw Image File (0.20.2-Release)
    DCRAW  DNG       r--   Raw Photo Decoder (dcraw) (0.20.2-Release)
      DCX* PCX       rw+   ZSoft IBM PC multi-page Paintbrush
      DDS* DDS       rw+   Microsoft DirectDraw Surface
    DFONT* TTF       r--   Multi-face font package (Freetype 2.11.1)
      DNG  DNG       r--   Digital Negative (0.20.2-Release)
      DOT  DOT       ---   Graphviz
      DPX* DPX       rw-   SMPTE 268M-2003 (DPX 2.0)
             Digital Moving Picture Exchange Bitmap, Version 2.0.
             See SMPTE 268M-2003 specification at http://www.smtpe.org
             
     DXT1* DDS       rw+   Microsoft DirectDraw Surface
     DXT5* DDS       rw+   Microsoft DirectDraw Surface
     EPDF  PDF       rw-   Encapsulated Portable Document Format
      EPI  PS        rw-   Encapsulated PostScript Interchange format
      EPS  PS        rw-   Encapsulated PostScript
     EPS2  PS2       -w-   Level II Encapsulated PostScript
     EPS3  PS3       -w+   Level III Encapsulated PostScript
     EPSF  PS        rw-   Encapsulated PostScript
     EPSI  PS        rw-   Encapsulated PostScript Interchange format
      EPT  EPT       rw-   Encapsulated PostScript with TIFF preview
     EPT2  EPT       rw-   Encapsulated PostScript Level II with TIFF preview
     EPT3  EPT       rw+   Encapsulated PostScript Level III with TIFF preview
      ERF  DNG       r--   Epson RAW Format (0.20.2-Release)
      EXR  EXR       rw-   High Dynamic-range (HDR) (OpenEXR 2.5.7)
 FARBFELD* FARBFELD  rw-   Farbfeld
      FAX* FAX       rw+   Group 3 FAX
             FAX machines use non-square pixels which are 1.5 times wider than
             they are tall but computer displays use square pixels, therefore
             FAX images may appear to be narrow unless they are explicitly
             resized using a geometry of "150x100%".
             
       FF* FARBFELD  rw-   Farbfeld
     FILE* URL       r--   Uniform Resource Locator (file://)
     FITS* FITS      rw+   Flexible Image Transport System
     FL32* FL32      rw-   FilmLight
      FLV  VIDEO     rw+   Flash Video Stream
  FRACTAL* PLASMA    r--   Plasma fractal image
      FTP* URL       r--   Uniform Resource Locator (ftp://)
      FTS* FITS      rw+   Flexible Image Transport System
     FTXT* FTXT      rw-   Formatted text image
       G3* FAX       rw-   Group 3 FAX
       G4* FAX       rw-   Group 4 FAX
      GIF* GIF       rw+   CompuServe graphics interchange format
    GIF87* GIF       rw-   CompuServe graphics interchange format (version 87a)
 GRADIENT* GRADIENT  r--   Gradual linear passing from one shade to another
     GRAY* GRAY      rw+   Raw gray samples
    GRAYA* GRAY      rw+   Raw gray and alpha samples
   GROUP4* TIFF      rw-   Raw CCITT Group4
             Compression options: None, Fax/Group3, Group4, JBIG, JPEG, LERC, LZW, LZMA, RLE, ZIP, ZSTD, WEBP
       GV  DOT       ---   Graphviz
     HALD* HALD      r--   Identity Hald color lookup table image
      HDR* HDR       rw+   Radiance RGBE image format
     HEIC  HEIC      rw+   High Efficiency Image Format (1.16.2)
     HEIF  HEIC      rw+   High Efficiency Image Format (1.16.2)
HISTOGRAM* HISTOGRAM -w-   Histogram of the image
      HRZ* HRZ       rw-   Slow Scan TeleVision
      HTM* HTML      -w-   Hypertext Markup Language and a client-side image map
     HTML* HTML      -w-   Hypertext Markup Language and a client-side image map
     HTTP* URL       r--   Uniform Resource Locator (http://)
    HTTPS* URL       r--   Uniform Resource Locator (https://)
      ICB* TGA       rw-   Truevision Targa image
      ICO* ICON      rw+   Microsoft icon
     ICON* ICON      rw-   Microsoft icon
      IIQ  DNG       r--   Phase One Raw Image Format (0.20.2-Release)
     INFO  INFO      -w+   The image format and characteristics
   INLINE* INLINE    rw+   Base64-encoded inline images
      IPL* IPL       rw+   IPL Image Sequence
   ISOBRL* BRAILLE   -w-   ISO/TR 11548-1 format
  ISOBRL6* BRAILLE   -w-   ISO/TR 11548-1 format 6dot
      J2C* JP2       rw-   JPEG-2000 Code Stream Syntax (2.4.0)
      J2K* JP2       rw-   JPEG-2000 Code Stream Syntax (2.4.0)
      JBG* JBIG      rw+   Joint Bi-level Image experts Group interchange format (2.1)
     JBIG* JBIG      rw+   Joint Bi-level Image experts Group interchange format (2.1)
      JNG* PNG       rw-   JPEG Network Graphics
             See http://www.libpng.org/pub/mng/ for details about the JNG
             format.
      JNX* JNX       r--   Garmin tile format
      JP2* JP2       rw-   JPEG-2000 File Format Syntax (2.4.0)
      JPC* JP2       rw-   JPEG-2000 Code Stream Syntax (2.4.0)
      JPE* JPEG      rw-   Joint Photographic Experts Group JFIF format (libjpeg-turbo 2.1.2)
     JPEG* JPEG      rw-   Joint Photographic Experts Group JFIF format (libjpeg-turbo 2.1.2)
      JPG* JPEG      rw-   Joint Photographic Experts Group JFIF format (libjpeg-turbo 2.1.2)
      JPM* JP2       rw-   JPEG-2000 File Format Syntax (2.4.0)
      JPS* JPEG      rw-   Joint Photographic Experts Group JFIF format (libjpeg-turbo 2.1.2)
      JPT* JP2       rw-   JPEG-2000 File Format Syntax (2.4.0)
     JSON  JSON      -w+   The image format and characteristics
      K25  DNG       r--   Kodak Digital Camera Raw Image Format (0.20.2-Release)
      KDC  DNG       r--   Kodak Digital Camera Raw Image Format (0.20.2-Release)
   KERNEL* KERNEL    -w-   Morphology Kernel
    LABEL* LABEL     r--   Image label
      M2V  VIDEO     rw+   MPEG Video Stream
      M4V  VIDEO     rw+   Raw VIDEO-4 Video
      MAC* MAC       r--   MAC Paint
      MAP* MAP       rw-   Colormap intensities and indices
     MASK* MASK      rw+   Image Clip Mask
      MAT  MAT       rw+   MATLAB level 5 image format
    MATTE* MATTE     -w+   MATTE format
      MEF  DNG       r--   Mamiya Raw Image File (0.20.2-Release)
     MIFF* MIFF      rw+   Magick Image File Format
      MKV  VIDEO     rw+   Multimedia Container
      MNG* PNG       rw+   Multiple-image Network Graphics (libpng 1.6.37)
             See http://www.libpng.org/pub/mng/ for details about the MNG
             format.
     MONO* MONO      rw-   Raw bi-level bitmap
      MOV  VIDEO     rw+   MPEG Video Stream
      MP4  VIDEO     rw+   VIDEO-4 Video Stream
      MPC* MPC       rw+   Magick Pixel Cache image format
     MPEG  VIDEO     rw+   MPEG Video Stream
      MPG  VIDEO     rw+   MPEG Video Stream
      MPO* JPEG      r--   Joint Photographic Experts Group JFIF format (libjpeg-turbo 2.1.2)
      MRW  DNG       r--   Sony (Minolta) Raw Image File (0.20.2-Release)
      MSL* MSL       rw+   Magick Scripting Language
     MSVG* SVG       rw+   ImageMagick's own SVG internal renderer
      MTV* MTV       rw+   MTV Raytracing image format
      MVG* MVG       rw-   Magick Vector Graphics
      NEF  DNG       r--   Nikon Digital SLR Camera Raw Image File (0.20.2-Release)
      NRW  DNG       r--   Nikon Digital SLR Camera Raw Image File (0.20.2-Release)
     NULL* NULL      rw-   Constant image of uniform color
      ORA  ORA       ---   OpenRaster format
      ORF  DNG       r--   Olympus Digital Camera Raw Image File (0.20.2-Release)
      OTB* OTB       rw-   On-the-air bitmap
      OTF* TTF       r--   Open Type font (Freetype 2.11.1)
      PAL* UYVY      rw-   16bit/pixel interleaved YUV
     PALM* PALM      rw+   Palm pixmap
      PAM* PNM       rw+   Common 2-dimensional bitmap format
    PANGO* PANGO     ---   Pango Markup Language
  PATTERN* PATTERN   r--   Predefined pattern
      PBM* PNM       rw+   Portable bitmap format (black and white)
      PCD* PCD       rw-   Photo CD
     PCDS* PCD       rw-   Photo CD
      PCL  PCL       rw+   Printer Control Language
      PCT* PICT      rw-   Apple Macintosh QuickDraw/PICT
      PCX* PCX       rw-   ZSoft IBM PC Paintbrush
      PDB* PDB       rw+   Palm Database ImageViewer Format
      PDF  PDF       rw+   Portable Document Format
     PDFA  PDF       rw+   Portable Document Archive Format
      PEF  DNG       r--   Pentax Electronic File (0.20.2-Release)
      PES* PES       r--   Embrid Embroidery Format
      PFA* TTF       r--   Postscript Type 1 font (ASCII) (Freetype 2.11.1)
      PFB* TTF       r--   Postscript Type 1 font (binary) (Freetype 2.11.1)
      PFM* PNM       rw+   Portable float format
      PGM* PNM       rw+   Portable graymap format (gray scale)
      PGX* PGX       rw-   JPEG 2000 uncompressed format
      PHM* PNM       rw+   Portable half float format
    PICON* XPM       rw-   Personal Icon
     PICT* PICT      rw-   Apple Macintosh QuickDraw/PICT
      PIX* PIX       r--   Alias/Wavefront RLE image format
    PJPEG* JPEG      rw-   Joint Photographic Experts Group JFIF format (libjpeg-turbo 2.1.2)
   PLASMA* PLASMA    r--   Plasma fractal image
      PNG* PNG       rw-   Portable Network Graphics (libpng 1.6.37)
             See http://www.libpng.org/ for details about the PNG format.
    PNG00* PNG       rw-   PNG inheriting bit-depth, color-type from original, if possible
    PNG24* PNG       rw-   opaque or binary transparent 24-bit RGB
    PNG32* PNG       rw-   opaque or transparent 32-bit RGBA
    PNG48* PNG       rw-   opaque or binary transparent 48-bit RGB
    PNG64* PNG       rw-   opaque or transparent 64-bit RGBA
     PNG8* PNG       rw-   8-bit indexed with optional binary transparency
      PNM* PNM       rw+   Portable anymap
POCKETMOD  PDF       rw+   Pocketmod Personal Organizer
      PPM* PNM       rw+   Portable pixmap format (color)
       PS  PS        rw+   PostScript
      PS2  PS2       -w+   Level II PostScript
      PS3  PS3       -w+   Level III PostScript
      PSB* PSD       rw+   Adobe Large Document Format
      PSD* PSD       rw+   Adobe Photoshop bitmap
     PTIF* TIFF      rw+   Pyramid encoded TIFF
             Compression options: None, Fax/Group3, Group4, JBIG, JPEG, LERC, LZW, LZMA, RLE, ZIP, ZSTD, WEBP
      PWP* PWP       r--   Seattle Film Works
      QOI* QOI       rw-   Quite OK image format
RADIAL-GRADIENT* GRADIENT  r--   Gradual radial passing from one shade to another
      RAF  DNG       r--   Fuji CCD-RAW Graphic File (0.20.2-Release)
      RAS* SUN       rw+   SUN Rasterfile
      RAW  DNG       r--   Raw (0.20.2-Release)
      RGB* RGB       rw+   Raw red, green, and blue samples
   RGB565* RGB       r--   Raw red, green, blue samples in 565 format
     RGBA* RGB       rw+   Raw red, green, blue, and alpha samples
     RGBO* RGB       rw+   Raw red, green, blue, and opacity samples
      RGF* RGF       rw-   LEGO Mindstorms EV3 Robot Graphic Format (black and white)
      RLA* RLA       r--   Alias/Wavefront image
      RLE* RLE       r--   Utah Run length encoded image
      RMF  DNG       r--   Raw Media Format (0.20.2-Release)
      RW2  DNG       r--   Panasonic Lumix Raw Image (0.20.2-Release)
      SCR* SCR       r--   ZX-Spectrum SCREEN$
      SCT* SCT       r--   Scitex HandShake
      SFW* SFW       r--   Seattle Film Works
      SGI* SGI       rw+   Irix RGB image
    SHTML* HTML      -w-   Hypertext Markup Language and a client-side image map
      SIX* SIXEL     rw-   DEC SIXEL Graphics Format
    SIXEL* SIXEL     rw-   DEC SIXEL Graphics Format
SPARSE-COLOR* TXT       -w+   Sparse Color
      SR2  DNG       r--   Sony Raw Format 2 (0.20.2-Release)
      SRF  DNG       r--   Sony Raw Format (0.20.2-Release)
  STEGANO* STEGANO   r--   Steganographic image
   STRIMG* STRIMG    rw-   String to image and back
      SUN* SUN       rw+   SUN Rasterfile
      SVG* SVG       rw+   Scalable Vector Graphics (XML 2.9.13)
     SVGZ* SVG       rw+   Compressed Scalable Vector Graphics (XML 2.9.13)
     TEXT* TXT       r--   Text
      TGA* TGA       rw-   Truevision Targa image
THUMBNAIL* THUMBNAIL -w+   EXIF Profile Thumbnail
     TIFF* TIFF      rw+   Tagged Image File Format (LIBTIFF, Version 4.3.0)
             Compression options: None, Fax/Group3, Group4, JBIG, JPEG, LERC, LZW, LZMA, RLE, ZIP, ZSTD, WEBP
   TIFF64* TIFF      rw+   Tagged Image File Format (64-bit) (LIBTIFF, Version 4.3.0)
             Compression options: None, Fax/Group3, Group4, JBIG, JPEG, LERC, LZW, LZMA, RLE, ZIP, ZSTD, WEBP
     TILE* TILE      r--   Tile image with a texture
      TIM* TIM       r--   PSX TIM
      TM2* TIM2      r--   PS2 TIM2
      TTC* TTF       r--   TrueType font collection (Freetype 2.11.1)
      TTF* TTF       r--   TrueType font (Freetype 2.11.1)
      TXT* TXT       rw+   Text
     UBRL* BRAILLE   -w-   Unicode Text format
    UBRL6* BRAILLE   -w-   Unicode Text format 6dot
      UIL* UIL       -w-   X-Motif UIL table
     UYVY* UYVY      rw-   16bit/pixel interleaved YUV
      VDA* TGA       rw-   Truevision Targa image
    VICAR* VICAR     rw-   Video Image Communication And Retrieval
      VID* VID       rw+   Visual Image Directory
     VIFF* VIFF      rw+   Khoros Visualization image
     VIPS* VIPS      rw+   VIPS image
      VST* TGA       rw-   Truevision Targa image
     WBMP* WBMP      rw-   Wireless Bitmap (level 0) image
     WEBM  VIDEO     rw+   Open Web Media
     WEBP* WEBP      rw+   WebP Image Format (libwebp 1.2.2 [020F])
      WMV  VIDEO     rw+   Windows Media Video
      WPG* WPG       rw-   Word Perfect Graphics
        X* X         rw+   X Image
      X3F  DNG       r--   Sigma Camera RAW Picture File (0.20.2-Release)
      XBM* XBM       rw-   X Windows system bitmap (black and white)
       XC* XC        r--   Constant image uniform color
      XCF* XCF       r--   GIMP image
      XPM* XPM       rw-   X Windows system pixmap (color)
      XPS  XPS       r--   Microsoft XML Paper Specification
       XV* VIFF      rw+   Khoros Visualization image
      XWD* XWD       rw-   X Windows system window dump (color)
     YAML  YAML      -w+   The image format and characteristics
    YCbCr* YCbCr     rw+   Raw Y, Cb, and Cr samples
   YCbCrA* YCbCr     rw+   Raw Y, Cb, Cr, and alpha samples
      YUV* YUV       rw-   CCIR 601 4:1:1 or 4:2:2

* native blob support
r read support
w write support
+ support for multiple images
```
