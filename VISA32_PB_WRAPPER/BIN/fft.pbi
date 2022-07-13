;==========================================================================
; Generated with PureDLLHelper, Copyright 2012 by Thomas <ts-soft> Schulz
;==========================================================================
XIncludeFile  "MemoryModule.pbi"

DataSection
  
  fft: IncludeBinary "fft.dll"
    
EndDataSection

Prototype  FFT(a, b, c, d)

Global FFT.FFT

Procedure.i fft_LoadDLL()
  Protected hDLL.i

  hDLL  = MemoryLoadLibrary(?fft)
  If hDLL <> 0
    FFT = MemoryGetProcAddress(hDLL, "_FFT@16")

    ProcedureReturn hDLL
  EndIf

  ProcedureReturn #False
EndProcedure


; IDE Options = PureBasic 5.00 (Windows - x86)
; Folding = -
; EnableXP