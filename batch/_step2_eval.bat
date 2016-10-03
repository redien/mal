
:CALL_STACK_PUSH
    set /a "_call_stack_size+=1"
    set "_call_stack_value!_call_stack_size!=!%1!"
EXIT /B 0

:CALL_STACK_POP
    set "CALL_STACK_POP_ref=_call_stack_value!_call_stack_size!"
    set "%1=!%CALL_STACK_POP_ref%!"
    set /a "_call_stack_size-=1"
EXIT /B 0

:NUMBER_ADD
    CALL :CALL_STACK_POP NUMBER_ADD_first
    CALL :CALL_STACK_POP NUMBER_ADD_second
    CALL :NUMBER_TO_STR NUMBER_ADD_first_str NUMBER_ADD_first
    CALL :NUMBER_TO_STR NUMBER_ADD_second_str NUMBER_ADD_second
    set /a "NUMBER_ADD_value_str=!NUMBER_ADD_first_str!+!NUMBER_ADD_second_str!"
    CALL :NUMBER_NEW NUMBER_ADD_value NUMBER_ADD_value_str
    CALL :CALL_STACK_PUSH NUMBER_ADD_value
EXIT /B 0

:NUMBER_SUBTRACT
    CALL :CALL_STACK_POP NUMBER_SUBTRACT_first
    CALL :CALL_STACK_POP NUMBER_SUBTRACT_second
    CALL :NUMBER_TO_STR NUMBER_SUBTRACT_first_str NUMBER_SUBTRACT_first
    CALL :NUMBER_TO_STR NUMBER_SUBTRACT_second_str NUMBER_SUBTRACT_second
    set /a "NUMBER_SUBTRACT_value_str=!NUMBER_SUBTRACT_first_str!-!NUMBER_SUBTRACT_second_str!"
    CALL :NUMBER_NEW NUMBER_SUBTRACT_value NUMBER_SUBTRACT_value_str
    CALL :CALL_STACK_PUSH NUMBER_SUBTRACT_value
EXIT /B 0

:NUMBER_MULTIPLY
    CALL :CALL_STACK_POP NUMBER_MULTIPLY_first
    CALL :CALL_STACK_POP NUMBER_MULTIPLY_second
    CALL :NUMBER_TO_STR NUMBER_MULTIPLY_first_str NUMBER_MULTIPLY_first
    CALL :NUMBER_TO_STR NUMBER_MULTIPLY_second_str NUMBER_MULTIPLY_second
    set /a "NUMBER_MULTIPLY_value_str=!NUMBER_MULTIPLY_first_str!*!NUMBER_MULTIPLY_second_str!"
    CALL :NUMBER_NEW NUMBER_MULTIPLY_value NUMBER_MULTIPLY_value_str
    CALL :CALL_STACK_PUSH NUMBER_MULTIPLY_value
EXIT /B 0

:NUMBER_DIVIDE
    CALL :CALL_STACK_POP NUMBER_DIVIDE_first
    CALL :CALL_STACK_POP NUMBER_DIVIDE_second
    CALL :NUMBER_TO_STR NUMBER_DIVIDE_first_str NUMBER_DIVIDE_first
    CALL :NUMBER_TO_STR NUMBER_DIVIDE_second_str NUMBER_DIVIDE_second
    set /a "NUMBER_DIVIDE_value_str=!NUMBER_DIVIDE_first_str!/!NUMBER_DIVIDE_second_str!"
    CALL :NUMBER_NEW NUMBER_DIVIDE_value NUMBER_DIVIDE_value_str
    CALL :CALL_STACK_PUSH NUMBER_DIVIDE_value
EXIT /B 0

:DEFINE_FUN
    set "DEFINE_FUN_key=%2"
    CALL :FUNCTION_NEW DEFINE_FUN_value %3
    CALL :HASHMAP_INSERT %1 DEFINE_FUN_key DEFINE_FUN_value
EXIT /B 0

:START

CALL :HASHMAP_NEW REPL_env
CALL :DEFINE_FUN REPL_env + :NUMBER_ADD
CALL :DEFINE_FUN REPL_env - :NUMBER_SUBTRACT
CALL :DEFINE_FUN REPL_env * :NUMBER_MULTIPLY
CALL :DEFINE_FUN REPL_env / :NUMBER_DIVIDE

:REPL
    set "_input="
    call :READ REPL_form
    set "REPL_result=!NIL!"
    call :EVAL REPL_result REPL_form REPL_env
    call :PRINT REPL_result
GOTO :REPL

:READ
    :: prompt the user and assign the user's input to _input.
    set /p "_input=user> "
    :: If nothing is written, empty the input and reset the error level
    if errorlevel 1 set "_input=" & verify>nul

    IF "!_input!"=="exit" EXIT :: Exit command used for testing purposes

    call :READ_STR %1 _input
