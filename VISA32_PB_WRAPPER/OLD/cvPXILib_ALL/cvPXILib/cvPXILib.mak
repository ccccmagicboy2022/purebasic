# Microsoft Developer Studio Generated NMAKE File, Based on cvPXILib.dsp
!IF "$(CFG)" == ""
CFG=cvPXILib - Win32 Debug
!MESSAGE No configuration specified. Defaulting to cvPXILib - Win32 Debug.
!ENDIF 

!IF "$(CFG)" != "cvPXILib - Win32 Release" && "$(CFG)" != "cvPXILib - Win32 Debug"
!MESSAGE Invalid configuration "$(CFG)" specified.
!MESSAGE You can specify a configuration when running NMAKE
!MESSAGE by defining the macro CFG on the command line. For example:
!MESSAGE 
!MESSAGE NMAKE /f "cvPXILib.mak" CFG="cvPXILib - Win32 Debug"
!MESSAGE 
!MESSAGE Possible choices for configuration are:
!MESSAGE 
!MESSAGE "cvPXILib - Win32 Release" (based on "Win32 (x86) Dynamic-Link Library")
!MESSAGE "cvPXILib - Win32 Debug" (based on "Win32 (x86) Dynamic-Link Library")
!MESSAGE 
!ERROR An invalid configuration is specified.
!ENDIF 

!IF "$(OS)" == "Windows_NT"
NULL=
!ELSE 
NULL=nul
!ENDIF 

!IF  "$(CFG)" == "cvPXILib - Win32 Release"

OUTDIR=.\Release
INTDIR=.\Release
# Begin Custom Macros
OutDir=.\Release
# End Custom Macros

ALL : "$(OUTDIR)\cvPXILib.dll" "$(OUTDIR)\cvPXILib.bsc"


CLEAN :
	-@erase "$(INTDIR)\cvPXILib.obj"
	-@erase "$(INTDIR)\cvPXILib.pch"
	-@erase "$(INTDIR)\cvPXILib.sbr"
	-@erase "$(INTDIR)\StdAfx.obj"
	-@erase "$(INTDIR)\StdAfx.sbr"
	-@erase "$(INTDIR)\vc60.idb"
	-@erase "$(INTDIR)\ver.res"
	-@erase "$(OUTDIR)\cvPXILib.bsc"
	-@erase "$(OUTDIR)\cvPXILib.dll"
	-@erase "$(OUTDIR)\cvPXILib.exp"
	-@erase "$(OUTDIR)\cvPXILib.lib"

"$(OUTDIR)" :
    if not exist "$(OUTDIR)/$(NULL)" mkdir "$(OUTDIR)"

CPP=cl.exe
CPP_PROJ=/nologo /MT /W3 /GX /O2 /D "WIN32" /D "NDEBUG" /D "_WINDOWS" /D "_MBCS" /D "_USRDLL" /D "CVPXILIB_EXPORTS" /FR"$(INTDIR)\\" /Fp"$(INTDIR)\cvPXILib.pch" /Yu"stdafx.h" /Fo"$(INTDIR)\\" /Fd"$(INTDIR)\\" /FD /c 

.c{$(INTDIR)}.obj::
   $(CPP) @<<
   $(CPP_PROJ) $< 
<<

.cpp{$(INTDIR)}.obj::
   $(CPP) @<<
   $(CPP_PROJ) $< 
<<

.cxx{$(INTDIR)}.obj::
   $(CPP) @<<
   $(CPP_PROJ) $< 
<<

.c{$(INTDIR)}.sbr::
   $(CPP) @<<
   $(CPP_PROJ) $< 
<<

.cpp{$(INTDIR)}.sbr::
   $(CPP) @<<
   $(CPP_PROJ) $< 
<<

.cxx{$(INTDIR)}.sbr::
   $(CPP) @<<
   $(CPP_PROJ) $< 
<<

