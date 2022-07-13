Procedure  progress_win(long.l)
  
  Protected hwnd  = OpenWindow(#PB_Any, 0, 0, 300, 70, "Timed Progress...", #PB_Window_Tool|#PB_Window_SystemMenu|#PB_Window_ScreenCentered)
  StickyWindow(hwnd, #True)
  pbg = ProgressBarGadget(#PB_Any, 10, 10, 280, 35, 0, long, #PB_ProgressBar_Smooth)
  SetWindowTitle(hwnd, "Please Waiting For " + Str(long) + "ms")
  
  AddKeyboardShortcut(hwnd, #PB_Shortcut_Escape, 500) ;exit
  
  If OSVersion() < #PB_OS_Windows_7
    ;
  Else
    Aerotic_Apply(WindowID(hwnd), -1, -1, -1, -1)
  EndIf  
  
  StartTime = ElapsedMilliseconds()
  
  Repeat
    If GetGadgetState(pbg) < long
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
  
  CloseWindow(hwnd)
  
EndProcedure

ProcedureDLL.l  progress_win_thread(long.l)
  ProcedureReturn CreateThread(@progress_win(), long)  
EndProcedure

; IDE Options = PureBasic 5.00 (Windows - x86)
; CursorPosition = 4
; Folding = -
; EnableXP