@echo off
SETLOCAL ENABLEEXTENSIONS ENABLEDELAYEDEXPANSION

SET _newline=^


:: Do not remove the empty lines above
::

set "sp=0"
set "sp2=-1"
set pops=set ^"
set pope=^=stack^^!sp^^!^" ^& set ^/a ^"sp-=1^"
set pushs=set ^/a ^"sp+=1^" ^& set ^"stack^^!sp^^!^=^^!
set pushe=^^!^"

goto :start


:read_str
    set "test=abc"
    set "test2=123"
    %pushs%test%pushe%
    echo !stack1!
    %pushs%test2%pushe%
    echo !stack2!
    %pops%var%pope%
    %pops%var2%pope%
    echo !%var%!
    echo !%var2%!
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

