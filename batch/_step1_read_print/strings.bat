
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
        set "STRING_CONTAINS_CHAR_string=!STRING_CONTAINS_CHAR_string:~1,2147483647!"
        GOTO :STRING_CONTAINS_CHAR_LOOP
    )
EXIT /B 0
