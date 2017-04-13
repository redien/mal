
:SUBSTRING
    SET "SUBSTRING_start=!%~3!"
    SET "SUBSTRING_length=!%~4!"
    CALL :_SUBSTRING %~1 %~2 %SUBSTRING_start% %SUBSTRING_length%
EXIT /B 0

:_SUBSTRING
    SET /a "_SUBSTRING_end=%~3+%~4-1"
    SET "%~1=!%~2:~%~3,%_SUBSTRING_end%!"
EXIT /B 0

:STRING_CONTAINS_CHAR
    SET "STRING_CONTAINS_CHAR_string=!%~2!"
    SET "STRING_CONTAINS_CHAR_char=!%~3!"

:STRING_CONTAINS_CHAR_LOOP
    IF "!STRING_CONTAINS_CHAR_string!"=="" (
        SET "%~1=!FALSE!"
    )

    IF "!STRING_CONTAINS_CHAR_string:~0,1!"=="!STRING_CONTAINS_CHAR_char!" (
        SET "%~1=!TRUE!"
    ) ELSE (
        SET "STRING_CONTAINS_CHAR_string=!STRING_CONTAINS_CHAR_string:~1,8191!"
        GOTO :STRING_CONTAINS_CHAR_LOOP
    )
EXIT /B 0

:STRLEN
    SET "STRLEN_buffer=#!%2!"
    SET "STRLEN_length=0"
    FOR %%N IN (8192 4096 2048 1024 512 256 128 64 32 16 8 4 2 1) DO (
        IF NOT "!STRLEN_buffer:~%%N,1!"=="" (
            SET /a "STRLEN_length+=%%N"
            SET "STRLEN_buffer=!STRLEN_buffer:~%%N!"
        )
    )
    SET "%1=%STRLEN_length%"
EXIT /B 0

:STRING_REPLACE_CHAR
    SET "STRING_REPLACE_CHAR_dest="
    SET "STRING_REPLACE_CHAR_source=!%2!"

:STRING_REPLACE_CHAR_LOOP
    IF "!STRING_REPLACE_CHAR_source!"=="" (
        SET "%1=!STRING_REPLACE_CHAR_dest!"
        EXIT /B 0
    )

    SET "STRING_REPLACE_CHAR_char=!STRING_REPLACE_CHAR_source:~0,1!"
    SET "STRING_REPLACE_CHAR_source=!STRING_REPLACE_CHAR_source:~1,8191!"

    IF "!STRING_REPLACE_CHAR_char!"=="!%3!" (
        SET "STRING_REPLACE_CHAR_dest=!STRING_REPLACE_CHAR_dest!!%4!"
        GOTO :STRING_REPLACE_CHAR_LOOP
    )

    SET "STRING_REPLACE_CHAR_dest=!STRING_REPLACE_CHAR_dest!!STRING_REPLACE_CHAR_char!"
    GOTO :STRING_REPLACE_CHAR_LOOP
EXIT /B 0
