
:DEFINE_FUN
    CALL :FUNCTION_NEW DEFINE_FUN_value %3 NIL NIL NIL
    CALL :SYMBOL_NEW DEFINE_FUN_key %2
    CALL :ENV_SET %1 DEFINE_FUN_key DEFINE_FUN_value
EXIT /B 0

:START

CALL :ENV_NEW REPL_env
CALL :DEFINE_FUN REPL_env _plus :MAL_NUMBER_ADD
CALL :DEFINE_FUN REPL_env _minus :MAL_NUMBER_SUBTRACT
CALL :DEFINE_FUN REPL_env _asterisk :MAL_NUMBER_MULTIPLY
CALL :DEFINE_FUN REPL_env _slash :MAL_NUMBER_DIVIDE
CALL :DEFINE_FUN REPL_env _greater_than :MAL_GREATER_THAN
CALL :DEFINE_FUN REPL_env _lower_than :MAL_LOWER_THAN
CALL :DEFINE_FUN REPL_env _greater_than_equal :MAL_GREATER_THAN_OR_EQUAL
CALL :DEFINE_FUN REPL_env _lower_than_equal :MAL_LOWER_THAN_OR_EQUAL
CALL :DEFINE_FUN REPL_env _equal :MAL_EQUAL

SET "_name=cons"
CALL :DEFINE_FUN REPL_env _name :MAL_CONS
SET "_name=first"
CALL :DEFINE_FUN REPL_env _name :MAL_FIRST
SET "_name=rest"
CALL :DEFINE_FUN REPL_env _name :MAL_REST
SET "_name=nth"
CALL :DEFINE_FUN REPL_env _name :MAL_NTH
SET "_name=concat"
CALL :DEFINE_FUN REPL_env _name :MAL_CONCAT
SET "_name=str"
CALL :DEFINE_FUN REPL_env _name :MAL_STR
SET "_name=prn"
CALL :DEFINE_FUN REPL_env _name :MAL_PRN
SET "_name=pr-str"
CALL :DEFINE_FUN REPL_env _name :MAL_PR_STR
SET "_name=println"
CALL :DEFINE_FUN REPL_env _name :MAL_PRINTLN
SET "_name=list"
CALL :DEFINE_FUN REPL_env _name :MAL_LIST
SET "_name=list?"
CALL :DEFINE_FUN REPL_env _name :MAL_LIST?
SET "_name=empty?"
CALL :DEFINE_FUN REPL_env _name :MAL_EMPTY?
SET "_name=count"
CALL :DEFINE_FUN REPL_env _name :MAL_COUNT
SET "_name=read-string"
CALL :DEFINE_FUN REPL_env _name :MAL_READ_STRING
SET "_name=eval"
CALL :DEFINE_FUN REPL_env _name :MAL_EVAL
SET "_name=slurp"
CALL :DEFINE_FUN REPL_env _name :MAL_SLURP
SET "_name=symbol"
CALL :DEFINE_FUN REPL_env _name :MAL_ATOM
SET "_name=symbol?"
CALL :DEFINE_FUN REPL_env _name :MAL_ATOM?
SET "_name=deref"
CALL :DEFINE_FUN REPL_env _name :MAL_ATOM_DEREF
SET "_name=reset^!"
CALL :DEFINE_FUN REPL_env _name :MAL_ATOM_RESET

SET "_script=(def^! not (fn* (a) (if a false true)))"
CALL :REP _ _script REPL_env
SET "_script=(def^! load-file (fn* (f) (eval (read-string (str ^"(do ^" (slurp f) ^")^")))))"
CALL :REP _ _script REPL_env
SET "_script=(def^! swap^! (fn* (a f & more) (reset^! a (eval (cons f (cons (deref a) more))))))"
CALL :REP _ _script REPL_env
SET "_script=(defmacro^! cond (fn* (& xs) (if (> (count xs) 0) (list 'if (first xs) (if (> (count xs) 1) (nth xs 1) (throw "odd number of forms to cond")) (cons 'cond (rest (rest xs)))))))"
CALL :REP _ _script REPL_env
SET "_script=(defmacro^! or (fn* (& xs) (if (empty? xs) nil (if (= 1 (count xs)) (first xs) `(let* (or_FIXME ~(first xs)) (if or_FIXME or_FIXME (or ~@(rest xs))))))))"
CALL :REP _ _script REPL_env

