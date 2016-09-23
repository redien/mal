@echo off
SETLOCAL ENABLEEXTENSIONS ENABLEDELAYEDEXPANSION

:REPL
    set "_input="
    call :READ
    call :EVAL
    call :PRINT
GOTO :REPL

:READ
    :: prompt the user and assign the user's input to _input.
    set /p "_input=user> "
    :: If nothing is written, empty the input and reset the error level
    if errorlevel 1 set "_input=" & verify>nul
EXIT /B 0

:EVAL
    set "_result=!_input!"
EXIT /B 0

:PRINT
    IF NOT "!_result!"=="" echo !_result!
EXIT /B 0
