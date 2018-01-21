
:_trim
    set trimmed=%*
exit /b 0

:read_str :: String s
    %pops%return_label%pope%
    %pops%s%pope%
    call :_trim !%s%!
    %pushs%trimmed%pushe%
goto !%return_label%!