SET "argv=!EMPTY_LIST!"
SET "argv_key=!_asterisk!ARGV!_asterisk!"
SET "arg=!%5!"
IF NOT "!arg!"=="" CALL :LIST_CONS argv arg argv
SET "arg=!%4!"
IF NOT "!arg!"=="" CALL :LIST_CONS argv arg argv
SET "arg=!%3!"
IF NOT "!arg!"=="" CALL :LIST_CONS argv arg argv
SET "arg=!%2!"
IF NOT "!arg!"=="" CALL :LIST_CONS argv arg argv
CALL :SYMBOL_NEW argv_key_symbol argv_key
CALL :ENV_SET REPL_env argv_key_symbol argv

:REPL
    SET "_input="
    :: prompt the user and assign the user's input to _input.
    SET /p "_input=user> "
    :: If nothing is written, empty the input and reSET the error level
    IF  errorlevel 1 SET "_input=" & verify>nul
    :: Exit command used for testing purposes
    IF "!_input!"=="exit" EXIT

    CALL :REP _result _input REPL_env

    CALL :ECHO _result
GOTO :REPL

:REP
    CALL :READ REP_read %2
    CALL :EVAL REP_evaled REP_read %3
    CALL :PRINT %1 REP_evaled
EXIT /B 0

:READ
    CALL :READ_STR %1 %2
EXIT /B 0

:PRINT
    CALL :PR_STR %1 %2 TRUE
EXIT /B 0

:EVAL_AST
    CALL :LIST? EVAL_AST_is_list %2
    IF "!EVAL_AST_is_list!"=="!TRUE!" (
        CALL :LIST_MAP %1 %2 :EVAL %3
        EXIT /B 0
    )

    CALL :VECTOR? EVAL_AST_is_vector %2
    IF "!EVAL_AST_is_vector!"=="!TRUE!" (
        CALL :VECTOR_MAP %1 %2 :EVAL %3
        EXIT /B 0
    )

    CALL :HASHMAP? EVAL_AST_is_hashmap %2
    IF "!EVAL_AST_is_hashmap!"=="!TRUE!" (
        CALL :HASHMAP_MAP %1 %2 :EVAL %3
        EXIT /B 0
    )

    CALL :SYMBOL? EVAL_AST_is_symbol %2
    IF "!EVAL_AST_is_symbol!"=="!TRUE!" (
        CALL :SYMBOL_TO_STR EVAL_AST_symbol_str %2
        IF NOT "!EVAL_AST_symbol_str:~0,1!"=="!_colon!" (
            CALL :ENV_GET %1 %3 %2
            EXIT /B 0
        )
    )

    SET "%1=!%2!"
EXIT /B 0

:EVAL_DEF_LIST
    SET /a "EVAL_DEF_LIST_recursion_count+=1"

    SET "EVAL_DEF_LIST_list%EVAL_DEF_LIST_recursion_count%=!%2!"
:_EVAL_DEF_LIST
    CALL :LIST_FIRST EVAL_DEF_LIST_key%EVAL_DEF_LIST_recursion_count% EVAL_DEF_LIST_list%EVAL_DEF_LIST_recursion_count%
    CALL :LIST_REST EVAL_DEF_LIST_list%EVAL_DEF_LIST_recursion_count% EVAL_DEF_LIST_list%EVAL_DEF_LIST_recursion_count%

    CALL :LIST_FIRST EVAL_DEF_LIST_value%EVAL_DEF_LIST_recursion_count% EVAL_DEF_LIST_list%EVAL_DEF_LIST_recursion_count%
    CALL :LIST_REST EVAL_DEF_LIST_list%EVAL_DEF_LIST_recursion_count% EVAL_DEF_LIST_list%EVAL_DEF_LIST_recursion_count%

    CALL :EVAL EVAL_DEF_LIST_evaluated_value%EVAL_DEF_LIST_recursion_count% EVAL_DEF_LIST_value%EVAL_DEF_LIST_recursion_count% %1

    CALL :ENV_SET %1 EVAL_DEF_LIST_key%EVAL_DEF_LIST_recursion_count% EVAL_DEF_LIST_evaluated_value%EVAL_DEF_LIST_recursion_count%

    IF NOT "!EVAL_DEF_LIST_list%EVAL_DEF_LIST_recursion_count%!"=="!EMPTY_LIST!" (
        GOTO :_EVAL_DEF_LIST
    )

    SET /a "EVAL_DEF_LIST_recursion_count-=1"
EXIT /B 0

