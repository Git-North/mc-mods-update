for /f "tokens=2" %%A in ('path.cmd') do echo %%A >> curlthis.tmp
powershell -command Get-Content curlthis.tmp -Head 2
pause

