@echo off
setlocal enabledelayedexpansion
:START
FOR /f "tokens=* delims=" %%I in (.\resources\mcdir.txt) do set "folder=%%I"



set /p pathchoice=Would you like to choose your minecraft path rather than the default one? "(Default path is %appdata%\minecraft)" [Default selection is 'No' which is recommended for most people]
::

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
if not !folder! == '' GOTO rest1
if !folder! == '' GOTO thisbishempty

GOTO rest1
:rest1
mkdir !folder!\mods
set dest=!folder!\mods
set pending=%~dp0\pending_mods


mklink /D ".\mods" "!dest!"

cd !folder!\mods
xcopy *.* .disabled\%date:~-10,2%.%date:~7,2%.%date:~-4,4% /i

del *.jar*


cd !pending!
echo ######################################################################################
SET /p choice=Would you like the repo mods or do you just wanna install local mods? [Default is '1']
echo ######################################################################################

IF NOT '%choice%'=='' SET choice=%choice:~0,1%
IF /i '%choice%'=='1' GOTO curlyes
IF '%choice%'=='' GOTO curlyes
IF /i '%choice%'=='2' GOTO rest


:curlyes
for /f "tokens=2" %%A in (%~dp0\resources\path.cmd) do curl --insecure -L -I "%%A" -O

GOTO rest2
:rest2



"%~dp0/resources/7za.exe" x *.zip
"%~dp0/resources/7za.exe" x *.7z
"%~dp0/resources/7za.exe" x *.rar
del *.zip *.7z *.rar
xcopy *.* !dest!

cd "%~dp0\resources\"
for /f "tokens=2" %%B in ('quiltmc-path.cmd') do echo %%B >> curlthis.tmp
powershell -command (Get-Content -Path '.\curlthis.tmp' -TotalCount 2)[-1] > latest.tmp
for /f "Tokens=* Delims=" %%x in (latest.tmp) do curl -L %%x -o "quilt-installer.exe"
del *.tmp

START "" "%~dp0\resources\quilt-installer.exe"
)
