;==========================================================================
; Generated with PureDLLHelper, Copyright ©2012 by Thomas <ts-soft> Schulz
;==========================================================================
XIncludeFile  "MemoryModule.pbi"

DataSection
  
  SkinH: IncludeBinary "SkinH.dll"
    
EndDataSection


Prototype  SkinH_AdjustAero(a, b, c, d, e, f, g, h, i)
Prototype  SkinH_AdjustHSV(a, b, c)
Prototype  SkinH_Attach()         ;pass
Prototype  SkinH_AttachEx(a, b)   ;pass
Prototype  SkinH_AttachExt(a, b, c, d, e)
Prototype  SkinH_AttachRes(a, b, c, d, e, f)
Prototype  SkinH_AttachResEx(a, b, c, d, e, f)
Prototype  SkinH_Detach()         ;pass
Prototype  SkinH_DetachEx(a)      ;pass
Prototype  SkinH_GetColor(a, b, c)
Prototype  SkinH_LockUpdate(a, b)
Prototype  SkinH_Map(a, b)
Prototype  SkinH_NineBlt(a, b, c, d, e, f)
Prototype  SkinH_SetAero(a)       ;pass
Prototype  SkinH_SetBackColor(a, b, c, d)
Prototype  SkinH_SetFont(a, b)
Prototype  SkinH_SetFontEx(a, b, c, d, e, f, g, h)
Prototype  SkinH_SetForeColor(a, b, c, d)
Prototype  SkinH_SetMenuAlpha(a)
Prototype  SkinH_SetTitleMenuBar(a, b, c, d, e)
Prototype  SkinH_SetWindowAlpha(a, b)
Prototype  SkinH_SetWindowMovable(a, b)
Prototype  SkinH_VerifySign()

Global SkinH_AdjustAero.SkinH_AdjustAero
Global SkinH_AdjustHSV.SkinH_AdjustHSV
Global SkinH_Attach.SkinH_Attach
Global SkinH_AttachEx.SkinH_AttachEx
Global SkinH_AttachExt.SkinH_AttachExt
Global SkinH_AttachRes.SkinH_AttachRes
Global SkinH_AttachResEx.SkinH_AttachResEx
Global SkinH_Detach.SkinH_Detach
Global SkinH_DetachEx.SkinH_DetachEx
Global SkinH_GetColor.SkinH_GetColor
Global SkinH_LockUpdate.SkinH_LockUpdate
Global SkinH_Map.SkinH_Map
Global SkinH_NineBlt.SkinH_NineBlt
Global SkinH_SetAero.SkinH_SetAero
Global SkinH_SetBackColor.SkinH_SetBackColor
Global SkinH_SetFont.SkinH_SetFont
Global SkinH_SetFontEx.SkinH_SetFontEx
Global SkinH_SetForeColor.SkinH_SetForeColor
Global SkinH_SetMenuAlpha.SkinH_SetMenuAlpha
Global SkinH_SetTitleMenuBar.SkinH_SetTitleMenuBar
Global SkinH_SetWindowAlpha.SkinH_SetWindowAlpha
Global SkinH_SetWindowMovable.SkinH_SetWindowMovable
Global SkinH_VerifySign.SkinH_VerifySign

Procedure.i SkinH_LoadDLL()
  Protected hDLL.i
  
  hDLL = MemoryLoadLibrary(?SkinH)
  If hDLL <> 0
    SkinH_AdjustAero = MemoryGetProcAddress(hDLL, "SkinH_AdjustAero")
    SkinH_AdjustHSV = MemoryGetProcAddress(hDLL, "SkinH_AdjustHSV")
    SkinH_Attach = MemoryGetProcAddress(hDLL, "SkinH_Attach")
    SkinH_AttachEx = MemoryGetProcAddress(hDLL, "SkinH_AttachEx")
    SkinH_AttachExt = MemoryGetProcAddress(hDLL, "SkinH_AttachExt")
    SkinH_AttachRes = MemoryGetProcAddress(hDLL, "SkinH_AttachRes")
    SkinH_AttachResEx = MemoryGetProcAddress(hDLL, "SkinH_AttachResEx")
    SkinH_Detach = MemoryGetProcAddress(hDLL, "SkinH_Detach")
    SkinH_DetachEx = MemoryGetProcAddress(hDLL, "SkinH_DetachEx")
    SkinH_GetColor = MemoryGetProcAddress(hDLL, "SkinH_GetColor")
    SkinH_LockUpdate = MemoryGetProcAddress(hDLL, "SkinH_LockUpdate")
    SkinH_Map = MemoryGetProcAddress(hDLL, "SkinH_Map")
    SkinH_NineBlt = MemoryGetProcAddress(hDLL, "SkinH_NineBlt")
    SkinH_SetAero = MemoryGetProcAddress(hDLL, "SkinH_SetAero")
    SkinH_SetBackColor = MemoryGetProcAddress(hDLL, "SkinH_SetBackColor")
    SkinH_SetFont = MemoryGetProcAddress(hDLL, "SkinH_SetFont")
    SkinH_SetFontEx = MemoryGetProcAddress(hDLL, "SkinH_SetFontEx")
    SkinH_SetForeColor = MemoryGetProcAddress(hDLL, "SkinH_SetForeColor")
    SkinH_SetMenuAlpha = MemoryGetProcAddress(hDLL, "SkinH_SetMenuAlpha")
    SkinH_SetTitleMenuBar = MemoryGetProcAddress(hDLL, "SkinH_SetTitleMenuBar")
    SkinH_SetWindowAlpha = MemoryGetProcAddress(hDLL, "SkinH_SetWindowAlpha")
    SkinH_SetWindowMovable = MemoryGetProcAddress(hDLL, "SkinH_SetWindowMovable")
    SkinH_VerifySign = MemoryGetProcAddress(hDLL, "SkinH_VerifySign")

    ProcedureReturn hDLL
  EndIf

  ProcedureReturn #False
EndProcedure


; IDE Options = PureBasic 4.60 (Windows - x86)
; CursorPosition = 19
; FirstLine = 3
; Folding = -
; EnableXP