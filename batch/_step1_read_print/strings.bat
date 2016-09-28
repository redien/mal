
:SUBSTRING
    set "SUBSTRING_start=!%~3!"
    set "SUBSTRING_length=!%~4!"
    call :_SUBSTRING %~1 %~2 %SUBSTRING_start% %SUBSTRING_length%
EXIT /B 0

:_SUBSTRING
    set /a "_SUBSTRING_end=%~3+%~4-1"
    set "%~1=!%~2:~%~3,%_SUBSTRING_end%!"
EXIT /B 0

:STRING_CONTAINS_CHAR
    set "STRING_CONTAINS_CHAR_string=!%~2!"
    set "STRING_CONTAINS_CHAR_char=!%~3!"

:STRING_CONTAINS_CHAR_LOOP
    IF "!STRING_CONTAINS_CHAR_string!"=="" (
        set "%~1=!FALSE!"
    )

    IF "!STRING_CONTAINS_CHAR_string:~0,1!"=="!STRING_CONTAINS_CHAR_char!" (
        set "%~1=!TRUE!"
    ) ELSE (
        set "STRING_CONTAINS_CHAR_string=!STRING_CONTAINS_CHAR_string:~1,8191!"
        GOTO :STRING_CONTAINS_CHAR_LOOP
    )
EXIT /B 0

:STRING_LENGTH
    set "STRING_LENGTH_buffer=#!%2!"
    set "STRING_LENGTH_length=0"
    FOR %%N IN (8192 4096 2048 1024 512 256 128 64 32 16 8 4 2 1) DO (
        IF NOT "!STRING_LENGTH_buffer:~%%N,1!"=="" (
            set /a "STRING_LENGTH_length+=%%N"
            set "STRING_LENGTH_buffer=!STRING_LENGTH_buffer:~%%N!"
        )
    )
    set "%1=%STRING_LENGTH_length%"
EXIT /B 0
