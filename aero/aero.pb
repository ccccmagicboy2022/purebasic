ProcedureDLL.l  aero_apply(hwnd.l, p1.l, p2.l, p3.l, p4.l)
  
  If OSVersion() < #PB_OS_Windows_Vista
    ProcedureReturn  0
  Else
    Aerotic_Apply(hwnd, p1, p2, p3, p4)
    ProcedureReturn  1
  EndIf
  
EndProcedure

ProcedureDLL.l  aero_remove(hwnd.l)
  
  If OSVersion() < #PB_OS_Windows_Vista
    ProcedureReturn  0
  Else
    Aerotic_Remove(hwnd)
    ProcedureReturn  1
  EndIf
  
EndProcedure

ProcedureDLL.l  aero_init()
  
  If OSVersion() < #PB_OS_Windows_Vista
    ProcedureReturn  0
  Else
    Aerotic_Initialize()
    ProcedureReturn  1
  EndIf
  
EndProcedure

ProcedureDLL.l  aero_final()
  
  If OSVersion() < #PB_OS_Windows_Vista
    ProcedureReturn  0
  Else
    Aerotic_Finalize()
    ProcedureReturn  1
  EndIf
  
EndProcedure

ProcedureDLL.l  aero_test()
  hwnd  = OpenWindow(#PB_Any, 0, 0, 300, 70, "Timed Progress...", #PB_Window_Tool|#PB_Window_SystemMenu|#PB_Window_ScreenCentered)
  StickyWindow(hwnd, #True)
  pbg = ProgressBarGadget(#PB_Any, 10, 10, 280, 35, 0, 10000, #PB_ProgressBar_Smooth)
  SetWindowTitle(hwnd, "Please Waiting For " + Str(10000) + "ms")
  
  AddKeyboardShortcut(hwnd, #PB_Shortcut_Escape, 500) ;exit
  
  aero_init()
  aero_apply(WindowID(hwnd), -1, -1, -1, -1)
  
  StartTime = ElapsedMilliseconds()
  
  Repeat
    If GetGadgetState(pbg) < 10000
      SetGadgetState(pbg, GetGadgetState(pbg) + 1)
      SetWindowTitle(hwnd, Str(ElapsedMilliseconds()-StartTime) + "ms")
      Delay(1)
      If  500 = EventMenu()
        quit  = #True
      EndIf
    Else
      quit  = #True
    EndIf
  Until WindowEvent() = #PB_Event_CloseWindow Or  quit  = #True
  
  aero_remove(WindowID(hwnd))
  aero_final()
  CloseWindow(hwnd)
  ProcedureReturn 0
EndProcedure

; IDE Options = PureBasic 5.11 (Windows - x86)
; ExecutableFormat = Shared Dll
; CursorPosition = 16
; Folding = -
; EnableThread
; EnableXP
; EnableAdmin
; Executable = aero.dll
; EnableCompileCount = 15
; EnableBuildCount = 13
; EnableExeConstant
; IncludeVersionInfo
; VersionField0 = 1,0,0,%BUILDCOUNT
; VersionField1 = 1,0,0,%BUILDCOUNT
; VersionField2 = cv aero
; VersionField3 = cv aero
; VersionField4 = cv aero
; VersionField5 = 1,0,0,%BUILDCOUNT
; VersionField6 = cv aero
; VersionField7 = cv aero
; VersionField8 = cv aero
; VersionField15 = VOS_NT
; VersionField16 = VFT_DLL
; VersionField17 = 0804 Chinese (PRC)