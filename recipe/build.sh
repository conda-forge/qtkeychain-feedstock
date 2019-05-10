#!/bin/bash

# Remove the full path from CXX etc. If we don't do this
# then the full path at build time gets put into 
# mkspecs/qmodule.pri and qmake attempts to use this.
#export AR=$(basename ${AR})
#export RANLIB=$(basename ${RANLIB})
#export STRIP=$(basename ${STRIP})
#export OBJDUMP=$(basename ${OBJDUMP})
#export CC=$(basename ${CC})
#export CXX=$(basename ${CXX})

#if [[ ${HOST} =~ .*darwin.* ]]; then
  # Some test runs 'clang -v', but I do not want to add it as a requirement just for that.
#  ln -s "${CXX}" ${HOST}-clang || true
  # For ltcg we cannot use libtool (or at least not the macOS 10.9 system one) due to lack of LLVM bitcode support.
#  ln -s "${LIBTOOL}" libtool || true
  # Just in-case our strip is better than the system one.
#  ln -s "${STRIP}" strip || true
#  chmod +x ${HOST}-clang libtool strip
  # Qt passes clang flags to LD (e.g. -stdlib=c++)
#  export LD=${CXX}
#  PATH=${PWD}:${PATH}
#fi

[[ -d build ]] || mkdir build
cd build/

# have to set CMAKE_INSTALL_LIBDIR otherwise it ends up under 'x86_64-linux-gnu'

cmake \
    -D CMAKE_INSTALL_PREFIX=${PREFIX} \
    -D CMAKE_INSTALL_LIBDIR=${PREFIX}/lib \
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
    install_name_tool -id ${PREFIX}/lib/libqt5keychain.${PKG_VERSION}.dylib ${PREFIX}/lib/libqt5keychain.${PKG_VERSION}.dylib
fi
