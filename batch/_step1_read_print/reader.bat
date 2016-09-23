
:READ_WHILE
    set "%1="
:READ_WHILE_LOOP
    set "READ_WHILE_char=!%2:~0,1!"
    IF "!READ_WHILE_char!"=="" (
        EXIT /B 0
    )

    call %3 READ_WHILE_did_match READ_WHILE_char

    IF "!READ_WHILE_did_match!"=="!FALSE!" (
        EXIT /B 0
    )
    set "%1=!%1!!READ_WHILE_char!"
    set "%2=!%2:~1,2147483647!"
    GOTO :READ_WHILE_LOOP
EXIT /B 0

:IS_COMMA_OR_SPACE
    set "%1=!FALSE!"
    IF "!%2!"=="," (set "%1=!TRUE!" & EXIT /B 0)
    IF "!%2!"==" " (set "%1=!TRUE!" & EXIT /B 0)
EXIT /B 0

:IS_SPECIAL_CHARACTER
    set "%1=!FALSE!"
    IF "!%2!"=="[" (set "%1=!TRUE!" & EXIT /B 0)
    IF "!%2!"=="]" (set "%1=!TRUE!" & EXIT /B 0)
    IF "!%2!"=="{" (set "%1=!TRUE!" & EXIT /B 0)
    IF "!%2!"=="}" (set "%1=!TRUE!" & EXIT /B 0)
    IF "!%2!"=="(" (set "%1=!TRUE!" & EXIT /B 0)
    IF "!%2!"==")" (set "%1=!TRUE!" & EXIT /B 0)
    IF "!%2!"=="'" (set "%1=!TRUE!" & EXIT /B 0)
    IF "!%2!"=="`" (set "%1=!TRUE!" & EXIT /B 0)
    IF "!%2!"=="~" (set "%1=!TRUE!" & EXIT /B 0)
    IF "!%2!"=="^" (set "%1=!TRUE!" & EXIT /B 0)
    IF "!%2!"=="@" (set "%1=!TRUE!" & EXIT /B 0)
EXIT /B 0

:TOKENIZER
    :: We put the input string into a buffer for reading
    set "TOKENIZER_buffer=!%2!"
    set "TOKENIZER_list=!NIL!"

:TOKENIZER_LOOP
    call :READ_WHILE TOKENIZER_token TOKENIZER_buffer :IS_SPECIAL_CHARACTER
    IF NOT "!TOKENIZER_token!"=="" (
        call :CONS TOKENIZER_list TOKENIZER_token TOKENIZER_list
        GOTO :TOKENIZER_LOOP
    )

    call :READ_WHILE TOKENIZER_token TOKENIZER_buffer :IS_COMMA_OR_SPACE
    IF NOT "!TOKENIZER_token!"=="" (
        call :CONS TOKENIZER_list TOKENIZER_token TOKENIZER_list
        GOTO :TOKENIZER_LOOP
    )

    set "%1=!TOKENIZER_list!"
EXIT /B 0
