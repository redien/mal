@echo off
SETLOCAL ENABLEEXTENSIONS ENABLEDELAYEDEXPANSION

set "sp=0"
set pops=set ^"
set pope=^=^^!stack^!sp^!^^!^" ^& set ^/a ^"sp-=1^"
set pushs=set ^/a ^"sp+=1^" ^& set ^"stack^!sp^!^=^^!
set pushe=^^!^"

goto :start

