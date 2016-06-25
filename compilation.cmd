echo off
echo ## Setting environment variables... ##
set PATH=D:\Qt\5.7\Static\bin;D:\Qt\Tools\mingw530_32\bin;%PATH%

echo ## Project configuration ##
qmake chocoupd.pro
lupdate chocoupd.pro

echo ## Compilation ##
mingw32-make release

echo ## Executable compression ##
upx build/chocoupd.exe

echo ## Moving executable to bin directory ##
COPY .\build\chocoupd.exe .\bin /Y

echo ## Preparing language files ##
lrelease chocoupd.pro
COPY .\translations\chocoupd*.qm .\bin\lang /Y

rmdir debug
rmdir release

timeout 5