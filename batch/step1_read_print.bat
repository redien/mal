:: The following file is generated by build.bat. DO NOT EDIT. 
@echo off
SETLOCAL ENABLEEXTENSIONS ENABLEDELAYEDEXPANSION

:: While macros
SET BREAK=EXIT
SET WHILE=IF "%1"=="fi301kvnro2qa9vm2" (FOR /L %%? IN () DO IF
SET DO=(
SET END_WHILE=) ELSE %BREAK%) ELSE CMD /Q /C "%~F0" fi301kvnro2qa9vm2

:: Magic number that says we're calling a loop
IF "%1"=="fi301kvnro2qa9vm2" GOTO %2

SET "NIL="
SET "TRUE=t"
SET "FALSE=f"

SET _doublequote=^"
SET _backslash=^\
SET _singlequote=^'
SET _backtick=^`
SET _tilde=^~
SET _splice_unquote=^~^@
SET _with_meta=^^

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
        SET "%~1=!TRUE!"
    ) ELSE (
        SET "%~1=!FALSE!"
    )
EXIT /B 0

:CONS
    SET /a "_list_counter+=1"
    SET "_list_first_!_list_counter!=!%~2!"
    SET "_list_rest_!_list_counter!=!%~3!"
    SET "%~1=L!_list_counter!"
EXIT /B 0

:FIRST
    SET "ref=_list_first_!%~2:~1,8191!"
    SET "%1=!%ref%!"
EXIT /B 0

:REST
    SET "ref=_list_rest_!%~2:~1,8191!"
    SET "%1=!%ref%!"
EXIT /B 0

:LIST?
    IF "!%2!"=="!NIL!" (
        SET "%~1=!TRUE!"
    ) ELSE (
        IF "!%~2:~0,1!"=="L" (
            SET "%~1=!TRUE!"
        ) ELSE (
            SET "%~1=!FALSE!"
        )
    )
EXIT /B 0

:LIST_REVERSE
    SET "%1=!NIL!"
    CALL :_LIST_REVERSE %1 %2
EXIT /B 0

:_LIST_REVERSE
    IF "!%2!"=="!NIL!" (
        EXIT /B 0
    )

    CALL :FIRST LIST_REVERSE_first %2
    CALL :REST LIST_REVERSE_rest %2

    CALL :CONS %1 LIST_REVERSE_first %1

    CALL :_LIST_REVERSE %1 LIST_REVERSE_rest
EXIT /B 0

:LIST_MAP
    SET "LIST_MAP_list%_recursion_count%=!NIL!"
    CALL :_LIST_MAP LIST_MAP_list%_recursion_count% %2 %3 %4
    CALL :LIST_REVERSE %1 LIST_MAP_list%_recursion_count%
EXIT /B 0

:_LIST_MAP
    IF "!%2!"=="!NIL!" (
        EXIT /B 0
    )

    CALL :FIRST LIST_MAP_first%_recursion_count% %2
    CALL :REST LIST_MAP_rest%_recursion_count% %2

    CALL %3 LIST_MAP_mapped%_recursion_count% LIST_MAP_first%_recursion_count% %4

    CALL :CONS %1 LIST_MAP_mapped%_recursion_count% %1

    CALL :_LIST_MAP %1 LIST_MAP_rest%_recursion_count% %3 %4
EXIT /B 0


:VECTOR_NEW
    SET /a "_vector_counter+=1"
    SET "_vector_length_!_vector_counter!=0"
    SET "%1=V!_vector_counter!"
EXIT /B 0

:VECTOR_LENGTH
    SET "_length=_vector_length_!%2:~1,8191!"
    SET "%1=!%_length%!"
EXIT /B 0

:VECTOR_GET
    SET "_ref=_vector_!%2:~1,8191!_!%3!"
    SET "%1=!%_ref%!"
EXIT /B 0

:VECTOR_PUSH
    SET "_id=!%1:~1,8191!"
    SET "_length=_vector_length_!_id!"
    SET "_ref=_vector_!_id!_!%_length%!"
    SET "%_ref%=!%2!"
    SET /a "%_length%+=1"
EXIT /B 0

:VECTOR?
    IF "!%2:~0,1!"=="V" (
        SET "%1=!TRUE!"
    ) ELSE (
        SET "%1=!FALSE!"
    )
EXIT /B 0

:STRING_NEW
    SET /a "_string_counter+=1"
    SET "_length=_string_length_!_string_counter!"
    CALL :STRLEN %_length% %2
    SET "_string_contents_!_string_counter!=!%2!"
    SET "%1=S!_string_counter!"
EXIT /B 0

:STRING_LENGTH
    SET "_length=_string_length_!%2:~1,8191!"
    SET "%1=!%_length%!"
EXIT /B 0

:STRING_TO_STR
    SET "_ref=_string_contents_!%2:~1,8191!"
    SET "%1=!%_ref%!"
EXIT /B 0

:STRING?
    IF "!%2:~0,1!"=="S" (
        SET "%1=!TRUE!"
    ) ELSE (
        SET "%1=!FALSE!"
    )
EXIT /B 0

:ATOM_NEW
    SET /a "_atom_counter+=1"
    SET "_length=_atom_length_!_atom_counter!"
    CALL :STRLEN %_length% %2
    SET "_atom_contents_!_atom_counter!=!%2!"
    SET "%1=A!_atom_counter!"
EXIT /B 0

:ATOM_LENGTH
    SET "_length=_atom_length_!%2:~1,8191!"
    SET "%1=!%_length%!"
EXIT /B 0

:ATOM_TO_STR
    SET "_ref=_atom_contents_!%2:~1,8191!"
    SET "%1=!%_ref%!"
EXIT /B 0

:ATOM?
    IF "!%2:~0,1!"=="A" (
        SET "%1=!TRUE!"
    ) ELSE (
        SET "%1=!FALSE!"
    )
EXIT /B 0

:FUNCTION_NEW
    SET /a "_function_counter+=1"
    SET "_function_name_!_function_counter!=!%2!"
    SET "%1=F!_function_counter!"
EXIT /B 0

:FUNCTION_TO_STR
    SET "_ref=_function_name_!%2:~1,8191!"
    SET "%1=!%_ref%!"
EXIT /B 0

:FUNCTION?
    IF "!%2:~0,1!"=="F" (
        SET "%1=!TRUE!"
    ) ELSE (
        SET "%1=!FALSE!"
    )
EXIT /B 0

:NUMBER_NEW
    SET /a "_number_counter+=1"
    SET "_number_value!_number_counter!=!%2!"
    SET "%1=N!_number_counter!"
EXIT /B 0

:NUMBER_TO_STR
    SET "_ref=_number_value!%2:~1,8191!"
    SET "%1=!%_ref%!"
EXIT /B 0

:NUMBER_TO_STRING
    SET "NUMBER_TO_STRING_str=_number_value!%2:~1,8191!"
    CALL :STRING_NEW %1 NUMBER_TO_STRING_str
EXIT /B 0

:NUMBER?
    IF "!%2:~0,1!"=="N" (
        SET "%1=!TRUE!"
    ) ELSE (
        SET "%1=!FALSE!"
    )
EXIT /B 0


:HASHMAP_NEW
    SET /a "_hashmap_counter+=1"
    CALL :VECTOR_NEW _hashmap_keys!_hashmap_counter!
    CALL :VECTOR_NEW _hashmap_values!_hashmap_counter!
    SET "%1=H!_hashmap_counter!"
EXIT /B 0

:HASHMAP_INSERT
    SET "HASHMAP_INSERT_id=!%1:~1,8191!"
    CALL :VECTOR_PUSH _hashmap_keys!HASHMAP_INSERT_id! %2
    CALL :VECTOR_PUSH _hashmap_values!HASHMAP_INSERT_id! %3
EXIT /B 0

:_HASHMAP_INDEX_OF_KEY
    SET "_HASHMAP_INDEX_OF_KEY_id=!%2:~1,8191!"
    SET "%1=!NIL!"
    CALL :VECTOR_LENGTH _HASHMAP_INDEX_OF_KEY_length _hashmap_keys!_HASHMAP_INDEX_OF_KEY_id!
    SET /a "_HASHMAP_INDEX_OF_KEY_length-=1"
    FOR /L %%G IN (0, 1, !_HASHMAP_INDEX_OF_KEY_length!) DO (
        SET "_HASHMAP_INDEX_OF_KEY_index=%%G"
        CALL :VECTOR_GET _HASHMAP_INDEX_OF_KEY_key _hashmap_keys!_HASHMAP_INDEX_OF_KEY_id! _HASHMAP_INDEX_OF_KEY_index
        IF "!_HASHMAP_INDEX_OF_KEY_key!"=="!%3!" (
            SET "%1=%%G"
        )
    )
EXIT /B 0

:HASHMAP_GET
    SET "HASHMAP_GET_id=!%2:~1,8191!"
    CALL :_HASHMAP_INDEX_OF_KEY HASHMAP_GET_key_index %2 %3
    IF "!HASHMAP_GET_key_index!"=="!NIL!" (
        SET "%1=!NIL!"
        EXIT /B 0
    )

    CALL :VECTOR_GET %1 _hashmap_values!HASHMAP_GET_id! HASHMAP_GET_key_index
EXIT /B 0

:HASHMAP_KEYS
    SET "_id=!%2:~1,8191!"
    SET "_ref=_hashmap_keys!_id!"
    SET "%1=!%_ref%!"
EXIT /B 0

:HASHMAP?
    IF "!%2:~0,1!"=="H" (
        SET "%1=!TRUE!"
    ) ELSE (
        SET "%1=!FALSE!"
    )
EXIT /B 0

:SUBSTRING
    SET "SUBSTRING_start=!%~3!"
    SET "SUBSTRING_length=!%~4!"
    CALL :_SUBSTRING %~1 %~2 %SUBSTRING_start% %SUBSTRING_length%
EXIT /B 0

:_SUBSTRING
    SET /a "_SUBSTRING_end=%~3+%~4-1"
    SET "%~1=!%~2:~%~3,%_SUBSTRING_end%!"
EXIT /B 0

:STRING_CONTAINS_CHAR
    SET "STRING_CONTAINS_CHAR_string=!%~2!"
    SET "STRING_CONTAINS_CHAR_char=!%~3!"

:STRING_CONTAINS_CHAR_LOOP
    IF "!STRING_CONTAINS_CHAR_string!"=="" (
        SET "%~1=!FALSE!"
    )

    IF "!STRING_CONTAINS_CHAR_string:~0,1!"=="!STRING_CONTAINS_CHAR_char!" (
        SET "%~1=!TRUE!"
    ) ELSE (
        SET "STRING_CONTAINS_CHAR_string=!STRING_CONTAINS_CHAR_string:~1,8191!"
        GOTO :STRING_CONTAINS_CHAR_LOOP
    )
EXIT /B 0

:STRLEN
    SET "STRLEN_buffer=#!%2!"
    SET "STRLEN_length=0"
    FOR %%N IN (8192 4096 2048 1024 512 256 128 64 32 16 8 4 2 1) DO (
        IF NOT "!STRLEN_buffer:~%%N,1!"=="" (
            SET /a "STRLEN_length+=%%N"
            SET "STRLEN_buffer=!STRLEN_buffer:~%%N!"
        )
    )
    SET "%1=%STRLEN_length%"
EXIT /B 0

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
:READ_DOUBLEQUOTED_STRING_CONTINUE
        IF "!%2!"=="" (
            EXIT /B 0
        )

        SET "%1=!%1!!%2:~0,1!"
        SET "%2=!%2:~1,8191!"

        CALL :READ_WHILE READ_DOUBLEQUOTED_STRING_match %2 :IS_NOT_DOUBLEQUOTE_OR_BACKSLASH
        SET "%1=!%1!!READ_DOUBLEQUOTED_STRING_match!"

        IF "!%2!"=="" (
            EXIT /B 0
        )

        SET "READ_DOUBLEQUOTED_STRING_terminator=!%2:~0,1!"
        SET "%2=!%2:~1,8191!"
        SET "%1=!%1!!READ_DOUBLEQUOTED_STRING_terminator!"

        :: If the last character was a back-slash, we continue reading the string.
        IF "!READ_DOUBLEQUOTED_STRING_terminator!"=="!_backslash!" (
            GOTO :READ_DOUBLEQUOTED_STRING_CONTINUE
        )
    )
EXIT /B 0

:SKIP_COMMENT
    :: If we encounter a comment, skip the rest by emptying the buffer
    IF "!%1:~0,1!"==";" (
        SET "%1="
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

    CALL :SKIP_COMMENT TOKENIZER_buffer

    CALL :READ_WHILE TOKENIZER_token TOKENIZER_buffer :IS_ATOM_CHARACTER
    IF NOT "!TOKENIZER_token!"=="" (
        CALL :VECTOR_PUSH TOKENIZER_list TOKENIZER_token
        GOTO :TOKENIZER_LOOP
    )

    SET "%1=!TOKENIZER_list!"
EXIT /B 0

:READ_LIST
    SET /a "%3+=1"
    SET "%1=!NIL!"
    CALL :VECTOR_LENGTH READ_LIST_length %2
:READ_LIST_LOOP
    IF !%3! GEQ !READ_LIST_length! (
        CALL :ABORT "expected ')', got EOF"
    )

    CALL :VECTOR_GET READ_LIST_token %2 %3
    IF "!READ_LIST_token!"==")" (
        SET /a "%3+=1"
        CALL :LIST_REVERSE tmp %1
        SET "%1=!tmp!"
        EXIT /B 0
    )

    CALL :READ_FORM form%_recursion_count% %2 %3
    CALL :CONS %1 form%_recursion_count% %1

    GOTO :READ_LIST_LOOP
EXIT /B 0

:READ_VECTOR
    SET /a "%3+=1"
    CALL :VECTOR_NEW %1
    CALL :VECTOR_LENGTH READ_LIST_length %2
:READ_VECTOR_LOOP
    IF !%3! GEQ !READ_LIST_length! (
        CALL :ABORT "expected ']', got EOF"
    )

    CALL :VECTOR_GET READ_LIST_token %2 %3
    IF "!READ_LIST_token!"=="]" (
        SET /a "%3+=1"
        EXIT /B 0
    )

    CALL :READ_FORM form%_recursion_count% %2 %3
    CALL :VECTOR_PUSH %1 form%_recursion_count%

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
    CALL :HASHMAP_NEW %1
    SET /a "%3+=1"

:READ_HASHMAP_LOOP
    CALL :VECTOR_GET READ_HASHMAP_key%_recursion_count% %2 %3
    SET /a "%3+=1"
    IF "!READ_HASHMAP_key%_recursion_count%!"=="}" (
        EXIT /B 0
    )

    CALL :READ_FORM READ_HASHMAP_value%_recursion_count% %2 %3

    CALL :HASHMAP_INSERT %1 READ_HASHMAP_key%_recursion_count% READ_HASHMAP_value%_recursion_count%

    GOTO :READ_HASHMAP_LOOP
EXIT /B 0

:READ_PREFIX
    SET /a "%3+=1"

    SET "%1=!NIL!"
    CALL :ATOM_NEW READ_PREFIX_atom%_recursion_count% %4
    CALL :READ_FORM READ_PREFIX_form%_recursion_count% %2 %3
    CALL :CONS %1 READ_PREFIX_form%_recursion_count% %1
    CALL :CONS %1 READ_PREFIX_atom%_recursion_count% %1
EXIT /B 0

:READ_PREFIX2
    SET /a "%3+=1"

    SET "%1=!NIL!"
    CALL :ATOM_NEW READ_PREFIX_atom%_recursion_count% %4
    CALL :READ_FORM READ_PREFIX_form%_recursion_count% %2 %3
    CALL :READ_FORM READ_PREFIX_form2%_recursion_count% %2 %3
    CALL :CONS %1 READ_PREFIX_form%_recursion_count% %1
    CALL :CONS %1 READ_PREFIX_form2%_recursion_count% %1
    CALL :CONS %1 READ_PREFIX_atom%_recursion_count% %1
EXIT /B 0

:READ_FORM
:: To get around the limitation of no local variables,
:: we keep a recursion count to diffirentiate variables
:: for each recursion level.

:: This can be solved better in the future by making them tail-recursive
    SET /a "_recursion_count+=1"
    CALL :VECTOR_LENGTH READ_FORM_length %2
    IF !%3! GEQ !READ_FORM_length! (
        CALL :ABORT "Unexpected EOF"
    )

    :: These IF statements slow down the reader significantly, can we
    :: branch some other way to make it faster?
    CALL :VECTOR_GET READ_FORM_token %2 %3
    IF "!READ_FORM_token!"=="(" (
        CALL :READ_LIST READ_FORM_form%_recursion_count% %2 %3
        GOTO :READ_FORM_EXIT
    )

    IF "!READ_FORM_token!"=="{" (
        CALL :READ_HASHMAP READ_FORM_form%_recursion_count% %2 %3
        GOTO :READ_FORM_EXIT
    )

    IF "!READ_FORM_token!"=="[" (
        CALL :READ_VECTOR READ_FORM_form%_recursion_count% %2 %3
        GOTO :READ_FORM_EXIT
    )

    IF "!READ_FORM_token!"=="!_singlequote!" (
        SET "READ_FORM_quote=quote"
        CALL :READ_PREFIX READ_FORM_form%_recursion_count% %2 %3 READ_FORM_quote
        GOTO :READ_FORM_EXIT
    )

    IF "!READ_FORM_token!"=="!_backtick!" (
        SET "READ_FORM_quote=quasiquote"
        CALL :READ_PREFIX READ_FORM_form%_recursion_count% %2 %3 READ_FORM_quote
        GOTO :READ_FORM_EXIT
    )

    IF "!READ_FORM_token!"=="!_tilde!" (
        SET "READ_FORM_quote=unquote"
        CALL :READ_PREFIX READ_FORM_form%_recursion_count% %2 %3 READ_FORM_quote
        GOTO :READ_FORM_EXIT
    )

    IF "!READ_FORM_token!"=="!_splice_unquote!" (
        SET "READ_FORM_quote=splice-unquote"
        CALL :READ_PREFIX READ_FORM_form%_recursion_count% %2 %3 READ_FORM_quote
        GOTO :READ_FORM_EXIT
    )

    IF "!READ_FORM_token!"=="@" (
        SET "READ_FORM_quote=deref"
        CALL :READ_PREFIX READ_FORM_form%_recursion_count% %2 %3 READ_FORM_quote
        GOTO :READ_FORM_EXIT
    )

    IF "!READ_FORM_token!"=="!_with_meta!" (
        SET "READ_FORM_quote=with-meta"
        CALL :READ_PREFIX2 READ_FORM_form%_recursion_count% %2 %3 READ_FORM_quote
        GOTO :READ_FORM_EXIT
    )

    CALL :IS_NUMERIC READ_FORM_is_numeric READ_FORM_token
    IF "!READ_FORM_is_numeric!"=="!TRUE!" (
        CALL :READ_NUMBER READ_FORM_form%_recursion_count% %2 %3
        GOTO :READ_FORM_EXIT
    )

    CALL :READ_ATOM READ_FORM_form%_recursion_count% %2 %3

:READ_FORM_EXIT
    SET "%1=!READ_FORM_form%_recursion_count%!"
    SET /a "_recursion_count-=1"
EXIT /B 0

:READ_STR
    CALL :TOKENIZER READ_STR_tokens %2
    SET "_recursion_count=0"
    SET "READ_STR_index=0"
    CALL :READ_FORM %1 READ_STR_tokens READ_STR_index
EXIT /B 0

:PR_STR
:: To get around the limitation of no local variables,
:: we keep a recursion count to diffirentiate variables
:: for each recursion level.

:: This can be solved better in the future by making them tail-recursive
    SET "_recursion_count=0"
    CALL :_PR_STR %1 %2
EXIT /B 0

:_PR_STR
    SET /a "_recursion_count+=1"

    CALL :ATOM? PR_STR_is_atom %2
    IF "!PR_STR_is_atom!"=="!TRUE!" (
        CALL :ATOM_TO_STR PR_STR_tmp %2
        SET "%1=!PR_STR_tmp!"
        SET /a "_recursion_count-=1"
        EXIT /B 0
    )

    CALL :NUMBER? PR_STR_is_number %2
    IF "!PR_STR_is_number!"=="!TRUE!" (
        CALL :NUMBER_TO_STR PR_STR_tmp %2
        SET "%1=!PR_STR_tmp!"
        SET /a "_recursion_count-=1"
        EXIT /B 0
    )

    CALL :FUNCTION? PR_STR_is_function %2
    IF "!PR_STR_is_function!"=="!TRUE!" (
        SET "%1=#<function>"
        SET /a "_recursion_count-=1"
        EXIT /B 0
    )

    CALL :LIST? PR_STR_is_list %2
    IF "!PR_STR_is_list!"=="!TRUE!" (
        SET "%1=("
        SET "_PR_STR_tail%_recursion_count%=!%2!"
:_PR_STR_LIST_LOOP
        CALL :NIL? _PR_STR_is_nil _PR_STR_tail%_recursion_count%
        IF "!_PR_STR_is_nil!"=="!FALSE!" (
            CALL :FIRST _PR_STR_form _PR_STR_tail%_recursion_count%
            CALL :REST _PR_STR_tail%_recursion_count% _PR_STR_tail%_recursion_count%

            CALL :_PR_STR PR_STR_str%_recursion_count% _PR_STR_form

            SET "%1=!%1!!PR_STR_str%_recursion_count%!"
            CALL :NIL? _PR_STR_is_nil _PR_STR_tail%_recursion_count%
            IF "!_PR_STR_is_nil!"=="!FALSE!" (
                SET "%1=!%1! "
            )
            GOTO :_PR_STR_LIST_LOOP
        )

        SET "%1=!%1!)"
        SET /a "_recursion_count-=1"
        EXIT /B 0
    )

    CALL :VECTOR? PR_STR_is_vector %2
    IF "!PR_STR_is_vector!"=="!TRUE!" (
        CALL :VECTOR_LENGTH PR_STR_length %2
        SET /a "PR_STR_length-=1"
        SET "%1=["
        FOR /L %%G IN (0, 1, !PR_STR_length!) DO (
            SET "PR_STR_index=%%G"
            CALL :VECTOR_GET PR_STR_item%_recursion_count% %2 PR_STR_index
            CALL :_PR_STR PR_STR_str%_recursion_count% PR_STR_item%_recursion_count%
            IF %%G NEQ 0 (
                SET "%1=!%1! "
            )
            SET "%1=!%1!!PR_STR_str%_recursion_count%!"
        )
        SET "%1=!%1!]"

        SET /a "_recursion_count-=1"
        EXIT /B 0
    )

    CALL :HASHMAP? PR_STR_is_hashmap %2
    IF "!PR_STR_is_hashmap!"=="!TRUE!" (
        CALL :HASHMAP_KEYS PR_STR_keys%_recursion_count% %2
        CALL :VECTOR_LENGTH PR_STR_length PR_STR_keys%_recursion_count%
        SET /a "PR_STR_length-=1"
        SET "%1={"
        FOR /L %%G IN (0, 1, !PR_STR_length!) DO (
            SET "PR_STR_index=%%G"
            CALL :VECTOR_GET PR_STR_key%_recursion_count% PR_STR_keys%_recursion_count% PR_STR_index
            CALL :HASHMAP_GET PR_STR_value%_recursion_count% %2 PR_STR_key%_recursion_count%
            CALL :_PR_STR PR_STR_str%_recursion_count% PR_STR_value%_recursion_count%
            IF %%G NEQ 0 (
                SET "%1=!%1! "
            )
            SET "%1=!%1!!PR_STR_key%_recursion_count%! !PR_STR_str%_recursion_count%!"
        )
        SET "%1=!%1!}"

        SET /a "_recursion_count-=1"
        EXIT /B 0
    )

    echo !%2!
    CALL :ABORT "Unexpected type !%2:~0,1!"
EXIT /B 0

:ENV_NEW
    SET /a "_env_counter+=1"
    SET "_env_outer!_env_counter!=!NIL!"
    CALL :HASHMAP_NEW _env_data!_env_counter!
    SET "%1=E!_env_counter!"
EXIT /B 0

:ENV_SET_OUTER
    SET "ENV_SET_id=!%1:~1,8191!"
    SET "_env_outer!ENV_SET_id!=!%2!"
EXIT /B 0

:ENV_SET
    SET "ENV_SET_id=!%1:~1,8191!"
    CALL :ATOM_TO_STR ENV_SET_key %2
    CALL :HASHMAP_INSERT _env_data!ENV_SET_id! ENV_SET_key %3
EXIT /B 0

:ENV_GET
    SET "ENV_GET_id=!%2:~1,8191!"
    CALL :ATOM_TO_STR ENV_GET_key %3
    CALL :HASHMAP_GET %1 _env_data!ENV_GET_id! ENV_GET_key
    IF "!%1!"=="!NIL!" (
        IF NOT "!_env_outer%ENV_GET_id%!"=="!NIL!" (
            CALL :ENV_GET %1 _env_outer%ENV_GET_id% %3
        )
    )
EXIT /B 0

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
