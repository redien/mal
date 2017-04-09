
:MAL_NUMBER_ADD
    CALL :CALL_STACK_POP NUMBER_ADD_second
    CALL :CALL_STACK_POP NUMBER_ADD_first
    CALL :NUMBER_TO_STR NUMBER_ADD_first_str NUMBER_ADD_first
    CALL :NUMBER_TO_STR NUMBER_ADD_second_str NUMBER_ADD_second
    SET /a "NUMBER_ADD_value_str=!NUMBER_ADD_first_str!+!NUMBER_ADD_second_str!"
    CALL :NUMBER_NEW NUMBER_ADD_value NUMBER_ADD_value_str
    CALL :CALL_STACK_PUSH NUMBER_ADD_value
EXIT /B 0

:MAL_NUMBER_SUBTRACT
    CALL :CALL_STACK_POP NUMBER_SUBTRACT_second
    CALL :CALL_STACK_POP NUMBER_SUBTRACT_first
    CALL :NUMBER_TO_STR NUMBER_SUBTRACT_first_str NUMBER_SUBTRACT_first
    CALL :NUMBER_TO_STR NUMBER_SUBTRACT_second_str NUMBER_SUBTRACT_second
    SET /a "NUMBER_SUBTRACT_value_str=!NUMBER_SUBTRACT_first_str!-!NUMBER_SUBTRACT_second_str!"
    CALL :NUMBER_NEW NUMBER_SUBTRACT_value NUMBER_SUBTRACT_value_str
    CALL :CALL_STACK_PUSH NUMBER_SUBTRACT_value
EXIT /B 0

:MAL_NUMBER_MULTIPLY
    CALL :CALL_STACK_POP NUMBER_MULTIPLY_second
    CALL :CALL_STACK_POP NUMBER_MULTIPLY_first
    CALL :NUMBER_TO_STR NUMBER_MULTIPLY_first_str NUMBER_MULTIPLY_first
    CALL :NUMBER_TO_STR NUMBER_MULTIPLY_second_str NUMBER_MULTIPLY_second
    SET /a "NUMBER_MULTIPLY_value_str=!NUMBER_MULTIPLY_first_str!*!NUMBER_MULTIPLY_second_str!"
    CALL :NUMBER_NEW NUMBER_MULTIPLY_value NUMBER_MULTIPLY_value_str
    CALL :CALL_STACK_PUSH NUMBER_MULTIPLY_value
EXIT /B 0

:MAL_NUMBER_DIVIDE
    CALL :CALL_STACK_POP NUMBER_DIVIDE_second
    CALL :CALL_STACK_POP NUMBER_DIVIDE_first
    CALL :NUMBER_TO_STR NUMBER_DIVIDE_first_str NUMBER_DIVIDE_first
    CALL :NUMBER_TO_STR NUMBER_DIVIDE_second_str NUMBER_DIVIDE_second
    SET /a "NUMBER_DIVIDE_value_str=!NUMBER_DIVIDE_first_str!/!NUMBER_DIVIDE_second_str!"
    CALL :NUMBER_NEW NUMBER_DIVIDE_value NUMBER_DIVIDE_value_str
    CALL :CALL_STACK_PUSH NUMBER_DIVIDE_value
EXIT /B 0

:MAL_PRN
    CALL :CALL_STACK_POP MAL_PRN_first
    CALL :PR_STR MAL_PRN_string MAL_PRN_first
    CALL :ECHO MAL_PRN_string
    CALL :CALL_STACK_PUSH NIL
EXIT /B 0

:MAL_LIST?
    CALL :CALL_STACK_POP MAL_PRN_first
    CALL :LIST? MAL_LIST?_is_list MAL_PRN_first
    CALL :CALL_STACK_PUSH MAL_LIST?_is_list
EXIT /B 0

:MAL_EMPTY?
    CALL :CALL_STACK_POP MAL_EMPTY?_first
    CALL :LIST_EMPTY? MAL_EMPTY?_is_empty MAL_EMPTY?_first
    CALL :CALL_STACK_PUSH MAL_EMPTY?_is_empty
EXIT /B 0

:MAL_COUNT
    CALL :CALL_STACK_POP MAL_COUNT_first
    CALL :LIST_COUNT MAL_COUNT_count MAL_COUNT_first
    CALL :NUMBER_NEW MAL_COUNT_count_number MAL_COUNT_count
    CALL :CALL_STACK_PUSH MAL_COUNT_count_number
