
:NIL?
    IF "!%~2!"=="" (
        SET "%~1=!TRUE!"
    ) ELSE (
        SET "%~1=!FALSE!"
    )
EXIT /B 0

:FIRST
    IF "!%2!"=="!NIL!" (
        SET "%1=!%2!"
        EXIT /B 0
    )

    CALL :EMPTY? FIRST_is_empty %2
    IF "!FIRST_is_empty!"=="!TRUE!" (
        SET "%1=!NIL!"
        EXIT /B 0
    )

    CALL :VECTOR? FIRST_is_vector %2
    IF "!FIRST_is_vector!"=="!TRUE!" (
        SET "FIRST_first_index=0"
        CALL :VECTOR_GET %1 %2 FIRST_first_index
    ) ELSE (
        CALL :LIST_FIRST %1 %2
    )
EXIT /B 0

:REST
    IF "!%2!"=="!NIL!" (
        SET "%1=!EMPTY_LIST!"
        EXIT /B 0
    )

    SET "REST_list=!%2!"

    CALL :VECTOR? REST_is_vector REST_list
    IF "!REST_is_vector!"=="!TRUE!" (
        CALL :VECTOR_TO_LIST REST_list REST_list
    )

    IF "!REST_list!"=="!EMPTY_LIST!" (
        SET "%1=!EMPTY_LIST!"
        EXIT /B 0
    )

    CALL :LIST_REST %1 REST_list
EXIT /B 0

:EMPTY?
    CALL :VECTOR? EMPTY?_is_vector %2
    IF "!EMPTY?_is_vector!"=="!TRUE!" (
        CALL :VECTOR_EMPTY? %1 %2
    ) ELSE (
        CALL :LIST_EMPTY? %1 %2
    )
EXIT /B 0

:COUNT
    CALL :VECTOR? COUNT_is_vector %2
    IF "!COUNT_is_vector!"=="!TRUE!" (
        CALL :VECTOR_LENGTH %1 %2
    ) ELSE (
        CALL :LIST_COUNT %1 %2
    )
EXIT /B 0

:MAP
    CALL :VECTOR? MAP_is_vector %2
    IF "!MAP_is_vector!"=="!TRUE!" (
        CALL :VECTOR_MAP %1 %2 %3 %4
    ) ELSE (
        CALL :LIST_MAP %1 %2 %3 %4
    )
EXIT /B 0

:NTH
    CALL :VECTOR? NTH_is_vector %2
    IF "!NTH_is_vector!"=="!TRUE!" (
        CALL :VECTOR_GET %1 %2 %3
    ) ELSE (
        CALL :LIST_NTH %1 %2 %3
    )
EXIT /B 0


:LIST_CONS
    SET /a "_list_counter+=1"
    SET "_list_first_!_list_counter!=!%~2!"
    SET "_list_rest_!_list_counter!=!%~3!"
    SET "%~1=L!_list_counter!"
EXIT /B 0

:LIST_FIRST
    SET "ref=_list_first_!%~2:~1,8191!"
    SET "%1=!%ref%!"
EXIT /B 0

:LIST_REST
    SET "ref=_list_rest_!%~2:~1,8191!"
    SET "%1=!%ref%!"
EXIT /B 0

:LIST?
    IF "!%2!"=="!EMPTY_LIST!" (
        SET "%~1=!TRUE!"
    ) ELSE (
        IF "!%~2:~0,1!"=="L" (
            SET "%~1=!TRUE!"
        ) ELSE (
            SET "%~1=!FALSE!"
        )
    )
EXIT /B 0

:LIST_EMPTY?
    IF "!%2!"=="!EMPTY_LIST!" (
        SET "%~1=!TRUE!"
    ) ELSE (
        SET "%~1=!FALSE!"
    )
EXIT /B 0

:LIST_COUNT
    SET "%1=0"

    IF "!%2!"=="!NIL!" (
        EXIT /B 0
    )

    SET "LIST_COUNT_list=!%2!"

:LIST_COUNT_LOOP
    IF NOT "!LIST_COUNT_list!"=="!EMPTY_LIST!" (
        CALL :LIST_REST LIST_COUNT_list LIST_COUNT_list
        SET /a "%1+=1"
        GOTO :LIST_COUNT_LOOP
    )
EXIT /B 0

:LIST_REVERSE
    SET "LIST_REVERSE_new_list=!EMPTY_LIST!"
    CALL :_LIST_REVERSE LIST_REVERSE_new_list %2
    SET "%1=!LIST_REVERSE_new_list!"
