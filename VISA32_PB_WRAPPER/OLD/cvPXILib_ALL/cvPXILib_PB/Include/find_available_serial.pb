ProcedureDLL.q  find_available_serial(*result)
  
  Image_rs232 = CatchImage(#PB_Any, ?icon_rs232)
  
  hWnd  = OpenWindow(#PB_Any, 0, 0, 300, 120, "in cvPXILib_PB.dll::find_available_serial()", #PB_Window_SystemMenu | #PB_Window_ScreenCentered)
  SetWindowPos_(WindowID(hWnd), #HWND_TOPMOST, 0, 0, 0, 0, #SWP_NOMOVE|#SWP_NOSIZE)
  SetWinTransparency(hWnd, 95)
  SendMessage_(WindowID(hWnd), #WM_SETICON, #False, ImageID(Image_rs232))
  CB_hWnd = ComboBoxGadget(#PB_Any, 10, 10, 280, 25, #PB_ComboBox_Image)

  For k = 1 To 100 Step 1
    serial.s  = ReplaceString("COM1", "1", Str(k))
    If OpenSerialPort(0, serial, 300, #PB_SerialPort_NoParity, 8, 1, #PB_SerialPort_NoHandshake, 1024, 1024)
      AddGadgetItem(CB_hWnd, -1, serial, ImageID(Image_rs232))
      CloseSerialPort(0)
      ;Beep_(800,100)
    Else
      ;
    EndIf
  Next

  SetGadgetState(CB_hWnd, 0)
  
  button_next = ButtonGadget(#PB_Any, 50, 50, 70, 20, "Next-->", #PB_Button_Default)
  AddKeyboardShortcut(hWnd, #PB_Shortcut_Return, 0) 
  GadgetToolTip(button_next, "ÏÂÒ»²½")
  
  Repeat
    Event.l = WaitWindowEvent()
    Select  Event
      Case  #PB_Event_Gadget
        Select  EventGadget()
          Case  button_next
            quit  = #True
        EndSelect
      Case  #PB_Event_Menu
        Select EventMenu()
          Case  0
            quit  = #True
        EndSelect 
    EndSelect
  Until Event = #PB_Event_CloseWindow Or  quit  = #True 

  selected_item = GetGadgetState(CB_hWnd)
  selected_source.s  = GetGadgetItemText(CB_hWnd, selected_item)
  PokeS(*result, selected_source)   

  CloseWindow(hWnd)
  FreeImage(Image_rs232)
  
  ProcedureReturn	selected_item

EndProcedure

; IDE Options = PureBasic 4.50 (Windows - x86)
; CursorPosition = 23
; FirstLine = 9
; Folding = -
; EnableXP