 
This is basically just an installer I made for my minecraft you can use it however you like

## If you are installing the mods

- Run run_me.bat
- Commands will do the rest

## If you wanna change the default directory

- locate your minecraft folder after running custom_directory.bat 
  - alternatively you can just change the mcdir.txt

# Documentation
- how it works

Hello! It seems like the code you provided is a batch script that automates the process of installing Minecraft mods and a mod loader called Quilt. Here's a brief explanation of what each part of the script does:

chcp 65001 sets the console code page to UTF-8 to ensure proper display of non-ASCII characters in the script output.
curl -s https://www.7-zip.org/a/7zr.exe -o resources/7zr.exe downloads the command-line version of the 7-Zip archiver and saves it in a subdirectory called "resources".
setlocal enabledelayedexpansion enables delayed environment variable expansion, which allows variables to be expanded at execution time rather than parsing time.
powershell -command New-Item -Path .\resources -Name "mcdir.txt" creates a new file called "mcdir.txt" in the "resources" subdirectory using Windows PowerShell.
for %%x in (.\resources\mcdir.txt) do if %%~zx==0 ( echo "%appdata%\.minecraft"> .\resources\mcdir.txt ) checks if the file size of "mcdir.txt" is 0 bytes and, if so, writes the default Minecraft directory path to it.
The next few lines of the script use environment variables and conditional statements to prompt the user to choose a custom Minecraft directory path, or use the default path if no input is provided.
mkdir !folder!\mods creates a "mods" directory in the chosen Minecraft directory path.
set dest=!folder!\mods sets the "dest" variable to the full path of the "mods" directory.
set pending=%~dp0\pending_mods sets the "pending" variable to the full path of a subdirectory called "pending_mods" in the current directory.
rmdir %~dp0\mods deletes the "mods" directory in the current directory (if it exists).
mklink /D "%~dp0\mods" "!dest!" creates a symbolic link called "mods" in the current directory that points to the chosen Minecraft directory's "mods" directory.
xcopy *.* ".\.disabled\%date:~-10,2%.%date:~7,2%.%date:~-4,4%;%subkey1%" /i copies all files in the chosen Minecraft directory's "mods" directory to a subdirectory called ".disabled" with the current date and a random string appended to the name.
del *.jar deletes all ".jar" files in the chosen Minecraft directory's "mods" directory.
for /f "tokens=2" %%A in ('%~dp0\resources\path.cmd') do curl -L -k "%%A" -O downloads the latest version of Quilt from the URL specified in a separate script called "path.cmd".
"%~dp0/resources/7zr.exe" x *.7z extracts all ".7z" files in the current directory using the 7-Zip archiver.
for %%f in (*.zip) do tar -xf "%%f" extracts all ".zip" files in the current directory using the tar archiver.
del *.zip *.7z *.rar deletes all ".zip", ".7z", and ".rar" files in the current directory.
xcopy *.* !dest! copies all files in the current directory (excluding the ".disabled" subdirectory) to the chosen Minecraft directory's "mods" directory.
The last few lines of the script create a subdirectory called "modloader