EXIT /B 0

:_LIST_REVERSE
    IF "!%2!"=="!EMPTY_LIST!" (
        EXIT /B 0
    )

    CALL :LIST_FIRST LIST_REVERSE_first %2
    CALL :LIST_REST LIST_REVERSE_rest %2

    CALL :LIST_CONS %1 LIST_REVERSE_first %1

    CALL :_LIST_REVERSE %1 LIST_REVERSE_rest
EXIT /B 0

:LIST_MAP
    SET /A "LIST_MAP_recursion_count+=1"
    SET "LIST_MAP_list%LIST_MAP_recursion_count%=!EMPTY_LIST!"
    CALL :_LIST_MAP LIST_MAP_list%LIST_MAP_recursion_count% %2 %3 %4
    CALL :LIST_REVERSE %1 LIST_MAP_list%LIST_MAP_recursion_count%
    SET /A "LIST_MAP_recursion_count-=1"
EXIT /B 0

:_LIST_MAP
    IF "!%2!"=="!EMPTY_LIST!" (
        EXIT /B 0
    )

    CALL :LIST_FIRST LIST_MAP_first%LIST_MAP_recursion_count% %2
    CALL :LIST_REST LIST_MAP_rest%LIST_MAP_recursion_count% %2

    CALL %3 LIST_MAP_mapped%LIST_MAP_recursion_count% LIST_MAP_first%LIST_MAP_recursion_count% %4

    CALL :LIST_CONS %1 LIST_MAP_mapped%LIST_MAP_recursion_count% %1

    CALL :_LIST_MAP %1 LIST_MAP_rest%LIST_MAP_recursion_count% %3 %4
EXIT /B 0

:LIST_FIND
    SET /A "LIST_FIND_recursion_count+=1"
    CALL :_LIST_FIND %1 %2 %3 %4
    SET /A "LIST_FIND_recursion_count-=1"
EXIT /B 0

:_LIST_FIND
    IF "!%2!"=="!EMPTY_LIST!" (
        SET "%1=!NIL!"
        EXIT /B 0
    )

    CALL :LIST_FIRST LIST_FIND_first%LIST_FIND_recursion_count% %2
    CALL :LIST_REST LIST_FIND_rest%LIST_FIND_recursion_count% %2

    CALL %3 LIST_FIND_predicate%LIST_FIND_recursion_count% LIST_FIND_first%LIST_FIND_recursion_count% %4

    IF "!LIST_FIND_predicate%LIST_FIND_recursion_count%!"=="!TRUE!" (
        SET "%1=!LIST_FIND_first%LIST_FIND_recursion_count%!"
        EXIT /B 0
    )

    CALL :_LIST_FIND %1 LIST_FIND_rest%LIST_FIND_recursion_count% %3 %4
EXIT /B 0

:LIST_EQUAL
    SET /A "LIST_EQUAL_recursion_count+=1"
    SET "LIST_EQUAL_rest_left%LIST_EQUAL_recursion_count%=!%2!"
    SET "LIST_EQUAL_rest_right%LIST_EQUAL_recursion_count%=!%3!"
    CALL :_LIST_EQUAL %1
    SET /A "LIST_EQUAL_recursion_count-=1"
EXIT /B 0

:_LIST_EQUAL
    IF "!LIST_EQUAL_rest_left%LIST_EQUAL_recursion_count%!"=="!EMPTY_LIST!" (
        IF "!LIST_EQUAL_rest_right%LIST_EQUAL_recursion_count%!"=="!EMPTY_LIST!" (
            SET "%1=!TRUE!"
        ) ELSE (
            SET "%1=!FALSE!"
        )
        EXIT /B 0
    )

    CALL :LIST_FIRST LIST_EQUAL_first_left%LIST_EQUAL_recursion_count% LIST_EQUAL_rest_left%LIST_EQUAL_recursion_count%
    CALL :LIST_REST LIST_EQUAL_rest_left%LIST_EQUAL_recursion_count% LIST_EQUAL_rest_left%LIST_EQUAL_recursion_count%

    CALL :LIST_FIRST LIST_EQUAL_first_right%LIST_EQUAL_recursion_count% LIST_EQUAL_rest_right%LIST_EQUAL_recursion_count%
    CALL :LIST_REST LIST_EQUAL_rest_right%LIST_EQUAL_recursion_count% LIST_EQUAL_rest_right%LIST_EQUAL_recursion_count%

    CALL :EQUAL? %1 LIST_EQUAL_first_left%LIST_EQUAL_recursion_count% LIST_EQUAL_first_right%LIST_EQUAL_recursion_count%

    IF "!%1!"=="!FALSE!" EXIT /B 0

    GOTO :_LIST_EQUAL
