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

conda list
ls -l ${PREFIX}/lib/qt6/bin/
${PREFIX}/lib/qt6/bin/qtpaths -h
${PREFIX}/lib/qt6/bin/qtpaths --query QT_INSTALL_PREFIX
echo $?

cmake ${CMAKE_ARGS} \
    -D CMAKE_INSTALL_PREFIX=${PREFIX} \
    -D CMAKE_INSTALL_LIBDIR=${PREFIX}/lib \
    -D BUILD_WITH_QT6=TRUE \
    ${SRC_DIR}

make -j$CPU_COUNT
# No "make check" available
make install

# we are fixing the paths to dynamic library files inside library 
# because something in make install is doubling up the
# path to the library files.  Anyone who knows how to solve that
# problem is free to contact the maintainers.
# See the GMT feedstock for similar problem

if [[ "$(uname)" == "Darwin" ]];then
    install_name_tool -id ${PREFIX}/lib/libqt6keychain.${PKG_VERSION}.dylib ${PREFIX}/lib/libqt6keychain.${PKG_VERSION}.dylib
fi
