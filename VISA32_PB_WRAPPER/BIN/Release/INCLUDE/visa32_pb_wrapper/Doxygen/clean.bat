@echo off
echo 清空以前输出
if exist VISA32_PB_WRAPPER_CLASS.chm del /f /q VISA32_PB_WRAPPER_CLASS.chm
if exist VISA32_PB_WRAPPER_CLASS.chw del /f /q VISA32_PB_WRAPPER_CLASS.chw
if exist output\html del /f /q output\html\*.*
if exist output\latex del /f /q output\latex\*.*
if exist output\rtf del /f /q output\rtf\*.*
if exist output del /f /q output\*.*
