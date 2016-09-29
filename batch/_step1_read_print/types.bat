
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
    set "length=_vector_length_!%2:~1,8191!"
    set "%1=!%length%!"
EXIT /B 0

:VECTOR_GET
    set "ref=_vector_!%2:~1,8191!_!%3!"
    set "%1=!%ref%!"
EXIT /B 0

:VECTOR_PUSH
    set "id=!%1:~1,8191!"
    set "length=_vector_length_!id!"
    set "ref=_vector_!id!_!%length%!"
    set "%ref%=!%2!"
    set /a "%length%+=1"
EXIT /B 0

:VECTOR?
    IF "!%2:~0,1!"=="V" (
        set "%1=!TRUE!"
    ) ELSE (
        set "%1=!FALSE!"
    )
EXIT /B 0