:EVAL
    SET /a "EVAL_recursion_count+=1"
    SET "EVAL_ast%EVAL_recursion_count%=!%2!"
    SET "EVAL_env%EVAL_recursion_count%=!%3!"
:EVAL_RECUR
    CALL :MACRO_EXPAND EVAL_ast%EVAL_recursion_count% EVAL_ast%EVAL_recursion_count% EVAL_env%EVAL_recursion_count%

    CALL :LIST? EVAL_is_list%EVAL_recursion_count% EVAL_ast%EVAL_recursion_count%
    IF "!EVAL_is_list%EVAL_recursion_count%!"=="!TRUE!" (
        IF "!EVAL_ast%EVAL_recursion_count%!"=="!EMPTY_LIST!" (
            SET "%1=!EMPTY_LIST!"
            GOTO :EVAL_EXIT
        )

        CALL :LIST_FIRST EVAL_first_form%EVAL_recursion_count% EVAL_ast%EVAL_recursion_count%
        CALL :LIST_REST EVAL_rest%EVAL_recursion_count% EVAL_ast%EVAL_recursion_count%
        CALL :SYMBOL? EVAL_is_symbol%EVAL_recursion_count% EVAL_first_form%EVAL_recursion_count%
        IF "!EVAL_is_symbol%EVAL_recursion_count%!"=="!TRUE!" (
            CALL :SYMBOL_TO_STR EVAL_first_symbol_str%EVAL_recursion_count% EVAL_first_form%EVAL_recursion_count%
            IF "!EVAL_first_symbol_str%EVAL_recursion_count%!"=="fn*" (
                CALL :LIST_FIRST EVAL_params%EVAL_recursion_count% EVAL_rest%EVAL_recursion_count%
                CALL :LIST_REST EVAL_rest%EVAL_recursion_count% EVAL_rest%EVAL_recursion_count%
                CALL :LIST_FIRST EVAL_body%EVAL_recursion_count% EVAL_rest%EVAL_recursion_count%

                SET "EVAL_lambda_function%EVAL_recursion_count%=:MAL_LAMBDA"
                CALL :FUNCTION_NEW %1 EVAL_lambda_function%EVAL_recursion_count% EVAL_env%EVAL_recursion_count% EVAL_params%EVAL_recursion_count% EVAL_body%EVAL_recursion_count%
                GOTO :EVAL_EXIT
            )

            SET "EVAL_function_or_macro%EVAL_recursion_count%=!FALSE!"
            IF "!EVAL_first_symbol_str%EVAL_recursion_count%!"=="def^!" (
                SET "EVAL_function_or_macro%EVAL_recursion_count%=!TRUE!"
            )

            IF "!EVAL_first_symbol_str%EVAL_recursion_count%!"=="defmacro^!" (
                SET "EVAL_function_or_macro%EVAL_recursion_count%=!TRUE!"
            )

            IF "!EVAL_function_or_macro%EVAL_recursion_count%!"=="!TRUE!" (
                CALL :LIST_FIRST EVAL_key%EVAL_recursion_count% EVAL_rest%EVAL_recursion_count%
                CALL :LIST_REST EVAL_rest%EVAL_recursion_count% EVAL_rest%EVAL_recursion_count%
                CALL :LIST_FIRST EVAL_value%EVAL_recursion_count% EVAL_rest%EVAL_recursion_count%
                CALL :EVAL EVAL_evaluated_value%EVAL_recursion_count% EVAL_value%EVAL_recursion_count% EVAL_env%EVAL_recursion_count%
                IF "!EVAL_evaluated_value%EVAL_recursion_count%!"=="!NIL!" (
                    SET "%1=!NIL!"
                    GOTO :EVAL_EXIT
                )
                IF "!EVAL_first_symbol_str%EVAL_recursion_count%!"=="defmacro^!" (
                    CALL :FUNCTION_SET_IS_MACRO EVAL_evaluated_value%EVAL_recursion_count% TRUE
                )
                CALL :ENV_SET EVAL_env%EVAL_recursion_count% EVAL_key%EVAL_recursion_count% EVAL_evaluated_value%EVAL_recursion_count%
                SET "%1=!EVAL_evaluated_value%EVAL_recursion_count%!"
                GOTO :EVAL_EXIT
            )

            IF "!EVAL_first_symbol_str%EVAL_recursion_count%!"=="quote" (
                CALL :LIST_FIRST %1 EVAL_rest%EVAL_recursion_count%
                GOTO :EVAL_EXIT
            )

            IF "!EVAL_first_symbol_str%EVAL_recursion_count%!"=="quasiquote" (
                CALL :LIST_FIRST EVAL_expression%EVAL_recursion_count% EVAL_rest%EVAL_recursion_count%
                CALL :QUASIQUOTE EVAL_ast%EVAL_recursion_count% EVAL_expression%EVAL_recursion_count%
                GOTO :EVAL_RECUR
            )

            IF "!EVAL_first_symbol_str%EVAL_recursion_count%!"=="macroexpand" (
                CALL :LIST_FIRST EVAL_expression%EVAL_recursion_count% EVAL_rest%EVAL_recursion_count%
                CALL :MACRO_EXPAND %1 EVAL_expression%EVAL_recursion_count% EVAL_env%EVAL_recursion_count%
                GOTO :EVAL_EXIT
            )

            IF "!EVAL_first_symbol_str%EVAL_recursion_count%!"=="do" (
                CALL :LIST_REST EVAL_list%EVAL_recursion_count% EVAL_ast%EVAL_recursion_count%

                CALL :LIST_LAST EVAL_ast%EVAL_recursion_count% EVAL_list%EVAL_recursion_count%
                CALL :LIST_WITHOUT_LAST EVAL_list%EVAL_recursion_count% EVAL_list%EVAL_recursion_count%

                CALL :EVAL_AST EVAL_evaluated_list%EVAL_recursion_count% EVAL_list%EVAL_recursion_count% EVAL_env%EVAL_recursion_count%
                CALL :LIST_FIND EVAL_error%EVAL_recursion_count% EVAL_evaluated_list%EVAL_recursion_count% :ERROR?
                IF NOT "!EVAL_error%EVAL_recursion_count%!"=="!NIL!" (
                    SET "%1=!EVAL_error%EVAL_recursion_count%!"
                    GOTO :EVAL_EXIT
                )

                GOTO :EVAL_RECUR
            )

            IF "!EVAL_first_symbol_str%EVAL_recursion_count%!"=="if" (
                CALL :LIST_FIRST EVAL_predicate%EVAL_recursion_count% EVAL_rest%EVAL_recursion_count%
                CALL :LIST_REST EVAL_rest%EVAL_recursion_count% EVAL_rest%EVAL_recursion_count%
                CALL :LIST_FIRST EVAL_true_expression%EVAL_recursion_count% EVAL_rest%EVAL_recursion_count%

                CALL :EVAL EVAL_evaluated_predicate%EVAL_recursion_count% EVAL_predicate%EVAL_recursion_count% EVAL_env%EVAL_recursion_count%
                CALL :ERROR? EVAL_evaluated_predicate_is_error%EVAL_recursion_count% EVAL_evaluated_predicate%EVAL_recursion_count%
                IF "!EVAL_evaluated_predicate_is_error%EVAL_recursion_count%!"=="!TRUE!" (
                    SET "%1=!EVAL_evaluated_predicate%EVAL_recursion_count%!"
                    GOTO :EVAL_EXIT
                )

                SET "EVAL_is_falsey%EVAL_recursion_count%=!FALSE!"
                IF "!EVAL_evaluated_predicate%EVAL_recursion_count%!"=="!FALSE!" (
                    SET "EVAL_is_falsey%EVAL_recursion_count%=!TRUE!"
                )
                IF "!EVAL_evaluated_predicate%EVAL_recursion_count%!"=="!NIL!" (
                    SET "EVAL_is_falsey%EVAL_recursion_count%=!TRUE!"
                )

                IF "!EVAL_is_falsey%EVAL_recursion_count%!"=="!TRUE!" (
                    CALL :LIST_REST EVAL_rest%EVAL_recursion_count% EVAL_rest%EVAL_recursion_count%
                    IF NOT "!EVAL_rest%EVAL_recursion_count%!"=="!EMPTY_LIST!" (
                        CALL :LIST_FIRST EVAL_ast%EVAL_recursion_count% EVAL_rest%EVAL_recursion_count%
                        GOTO :EVAL_RECUR
                    ) ELSE (
                        SET "%1=!NIL!"
                        GOTO :EVAL_EXIT
                    )
                ) ELSE (
                    SET "EVAL_ast%EVAL_recursion_count%=!EVAL_true_expression%EVAL_recursion_count%!"
                    GOTO :EVAL_RECUR
                )
            )

            IF "!EVAL_first_symbol_str%EVAL_recursion_count%!"=="let*" (
                CALL :ENV_NEW EVAL_let_env%EVAL_recursion_count%
                CALL :ENV_SET_OUTER EVAL_let_env%EVAL_recursion_count% EVAL_env%EVAL_recursion_count%

                CALL :LIST_FIRST EVAL_def_list%EVAL_recursion_count% EVAL_rest%EVAL_recursion_count%

                CALL :VECTOR? EVAL_is_vector%EVAL_recursion_count% EVAL_def_list%EVAL_recursion_count%
                IF "!EVAL_is_vector%EVAL_recursion_count%!"=="!TRUE!" (
                    CALL :VECTOR_TO_LIST EVAL_def_list%EVAL_recursion_count% EVAL_def_list%EVAL_recursion_count%
                )

                CALL :EVAL_DEF_LIST EVAL_let_env%EVAL_recursion_count% EVAL_def_list%EVAL_recursion_count%

                CALL :LIST_REST EVAL_rest%EVAL_recursion_count% EVAL_rest%EVAL_recursion_count%
                CALL :LIST_FIRST EVAL_ast%EVAL_recursion_count% EVAL_rest%EVAL_recursion_count%
                SET "EVAL_env%EVAL_recursion_count%=!EVAL_let_env%EVAL_recursion_count%!"
                GOTO :EVAL_RECUR
            )
        )

        CALL :EVAL_AST EVAL_list%EVAL_recursion_count% EVAL_ast%EVAL_recursion_count% EVAL_env%EVAL_recursion_count%
        CALL :LIST_FIND EVAL_error%EVAL_recursion_count% EVAL_list%EVAL_recursion_count% :ERROR?
        IF NOT "!EVAL_error%EVAL_recursion_count%!"=="!NIL!" (
            SET "%1=!EVAL_error%EVAL_recursion_count%!"
            GOTO :EVAL_EXIT
        )

        CALL :LIST_FIRST EVAL_function%EVAL_recursion_count% EVAL_list%EVAL_recursion_count%
        CALL :LIST_REST EVAL_lambda_args%EVAL_recursion_count% EVAL_list%EVAL_recursion_count%

        CALL :FUNCTION_TO_STR EVAL_function_str%EVAL_recursion_count% EVAL_function%EVAL_recursion_count%
        IF "!EVAL_function_str%EVAL_recursion_count%!"==":MAL_LAMBDA" (
            CALL :PREPARE_FUNCTION_FOR_EVAL EVAL_ast%EVAL_recursion_count% EVAL_env%EVAL_recursion_count% EVAL_function%EVAL_recursion_count% EVAL_lambda_args%EVAL_recursion_count%
            GOTO :EVAL_RECUR
        ) ELSE (
            CALL :CALL_STACK_PUSH EVAL_lambda_args%EVAL_recursion_count%
            CALL !EVAL_function_str%EVAL_recursion_count%! EVAL_function%EVAL_recursion_count%
            CALL :CALL_STACK_POP %1
            GOTO :EVAL_EXIT
        )
    )

    CALL :EVAL_AST %1 EVAL_ast%EVAL_recursion_count% EVAL_env%EVAL_recursion_count%

