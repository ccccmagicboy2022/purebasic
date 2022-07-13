# Microsoft Developer Studio Project File - Name="dll_test" - Package Owner=<4>
# Microsoft Developer Studio Generated Build File, Format Version 6.00
# ** DO NOT EDIT **

# TARGTYPE "Win32 (x86) Console Application" 0x0103

CFG=dll_test - Win32 Debug
!MESSAGE This is not a valid makefile. To build this project using NMAKE,
!MESSAGE use the Export Makefile command and run
!MESSAGE 
!MESSAGE NMAKE /f "dll_test.mak".
!MESSAGE 
!MESSAGE You can specify a configuration when running NMAKE
!MESSAGE by defining the macro CFG on the command line. For example:
!MESSAGE 
!MESSAGE NMAKE /f "dll_test.mak" CFG="dll_test - Win32 Debug"
!MESSAGE 
!MESSAGE Possible choices for configuration are:
!MESSAGE 
!MESSAGE "dll_test - Win32 Release" (based on "Win32 (x86) Console Application")
!MESSAGE "dll_test - Win32 Debug" (based on "Win32 (x86) Console Application")
!MESSAGE 

# Begin Project
# PROP AllowPerConfigDependencies 0
# PROP Scc_ProjName ""
# PROP Scc_LocalPath ""
CPP=cl.exe
RSC=rc.exe

!IF  "$(CFG)" == "dll_test - Win32 Release"

# PROP BASE Use_MFC 0
# PROP BASE Use_Debug_Libraries 0
# PROP BASE Output_Dir "Release"
# PROP BASE Intermediate_Dir "Release"
# PROP BASE Target_Dir ""
# PROP Use_MFC 0
# PROP Use_Debug_Libraries 0
# PROP Output_Dir "Release"
# PROP Intermediate_Dir "Release"
# PROP Target_Dir ""
# ADD BASE CPP /nologo /W3 /GX /O2 /D "WIN32" /D "NDEBUG" /D "_CONSOLE" /D "_MBCS" /Yu"stdafx.h" /FD /c
# ADD CPP /nologo /W3 /GX /O2 /D "WIN32" /D "NDEBUG" /D "_CONSOLE" /D "_MBCS" /FD /c
# SUBTRACT CPP /YX /Yc /Yu
# ADD BASE RSC /l 0x804 /d "NDEBUG"
# ADD RSC /l 0x804 /d "NDEBUG"
BSC32=bscmake.exe
# ADD BASE BSC32 /nologo
# ADD BSC32 /nologo
LINK32=link.exe
# ADD BASE LINK32 kernel32.lib user32.lib gdi32.lib winspool.lib comdlg32.lib advapi32.lib shell32.lib ole32.lib oleaut32.lib uuid.lib odbc32.lib odbccp32.lib kernel32.lib user32.lib gdi32.lib winspool.lib comdlg32.lib advapi32.lib shell32.lib ole32.lib oleaut32.lib uuid.lib odbc32.lib odbccp32.lib /nologo /subsystem:console /machine:I386
# ADD LINK32 kernel32.lib user32.lib gdi32.lib winspool.lib comdlg32.lib advapi32.lib shell32.lib ole32.lib oleaut32.lib uuid.lib odbc32.lib odbccp32.lib kernel32.lib user32.lib gdi32.lib winspool.lib comdlg32.lib advapi32.lib shell32.lib ole32.lib oleaut32.lib uuid.lib odbc32.lib odbccp32.lib /nologo /subsystem:console /machine:I386

!ELSEIF  "$(CFG)" == "dll_test - Win32 Debug"

# PROP BASE Use_MFC 0
# PROP BASE Use_Debug_Libraries 1
# PROP BASE Output_Dir "Debug"
# PROP BASE Intermediate_Dir "Debug"
# PROP BASE Target_Dir ""
# PROP Use_MFC 0
# PROP Use_Debug_Libraries 1
# PROP Output_Dir "Debug"
# PROP Intermediate_Dir "Debug"
# PROP Ignore_Export_Lib 0
# PROP Target_Dir ""
# ADD BASE CPP /nologo /W3 /Gm /GX /ZI /Od /D "WIN32" /D "_DEBUG" /D "_CONSOLE" /D "_MBCS" /Yu"stdafx.h" /FD /GZ /c
# ADD CPP /nologo /W3 /Gm /GX /ZI /Od /D "WIN32" /D "_DEBUG" /D "_CONSOLE" /D "_MBCS" /FR /FD /GZ /c
# SUBTRACT CPP /YX /Yc /Yu
# ADD BASE RSC /l 0x804 /d "_DEBUG"
# ADD RSC /l 0x804 /d "_DEBUG"
BSC32=bscmake.exe
# ADD BASE BSC32 /nologo
# ADD BSC32 /nologo
LINK32=link.exe
# ADD BASE LINK32 kernel32.lib user32.lib gdi32.lib winspool.lib comdlg32.lib advapi32.lib shell32.lib ole32.lib oleaut32.lib uuid.lib odbc32.lib odbccp32.lib kernel32.lib user32.lib gdi32.lib winspool.lib comdlg32.lib advapi32.lib shell32.lib ole32.lib oleaut32.lib uuid.lib odbc32.lib odbccp32.lib /nologo /subsystem:console /debug /machine:I386 /pdbtype:sept
# ADD LINK32 kernel32.lib user32.lib gdi32.lib winspool.lib comdlg32.lib advapi32.lib shell32.lib ole32.lib oleaut32.lib uuid.lib odbc32.lib odbccp32.lib kernel32.lib user32.lib gdi32.lib winspool.lib comdlg32.lib advapi32.lib shell32.lib ole32.lib oleaut32.lib uuid.lib odbc32.lib odbccp32.lib /nologo /subsystem:console /debug /machine:I386 /pdbtype:sept

