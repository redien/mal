
:CALL_STACK_PUSH
    SET /a "_call_stack_size+=1"
    SET "_call_stack_value!_call_stack_size!=!%1!"
EXIT /B 0

:CALL_STACK_POP
    SET "CALL_STACK_POP_ref=_call_stack_value!_call_stack_size!"
    SET "%1=!%CALL_STACK_POP_ref%!"
    SET /a "_call_stack_size-=1"
EXIT /B 0

:CALL_STACK_SIZE
    SET "%1=!_call_stack_size!"
EXIT /B 0

:CALL_STACK_CLEAR
    SET "_call_stack_size=0"
EXIT /B 0

:DEFINE_FUN
    CALL :FUNCTION_NEW DEFINE_FUN_value %3
    CALL :ATOM_NEW DEFINE_FUN_key %2
    CALL :ENV_SET %1 DEFINE_FUN_key DEFINE_FUN_value
EXIT /B 0

:START

CALL :ENV_NEW REPL_env
CALL :DEFINE_FUN REPL_env _plus :MAL_NUMBER_ADD
CALL :DEFINE_FUN REPL_env _minus :MAL_NUMBER_SUBTRACT
CALL :DEFINE_FUN REPL_env _asterisk :MAL_NUMBER_MULTIPLY
CALL :DEFINE_FUN REPL_env _slash :MAL_NUMBER_DIVIDE
SET "_name=prn"
CALL :DEFINE_FUN REPL_env _name :MAL_PRN
SET "_name=list"
CALL :DEFINE_FUN REPL_env _name :MAL_LIST
SET "_name=list?"
CALL :DEFINE_FUN REPL_env _name :MAL_LIST?
SET "_name=empty?"
CALL :DEFINE_FUN REPL_env _name :MAL_EMPTY?
SET "_name=count"
CALL :DEFINE_FUN REPL_env _name :MAL_COUNT
::CALL :DEFINE_FUN REPL_env = :MAL_EQUAL
CALL :DEFINE_FUN REPL_env _greater_than :MAL_GREATER_THAN
CALL :DEFINE_FUN REPL_env _lower_than :MAL_LOWER_THAN
CALL :DEFINE_FUN REPL_env _greater_than_equal :MAL_GREATER_THAN_OR_EQUAL
CALL :DEFINE_FUN REPL_env _lower_than_equal :MAL_LOWER_THAN_OR_EQUAL

:REPL
    SET "_input="
    CALL :READ REPL_form
    SET "REPL_result=!NIL!"
    CALL :EVAL REPL_result REPL_form REPL_env
    CALL :PRINT REPL_result
GOTO :REPL

:READ
    :: prompt the user and assign the user's input to _input.
    SET /p "_input=user> "
    :: If nothing is written, empty the input and reSET the error level
    IF  errorlevel 1 SET "_input=" & verify>nul

    IF "!_input!"=="exit" EXIT :: Exit command used for testing purposes

    CALL :READ_STR %1 _input
EXIT /B 0

:PRINT
    CALL :PR_STR PRINT_output %1
    CALL :ECHO PRINT_output
EXIT /B 0

:EVAL_AST
    CALL :LIST? EVAL_AST_is_list %2
    IF "!EVAL_AST_is_list!"=="!TRUE!" (
        CALL :LIST_MAP %1 %2 :EVAL %3
        EXIT /B 0
    )

    CALL :VECTOR? EVAL_AST_is_vector %2
    IF "!EVAL_AST_is_vector!"=="!TRUE!" (
        CALL :VECTOR_MAP %1 %2 :EVAL %3
        EXIT /B 0
    )

    CALL :HASHMAP? EVAL_AST_is_hashmap %2
    IF "!EVAL_AST_is_hashmap!"=="!TRUE!" (
        CALL :HASHMAP_MAP %1 %2 :EVAL %3
        EXIT /B 0
    )

    CALL :ATOM? EVAL_AST_is_atom %2
    IF "!EVAL_AST_is_atom!"=="!TRUE!" (
        CALL :ENV_GET %1 %3 %2
        IF "!%1!"=="!NIL!" (
            CALL :ATOM_TO_STR EVAL_AST_atom_str %2
            SET "EVAL_AST_error=Not defined: !EVAL_AST_atom_str!"
            CALL :ERROR_NEW %1 EVAL_AST_error
        )
        EXIT /B 0
    )

    SET "%1=!%2!"
EXIT /B 0

:EVAL_DEF_LIST
    SET "EVAL_DEF_LIST_list%_recursion_count%=!%2!"