:EVAL_EXIT
    SET /a "EVAL_recursion_count-=1"
EXIT /B 0

:CALL_STACK_PUSH
    SET /a "_call_stack_size+=1"
    SET "_call_stack_value!_call_stack_size!=!%1!"
EXIT /B 0

:CALL_STACK_POP
    SET "CALL_STACK_POP_ref=_call_stack_value!_call_stack_size!"
    SET "%1=!%CALL_STACK_POP_ref%!"
    SET /a "_call_stack_size-=1"
EXIT /B 0

:IS_PAIR
    CALL :LIST? IS_PAIR_is_list %2
    IF NOT "!%2!"=="!EMPTY_LIST!" (
        SET "%1=!IS_PAIR_is_list!"
        EXIT /B 0
    )
    SET "%1=!FALSE!"
EXIT /B 0

:QUASIQUOTE
    SET /A "QUASIQUOTE_recursion_count+=1"
    SET "QUASIQUOTE_ast%QUASIQUOTE_recursion_count%=!%2!"

    CALL :VECTOR? QUASIQUOTE_is_vector QUASIQUOTE_ast%QUASIQUOTE_recursion_count%
    IF "!QUASIQUOTE_is_vector!"=="!TRUE!" (
        CALL :VECTOR_TO_LIST QUASIQUOTE_ast%QUASIQUOTE_recursion_count% QUASIQUOTE_ast%QUASIQUOTE_recursion_count%
    )

    CALL :IS_PAIR QUASIQUOTE_is_pair%QUASIQUOTE_recursion_count% QUASIQUOTE_ast%QUASIQUOTE_recursion_count%
    IF "!QUASIQUOTE_is_pair%QUASIQUOTE_recursion_count%!"=="!FALSE!" (
        SET "QUASIQUOTE_symbol_str%QUASIQUOTE_recursion_count%=quote"
        CALL :SYMBOL_NEW QUASIQUOTE_symbol%QUASIQUOTE_recursion_count% QUASIQUOTE_symbol_str%QUASIQUOTE_recursion_count%
        CALL :LIST_CONS QUASIQUOTE_result%QUASIQUOTE_recursion_count% QUASIQUOTE_ast%QUASIQUOTE_recursion_count% EMPTY_LIST
        CALL :LIST_CONS %1 QUASIQUOTE_symbol%QUASIQUOTE_recursion_count% QUASIQUOTE_result%QUASIQUOTE_recursion_count%
        GOTO :QUASIQUOTE_EXIT
    )

    CALL :LIST_FIRST QUASIQUOTE_first0%QUASIQUOTE_recursion_count% QUASIQUOTE_ast%QUASIQUOTE_recursion_count%
    CALL :LIST_REST QUASIQUOTE_rest0%QUASIQUOTE_recursion_count% QUASIQUOTE_ast%QUASIQUOTE_recursion_count%

    CALL :SYMBOL? QUASIQUOTE_is_symbol%QUASIQUOTE_recursion_count% QUASIQUOTE_first0%QUASIQUOTE_recursion_count%
    IF "!QUASIQUOTE_is_symbol%QUASIQUOTE_recursion_count%!"=="!TRUE!" (
        CALL :SYMBOL_TO_STR QUASIQUOTE_first_str%QUASIQUOTE_recursion_count% QUASIQUOTE_first0%QUASIQUOTE_recursion_count%
        IF "!QUASIQUOTE_first_str%QUASIQUOTE_recursion_count%!"=="unquote" (
            CALL :LIST_FIRST QUASIQUOTE_second0%QUASIQUOTE_recursion_count% QUASIQUOTE_rest0%QUASIQUOTE_recursion_count%
            SET "%1=!QUASIQUOTE_second0%QUASIQUOTE_recursion_count%!"
            GOTO :QUASIQUOTE_EXIT
        )
    )

    CALL :IS_PAIR QUASIQUOTE_is_pair%QUASIQUOTE_recursion_count% QUASIQUOTE_first0%QUASIQUOTE_recursion_count%
    IF "!QUASIQUOTE_is_pair%QUASIQUOTE_recursion_count%!"=="!TRUE!" (
        CALL :LIST_FIRST QUASIQUOTE_first1%QUASIQUOTE_recursion_count% QUASIQUOTE_first0%QUASIQUOTE_recursion_count%
        CALL :SYMBOL? QUASIQUOTE_is_symbol%QUASIQUOTE_recursion_count% QUASIQUOTE_first1%QUASIQUOTE_recursion_count%
        IF "!QUASIQUOTE_is_symbol%QUASIQUOTE_recursion_count%!"=="!TRUE!" (
            CALL :SYMBOL_TO_STR QUASIQUOTE_first_str%QUASIQUOTE_recursion_count% QUASIQUOTE_first1%QUASIQUOTE_recursion_count%
            IF "!QUASIQUOTE_first_str%QUASIQUOTE_recursion_count%!"=="splice-unquote" (
                SET "QUASIQUOTE_symbol_str%QUASIQUOTE_recursion_count%=concat"
                CALL :SYMBOL_NEW QUASIQUOTE_symbol%QUASIQUOTE_recursion_count% QUASIQUOTE_symbol_str%QUASIQUOTE_recursion_count%

                CALL :LIST_REST QUASIQUOTE_rest1%QUASIQUOTE_recursion_count% QUASIQUOTE_first0%QUASIQUOTE_recursion_count%
                CALL :LIST_FIRST QUASIQUOTE_second1%QUASIQUOTE_recursion_count% QUASIQUOTE_rest1%QUASIQUOTE_recursion_count%

                CALL :QUASIQUOTE QUASIQUOTE_result%QUASIQUOTE_recursion_count% QUASIQUOTE_rest0%QUASIQUOTE_recursion_count%

                CALL :LIST_CONS QUASIQUOTE_result%QUASIQUOTE_recursion_count% QUASIQUOTE_result%QUASIQUOTE_recursion_count% EMPTY_LIST
                CALL :LIST_CONS QUASIQUOTE_result%QUASIQUOTE_recursion_count% QUASIQUOTE_second1%QUASIQUOTE_recursion_count% QUASIQUOTE_result%QUASIQUOTE_recursion_count%
                CALL :LIST_CONS %1 QUASIQUOTE_symbol%QUASIQUOTE_recursion_count% QUASIQUOTE_result%QUASIQUOTE_recursion_count%

                GOTO :QUASIQUOTE_EXIT
            )
        )
    )

    SET "QUASIQUOTE_symbol_str%QUASIQUOTE_recursion_count%=cons"
    CALL :SYMBOL_NEW QUASIQUOTE_symbol%QUASIQUOTE_recursion_count% QUASIQUOTE_symbol_str%QUASIQUOTE_recursion_count%
    CALL :QUASIQUOTE QUASIQUOTE_result_first%QUASIQUOTE_recursion_count% QUASIQUOTE_first0%QUASIQUOTE_recursion_count%
    CALL :QUASIQUOTE QUASIQUOTE_result_rest%QUASIQUOTE_recursion_count% QUASIQUOTE_rest0%QUASIQUOTE_recursion_count%
    CALL :LIST_CONS QUASIQUOTE_result%QUASIQUOTE_recursion_count% QUASIQUOTE_result_rest%QUASIQUOTE_recursion_count% EMPTY_LIST
    CALL :LIST_CONS QUASIQUOTE_result%QUASIQUOTE_recursion_count% QUASIQUOTE_result_first%QUASIQUOTE_recursion_count% QUASIQUOTE_result%QUASIQUOTE_recursion_count%
    CALL :LIST_CONS %1 QUASIQUOTE_symbol%QUASIQUOTE_recursion_count% QUASIQUOTE_result%QUASIQUOTE_recursion_count%

