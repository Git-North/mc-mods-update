mklink /D "./" "%appdata%/.minecraft/mods"
powershell -command curl -L "" "https://www.7-zip.org/a/7zr.exe" --output "./resources/7zr.exe"
"./resources/7zr.exe" x *.zip
