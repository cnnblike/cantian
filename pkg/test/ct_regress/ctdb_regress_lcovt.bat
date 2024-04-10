echo off
del /Q ct_regress.exe ctsql.exe gsc.dll
del /Q results\*.out results\*.log results\*.diff 
copy /B /Y "..\..\bin\ct_regress.exe"  "."
copy /B /Y "..\..\bin\ctsql.exe"  "."
copy /B /Y "..\..\bin\gsc.dll"  "."

del /Q .\sql\gs_lcovt_all.sql
for /f "tokens=2,3* delims=: " %%a in (ct_schedule) do (
	echo .\sql\%%a.sql
	rem type .\sql\%%a.sql  >> .\sql\gs_lcovt_all.sql
	rem echo[ >> .\sql\gs_lcovt_all.sql
	rem echo[ >> .\sql\gs_lcovt_all.sql
)

echo test: gs_lcovt_all  > ct_schedule_lcovt
cat ct_schedule_lcovt
.\ct_regress.exe --host=127.0.0.1 --port=1611 --schedule=.\ct_schedule_lcovt
