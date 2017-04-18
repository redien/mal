
:READ_WHILE
    SET "%1="
:READ_WHILE_LOOP
    IF "!%2!"=="" (
        EXIT /B 0
    )

    SET "READ_WHILE_char=!%2:~0,1!"

    CALL %3 READ_WHILE_did_match READ_WHILE_char

    IF "!READ_WHILE_did_match!"=="!FALSE!" (
        EXIT /B 0
    )
    SET "%1=!%1!!READ_WHILE_char!"
    SET "%2=!%2:~1,8191!"
    GOTO :READ_WHILE_LOOP
EXIT /B 0

:READ_CHARACTER
    SET "%1="

    IF "!%2!"=="" (
        EXIT /B 0
    )

    SET "READ_CHARACTER_char=!%2:~0,1!"

    CALL %3 READ_CHARACTER_did_match READ_CHARACTER_char

    IF "!READ_CHARACTER_did_match!"=="!FALSE!" (
        EXIT /B 0
    )

    SET "%1=!READ_CHARACTER_char!"
    SET "%2=!%2:~1,8191!"
EXIT /B 0

:IS_COMMA_OR_SPACE
    SET "%1=!FALSE!"
    IF "!%2!"=="," (SET "%1=!TRUE!" & EXIT /B 0)
    IF "!%2!"==" " (SET "%1=!TRUE!" & EXIT /B 0)
    IF "!%2!"=="!_newline!" (SET "%1=!TRUE!" & EXIT /B 0)
EXIT /B 0

:IS_SPECIAL_CHARACTER
    SET "%1=!FALSE!"
    IF "!%2!"=="[" (SET "%1=!TRUE!" & EXIT /B 0)
    IF "!%2!"=="]" (SET "%1=!TRUE!" & EXIT /B 0)
    IF "!%2!"=="{" (SET "%1=!TRUE!" & EXIT /B 0)
    IF "!%2!"=="}" (SET "%1=!TRUE!" & EXIT /B 0)
    IF "!%2!"=="(" (SET "%1=!TRUE!" & EXIT /B 0)
    IF "!%2!"==")" (SET "%1=!TRUE!" & EXIT /B 0)
    IF "!%2!"=="'" (SET "%1=!TRUE!" & EXIT /B 0)
    IF "!%2!"=="`" (SET "%1=!TRUE!" & EXIT /B 0)
    IF "!%2!"=="~" (SET "%1=!TRUE!" & EXIT /B 0)
    IF "!%2!"=="^" (SET "%1=!TRUE!" & EXIT /B 0)
    IF "!%2!"=="@" (SET "%1=!TRUE!" & EXIT /B 0)
EXIT /B 0

:IS_NOT_DOUBLEQUOTE_OR_BACKSLASH
    SET "%1=!TRUE!"
    IF "!%2!"=="!_doublequote!" (SET "%1=!FALSE!" & EXIT /B 0)
    IF "!%2!"=="!_backslash!" (SET "%1=!FALSE!" & EXIT /B 0)
EXIT /B 0

:IS_ATOM_CHARACTER
    SET "%1=!TRUE!"
    IF "!%2!"=="[" (SET "%1=!FALSE!" & EXIT /B 0)
    IF "!%2!"=="]" (SET "%1=!FALSE!" & EXIT /B 0)
    IF "!%2!"=="{" (SET "%1=!FALSE!" & EXIT /B 0)
    IF "!%2!"=="}" (SET "%1=!FALSE!" & EXIT /B 0)
    IF "!%2!"=="(" (SET "%1=!FALSE!" & EXIT /B 0)
    IF "!%2!"==")" (SET "%1=!FALSE!" & EXIT /B 0)
    IF "!%2!"=="'" (SET "%1=!FALSE!" & EXIT /B 0)
    IF "!%2!"=="`" (SET "%1=!FALSE!" & EXIT /B 0)
    IF "!%2!"=="~" (SET "%1=!FALSE!" & EXIT /B 0)
    IF "!%2!"=="^" (SET "%1=!FALSE!" & EXIT /B 0)
    IF "!%2!"=="@" (SET "%1=!FALSE!" & EXIT /B 0)
    IF "!%2!"=="," (SET "%1=!FALSE!" & EXIT /B 0)
    IF "!%2!"==" " (SET "%1=!FALSE!" & EXIT /B 0)
    IF "!%2!"==";" (SET "%1=!FALSE!" & EXIT /B 0)
    IF "!%2!"=="!_newline!" (SET "%1=!FALSE!" & EXIT /B 0)
    IF "!%2!"=="!_doublequote!" (SET "%1=!FALSE!" & EXIT /B 0)
