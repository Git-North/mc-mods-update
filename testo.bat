chcp 65001
for /f "tokens=2" %%A in (%~dp0\resources\path.cmd) do echo %%A
for /f "tokens=2" %%A in ('%~dp0\resources\path.cmd') do curl -L "%%A" -O
PAUSE
