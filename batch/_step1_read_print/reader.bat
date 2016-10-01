
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

:READ_CHARACTER
    set "%1="

    IF "!%2!"=="" (
        EXIT /B 0
    )

    set "READ_CHARACTER_char=!%2:~0,1!"

    call %3 READ_CHARACTER_did_match READ_CHARACTER_char

    IF "!READ_CHARACTER_did_match!"=="!FALSE!" (
        EXIT /B 0
    )

    set "%1=!READ_CHARACTER_char!"
    set "%2=!%2:~1,8191!"
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

:IS_ATOM_CHARACTER
    set "%1=!TRUE!"
    IF "!%2!"=="[" (set "%1=!FALSE!" & EXIT /B 0)
    IF "!%2!"=="]" (set "%1=!FALSE!" & EXIT /B 0)
    IF "!%2!"=="{" (set "%1=!FALSE!" & EXIT /B 0)
    IF "!%2!"=="}" (set "%1=!FALSE!" & EXIT /B 0)
    IF "!%2!"=="(" (set "%1=!FALSE!" & EXIT /B 0)
    IF "!%2!"==")" (set "%1=!FALSE!" & EXIT /B 0)
    IF "!%2!"=="'" (set "%1=!FALSE!" & EXIT /B 0)
    IF "!%2!"=="`" (set "%1=!FALSE!" & EXIT /B 0)
    IF "!%2!"=="~" (set "%1=!FALSE!" & EXIT /B 0)
    IF "!%2!"=="^" (set "%1=!FALSE!" & EXIT /B 0)
    IF "!%2!"=="@" (set "%1=!FALSE!" & EXIT /B 0)
    IF "!%2!"=="," (set "%1=!FALSE!" & EXIT /B 0)
    IF "!%2!"==" " (set "%1=!FALSE!" & EXIT /B 0)
    IF "!%2!"==";" (set "%1=!FALSE!" & EXIT /B 0)
    IF "!%2!"=="!_doublequote!" (set "%1=!FALSE!" & EXIT /B 0)
EXIT /B 0

:READ_STRING
    IF "!%2!"=="" (
        set "%1="
        EXIT /B 0
    )
    call :STRLEN READ_STRING_length %3
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
    call :VECTOR_NEW TOKENIZER_list
    set "TOKENIZER_@=~@"

:TOKENIZER_LOOP
    call :READ_WHILE TOKENIZER_token TOKENIZER_buffer :IS_COMMA_OR_SPACE
    IF NOT "!TOKENIZER_token!"=="" (
        :: Whitespace and commas are ignored
        GOTO :TOKENIZER_LOOP
    )

    call :READ_STRING TOKENIZER_token TOKENIZER_buffer TOKENIZER_@
    IF NOT "!TOKENIZER_token!"=="" (
        call :VECTOR_PUSH TOKENIZER_list TOKENIZER_token
        GOTO :TOKENIZER_LOOP
    )

    call :READ_CHARACTER TOKENIZER_token TOKENIZER_buffer :IS_SPECIAL_CHARACTER
    IF NOT "!TOKENIZER_token!"=="" (
        call :VECTOR_PUSH TOKENIZER_list TOKENIZER_token
        GOTO :TOKENIZER_LOOP
    )

    call :READ_DOUBLEQUOTED_STRING TOKENIZER_token TOKENIZER_buffer
    IF NOT "!TOKENIZER_token!"=="" (
        call :VECTOR_PUSH TOKENIZER_list TOKENIZER_token
        GOTO :TOKENIZER_LOOP
    )

    call :SKIP_COMMENT TOKENIZER_buffer

    call :READ_WHILE TOKENIZER_token TOKENIZER_buffer :IS_ATOM_CHARACTER
    IF NOT "!TOKENIZER_token!"=="" (
        call :VECTOR_PUSH TOKENIZER_list TOKENIZER_token
        GOTO :TOKENIZER_LOOP
    )

    set "%1=!TOKENIZER_list!"
EXIT /B 0

:READ_LIST
    set /a "%3+=1"
    set "%1=!NIL!"
    call :VECTOR_LENGTH READ_LIST_length %2
