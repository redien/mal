
:CALL_STACK_PUSH
    SET /a "_call_stack_size+=1"
    SET "_call_stack_value!_call_stack_size!=!%1!"
EXIT /B 0

:CALL_STACK_POP
    SET "CALL_STACK_POP_ref=_call_stack_value!_call_stack_size!"
    SET "%1=!%CALL_STACK_POP_ref%!"
    SET /a "_call_stack_size-=1"
EXIT /B 0

:MAL_NUMBER_ADD
    CALL :CALL_STACK_POP MAL_NUMBER_ADD_first
    CALL :CALL_STACK_POP MAL_NUMBER_ADD_second
    CALL :NUMBER_TO_STR MAL_NUMBER_ADD_first_str MAL_NUMBER_ADD_first
    CALL :NUMBER_TO_STR MAL_NUMBER_ADD_second_str MAL_NUMBER_ADD_second
    SET /a "MAL_NUMBER_ADD_value_str=!MAL_NUMBER_ADD_first_str!+!MAL_NUMBER_ADD_second_str!"
    CALL :NUMBER_NEW MAL_NUMBER_ADD_value MAL_NUMBER_ADD_value_str
    CALL :CALL_STACK_PUSH MAL_NUMBER_ADD_value
EXIT /B 0

:MAL_NUMBER_SUBTRACT
    CALL :CALL_STACK_POP MAL_NUMBER_SUBTRACT_first
    CALL :CALL_STACK_POP MAL_NUMBER_SUBTRACT_second
    CALL :NUMBER_TO_STR MAL_NUMBER_SUBTRACT_first_str MAL_NUMBER_SUBTRACT_first
    CALL :NUMBER_TO_STR MAL_NUMBER_SUBTRACT_second_str MAL_NUMBER_SUBTRACT_second
    SET /a "MAL_NUMBER_SUBTRACT_value_str=!MAL_NUMBER_SUBTRACT_first_str!-!MAL_NUMBER_SUBTRACT_second_str!"
    CALL :NUMBER_NEW MAL_NUMBER_SUBTRACT_value MAL_NUMBER_SUBTRACT_value_str
    CALL :CALL_STACK_PUSH MAL_NUMBER_SUBTRACT_value
EXIT /B 0

:MAL_NUMBER_MULTIPLY
    CALL :CALL_STACK_POP MAL_NUMBER_MULTIPLY_first
    CALL :CALL_STACK_POP MAL_NUMBER_MULTIPLY_second
    CALL :NUMBER_TO_STR MAL_NUMBER_MULTIPLY_first_str MAL_NUMBER_MULTIPLY_first
    CALL :NUMBER_TO_STR MAL_NUMBER_MULTIPLY_second_str MAL_NUMBER_MULTIPLY_second
    SET /a "MAL_NUMBER_MULTIPLY_value_str=!MAL_NUMBER_MULTIPLY_first_str!*!MAL_NUMBER_MULTIPLY_second_str!"
    CALL :NUMBER_NEW MAL_NUMBER_MULTIPLY_value MAL_NUMBER_MULTIPLY_value_str
    CALL :CALL_STACK_PUSH MAL_NUMBER_MULTIPLY_value
EXIT /B 0

:MAL_NUMBER_DIVIDE
    CALL :CALL_STACK_POP MAL_NUMBER_DIVIDE_first
    CALL :CALL_STACK_POP MAL_NUMBER_DIVIDE_second
    CALL :NUMBER_TO_STR MAL_NUMBER_DIVIDE_first_str MAL_NUMBER_DIVIDE_first
    CALL :NUMBER_TO_STR MAL_NUMBER_DIVIDE_second_str MAL_NUMBER_DIVIDE_second
    SET /a "MAL_NUMBER_DIVIDE_value_str=!MAL_NUMBER_DIVIDE_first_str!/!MAL_NUMBER_DIVIDE_second_str!"
    CALL :NUMBER_NEW MAL_NUMBER_DIVIDE_value MAL_NUMBER_DIVIDE_value_str
    CALL :CALL_STACK_PUSH MAL_NUMBER_DIVIDE_value
