@echo off
echo 清空以前输出
if exist dll_test.chm del /f /q dll_test.chm
if exist dll_test.chw del /f /q dll_test.chw
if exist output\html del /f /q output\html\*.*
if exist output\latex del /f /q output\latex\*.*
if exist output\rtf del /f /q output\rtf\*.*
if exist output del /f /q output\*.*