EXIT /B 0

:LIST_LAST
    IF "!%2!"=="!EMPTY_LIST!" (
        SET "%1=!NIL!"
        EXIT /B 0
    )
    SET "LIST_LAST_list=!%2!"
:LIST_LAST_LOOP

    CALL :LIST_REST LIST_LAST_rest LIST_LAST_list

    IF "!LIST_LAST_rest!"=="!EMPTY_LIST!" (
        CALL :LIST_FIRST %1 LIST_LAST_list
        EXIT /B 0
    )

    SET "LIST_LAST_list=!LIST_LAST_rest!"
    GOTO :LIST_LAST_LOOP
EXIT /B 0

:LIST_WITHOUT_LAST
    CALL :LIST_REVERSE LIST_WITHOUT_LAST_list %2
    CALL :LIST_REST LIST_WITHOUT_LAST_list LIST_WITHOUT_LAST_list
    CALL :LIST_REVERSE %1 LIST_WITHOUT_LAST_list
EXIT /B 0

:LIST_CONCAT
    CALL :LIST_REVERSE LIST_CONCAT_first %2
    SET "LIST_CONCAT_second=!%3!"
:LIST_CONCAT_RECUR
    IF "!LIST_CONCAT_first!"=="!EMPTY_LIST!" (
        SET "%1=!LIST_CONCAT_second!"
        EXIT /B 0
    )

    CALL :LIST_FIRST LIST_CONCAT_item LIST_CONCAT_first
    CALL :LIST_REST LIST_CONCAT_first LIST_CONCAT_first

    CALL :LIST_CONS LIST_CONCAT_second LIST_CONCAT_item LIST_CONCAT_second

    GOTO :LIST_CONCAT_RECUR
EXIT /B 0

:LIST_NTH
    SET "%1=!NIL!"
    SET "LIST_NTH_list=!%2!"
    SET "LIST_NTH_countdown=!%3!"

:LIST_NTH_LOOP
    IF NOT "!LIST_NTH_list!"=="!EMPTY_LIST!" (
        IF "!LIST_NTH_countdown!"=="0" (
            CALL :LIST_FIRST %1 LIST_NTH_list
            EXIT /B 0
        )

        CALL :LIST_REST LIST_NTH_list LIST_NTH_list
        SET /A "LIST_NTH_countdown-=1"
        GOTO :LIST_NTH_LOOP
    )
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

:VECTOR_EMPTY?
    SET "_length=_vector_length_!%2:~1,8191!"
    IF "!%_length%!"=="0" (
        SET "%1=!TRUE!"
    ) ELSE (
        SET "%1=!FALSE!"
    )
EXIT /B 0

:VECTOR_GET
    SET "_ref=_vector_!%2:~1,8191!_!%3!"
    SET "%1=!%_ref%!"
EXIT /B 0

:VECTOR_SLICE
    CALL :VECTOR_NEW VECTOR_SLICE_new_vector
    SET /A "VECTOR_SLICE_end=!%4!-1"

    FOR /L %%G IN (!%3!, 1, !VECTOR_SLICE_end!) DO (
        SET "_ref=_vector_!%2:~1,8191!_!%%G!"
        SET "_vector_!VECTOR_SLICE_new_vector:~1,8191!_!%%G!=!%_ref%!"
    )

    SET /A "_vector_length_!VECTOR_SLICE_new_vector:~1,8191!=!%4!-!%3!"
    SET "%1=!VECTOR_SLICE_new_vector!"
EXIT /B 0

:VECTOR_PUSH
    SET "_id=!%1:~1,8191!"
    SET "_length=_vector_length_!_id!"
    SET "_ref=_vector_!_id!_!%_length%!"
    SET "%_ref%=!%2!"
    SET /a "%_length%+=1"
EXIT /B 0

:VECTOR_MAP
    SET /A "VECTOR_MAP_recursion_count+=1"
    CALL :_VECTOR_MAP %1 %2 %3 %4
    SET /A VECTOR_MAP_recursion_count-=1"
EXIT /B 0

