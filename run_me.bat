@echo off
setlocal enabledelayedexpansion
:START
FOR /f "tokens=* delims=" %%I in (`resources\mcdir.txt`) do set "folder=%%I"



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
for /f "tokens=2" %%A in ('%~dp0\resources\path.cmd') do curl -L "%%A" -O

GOTO rest
:rest
xcopy *.* !dest!


"%~dp0/resources/7za.exe" x *.zip
"%~dp0/resources/7za.exe" x *.7z
"%~dp0/resources/7za.exe" x *.rar
del mods.zip mods.7z

cd "%~dp0\resources\"
for /f "tokens=2" %%B in ('quiltmc-path.cmd') do echo %%B >> curlthis.tmp
powershell -command (Get-Content -Path '.\curlthis.tmp' -TotalCount 2)[-1] > latest.tmp
for /f "Tokens=* Delims=" %%x in (latest.tmp) do curl -L %%x -o "quilt-installer.exe"
del *.tmp

START "" "%~dp0\resources\quilt-installer.exe"
)