EXIT /B 0

:PRINT
    call :PR_STR PRINT_output %1
    call :ECHO PRINT_output
EXIT /B 0

:EVAL_AST
    CALL :LIST? EVAL_AST_is_list %2
    IF "!EVAL_AST_is_list!"=="!TRUE!" (
        CALL :LIST_MAP %1 %2 :EVAL %3
        EXIT /B 0
    )

    CALL :VECTOR? EVAL_AST_is_vector %2
    IF "!EVAL_AST_is_vector!"=="!TRUE!" (
        CALL :VECTOR_LENGTH EVAL_AST_vector_length %2
        set /a "EVAL_AST_vector_length-=1"
        CALL :VECTOR_NEW EVAL_AST_new_vector%_recursive_count%
        FOR /L %%G IN (0, 1, !EVAL_AST_vector_length!) DO (
            set "EVAL_AST_index=%%G"
            CALL :VECTOR_GET EVAL_AST_form%_recursive_count% %2 EVAL_AST_index
            CALL :EVAL EVAL_AST_evaluated%_recursive_count% EVAL_AST_form%_recursive_count% %3
            CALL :VECTOR_PUSH EVAL_AST_new_vector%_recursive_count% EVAL_AST_evaluated%_recursive_count%
        )
        set "%1=!EVAL_AST_new_vector%_recursive_count%!"
        EXIT /B 0
    )

    CALL :HASHMAP? EVAL_AST_is_hashmap %2
    IF "!EVAL_AST_is_hashmap!"=="!TRUE!" (
        CALL :HASHMAP_KEYS EVAL_AST_keys%_recursive_count% %2
        CALL :VECTOR_LENGTH EVAL_AST_keys_length EVAL_AST_keys%_recursive_count%
        set /a "EVAL_AST_keys_length-=1"
        CALL :HASHMAP_NEW EVAL_AST_new_hashmap%_recursive_count%
        FOR /L %%G IN (0, 1, !EVAL_AST_keys_length!) DO (
            set "EVAL_AST_index=%%G"
            CALL :VECTOR_GET EVAL_AST_key%_recursive_count% EVAL_AST_keys%_recursive_count% EVAL_AST_index
            CALL :HASHMAP_GET EVAL_AST_value%_recursive_count% %2 EVAL_AST_key%_recursive_count%
            CALL :EVAL EVAL_AST_evaluated%_recursive_count% EVAL_AST_value%_recursive_count% %3
            CALL :HASHMAP_INSERT EVAL_AST_new_hashmap%_recursive_count% EVAL_AST_key%_recursive_count% EVAL_AST_evaluated%_recursive_count%
        )
        set "%1=!EVAL_AST_new_hashmap%_recursive_count%!"
        EXIT /B 0
    )

    CALL :ATOM? EVAL_AST_is_atom %2
    IF "!EVAL_AST_is_atom!"=="!TRUE!" (
        CALL :ATOM_TO_STR EVAL_AST_atom_str%_recursive_count% %2
        CALL :HASHMAP_GET %1 %3 EVAL_AST_atom_str%_recursive_count%
        EXIT /B 0
    )

    set "%1=!%2!"
EXIT /B 0

:EVAL
    set /a "_recursive_count+=1"

    CALL :LIST? EVAL_is_list %2
    IF "!EVAL_is_list!"=="!TRUE!" (
        IF "!%2!"=="!NIL!" (
            set "%1=!%2!"
            set /a "_recursive_count-=1"
            EXIT /B 0
        )

        CALL :EVAL_AST EVAL_list%_recursive_count% %2 %3

        CALL :FIRST EVAL_function%_recursive_count% EVAL_list%_recursive_count%
        CALL :FUNCTION_TO_STR EVAL_function_str%_recursive_count% EVAL_function%_recursive_count%

        CALL :REST EVAL_list%_recursive_count% EVAL_list%_recursive_count%
        CALL :FIRST EVAL_a%_recursive_count% EVAL_list%_recursive_count%

        CALL :REST EVAL_list%_recursive_count% EVAL_list%_recursive_count%
        CALL :FIRST EVAL_b%_recursive_count% EVAL_list%_recursive_count%

        CALL :CALL_STACK_PUSH EVAL_b%_recursive_count%
        CALL :CALL_STACK_PUSH EVAL_a%_recursive_count%
        CALL !EVAL_function_str%_recursive_count%!
        CALL :CALL_STACK_POP %1

        set /a "_recursive_count-=1"
        EXIT /B 0
    )

    CALL :EVAL_AST %1 %2 %3

    set /a "_recursive_count-=1"
EXIT /B 0
