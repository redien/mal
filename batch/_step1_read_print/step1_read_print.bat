
:FUNC
    EXIT /B 1
EXIT /B 0

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
EXIT /B 0

:EVAL
    set "_result="
    call :TOKENIZER tokens _input
:PRINT_TOKENS
    IF NOT "!tokens!"=="!NIL!" (
        call :FIRST token tokens
        call :ECHO token
        call :REST tokens tokens
        GOTO :PRINT_TOKENS
    )
EXIT /B 0

:PRINT
    call :ECHO _result
EXIT /B 0
