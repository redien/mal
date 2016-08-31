@echo off
set "_label=%1"
shift
goto %_label%

:STRLEN
    set "s=!%~2!#"
    set "len=0"
    for %%P in (131072 65536 32768 16384 8192 4096 2048 1024 512 256 128 64 32 16 8 4 2 1) do (
        if "!s:~%%P,1!" NEQ "" (
            set /a "len+=%%P"
            set "s=!s:~%%P!"
        )
    )
    set "%~1=%len%"
EXIT /B 0

:PAD_NUMBER
    call :STRLEN _length %~1
    if !_length! GEQ 6 (EXIT /B 0)
    set "%~1=0!%~1!"
goto :PAD_NUMBER

:NIL
    set "%~1=2"
EXIT /B 0

:NIL?
    if "!%~2!"=="2" (set "%~1=1" & EXIT /B 1)
    set "%~1=0"
EXIT /B 0

:INTEGER
    set "%~1=3!%~2!"
EXIT /B 0

:INTEGER?
    if "!%~2:~0,1!"=="3" (set "%~1=1" & EXIT /B 1)
    set "%~1=0"
EXIT /B 0

:INTEGER_VALUE
    set "%~1=!%~2:~1!"
EXIT /B 0

:STRING
    set "%~1=4!%~2!"
EXIT /B 0

:STRING?
    if "!%~2:~0,1!"=="4" (set "%~1=1" & EXIT /B 1)
    set "%~1=0"
EXIT /B 0

:STRING_VALUE
    set "%~1=!%~2:~1!"
EXIT /B 0

:NEW_OBJECT_ID
    set "%~1=%__object_id%"
    set /a "__object_id+=1"
EXIT /B 0

:LIST?
    if "!%~2:~0,1!"=="5" (set "%~1=1" & EXIT /B 1)
    set "%~1=0"
EXIT /B 0
