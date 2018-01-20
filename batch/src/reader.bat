
:read_str
    set "test=abc"
    set "test2=123"
    %pushs%test%pushe%
    %pushs%test2%pushe%
    %pops%var%pope%
    %pops%var2%pope%
    echo !var!!var2!
EXIT /B 0

