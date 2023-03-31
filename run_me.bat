
chcp 65001

curl -s https://www.7-zip.org/a/7zr.exe -o resources/7zr.exe


@echo off
setlocal enabledelayedexpansion
:START
powershell -command New-Item -Path .\resources -Name "mcdir.txt"
for %%x in (.\resources\mcdir.txt) do if %%~zx==0 (
    echo "%appdata%\.minecraft"> .\resources\mcdir.txt
)
FOR /f "tokens=* delims=" %%I in (.\resources\mcdir.txt) do set "folder=%%I"



set %localappdata%\Packages\Microsoft.4297127D64EC6_8wekyb3d8bbwe\LocalCache\Local\runtime\java-runtime-beta\windows-x64\java-runtime-beta\bin\=javafolder
set !javafolder!\javaw.exe=javapath


echo #########
set /p pathchoice=Would you like to choose your minecraft path rather than the default one? "(Default path is %appdata%\.minecraft)" [Default selection is 'No' which is recommended for most people]
echo #########

IF '%pathchoice%' == '' GOTO rest1
IF /i '%pathchoice%' == 'no' GOTO rest1
IF /i '%pathchoice%' == 'n' GOTO rest1
IF '%pathchoice%' == '0' GOTO rest1

IF /i '%pathchoice%' == 'yes' GOTO pathcustom
IF /i '%pathchoice%' == 'ye' GOTO pathcustom
IF /i '%pathchoice%' == 'y' GOTO pathcustom
IF '%pathchoice%' == '1' GOTO pathcustom


:pathcustom
echo Please select your minecraft filepath
SET "psCommand="(new-object -COM 'Shell.Application')^
.BrowseForFolder(0,'Select where Minecraft is installed',0,26).self.path""
FOR /f "usebackq delims=" %%I in (`powershell %psCommand%`) do set "folder=%%I"

:thisbishempty
echo "!folder!" > resources\mcdir.txt
if not !folder! == '%appdata%' GOTO rest1
if !folder! == '%appdata%' GOTO pathcustom

GOTO rest1
:rest1
mkdir !folder!\mods
set dest=!folder!\mods
set pending=%~dp0\pending_mods

rmdir %~dp0\mods
echo !dest!
mklink /D "%~dp0\mods" "!dest!"

rem random string
SET subkey1=%random%

SET subkey1=%subkey1:0=a%
SET subkey1=%subkey1:1=b%
SET subkey1=%subkey1:2=c%

rem folder date

cd !folder!\mods
xcopy *.* ".\.disabled\%date:~-10,2%.%date:~7,2%.%date:~-4,4%;%subkey1%" /i

del *.jar


:curlyes
for /f "tokens=2" %%A in ('%~dp0\resources\path.cmd') do curl -L -k "%%A" -O
del latest


GOTO rest2
:rest2



"%~dp0/resources/7zr.exe" x *.7z
for %%f in (*.zip) do tar -xf "%%f"


del *.zip *.7z *.rar
xcopy *.* !dest!

mkdir %~dp0\modloader
cd "%~dp0\modloader"
for /f "tokens=2" %%B in ('quiltmc-path.cmd') do echo %%B >> curlthis.tmp
powershell -command (Get-Content -Path '.\curlthis.tmp' -TotalCount 2)[-1] > latest.tmp
for /f "Tokens=* Delims=" %%Q in (latest.tmp) do curl -L %%Q -o "quilt-installer.exe"
del *.tmp

START "" "%~dp0\modloader\quilt-installer.exe"
)
