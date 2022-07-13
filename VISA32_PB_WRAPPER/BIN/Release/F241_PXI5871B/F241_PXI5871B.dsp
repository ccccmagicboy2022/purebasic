# Microsoft Developer Studio Project File - Name="F241_PXI5871B" - Package Owner=<4>
# Microsoft Developer Studio Generated Build File, Format Version 6.00
# ** DO NOT EDIT **

# TARGTYPE "Win32 (x86) Application" 0x0101

CFG=F241_PXI5871B - Win32 Debug
!MESSAGE This is not a valid makefile. To build this project using NMAKE,
!MESSAGE use the Export Makefile command and run
!MESSAGE 
!MESSAGE NMAKE /f "F241_PXI5871B.mak".
!MESSAGE 
!MESSAGE You can specify a configuration when running NMAKE
!MESSAGE by defining the macro CFG on the command line. For example:
!MESSAGE 
!MESSAGE NMAKE /f "F241_PXI5871B.mak" CFG="F241_PXI5871B - Win32 Debug"
!MESSAGE 
!MESSAGE Possible choices for configuration are:
!MESSAGE 
!MESSAGE "F241_PXI5871B - Win32 Release" (based on "Win32 (x86) Application")
!MESSAGE "F241_PXI5871B - Win32 Debug" (based on "Win32 (x86) Application")
!MESSAGE 

# Begin Project
# PROP AllowPerConfigDependencies 0
# PROP Scc_ProjName ""
# PROP Scc_LocalPath ""
CPP=cl.exe
MTL=midl.exe
RSC=rc.exe

!IF  "$(CFG)" == "F241_PXI5871B - Win32 Release"

# PROP BASE Use_MFC 6
# PROP BASE Use_Debug_Libraries 0
# PROP BASE Output_Dir "Release"
# PROP BASE Intermediate_Dir "Release"
# PROP BASE Target_Dir ""
# PROP Use_MFC 6
# PROP Use_Debug_Libraries 0
# PROP Output_Dir "Release"
# PROP Intermediate_Dir "Release"
# PROP Ignore_Export_Lib 0
# PROP Target_Dir ""
# ADD BASE CPP /nologo /MD /W3 /GX /O2 /D "WIN32" /D "NDEBUG" /D "_WINDOWS" /D "_AFXDLL" /Yu"stdafx.h" /FD /c
# ADD CPP /nologo /MD /W3 /GX /Zi /O2 /D "WIN32" /D "NDEBUG" /D "_WINDOWS" /D "_AFXDLL" /D "_MBCS" /FD /c
# SUBTRACT CPP /YX /Yc /Yu
# ADD BASE MTL /nologo /D "NDEBUG" /mktyplib203 /win32
# ADD MTL /nologo /D "NDEBUG" /mktyplib203 /win32
# ADD BASE RSC /l 0x804 /d "NDEBUG" /d "_AFXDLL"
# ADD RSC /l 0x804 /d "NDEBUG" /d "_AFXDLL"
BSC32=bscmake.exe
# ADD BASE BSC32 /nologo
# ADD BSC32 /nologo
LINK32=link.exe
# ADD BASE LINK32 /nologo /subsystem:windows /machine:I386
# ADD LINK32 /nologo /subsystem:windows /debug /machine:I386

!ELSEIF  "$(CFG)" == "F241_PXI5871B - Win32 Debug"

# PROP BASE Use_MFC 6
# PROP BASE Use_Debug_Libraries 1
# PROP BASE Output_Dir "Debug"
# PROP BASE Intermediate_Dir "Debug"
# PROP BASE Target_Dir ""
# PROP Use_MFC 6
# PROP Use_Debug_Libraries 1
# PROP Output_Dir "Debug"
# PROP Intermediate_Dir "Debug"
# PROP Target_Dir ""
# ADD BASE CPP /nologo /MDd /W3 /Gm /GX /ZI /Od /D "WIN32" /D "_DEBUG" /D "_WINDOWS" /D "_AFXDLL" /Yu"stdafx.h" /FD /GZ /c
# ADD CPP /nologo /MDd /W3 /Gm /GX /ZI /Od /D "WIN32" /D "_DEBUG" /D "_WINDOWS" /D "_AFXDLL" /D "_MBCS" /FR /FD /GZ /c
# SUBTRACT CPP /YX /Yc /Yu
# ADD BASE MTL /nologo /D "_DEBUG" /mktyplib203 /win32
# ADD MTL /nologo /D "_DEBUG" /mktyplib203 /win32
# ADD BASE RSC /l 0x804 /d "_DEBUG" /d "_AFXDLL"
# ADD RSC /l 0x804 /d "_DEBUG" /d "_AFXDLL"
BSC32=bscmake.exe
# ADD BASE BSC32 /nologo
# ADD BSC32 /nologo
LINK32=link.exe
# ADD BASE LINK32 /nologo /subsystem:windows /debug /machine:I386 /pdbtype:sept
# ADD LINK32 /nologo /subsystem:windows /debug /machine:I386 /pdbtype:sept

!ENDIF 

# Begin Target

# Name "F241_PXI5871B - Win32 Release"
# Name "F241_PXI5871B - Win32 Debug"
# Begin Group "Source Files"

# PROP Default_Filter "cpp;c;cxx;rc;def;r;odl;idl;hpj;bat"
# Begin Source File

SOURCE=.\_led.cpp
# End Source File
# Begin Source File

