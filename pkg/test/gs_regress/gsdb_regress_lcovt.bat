echo off
del /Q gs_regress.exe ctsql.exe gsc.dll
del /Q results\*.out results\*.log results\*.diff 
copy /B /Y "..\..\bin\gs_regress.exe"  "."
copy /B /Y "..\..\bin\ctsql.exe"  "."
copy /B /Y "..\..\bin\gsc.dll"  "."

del /Q .\sql\gs_lcovt_all.sql
for /f "tokens=2,3* delims=: " %%a in (gs_schedule) do (
	echo .\sql\%%a.sql
	rem type .\sql\%%a.sql  >> .\sql\gs_lcovt_all.sql
	rem echo[ >> .\sql\gs_lcovt_all.sql
	rem echo[ >> .\sql\gs_lcovt_all.sql
)

echo test: gs_lcovt_all  > gs_schedule_lcovt
cat gs_schedule_lcovt
.\gs_regress.exe --host=127.0.0.1 --port=1611 --schedule=.\gs_schedule_lcovt
