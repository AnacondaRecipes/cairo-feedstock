@echo on
setlocal enableextensions enabledelayedexpansion

:: Trailing semicolon in this variable as set by current (2017/01)
:: conda-build breaks us. Manual fix:
set "MSYS2_ARG_CONV_EXCL=/AI;/AL;/OUT;/out"

:: Compiling.
make -f Makefile.win32 CFG=release ^
  PIXMAN_CFLAGS=-I%CYGWIN_PREFIX%/Library/include/pixman ^
  PIXMAN_LIBS=%CYGWIN_PREFIX%/Library/lib/pixman-1.lib ^
  ZLIB_CFLAGS=-I%CYGWIN_PREFIX%/Library/include/ ^
  LIBPNG_CFLAGS=-I%CYGWIN_PREFIX%/Library/include/ ^
  CAIRO_LIBS='gdi32.lib msimg32.lib user32.lib %CYGWIN_PREFIX%/Library/lib/libpng.lib %CYGWIN_PREFIX%/Library/lib/zlib.lib'
if errorlevel 1 exit 1

:: Installing.
set CAIRO_INC=%LIBRARY_INC%\cairo
mkdir %CAIRO_INC%
move cairo-version.h %CAIRO_INC%
move src\cairo-features.h %CAIRO_INC%
move src\cairo.h %CAIRO_INC%
move src\cairo-deprecated.h %CAIRO_INC%
move src\cairo-win32.h %CAIRO_INC%
move src\cairo-script.h %CAIRO_INC%
move src\cairo-ps.h %CAIRO_INC%
move src\cairo-pdf.h %CAIRO_INC%
move src\cairo-svg.h %CAIRO_INC%

move src\release\cairo.dll %LIBRARY_BIN%
move src\release\cairo.lib %LIBRARY_LIB%
move src\release\cairo-static.lib %LIBRARY_LIB%
