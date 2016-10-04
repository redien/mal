
@echo off

CALL :BUILD_STEP step1_read_print
CALL :BUILD_STEP step2_eval
CALL :BUILD_STEP step3_env
EXIT /B 0

:BUILD_STEP
    echo ^:^: The following file is generated by build.bat. DO NOT EDIT. > tmp1.bat
    copy /b tmp1.bat+header.bat tmp2.bat > nul
    copy /b tmp2.bat+types.bat tmp3.bat > nul
    copy /b tmp3.bat+strings.bat tmp4.bat > nul
    copy /b tmp4.bat+reader.bat tmp5.bat > nul
    copy /b tmp5.bat+printer.bat tmp6.bat > nul
    copy /b tmp6.bat+env.bat tmp7.bat > nul
    copy /b tmp7.bat+_%1.bat tmp8.bat > nul
    copy /b tmp8.bat %1.bat > nul
    del tmp*.bat > nul
EXIT /B 0
