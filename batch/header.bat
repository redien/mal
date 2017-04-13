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
SET "EMPTY_LIST=l"
SET "TRUE=t"
SET "FALSE=f"

SET _newline_escape=\n
SET _doublequote_escape=\"
SET _backslash_escape=\\

SET _doublequote=^"
SET _backslash=^\
SET _singlequote=^'
SET _backtick=^`
SET _tilde=^~
SET _splice_unquote=^~^@
SET _with_meta=^^
SET _greater_than=^>
SET _lower_than=^<
SET _greater_than_equal=^>^=
SET _lower_than_equal=^<^=
SET _equal=^=
SET _plus=^+
SET _minus=^-
SET _slash=^/
SET _asterisk=^*
SET _newline=^


:: Do not remove the empty lines above

GOTO :START

:ECHO
    IF NOT "!%1!"=="" echo !%1!
EXIT /B 0

:ABORT
    :: With to many calls to abort the stack starts to fill up.
    :: Better to return an error value instead.
    ECHO %~1
    GOTO :START
EXIT