EXIT /B 0

:MAL_GREATER_THAN
    CALL :CALL_STACK_POP MAL_GREATER_THAN_second
    CALL :CALL_STACK_POP MAL_GREATER_THAN_first
    CALL :NUMBER_TO_STR MAL_GREATER_THAN_first_str MAL_GREATER_THAN_first
    CALL :NUMBER_TO_STR MAL_GREATER_THAN_second_str MAL_GREATER_THAN_second
    IF !MAL_GREATER_THAN_first_str! GTR !MAL_GREATER_THAN_second_str! (
        CALL :CALL_STACK_PUSH TRUE
    ) ELSE (
        CALL :CALL_STACK_PUSH FALSE
    )
EXIT /B 0

:MAL_LOWER_THAN
    CALL :CALL_STACK_POP MAL_LOWER_THAN_second
    CALL :CALL_STACK_POP MAL_LOWER_THAN_first
    CALL :NUMBER_TO_STR MAL_LOWER_THAN_first_str MAL_LOWER_THAN_first
    CALL :NUMBER_TO_STR MAL_LOWER_THAN_second_str MAL_LOWER_THAN_second
    IF !MAL_LOWER_THAN_first_str! LSS !MAL_LOWER_THAN_second_str! (
        CALL :CALL_STACK_PUSH TRUE
    ) ELSE (
        CALL :CALL_STACK_PUSH FALSE
    )
EXIT /B 0

:MAL_GREATER_THAN_OR_EQUAL
    CALL :CALL_STACK_POP MAL_GREATER_THAN_OR_EQUAL_second
    CALL :CALL_STACK_POP MAL_GREATER_THAN_OR_EQUAL_first
    CALL :NUMBER_TO_STR MAL_GREATER_THAN_OR_EQUAL_first_str MAL_GREATER_THAN_OR_EQUAL_first
    CALL :NUMBER_TO_STR MAL_GREATER_THAN_OR_EQUAL_second_str MAL_GREATER_THAN_OR_EQUAL_second
    IF !MAL_GREATER_THAN_OR_EQUAL_first_str! GEQ !MAL_GREATER_THAN_OR_EQUAL_second_str! (
        CALL :CALL_STACK_PUSH TRUE
    ) ELSE (
        CALL :CALL_STACK_PUSH FALSE
    )
EXIT /B 0

:MAL_LOWER_THAN_OR_EQUAL
    CALL :CALL_STACK_POP MAL_LOWER_THAN_OR_EQUAL_second
    CALL :CALL_STACK_POP MAL_LOWER_THAN_OR_EQUAL_first
    CALL :NUMBER_TO_STR MAL_LOWER_THAN_OR_EQUAL_first_str MAL_LOWER_THAN_OR_EQUAL_first
    CALL :NUMBER_TO_STR MAL_LOWER_THAN_OR_EQUAL_second_str MAL_LOWER_THAN_OR_EQUAL_second
    IF !MAL_LOWER_THAN_OR_EQUAL_first_str! LEQ !MAL_LOWER_THAN_OR_EQUAL_second_str! (
        CALL :CALL_STACK_PUSH TRUE
    ) ELSE (
        CALL :CALL_STACK_PUSH FALSE
    )
EXIT /B 0

:MAL_EQUAL
    CALL :CALL_STACK_POP MAL_EQUAL_second
    CALL :CALL_STACK_POP MAL_EQUAL_first
    IF "!MAL_EQUAL_first!"=="!MAL_EQUAL_second!" (
        CALL :CALL_STACK_PUSH TRUE
    ) ELSE (
        CALL :CALL_STACK_PUSH FALSE
    )
EXIT /B 0

:MAL_LIST
    SET "MAL_LIST_list=!EMPTY_LIST!"
    CALL :CALL_STACK_SIZE MAL_LIST_arguments
    SET /a "MAL_LIST_arguments-=1"
    FOR /L %%G IN (0, 1, !MAL_LIST_arguments!) DO (
        CALL :CALL_STACK_POP MAL_LIST_argument
        CALL :CONS MAL_LIST_list MAL_LIST_argument MAL_LIST_list
    )
    CALL :CALL_STACK_PUSH MAL_LIST_list
EXIT /B 0
