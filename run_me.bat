@echo off
setlocal enabledelayedexpansion

echo Please select your minecraft filepath
FOR /f "tokens=* delims=" %%I in (`resources\mcdir.txt`) do set "folder=%%I"



mkdir !folder!\mods
set dest=!folder!\mods



mklink /D ".\mods" "!dest!"

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
