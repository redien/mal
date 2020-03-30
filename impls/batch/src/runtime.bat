@echo off
SETLOCAL ENABLEEXTENSIONS ENABLEDELAYEDEXPANSION

SET _newline=^


:: Do not remove the empty lines above

set "sp=0"
set pops=set ^"
set pope=^=stack^^!sp^^!^" ^& set ^/a ^"sp-=1^"
set pushs=set ^/a ^"sp+=1^" ^& set ^"stack^^!sp^^!^=^^!
set pushe=^^!^"

set do=set ^"end^=stack^^!sp^^!^" ^& set ^/a ^"sp-=1^"

set "objp=0"
set news=set ^"
set newe=^=obj^^!objp^^!^" ^& set ^/a ^"objp+=1^"

goto :start

