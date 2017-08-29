#!/bin/bash

# As of Mac OS 10.8, X11 is no longer included by default
# (See https://support.apple.com/en-us/HT201341 for the details).
# Due to this change, we disable building X11 support for cairo on OS X by
# default.
if [[ ${HOST} =~ .*darwin.* ]]; then
  # Raw LDFLAGS get passed via the compile and cause warnings. The linker tests break
  # when there are warnings for some weird reason, (-pie is the cuplrit).
  export LDFLAGS=${LDFLAGS_CC}
fi

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
