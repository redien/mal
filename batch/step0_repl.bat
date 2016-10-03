@echo off
SETLOCAL ENABLEEXTENSIONS ENABLEDELAYEDEXPANSION

:REPL
    SET "_input="
    CALL :READ
    CALL :EVAL
    CALL :PRINT
GOTO :REPL

:READ
    :: prompt the user and assign the user's input to _input.
    SET /p "_input=user> "
    :: If nothing is written, empty the input and reSET the error level
    IF  errorlevel 1 SET "_input=" & verify>nul
EXIT /B 0

:EVAL
    SET "_result=!_input!"
EXIT /B 0

:PRINT
    IF NOT "!_result!"=="" echo !_result!
EXIT /B 0