:READ_LIST_LOOP
    IF !%3! GEQ !READ_LIST_length! (
        call :ABORT "expected ')', got EOF"
    )

    call :VECTOR_GET READ_LIST_token %2 %3
    IF "!READ_LIST_token!"==")" (
        set /a "%3+=1"
        call :LIST_REVERSE tmp %1
        set "%1=!tmp!"
        EXIT /B 0
    )

    call :READ_FORM form%_recursive_count% %2 %3
    call :CONS %1 form%_recursive_count% %1

    GOTO :READ_LIST_LOOP
EXIT /B 0

:READ_VECTOR
    set /a "%3+=1"
    call :VECTOR_NEW %1
    call :VECTOR_LENGTH READ_LIST_length %2
:READ_VECTOR_LOOP
    IF !%3! GEQ !READ_LIST_length! (
        call :ABORT "expected ']', got EOF"
    )

    call :VECTOR_GET READ_LIST_token %2 %3
    IF "!READ_LIST_token!"=="]" (
        set /a "%3+=1"
        EXIT /B 0
    )

    call :READ_FORM form%_recursive_count% %2 %3
    call :VECTOR_PUSH %1 form%_recursive_count%

    GOTO :READ_VECTOR_LOOP
EXIT /B 0

:IS_NUMERIC

EXIT /B 0

:READ_ATOM
    call :VECTOR_GET READ_ATOM_token %2 %3
    call :ATOM_NEW %1 READ_ATOM_token
    set /a "%3+=1"
EXIT /B 0

:READ_PREFIX
    set /a "%3+=1"

    set "%1=!NIL!"
    call :ATOM_NEW READ_PREFIX_atom%_recursive_count% %4
    call :READ_FORM READ_PREFIX_form%_recursive_count% %2 %3
    call :CONS %1 READ_PREFIX_form%_recursive_count% %1
    call :CONS %1 READ_PREFIX_atom%_recursive_count% %1
EXIT /B 0

:READ_FORM
:: To get around the limitation of no local variables,
:: we keep a recursion count to diffirentiate variables
:: for each recursion level.

:: This can be solved better in the future by making them tail-recursive
    set /a "_recursive_count+=1"
    call :VECTOR_LENGTH READ_FORM_length %2
    IF !%3! GEQ !READ_FORM_length! (
        call :ABORT "Unexpected EOF"
    )

    :: These nested IF statements slow down the reader significantly, can we
    :: branch some other way to make it faster?
    call :VECTOR_GET READ_FORM_token %2 %3
    IF "!READ_FORM_token!"=="(" (
        call :READ_LIST READ_FORM_form%_recursive_count% %2 %3
    ) ELSE (
        IF "!READ_FORM_token!"=="[" (
            call :READ_VECTOR READ_FORM_form%_recursive_count% %2 %3
        ) ELSE (
            IF "!READ_FORM_token!"=="!_singlequote!" (
                set "READ_FORM_quote=quote"
                call :READ_PREFIX READ_FORM_form%_recursive_count% %2 %3 READ_FORM_quote
            ) ELSE (
                IF "!READ_FORM_token!"=="!_backtick!" (
                    set "READ_FORM_quote=quasiquote"
                    call :READ_PREFIX READ_FORM_form%_recursive_count% %2 %3 READ_FORM_quote
                ) ELSE (
                    IF "!READ_FORM_token!"=="!_tilde!" (
                        set "READ_FORM_quote=unquote"
                        call :READ_PREFIX READ_FORM_form%_recursive_count% %2 %3 READ_FORM_quote
                    ) ELSE (
                        IF "!READ_FORM_token!"=="!_splice_unquote!" (
                            set "READ_FORM_quote=splice-unquote"
                            call :READ_PREFIX READ_FORM_form%_recursive_count% %2 %3 READ_FORM_quote
                        ) ELSE (
                            IF "!READ_FORM_token!"=="@" (
                                set "READ_FORM_quote=deref"
                                call :READ_PREFIX READ_FORM_form%_recursive_count% %2 %3 READ_FORM_quote
                            ) ELSE (
                                call :READ_ATOM READ_FORM_form%_recursive_count% %2 %3
                            )
                        )
                    )
                )
            )
        )
    )

    set "%1=!READ_FORM_form%_recursive_count%!"
    set /a "_recursive_count-=1"
EXIT /B 0

:READ_STR
    call :TOKENIZER READ_STR_tokens %2
    set "_recursive_count=0"
    set "READ_STR_index=0"
    call :READ_FORM %1 READ_STR_tokens READ_STR_index
EXIT /B 0
