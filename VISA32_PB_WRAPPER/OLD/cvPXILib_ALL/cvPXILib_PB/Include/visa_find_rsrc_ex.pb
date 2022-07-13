ProcedureDLL.q  visa_find_rsrc_ex(*result)
  
  Enumeration
    #DLL_LIB_visa_rsrc
    #WINDOWS_MAIN_visa_rsrc
    #ComboBoxGadget
    #ButtonNext_visa_rsrc
    #SKIN_DLL
  EndEnumeration
  
  Image_visa32 = CatchImage(0, ?Icon_visa32)  ;visa32的图标
  Image_lxi = CatchImage(1, ?Icon_lxi)
  
  ExamineDesktops()
  OutputDebugString_("visa_find_rsrc_ex():: color depth is :" + Str(DesktopDepth(0)))
  If  (DesktopDepth(0)  >=  16)
    OpenLibrary(#SKIN_DLL, "SkinH.dll")
    CallFunction(#SKIN_DLL, "SkinH_Attach")
  Else
    ;
  EndIf
  
  *Buffer = AllocateMemory(3000) ;新建内存 
  OpenLibrary(#DLL_LIB_visa_rsrc, "cvPXILib.dll")
  count.q = CallFunction(#DLL_LIB_visa_rsrc, "_visa_find_rsrc@4", *Buffer)  
  all_item.s  = PeekS(*Buffer) 
  FreeMemory(*Buffer)
  item_count.q = CountString(all_item, "::INSTR")
  
  hWnd  = OpenWindow(#WINDOWS_MAIN_visa_rsrc, 0, 0, 350, 120, "in cvPXILib_PB.dll::visa_find_rsrc_ex()", #PB_Window_SystemMenu | #PB_Window_ScreenCentered)
  
  If  (DesktopDepth(0)  >=  16)
    CallFunction(#SKIN_DLL, "SkinH_SetAero", hWnd)
  Else
    ;
  EndIf   
  
  SetWindowColor(#WINDOWS_MAIN_visa_rsrc, $E8E8E8) 
  SetWindowPos_(hWnd, #HWND_TOP, 0, 0, 0, 0, #SWP_NOMOVE|#SWP_NOSIZE) ; 总在最上
  SetWinTransparency(#WINDOWS_MAIN_visa_rsrc, 98)	; 设置透明度  
  SendMessage_(WindowID(#WINDOWS_MAIN_visa_rsrc), #WM_SETICON, #False, Image_visa32)
  CB_hWnd = ComboBoxGadget(#ComboBoxGadget, 10, 10, 330, 25, #PB_ComboBox_Image | #PB_ComboBox_Editable)
  For k=1 To item_count
    find_item.s = StringField(all_item, k, " ")
    If  (Left(find_item,5)  = "TCPIP")
      AddGadgetItem(#ComboBoxGadget, -1, find_item, Image_lxi)
    Else
      AddGadgetItem(#ComboBoxGadget, -1, find_item, Image_visa32)
    EndIf
  Next
  SetGadgetState(#ComboBoxGadget, 0)
  
  ButtonGadget(#ButtonNext_visa_rsrc, 50, 50, 80, 40, "Next-->", #PB_Button_Default)
  AddKeyboardShortcut(#WINDOWS_MAIN_visa_rsrc, #PB_Shortcut_Return, #ButtonNext_visa_rsrc) 
  GadgetToolTip(#ButtonNext_visa_rsrc, "下一步")
  
  Repeat
    Event.l = WaitWindowEvent()
    Select  Event
      Case  #PB_Event_Gadget
        Select  EventGadget()
          Case  #ButtonNext_visa_rsrc
            quit  = #True
        EndSelect
      Case  #PB_Event_Menu
        Select EventMenu()
          Case  #ButtonNext_visa_rsrc
            quit  = #True
        EndSelect 
    EndSelect
  Until Event = #PB_Event_CloseWindow Or  quit  = #True  
  
  selected_item = GetGadgetState(#ComboBoxGadget)
  selected_source.s  = GetGadgetItemText(#ComboBoxGadget, selected_item)
  PokeS(*result, selected_source)   
  
  If  (DesktopDepth(0)  >=  16)
    CallFunction(#SKIN_DLL, "SkinH_Detach")
    CloseLibrary(#SKIN_DLL)
  Else
    ;
  EndIf    
  
  CloseWindow(#WINDOWS_MAIN_visa_rsrc)
  CloseLibrary(#DLL_LIB_visa_rsrc)
  FreeImage(0)
  
  OutputDebugString_("visa_find_rsrc_ex():: visa resource is : " + selected_source)
  ProcedureReturn	selected_item
  
EndProcedure
; IDE Options = PureBasic 4.50 (Windows - x86)
; CursorPosition = 38
; FirstLine = 29
; Folding = -
; EnableXP