FROM debian:bullseye-slim

MAINTAINER Matt McCormick "matt.mccormick@kitware.com"

ARG DEBIAN_FRONTEND=noninteractive

RUN \
  apt-get update --yes && \
  apt-get install --no-install-recommends --yes \
    autogen \
    automake \
    bash \
    bc \
    bison \
    build-essential \
    bzip2 \
    ca-certificates \
    curl \
    dirmngr \
    file \
    flex \
    gettext \
    gzip \
    gnupg \
    initramfs-tools \
    libncurses5 \
    libtool \
    make \
    libudev-dev \
    ncurses-dev \
    pkg-config \
    pax \
    python3 \
    python3-pip \
    rsync \
    sed \
    ssh \
    tar \
    vim \
    wget \
    xz-utils \
    zip \
    zlib1g-dev \
    python-is-python3 \
    && apt-get clean autoclean --yes \
    && apt-get autoremove --yes \
    && rm -rf /var/lib/{apt,dpkg,cache,log}/

WORKDIR /usr/src

# Image build scripts
COPY \
  imagefiles/install-gosu-binary.sh \
  imagefiles/install-gosu-binary-wrapper.sh \
  /buildscripts/

RUN \
  set -x && \
  /buildscripts/install-gosu-binary.sh && \
  /buildscripts/install-gosu-binary-wrapper.sh && \
  rm -rf /buildscripts

# Runtime scripts
COPY imagefiles/entrypoint.sh imagefiles/dockcross.sh /dockcross/

WORKDIR /usr/src

ARG GIT_VERSION=2.32.0
ARG CMAKE_VERSION=3.21.1

# Image build scripts
COPY \
  imagefiles/build-and-install-cmake.sh \
  imagefiles/build-and-install-curl.sh \
  imagefiles/build-and-install-git.sh \
  imagefiles/build-and-install-ninja.sh \
  imagefiles/build-and-install-openssl.sh \
  imagefiles/build-and-install-openssh.sh \
  imagefiles/install-cmake-binary.sh \
  imagefiles/install-liquidprompt-binary.sh \
  imagefiles/install-python-packages.sh \
  imagefiles/utils.sh \
  /buildscripts/

RUN \
  X86_FLAG=$([ "$DEFAULT_DOCKCROSS_IMAGE" = "dockcross/manylinux2014-x86" ] && echo "-32" || echo "") && \
  /buildscripts/build-and-install-openssl.sh $X86_FLAG && \
  /buildscripts/build-and-install-openssh.sh && \
  /buildscripts/build-and-install-curl.sh && \
  /buildscripts/build-and-install-git.sh && \
  if [ "$CMAKE_BIN" = "true" ]; then CMAKE_VERSION=3.17.1 && /buildscripts/install-cmake-binary.sh $X86_FLAG;else /buildscripts/build-and-install-cmake.sh  $X86_FLAG;fi && \
  /buildscripts/install-liquidprompt-binary.sh && \
  PYTHON=$([ -e /opt/python/cp38-cp38/bin/python ] && echo "/opt/python/cp38-cp38/bin/python" || echo "python3") && \
  /buildscripts/install-python-packages.sh -python ${PYTHON} && \
  /buildscripts/build-and-install-ninja.sh -python ${PYTHON} && \
  rm -rf /buildscripts

RUN echo "root:root" | chpasswd
WORKDIR /work
ENTRYPOINT ["/dockcross/entrypoint.sh"]

# Runtime scripts
COPY imagefiles/cmake.sh /usr/local/bin/cmake
COPY imagefiles/ccmake.sh /usr/local/bin/ccmake

# Build-time metadata as defined at http://label-schema.org
# Note: To avoid systematic rebuild of dependent images, only
#       name and vcs-url are included.
ARG IMAGE
ARG VCS_URL
LABEL org.label-schema.name=$IMAGE \
      org.label-schema.vcs-url=$VCS_URL \
      org.label-schema.schema-version="1.0"

ENV CT_VERSION 5f5a22f7a7307790ec571d0c5acf8790416964e6

# crosstool.common
#
# Common Docker instructions to install "crosstool-ng" and build a full
# cross-compiler suite from a crosstool-ng configuration, CROSSTOOL_CONFIG.
#
# This import complements the "dockcross/base" image, adding:
# - "ct-ng", a cross-compiler building utilty.
# - A cross-compiler suite configured in "crosstool-ng.config".
#
# The generated cross-compiler will have a CROSS_ROOT of:
#   ${XCC_PREFIX}/${CROSS_TRIPLE}
#
# A given platform will need to supply the appropriate "crosstool-ng.config" to
# generate its cross-compiler. This can be built using "ct-ng menuconfig" to
# generate a configuration.

# Install Debian packages required for `ct-ng`.
RUN apt-get update --yes && apt-get install --no-install-recommends --yes \
    gawk \
    gperf \
    help2man \
    python3-dev \
    texinfo \
# Packages needed for crosstool-ng 1.24 or higher 
    unzip \
    libtool \
    libtool-bin \
    && apt-get clean autoclean --yes \
    && apt-get autoremove --yes \
    && rm -rf /var/lib/{apt,dpkg,cache,log}/

ENV XCC_PREFIX=/usr/xcc