EXIT /B 0

:READ_STRING
    IF "!%2!"=="" (
        SET "%1="
        EXIT /B 0
    )
    CALL :STRLEN READ_STRING_length %3
    SET "READ_STRING_match=!%2:~0,%READ_STRING_length%!"
    IF "!READ_STRING_match!"=="!%3!" (
        SET "%1=!READ_STRING_match!"
        SET "%2=!%2:~%READ_STRING_length%!"
    ) ELSE (
        SET "%1="
    )
EXIT /B 0

:READ_DOUBLEQUOTED_STRING
    SET "%1="

    :: If there is a double-quote, read a quoted string
    IF "!%2:~0,1!"=="!_doublequote!" (
        SET "%1=!%1!!%2:~0,1!"
        SET "%2=!%2:~1,8191!"
:READ_DOUBLEQUOTED_STRING_CONTINUE
        IF "!%2!"=="" (
            EXIT /B 0
        )

        CALL :READ_WHILE READ_DOUBLEQUOTED_STRING_match %2 :IS_NOT_DOUBLEQUOTE_OR_BACKSLASH
        SET "%1=!%1!!READ_DOUBLEQUOTED_STRING_match!"

        IF "!%2!"=="" (
            EXIT /B 0
        )

        SET "READ_DOUBLEQUOTED_STRING_terminator=!%2:~0,1!"
        SET "%2=!%2:~1,8191!"

        :: If the last character was a back-slash, we continue reading the string.
        IF "!READ_DOUBLEQUOTED_STRING_terminator!"=="!_backslash!" (
            SET "READ_DOUBLEQUOTED_STRING_escape=!%2:~0,1!"
            SET "%2=!%2:~1,8191!"

            IF "!READ_DOUBLEQUOTED_STRING_escape!"=="n" (
                SET "%1=!%1!!_newline!"
                GOTO :READ_DOUBLEQUOTED_STRING_CONTINUE
            )

            IF "!READ_DOUBLEQUOTED_STRING_escape!"=="!_doublequote!" (
                SET "%1=!%1!!_doublequote!"
                GOTO :READ_DOUBLEQUOTED_STRING_CONTINUE
            )

            IF "!READ_DOUBLEQUOTED_STRING_escape!"=="!_backslash!" (
                SET "%1=!%1!!_backslash!"
                GOTO :READ_DOUBLEQUOTED_STRING_CONTINUE
            )

            GOTO :READ_DOUBLEQUOTED_STRING_CONTINUE
        ) ELSE (
            SET "%1=!%1!!_doublequote!"
        )
    )
EXIT /B 0

:NOT_END_OF_LINE
    SET "%1=!TRUE!"
    IF "!%2!"=="!_newline!" (SET "%1=!FALSE!" & EXIT /B 0)
EXIT /B 0

:SKIP_COMMENT
    :: If we encounter a comment, skip the rest of the line
    IF "!%1:~0,1!"==";" (
        CALL :READ_WHILE _ %1 :NOT_END_OF_LINE
    )
EXIT /B 0

:TOKENIZER
    :: We put the input string into a buffer for reading
    SET "TOKENIZER_buffer=!%2!"
    CALL :VECTOR_NEW TOKENIZER_list
    SET "TOKENIZER_@=~@"

