@echo off
SETLOCAL ENABLEEXTENSIONS ENABLEDELAYEDEXPANSION

set "_str=abcd"
set "_str2=1234"

call types.bat :CONS _rest _str2 _nil

call types.bat :CONS _list _str _rest

echo !_list!
call types.bat :FIRST _first _list
echo !_first!
call types.bat :REST _rest _list
echo !_rest!

:REPL
    set "_input="
    call :READ
    call :EVAL
    call :PRINT
GOTO :REPL

:READ
    set /p "_input=user> "
    if errorlevel 1 set "_input=" & verify>nul
EXIT /B 0

:EVAL
    set "_reader_buffer=!_input!"
    call reader.bat :READ_CHARACTER
    echo !_read_character!
    call reader.bat :READ_CHARACTER
    echo !_read_character!
    call reader.bat :READ_CHARACTER
    echo !_read_character!
    call reader.bat :READ_CHARACTER
    echo !_read_character!

    set "_result=!_input!"
EXIT /B 0

:PRINT
    IF NOT "!_result!"=="" echo !_result!
    IF "!_result!"=="" echo.
EXIT /B 0
