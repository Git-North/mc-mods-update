@echo off
setlocal enabledelayedexpansion

echo Please select your minecraft filepath
SET "psCommand="(new-object -COM 'Shell.Application')^
.BrowseForFolder(0,'Select where Minecraft is installed',0,26).self.path""
FOR /f "usebackq delims=" %%I in (`powershell %psCommand%`) do set "folder=%%I"


mkdir !folder!\mods
set dest=!folder!\mods
pause


::IF NOT EXIST !folder! (
::  echo no folder selected or folder not found.
::  <nul set /p "=Press any key to exit..."
::  pause >nul
::  endlocal
:: ) else (



mklink /D ".\mods" "!folder!\mods"

cd !folder!\mods
xcopy *.* %date:~-10,2%.%date:~7,2%.%date:~-4,4% /i

del *.jar*

for /f "tokens=2" %%A in ('%~dp0\resources\path.cmd') do curl -L "%%A" -O


"%~dp0/resources/7za.exe" x *.zip
"%~dp0/resources/7za.exe" x *.7z
del mods.zip mods.7z

cd "%~dp0\resources\"
for /f "tokens=2" %%B in ('quiltmc-path.cmd') do echo %%B >> curlthis.tmp
powershell -command (Get-Content -Path '.\curlthis.tmp' -TotalCount 2)[-1] > latest.tmp
for /f "Tokens=* Delims=" %%x in (latest.tmp) do curl -L %%x -o "quilt-installer.exe"
del *.tmp

START "" "%~dp0\resources\quilt-installer.exe"
)