:QUASIQUOTE_EXIT
    SET /A "QUASIQUOTE_recursion_count-=1"
EXIT /B 0

:IS_MACRO_CALL
    CALL :IS_PAIR IS_MACRO_CALL_is_pair %2
    IF "!IS_MACRO_CALL_is_pair!"=="!TRUE!" (
        CALL :LIST_FIRST IS_MACRO_CALL_symbol %2
        CALL :SYMBOL? IS_MACRO_CALL_is_symbol IS_MACRO_CALL_symbol
        IF "!IS_MACRO_CALL_is_symbol!"=="!TRUE!" (
            CALL :ENV_GET IS_MACRO_CALL_function %3 IS_MACRO_CALL_symbol
            IF NOT "!IS_MACRO_CALL_function!"=="!NIL!" (
                CALL :FUNCTION? IS_MACRO_CALL_is_function IS_MACRO_CALL_function
                IF "!IS_MACRO_CALL_is_function!"=="!TRUE!" (
                    CALL :FUNCTION_MACRO? %1 IS_MACRO_CALL_function
                    EXIT /B 0
                )
            )
        )
    )
    SET "%1=!FALSE!"
EXIT /B 0

:MACRO_EXPAND
    SET /A "MACRO_EXPAND_recursion_count+=1"
    SET "MACRO_EXPAND_ast%MACRO_EXPAND_recursion_count%=!%2!"
    SET "MACRO_EXPAND_env%MACRO_EXPAND_recursion_count%=!%3!"
