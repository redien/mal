:: The following file is generated by build.bat. DO NOT EDIT. 
@echo off
SETLOCAL ENABLEEXTENSIONS ENABLEDELAYEDEXPANSION

:: While macros
set BREAK=EXIT
set WHILE=IF "%1"=="fi301kvnro2qa9vm2" (FOR /L %%? IN () DO IF
set DO=(
set END_WHILE=) ELSE %BREAK%) ELSE CMD /Q /C "%~F0" fi301kvnro2qa9vm2

:: Magic number that says we're calling a loop
IF "%1"=="fi301kvnro2qa9vm2" GOTO %2

set "NIL="
set "TRUE=t"
set "FALSE=f"

set _doublequote=^"
set _backslash=^\
set _singlequote=^'
set _backtick=^`
set _tilde=^~
set _splice_unquote=^~^@
set _with_meta=^^

GOTO :START

:ECHO
    IF NOT "!%1!"=="" echo !%1!
EXIT /B 0

:ABORT
    ECHO %~1
    GOTO :START
EXIT

:NIL?
    IF "!%~2!"=="" (
        set "%~1=!TRUE!"
    ) ELSE (
        set "%~1=!FALSE!"
    )
EXIT /B 0

:CONS
    set /a "_list_counter+=1"
    set "_list_first_!_list_counter!=!%~2!"
    set "_list_rest_!_list_counter!=!%~3!"
    set "%~1=L!_list_counter!"
EXIT /B 0

:FIRST
    set "ref=_list_first_!%~2:~1,8191!"
    set "%1=!%ref%!"
EXIT /B 0

:REST
    set "ref=_list_rest_!%~2:~1,8191!"
    set "%1=!%ref%!"
EXIT /B 0

:LIST?
    IF "!%2!"=="!NIL!" (
        set "%~1=!TRUE!"
    ) ELSE (
        IF "!%~2:~0,1!"=="L" (
            set "%~1=!TRUE!"
        ) ELSE (
            set "%~1=!FALSE!"
        )
    )
EXIT /B 0

:LIST_REVERSE
    set "%1=!NIL!"
    call :_LIST_REVERSE %1 %2
EXIT /B 0

:_LIST_REVERSE
    IF "!%2!"=="!NIL!" (
        EXIT /B 0
    )

    call :FIRST LIST_REVERSE_first %2
    call :REST LIST_REVERSE_rest %2

    call :CONS %1 LIST_REVERSE_first %1

    call :_LIST_REVERSE %1 LIST_REVERSE_rest
EXIT /B 0


:VECTOR_NEW
    set /a "_vector_counter+=1"
    set "_vector_length_!_vector_counter!=0"
    set "%1=V!_vector_counter!"
EXIT /B 0

:VECTOR_LENGTH
    set "_length=_vector_length_!%2:~1,8191!"
    set "%1=!%_length%!"
EXIT /B 0

:VECTOR_GET
    set "_ref=_vector_!%2:~1,8191!_!%3!"
    set "%1=!%_ref%!"
EXIT /B 0

:VECTOR_PUSH
    set "_id=!%1:~1,8191!"
    set "_length=_vector_length_!_id!"
    set "_ref=_vector_!_id!_!%_length%!"
    set "%_ref%=!%2!"
    set /a "%_length%+=1"
EXIT /B 0

:VECTOR?
    IF "!%2:~0,1!"=="V" (
        set "%1=!TRUE!"
    ) ELSE (
        set "%1=!FALSE!"
    )
EXIT /B 0

:STRING_NEW
    set /a "_string_counter+=1"
    set "_length=_string_length_!_string_counter!"
    call :STRLEN %_length% %2
    set "_string_contents_!_string_counter!=!%2!"
    set "%1=S!_string_counter!"
EXIT /B 0

:STRING_LENGTH
    set "_length=_string_length_!%2:~1,8191!"
    set "%1=!%_length%!"
EXIT /B 0

:STRING_TO_STR
    set "_ref=_string_contents_!%2:~1,8191!"
    set "%1=!%_ref%!"
EXIT /B 0

:STRING?
    IF "!%2:~0,1!"=="S" (
        set "%1=!TRUE!"
    ) ELSE (
        set "%1=!FALSE!"
    )
EXIT /B 0

:ATOM_NEW
    set /a "_atom_counter+=1"
    set "_length=_atom_length_!_atom_counter!"
    call :STRLEN %_length% %2
    set "_atom_contents_!_atom_counter!=!%2!"
    set "%1=A!_atom_counter!"
EXIT /B 0

:ATOM_LENGTH
    set "_length=_atom_length_!%2:~1,8191!"
    set "%1=!%_length%!"
EXIT /B 0

:ATOM_TO_STR
    set "_ref=_atom_contents_!%2:~1,8191!"
    set "%1=!%_ref%!"
EXIT /B 0

:ATOM?
    IF "!%2:~0,1!"=="A" (
        set "%1=!TRUE!"
    ) ELSE (
        set "%1=!FALSE!"
    )
EXIT /B 0

:NUMBER_NEW
    set /a "_number_counter+=1"
    set "_number_value!_number_counter!=!%2!"
    set "%1=N!_number_counter!"
EXIT /B 0

:NUMBER_TO_STR
    set "_ref=_number_value!%2:~1,8191!"
    set "%1=!%_ref%!"
EXIT /B 0

:NUMBER_TO_STRING
    set "NUMBER_TO_STRING_str=_number_value!%2:~1,8191!"
    call :STRING_NEW %1 NUMBER_TO_STRING_str
EXIT /B 0

:NUMBER?
    IF "!%2:~0,1!"=="N" (
        set "%1=!TRUE!"
    ) ELSE (
        set "%1=!FALSE!"
    )
EXIT /B 0


:HASHMAP_NEW
    set /a "_hashmap_counter+=1"
    call :VECTOR_NEW _hashmap_keys!_hashmap_counter!
    call :VECTOR_NEW _hashmap_values!_hashmap_counter!
    set "%1=H!_hashmap_counter!"
EXIT /B 0

:HASHMAP_INSERT
    set "HASHMAP_INSERT_id=!%1:~1,8191!"
    call :VECTOR_PUSH _hashmap_keys!HASHMAP_INSERT_id! %2
    call :VECTOR_PUSH _hashmap_values!HASHMAP_INSERT_id! %3
EXIT /B 0

:_HASHMAP_INDEX_OF_KEY
    set "_HASHMAP_INDEX_OF_KEY_id=!%2:~1,8191!"
    set "%1=!NIL!"
    call :VECTOR_LENGTH _HASHMAP_INDEX_OF_KEY_length _hashmap_keys!_HASHMAP_INDEX_OF_KEY_id!
    set /a "_HASHMAP_INDEX_OF_KEY_length-=1"
    FOR /L %%G IN (0, 1, !_HASHMAP_INDEX_OF_KEY_length!) DO (
        set "_HASHMAP_INDEX_OF_KEY_index=%%G"
        call :VECTOR_GET _HASHMAP_INDEX_OF_KEY_key _hashmap_keys!_HASHMAP_INDEX_OF_KEY_id! _HASHMAP_INDEX_OF_KEY_index
        IF "!_HASHMAP_INDEX_OF_KEY_key!"=="!%3!" (
            set "%1=%%G"
        )
    )
EXIT /B 0

:HASHMAP_GET
    set "HASHMAP_GET_id=!%2:~1,8191!"
    call :_HASHMAP_INDEX_OF_KEY HASHMAP_GET_key_index %2 %3
    IF "!HASHMAP_GET_key_index!"=="!NIL!" (
        set "%1=!NIL!"
        EXIT /B 0
    )

    call :VECTOR_GET %1 _hashmap_values!HASHMAP_GET_id! HASHMAP_GET_key_index
EXIT /B 0

:HASHMAP_KEYS
    set "_id=!%2:~1,8191!"
    set "_ref=_hashmap_keys!_id!"
    set "%1=!%_ref%!"
EXIT /B 0

:HASHMAP?
    IF "!%2:~0,1!"=="H" (
        set "%1=!TRUE!"
    ) ELSE (
        set "%1=!FALSE!"
    )
EXIT /B 0

:SUBSTRING
    set "SUBSTRING_start=!%~3!"
    set "SUBSTRING_length=!%~4!"
    call :_SUBSTRING %~1 %~2 %SUBSTRING_start% %SUBSTRING_length%
EXIT /B 0

:_SUBSTRING
    set /a "_SUBSTRING_end=%~3+%~4-1"
    set "%~1=!%~2:~%~3,%_SUBSTRING_end%!"
EXIT /B 0

:STRING_CONTAINS_CHAR
    set "STRING_CONTAINS_CHAR_string=!%~2!"
    set "STRING_CONTAINS_CHAR_char=!%~3!"

:STRING_CONTAINS_CHAR_LOOP
    IF "!STRING_CONTAINS_CHAR_string!"=="" (
        set "%~1=!FALSE!"
    )

    IF "!STRING_CONTAINS_CHAR_string:~0,1!"=="!STRING_CONTAINS_CHAR_char!" (
        set "%~1=!TRUE!"
    ) ELSE (
        set "STRING_CONTAINS_CHAR_string=!STRING_CONTAINS_CHAR_string:~1,8191!"
        GOTO :STRING_CONTAINS_CHAR_LOOP
    )
EXIT /B 0

:STRLEN
    set "STRLEN_buffer=#!%2!"
    set "STRLEN_length=0"
    FOR %%N IN (8192 4096 2048 1024 512 256 128 64 32 16 8 4 2 1) DO (
        IF NOT "!STRLEN_buffer:~%%N,1!"=="" (
            set /a "STRLEN_length+=%%N"
            set "STRLEN_buffer=!STRLEN_buffer:~%%N!"
        )
    )
    set "%1=%STRLEN_length%"
EXIT /B 0

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

:READ_HASHMAP
    call :HASHMAP_NEW %1
    set /a "%3+=1"

:READ_HASHMAP_LOOP
    call :VECTOR_GET READ_HASHMAP_key%_recursive_count% %2 %3
    set /a "%3+=1"
    IF "!READ_HASHMAP_key%_recursive_count%!"=="}" (
        EXIT /B 0
    )

    call :READ_FORM READ_HASHMAP_value%_recursive_count% %2 %3

    call :HASHMAP_INSERT %1 READ_HASHMAP_key%_recursive_count% READ_HASHMAP_value%_recursive_count%

    GOTO :READ_HASHMAP_LOOP
EXIT /B 0

:READ_PREFIX
    set /a "%3+=1"

    set "%1=!NIL!"
    call :ATOM_NEW READ_PREFIX_atom%_recursive_count% %4
    call :READ_FORM READ_PREFIX_form%_recursive_count% %2 %3
    call :CONS %1 READ_PREFIX_form%_recursive_count% %1
    call :CONS %1 READ_PREFIX_atom%_recursive_count% %1
EXIT /B 0

:READ_PREFIX2
    set /a "%3+=1"

    set "%1=!NIL!"
    call :ATOM_NEW READ_PREFIX_atom%_recursive_count% %4
    call :READ_FORM READ_PREFIX_form%_recursive_count% %2 %3
    call :READ_FORM READ_PREFIX_form2%_recursive_count% %2 %3
    call :CONS %1 READ_PREFIX_form%_recursive_count% %1
    call :CONS %1 READ_PREFIX_form2%_recursive_count% %1
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
        GOTO :READ_FORM_EXIT
    )

    IF "!READ_FORM_token!"=="{" (
        call :READ_HASHMAP READ_FORM_form%_recursive_count% %2 %3
        GOTO :READ_FORM_EXIT
    )

    IF "!READ_FORM_token!"=="[" (
        call :READ_VECTOR READ_FORM_form%_recursive_count% %2 %3
        GOTO :READ_FORM_EXIT
    )

    IF "!READ_FORM_token!"=="!_singlequote!" (
        set "READ_FORM_quote=quote"
        call :READ_PREFIX READ_FORM_form%_recursive_count% %2 %3 READ_FORM_quote
        GOTO :READ_FORM_EXIT
    )

    IF "!READ_FORM_token!"=="!_backtick!" (
        set "READ_FORM_quote=quasiquote"
        call :READ_PREFIX READ_FORM_form%_recursive_count% %2 %3 READ_FORM_quote
        GOTO :READ_FORM_EXIT
    )

    IF "!READ_FORM_token!"=="!_tilde!" (
        set "READ_FORM_quote=unquote"
        call :READ_PREFIX READ_FORM_form%_recursive_count% %2 %3 READ_FORM_quote
        GOTO :READ_FORM_EXIT
    )

    IF "!READ_FORM_token!"=="!_splice_unquote!" (
        set "READ_FORM_quote=splice-unquote"
        call :READ_PREFIX READ_FORM_form%_recursive_count% %2 %3 READ_FORM_quote
        GOTO :READ_FORM_EXIT
    )

    IF "!READ_FORM_token!"=="@" (
        set "READ_FORM_quote=deref"
        call :READ_PREFIX READ_FORM_form%_recursive_count% %2 %3 READ_FORM_quote
        GOTO :READ_FORM_EXIT
    )

    IF "!READ_FORM_token!"=="!_with_meta!" (
        set "READ_FORM_quote=with-meta"
        call :READ_PREFIX2 READ_FORM_form%_recursive_count% %2 %3 READ_FORM_quote
        GOTO :READ_FORM_EXIT
    )

    call :READ_ATOM READ_FORM_form%_recursive_count% %2 %3

:READ_FORM_EXIT
    set "%1=!READ_FORM_form%_recursive_count%!"
    set /a "_recursive_count-=1"
EXIT /B 0

:READ_STR
    call :TOKENIZER READ_STR_tokens %2
    set "_recursive_count=0"
    set "READ_STR_index=0"
    call :READ_FORM %1 READ_STR_tokens READ_STR_index
EXIT /B 0

:PR_STR
:: To get around the limitation of no local variables,
:: we keep a recursion count to diffirentiate variables
:: for each recursion level.

:: This can be solved better in the future by making them tail-recursive
    set "_recursive_count=0"
    call :_PR_STR %1 %2
EXIT /B 0

:_PR_STR
    set /a "_recursive_count+=1"

    call :ATOM? PR_STR_is_atom %2
    IF "!PR_STR_is_atom!"=="!TRUE!" (
        call :ATOM_TO_STR PR_STR_tmp %2
        set "%1=!PR_STR_tmp!"
        set /a "_recursive_count-=1"
        EXIT /B 0
    )

    call :LIST? PR_STR_is_list %2
    IF "!PR_STR_is_list!"=="!TRUE!" (
        set "%1=("
        set "_PR_STR_tail%_recursive_count%=!%2!"
:_PR_STR_LIST_LOOP
        call :NIL? _PR_STR_is_nil _PR_STR_tail%_recursive_count%
        IF "!_PR_STR_is_nil!"=="!FALSE!" (
            call :FIRST _PR_STR_form _PR_STR_tail%_recursive_count%
            call :REST _PR_STR_tail%_recursive_count% _PR_STR_tail%_recursive_count%

            call :_PR_STR PR_STR_str%_recursive_count% _PR_STR_form

            set "%1=!%1!!PR_STR_str%_recursive_count%!"
            call :NIL? _PR_STR_is_nil _PR_STR_tail%_recursive_count%
            IF "!_PR_STR_is_nil!"=="!FALSE!" (
                set "%1=!%1! "
            )
            GOTO :_PR_STR_LIST_LOOP
        )

        set "%1=!%1!)"
        set /a "_recursive_count-=1"
        EXIT /B 0
    )

    call :VECTOR? PR_STR_is_vector %2
    IF "!PR_STR_is_vector!"=="!TRUE!" (
        call :VECTOR_LENGTH PR_STR_length %2
        set /a "PR_STR_length-=1"
        set "%1=["
        FOR /L %%G IN (0, 1, !PR_STR_length!) DO (
            set "PR_STR_index=%%G"
            call :VECTOR_GET PR_STR_item%_recursive_count% %2 PR_STR_index
            call :_PR_STR PR_STR_str%_recursive_count% PR_STR_item%_recursive_count%
            IF %%G NEQ 0 (
                set "%1=!%1! "
            )
            set "%1=!%1!!PR_STR_str%_recursive_count%!"
        )
        set "%1=!%1!]"

        set /a "_recursive_count-=1"
        EXIT /B 0
    )

    call :HASHMAP? PR_STR_is_hashmap %2
    IF "!PR_STR_is_hashmap!"=="!TRUE!" (
        call :HASHMAP_KEYS PR_STR_keys%_recursive_count% %2
        call :VECTOR_LENGTH PR_STR_length PR_STR_keys%_recursive_count%
        set /a "PR_STR_length-=1"
        set "%1={"
        FOR /L %%G IN (0, 1, !PR_STR_length!) DO (
            set "PR_STR_index=%%G"
            call :VECTOR_GET PR_STR_key%_recursive_count% PR_STR_keys%_recursive_count% PR_STR_index
            call :HASHMAP_GET PR_STR_value%_recursive_count% %2 PR_STR_key%_recursive_count%
            call :_PR_STR PR_STR_str%_recursive_count% PR_STR_value%_recursive_count%
            IF %%G NEQ 0 (
                set "%1=!%1! "
            )
            set "%1=!%1!!PR_STR_key%_recursive_count%! !PR_STR_str%_recursive_count%!"
        )
        set "%1=!%1!}"

        set /a "_recursive_count-=1"
        EXIT /B 0
    )

    call :ABORT "Unexpected type !%2:~0,1!"
EXIT /B 0

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
