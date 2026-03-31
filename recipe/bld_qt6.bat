mkdir build
cd build

set PATH=%LIBRARY_PREFIX%/lib/qt6/bin;%PATH%
where qtpaths

cmake -G "NMake Makefiles" ^
    -D CMAKE_INSTALL_PREFIX=%LIBRARY_PREFIX% ^
    -D CMAKE_BUILD_TYPE=Release ^
    -D BUILD_WITH_QT6=TRUE ^
    -D QT_INSTALL_PREFIX=%LIBRARY_PREFIX% ^
    ..
if errorlevel 1 exit 1

nmake
if errorlevel 1 exit 1
:: No "make check" available
nmake install
if errorlevel 1 exit 1
