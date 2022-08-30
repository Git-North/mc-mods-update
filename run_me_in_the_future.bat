::mklink /D "./" "%appdata%/.minecraft/mods"

::mkdir %date:~-10,2%.%date:~7,2%.%date:~-4,4%

powershell -command curl -L "" "https://www.7-zip.org/a/7zr.exe" --output "./resources/7zr.exe"
"./resources/7zr.exe" x *.zip
