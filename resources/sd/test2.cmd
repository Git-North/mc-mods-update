for /f "tokens=2" %%A in ('path.cmd') do powershell -command -first 1 | echo %%A> curlthis.txt

