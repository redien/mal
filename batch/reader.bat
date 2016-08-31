@echo off
set "_label=%1"
shift
goto %_label%

:PEEK_CHARACTER
    REM Read a character into _read_character.
    REM Reads "EOF" if the buffer is empty.
    IF NOT "!_reader_buffer!"=="" set "_read_character=!_reader_buffer:~0,1!"
    IF "!_reader_buffer!"=="" set "_read_character=EOF"
EXIT /B 0

:READ_CHARACTER
    call :PEEK_CHARACTER
    REM Remove the character we just read
    set "_reader_buffer=!_reader_buffer:~1,2147483647!"
EXIT /B 0

:READ_STRING

EXIT /B 0