MTL=midl.exe
MTL_PROJ=/nologo /D "NDEBUG" /mktyplib203 /win32 
RSC=rc.exe
RSC_PROJ=/l 0x804 /fo"$(INTDIR)\ver.res" /d "NDEBUG" 
BSC32=bscmake.exe
BSC32_FLAGS=/nologo /o"$(OUTDIR)\cvPXILib.bsc" 
BSC32_SBRS= \
	"$(INTDIR)\cvPXILib.sbr" \
	"$(INTDIR)\StdAfx.sbr"

"$(OUTDIR)\cvPXILib.bsc" : "$(OUTDIR)" $(BSC32_SBRS)
    $(BSC32) @<<
  $(BSC32_FLAGS) $(BSC32_SBRS)
<<

LINK32=link.exe
LINK32_FLAGS=kernel32.lib user32.lib gdi32.lib winspool.lib comdlg32.lib advapi32.lib shell32.lib ole32.lib oleaut32.lib uuid.lib odbc32.lib odbccp32.lib /nologo /dll /incremental:no /pdb:"$(OUTDIR)\cvPXILib.pdb" /machine:I386 /out:"$(OUTDIR)\cvPXILib.dll" /implib:"$(OUTDIR)\cvPXILib.lib" 
LINK32_OBJS= \
	"$(INTDIR)\cvPXILib.obj" \
	"$(INTDIR)\StdAfx.obj" \
	"$(INTDIR)\ver.res"

"$(OUTDIR)\cvPXILib.dll" : "$(OUTDIR)" $(DEF_FILE) $(LINK32_OBJS)
    $(LINK32) @<<
  $(LINK32_FLAGS) $(LINK32_OBJS)
<<

!ELSEIF  "$(CFG)" == "cvPXILib - Win32 Debug"

OUTDIR=.\Debug
INTDIR=.\Debug
# Begin Custom Macros
OutDir=.\Debug
# End Custom Macros

ALL : "$(OUTDIR)\cvPXILib.dll"


CLEAN :
	-@erase "$(INTDIR)\cvPXILib.obj"
	-@erase "$(INTDIR)\cvPXILib.pch"
	-@erase "$(INTDIR)\StdAfx.obj"
	-@erase "$(INTDIR)\vc60.idb"
	-@erase "$(INTDIR)\vc60.pdb"
	-@erase "$(INTDIR)\ver.res"
	-@erase "$(OUTDIR)\cvPXILib.dll"
	-@erase "$(OUTDIR)\cvPXILib.exp"
	-@erase "$(OUTDIR)\cvPXILib.ilk"
	-@erase "$(OUTDIR)\cvPXILib.lib"
	-@erase "$(OUTDIR)\cvPXILib.pdb"

"$(OUTDIR)" :
    if not exist "$(OUTDIR)/$(NULL)" mkdir "$(OUTDIR)"

CPP=cl.exe
CPP_PROJ=/nologo /MTd /W3 /Gm /GX /ZI /Od /D "WIN32" /D "_DEBUG" /D "_WINDOWS" /D "_MBCS" /D "_USRDLL" /D "CVPXILIB_EXPORTS" /Fp"$(INTDIR)\cvPXILib.pch" /Yu"stdafx.h" /Fo"$(INTDIR)\\" /Fd"$(INTDIR)\\" /FD /GZ /c 

.c{$(INTDIR)}.obj::
   $(CPP) @<<
   $(CPP_PROJ) $< 
<<

.cpp{$(INTDIR)}.obj::
   $(CPP) @<<
   $(CPP_PROJ) $< 
<<

.cxx{$(INTDIR)}.obj::
   $(CPP) @<<
   $(CPP_PROJ) $< 
<<

.c{$(INTDIR)}.sbr::
   $(CPP) @<<
   $(CPP_PROJ) $< 
<<

.cpp{$(INTDIR)}.sbr::
   $(CPP) @<<
   $(CPP_PROJ) $< 
<<

.cxx{$(INTDIR)}.sbr::
   $(CPP) @<<
   $(CPP_PROJ) $< 
<<

MTL=midl.exe
MTL_PROJ=/nologo /D "_DEBUG" /mktyplib203 /win32 
RSC=rc.exe
RSC_PROJ=/l 0x804 /fo"$(INTDIR)\ver.res" /d "_DEBUG" 
BSC32=bscmake.exe
BSC32_FLAGS=/nologo /o"$(OUTDIR)\cvPXILib.bsc" 
BSC32_SBRS= \
	
