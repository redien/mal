@echo off
SETLOCAL ENABLEEXTENSIONS ENABLEDELAYEDEXPANSION

:REPL
    set "_input="
    call :READ
    call :EVAL
    call :PRINT
GOTO :REPL

:READ
    set /p "_input=user> "
    if errorlevel 1 set "_input=" & verify>nul & echo.
EXIT /B 0

:EVAL
    set "_result=!_input!"
EXIT /B 0

:PRINT
    IF NOT "!_result!"=="" echo !_result!
EXIT /B 0