EXIT /B 0

:DEFINE_FUN
    CALL :FUNCTION_NEW DEFINE_FUN_value %3 NIL NIL NIL
    set "DEFINE_FUN_key_str=%2"
    CALL :SYMBOL_NEW DEFINE_FUN_key DEFINE_FUN_key_str
    CALL :ENV_SET %1 DEFINE_FUN_key DEFINE_FUN_value
EXIT /B 0

:START

CALL :ENV_NEW REPL_env
CALL :DEFINE_FUN REPL_env + :MAL_NUMBER_ADD
CALL :DEFINE_FUN REPL_env - :MAL_NUMBER_SUBTRACT
CALL :DEFINE_FUN REPL_env * :MAL_NUMBER_MULTIPLY
CALL :DEFINE_FUN REPL_env / :MAL_NUMBER_DIVIDE

:REPL
    SET "_input="
    :: prompt the user and assign the user's input to _input.
    SET /p "_input=user> "
    :: If nothing is written, empty the input and reSET the error level
    IF  errorlevel 1 SET "_input=" & verify>nul
    :: Exit command used for testing purposes
    IF "!_input!"=="exit" EXIT

    CALL :REP _result _input REPL_env

    CALL :ECHO _result
GOTO :REPL

:REP
    CALL :READ REP_read %2
    CALL :EVAL REP_evaled REP_read %3
    CALL :PRINT %1 REP_evaled
EXIT /B 0

:READ
    CALL :READ_STR %1 %2
EXIT /B 0

:PRINT
    CALL :PR_STR %1 %2 TRUE
EXIT /B 0

:EVAL_AST
    SET /a "EVAL_AST_recursion_count+=1"

    CALL :LIST? EVAL_AST_is_list %2
    IF "!EVAL_AST_is_list!"=="!TRUE!" (
        CALL :LIST_MAP %1 %2 :EVAL %3
        SET /a "EVAL_AST_recursion_count-=1"
        EXIT /B 0
    )

    CALL :VECTOR? EVAL_AST_is_vector %2
    IF "!EVAL_AST_is_vector!"=="!TRUE!" (
        CALL :VECTOR_LENGTH EVAL_AST_vector_length %2
        SET /a "EVAL_AST_vector_length-=1"
        CALL :VECTOR_NEW EVAL_AST_new_vector%EVAL_AST_recursion_count%
        FOR /L %%G IN (0, 1, !EVAL_AST_vector_length!) DO (
            SET "EVAL_AST_index=%%G"
            CALL :VECTOR_GET EVAL_AST_form%EVAL_AST_recursion_count% %2 EVAL_AST_index
            CALL :EVAL EVAL_AST_evaluated%EVAL_AST_recursion_count% EVAL_AST_form%EVAL_AST_recursion_count% %3
            CALL :VECTOR_PUSH EVAL_AST_new_vector%EVAL_AST_recursion_count% EVAL_AST_evaluated%EVAL_AST_recursion_count%
        )
        SET "%1=!EVAL_AST_new_vector%EVAL_AST_recursion_count%!"
        SET /a "EVAL_AST_recursion_count-=1"
        EXIT /B 0
    )

    CALL :HASHMAP? EVAL_AST_is_hashmap %2
    IF "!EVAL_AST_is_hashmap!"=="!TRUE!" (
        CALL :HASHMAP_KEYS EVAL_AST_keys%EVAL_AST_recursion_count% %2
        CALL :VECTOR_LENGTH EVAL_AST_keys_length EVAL_AST_keys%EVAL_AST_recursion_count%
        SET /a "EVAL_AST_keys_length-=1"
        CALL :HASHMAP_NEW EVAL_AST_new_hashmap%EVAL_AST_recursion_count%
        FOR /L %%G IN (0, 1, !EVAL_AST_keys_length!) DO (
            SET "EVAL_AST_index=%%G"
            CALL :VECTOR_GET EVAL_AST_key%EVAL_AST_recursion_count% EVAL_AST_keys%EVAL_AST_recursion_count% EVAL_AST_index
            CALL :HASHMAP_GET EVAL_AST_value%EVAL_AST_recursion_count% %2 EVAL_AST_key%EVAL_AST_recursion_count%
            CALL :EVAL EVAL_AST_evaluated%EVAL_AST_recursion_count% EVAL_AST_value%EVAL_AST_recursion_count% %3
            CALL :HASHMAP_INSERT EVAL_AST_new_hashmap%EVAL_AST_recursion_count% EVAL_AST_key%EVAL_AST_recursion_count% EVAL_AST_evaluated%EVAL_AST_recursion_count%
        )
        SET "%1=!EVAL_AST_new_hashmap%EVAL_AST_recursion_count%!"
        SET /a "EVAL_AST_recursion_count-=1"
        EXIT /B 0
    )

    CALL :SYMBOL? EVAL_AST_is_symbol %2
    IF "!EVAL_AST_is_symbol!"=="!TRUE!" (
        CALL :ENV_GET %1 %3 %2
        IF "!%1!"=="!NIL!" (
            CALL :SYMBOL_TO_STR EVAL_AST_symbol_str %2
            set "EVAL_AST_error=Not defined: !EVAL_AST_symbol_str!"
            CALL :ABORT "!EVAL_AST_error!"
        )
        SET /a "EVAL_AST_recursion_count-=1"
        EXIT /B 0
    )

    SET "%1=!%2!"
    SET /a "EVAL_AST_recursion_count-=1"