:MACRO_EXPAND_RECUR
    CALL :IS_MACRO_CALL MACRO_EXPAND_ast_is_macro%MACRO_EXPAND_recursion_count% MACRO_EXPAND_ast%MACRO_EXPAND_recursion_count% MACRO_EXPAND_env%MACRO_EXPAND_recursion_count%
    IF "!MACRO_EXPAND_ast_is_macro%MACRO_EXPAND_recursion_count%!"=="!TRUE!" (
        CALL :LIST_FIRST MACRO_EXPAND_symbol%MACRO_EXPAND_recursion_count% MACRO_EXPAND_ast%MACRO_EXPAND_recursion_count%
        CALL :LIST_REST MACRO_EXPAND_arguments%MACRO_EXPAND_recursion_count% MACRO_EXPAND_ast%MACRO_EXPAND_recursion_count%
        CALL :ENV_GET MACRO_EXPAND_function%MACRO_EXPAND_recursion_count% MACRO_EXPAND_env%MACRO_EXPAND_recursion_count% MACRO_EXPAND_symbol%MACRO_EXPAND_recursion_count%
        CALL :PREPARE_FUNCTION_FOR_EVAL MACRO_EXPAND_ast%MACRO_EXPAND_recursion_count% MACRO_EXPAND_env%MACRO_EXPAND_recursion_count% MACRO_EXPAND_function%MACRO_EXPAND_recursion_count% MACRO_EXPAND_arguments%MACRO_EXPAND_recursion_count%
        CALL :EVAL MACRO_EXPAND_ast%MACRO_EXPAND_recursion_count% MACRO_EXPAND_ast%MACRO_EXPAND_recursion_count% MACRO_EXPAND_env%MACRO_EXPAND_recursion_count%
        GOTO :MACRO_EXPAND_RECUR
    )
    SET "%1=!MACRO_EXPAND_ast%MACRO_EXPAND_recursion_count%!"
    SET /A "MACRO_EXPAND_recursion_count-=1"
