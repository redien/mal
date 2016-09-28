@echo off
SETLOCAL ENABLEEXTENSIONS ENABLEDELAYEDEXPANSION

:: While macros
set BREAK=EXIT
set WHILE=IF "%1"=="fi301kvnro2qa9vm2" (FOR /L %%? IN () DO IF
set DO=(
set END_WHILE=) ELSE %BREAK%) ELSE CMD /Q /C "%~F0" fi301kvnro2qa9vm2

:: Magic number that says we're calling a loop
IF "%1"=="fi301kvnro2qa9vm2" GOTO %2

set "NIL="
set "TRUE=t"
set "FALSE=f"

set _doublequote=^"
set _backslash=^\

GOTO :START

:ECHO
    IF NOT "!%1!"=="" echo !%1!
EXIT /B 0