EXIT /B 0

:EVAL_DEF_LIST
    SET /a "EVAL_DEF_LIST_recursion_count+=1"
    set "EVAL_DEF_LIST_list%EVAL_DEF_LIST_recursion_count%=!%2!"
:_EVAL_DEF_LIST
    CALL :LIST_FIRST EVAL_DEF_LIST_key%EVAL_DEF_LIST_recursion_count% EVAL_DEF_LIST_list%EVAL_DEF_LIST_recursion_count%
    CALL :LIST_REST EVAL_DEF_LIST_list%EVAL_DEF_LIST_recursion_count% EVAL_DEF_LIST_list%EVAL_DEF_LIST_recursion_count%

    CALL :LIST_FIRST EVAL_DEF_LIST_value%EVAL_DEF_LIST_recursion_count% EVAL_DEF_LIST_list%EVAL_DEF_LIST_recursion_count%
    CALL :LIST_REST EVAL_DEF_LIST_list%EVAL_DEF_LIST_recursion_count% EVAL_DEF_LIST_list%EVAL_DEF_LIST_recursion_count%

    CALL :EVAL EVAL_DEF_LIST_evaluated_value%EVAL_DEF_LIST_recursion_count% EVAL_DEF_LIST_value%EVAL_DEF_LIST_recursion_count% %1

    CALL :ENV_SET %1 EVAL_DEF_LIST_key%EVAL_DEF_LIST_recursion_count% EVAL_DEF_LIST_evaluated_value%EVAL_DEF_LIST_recursion_count%

    IF NOT "!EVAL_DEF_LIST_list%EVAL_DEF_LIST_recursion_count%!"=="!EMPTY_LIST!" (
        GOTO :_EVAL_DEF_LIST
    )
    SET /a "EVAL_DEF_LIST_recursion_count-=1"
EXIT /B 0

