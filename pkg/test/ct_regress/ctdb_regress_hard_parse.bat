del /Q ct_regress.exe ctsql.exe gsc.dll libipsi_crypto.dll libipsi_osal.dll libipsi_pse.dll libipsi_ssl.dll lib_security.dll
del /Q results\*.out results\*.log results\*.diff 
del /Q %CTDB_HOME%\cumu_*.bak*
del /Q %CTDB_HOME%\cantiandb_*.bak*
copy /B /Y "..\..\bin\Win32\Debug\ct_regress.exe"  "."
copy /B /Y "..\..\bin\Win32\Debug\ctsql.exe"  "."
copy /B /Y "..\..\bin\Win32\Debug\cantiand.exe"  "."
copy /B /Y "..\..\bin\Win32\Debug\gsc.dll"  "."
copy /B /Y "..\..\bin\Win32\Debug\ctconn_demo.exe"  "."
copy /B /Y "..\..\library\platform\aes\lib\Windows\32\debug\lib_security.dll"  "."
copy /B /Y "..\..\library\platform\aes\lib\Windows\32\debug\libipsi_crypto.dll"  "."
copy /B /Y "..\..\library\platform\aes\lib\Windows\32\debug\libipsi_osal.dll"  "."
copy /B /Y "..\..\library\platform\aes\lib\Windows\32\debug\libipsi_pse.dll"  "."
copy /B /Y "..\..\library\platform\aes\lib\Windows\32\debug\libipsi_ssl.dll"  "."
set CTSQL_SSL_QUIET=TRUE

xcopy .\expected .\expected_bak\ /s/e/y
del /Q .\expected\*.out
xcopy .\expected_hard_parse .\expected\ /s/e/y

.\ct_regress.exe --host=127.0.0.1 --port=1611 --schedule=.\gs_schedule_hard_parse

del /Q .\expected\*.out
xcopy .\expected_bak .\expected\ /s/e/y
del /Q .\expected_bak\*.out

.\ctconn_demo.exe
