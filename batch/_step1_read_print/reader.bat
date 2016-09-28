
:READ_WHILE
    set "%1="
:READ_WHILE_LOOP
    IF "!%2!"=="" (
        EXIT /B 0
    )

    set "READ_WHILE_char=!%2:~0,1!"

    call %3 READ_WHILE_did_match READ_WHILE_char

    IF "!READ_WHILE_did_match!"=="!FALSE!" (
        EXIT /B 0
    )
    set "%1=!%1!!READ_WHILE_char!"
    set "%2=!%2:~1,8191!"
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

:IS_NOT_DOUBLEQUOTE_OR_BACKSLASH
    set "%1=!TRUE!"
    IF "!%2!"=="!_doublequote!" (set "%1=!FALSE!" & EXIT /B 0)
    IF "!%2!"=="!_backslash!" (set "%1=!FALSE!" & EXIT /B 0)
EXIT /B 0

:IS_NOT_SPECIAL_CHARACTER
    call :IS_SPECIAL_CHARACTER %1 %2
    IF "!%1!"=="!FALSE!" (
        set "%1=!TRUE!"
    ) ELSE (
        set "%1=!FALSE!"
    )
EXIT /B 0

:READ_STRING
    IF "!%2!"=="" (
        set "%1="
        EXIT /B 0
    )
    call :STRING_LENGTH READ_STRING_length %3
    set "READ_STRING_match=!%2:~0,%READ_STRING_length%!"
    IF "!READ_STRING_match!"=="!%3!" (
        set "%1=!READ_STRING_match!"
        set "%2=!%2:~%READ_STRING_length%!"
    ) ELSE (
        set "%1="
    )
EXIT /B 0

:READ_DOUBLEQUOTED_STRING
    set "%1="

    :: If there is a double-quote, read a quoted string
    IF "!%2:~0,1!"=="!_doublequote!" (
:READ_DOUBLEQUOTED_STRING_CONTINUE
        IF "!%2!"=="" (
            EXIT /B 0
        )

        set "%1=!%1!!%2:~0,1!"
        set "%2=!%2:~1,8191!"

        call :READ_WHILE READ_DOUBLEQUOTED_STRING_match %2 :IS_NOT_DOUBLEQUOTE_OR_BACKSLASH
        set "%1=!%1!!READ_DOUBLEQUOTED_STRING_match!"

        IF "!%2!"=="" (
            EXIT /B 0
        )

        set "READ_DOUBLEQUOTED_STRING_terminator=!%2:~0,1!"
        set "%2=!%2:~1,8191!"
        set "%1=!%1!!READ_DOUBLEQUOTED_STRING_terminator!"

        :: If the last character was a back-slash, we continue reading the string.
        IF "!READ_DOUBLEQUOTED_STRING_terminator!"=="!_backslash!" (
            GOTO :READ_DOUBLEQUOTED_STRING_CONTINUE
        )
    )
EXIT /B 0

:SKIP_COMMENT
    :: If we encounter a comment, skip the rest by emptying the buffer
    IF "!%1:~0,1!"==";" (
        set "%1="
    )
EXIT /B 0

:TOKENIZER
    :: We put the input string into a buffer for reading
    set "TOKENIZER_buffer=!%2!"
    set "TOKENIZER_list=!NIL!"
    set "TOKENIZER_@=~@"

:TOKENIZER_LOOP
    call :READ_WHILE TOKENIZER_token TOKENIZER_buffer :IS_COMMA_OR_SPACE
    IF NOT "!TOKENIZER_token!"=="" (
        :: Whitespace and commas are ignored
        GOTO :TOKENIZER_LOOP
    )

    call :READ_STRING TOKENIZER_token TOKENIZER_buffer TOKENIZER_@
    IF NOT "!TOKENIZER_token!"=="" (
        call :CONS TOKENIZER_list TOKENIZER_token TOKENIZER_list
        GOTO :TOKENIZER_LOOP
    )

    call :READ_WHILE TOKENIZER_token TOKENIZER_buffer :IS_SPECIAL_CHARACTER
    IF NOT "!TOKENIZER_token!"=="" (
        call :CONS TOKENIZER_list TOKENIZER_token TOKENIZER_list
        GOTO :TOKENIZER_LOOP
    )

    call :READ_DOUBLEQUOTED_STRING TOKENIZER_token TOKENIZER_buffer
    IF NOT "!TOKENIZER_token!"=="" (
        call :CONS TOKENIZER_list TOKENIZER_token TOKENIZER_list
        GOTO :TOKENIZER_LOOP
    )

    call :SKIP_COMMENT TOKENIZER_buffer

    call :READ_WHILE TOKENIZER_token TOKENIZER_buffer :IS_NOT_SPECIAL_CHARACTER
    IF NOT "!TOKENIZER_token!"=="" (
        call :CONS TOKENIZER_list TOKENIZER_token TOKENIZER_list
        GOTO :TOKENIZER_LOOP
    )

    set "%1=!TOKENIZER_list!"
EXIT /B 0

:READ_STR

EXIT /B 0