:TOKENIZER_LOOP
    CALL :READ_WHILE TOKENIZER_token TOKENIZER_buffer :IS_COMMA_OR_SPACE
    IF NOT "!TOKENIZER_token!"=="" (
        :: Whitespace and commas are ignored
        GOTO :TOKENIZER_LOOP
    )

    CALL :READ_STRING TOKENIZER_token TOKENIZER_buffer TOKENIZER_@
    IF NOT "!TOKENIZER_token!"=="" (
        CALL :VECTOR_PUSH TOKENIZER_list TOKENIZER_token
        GOTO :TOKENIZER_LOOP
    )

    CALL :READ_CHARACTER TOKENIZER_token TOKENIZER_buffer :IS_SPECIAL_CHARACTER
    IF NOT "!TOKENIZER_token!"=="" (
        CALL :VECTOR_PUSH TOKENIZER_list TOKENIZER_token
        GOTO :TOKENIZER_LOOP
    )

    CALL :READ_DOUBLEQUOTED_STRING TOKENIZER_token TOKENIZER_buffer
    IF NOT "!TOKENIZER_token!"=="" (
        CALL :VECTOR_PUSH TOKENIZER_list TOKENIZER_token
        GOTO :TOKENIZER_LOOP
    )

    IF "!TOKENIZER_buffer:~0,1!"==";" (
        :: If we encounter a comment, skip the rest of the line
        CALL :READ_WHILE _ TOKENIZER_buffer :NOT_END_OF_LINE
        GOTO :TOKENIZER_LOOP
    )

    CALL :READ_WHILE TOKENIZER_token TOKENIZER_buffer :IS_ATOM_CHARACTER
    IF NOT "!TOKENIZER_token!"=="" (
        CALL :VECTOR_PUSH TOKENIZER_list TOKENIZER_token
        GOTO :TOKENIZER_LOOP
    )

    SET "%1=!TOKENIZER_list!"
EXIT /B 0

:READ_LIST
    SET /a "READ_LIST_recursion_count+=1"

    SET /a "%3+=1"
    SET "%1=!EMPTY_LIST!"
    CALL :VECTOR_LENGTH READ_LIST_length %2
:READ_LIST_LOOP
    IF !%3! GEQ !READ_LIST_length! (
        SET /a "READ_LIST_recursion_count-=1"
        CALL :ABORT "expected ')', got EOF"
    )

    CALL :VECTOR_GET READ_LIST_token %2 %3
    IF "!READ_LIST_token!"==")" (
        SET /a "%3+=1"
        CALL :LIST_REVERSE tmp %1
        SET "%1=!tmp!"
        SET /a "READ_LIST_recursion_count-=1"
        EXIT /B 0
    )

    CALL :READ_FORM form%READ_LIST_recursion_count% %2 %3
    CALL :CONS %1 form%READ_LIST_recursion_count% %1

    GOTO :READ_LIST_LOOP
EXIT /B 0

:READ_VECTOR
    SET /a "READ_VECTOR_recursion_count+=1"

    SET /a "%3+=1"
    CALL :VECTOR_NEW %1
    CALL :VECTOR_LENGTH READ_LIST_length %2
:READ_VECTOR_LOOP
    IF !%3! GEQ !READ_LIST_length! (
        SET /a "READ_VECTOR_recursion_count-=1"
        CALL :ABORT "expected ']', got EOF"
    )

    CALL :VECTOR_GET READ_LIST_token %2 %3
    IF "!READ_LIST_token!"=="]" (
        SET /a "%3+=1"
        SET /a "READ_VECTOR_recursion_count-=1"
        EXIT /B 0
    )

    CALL :READ_FORM form%READ_VECTOR_recursion_count% %2 %3
    CALL :VECTOR_PUSH %1 form%READ_VECTOR_recursion_count%

    GOTO :READ_VECTOR_LOOP
EXIT /B 0

:IS_NUMERIC
    SET "%1=!FALSE!"
    IF "!%2:~0,1!"=="1" (SET "%1=!TRUE!" & EXIT /B 0)
    IF "!%2:~0,1!"=="2" (SET "%1=!TRUE!" & EXIT /B 0)
    IF "!%2:~0,1!"=="3" (SET "%1=!TRUE!" & EXIT /B 0)
    IF "!%2:~0,1!"=="4" (SET "%1=!TRUE!" & EXIT /B 0)
    IF "!%2:~0,1!"=="5" (SET "%1=!TRUE!" & EXIT /B 0)
    IF "!%2:~0,1!"=="6" (SET "%1=!TRUE!" & EXIT /B 0)
    IF "!%2:~0,1!"=="7" (SET "%1=!TRUE!" & EXIT /B 0)
    IF "!%2:~0,1!"=="8" (SET "%1=!TRUE!" & EXIT /B 0)
    IF "!%2:~0,1!"=="9" (SET "%1=!TRUE!" & EXIT /B 0)
    IF "!%2:~0,1!"=="0" (SET "%1=!TRUE!" & EXIT /B 0)
    IF "!%2:~0,2!"=="-1" (SET "%1=!TRUE!" & EXIT /B 0)
    IF "!%2:~0,2!"=="-2" (SET "%1=!TRUE!" & EXIT /B 0)
    IF "!%2:~0,2!"=="-3" (SET "%1=!TRUE!" & EXIT /B 0)
    IF "!%2:~0,2!"=="-4" (SET "%1=!TRUE!" & EXIT /B 0)
    IF "!%2:~0,2!"=="-5" (SET "%1=!TRUE!" & EXIT /B 0)
    IF "!%2:~0,2!"=="-6" (SET "%1=!TRUE!" & EXIT /B 0)
    IF "!%2:~0,2!"=="-7" (SET "%1=!TRUE!" & EXIT /B 0)
    IF "!%2:~0,2!"=="-8" (SET "%1=!TRUE!" & EXIT /B 0)
    IF "!%2:~0,2!"=="-9" (SET "%1=!TRUE!" & EXIT /B 0)
    IF "!%2:~0,2!"=="-0" (SET "%1=!TRUE!" & EXIT /B 0)
