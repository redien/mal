@echo off
SETLOCAL ENABLEEXTENSIONS ENABLEDELAYEDEXPANSION

SET _newline=^


:: Do not remove the empty lines above
::

set "sp=0"
set "sp2=-1"
set pops=set ^"
set pope=^=stack^^!sp^^!^" ^& set ^/a ^"sp-=1^"
set pushs=set ^/a ^"sp+=1^" ^& set ^"stack^^!sp^^!^=^^!
set pushe=^^!^"

goto :start