!ENDIF 

# Begin Target

# Name "dll_test - Win32 Release"
# Name "dll_test - Win32 Debug"
# Begin Group "Source Files"

# PROP Default_Filter "cpp;c;cxx;rc;def;r;odl;idl;hpj;bat"
# Begin Source File

SOURCE=..\INCLUDE\visa32_pb_wrapper\AG34410A.cpp
# End Source File
# Begin Source File

SOURCE=..\INCLUDE\visa32_pb_wrapper\cable_tester.cpp
# End Source File
# Begin Source File

SOURCE=..\INCLUDE\visa32_pb_wrapper\card_info.cpp
# End Source File
# Begin Source File

SOURCE=.\dll_test.cpp
# End Source File
# Begin Source File

SOURCE=..\INCLUDE\visa32_pb_wrapper\GX6888.cpp
# End Source File
# Begin Source File

SOURCE=..\INCLUDE\visa32_pb_wrapper\MSO7034B.cpp
# End Source File
# Begin Source File

SOURCE=..\INCLUDE\visa32_pb_wrapper\pc_info.cpp
# End Source File
# Begin Source File

SOURCE=..\INCLUDE\visa32_pb_wrapper\plx9054_card.cpp
# End Source File
# Begin Source File

SOURCE=..\INCLUDE\visa32_pb_wrapper\PXI5477.cpp
# End Source File
# Begin Source File

SOURCE=..\INCLUDE\visa32_pb_wrapper\PXI5487.cpp
# End Source File
# Begin Source File

SOURCE=..\INCLUDE\visa32_pb_wrapper\visa32_base.cpp
# End Source File
# Begin Source File

SOURCE=..\INCLUDE\visa32_pb_wrapper\visa32_device.cpp
# End Source File
# End Group
# Begin Group "Header Files"

# PROP Default_Filter "h;hpp;hxx;hm;inl"
# Begin Source File

SOURCE=..\INCLUDE\visa32_pb_wrapper\AG34410A.h
# End Source File
# Begin Source File

SOURCE=..\INCLUDE\visa32_pb_wrapper\cable_tester.h
# End Source File
# Begin Source File

SOURCE=..\INCLUDE\visa32_pb_wrapper\card_info.h
# End Source File
# Begin Source File

SOURCE=..\INCLUDE\visa32_pb_wrapper\GX6888.h
# End Source File
# Begin Source File

SOURCE=..\INCLUDE\visa32_pb_wrapper\MSO7034B.h
# End Source File
# Begin Source File

SOURCE=..\INCLUDE\visa32_pb_wrapper\pc_info.h
# End Source File
# Begin Source File

SOURCE=..\INCLUDE\visa32_pb_wrapper\plx9054_card.h
# End Source File
# Begin Source File

SOURCE=..\INCLUDE\visa32_pb_wrapper\PXI5477.h
# End Source File
# Begin Source File

SOURCE=..\INCLUDE\visa32_pb_wrapper\PXI5487.h
# End Source File
# Begin Source File

SOURCE=..\INCLUDE\visa\visa.h
# End Source File
# Begin Source File

SOURCE=..\INCLUDE\visa32_pb_wrapper\visa32_base.h
# End Source File
# Begin Source File

SOURCE=..\INCLUDE\visa32_pb_wrapper\VISA32_CALLBACK.h
# End Source File
# Begin Source File

SOURCE=..\INCLUDE\visa32_pb_wrapper\visa32_device.h
# End Source File
# Begin Source File

SOURCE=..\INCLUDE\visa32_pb_wrapper\VISA32_PB_WRAPPER_DLL.h
# End Source File
# Begin Source File

SOURCE=..\INCLUDE\visa32_pb_wrapper\VISA32_PB_WRAPPER_KIT.h
# End Source File
# End Group
# Begin Group "Resource Files"

# PROP Default_Filter "ico;cur;bmp;dlg;rc2;rct;bin;rgs;gif;jpg;jpeg;jpe"
# Begin Source File

SOURCE=.\dll.ico
# End Source File
# Begin Source File

SOURCE=.\ver.rc
# End Source File
# End Group
# Begin Source File

SOURCE=.\req_admin.manifest
# End Source File
# Begin Source File

SOURCE=.\XPStyle.manifest
# End Source File
# End Target
# End Project
