;==========================================================================
; Generated with PureDLLHelper, Copyright ©2012 by Thomas <ts-soft> Schulz
;==========================================================================
XIncludeFile  "MemoryModule.pbi"

DataSection
  dll3_start:
    IncludeBinary "OSD_cv.dll"
  dll3_end:
EndDataSection

Prototype  osd_cv_thread(a)

Global osd_cv_thread.osd_cv_thread

Procedure.i OSD_cv_LoadDLL()
  Protected hDLL.i   

  hDLL = MemoryLoadLibrary(?dll3_start)
  If hDLL <> 0
    osd_cv_thread = MemoryGetProcAddress(hDLL, "osd_cv_thread")

    ProcedureReturn hDLL
  EndIf

  ProcedureReturn #False
EndProcedure


; IDE Options = PureBasic 4.60 (Windows - x86)
; CursorPosition = 20
; Folding = -
; EnableXP