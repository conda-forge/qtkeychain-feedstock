#!/bin/bash

set -x

[[ -d build ]] || mkdir build
cd build/

# have to set CMAKE_INSTALL_LIBDIR otherwise it ends up under 'x86_64-linux-gnu'

# For cross-compilation from x86_64 to arm64
#if [[ "${CONDA_BUILD_CROSS_COMPILATION:-}" == "1" ]]; then
#    # Use the build platform's qtpaths
#    QT_HOST_PATH="$BUILD_PREFIX"
#else
#    QT_HOST_PATH="$PREFIX"
#fi

export PATH=${PREFIX}/lib/qt6/bin:${PATH}
which qtpaths

cmake ${CMAKE_ARGS} \
    -D CMAKE_INSTALL_PREFIX=${PREFIX} \
    -D CMAKE_INSTALL_LIBDIR=${PREFIX}/lib \
    -D BUILD_WITH_QT6=TRUE \
    ${SRC_DIR}

make -j$CPU_COUNT
# No "make check" available
make install

