#!/usr/bin/env bash

set -ex

WRAPPER=""

CMAKE_URL="https://gitlab.kitware.com/cmake/cmake.git"
CMAKE_MIRROR_URL="https://github.com/Kitware/CMake.git"

while [ $# -gt 0 ]; do
  case "$1" in
    -32)
      WRAPPER="linux32"
      ;;
    *)
      echo "Usage: Usage: ${0##*/} [-32]"
      exit 1
      ;;
  esac
  shift
done

if ! command -v git &> /dev/null; then
	echo >&2 'error: "git" not found!'
	exit 1
fi

if [[ -z "${CMAKE_VERSION}" ]]; then
  echo >&2 'error: CMAKE_VERSION env. variable must be set to a non-empty value'
  exit 1
fi

cd /usr/src

# If the first link doesn't work, it will use the mirror on github
git clone "$CMAKE_URL" CMake -b "v$CMAKE_VERSION" --depth 1 \
  || git clone "$CMAKE_MIRROR_URL" CMake -b "v$CMAKE_VERSION" --depth 1

mkdir /usr/src/CMake-build
cd /usr/src/CMake-build

${WRAPPER} /usr/src/CMake/bootstrap \
  --parallel="$(nproc)" \
  -- -DCMAKE_USE_OPENSSL=OFF
${WRAPPER} make -j"$(nproc)"


mkdir /usr/src/CMake-ssl-build
cd /usr/src/CMake-ssl-build

${WRAPPER} /usr/src/CMake-build/bin/cmake \
  -DCMAKE_BUILD_TYPE:STRING=Release \
  -DBUILD_TESTING:BOOL=OFF \
  -DCMAKE_INSTALL_PREFIX:PATH=/usr/src/cmake-$CMAKE_VERSION \
  -DCMAKE_USE_OPENSSL:BOOL=ON \
  -DOPENSSL_ROOT_DIR:PATH=/usr/local/ssl \
  ../CMake
${WRAPPER} make -j"$(nproc)" install

# Cleanup install tree
cd /usr/src/cmake-$CMAKE_VERSION
rm -rf doc man

# Install files
find . -type f -exec install -D "{}" "/usr/{}" \;

# Write test script
cat <<EOF > cmake-test-https-download.cmake

file(
  DOWNLOAD https://raw.githubusercontent.com/Kitware/CMake/master/README.rst /tmp/README.rst
  STATUS status
  )
list(GET status 0 error_code)
list(GET status 1 error_msg)
if(error_code)
  message(FATAL_ERROR "error: Failed to download ${url} - ${error_msg}")
else()
  message(STATUS "CMake: HTTPS download works")
endif()

file(REMOVE /tmp/README.rst)

EOF

# Execute test script
cmake -P cmake-test-https-download.cmake

# Remove source and build trees
rm -rf /usr/src/CMake*