:_EVAL_DEF_LIST
    CALL :FIRST EVAL_DEF_LIST_key%_recursion_count% EVAL_DEF_LIST_list%_recursion_count%
    CALL :REST EVAL_DEF_LIST_list%_recursion_count% EVAL_DEF_LIST_list%_recursion_count%

    CALL :FIRST EVAL_DEF_LIST_value%_recursion_count% EVAL_DEF_LIST_list%_recursion_count%
    CALL :REST EVAL_DEF_LIST_list%_recursion_count% EVAL_DEF_LIST_list%_recursion_count%

    CALL :EVAL EVAL_DEF_LIST_evaluated_value%_recursion_count% EVAL_DEF_LIST_value%_recursion_count% %1

    CALL :ENV_SET %1 EVAL_DEF_LIST_key%_recursion_count% EVAL_DEF_LIST_evaluated_value%_recursion_count%

    IF NOT "!EVAL_DEF_LIST_list%_recursion_count%!"=="!NIL!" (
        GOTO :_EVAL_DEF_LIST
    )
EXIT /B 0

:EVAL_DEF_VECTOR
    CALL :VECTOR_LENGTH EVAL_DEF_VECTOR_vector_length %2
    SET /a "EVAL_DEF_VECTOR_vector_length-=1"
    FOR /L %%G IN (0, 2, !EVAL_DEF_VECTOR_vector_length!) DO (
        SET "EVAL_DEF_VECTOR_index=%%G"
        CALL :VECTOR_GET EVAL_DEF_VECTOR_key%_recursion_count% %2 EVAL_DEF_VECTOR_index
        SET /a "EVAL_DEF_VECTOR_index+=1"
        CALL :VECTOR_GET EVAL_DEF_VECTOR_value%_recursion_count% %2 EVAL_DEF_VECTOR_index

        CALL :EVAL EVAL_DEF_VECTOR_evaluated_value%_recursion_count% EVAL_DEF_VECTOR_value%_recursion_count% %1

        CALL :ENV_SET %1 EVAL_DEF_VECTOR_key%_recursion_count% EVAL_DEF_VECTOR_evaluated_value%_recursion_count%
    )
EXIT /B 0

