:start

:repl
    set "_input="
    set /p "_input=user> "
	
    :: If nothing is written, empty the input and reSET the error level
    IF  errorlevel 1 SET "_input=" & verify>nul
    :: Exit command used for testing purposes
    IF "!_input!"=="exit" EXIT
    
    set "return_label=:repl_1"
    %pushs%_input%pushe%
    %pushs%return_label%pushe%
    goto :read_str
:repl_1
    %pops%output%pope%
    echo !%output%!
goto :repl

