
:START
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

    IF "!_input!"=="exit" EXIT :: Exit command used for testing purposes

    call :READ_STR form _input
EXIT /B 0

:EVAL
    set "_result="
EXIT /B 0

:PRINT
    call :PR_STR output form
    call :ECHO output
EXIT /B 0
