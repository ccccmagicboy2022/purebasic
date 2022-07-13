ProcedureDLL  bar_and_offset(*result)
  
  icon = CatchImage(#PB_Any, ?Icon_bar)
  
  hWnd  = OpenWindow(#PB_Any, 0, 0, 540, 235, "in cvPXILib_PB.dll::bar_and_offset()", #PB_Window_SystemMenu | #PB_Window_ScreenCentered)
  
  SetWindowColor(hWnd, $E8E8E8) 
  SetWindowPos_(hWnd, #HWND_TOP, 0, 0, 0, 0, #SWP_NOMOVE|#SWP_NOSIZE)
  
  SendMessage_(WindowID(hWnd), #WM_SETICON, #False, ImageID(icon)) 
  
  SetWinTransparency(hWnd, 90)
  
  CB_hWnd = ComboBoxGadget(#PB_Any, 10, 10, 330, 25, #PB_ComboBox_Image | #PB_ComboBox_Editable)
  
  AddGadgetItem(CB_hWnd, -1, "bar0", ImageID(icon))
  AddGadgetItem(CB_hWnd, -1, "bar1", ImageID(icon))
  AddGadgetItem(CB_hWnd, -1, "bar2", ImageID(icon))
  AddGadgetItem(CB_hWnd, -1, "bar3", ImageID(icon))
  AddGadgetItem(CB_hWnd, -1, "bar4", ImageID(icon))
  AddGadgetItem(CB_hWnd, -1, "bar5", ImageID(icon))
  
  button1 = ButtonGadget(#PB_Any, 20, 200, 90, 25, "normal", #PB_Button_Default)
  GadgetToolTip(button1, "normal")
  
  button2 = ButtonGadget(#PB_Any, 160, 200, 90, 25, "read_only")
  GadgetToolTip(button2, "read_only")
  
  button3 = ButtonGadget(#PB_Any, 300, 200, 90, 25, "exit")
  GadgetToolTip(button3, "exit")  
  
  
  
  
  Repeat
    Event.l = WaitWindowEvent()
    Select  Event
      Case  #PB_Event_Gadget
        Select  EventGadget()
          Case  button1
            Beep_(1000,25)
          Case  button3
        EndSelect
      Case  #PB_Event_Menu
        Select EventMenu()
          Case  button1
            quit  = #True
        EndSelect 
    EndSelect
  Until Event = #PB_Event_CloseWindow Or  quit  = #True    
  
  
  
  
  
  PokeS(*result, "aaa")    
  
  
  
  CloseWindow(hWnd)
  FreeImage(icon)
  
  OutputDebugString_("bar_and_offset()::xxxx")  
  
  
EndProcedure  

; IDE Options = PureBasic 4.50 (Windows - x86)
; CursorPosition = 20
; FirstLine = 5
; Folding = -
; EnableXP