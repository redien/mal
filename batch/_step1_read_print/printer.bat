
:PR_STR
    set "_recursive_count=0"
    call :_PR_STR %1 %2
EXIT /B 0

:_PR_STR
    set /a "_recursive_count+=1"

    call :ATOM? PR_STR_is_atom %2
    IF "!PR_STR_is_atom!"=="!TRUE!" (
        call :ATOM_TO_STR PR_STR_tmp %2
        set "%1=!PR_STR_tmp!"
        set /a "_recursive_count-=1"
        EXIT /B 0
    )

    call :VECTOR? PR_STR_is_vector %2
    IF "!PR_STR_is_vector!"=="!TRUE!" (
        call :VECTOR_LENGTH PR_STR_length %2
        set /a "PR_STR_length-=1"
        set "%1=("
        FOR /L %%G IN (0, 1, !PR_STR_length!) DO (
            set "PR_STR_index=%%G"
            call :VECTOR_GET PR_STR_item%_recursive_count% %2 PR_STR_index
            call :_PR_STR PR_STR_str%_recursive_count% PR_STR_item%_recursive_count%
            IF %%G NEQ 0 (
                set "%1=!%1! "
            )
            set "%1=!%1!!PR_STR_str%_recursive_count%!"
        )
        set "%1=!%1!)"

        set /a "_recursive_count-=1"
        EXIT /B 0
    )

    call :ABORT "Unexpected type !%2:~0,1!"
EXIT /B 0
