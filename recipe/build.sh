#!/bin/bash
set -u

mkdir -p build

export PKG_CONFIG_PATH=$PKG_CONFIG_PATH:$BUILD_PREFIX/lib/pkgconfig

export ADDITIONAL_MESON_ARGS=(
  --buildtype=release
  --prefix="${PREFIX}"
  --default-library=shared
  --wrap-mode=nofallback
  -Dlibdir=lib
  -Dfreetype=enabled
  -Dfontconfig=enabled
  -Dglib=enabled
  -Dgtk_doc=false
  # meson.build:602:7: ERROR: Program 'gs' not found or not executable - program needed during testing (not in main chanel)
  # -Dtests=enabled
)

if [[ ${target_platform} == osx-* ]]; then
  ADDITIONAL_MESON_ARGS+=(-Dxlib=disabled)
else
  ADDITIONAL_MESON_ARGS+=(-Dxlib=enabled)
  ADDITIONAL_MESON_ARGS+=(-Dxcb=enabled)
  : ${CONDA_BUILD_SYSROOT:=`"$CC" -print-sysroot`}
  export PKG_CONFIG_PATH="${CONDA_BUILD_SYSROOT}/usr/lib64/pkgconfig"
  if [[ ${target_platform} == linux-ppc64le ]]; then
    export CFLAGS="${CFLAGS} -Wno-enum-conversion"
  fi
fi

if [ $(uname -m) == x86_64 ] || [ $(uname -m) == aarch64 ]; then
  export ax_cv_c_float_words_bigendian="no"
fi

meson setup build ${ADDITIONAL_MESON_ARGS[@]}
meson compile -vC build -j ${CPU_COUNT}
# meson test
meson install -C build
