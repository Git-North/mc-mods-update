@echo off
setlocal enabledelayedexpansion
echo Please select your minecraft filepath
SET "psCommand="(new-object -COM 'Shell.Application')^
.BrowseForFolder(0,'Select where Minecraft is installed',0,26).self.path""
FOR /f "usebackq delims=" %%I in (`powershell %psCommand%`) do set "folder=%%I"

echo !folder! > resources\mcdir.txt
@echo on
call run_me.bat