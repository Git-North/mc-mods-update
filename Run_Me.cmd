@ECHO OFF
setlocal
SET mypath=%~dp0
SET modpath=%mypath:~0,-1%\mods
echo modpath: %modpath%
TITLE North's Minecraft Mod Syncer
ECHO Downloading zip file
for /f "tokens=2" %%A in ('path.cmd') do curl -L "%%A" -o mods.zip
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
  echo Unzipping to %dest%
  pathfinder_and_[un]zipping_HAHAHAHHAH_[im_going_insane].exe "mods.zip" -d mods
  robocopy "%modpath%" "%dest%" /PURGE
  <nul set /p "=Complete Press any key to exit...
  pause >nul
  rmdir /S /Q mods
  del /S /Q mods.zip
  endlocal
)