SOURCE=..\INCLUDE\visa32_pb_wrapper\card_info.cpp
# End Source File
# Begin Source File

SOURCE=.\F241_PXI5871B.cpp
# End Source File
# Begin Source File

SOURCE=.\F241_PXI5871B.rc
# End Source File
# Begin Source File

SOURCE=.\F241_PXI5871BDlg.cpp
# End Source File
# Begin Source File

SOURCE=.\HexEdit.cpp
# End Source File
# Begin Source File

SOURCE=.\LedButton.cpp
# End Source File
# Begin Source File

SOURCE=.\MyConfigSheet.cpp
# End Source File
# Begin Source File

SOURCE=.\Page1.cpp
# End Source File
# Begin Source File

SOURCE=.\Page2.cpp
# End Source File
# Begin Source File

SOURCE=.\Page3.cpp
# End Source File
# Begin Source File

SOURCE=.\Page4.cpp
# End Source File
# Begin Source File

SOURCE=.\Page5.cpp
# End Source File
# Begin Source File

SOURCE=.\Page6.cpp
# End Source File
# Begin Source File

SOURCE=.\Page7.cpp
# End Source File
# Begin Source File

SOURCE=.\Page8.cpp
# End Source File
# Begin Source File

SOURCE=..\INCLUDE\visa32_pb_wrapper\plx9054_card.cpp
# End Source File
# Begin Source File

SOURCE=.\PXI5871B.cpp
# End Source File
# Begin Source File

SOURCE=.\StdAfx.cpp
# ADD CPP /Yc"stdafx.h"
# End Source File
# Begin Source File

SOURCE=.\VersionInfo.cpp
# End Source File
# Begin Source File

SOURCE=..\INCLUDE\visa32_pb_wrapper\visa32_base.cpp
# End Source File
# End Group
# Begin Group "Header Files"

# PROP Default_Filter "h;hpp;hxx;hm;inl"
# Begin Source File

SOURCE=.\_led.h
# End Source File
# Begin Source File

SOURCE=..\INCLUDE\visa32_pb_wrapper\card_info.h
# End Source File
# Begin Source File

SOURCE=.\F241_PXI5871B.h
# End Source File
# Begin Source File

SOURCE=.\F241_PXI5871BDlg.h
# End Source File
# Begin Source File

SOURCE=.\HexEdit.h
# End Source File
# Begin Source File

SOURCE=.\LedButton.h
# End Source File
# Begin Source File

SOURCE=.\MyConfigSheet.h
# End Source File
# Begin Source File

SOURCE=.\Page1.h
# End Source File
# Begin Source File

SOURCE=.\Page2.h
# End Source File
# Begin Source File

SOURCE=.\Page3.h
# End Source File
# Begin Source File

SOURCE=.\Page4.h
# End Source File
# Begin Source File

SOURCE=.\Page5.h
# End Source File
# Begin Source File

SOURCE=.\Page6.h
# End Source File
# Begin Source File

SOURCE=.\Page7.h
# End Source File
# Begin Source File

SOURCE=.\Page8.h
# End Source File
# Begin Source File

SOURCE=..\INCLUDE\visa32_pb_wrapper\plx9054_card.h
# End Source File
# Begin Source File

SOURCE=.\PXI5871B.h
# End Source File
# Begin Source File

SOURCE=.\Resource.h
# End Source File
# Begin Source File

SOURCE=.\StdAfx.h
# End Source File
# Begin Source File

SOURCE=.\VersionInfo.h
# End Source File
# Begin Source File

SOURCE=..\INCLUDE\visa32_pb_wrapper\visa32_base.h
# End Source File
# Begin Source File

SOURCE=..\INCLUDE\visa32_pb_wrapper\VISA32_PB_WRAPPER_KIT.h
# End Source File
# End Group
# Begin Group "Resource Files"

# PROP Default_Filter "ico;cur;bmp;dlg;rc2;rct;bin;rgs;gif;jpg;jpeg;jpe"
# Begin Source File

SOURCE=.\res\card16.ico
# End Source File
# Begin Source File

SOURCE=.\res\card16_gray.ico
# End Source File
# Begin Source File

SOURCE=.\res\F241_PXI5871B.ico
# End Source File
# Begin Source File

SOURCE=.\res\F241_PXI5871B.rc2
# End Source File
# Begin Source File

SOURCE=.\res\greenButton.bmp
# End Source File
# Begin Source File

SOURCE=.\res\LedGreen.ico
# End Source File
# Begin Source File

SOURCE=.\res\LedNone.ico
# End Source File
# Begin Source File

SOURCE=.\res\new_gray.ico
# End Source File
# Begin Source File

SOURCE=.\res\new_red.ico
# End Source File
# Begin Source File

SOURCE=.\res\redButton.bmp
# End Source File
# End Group
# Begin Source File

SOURCE=.\ReadMe.txt
# End Source File
# Begin Source File

SOURCE=.\XPStyle.manifest
# End Source File
# End Target
# End Project
# Section F241_PXI5871B : {7B22D231-8148-4808-96A3-768E57B96355}
# 	2:21:DefaultSinkHeaderFile:_led.h
# 	2:16:DefaultSinkClass:C_LED
# End Section
# Section F241_PXI5871B : {A06450CA-0106-4042-9024-9AD892C0FFA1}
# 	2:5:Class:C_LED
# 	2:10:HeaderFile:_led.h
# 	2:8:ImplFile:_led.cpp
# End Section
