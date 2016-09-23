
set "NIL="
set "TRUE=t"
set "FALSE=f"

:NIL?
    IF "!%~2!"=="" (
        set "%~1=!TRUE!"
    ) ELSE (
        set "%~1=!FALSE!"
    )
EXIT /B 0

:CONS
    set "_list_first_!_list_counter!=!%~2!"
    set "_list_rest_!_list_counter!=!%~3!"
    set /a "_list_counter+=1"
    set "%~1=L!_list_counter!"
EXIT /B 0

:FIRST
:: Need to figure out how to dereference these
    set "ref=_list_first_!%~2:~1,2147483647!"
    set "%1=!%ref%!"
EXIT /B 0

:REST
    set "ref=_list_rest_!%~2:~1,2147483647!"
    set "%1=!%ref%!"
EXIT /B 0

:LIST?
    IF "!%~2:~0,1!"=="L" (
        set "%~1=!TRUE!"
    ) ELSE (
        set "%~1=!FALSE!"
    )
EXIT /B 0
