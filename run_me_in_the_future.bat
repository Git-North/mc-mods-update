

SET "psCommand="(new-object -COM 'Shell.Application')^
.BrowseForFolder(0,'Select where Minecraft is installed',0,26).self.path""
FOR /f "usebackq delims=" %%I in (`powershell %psCommand%`) do set "folder=%%I"

setlocal enabledelayedexpansion
set dest=!folder!\mods



IF NOT EXIST !folder! (
  echo no folder selected or folder not found.
  <nul set /p "=Press any key to exit...
  pause >nul
  endlocal
) else (
curl -L https://www.7-zip.org/a/7zr.exe --output resources\7zr.exe

mklink /D ".\mods" "!folder!\mods"

cd !folder!\mods
xcopy *.* %date:~-10,2%.%date:~7,2%.%date:~-4,4% /i

del *.jar*

cd %~dp0
for /f "tokens=2" %%A in ('resources\path.cmd') do curl -L "%%A" -o mods.zip

"%~dp0/resources/7zr.exe" x *.zip
)
