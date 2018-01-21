
:_trim
    set trimmed=%*
exit /b 0

:read_str
%do%
    %pops%s%pope%
    call :_trim !%s%!
    %pushs%trimmed%pushe%
goto !%end%!