EXIT /B 0

:PREPARE_FUNCTION_FOR_EVAL
    SET "PREPARE_FUNCTION_FOR_EVAL_lambda_args=!%4!"

    CALL :FUNCTION_GET_PARAMS PREPARE_FUNCTION_FOR_EVAL_lambda_params %3
    CALL :FUNCTION_GET_ENV PREPARE_FUNCTION_FOR_EVAL_lambda_env_outer %3
    CALL :FUNCTION_GET_BODY PREPARE_FUNCTION_FOR_EVAL_lambda_body %3

    CALL :ENV_NEW PREPARE_FUNCTION_FOR_EVAL_lambda_env
    CALL :ENV_SET_OUTER PREPARE_FUNCTION_FOR_EVAL_lambda_env PREPARE_FUNCTION_FOR_EVAL_lambda_env_outer

    CALL :VECTOR? PREPARE_FUNCTION_FOR_EVAL_lambda_params_is_vector PREPARE_FUNCTION_FOR_EVAL_lambda_params
    IF "!PREPARE_FUNCTION_FOR_EVAL_lambda_params_is_vector!"=="!TRUE!" (
        CALL :VECTOR_TO_LIST PREPARE_FUNCTION_FOR_EVAL_lambda_params PREPARE_FUNCTION_FOR_EVAL_lambda_params
    )

