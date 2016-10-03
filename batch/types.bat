
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