:EVAL
    SET /a "_recursion_count+=1"

    CALL :LIST? EVAL_is_list %2
    IF "!EVAL_is_list!"=="!TRUE!" (
        IF "!%2!"=="!NIL!" (
            SET "%1=!%2!"
            SET /a "_recursion_count-=1"
            EXIT /B 0
        )

        CALL :FIRST EVAL_first_form %2
        CALL :REST EVAL_rest%_recursion_count% %2
        CALL :ATOM? EVAL_is_atom EVAL_first_form
        IF "!EVAL_is_atom!"=="!TRUE!" (
            CALL :ATOM_TO_STR EVAL_first_atom_str EVAL_first_form
            IF "!EVAL_first_atom_str!"=="def^!" (
                CALL :FIRST EVAL_key%_recursion_count% EVAL_rest%_recursion_count%
                CALL :REST EVAL_rest%_recursion_count% EVAL_rest%_recursion_count%
                CALL :FIRST EVAL_value%_recursion_count% EVAL_rest%_recursion_count%
                CALL :EVAL EVAL_evaluated_value%_recursion_count% EVAL_value%_recursion_count% %3
                CALL :ENV_SET %3 EVAL_key%_recursion_count% EVAL_evaluated_value%_recursion_count%
                SET "%1=!EVAL_evaluated_value%_recursion_count%!"
                SET /a "_recursion_count-=1"
                EXIT /B 0
            )

            IF "!EVAL_first_atom_str!"=="do" (
                CALL :REST EVAL_list%_recursion_count% %2
                CALL :EVAL_AST EVAL_evaluated_list%_recursion_count% EVAL_list%_recursion_count% %3
                CALL :ERROR? EVAL_evaluated_list_is_error%_recursion_count% EVAL_evaluated_list%_recursion_count%
                IF "!EVAL_evaluated_list_is_error%_recursion_count%!"=="!TRUE!" (
                    SET "%1=!EVAL_evaluated_list%_recursion_count%!"
                    SET /a "_recursion_count-=1"
                    EXIT /B 0
                )

                CALL :LIST_LAST EVAL_evaluated_value%_recursion_count% EVAL_evaluated_list%_recursion_count%
                SET "%1=!EVAL_evaluated_value%_recursion_count%!"
                SET /a "_recursion_count-=1"
                EXIT /B 0
            )

            IF "!EVAL_first_atom_str!"=="if" (
                CALL :FIRST EVAL_predicate%_recursion_count% EVAL_rest%_recursion_count%
                CALL :REST EVAL_rest%_recursion_count% EVAL_rest%_recursion_count%
                CALL :FIRST EVAL_true_expression%_recursion_count% EVAL_rest%_recursion_count%

                CALL :EVAL EVAL_evaluated_predicate%_recursion_count% EVAL_predicate%_recursion_count% %3
                CALL :ERROR? EVAL_evaluated_predicate_is_error%_recursion_count% EVAL_evaluated_predicate%_recursion_count%
                IF "!EVAL_evaluated_predicate_is_error%_recursion_count%!"=="!TRUE!" (
                    SET "%1=!EVAL_evaluated_predicate%_recursion_count%!"
                    SET /a "_recursion_count-=1"
                    EXIT /B 0
                )

                SET "EVAL_is_falsey%_recursion_count%=!FALSE!"
                IF "!EVAL_evaluated_predicate%_recursion_count%!"=="!FALSE!" (
                    SET "EVAL_is_falsey%_recursion_count%=!TRUE!"
                )
                IF "!EVAL_evaluated_predicate%_recursion_count%!"=="!NIL!" (
                    SET "EVAL_is_falsey%_recursion_count%=!TRUE!"
                )

                IF "!EVAL_is_falsey%_recursion_count%!"=="!TRUE!" (
                    CALL :REST EVAL_rest%_recursion_count% EVAL_rest%_recursion_count%
                    IF NOT "!EVAL_rest%_recursion_count%!"=="!NIL!" (
                        CALL :FIRST EVAL_false_expression%_recursion_count% EVAL_rest%_recursion_count%
                        CALL :EVAL EVAL_evaluated_value%_recursion_count% EVAL_false_expression%_recursion_count% %3
                    ) ELSE (
                        SET "EVAL_evaluated_value%_recursion_count%=!NIL!"
                    )
                ) ELSE (
                    CALL :EVAL EVAL_evaluated_value%_recursion_count% EVAL_true_expression%_recursion_count% %3
                )

                SET "%1=!EVAL_evaluated_value%_recursion_count%!"
                SET /a "_recursion_count-=1"
                EXIT /B 0
            )

            IF "!EVAL_first_atom_str!"=="let*" (
                CALL :ENV_NEW EVAL_env%_recursion_count%
                CALL :ENV_SET_OUTER EVAL_env%_recursion_count% %3

                CALL :FIRST EVAL_def_list%_recursion_count% EVAL_rest%_recursion_count%

                CALL :LIST? EVAL_is_list EVAL_def_list%_recursion_count%
                IF "!EVAL_is_list!"=="!TRUE!" (
                    CALL :EVAL_DEF_LIST EVAL_env%_recursion_count% EVAL_def_list%_recursion_count%
                ) ELSE (
                    CALL :EVAL_DEF_VECTOR EVAL_env%_recursion_count% EVAL_def_list%_recursion_count%
                )

                CALL :REST EVAL_rest%_recursion_count% EVAL_rest%_recursion_count%
                CALL :FIRST EVAL_value%_recursion_count% EVAL_rest%_recursion_count%

                CALL :EVAL EVAL_evaluated_value%_recursion_count% EVAL_value%_recursion_count% EVAL_env%_recursion_count%

                SET "%1=!EVAL_evaluated_value%_recursion_count%!"
                SET /a "_recursion_count-=1"
                EXIT /B 0
            )
        )

        CALL :EVAL_AST EVAL_list%_recursion_count% %2 %3
        CALL :LIST_FIND EVAL_error%_recursion_count% EVAL_list%_recursion_count% :ERROR?
        IF NOT "!EVAL_error%_recursion_count%!"=="!NIL!" (
            SET "%1=!EVAL_error%_recursion_count%!"
            SET /a "_recursion_count-=1"
            EXIT /B 0
        )

        CALL :FIRST EVAL_function%_recursion_count% EVAL_list%_recursion_count%
        CALL :FUNCTION_TO_STR EVAL_function_str%_recursion_count% EVAL_function%_recursion_count%
        CALL :REST EVAL_list%_recursion_count% EVAL_list%_recursion_count%

:EVAL_ARGUMENT_LOOP
        IF NOT "!EVAL_list%_recursion_count%!"=="!NIL!" (
            CALL :FIRST EVAL_argument%_recursion_count% EVAL_list%_recursion_count%
            CALL :REST EVAL_list%_recursion_count% EVAL_list%_recursion_count%
            CALL :CALL_STACK_PUSH EVAL_argument%_recursion_count%
            GOTO :EVAL_ARGUMENT_LOOP
        )

        CALL !EVAL_function_str%_recursion_count%!
        CALL :CALL_STACK_POP %1

        SET /a "_recursion_count-=1"
        EXIT /B 0
    )

    CALL :EVAL_AST %1 %2 %3

    SET /a "_recursion_count-=1"
EXIT /B 0
