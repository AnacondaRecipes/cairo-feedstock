#!/bin/bash

./configure \
    --prefix="${PREFIX}"  \
    --host=${HOST}        \
    --enable-ft           \
    --enable-ps           \
    --enable-pdf          \
    --enable-svg          \
    --enable-pthread      \
    --disable-gtk-doc     \
    $XWIN_ARGS

make -j${CPU_COUNT} ${VERBOSE_AT}
# FAIL: check-link on OS X
# Hangs for > 10 minutes on Linux
# make check
make install