LINK32=link.exe
LINK32_FLAGS=kernel32.lib user32.lib gdi32.lib winspool.lib comdlg32.lib advapi32.lib shell32.lib ole32.lib oleaut32.lib uuid.lib odbc32.lib odbccp32.lib /nologo /dll /incremental:yes /pdb:"$(OUTDIR)\cvPXILib.pdb" /debug /machine:I386 /out:"$(OUTDIR)\cvPXILib.dll" /implib:"$(OUTDIR)\cvPXILib.lib" /pdbtype:sept 
LINK32_OBJS= \
	"$(INTDIR)\cvPXILib.obj" \
	"$(INTDIR)\StdAfx.obj" \
	"$(INTDIR)\ver.res"

"$(OUTDIR)\cvPXILib.dll" : "$(OUTDIR)" $(DEF_FILE) $(LINK32_OBJS)
    $(LINK32) @<<
  $(LINK32_FLAGS) $(LINK32_OBJS)
<<

!ENDIF 


!IF "$(NO_EXTERNAL_DEPS)" != "1"
!IF EXISTS("cvPXILib.dep")
!INCLUDE "cvPXILib.dep"
!ELSE 
!MESSAGE Warning: cannot find "cvPXILib.dep"
!ENDIF 
!ENDIF 


!IF "$(CFG)" == "cvPXILib - Win32 Release" || "$(CFG)" == "cvPXILib - Win32 Debug"
SOURCE=.\cvPXILib.cpp

!IF  "$(CFG)" == "cvPXILib - Win32 Release"


"$(INTDIR)\cvPXILib.obj"	"$(INTDIR)\cvPXILib.sbr" : $(SOURCE) "$(INTDIR)" "$(INTDIR)\cvPXILib.pch"


!ELSEIF  "$(CFG)" == "cvPXILib - Win32 Debug"


"$(INTDIR)\cvPXILib.obj" : $(SOURCE) "$(INTDIR)" "$(INTDIR)\cvPXILib.pch"


!ENDIF 

SOURCE=.\StdAfx.cpp

!IF  "$(CFG)" == "cvPXILib - Win32 Release"

CPP_SWITCHES=/nologo /MT /W3 /GX /O2 /D "WIN32" /D "NDEBUG" /D "_WINDOWS" /D "_MBCS" /D "_USRDLL" /D "CVPXILIB_EXPORTS" /FR"$(INTDIR)\\" /Fp"$(INTDIR)\cvPXILib.pch" /Yc"stdafx.h" /Fo"$(INTDIR)\\" /Fd"$(INTDIR)\\" /FD /c 

"$(INTDIR)\StdAfx.obj"	"$(INTDIR)\StdAfx.sbr"	"$(INTDIR)\cvPXILib.pch" : $(SOURCE) "$(INTDIR)"
	$(CPP) @<<
  $(CPP_SWITCHES) $(SOURCE)
<<


!ELSEIF  "$(CFG)" == "cvPXILib - Win32 Debug"

CPP_SWITCHES=/nologo /MTd /W3 /Gm /GX /ZI /Od /D "WIN32" /D "_DEBUG" /D "_WINDOWS" /D "_MBCS" /D "_USRDLL" /D "CVPXILIB_EXPORTS" /Fp"$(INTDIR)\cvPXILib.pch" /Yc"stdafx.h" /Fo"$(INTDIR)\\" /Fd"$(INTDIR)\\" /FD /GZ /c 

"$(INTDIR)\StdAfx.obj"	"$(INTDIR)\cvPXILib.pch" : $(SOURCE) "$(INTDIR)"
	$(CPP) @<<
  $(CPP_SWITCHES) $(SOURCE)
<<


!ENDIF 

SOURCE=.\ver.rc

"$(INTDIR)\ver.res" : $(SOURCE) "$(INTDIR)"
	$(RSC) $(RSC_PROJ) $(SOURCE)



!ENDIF 

