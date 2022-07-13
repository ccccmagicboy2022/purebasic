;==========================================================================
; Generated with PureDLLHelper, Copyright ©2012 by Thomas <ts-soft> Schulz
;==========================================================================
XIncludeFile  "MemoryModule.pbi"

DataSection
  
  CPUID_Util: IncludeBinary "CPUID_Util.dll"
    
EndDataSection

Prototype GetCPUID(a)

Global GetCPUID.GetCPUID

Procedure.i CPUID_Util_LoadDLL()
  Protected hDLL.i
  
  hDLL = MemoryLoadLibrary(?CPUID_Util)
  If hDLL <> 0
    GetCPUID = MemoryGetProcAddress(hDLL, "GetCPUID")

    ProcedureReturn hDLL
  EndIf

  ProcedureReturn #False
EndProcedure


; IDE Options = PureBasic 5.00 (Windows - x86)
; CursorPosition = 11
; Folding = -
; EnableXP