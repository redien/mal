
:read_str
    set "test=abc"
    set "test2=123"
    %pushs%test%pushe%
    echo !stack1!
    %pushs%test2%pushe%
    echo !stack2!
    %pops%var%pope%
    %pops%var2%pope%
    echo !%var%!
    echo !%var2%!
EXIT /B 0

