@echo off
setlocal

cd ..
cd test
powershell -WindowStyle Hidden -Command "wsl -e /bin/bash -c 'gtkwave tb.vcd >/dev/null 2>&1'"

endlocal