:_VECTOR_MAP
    CALL :VECTOR_LENGTH VECTOR_MAP_vector_length%VECTOR_MAP_recursion_count% %2
    SET /a "VECTOR_MAP_vector_length%VECTOR_MAP_recursion_count%-=1"
    CALL :VECTOR_NEW VECTOR_MAP_new_vector%VECTOR_MAP_recursion_count%
    FOR /L %%G IN (0, 1, !VECTOR_MAP_vector_length%VECTOR_MAP_recursion_count%!) DO (
        SET "VECTOR_MAP_index%VECTOR_MAP_recursion_count%=%%G"
        CALL :VECTOR_GET VECTOR_MAP_value%VECTOR_MAP_recursion_count% %2 VECTOR_MAP_index%VECTOR_MAP_recursion_count%
        CALL %3 VECTOR_MAP_mapped%VECTOR_MAP_recursion_count% VECTOR_MAP_value%VECTOR_MAP_recursion_count% %4
        CALL :VECTOR_PUSH VECTOR_MAP_new_vector%VECTOR_MAP_recursion_count% VECTOR_MAP_mapped%VECTOR_MAP_recursion_count%
    )
    SET "%1=!VECTOR_MAP_new_vector%VECTOR_MAP_recursion_count%!"
EXIT /B 0

:VECTOR_TO_LIST
    CALL :VECTOR_LENGTH VECTOR_TO_LIST_length %2
    SET "VECTOR_TO_LIST_list=!EMPTY_LIST!"
    SET /A "VECTOR_TO_LIST_length-=1"
    FOR /L %%G IN (0, 1, !VECTOR_TO_LIST_length!) DO (
        SET "VECTOR_TO_LIST_index=%%G"
        CALL :VECTOR_GET VECTOR_TO_LIST_value %2 VECTOR_TO_LIST_index
        CALL :LIST_CONS VECTOR_TO_LIST_list VECTOR_TO_LIST_value VECTOR_TO_LIST_list
    )
    CALL :LIST_REVERSE VECTOR_TO_LIST_list VECTOR_TO_LIST_list
    SET "%1=!VECTOR_TO_LIST_list!"
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

:STRING_EQUAL
    SET "STRING_EQUAL_first=_string_contents_!%2:~1,8191!"
    SET "STRING_EQUAL_second=_string_contents_!%3:~1,8191!"
    IF "!%STRING_EQUAL_first%!"=="!%STRING_EQUAL_second%!" (
        SET "%1=!TRUE!"
    ) ELSE (
        SET "%1=!FALSE!"
    )
EXIT /B 0

:STRING?
    IF "!%2:~0,1!"=="S" (
        SET "%1=!TRUE!"
    ) ELSE (
        SET "%1=!FALSE!"
    )
EXIT /B 0


:SYMBOL_NEW
    SET /a "_symbol_counter+=1"
    SET "_length=_symbol_length_!_symbol_counter!"
    CALL :STRLEN %_length% %2
    SET "_symbol_contents_!_symbol_counter!=!%2!"
    SET "%1=A!_symbol_counter!"
EXIT /B 0

:SYMBOL_LENGTH
    SET "_length=_symbol_length_!%2:~1,8191!"
    SET "%1=!%_length%!"
EXIT /B 0

:SYMBOL_TO_STR
    SET "_ref=_symbol_contents_!%2:~1,8191!"
    SET "%1=!%_ref%!"
EXIT /B 0

:SYMBOL_EQUAL
    SET "SYMBOL_EQUAL_first=_symbol_contents_!%2:~1,8191!"
    SET "SYMBOL_EQUAL_second=_symbol_contents_!%3:~1,8191!"
    IF "!%SYMBOL_EQUAL_first%!"=="!%SYMBOL_EQUAL_second%!" (
        SET "%1=!TRUE!"
    ) ELSE (
        SET "%1=!FALSE!"
    )
EXIT /B 0

:SYMBOL?
    IF "!%2:~0,1!"=="A" (
        SET "%1=!TRUE!"
    ) ELSE (
        SET "%1=!FALSE!"
    )
EXIT /B 0



:ATOM_NEW
    SET /a "_atom_counter+=1"
    SET "_atom_value_!_atom_counter!=!%2!"
    SET "%1=T!_atom_counter!"
EXIT /B 0

:ATOM_DEREF
    SET "_ref=_atom_value_!%2:~1,8191!"
    SET "%1=!%_ref%!"
EXIT /B 0

:ATOM_RESET
    SET "_ref=_atom_value_!%2:~1,8191!"
    SET "%_ref%=!%3!"
    SET "%1=!%3!"
EXIT /B 0

