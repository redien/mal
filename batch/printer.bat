
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

    IF "!%2!"=="!NIL!" (
        SET "%1=nil"
        SET /a "_recursion_count-=1"
        EXIT /B 0
    )

    IF "!%2!"=="!TRUE!" (
        SET "%1=true"
        SET /a "_recursion_count-=1"
        EXIT /B 0
    )

    IF "!%2!"=="!FALSE!" (
        SET "%1=false"
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
