# Build Packages
FROM --platform=linux/amd64 ubuntu:jammy as builder
SHELL ["/bin/bash", "-c"]
ENV DEBIAN_FRONTEND=noninteractive

# Create binaries folder
RUN mkdir binaries

# Install build dependencies
RUN apt update && apt -y install \
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
ENV LIBHEIF_DEPENDENCIES='\
  libx265-dev,\
  libaom-dev\
'
RUN apt satisfy -y "$LIBHEIF_DEPENDENCIES"

# Install ImageMagick dependencies
ENV IMAGEMAGICK_DEPENDENCIES='\
  libbz2-dev,\
  libfontconfig1-dev (>= 2.1.0),\
  libfreetype-dev (>= 2.8.0),\
  libgs-dev,\
  liblcms2-dev (>= 2.0.0),\
  liblzma-dev (>= 2.9.0),\
  libopenexr-dev (>= 1.0.6),\
  libopenjp2-7-dev (>= 2.1.0),\
  libjpeg-turbo8-dev,\
  libpng-dev (>= 1.0.0),\
  liblqr-1-0-dev (>= 0.1.0),\
  libglib2.0-dev,\
  libraw-dev (>= 0.14.8),\
  libtiff-dev (>= 4.0.0),\
  libwebp-dev (>= 0.6.1),\
  libxml2-dev (>= 2.0.0),\
  libx11-dev,\
  zlib1g (>= 1.0.0),\
  libltdl7\
'
RUN apt satisfy -y "$IMAGEMAGICK_DEPENDENCIES"

# Build libde265 from source
ENV LIBDE265_VERSION="1.0.11"
RUN git clone --depth 1 --branch v$LIBDE265_VERSION https://github.com/strukturag/libde265.git
WORKDIR libde265
RUN ./autogen.sh
RUN ./configure
RUN make -j$(nproc)
RUN checkinstall --pkgversion="$LIBDE265_VERSION"
RUN mv libde265_*.deb ../binaries/
RUN pkg-config --exists --print-errors "libde265 = $LIBDE265_VERSION"
WORKDIR /

# Build libheif from source
ENV LIBHEIF_VERSION="1.14.2"
RUN git clone --depth 1 --branch v$LIBHEIF_VERSION https://github.com/strukturag/libheif.git
WORKDIR libheif
RUN ./autogen.sh
RUN ./configure
RUN make -j$(nproc)
RUN checkinstall \
  --pkgversion="$LIBHEIF_VERSION" \
  --requires="'$LIBHEIF_DEPENDENCIES, libde265 (>= $LIBDE265_VERSION)'"
RUN mv libheif_*.deb ../binaries/
RUN pkg-config --exists --print-errors "libheif = $LIBHEIF_VERSION"
WORKDIR /

# Set and validate ImageMagick epoch
ENV IMAGEMAGICK_EPOCH="8:"
RUN [[ $(apt-cache show imagemagick | grep Version) =~ $IMAGEMAGICK_EPOCH ]]

# Build ImageMagick from source
ENV IMAGEMAGICK_VERSION="7.1.0-61"
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
RUN make -j$(nproc)
RUN checkinstall \
  --pkgversion=$IMAGEMAGICK_EPOCH$(echo "$IMAGEMAGICK_VERSION" | cut -d- -f1) \
  --pkgrelease=$(echo "$IMAGEMAGICK_VERSION" | cut -d- -f2) \
  --requires="'$IMAGEMAGICK_DEPENDENCIES, libde265 (>= $LIBDE265_VERSION), libheif (>= $LIBHEIF_VERSION)'"
RUN ldconfig
RUN mv imagemagick_*.deb ../binaries/
RUN [[ $(dpkg-query -W -f='${Version}' imagemagick) == $IMAGEMAGICK_EPOCH$IMAGEMAGICK_VERSION ]]
WORKDIR /

# Add Ubuntu codename to the filenames
WORKDIR binaries
RUN CODENAME=$( . /etc/os-release ; echo $UBUNTU_CODENAME) && \
  for f in * ; do mv -i -- "$f" "${f//_amd64/~${CODENAME}_amd64}" ; done
WORKDIR /

# Test package install
FROM --platform=linux/amd64 ubuntu:jammy as tester
COPY --from=builder binaries binaries
SHELL ["/bin/bash", "-c"]
ENV DEBIAN_FRONTEND=noninteractive

# Preinstall ImageMagick and imagick php extension
RUN apt update && apt install -y software-properties-common
RUN LC_ALL=en_US.UTF-8 add-apt-repository -y ppa:ondrej/php
RUN apt update && apt install -y php8.2 php-pear php-dev imagemagick libmagickwand-dev
RUN curl -o imagick.tgz https://pecl.php.net/get/imagick
RUN printf "\n" | MAKEFLAGS="-j $(nproc)" pecl install ./imagick.tgz
RUN echo extension=imagick.so > /etc/php/8.2/mods-available/imagick.ini
RUN phpenmod imagick

# Installed ImageMagick version should not match built ImageMagick version
RUN [[ $(dpkg-query -W -f='${Version}' imagemagick) != $(dpkg-deb -f ./binaries/imagemagick_*.deb Version) ]]

# ImageMagick version imagick was compiled with and is using should match installed ImageMagick version
RUN [[ $(php -i | grep "Imagick compiled with ImageMagick version") =~ $(identify --version | sed "-e s/Version: ImageMagick //" -e "s/ .*//" | head -1) ]]
RUN [[ $(php -i | grep "Imagick using ImageMagick library version") =~ $(identify --version | sed "-e s/Version: ImageMagick //" -e "s/ .*//" | head -1) ]]

# Install built versions
RUN apt install ./binaries/libde265_*.deb
RUN apt install -y ./binaries/libheif_*.deb
RUN apt install -y ./binaries/imagemagick_*.deb
RUN ldconfig

# Installed ImageMagick version should match built ImageMagick version
RUN [[ $(dpkg-query -W -f='${Version}' imagemagick) == $(dpkg-deb -f ./binaries/imagemagick_*.deb Version) ]]

# Upgrade imagick php extension
RUN printf "\n" | MAKEFLAGS="-j $(nproc)" pecl upgrade --force ./imagick.tgz

# ImageMagick version imagick was compiled with and is using should match built ImageMagick version
RUN [[ $(php -i | grep "Imagick compiled with ImageMagick version") =~ $(dpkg-deb -f ./binaries/imagemagick_*.deb Version | cut -d: -f2) ]]
RUN [[ $(php -i | grep "Imagick using ImageMagick library version") =~ $(dpkg-deb -f ./binaries/imagemagick_*.deb Version | cut -d: -f2) ]]

# Test imagick php extension by creating an avif image
RUN php -r '$image = new \Imagick();$image->newImage(1, 1, new \ImagickPixel("red"));$image->writeImage("avif:test.avif");'

# Export packages
FROM scratch AS export-stage
COPY --from=tester binaries .
