
:ENV_NEW
    SET /a "_env_counter+=1"
    SET "_env_outer!_env_counter!=!NIL!"
    CALL :HASHMAP_NEW _env_data!_env_counter!
    SET "%1=E!_env_counter!"
EXIT /B 0

:ENV_SET_OUTER
    SET "ENV_SET_id=!%1:~1,8191!"
    SET "_env_outer!ENV_SET_id!=!%2!"
EXIT /B 0

:ENV_SET
    SET "ENV_SET_id=!%1:~1,8191!"
    CALL :SYMBOL_TO_STR ENV_SET_key %2
    CALL :HASHMAP_INSERT _env_data!ENV_SET_id! ENV_SET_key %3
EXIT /B 0

:ENV_GET
    SET "ENV_GET_id=!%2:~1,8191!"
    CALL :SYMBOL_TO_STR ENV_GET_key %3

:ENV_GET_RECUR
    CALL :HASHMAP_GET_REF ENV_GET_ref _env_data!ENV_GET_id! ENV_GET_key
    IF "!ENV_GET_ref!"=="!NIL!" (
        IF NOT "!_env_outer%ENV_GET_id%!"=="!NIL!" (
            SET "ENV_GET_id=!_env_outer%ENV_GET_id%:~1,8191!"
            GOTO :ENV_GET_RECUR
        )

        SET "ENV_GET_error=Not defined: !ENV_GET_key!"
        CALL :ERROR_NEW %1 ENV_GET_error
        EXIT /B 0
    )

    SET "%1=!%ENV_GET_ref%!"
EXIT /B 0
