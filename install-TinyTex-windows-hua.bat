::set the latex root='d:/TinyTex',set the tsinghua 
where /q powershell || echo powershell not found && exit /b
md d:/TinyTex
rem switch to a temp directory, whichever works
::cd /d "%TMP%"
::cd /d "%TEMP%"
:: the path of this .bat shell
cd /d %~dp0

rem in case there is a leftover install-tl-* dir, delete it
for /d %%G in ("install-tl-*") do rd /s /q "%%~G"

rem download install-tl.zip and unzip it
powershell -Command "[Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12; Invoke-WebRequest https://mirrors.tuna.tsinghua.edu.cn/CTAN/systems/texlive/tlnet/install-tl.zip -OutFile install-tl.zip"
powershell -Command "& { Add-Type -A 'System.IO.Compression.FileSystem'; [IO.Compression.ZipFile]::ExtractToDirectory('install-tl.zip', '.'); }"
del install-tl.zip

rem download tinytex.profile and modify it (set texdir to d:/TinyTeX)
powershell -Command "[Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12; Invoke-WebRequest https://yihui.org/gh/tinytex/tools/tinytex.profile -OutFile tinytex.profile" || exit /b
powershell -Command "(gc tinytex.profile) -replace '\./', 'd:/TinyTex/' | Out-File -encoding ASCII tinytex.profile"

echo TEXMFCONFIG $TEXMFSYSCONFIG>> tinytex.profile
echo TEXMFHOME $TEXMFLOCAL>> tinytex.profile
echo TEXMFVAR $TEXMFSYSVAR>> tinytex.profile

rem download the custom package list
powershell -Command "[Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12; Invoke-WebRequest https://yihui.org/gh/tinytex/tools/pkgs-custom.txt -OutFile pkgs-custom.txt"

rem an automated installation of TeXLive (infrastructure only)
cd install-tl-*
@echo | install-tl-windows.bat -repository https://mirrors.tuna.tsinghua.edu.cn/CTAN/systems/texlive/tlnet/ -no-gui -profile=../tinytex.profile

del TinyTeX\install-tl.log ..\tinytex.profile

rem TeXLive installed to d:/TinyTeX; move it to d:/
::rd /s /q "d:/TinyTeX"
move /y TinyTeX "d:/"

rem clean up the install-tl-* directory
cd ..
for /d %%G in ("install-tl-*") do rd /s /q "%%~G"

rem install all custom packages
@echo off
setlocal enabledelayedexpansion
set "pkgs="
for /F %%a in (pkgs-custom.txt) do set "pkgs=!pkgs! %%a"
@echo on

del pkgs-custom.txt

::call "d:\TinyTeX\bin\win32\tlmgr" path add
:: add packsge ctex for Chinese,by hua
call "d:\TinyTeX\bin\win32\tlmgr" install latex-bin xetex ctex %pkgs%
:: if something mised,eg, ctex, in d:\TinyTeX\bin\win32\tlmgr, ./tlmgr install ctex 
pause
