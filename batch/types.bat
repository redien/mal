
:NIL?
    IF "!%~2!"=="" (
        set "%~1=!TRUE!"
    ) ELSE (
        set "%~1=!FALSE!"
    )
EXIT /B 0

:CONS
    set /a "_list_counter+=1"
    set "_list_first_!_list_counter!=!%~2!"
    set "_list_rest_!_list_counter!=!%~3!"
    set "%~1=L!_list_counter!"
EXIT /B 0

:FIRST
    set "ref=_list_first_!%~2:~1,8191!"
    set "%1=!%ref%!"
EXIT /B 0

:REST
    set "ref=_list_rest_!%~2:~1,8191!"
    set "%1=!%ref%!"
EXIT /B 0

:LIST?
    IF "!%2!"=="!NIL!" (
        set "%~1=!TRUE!"
    ) ELSE (
        IF "!%~2:~0,1!"=="L" (
            set "%~1=!TRUE!"
        ) ELSE (
            set "%~1=!FALSE!"
        )
    )
EXIT /B 0

:LIST_REVERSE
    set "%1=!NIL!"
    call :_LIST_REVERSE %1 %2
EXIT /B 0

:_LIST_REVERSE
    IF "!%2!"=="!NIL!" (
        EXIT /B 0
    )

    call :FIRST LIST_REVERSE_first %2
    call :REST LIST_REVERSE_rest %2

    call :CONS %1 LIST_REVERSE_first %1

    call :_LIST_REVERSE %1 LIST_REVERSE_rest
EXIT /B 0

:LIST_MAP
    set "LIST_MAP_list%_recursive_count%=!NIL!"
    call :_LIST_MAP LIST_MAP_list%_recursive_count% %2 %3 %4
    call :LIST_REVERSE %1 LIST_MAP_list%_recursive_count%
EXIT /B 0

:_LIST_MAP
    IF "!%2!"=="!NIL!" (
        EXIT /B 0
    )

    call :FIRST LIST_MAP_first%_recursive_count% %2
    call :REST LIST_MAP_rest%_recursive_count% %2

    call %3 LIST_MAP_mapped%_recursive_count% LIST_MAP_first%_recursive_count% %4

    call :CONS %1 LIST_MAP_mapped%_recursive_count% %1

    call :_LIST_MAP %1 LIST_MAP_rest%_recursive_count% %3 %4
EXIT /B 0


:VECTOR_NEW
    set /a "_vector_counter+=1"
    set "_vector_length_!_vector_counter!=0"
    set "%1=V!_vector_counter!"
EXIT /B 0

:VECTOR_LENGTH
    set "_length=_vector_length_!%2:~1,8191!"
    set "%1=!%_length%!"
EXIT /B 0

:VECTOR_GET
    set "_ref=_vector_!%2:~1,8191!_!%3!"
    set "%1=!%_ref%!"
EXIT /B 0

:VECTOR_PUSH
    set "_id=!%1:~1,8191!"
    set "_length=_vector_length_!_id!"
    set "_ref=_vector_!_id!_!%_length%!"
    set "%_ref%=!%2!"
    set /a "%_length%+=1"
EXIT /B 0

:VECTOR?
    IF "!%2:~0,1!"=="V" (
        set "%1=!TRUE!"
    ) ELSE (
        set "%1=!FALSE!"
    )
EXIT /B 0

:STRING_NEW
    set /a "_string_counter+=1"
    set "_length=_string_length_!_string_counter!"
    call :STRLEN %_length% %2
    set "_string_contents_!_string_counter!=!%2!"
    set "%1=S!_string_counter!"
EXIT /B 0

:STRING_LENGTH
    set "_length=_string_length_!%2:~1,8191!"
    set "%1=!%_length%!"
EXIT /B 0

:STRING_TO_STR
    set "_ref=_string_contents_!%2:~1,8191!"
    set "%1=!%_ref%!"
EXIT /B 0

:STRING?
    IF "!%2:~0,1!"=="S" (
        set "%1=!TRUE!"
    ) ELSE (
        set "%1=!FALSE!"
    )
EXIT /B 0

:ATOM_NEW
    set /a "_atom_counter+=1"
    set "_length=_atom_length_!_atom_counter!"
    call :STRLEN %_length% %2
    set "_atom_contents_!_atom_counter!=!%2!"
    set "%1=A!_atom_counter!"
