
:PR_STR
:: To get around the limitation of no local variables,
:: we keep a recursion count to diffirentiate variables
:: for each recursion level.

:: This can be solved better in the future by making them tail-recursive
    SET "PR_STR_recursion_count=0"
    CALL :_PR_STR %1 %2 %3
EXIT /B 0

:_PR_STR
    SET /a "PR_STR_recursion_count+=1"

    CALL :ERROR? PR_STR_is_error %2
    IF "!PR_STR_is_error!"=="!TRUE!" (
        CALL :ERROR_TO_STR %1 %2
        SET "%1=Error: !%1!"
        SET /a "PR_STR_recursion_count-=1"
        EXIT /B 0
    )

    CALL :ATOM? PR_STR_is_atom %2
    IF "!PR_STR_is_atom!"=="!TRUE!" (
        CALL :SYMBOL_TO_STR %1 %2
        SET /a "PR_STR_recursion_count-=1"
        EXIT /B 0
    )

    CALL :NUMBER? PR_STR_is_number %2
    IF "!PR_STR_is_number!"=="!TRUE!" (
        CALL :NUMBER_TO_STR %1 %2
        SET /a "PR_STR_recursion_count-=1"
        EXIT /B 0
    )

    CALL :STRING? PR_STR_is_string %2
    IF "!PR_STR_is_string!"=="!TRUE!" (
        CALL :STRING_TO_STR PR_STR_string %2
        IF "!%3!"=="!TRUE!" (
            CALL :STRING_REPLACE_CHAR PR_STR_string PR_STR_string _backslash _backslash_escape
            CALL :STRING_REPLACE_CHAR PR_STR_string PR_STR_string _newline _newline_escape
            CALL :STRING_REPLACE_CHAR PR_STR_string PR_STR_string _doublequote _doublequote_escape
            SET "%1=!_doublequote!!PR_STR_string!!_doublequote!"
        ) ELSE (
            SET "%1=!PR_STR_string!"
        )
        SET /a "PR_STR_recursion_count-=1"
        EXIT /B 0
    )

    CALL :FUNCTION? PR_STR_is_function %2
    IF "!PR_STR_is_function!"=="!TRUE!" (
        SET "%1=#<function>"
        SET /a "PR_STR_recursion_count-=1"
        EXIT /B 0
    )

    IF "!%2!"=="!NIL!" (
        SET "%1=nil"
        SET /a "PR_STR_recursion_count-=1"
        EXIT /B 0
    )

    IF "!%2!"=="!EMPTY_LIST!" (
        SET "%1=()"
        SET /a "PR_STR_recursion_count-=1"
        EXIT /B 0
    )

    IF "!%2!"=="!TRUE!" (
        SET "%1=true"
        SET /a "PR_STR_recursion_count-=1"
        EXIT /B 0
    )

    IF "!%2!"=="!FALSE!" (
        SET "%1=false"
        SET /a "PR_STR_recursion_count-=1"
        EXIT /B 0
    )

    CALL :LIST? PR_STR_is_list %2
    IF "!PR_STR_is_list!"=="!TRUE!" (
        SET "%1=("
        SET "_PR_STR_tail%PR_STR_recursion_count%=!%2!"
:_PR_STR_LIST_LOOP
        CALL :LIST_EMPTY? _PR_STR_is_empty _PR_STR_tail%PR_STR_recursion_count%
        IF "!_PR_STR_is_empty!"=="!FALSE!" (
            CALL :FIRST _PR_STR_form _PR_STR_tail%PR_STR_recursion_count%
            CALL :REST _PR_STR_tail%PR_STR_recursion_count% _PR_STR_tail%PR_STR_recursion_count%

            CALL :_PR_STR PR_STR_str%PR_STR_recursion_count% _PR_STR_form %3

            SET "%1=!%1!!PR_STR_str%PR_STR_recursion_count%!"
            CALL :LIST_EMPTY? _PR_STR_is_empty _PR_STR_tail%PR_STR_recursion_count%
            IF "!_PR_STR_is_empty!"=="!FALSE!" (
                SET "%1=!%1! "
            )
            GOTO :_PR_STR_LIST_LOOP
        )

        SET "%1=!%1!)"
        SET /a "PR_STR_recursion_count-=1"
        EXIT /B 0
    )

    CALL :VECTOR? PR_STR_is_vector %2
    IF "!PR_STR_is_vector!"=="!TRUE!" (
        CALL :VECTOR_LENGTH PR_STR_length %2
        SET /a "PR_STR_length-=1"
        SET "%1=["
        FOR /L %%G IN (0, 1, !PR_STR_length!) DO (
            SET "PR_STR_index=%%G"
            CALL :VECTOR_GET PR_STR_item%PR_STR_recursion_count% %2 PR_STR_index
            CALL :_PR_STR PR_STR_str%PR_STR_recursion_count% PR_STR_item%PR_STR_recursion_count% %3
            IF %%G NEQ 0 (
                SET "%1=!%1! "
            )
            SET "%1=!%1!!PR_STR_str%PR_STR_recursion_count%!"
        )
        SET "%1=!%1!]"

        SET /a "PR_STR_recursion_count-=1"
        EXIT /B 0
    )

    CALL :HASHMAP? PR_STR_is_hashmap %2
    IF "!PR_STR_is_hashmap!"=="!TRUE!" (
        CALL :HASHMAP_KEYS PR_STR_keys%PR_STR_recursion_count% %2
        CALL :VECTOR_LENGTH PR_STR_length PR_STR_keys%PR_STR_recursion_count%
        SET /a "PR_STR_length-=1"
        SET "%1={"
        FOR /L %%G IN (0, 1, !PR_STR_length!) DO (
            SET "PR_STR_index=%%G"
            CALL :VECTOR_GET PR_STR_key%PR_STR_recursion_count% PR_STR_keys%PR_STR_recursion_count% PR_STR_index
            CALL :HASHMAP_GET PR_STR_value%PR_STR_recursion_count% %2 PR_STR_key%PR_STR_recursion_count%
            CALL :_PR_STR PR_STR_str%PR_STR_recursion_count% PR_STR_value%PR_STR_recursion_count% %3
            IF %%G NEQ 0 (
                SET "%1=!%1! "
            )
            SET "%1=!%1!!PR_STR_key%PR_STR_recursion_count%! !PR_STR_str%PR_STR_recursion_count%!"
        )
        SET "%1=!%1!}"

        SET /a "PR_STR_recursion_count-=1"
        EXIT /B 0
    )

    echo !%2!
    CALL :ABORT "Unexpected type !%2:~0,1!"
EXIT /B 0
