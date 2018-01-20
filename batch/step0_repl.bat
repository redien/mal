@echo off
SETLOCAL ENABLEEXTENSIONS ENABLEDELAYEDEXPANSION

set "sp=0"
set "pop=set /a ^"sp-=1^""

goto :start


:READ_STR
    set "var=!stack%sp%!"
    %pop%
:EXIT /B 0


:start

:REPL
	SET /p "input=user> "
	ECHO %input%
GOTO :REPL

