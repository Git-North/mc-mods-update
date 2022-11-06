for /f "tokens=2" %%A in ('path.cmd') do powershell -command -first 1 | curl -L "%%A" -O
powershell -command -first 1
