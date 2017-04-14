
:NUMBER_OF_ARGS_OR_ERROR
    CALL :CALL_STACK_POP NUMBER_OF_ARGS_OR_ERROR_size_number
    CALL :NUMBER_TO_STR NUMBER_OF_ARGS_OR_ERROR_size NUMBER_OF_ARGS_OR_ERROR_size_number
    IF NOT "!NUMBER_OF_ARGS_OR_ERROR_size!"=="%2" (
        SET "NUMBER_OF_ARGS_OR_ERROR_error_message=Wrong number of arguments: got !NUMBER_OF_ARGS_OR_ERROR_size! expected %2!"
        CALL :ERROR_NEW %1 NUMBER_OF_ARGS_OR_ERROR_error_message

        :: We clean up the stack on error.
        SET /a "NUMBER_OF_ARGS_OR_ERROR_size-=1"
        FOR /L %%G IN (0, 1, !NUMBER_OF_ARGS_OR_ERROR_size!) DO (
            SET "NUMBER_OF_ARGS_OR_ERROR_index=%%G"
            CALL :CALL_STACK_POP _
        )

    ) ELSE (
        SET "%1=!NUMBER_OF_ARGS_OR_ERROR_size_number!"
    )
EXIT /B 0

:MAL_NUMBER_ADD
    CALL :NUMBER_OF_ARGS_OR_ERROR MAL_NUMBER_ADD_args 2
    CALL :ERROR? MAL_NUMBER_ADD_args_is_error MAL_NUMBER_ADD_args
    IF "!MAL_NUMBER_ADD_args_is_error!"=="!TRUE!" (
        CALL :CALL_STACK_PUSH MAL_NUMBER_ADD_args
        EXIT /B 0
    )

    CALL :CALL_STACK_POP MAL_NUMBER_ADD_first
    CALL :CALL_STACK_POP MAL_NUMBER_ADD_second
    CALL :NUMBER_TO_STR MAL_NUMBER_ADD_first_str MAL_NUMBER_ADD_first
    CALL :NUMBER_TO_STR MAL_NUMBER_ADD_second_str MAL_NUMBER_ADD_second
    SET /a "MAL_NUMBER_ADD_value_str=!MAL_NUMBER_ADD_first_str!+!MAL_NUMBER_ADD_second_str!"
    CALL :NUMBER_NEW MAL_NUMBER_ADD_value MAL_NUMBER_ADD_value_str
    CALL :CALL_STACK_PUSH MAL_NUMBER_ADD_value
EXIT /B 0

:MAL_NUMBER_SUBTRACT
    CALL :NUMBER_OF_ARGS_OR_ERROR NUMBER_SUBTRACT_args 2
    CALL :ERROR? NUMBER_SUBTRACT_args_is_error NUMBER_SUBTRACT_args
    IF "!NUMBER_SUBTRACT_args_is_error!"=="!TRUE!" (
        CALL :CALL_STACK_PUSH NUMBER_SUBTRACT_args
        EXIT /B 0
    )

    CALL :CALL_STACK_POP NUMBER_SUBTRACT_first
    CALL :CALL_STACK_POP NUMBER_SUBTRACT_second
    CALL :NUMBER_TO_STR NUMBER_SUBTRACT_first_str NUMBER_SUBTRACT_first
    CALL :NUMBER_TO_STR NUMBER_SUBTRACT_second_str NUMBER_SUBTRACT_second
    SET /a "NUMBER_SUBTRACT_value_str=!NUMBER_SUBTRACT_first_str!-!NUMBER_SUBTRACT_second_str!"
    CALL :NUMBER_NEW NUMBER_SUBTRACT_value NUMBER_SUBTRACT_value_str
    CALL :CALL_STACK_PUSH NUMBER_SUBTRACT_value
EXIT /B 0