# Add the crosstool-ng script and image-specific toolchain configuration into
# /dockcross/.
#
# Afterwards, we will leave the "ct-ng" config in the image as a reference
# for users.
COPY \
  imagefiles/install-crosstool-ng-toolchain.sh \
  imagefiles/patch/crosstool-ng/crosstool-ng-expat.patch \
  imagefiles/patch/crosstool-ng/Fix-error-with-bash-5-and-up.patch \
  crosstool-ng.config \
  /dockcross/

# Build and install the toolchain, cleaning up artifacts afterwards.
RUN mkdir /dockcross/crosstool \
&& cd /dockcross/crosstool \
&& /dockcross/install-crosstool-ng-toolchain.sh \
  -p "${XCC_PREFIX}" \
  -c "/dockcross/crosstool-ng.config" \
  -v "${CT_VERSION}" \
&& rm -rf /dockcross/crosstool /dockcross/install-crosstool-ng-toolchain.sh

# Restore our default workdir (from "dockcross/base").
WORKDIR /work

# The cross-compiling emulator
RUN apt-get update \
&& apt-get install -y \
  qemu-user \
  qemu-user-static \
&& apt-get clean --yes

# The CROSS_TRIPLE is a configured alias of the "aarch64-unknown-linux-gnu" target.
ENV CROSS_TRIPLE aarch64-unknown-linux-gnu

ENV CROSS_ROOT ${XCC_PREFIX}/${CROSS_TRIPLE}
ENV AS=${CROSS_ROOT}/bin/${CROSS_TRIPLE}-as \
    AR=${CROSS_ROOT}/bin/${CROSS_TRIPLE}-ar \
    CC=${CROSS_ROOT}/bin/${CROSS_TRIPLE}-gcc \
    CPP=${CROSS_ROOT}/bin/${CROSS_TRIPLE}-cpp \
    CXX=${CROSS_ROOT}/bin/${CROSS_TRIPLE}-g++ \
    LD=${CROSS_ROOT}/bin/${CROSS_TRIPLE}-ld \
    FC=${CROSS_ROOT}/bin/${CROSS_TRIPLE}-gfortran

ENV QEMU_LD_PREFIX "${CROSS_ROOT}/${CROSS_TRIPLE}/sysroot"
ENV QEMU_SET_ENV "LD_LIBRARY_PATH=${CROSS_ROOT}/lib:${QEMU_LD_PREFIX}"

COPY Toolchain.cmake ${CROSS_ROOT}/
ENV CMAKE_TOOLCHAIN_FILE ${CROSS_ROOT}/Toolchain.cmake

ENV PKG_CONFIG_PATH /usr/lib/aarch64-linux-gnu/pkgconfig

# Linux kernel cross compilation variables
ENV PATH ${PATH}:${CROSS_ROOT}/bin
ENV CROSS_COMPILE ${CROSS_TRIPLE}-
ENV ARCH arm64

# Build-time metadata as defined at http://label-schema.org
ARG BUILD_DATE
ARG IMAGE
ARG VERSION=latest
ARG VCS_REF
ARG VCS_URL
LABEL org.label-schema.build-date=$BUILD_DATE \
      org.label-schema.name=$IMAGE \
      org.label-schema.version=$VERSION \
      org.label-schema.vcs-ref=$VCS_REF \
      org.label-schema.vcs-url=$VCS_URL \
      org.label-schema.schema-version="1.0"

ENV DEFAULT_DOCKCROSS_IMAGE ${IMAGE}:${VERSION}

RUN groupadd --gid 1000 node && useradd --uid 1000 --gid node --shell /bin/bash --create-home node && \
  groupadd --gid 2000 travis && useradd --uid 2000 --gid travis --shell /bin/bash --create-home travis && \
  apt-get -y update && \
  apt-get -y --no-install-recommends install git curl gnupg apt-transport-https && \
  echo Package: nodejs >> /etc/apt/preferences.d/preferences && \
  echo Pin: origin deb.nodesource.com >> /etc/apt/preferences.d/preferences && \
  echo Pin-Priority: 1000 >> /etc/apt/preferences.d/preferences && \
  curl -fsSL https://deb.nodesource.com/setup_lts.x | bash - && \
  apt-get -y install nodejs && \
  npm -v && \
  test -f ${CROSS_ROOT}/bin/${CROSS_TRIPLE}-strip && \
  rm -rf /var/lib/apt/lists/*

USER node

ENV PREBUILD_STRIP_BIN ${CROSS_ROOT}/bin/${CROSS_TRIPLE}-strip
ENV PREBUILD_ARCH arm64
ENV PREBUILD_ARMV 8
ENV PREBUILD_PLATFORM linux

# TODO: These are for backwards compat. Remove once we have versioning.
ENV STRIP ${PREBUILD_STRIP_BIN}
ENV ARCH ${PREBUILD_ARCH}
ENV ARM_VERSION ${PREBUILD_ARMV}
ENV TARGET_PLATFORM ${PREBUILD_PLATFORM}

# Set inherited dockcross labels to empty values.
# Labels can't be deleted (https://github.com/moby/moby/issues/3465)
LABEL org.label-schema.build-date=
LABEL org.label-schema.name=
LABEL org.label-schema.schema-version=
LABEL org.label-schema.vcs-ref=
LABEL org.label-schema.vcs-url=
LABEL org.label-schema.version=

WORKDIR /app
