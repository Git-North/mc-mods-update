for /f "tokens=2" %%A in ('path.cmd') do echo %%A >> curlthis.tmp
powershell -command (Get-Content -Path .\curlthis.tmp -TotalCount 2)[-1]
pause