:MAL_NUMBER_MULTIPLY
    CALL :NUMBER_OF_ARGS_OR_ERROR NUMBER_MULTIPLY_args 2
    CALL :ERROR? NUMBER_MULTIPLY_args_is_error NUMBER_MULTIPLY_args
    IF "!NUMBER_MULTIPLY_args_is_error!"=="!TRUE!" (
        CALL :CALL_STACK_PUSH NUMBER_MULTIPLY_args
        EXIT /B 0
    )

    CALL :CALL_STACK_POP NUMBER_MULTIPLY_first
    CALL :CALL_STACK_POP NUMBER_MULTIPLY_second
    CALL :NUMBER_TO_STR NUMBER_MULTIPLY_first_str NUMBER_MULTIPLY_first
    CALL :NUMBER_TO_STR NUMBER_MULTIPLY_second_str NUMBER_MULTIPLY_second
    SET /a "NUMBER_MULTIPLY_value_str=!NUMBER_MULTIPLY_first_str!*!NUMBER_MULTIPLY_second_str!"
    CALL :NUMBER_NEW NUMBER_MULTIPLY_value NUMBER_MULTIPLY_value_str
    CALL :CALL_STACK_PUSH NUMBER_MULTIPLY_value
EXIT /B 0

:MAL_NUMBER_DIVIDE
    CALL :NUMBER_OF_ARGS_OR_ERROR NUMBER_DIVIDE_args 2
    CALL :ERROR? NUMBER_DIVIDE_args_is_error NUMBER_DIVIDE_args
    IF "!NUMBER_DIVIDE_args_is_error!"=="!TRUE!" (
        CALL :CALL_STACK_PUSH NUMBER_DIVIDE_args
        EXIT /B 0
    )

    CALL :CALL_STACK_POP NUMBER_DIVIDE_first
    CALL :CALL_STACK_POP NUMBER_DIVIDE_second
    CALL :NUMBER_TO_STR NUMBER_DIVIDE_first_str NUMBER_DIVIDE_first
    CALL :NUMBER_TO_STR NUMBER_DIVIDE_second_str NUMBER_DIVIDE_second
    SET /a "NUMBER_DIVIDE_value_str=!NUMBER_DIVIDE_first_str!/!NUMBER_DIVIDE_second_str!"
    CALL :NUMBER_NEW NUMBER_DIVIDE_value NUMBER_DIVIDE_value_str
    CALL :CALL_STACK_PUSH NUMBER_DIVIDE_value
EXIT /B 0

:MAL_STR
    SET "MAL_STR_str="
    CALL :CALL_STACK_POP MAL_STR_args_number
    CALL :NUMBER_TO_STR MAL_STR_args MAL_STR_args_number
    SET /a "MAL_STR_args-=1"
    FOR /L %%G IN (0, 1, !MAL_STR_args!) DO (
        CALL :CALL_STACK_POP MAL_STR_argument
        CALL :PR_STR MAL_STR_substring MAL_STR_argument FALSE
        SET "MAL_STR_str=!MAL_STR_str!!MAL_STR_substring!"
    )
    CALL :STRING_NEW MAL_STR_string MAL_STR_str
    CALL :CALL_STACK_PUSH MAL_STR_string
EXIT /B 0

:_MAL_PR_STR
    SET "_MAL_PR_STR_str="
    CALL :CALL_STACK_POP _MAL_PR_STR_args_number
    CALL :NUMBER_TO_STR _MAL_PR_STR_args _MAL_PR_STR_args_number
    SET /a "_MAL_PR_STR_args-=1"
    FOR /L %%G IN (0, 1, !_MAL_PR_STR_args!) DO (
        CALL :CALL_STACK_POP _MAL_PR_STR_argument
        CALL :PR_STR _MAL_PR_STR_substring _MAL_PR_STR_argument %1
        SET "_MAL_PR_STR_str=!_MAL_PR_STR_str! !_MAL_PR_STR_substring!"
    )
    IF NOT "!_MAL_PR_STR_str!"=="" (
        SET "_MAL_PR_STR_str=!_MAL_PR_STR_str:~1!"
    )
    CALL :STRING_NEW _MAL_PR_STR_string _MAL_PR_STR_str
    CALL :CALL_STACK_PUSH _MAL_PR_STR_string
EXIT /B 0

:MAL_PR_STR
    CALL :_MAL_PR_STR TRUE
EXIT /B 0

:MAL_PRN
    CALL :_MAL_PR_STR TRUE
    CALL :CALL_STACK_POP MAL_PRN_string
    CALL :STRING_TO_STR MAL_PRN_str MAL_PRN_string
    CALL :ECHO MAL_PRN_str
    CALL :CALL_STACK_PUSH NIL
