for /f "tokens=2" %%A in (%~dp0\resources\path.cmd) do curl -k -L -I %%A -O
