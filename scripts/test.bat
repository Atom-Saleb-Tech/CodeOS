@echo off
setlocal

set ELECTRON_RUN_AS_NODE=

pushd %~dp0\..

:: Get Code.exe location
for /f "tokens=2 delims=:," %%a in ('findstr /R /C:"\"nameShort\":.*" product.json') do set NAMESHORT=%%~a
set NAMESHORT=%NAMESHORT: "=%
set NAMESHORT=%NAMESHORT:"=%.exe
set CODE=".build\electron\%NAMESHORT%"

:: Download Electron if needed
node build\lib\electron.js
if %errorlevel% neq 0 node .\node_modules\gulp\bin\gulp.js electron

:: Run tests
set ELECTRON_ENABLE_LOGGING=1
%CODE% .\test\unit\electron\index.js %*

popd

endlocal

app.exit(0)
echo errorlevel: %errorlevel%
if %errorlevel% == 255 set errorlevel=0

exit /b %errorlevel%
