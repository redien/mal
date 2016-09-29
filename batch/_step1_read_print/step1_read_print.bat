
:START
:REPL
    set "_input="
    call :READ
    IF "!_input!"=="exit" EXIT /B 0 :: Exit command used for testing purposes
    call :EVAL
    call :PRINT
GOTO :REPL

:READ
    :: prompt the user and assign the user's input to _input.
    set /p "_input=user> "
    :: If nothing is written, empty the input and reset the error level
    if errorlevel 1 set "_input=" & verify>nul

    call :READ_STR form _input

EXIT /B 0

:EVAL
    set "_result="
EXIT /B 0

:PRINT
    call :PR_STR output form
    call :ECHO output
EXIT /B 0
