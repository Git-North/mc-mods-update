

chcp 65001

@echo off
setlocal enabledelayedexpansion
:START
for %%x in (.\resources\mcdir.txt) do if %%~zx==0 (
    echo "%appdata%\.minecraft" > .\resources\mcdir.txt
)
FOR /f "tokens=* delims=" %%I in (.\resources\mcdir.txt) do set "folder=%%I"



set %localappdata%\Packages\Microsoft.4297127D64EC6_8wekyb3d8bbwe\LocalCache\Local\runtime\java-runtime-beta\windows-x64\java-runtime-beta\bin\=javafolder
set !javafolder!\javaw.exe=javapath


echo #########
set /p pathchoice=Would you like to choose your minecraft path rather than the default one? "(Default path is %appdata%\minecraft)" [Default selection is 'No' which is recommended for most people]
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
set quofold="!folder!"
:rest1

echo !folder!

