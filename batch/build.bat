
@echo off

echo ^:^: The following file is generated by build.bat. DO NOT EDIT. > tmp_comment.bat
copy /b tmp_comment.bat+header.src.bat+types.src.bat+strings.src.bat+reader.src.bat+printer.src.bat tmp_base.bat > nul
copy /b tmp_base.bat+step2_eval.src.bat step2_eval.bat > nul
copy /b tmp_base.bat+env.src.bat+step3_env.src.bat step3_env.bat > nul
copy /b tmp_base.bat+env.src.bat+core.src.bat+step4_if_fn_do.src.bat step4_if_fn_do.bat > nul
del tmp*.bat > nul