EXIT /B 0

:READ_ATOM
    CALL :VECTOR_GET READ_ATOM_token %2 %3
    CALL :ATOM_NEW %1 READ_ATOM_token
    SET /a "%3+=1"
EXIT /B 0

:READ_NUMBER
    CALL :VECTOR_GET READ_ATOM_token %2 %3
    CALL :NUMBER_NEW %1 READ_ATOM_token
    SET /a "%3+=1"
EXIT /B 0

:READ_HASHMAP
    SET /a "READ_HASHMAP_recursion_count+=1"

    CALL :HASHMAP_NEW %1
    SET /a "%3+=1"

:READ_HASHMAP_LOOP
    CALL :VECTOR_GET READ_HASHMAP_key%READ_HASHMAP_recursion_count% %2 %3
    SET /a "%3+=1"
    IF "!READ_HASHMAP_key%READ_HASHMAP_recursion_count%!"=="}" (
        SET /a "READ_HASHMAP_recursion_count-=1"
        EXIT /B 0
    )

    CALL :READ_FORM READ_HASHMAP_value%READ_HASHMAP_recursion_count% %2 %3

    CALL :HASHMAP_INSERT %1 READ_HASHMAP_key%READ_HASHMAP_recursion_count% READ_HASHMAP_value%READ_HASHMAP_recursion_count%

    GOTO :READ_HASHMAP_LOOP
EXIT /B 0

:READ_PREFIX
    SET /a "READ_PREFIX_recursion_count+=1"

    SET /a "%3+=1"

    SET "%1=!EMPTY_LIST!"
    CALL :ATOM_NEW READ_PREFIX_atom%READ_PREFIX_recursion_count% %4
    CALL :READ_FORM READ_PREFIX_form%READ_PREFIX_recursion_count% %2 %3
    CALL :CONS %1 READ_PREFIX_form%READ_PREFIX_recursion_count% %1
    CALL :CONS %1 READ_PREFIX_atom%READ_PREFIX_recursion_count% %1

    SET /a "READ_PREFIX_recursion_count-=1"
EXIT /B 0

:READ_PREFIX2
    SET /a "READ_PREFIX2_recursion_count+=1"

    SET /a "%3+=1"

    SET "%1=!EMPTY_LIST!"
    CALL :ATOM_NEW READ_PREFIX_atom%READ_PREFIX2_recursion_count% %4
    CALL :READ_FORM READ_PREFIX_form%READ_PREFIX2_recursion_count% %2 %3
    CALL :READ_FORM READ_PREFIX_form2%READ_PREFIX2_recursion_count% %2 %3
    CALL :CONS %1 READ_PREFIX_form%READ_PREFIX2_recursion_count% %1
    CALL :CONS %1 READ_PREFIX_form2%READ_PREFIX2_recursion_count% %1
    CALL :CONS %1 READ_PREFIX_atom%READ_PREFIX2_recursion_count% %1

    SET /a "READ_PREFIX2_recursion_count-=1"
EXIT /B 0

:READ_FORM
:: To get around the limitation of no local variables,
:: we keep a recursion count to diffirentiate variables
:: for each recursion level.

