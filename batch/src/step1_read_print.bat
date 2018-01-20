:start

call :read_str

:repl
    set "_input="
    set /p "_input=user> "
	
    :: If nothing is written, empty the input and reSET the error level
    IF  errorlevel 1 SET "_input=" & verify>nul
    :: Exit command used for testing purposes
    IF "!_input!"=="exit" EXIT
	
    echo !_input!
goto :repl