EXIT /B 0

:MAL_PRINTLN
    CALL :_MAL_PR_STR FALSE
    CALL :CALL_STACK_POP MAL_PRINTLN_string
    CALL :STRING_TO_STR MAL_PRINTLN_str MAL_PRINTLN_string
    CALL :ECHO MAL_PRINTLN_str
    CALL :CALL_STACK_PUSH NIL
EXIT /B 0

:MAL_LIST?
    CALL :NUMBER_OF_ARGS_OR_ERROR MAL_LIST?_args 1
    CALL :ERROR? MAL_LIST?_args_is_error MAL_LIST?_args
    IF "!MAL_LIST?_args_is_error!"=="!TRUE!" (
        CALL :CALL_STACK_PUSH MAL_LIST?_args
        EXIT /B 0
    )

    CALL :CALL_STACK_POP MAL_LIST?_first
    CALL :LIST? MAL_LIST?_is_list MAL_LIST?_first
    CALL :CALL_STACK_PUSH MAL_LIST?_is_list
EXIT /B 0

:MAL_EMPTY?
    CALL :NUMBER_OF_ARGS_OR_ERROR MAL_EMPTY?_args 1
    CALL :ERROR? MAL_EMPTY?_args_is_error MAL_EMPTY?_args
    IF "!MAL_EMPTY?_args_is_error!"=="!TRUE!" (
        CALL :CALL_STACK_PUSH MAL_EMPTY?_args
        EXIT /B 0
    )

    CALL :CALL_STACK_POP MAL_EMPTY?_first
    CALL :VECTOR? MAL_EMPTY?_is_vector MAL_EMPTY?_first
    IF "!MAL_EMPTY?_is_vector!"=="!TRUE!" (
        CALL :VECTOR_EMPTY? MAL_EMPTY?_is_empty MAL_EMPTY?_first
    ) ELSE (
        CALL :LIST_EMPTY? MAL_EMPTY?_is_empty MAL_EMPTY?_first
    )
    CALL :CALL_STACK_PUSH MAL_EMPTY?_is_empty
EXIT /B 0

:MAL_COUNT
    CALL :NUMBER_OF_ARGS_OR_ERROR MAL_COUNT_args 1
    CALL :ERROR? MAL_COUNT_args_is_error MAL_COUNT_args
    IF "!MAL_COUNT_args_is_error!"=="!TRUE!" (
        CALL :CALL_STACK_PUSH MAL_COUNT_args
        EXIT /B 0
    )

    CALL :CALL_STACK_POP MAL_COUNT_first
    CALL :VECTOR? MAL_COUNT_is_vector MAL_COUNT_first
    IF "!MAL_COUNT_is_vector!"=="!TRUE!" (
        CALL :VECTOR_LENGTH MAL_COUNT_count MAL_COUNT_first
    ) ELSE (
        CALL :LIST_COUNT MAL_COUNT_count MAL_COUNT_first
    )
    CALL :NUMBER_NEW MAL_COUNT_count_number MAL_COUNT_count
    CALL :CALL_STACK_PUSH MAL_COUNT_count_number
EXIT /B 0

:MAL_GREATER_THAN
    CALL :NUMBER_OF_ARGS_OR_ERROR MAL_GREATER_THAN_args 2
    CALL :ERROR? MAL_GREATER_THAN_args_is_error MAL_GREATER_THAN_args
    IF "!MAL_GREATER_THAN_args_is_error!"=="!TRUE!" (
        CALL :CALL_STACK_PUSH MAL_GREATER_THAN_args
        EXIT /B 0
    )

    CALL :CALL_STACK_POP MAL_GREATER_THAN_first
    CALL :CALL_STACK_POP MAL_GREATER_THAN_second
    CALL :NUMBER_TO_STR MAL_GREATER_THAN_first_str MAL_GREATER_THAN_first
    CALL :NUMBER_TO_STR MAL_GREATER_THAN_second_str MAL_GREATER_THAN_second
    IF !MAL_GREATER_THAN_first_str! GTR !MAL_GREATER_THAN_second_str! (
        CALL :CALL_STACK_PUSH TRUE
    ) ELSE (
        CALL :CALL_STACK_PUSH FALSE
    )
