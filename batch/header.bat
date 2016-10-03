@echo off
SETLOCAL ENABLEEXTENSIONS ENABLEDELAYEDEXPANSION

:: While macros
SET BREAK=EXIT
SET WHILE=IF "%1"=="fi301kvnro2qa9vm2" (FOR /L %%? IN () DO IF
SET DO=(
SET END_WHILE=) ELSE %BREAK%) ELSE CMD /Q /C "%~F0" fi301kvnro2qa9vm2

:: Magic number that says we're calling a loop
IF "%1"=="fi301kvnro2qa9vm2" GOTO %2

SET "NIL="
SET "TRUE=t"
SET "FALSE=f"

SET _doublequote=^"
SET _backslash=^\
SET _singlequote=^'
SET _backtick=^`
SET _tilde=^~
SET _splice_unquote=^~^@
SET _with_meta=^^

GOTO :START

:ECHO
    IF NOT "!%1!"=="" echo !%1!
EXIT /B 0

:ABORT
    ECHO %~1
    GOTO :START
EXIT
