@echo off
SETLOCAL ENABLEEXTENSIONS ENABLEDELAYEDEXPANSION

GOTO :START

:ECHO
    IF NOT "!%~1!"=="" echo !%~1!
EXIT /B 0
