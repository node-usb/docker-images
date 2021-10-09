FROM dockcross/manylinux2014-x86
ARG NODE=14.18.0

RUN yum -y install libudev-devel

RUN curl -s https://nodejs.org/dist/v$NODE/node-v$NODE.tar.gz | tar xvz -C /usr/src

RUN cd /usr/src/node-v$NODE && \
  ./configure && \
  make -j4 && \
  make install

RUN groupadd -g 1000 node && useradd -g 1000 -u 1000 -m node
USER node

ENV PREBUILD_ARCH ia32
ENV PREBUILD_PLATFORM linux

# TODO: These are for backwards compat. Remove once we have versioning.
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