EXIT /B 0

:MAL_LOWER_THAN
    CALL :NUMBER_OF_ARGS_OR_ERROR MAL_LOWER_THAN_args 2
    CALL :ERROR? MAL_LOWER_THAN_args_is_error MAL_LOWER_THAN_args
    IF "!MAL_LOWER_THAN_args_is_error!"=="!TRUE!" (
        CALL :CALL_STACK_PUSH MAL_LOWER_THAN_args
        EXIT /B 0
    )

    CALL :CALL_STACK_POP MAL_LOWER_THAN_first
    CALL :CALL_STACK_POP MAL_LOWER_THAN_second
    CALL :NUMBER_TO_STR MAL_LOWER_THAN_first_str MAL_LOWER_THAN_first
    CALL :NUMBER_TO_STR MAL_LOWER_THAN_second_str MAL_LOWER_THAN_second
    IF !MAL_LOWER_THAN_first_str! LSS !MAL_LOWER_THAN_second_str! (
        CALL :CALL_STACK_PUSH TRUE
    ) ELSE (
        CALL :CALL_STACK_PUSH FALSE
    )
EXIT /B 0

:MAL_GREATER_THAN_OR_EQUAL
    CALL :NUMBER_OF_ARGS_OR_ERROR MAL_GREATER_THAN_OR_EQUAL_args 2
    CALL :ERROR? MAL_GREATER_THAN_OR_EQUAL_args_is_error MAL_GREATER_THAN_OR_EQUAL_args
    IF "!MAL_GREATER_THAN_OR_EQUAL_args_is_error!"=="!TRUE!" (
        CALL :CALL_STACK_PUSH MAL_GREATER_THAN_OR_EQUAL_args
        EXIT /B 0
    )

    CALL :CALL_STACK_POP MAL_GREATER_THAN_OR_EQUAL_first
    CALL :CALL_STACK_POP MAL_GREATER_THAN_OR_EQUAL_second
    CALL :NUMBER_TO_STR MAL_GREATER_THAN_OR_EQUAL_first_str MAL_GREATER_THAN_OR_EQUAL_first
    CALL :NUMBER_TO_STR MAL_GREATER_THAN_OR_EQUAL_second_str MAL_GREATER_THAN_OR_EQUAL_second
    IF !MAL_GREATER_THAN_OR_EQUAL_first_str! GEQ !MAL_GREATER_THAN_OR_EQUAL_second_str! (
        CALL :CALL_STACK_PUSH TRUE
    ) ELSE (
        CALL :CALL_STACK_PUSH FALSE
    )
EXIT /B 0

:MAL_LOWER_THAN_OR_EQUAL
    CALL :NUMBER_OF_ARGS_OR_ERROR MAL_LOWER_THAN_OR_EQUAL_args 2
    CALL :ERROR? MAL_LOWER_THAN_OR_EQUAL_args_is_error MAL_LOWER_THAN_OR_EQUAL_args
    IF "!MAL_LOWER_THAN_OR_EQUAL_args_is_error!"=="!TRUE!" (
        CALL :CALL_STACK_PUSH MAL_LOWER_THAN_OR_EQUAL_args
        EXIT /B 0
    )

    CALL :CALL_STACK_POP MAL_LOWER_THAN_OR_EQUAL_first
    CALL :CALL_STACK_POP MAL_LOWER_THAN_OR_EQUAL_second
    CALL :NUMBER_TO_STR MAL_LOWER_THAN_OR_EQUAL_first_str MAL_LOWER_THAN_OR_EQUAL_first
    CALL :NUMBER_TO_STR MAL_LOWER_THAN_OR_EQUAL_second_str MAL_LOWER_THAN_OR_EQUAL_second
    IF !MAL_LOWER_THAN_OR_EQUAL_first_str! LEQ !MAL_LOWER_THAN_OR_EQUAL_second_str! (
        CALL :CALL_STACK_PUSH TRUE
    ) ELSE (
        CALL :CALL_STACK_PUSH FALSE
    )
EXIT /B 0

