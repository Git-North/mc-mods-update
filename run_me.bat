
chcp 65001

curl -s https://www.7-zip.org/a/7zr.exe -o resources/7zr.exe

@echo off
setlocal enabledelayedexpansion
:START
set "pdatammu=%programdata%\mc-mods-update"
set "pdataresource=!pdatammu!\resources"
rem Create a new mcdir.txt file in the resources directory
mkdir !pdataresource!
powershell -command New-Item -Path !pdataresource! -Name "mcdir.txt"

:choice 
rem Ask the user if they want to choose a custom Minecraft filepath or use the default one
echo # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # 
set /p pathchoice=Would you like to choose your minecraft path rather than the default one? "(Default path is %appdata%\.minecraft)" [Default selection is 'No' which is recommended for most people]
echo # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # 


rem Check the user's response and set the 'folder' variable accordingly
IF '%pathchoice%' == '' GOTO rest1
IF /i '%pathchoice%' == 'no' GOTO rest1
IF /i '%pathchoice%' == 'n' GOTO rest1
IF '%pathchoice%' == '0' GOTO rest1

IF /i '%pathchoice%' == 'yes' GOTO pathcustom
IF /i '%pathchoice%' == 'ye' GOTO pathcustom
IF /i '%pathchoice%' == 'y' GOTO pathcustom
IF '%pathchoice%' == '1' GOTO pathcustom
IF '%pathchoice%' == '2' GOTO pathcustom



:pathcustom

for %%x in (!pdataresource!\mcdir.txt) do if %%~zx==0 (
    goto continue
)


:alreadyedited
set /p alreadyedited=It seems that you already have already changed your Minecraft filepath. Would you like to change it again? or would you like to continue with the current filepath? [1 or 2]


IF '%alreadyedited%' == '1' GOTO change

IF '%alreadyedited%' == '2' GOTO continue
:change
rem Ask the user to select their Minecraft filepath
echo Please select your minecraft filepath
SET "psCommand="(new-object -COM 'Shell.Application')^
.BrowseForFolder(0,'Select where Minecraft is installed',0,26).self.path""
FOR /f "usebackq delims=" %%I in (`powershell %psCommand%`) do set "folder=%%I"
GOTO continue

:continue

IF NOT EXIST !folder! (
  echo no folder selected or folder not found.
  goto choice
) else ( goto rest2 )

:rest1


rem Check if the file size is 0, if it is, then set the contents to '%appdata%\.minecraft'
for %%x in (!pdataresource!\mcdir.txt) do if %%~zx==0 (
    echo "%appdata%\.minecraft"> !pdataresource!\mcdir.txt
)
rem Read the contents of the mcdir.txt file into the 'folder' variable
FOR /f "tokens=* delims=" %%I in (!pdataresource!\mcdir.txt) do set "folder=%%I"

:rest2
rem Create a 'mods' folder in the 'folder' directory
mkdir !folder!\mods
rem Set the 'dest' variable to the 'mods' folder path
set dest=!folder!\mods
mkdir !dest!\quiltmc
rem Create a 'quiltmc' folder in the 'mods' folder

rem Delete the 'mods' folder in the current directory
rmdir %~dp0\mods
echo !dest!
rem Create a symbolic link to the 'dest' folder for the 'mods' folder in the current directory
mklink /D "%~dp0\mods" "!dest!"

rem Set the 'subkey1' variable to a random number
SET subkey1=%random%

rem Replace all 0s in 'subkey1' with 'a', all 1s with 'b', and all 2s with 'c'
SET subkey1=%subkey1:0=a%
SET subkey1=%subkey1:1=b%
SET subkey1=%subkey1:2=c%

rem Copy all files in the 'mods' folder to a new folder with the name 'mm.dd.yyyy;subkey1' in the 'disabled' folder
cd !folder!\mods
xcopy *.* ".\.disabled\%date:~-10,2%.%date:~7,2%.%date:~-4,4%;%subkey1%" /i

rem Delete all .jar files in the 'mods' folder
del *.jar
del quilt\*.jar
del quiltmc\*.jar
:curlyes
rem Download the resource at the URL specified in the 'path.cmd' file and save it in the current directory
for /f "tokens=2" %%A in ('%~dp0\resources\path.cmd') do curl -L -k "%%A" -O
rem Delete the 'latest' file
del latest

GOTO rest2
:rest2

rem Extract all .7z files in the current directory using 7zr.exe
"%~dp0/resources/7zr.exe" x *.7z
rem Extract all .zip files in the current directory using tar.exe
for %%f in (*.zip) do tar -xf "%%f"

rem Delete all .zip, .7z, and .rar files in the current directory
del *.zip *.7z *.rar
rem Copy all files in the current directory to the 'dest' folder
xcopy *.* !dest!


del *.tmp

rem Copy 'quilt-installer.exe' to the 'modloader' folder
xcopy quilt-installer.exe "%~dp0\modloader\" /Y

rem Start 'forge-installer.exe'
taskkill /IM "Minecraft*"
START "" "%~dp0\modloader\forge-installer.exe"