:ATOM?
    IF "!%2:~0,1!"=="T" (
        SET "%1=!TRUE!"
    ) ELSE (
        SET "%1=!FALSE!"
    )
EXIT /B 0


:FUNCTION_NEW
    SET /a "_function_counter+=1"
    SET "_function_name_!_function_counter!=!%2!"
    SET "_function_env_!_function_counter!=!%3!"
    SET "_function_params_!_function_counter!=!%4!"
    SET "_function_body_!_function_counter!=!%5!"
    SET "_function_is_macro_!_function_counter!=!FALSE!"
    SET "%1=F!_function_counter!"
EXIT /B 0

:FUNCTION_TO_STR
    SET "_ref=_function_name_!%2:~1,8191!"
    SET "%1=!%_ref%!"
EXIT /B 0

:FUNCTION_GET_ENV
    SET "_ref=_function_env_!%2:~1,8191!"
    SET "%1=!%_ref%!"
EXIT /B 0

:FUNCTION_MACRO?
    SET "_ref=_function_is_macro_!%2:~1,8191!"
    SET "%1=!%_ref%!"
EXIT /B 0

:FUNCTION_SET_IS_MACRO
    SET "_ref=_function_is_macro_!%1:~1,8191!"
    SET "%_ref%=!%2!"
EXIT /B 0

:FUNCTION_GET_PARAMS
    SET "_ref=_function_params_!%2:~1,8191!"
    SET "%1=!%_ref%!"
EXIT /B 0

:FUNCTION_GET_BODY
    SET "_ref=_function_body_!%2:~1,8191!"
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

:NUMBER_EQUAL
    SET "NUMBER_EQUAL_first=_number_value!%2:~1,8191!"
    SET "NUMBER_EQUAL_second=_number_value!%3:~1,8191!"
    IF "!%NUMBER_EQUAL_first%!"=="!%NUMBER_EQUAL_second%!" (
        SET "%1=!TRUE!"
    ) ELSE (
        SET "%1=!FALSE!"
    )
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

:HASHMAP_GET_REF
    SET "_HASHMAP_INDEX_OF_KEY_id=!%2:~1,8191!"
    SET "%1=!NIL!"

    SET "_HASHMAP_INDEX_OF_KEY_vector_id=!_hashmap_keys%_HASHMAP_INDEX_OF_KEY_id%:~1,8191!"
    SET "_HASHMAP_INDEX_OF_KEY_values_vector_id=!_hashmap_values%_HASHMAP_INDEX_OF_KEY_id%:~1,8191!"
    SET "_HASHMAP_INDEX_OF_KEY_length=!_vector_length_%_HASHMAP_INDEX_OF_KEY_vector_id%!"

    SET /a "_HASHMAP_INDEX_OF_KEY_length-=1"
    FOR /L %%G IN (0, 1, !_HASHMAP_INDEX_OF_KEY_length!) DO (
        SET "_HASHMAP_INDEX_OF_KEY_index=%%G"

        SET "_HASHMAP_INDEX_OF_KEY_key=!_vector_%_HASHMAP_INDEX_OF_KEY_vector_id%_%%G!"

        IF "!_HASHMAP_INDEX_OF_KEY_key!"=="!%3!" (
            SET "%1=_vector_%_HASHMAP_INDEX_OF_KEY_values_vector_id%_%%G"
        )
    )
EXIT /B 0

:HASHMAP_HAS_KEY?
    SET "HASHMAP_GET_id=!%2:~1,8191!"
    CALL :HASHMAP_GET_REF HASHMAP_GET_ref %2 %3
    IF "!HASHMAP_GET_ref!"=="!NIL!" (
        SET "%1=!FALSE!"
        EXIT /B 0
    )

    SET "%1=!TRUE!"
EXIT /B 0

:HASHMAP_GET
    SET "HASHMAP_GET_id=!%2:~1,8191!"
    CALL :HASHMAP_GET_REF HASHMAP_GET_ref %2 %3
    IF "!HASHMAP_GET_ref!"=="!NIL!" (
        SET "%1=!NIL!"
        EXIT /B 0
    )

    SET "%1=!%HASHMAP_GET_ref%!"
EXIT /B 0

:HASHMAP_KEYS
    SET "_id=!%2:~1,8191!"
    SET "_ref=_hashmap_keys!_id!"
    SET "%1=!%_ref%!"
EXIT /B 0

:HASHMAP_MAP
    SET /A "HASHMAP_MAP_recursion_count+=1"
    CALL :_HASHMAP_MAP %1 %2 %3 %4
    SET /A HASHMAP_MAP_recursion_count-=1"
