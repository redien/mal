
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
    IF "!%~2:~0,1!"=="L" (
        set "%~1=!TRUE!"
    ) ELSE (
        set "%~1=!FALSE!"
    )
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
