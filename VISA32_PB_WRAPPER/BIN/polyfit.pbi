;==========================================================================
; Generated with PureDLLHelper, Copyright 2012 by Thomas <ts-soft> Schulz
;==========================================================================
XIncludeFile  "MemoryModule.pbi"

DataSection
  
  polyfit: IncludeBinary "polyfit.dll"
    
EndDataSection

Prototype  polyfit(a, b, c, d, e)

Global polyfit.polyfit

Procedure.i polyfit_LoadDLL()
  Protected hDLL.i

  hDLL = MemoryLoadLibrary(?polyfit)
  If hDLL <> 0
    polyfit = MemoryGetProcAddress(hDLL, "_polyfit@20");

    ProcedureReturn hDLL
  EndIf

  ProcedureReturn #False
EndProcedure


; IDE Options = PureBasic 4.60 (Windows - x86)
; CursorPosition = 19
; Folding = -
; EnableXP