EXIT /B 0

:_HASHMAP_MAP
    CALL :HASHMAP_KEYS HASHMAP_MAP_keys%HASHMAP_MAP_recursion_count% %2
    CALL :VECTOR_LENGTH HASHMAP_MAP_keys_length%HASHMAP_MAP_recursion_count% HASHMAP_MAP_keys%HASHMAP_MAP_recursion_count%
    SET /a "HASHMAP_MAP_keys_length%HASHMAP_MAP_recursion_count%-=1"
    CALL :HASHMAP_NEW HASHMAP_MAP_new_hashmap%HASHMAP_MAP_recursion_count%
    FOR /L %%G IN (0, 1, !HASHMAP_MAP_keys_length%HASHMAP_MAP_recursion_count%!) DO (
        SET "HASHMAP_MAP_index%HASHMAP_MAP_recursion_count%=%%G"
        CALL :VECTOR_GET HASHMAP_MAP_key%HASHMAP_MAP_recursion_count% HASHMAP_MAP_keys%HASHMAP_MAP_recursion_count% HASHMAP_MAP_index%HASHMAP_MAP_recursion_count%
        CALL :HASHMAP_GET HASHMAP_MAP_value%HASHMAP_MAP_recursion_count% %2 HASHMAP_MAP_key%HASHMAP_MAP_recursion_count%
        CALL %3 HASHMAP_MAP_mapped%HASHMAP_MAP_recursion_count% HASHMAP_MAP_value%HASHMAP_MAP_recursion_count% %4
        CALL :HASHMAP_INSERT HASHMAP_MAP_new_hashmap%HASHMAP_MAP_recursion_count% HASHMAP_MAP_key%HASHMAP_MAP_recursion_count% HASHMAP_MAP_mapped%HASHMAP_MAP_recursion_count%
    )
    SET "%1=!HASHMAP_MAP_new_hashmap%HASHMAP_MAP_recursion_count%!"
EXIT /B 0

:HASHMAP?
    IF "!%2:~0,1!"=="H" (
        SET "%1=!TRUE!"
    ) ELSE (
        SET "%1=!FALSE!"
    )
EXIT /B 0


:ERROR_NEW
    SET /a "_error_counter+=1"
    SET "_error_value!_error_counter!=!%2!"
    SET "%1=R!_error_counter!"
EXIT /B 0

:ERROR_TO_STR
    SET "_ref=_error_value!%2:~1,8191!"
    SET "%1=!%_ref%!"
EXIT /B 0

:ERROR_TO_STRING
    SET "ERROR_TO_STRING_str=_error_value!%2:~1,8191!"
    CALL :STRING_NEW %1 ERROR_TO_STRING_str
EXIT /B 0

:ERROR?
    IF "!%2:~0,1!"=="R" (
        SET "%1=!TRUE!"
    ) ELSE (
        SET "%1=!FALSE!"
    )
EXIT /B 0


:EQUAL?
    SET "EQUAL?_first=!%2!"
    SET "EQUAL?_second=!%3!"

    IF "!EQUAL?_first:~0,1!"=="V" (
        CALL :VECTOR_TO_LIST EQUAL?_first EQUAL?_first
    )
    IF "!EQUAL?_second:~0,1!"=="V" (
        CALL :VECTOR_TO_LIST EQUAL?_second EQUAL?_second
    )

    IF "!EQUAL?_first!"=="!EQUAL?_second!" (
        SET "%1=!TRUE!"
        EXIT /B 0
    ) ELSE (
        IF "!EQUAL?_first:~0,1!"=="!EQUAL?_second:~0,1!" (
            :: Types are the same
            IF "!EQUAL?_first:~0,1!"=="A" (
                CALL :SYMBOL_EQUAL %1 EQUAL?_first EQUAL?_second
                EXIT /B 0
            )
            IF "!EQUAL?_first:~0,1!"=="N" (
                CALL :NUMBER_EQUAL %1 EQUAL?_first EQUAL?_second
                EXIT /B 0
            )
            IF "!EQUAL?_first:~0,1!"=="S" (
                CALL :STRING_EQUAL %1 EQUAL?_first EQUAL?_second
                EXIT /B 0
            )
            IF "!EQUAL?_first:~0,1!"=="L" (
                CALL :LIST_EQUAL %1 EQUAL?_first EQUAL?_second
                EXIT /B 0
            )
        )
    )
    SET "%1=!FALSE!"
EXIT /B 0
