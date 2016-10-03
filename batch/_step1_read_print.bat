
:START
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

    IF "!_input!"=="exit" EXIT :: Exit command used for testing purposes

    CALL :READ_STR form _input
EXIT /B 0

:EVAL
    SET "_result="
EXIT /B 0

:PRINT
    CALL :PR_STR output form
    CALL :ECHO output
EXIT /B 0
