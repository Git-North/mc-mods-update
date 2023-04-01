@echo off


mkdir %temp%\mc-mods-installer\
cd "%temp%\mc-mods-installer\"
for /f "tokens=2" %%B in ('quiltmc-path.cmd') do echo %%B 
powershell -command (Get-Content -Path '.\curlthis.tmp' -TotalCount 2)[-1] > latest.tmp
for /f "Tokens=* Delims=" %%Q in (latest.tmp) do curl -L %%Q -o "quilt-installer.exe"