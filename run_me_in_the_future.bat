SET "psCommand="(new-object -COM 'Shell.Application')^
.BrowseForFolder(0,'Select where Minecraft is installed',0,26).self.path""
FOR /f "usebackq delims=" %%I in (`powershell %psCommand%`) do set "folder=%%I"

setlocal enabledelayedexpansion
set dest=!folder!\mods

IF NOT EXIST !folder! (
  echo no folder selected or folder not found.
mklink /D "./" "!folder!\mods"

cd !folder!
xcopy *.* %date:~-10,2%.%date:~7,2%.%date:~-4,4% /i
del *.jar*

cd %~dp0
for /f "tokens=2" %%A in ('path.cmd') do curl -L "%%A" -o mods.zip
powershell -command curl -L "" "https://www.7-zip.org/a/7zr.exe" --output "./resources/7zr.exe"
"./resources/7zr.exe" x *.zip