:MAL_EQUAL
    CALL :NUMBER_OF_ARGS_OR_ERROR MAL_EQUAL_args 2
    CALL :ERROR? MAL_EQUAL_args_is_error MAL_EQUAL_args
    IF "!MAL_EQUAL_args_is_error!"=="!TRUE!" (
        CALL :CALL_STACK_PUSH MAL_EQUAL_args
        EXIT /B 0
    )

    CALL :CALL_STACK_POP MAL_EQUAL_first
    CALL :CALL_STACK_POP MAL_EQUAL_second
    CALL :EQUAL? MAL_EQUAL_result MAL_EQUAL_first MAL_EQUAL_second
    CALL :CALL_STACK_PUSH MAL_EQUAL_result
EXIT /B 0

:MAL_LIST
    SET "MAL_LIST_list=!EMPTY_LIST!"
    CALL :CALL_STACK_POP MAL_LIST_args_number
    CALL :NUMBER_TO_STR MAL_LIST_args MAL_LIST_args_number
    SET /a "MAL_LIST_args-=1"
    FOR /L %%G IN (0, 1, !MAL_LIST_args!) DO (
        CALL :CALL_STACK_POP MAL_LIST_argument
        CALL :CONS MAL_LIST_list MAL_LIST_argument MAL_LIST_list
    )
    CALL :LIST_REVERSE MAL_LIST_list MAL_LIST_list
    CALL :CALL_STACK_PUSH MAL_LIST_list
EXIT /B 0

:MAL_LAMBDA
    SET /a "MAL_LAMBDA_recursion_count+=1"

    CALL :FUNCTION_GET_PARAMS MAL_LAMBDA_params %1
    CALL :FUNCTION_GET_ENV MAL_LAMBDA_env_outer %1
    CALL :FUNCTION_GET_BODY MAL_LAMBDA_body%MAL_LAMBDA_recursion_count% %1

    CALL :ENV_NEW MAL_LAMBDA_env%MAL_LAMBDA_recursion_count%
    CALL :ENV_SET_OUTER MAL_LAMBDA_env%MAL_LAMBDA_recursion_count% MAL_LAMBDA_env_outer

    CALL :VECTOR? MAL_LAMBDA_params_is_vector MAL_LAMBDA_params
    IF "!MAL_LAMBDA_params_is_vector!"=="!TRUE!" (
        CALL :VECTOR_LENGTH MAL_LAMBDA_params_length MAL_LAMBDA_params
    ) ELSE (
        CALL :LIST_COUNT MAL_LAMBDA_params_length MAL_LAMBDA_params
    )

    CALL :NUMBER_OF_ARGS_OR_ERROR MAL_LAMBDA_args !MAL_LAMBDA_params_length!
    CALL :ERROR? MAL_LAMBDA_args_is_error MAL_LAMBDA_args
    IF "!MAL_LAMBDA_args_is_error!"=="!TRUE!" (
        CALL :CALL_STACK_PUSH MAL_LAMBDA_args
        SET /a "MAL_LAMBDA_recursion_count-=1"
        EXIT /B 0
    )

    CALL :NUMBER_TO_STR MAL_LAMBDA_args_length MAL_LAMBDA_args
    SET /a "MAL_LAMBDA_args_length-=1"
    FOR /L %%G IN (0, 1, !MAL_LAMBDA_args_length!) DO (
        SET "MAL_LAMBDA_args_index=%%G"
        IF "!MAL_LAMBDA_params_is_vector!"=="!TRUE!" (
            CALL :VECTOR_GET MAL_LAMBDA_param MAL_LAMBDA_params MAL_LAMBDA_args_index
        ) ELSE (
            CALL :FIRST MAL_LAMBDA_param MAL_LAMBDA_params
            CALL :REST MAL_LAMBDA_params MAL_LAMBDA_params
        )
        CALL :CALL_STACK_POP MAL_LAMBDA_argument
        CALL :ENV_SET MAL_LAMBDA_env%MAL_LAMBDA_recursion_count% MAL_LAMBDA_param MAL_LAMBDA_argument
    )

    CALL :EVAL MAL_LAMBDA_result MAL_LAMBDA_body%MAL_LAMBDA_recursion_count% MAL_LAMBDA_env%MAL_LAMBDA_recursion_count%
    CALL :CALL_STACK_PUSH MAL_LAMBDA_result

    SET /a "MAL_LAMBDA_recursion_count-=1"
EXIT /B 0
