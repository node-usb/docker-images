FROM dockcross/linux-x86

RUN cd ${CROSS_ROOT}/bin && \
  ln -s /usr/bin/x86_64-linux-gnu-strip

RUN apt-get -y update && \
  apt-get -y --no-install-recommends install libudev-dev:i386
  
RUN apt-get -y update && \
  apt-get -y --no-install-recommends install git curl gnupg apt-transport-https && \
  echo Package: nodejs >> /etc/apt/preferences.d/preferences && \
  echo Pin: origin deb.nodesource.com >> /etc/apt/preferences.d/preferences && \
  echo Pin-Priority: 1000 >> /etc/apt/preferences.d/preferences && \
  curl -fsSL https://deb.nodesource.com/setup_lts.x | bash - && \
  apt-get -y install nodejs && \
  npm -v && \
  test -f ${CROSS_ROOT}/bin/x86_64-linux-gnu-strip && \
  rm -rf /var/lib/apt/lists/*

RUN groupadd --gid 1000 node && useradd --uid 1000 --gid node --shell /bin/bash --create-home node
USER node

ENV PREBUILD_STRIP_BIN ${CROSS_ROOT}/bin/x86_64-linux-gnu-strip
ENV PREBUILD_ARCH x86
ENV PREBUILD_PLATFORM linux

# TODO: These are for backwards compat. Remove once we have versioning.
ENV STRIP ${PREBUILD_STRIP_BIN}
ENV ARCH ${PREBUILD_ARCH}
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
