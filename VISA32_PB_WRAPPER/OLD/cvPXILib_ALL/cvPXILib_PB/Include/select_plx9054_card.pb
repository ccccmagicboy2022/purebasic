;-----------------------------------------------------------------------------------------------
ProcedureDLL.q  select_plx9054_card()
  
  Enumeration
    #DLL_LIB_plx9054
    #WINDOWS_MAIN_plx9054
    #ComboBoxGadget_plx9054
    #ButtonNext_plx9054
    #SKIN_DLL_plx9054
  EndEnumeration
  
  ImageCard9 = CatchImage(0, ?Icon_card9)  ;图标
  ImageCard2 = CatchImage(1, ?Icon_card2)  ;图标
  
  ExamineDesktops()
  OutputDebugString_("select_plx9054_card():: color depth is :" + Str(DesktopDepth(0)))
  If  (DesktopDepth(0)  >=  16)
    OpenLibrary(#SKIN_DLL_plx9054, "SkinH.dll")
    CallFunction(#SKIN_DLL_plx9054, "SkinH_Attach")
  Else
    ;
  EndIf
  
  hWnd  = OpenWindow(#WINDOWS_MAIN_plx9054, 0, 0, 350, 120, "in cvPXILib_PB.dll::select_plx9054_card()", #PB_Window_SystemMenu | #PB_Window_ScreenCentered)
  
  If  (DesktopDepth(0)  >=  16)
    CallFunction(#SKIN_DLL_plx9054, "SkinH_SetAero", hWnd)
  Else
    ;
  EndIf  
  
  SetWindowColor(#WINDOWS_MAIN_plx9054, $E8E8E8) 
  SetWindowPos_(hWnd, #HWND_TOP, 0, 0, 0, 0, #SWP_NOMOVE|#SWP_NOSIZE) ; 总在最上
  SetWinTransparency(#WINDOWS_MAIN_plx9054, 98)	; 设置透明度  
  SendMessage_(WindowID(#WINDOWS_MAIN_plx9054), #WM_SETICON, #False, ImageCard2)
  CB_hWnd = ComboBoxGadget(#ComboBoxGadget_plx9054, 10, 10, 330, 25, #PB_ComboBox_Image)
  
  ButtonGadget(#ButtonNext_plx9054, 50, 50, 80, 40, "Next-->", #PB_Button_Default)
  AddKeyboardShortcut(#WINDOWS_MAIN_plx9054, #PB_Shortcut_Return, #ButtonNext_plx9054) 
  GadgetToolTip(#ButtonNext_plx9054, "下一步")
  
  OpenLibrary(#DLL_LIB_plx9054, "cvPXILib.dll")
  For x.l = 0 To $1fff
    temp.q = x*$800
    temp  | $80000000
    temp2.q = CallFunction(#DLL_LIB_plx9054, "_PCR_Read@8", temp, 0)
    bar0.q  = CallFunction(#DLL_LIB_plx9054, "_PCR_Read@8", temp, $010)
    reg9054check.q  = bar0  + $70
    temp3.q = temp2 & $ffff
    temp4.q = temp2 & $ffffffff
    If  ((temp2  <>  $ffffffffffffffff) And  (temp3 <> $8086))
      bus	=	(temp&$00ff0000)/$10000;
	    device	=	(temp&$0000f800)/$800;
	    function	=	(temp&$700)/$100;
	    identifer.s = "bus:"  + RSet(Hex(bus), 2, "0") + " dev:" + RSet(Hex(device), 2, "0") + " fun:" + RSet(Hex(function), 2, "0")
	    If  (CallFunction(#DLL_LIB_plx9054, "_ReadPhyMem32@4", reg9054check)  = $905410B5)
	      AddGadgetItem(#ComboBoxGadget_plx9054, -1, Hex(temp)+" "+identifer+" "+RSet(Hex(temp4), 8, "0"), ImageCard2)
	    Else
	      AddGadgetItem(#ComboBoxGadget_plx9054, -1, Hex(temp)+" "+identifer+" "+RSet(Hex(temp4), 8, "0"), ImageCard9)
	    EndIf     
	  EndIf
  Next x  
  CloseLibrary(#DLL_LIB_plx9054)  
  SetGadgetState(#ComboBoxGadget_plx9054, 0)     
  
  Repeat
    Event.l = WaitWindowEvent()
    Select  Event
      Case  #PB_Event_Gadget
        Select  EventGadget()
          Case  #ButtonNext_plx9054
            quit  = #True
            Result.l = GetGadgetState(#ComboBoxGadget_plx9054)  
            If  (Result = -1)
              MessageRequester("select_plx9054_card()", "Please select one card!", #PB_MessageRequester_Ok)
              Continue
            Else
              cccc.q = Val("$"  + Left(GetGadgetItemText(#ComboBoxGadget_plx9054, Result), 8))
            EndIf
        EndSelect
      Case  #PB_Event_Menu
        Select EventMenu()
          Case  #ButtonNext_plx9054
            quit  = #True
            Result.l = GetGadgetState(#ComboBoxGadget_plx9054)  
            If  (Result = -1)
              MessageRequester("select_plx9054_card()", "Please select one card!", #PB_MessageRequester_Ok)
              Continue
            Else
              cccc.q = Val("$"  + Left(GetGadgetItemText(#ComboBoxGadget_plx9054, Result), 8))
            EndIf
        EndSelect 
    EndSelect
  Until Event = #PB_Event_CloseWindow Or  quit  = #True  
    
  If  (DesktopDepth(0)  >=  16)
    CallFunction(#SKIN_DLL_plx9054, "SkinH_Detach")
    CloseLibrary(#SKIN_DLL_plx9054)
  Else
    ;
  EndIf   
  
  CloseWindow(#WINDOWS_MAIN_plx9054)
  CloseLibrary(#DLL_LIB_plx9054)
  FreeImage(0)
  
  OutputDebugString_("select_plx9054_card():: card id is : 0x" + Hex(cccc))
  ProcedureReturn	cccc
  
EndProcedure
; IDE Options = PureBasic 4.50 (Windows - x86)
; CursorPosition = 32
; FirstLine = 9
; Folding = -
; EnableXP