:EVAL
    SET /a "EVAL_recursion_count+=1"

    CALL :LIST? EVAL_is_list %2
    IF "!EVAL_is_list!"=="!TRUE!" (
        IF "!%2!"=="!EMPTY_LIST!" (
            SET "%1=!%2!"
            SET /a "EVAL_recursion_count-=1"
            EXIT /B 0
        )

        CALL :LIST_FIRST EVAL_first_form %2
        CALL :LIST_REST EVAL_rest%EVAL_recursion_count% %2
        CALL :SYMBOL? EVAL_is_symbol EVAL_first_form
        IF "!EVAL_is_symbol!"=="!TRUE!" (
            CALL :SYMBOL_TO_STR EVAL_first_symbol_str EVAL_first_form
            IF "!EVAL_first_symbol_str!"=="def^!" (
                CALL :LIST_FIRST EVAL_key%EVAL_recursion_count% EVAL_rest%EVAL_recursion_count%
                CALL :LIST_REST EVAL_rest%EVAL_recursion_count% EVAL_rest%EVAL_recursion_count%
                CALL :LIST_FIRST EVAL_value%EVAL_recursion_count% EVAL_rest%EVAL_recursion_count%
                CALL :EVAL EVAL_evaluated_value%EVAL_recursion_count% EVAL_value%EVAL_recursion_count% %3
                CALL :ENV_SET %3 EVAL_key%EVAL_recursion_count% EVAL_evaluated_value%EVAL_recursion_count%
                set "%1=!EVAL_evaluated_value%EVAL_recursion_count%!"
                SET /a "EVAL_recursion_count-=1"
                EXIT /B 0
            )

            IF "!EVAL_first_symbol_str!"=="let*" (
                CALL :ENV_NEW EVAL_env%EVAL_recursion_count%
                CALL :ENV_SET_OUTER EVAL_env%EVAL_recursion_count% %3

                CALL :LIST_FIRST EVAL_def_list%EVAL_recursion_count% EVAL_rest%EVAL_recursion_count%

                CALL :VECTOR? EVAL_is_vector EVAL_def_list%EVAL_recursion_count%
                IF "!EVAL_is_vector!"=="!TRUE!" (
                    CALL :VECTOR_TO_LIST EVAL_def_list%EVAL_recursion_count% EVAL_def_list%EVAL_recursion_count%
                )

                CALL :EVAL_DEF_LIST EVAL_env%EVAL_recursion_count% EVAL_def_list%EVAL_recursion_count%

                CALL :LIST_REST EVAL_rest%EVAL_recursion_count% EVAL_rest%EVAL_recursion_count%
                CALL :LIST_FIRST EVAL_value%EVAL_recursion_count% EVAL_rest%EVAL_recursion_count%

                CALL :EVAL EVAL_evaluated_value%EVAL_recursion_count% EVAL_value%EVAL_recursion_count% EVAL_env%EVAL_recursion_count%

                set "%1=!EVAL_evaluated_value%EVAL_recursion_count%!"
                SET /a "EVAL_recursion_count-=1"
                EXIT /B 0
            )
        )

        CALL :EVAL_AST EVAL_list%EVAL_recursion_count% %2 %3

        CALL :LIST_FIRST EVAL_function%EVAL_recursion_count% EVAL_list%EVAL_recursion_count%
        CALL :FUNCTION_TO_STR EVAL_function_str%EVAL_recursion_count% EVAL_function%EVAL_recursion_count%

        CALL :LIST_REST EVAL_list%EVAL_recursion_count% EVAL_list%EVAL_recursion_count%
        CALL :LIST_FIRST EVAL_a%EVAL_recursion_count% EVAL_list%EVAL_recursion_count%

        CALL :LIST_REST EVAL_list%EVAL_recursion_count% EVAL_list%EVAL_recursion_count%
        CALL :LIST_FIRST EVAL_b%EVAL_recursion_count% EVAL_list%EVAL_recursion_count%

        CALL :CALL_STACK_PUSH EVAL_b%EVAL_recursion_count%
        CALL :CALL_STACK_PUSH EVAL_a%EVAL_recursion_count%

        CALL !EVAL_function_str%EVAL_recursion_count%!
        CALL :CALL_STACK_POP %1

        SET /a "EVAL_recursion_count-=1"
        EXIT /B 0
    )

    CALL :EVAL_AST %1 %2 %3

    SET /a "EVAL_recursion_count-=1"
EXIT /B 0
