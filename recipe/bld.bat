@echo off

set "PKG_CONFIG_PATH=%LIBRARY_LIB%\pkgconfig;%LIBRARY_PREFIX%\share\pkgconfig"

mkdir build
meson setup build ^
  --buildtype=release ^
  --default-library=shared ^
  --prefix=%LIBRARY_PREFIX% ^
  --wrap-mode=nofallback ^
  --backend=ninja ^
  --libdir=lib ^
  -Dfontconfig=enabled ^
  -Dfreetype=enabled ^
  -Dglib=enabled
if errorlevel 1 exit 1

meson compile -v -C build -j %CPU_COUNT%
if errorlevel 1 exit 1

meson install -C build
if errorlevel 1 exit 1