:: This can be solved better in the future by making them tail-recursive
    SET /a "READ_FORM_recursion_count+=1"
    CALL :VECTOR_LENGTH READ_FORM_length %2
    IF !%3! GEQ !READ_FORM_length! (
        CALL :ABORT "Unexpected EOF"
    )

    :: These IF statements slow down the reader significantly, can we
    :: branch some other way to make it faster?
    CALL :VECTOR_GET READ_FORM_token %2 %3
    IF "!READ_FORM_token!"=="(" (
        CALL :READ_LIST READ_FORM_form%READ_FORM_recursion_count% %2 %3
        GOTO :READ_FORM_EXIT
    )

    IF "!READ_FORM_token!"=="{" (
        CALL :READ_HASHMAP READ_FORM_form%READ_FORM_recursion_count% %2 %3
        GOTO :READ_FORM_EXIT
    )

    IF "!READ_FORM_token!"=="[" (
        CALL :READ_VECTOR READ_FORM_form%READ_FORM_recursion_count% %2 %3
        GOTO :READ_FORM_EXIT
    )

    IF "!READ_FORM_token!"=="!_singlequote!" (
        SET "READ_FORM_quote=quote"
        CALL :READ_PREFIX READ_FORM_form%READ_FORM_recursion_count% %2 %3 READ_FORM_quote
        GOTO :READ_FORM_EXIT
    )

    IF "!READ_FORM_token!"=="!_backtick!" (
        SET "READ_FORM_quote=quasiquote"
        CALL :READ_PREFIX READ_FORM_form%READ_FORM_recursion_count% %2 %3 READ_FORM_quote
        GOTO :READ_FORM_EXIT
    )

    IF "!READ_FORM_token!"=="!_tilde!" (
        SET "READ_FORM_quote=unquote"
        CALL :READ_PREFIX READ_FORM_form%READ_FORM_recursion_count% %2 %3 READ_FORM_quote
        GOTO :READ_FORM_EXIT
    )

    IF "!READ_FORM_token!"=="!_splice_unquote!" (
        SET "READ_FORM_quote=splice-unquote"
        CALL :READ_PREFIX READ_FORM_form%READ_FORM_recursion_count% %2 %3 READ_FORM_quote
        GOTO :READ_FORM_EXIT
    )

    IF "!READ_FORM_token!"=="@" (
        SET "READ_FORM_quote=deref"
        CALL :READ_PREFIX READ_FORM_form%READ_FORM_recursion_count% %2 %3 READ_FORM_quote
        GOTO :READ_FORM_EXIT
    )

    IF "!READ_FORM_token!"=="!_with_meta!" (
        SET "READ_FORM_quote=with-meta"
        CALL :READ_PREFIX2 READ_FORM_form%READ_FORM_recursion_count% %2 %3 READ_FORM_quote
        GOTO :READ_FORM_EXIT
    )

    CALL :IS_NUMERIC READ_FORM_is_numeric READ_FORM_token
    IF "!READ_FORM_is_numeric!"=="!TRUE!" (
        CALL :READ_NUMBER READ_FORM_form%READ_FORM_recursion_count% %2 %3
        GOTO :READ_FORM_EXIT
    )

    IF "!READ_FORM_token:~0,1!"=="!_doublequote!" (
        SET "READ_FORM_string_str=!READ_FORM_token:~1,-1!"
        CALL :STRING_NEW READ_FORM_form%READ_FORM_recursion_count% READ_FORM_string_str
        SET /a "%3+=1"
        GOTO :READ_FORM_EXIT
    )

    IF "!READ_FORM_token!"=="nil" (
        SET "READ_FORM_form%READ_FORM_recursion_count%=!NIL!"
        SET /a "%3+=1"
        GOTO :READ_FORM_EXIT
    )

    IF "!READ_FORM_token!"=="true" (
        SET "READ_FORM_form%READ_FORM_recursion_count%=!TRUE!"
        SET /a "%3+=1"
        GOTO :READ_FORM_EXIT
    )

    IF "!READ_FORM_token!"=="false" (
        SET "READ_FORM_form%READ_FORM_recursion_count%=!FALSE!"
        SET /a "%3+=1"
        GOTO :READ_FORM_EXIT
    )

    CALL :READ_ATOM READ_FORM_form%READ_FORM_recursion_count% %2 %3

:READ_FORM_EXIT
    SET "%1=!READ_FORM_form%READ_FORM_recursion_count%!"
    SET /a "READ_FORM_recursion_count-=1"
EXIT /B 0

:READ_STR
    CALL :TOKENIZER READ_STR_tokens %2
    SET "READ_STR_index=0"
    CALL :READ_FORM %1 READ_STR_tokens READ_STR_index
EXIT /B 0
