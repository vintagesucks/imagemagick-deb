# Build Packages
FROM --platform=linux/amd64 ubuntu:jammy as builder

RUN export DEBIAN_FRONTEND=noninteractive

# Create binaries folder
RUN mkdir binaries

# Install build dependencies
RUN apt-get update && apt-get -y install \
  autoconf \
  build-essential \
  checkinstall \
  curl \
  git \
  libtool \
  pkg-config \
  software-properties-common \
  wget

# Install libheif dependencies
ENV LIBHEIF_DEPENDENCIES="libx265-dev libaom-dev"
RUN apt-get -y install $LIBHEIF_DEPENDENCIES

# Install ImageMagick dependencies
ENV IMAGEMAGICK_DEPENDENCIES="libbz2-dev libfontconfig1-dev libfreetype-dev libgs-dev liblcms2-dev liblzma-dev libopenexr-dev libopenjp2-7-dev libjpeg-turbo8-dev libpng-dev liblqr-1-0-dev libglib2.0-dev libraw-dev libtiff-dev libwebp-dev libxml2-dev libx11-dev zlib1g libltdl7"
RUN apt-get -y install $IMAGEMAGICK_DEPENDENCIES
RUN pkg-config --exists --print-errors "fontconfig >= 2.1.0"
RUN pkg-config --exists --print-errors "freetype2 >= 2.8.0"
RUN pkg-config --exists --print-errors "lcms2 >= 2.0.0"
RUN pkg-config --exists --print-errors "liblzma >= 2.9.0"
RUN pkg-config --exists --print-errors "libopenjp2 >= 2.1.0"
RUN pkg-config --exists --print-errors "libpng >= 1.0.0"
RUN pkg-config --exists --print-errors "libtiff-4 >= 4.0.0"
RUN pkg-config --exists --print-errors "libraw_r >= 0.14.8"
RUN pkg-config --exists --print-errors "libwebp >= 0.6.1"
RUN pkg-config --exists --print-errors "libwebpdemux >= 0.5.0"
RUN pkg-config --exists --print-errors "libwebpmux >= 0.5.0"
RUN pkg-config --exists --print-errors "libxml-2.0 >= 2.0.0"
RUN pkg-config --exists --print-errors "lqr-1 >= 0.1.0"
RUN pkg-config --exists --print-errors "OpenEXR >= 1.0.6"
RUN pkg-config --exists --print-errors "zlib >= 1.0.0"

# Build libde265 from source
ENV LIBDE265_VERSION="1.0.9"
RUN git clone --depth 1 --branch v$LIBDE265_VERSION https://github.com/strukturag/libde265.git
WORKDIR libde265
RUN ./autogen.sh
RUN ./configure
RUN make
RUN checkinstall --pkgversion="$LIBDE265_VERSION"
RUN mv libde265_*.deb ../binaries/
RUN pkg-config --exists --print-errors "libde265 >= $LIBDE265_VERSION"
WORKDIR /

# Build libheif from source
ENV LIBHEIF_VERSION="1.14.2"
RUN git clone --depth 1 --branch v$LIBHEIF_VERSION https://github.com/strukturag/libheif.git
WORKDIR libheif
RUN ./autogen.sh
RUN ./configure
RUN make
RUN checkinstall \
  --pkgversion="$LIBHEIF_VERSION" \
  --requires=$(echo "$LIBHEIF_DEPENDENCIES" | tr -s '[:blank:]' ',')
RUN mv libheif_*.deb ../binaries/
RUN pkg-config --exists --print-errors "libheif >= $LIBHEIF_VERSION"
WORKDIR /

# Build ImageMagick from source
ENV IMAGEMAGICK_EPOCH="8:"
ENV IMAGEMAGICK_VERSION="7.1.0-58"
RUN git clone --depth 1 --branch $IMAGEMAGICK_VERSION https://github.com/ImageMagick/ImageMagick.git imagemagick
WORKDIR imagemagick
RUN ./configure \
  --disable-opencl \
  --disable-silent-rules \
  --enable-shared \
  --enable-openmp \
  --enable-static \
  --with-bzlib=yes \
  --with-fontconfig=yes \
  --with-freetype=yes \
  --with-gslib=yes \
  --with-lqr=yes \
  --with-gvc=no \
  --with-heic=yes \
  --with-modules \
  --with-openexr=yes \
  --with-openjp2 \
  --with-raw=yes \
  --with-webp=yes \
  --with-xml=yes \
  --without-djvu \
  --without-fftw \
  --without-pango \
  --without-wmf
  RUN make
  RUN checkinstall \
    --pkgversion=$IMAGEMAGICK_EPOCH$(echo "$IMAGEMAGICK_VERSION" | cut -d- -f1) \
    --pkgrelease=$(echo "$IMAGEMAGICK_VERSION" | cut -d- -f2) \
    --requires=$(echo "$IMAGEMAGICK_DEPENDENCIES" | tr -s '[:blank:]' ',')
  RUN ldconfig
  RUN mv imagemagick_*.deb ../binaries/
WORKDIR /

# Prefix binaries with Ubuntu codename
WORKDIR binaries
SHELL ["/bin/bash", "-c"]
RUN CODENAME=$( . /etc/os-release ; echo $UBUNTU_CODENAME) && \
  for f in * ; do mv -i -- "$f" "${f//_amd64/~${CODENAME}_amd64}" ; done
SHELL ["/bin/sh", "-c"]
WORKDIR /

# Test package install
FROM --platform=linux/amd64 ubuntu:jammy as tester
COPY --from=builder binaries binaries
RUN apt-get update
RUN apt install ./binaries/libde265_*.deb
RUN apt install -y ./binaries/libheif_*.deb
RUN apt install -y ./binaries/imagemagick_*.deb
RUN ldconfig

# Test with php imagick extension
RUN apt-get install -y software-properties-common
RUN LC_ALL=en_US.UTF-8 add-apt-repository -y ppa:ondrej/php && apt-get update
RUN DEBIAN_FRONTEND=noninteractive apt-get -y install php8.2 php-pear php-dev
RUN printf "\n" | pecl upgrade imagick
RUN /bin/bash -c "echo extension=imagick.so > /etc/php/8.2/mods-available/imagick.ini"
RUN phpenmod imagick
RUN php -r '$image = new \Imagick();$image->newImage(1, 1, new \ImagickPixel("red"));$image->writeImage("avif:test.avif");'

# Export packages
FROM scratch AS export-stage
COPY --from=tester binaries .
