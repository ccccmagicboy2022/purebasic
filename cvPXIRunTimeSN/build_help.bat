@echo off
cls
color 0A
set project_name=cvPXIRunTimeSN
doxygen %project_name%.doxygen
%systemroot%\hh.exe .\Release\%project_name%.chm
清除vc6的垃圾文件_cv.bat
pause