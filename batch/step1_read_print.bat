@echo off
SETLOCAL ENABLEEXTENSIONS ENABLEDELAYEDEXPANSION

set "sp=0"
set "pop=set /a ^"sp-=1^""
set pops=set ^"
set pope=^=^^!stack^!sp^!^^!^"

goto :start


:read_str
    set "stack0=abc"
    %pops%var%pope%
    echo .!var!.
EXIT /B 0

:start

call :read_str

:repl
    set "_input="
    set /p "_input=user> "
	
    :: If nothing is written, empty the input and reSET the error level
    IF  errorlevel 1 SET "_input=" & verify>nul
    :: Exit command used for testing purposes
    IF "!_input!"=="exit" EXIT
	
    echo !_input!
goto :repl

