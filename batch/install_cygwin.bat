
REM URL to cygwin-setup
SET "cygwin_setup_url=https://cygwin.com/setup-x86.exe"

REM Download cygwin-setup
PowerShell -Command "Invoke-WebRequest $env:cygwin_setup_url -OutFile 'cygwin_setup.exe'"

REM Perform install
cygwin_setup.exe -s http://ftp.acc.umu.se/mirror/cygwin/ -P python -P make -q -B
