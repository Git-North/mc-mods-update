chcp 65001

rmdir %temp%\mc-mods-installer
mkdir %temp%\mc-mods-installer\
cd %temp%\mc-mods-installer\

curl https://raw.githubusercontent.com/Git-North/mc-mods-update/oneliner/paths-for-curl/git-path.cmd -O -L
curl https://raw.githubusercontent.com/Git-North/mc-mods-update/oneliner/paths-for-curl/quiltmc-path.cmd -O -L
echo "%appdata%\.minecraft"> .\mcdir.txt
curl -s https://www.7-zip.org/a/7zr.exe -o 7zr.exe
 
@echo off
setlocal enabledelayedexpansion
:START

cd %temp%\mc-mods-installer
FOR /f "tokens=* delims=" %%I in (.\mcdir.txt) do set "folder=%%I"



set %localappdata%\Packages\Microsoft.4297127D64EC6_8wekyb3d8bbwe\LocalCache\Local\runtime\java-runtime-beta\windows-x64\java-runtime-beta\bin\=javafolder
set !javafolder!\javaw.exe=javapath


echo # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # 
set /p pathchoice=Would you like to choose your minecraft path rather than the default one? "(Default path is %appdata%\.minecraft)" [Default selection is 'No' which is recommended for most people]
echo # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # 

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
echo "!folder!" > \mcdir.txt
if not !folder! == '%appdata%' GOTO rest1
if !folder! == '%appdata%' GOTO pathcustom

GOTO rest1
:rest1
mkdir !folder!\mods
set dest=!folder!\mods


SET subkey1=%random%

SET subkey1=%subkey1:0=a%
SET subkey1=%subkey1:1=b%
SET subkey1=%subkey1:2=c%

rem folder date

cd !folder!\mods
xcopy *.* ".\.disabled\%date:~-10,2%.%date:~7,2%.%date:~-4,4%;%subkey1%" /i

del *.jar


:curlyes
for /f "tokens=2" %%A in ('%temp%\mc-mods-installer\git-path.cmd') do curl -L -k "%%A" -O
del latest


GOTO rest2
:rest2



"%temp%\mc-mods-installer\7zr.exe" x *.7z
for %%f in (*.zip) do tar -xf "%%f"


del *.zip *.7z *.rar
xcopy *.* !dest!

mkdir %temp%\mc-mods-installer\
cd "%temp%\mc-mods-installer\"
for /f "tokens=2" %%B in ('quiltmc-path.cmd') do echo %%B >> curlthis.tmp
powershell -command (Get-Content -Path '.\curlthis.tmp' -TotalCount 2)[-1] > latest.tmp
for /f "Tokens=* Delims=" %%Q in (latest.tmp) do curl -L %%Q -o "quilt-installer.exe"
del *.tmp

START "" "%temp%\mc-mods-installer\quilt-installer.exe"
)