:PREPARE_FUNCTION_FOR_EVAL_NEXT_ARG
    IF NOT "!PREPARE_FUNCTION_FOR_EVAL_lambda_params!"=="!EMPTY_LIST!" (
        CALL :LIST_FIRST PREPARE_FUNCTION_FOR_EVAL_lambda_param PREPARE_FUNCTION_FOR_EVAL_lambda_params
        CALL :LIST_REST PREPARE_FUNCTION_FOR_EVAL_lambda_params PREPARE_FUNCTION_FOR_EVAL_lambda_params

        CALL :SYMBOL_TO_STR PREPARE_FUNCTION_FOR_EVAL_lambda_param_str PREPARE_FUNCTION_FOR_EVAL_lambda_param
        IF "!PREPARE_FUNCTION_FOR_EVAL_lambda_param_str!"=="!_ampersand!" (
            CALL :LIST_FIRST PREPARE_FUNCTION_FOR_EVAL_lambda_param PREPARE_FUNCTION_FOR_EVAL_lambda_params
            CALL :ENV_SET PREPARE_FUNCTION_FOR_EVAL_lambda_env PREPARE_FUNCTION_FOR_EVAL_lambda_param PREPARE_FUNCTION_FOR_EVAL_lambda_args

        ) ELSE (
            CALL :LIST_FIRST PREPARE_FUNCTION_FOR_EVAL_lambda_argument PREPARE_FUNCTION_FOR_EVAL_lambda_args
            CALL :LIST_REST PREPARE_FUNCTION_FOR_EVAL_lambda_args PREPARE_FUNCTION_FOR_EVAL_lambda_args
            CALL :ENV_SET PREPARE_FUNCTION_FOR_EVAL_lambda_env PREPARE_FUNCTION_FOR_EVAL_lambda_param PREPARE_FUNCTION_FOR_EVAL_lambda_argument
            GOTO :PREPARE_FUNCTION_FOR_EVAL_NEXT_ARG
        )
    )

    SET "%1=!PREPARE_FUNCTION_FOR_EVAL_lambda_body!"
    SET "%2=!PREPARE_FUNCTION_FOR_EVAL_lambda_env!"
EXIT /B 0