EXIT /B 0

:ATOM_LENGTH
    set "_length=_atom_length_!%2:~1,8191!"
    set "%1=!%_length%!"
EXIT /B 0

:ATOM_TO_STR
    set "_ref=_atom_contents_!%2:~1,8191!"
    set "%1=!%_ref%!"
EXIT /B 0

:ATOM?
    IF "!%2:~0,1!"=="A" (
        set "%1=!TRUE!"
    ) ELSE (
        set "%1=!FALSE!"
    )
EXIT /B 0

:FUNCTION_NEW
    set /a "_function_counter+=1"
    set "_function_name_!_function_counter!=!%2!"
    set "%1=F!_function_counter!"
EXIT /B 0

:FUNCTION_TO_STR
    set "_ref=_function_name_!%2:~1,8191!"
    set "%1=!%_ref%!"
EXIT /B 0

:FUNCTION?
    IF "!%2:~0,1!"=="F" (
        set "%1=!TRUE!"
    ) ELSE (
        set "%1=!FALSE!"
    )
EXIT /B 0

:NUMBER_NEW
    set /a "_number_counter+=1"
    set "_number_value!_number_counter!=!%2!"
    set "%1=N!_number_counter!"
EXIT /B 0

:NUMBER_TO_STR
    set "_ref=_number_value!%2:~1,8191!"
    set "%1=!%_ref%!"
EXIT /B 0

:NUMBER_TO_STRING
    set "NUMBER_TO_STRING_str=_number_value!%2:~1,8191!"
    call :STRING_NEW %1 NUMBER_TO_STRING_str
EXIT /B 0

:NUMBER?
    IF "!%2:~0,1!"=="N" (
        set "%1=!TRUE!"
    ) ELSE (
        set "%1=!FALSE!"
    )
EXIT /B 0


:HASHMAP_NEW
    set /a "_hashmap_counter+=1"
    call :VECTOR_NEW _hashmap_keys!_hashmap_counter!
    call :VECTOR_NEW _hashmap_values!_hashmap_counter!
    set "%1=H!_hashmap_counter!"
EXIT /B 0

:HASHMAP_INSERT
    set "HASHMAP_INSERT_id=!%1:~1,8191!"
    call :VECTOR_PUSH _hashmap_keys!HASHMAP_INSERT_id! %2
    call :VECTOR_PUSH _hashmap_values!HASHMAP_INSERT_id! %3
EXIT /B 0

:_HASHMAP_INDEX_OF_KEY
    set "_HASHMAP_INDEX_OF_KEY_id=!%2:~1,8191!"
    set "%1=!NIL!"
    call :VECTOR_LENGTH _HASHMAP_INDEX_OF_KEY_length _hashmap_keys!_HASHMAP_INDEX_OF_KEY_id!
    set /a "_HASHMAP_INDEX_OF_KEY_length-=1"
    FOR /L %%G IN (0, 1, !_HASHMAP_INDEX_OF_KEY_length!) DO (
        set "_HASHMAP_INDEX_OF_KEY_index=%%G"
        call :VECTOR_GET _HASHMAP_INDEX_OF_KEY_key _hashmap_keys!_HASHMAP_INDEX_OF_KEY_id! _HASHMAP_INDEX_OF_KEY_index
        IF "!_HASHMAP_INDEX_OF_KEY_key!"=="!%3!" (
            set "%1=%%G"
        )
    )
EXIT /B 0

:HASHMAP_GET
    set "HASHMAP_GET_id=!%2:~1,8191!"
    call :_HASHMAP_INDEX_OF_KEY HASHMAP_GET_key_index %2 %3
    IF "!HASHMAP_GET_key_index!"=="!NIL!" (
        set "%1=!NIL!"
        EXIT /B 0
    )

    call :VECTOR_GET %1 _hashmap_values!HASHMAP_GET_id! HASHMAP_GET_key_index
EXIT /B 0

:HASHMAP_KEYS
    set "_id=!%2:~1,8191!"
    set "_ref=_hashmap_keys!_id!"
    set "%1=!%_ref%!"
EXIT /B 0

:HASHMAP?
    IF "!%2:~0,1!"=="H" (
        set "%1=!TRUE!"
    ) ELSE (
        set "%1=!FALSE!"
    )
EXIT /B 0
