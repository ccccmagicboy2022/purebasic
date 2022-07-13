Procedure SetWinTransparency(win, level)
  If level>=0 And level<101
    hLib = LoadLibrary_("user32.dll")
    If hLib
      adr = GetProcAddress_(hLib, "SetLayeredWindowAttributes")
      If adr
        SetWindowLong_(WindowID(win), #GWL_EXSTYLE, GetWindowLong_(WindowID(win), #GWL_EXSTYLE)|$00080000) ; #WS_EX_LAYERED = $00080000
        CallFunctionFast(adr, WindowID(win), 0, 255*level/100, 2)
      EndIf
      FreeLibrary_(hLib)
    EndIf
  EndIf
EndProcedure 
;---------------------------------------------------------------------
Procedure Uhr() 
  Time$ = FormatDate("%hh:%ii:%ss", Date()) 
  StatusBarText(0, 1, Time$, #PB_StatusBar_Center)
EndProcedure 
;---------------------------------------------------------------------
Procedure BalloonTip(WindowID, Gadget, Text$ , Title$, Icon)
  ToolTip=CreateWindowEx_(0,"ToolTips_Class32","",#WS_POPUP | #TTS_NOPREFIX | #TTS_BALLOON,0,0,0,0,WindowID,0,GetModuleHandle_(0),0)
  SendMessage_(ToolTip,#TTM_SETTIPTEXTCOLOR,GetSysColor_(#COLOR_INFOTEXT),0)
  SendMessage_(ToolTip,#TTM_SETTIPBKCOLOR,GetSysColor_(#COLOR_INFOBK),0)
  SendMessage_(ToolTip,#TTM_SETMAXTIPWIDTH,0,180)
  Balloon.TOOLINFO\cbSize=SizeOf(TOOLINFO)
  Balloon\uFlags=#TTF_IDISHWND | #TTF_SUBCLASS
  Balloon\hWnd=GadgetID(Gadget)
  Balloon\uId=GadgetID(Gadget)
  Balloon\lpszText=@Text$
  SendMessage_(ToolTip, #TTM_ADDTOOL, 0, Balloon)
  If Title$ > ""
    SendMessage_(ToolTip, #TTM_SETTITLE, Icon, @Title$)
  EndIf  
EndProcedure
;---------------------------------------------------------------------
ProcedureDLL.q select_card_pb()
  
  Enumeration
    #WINDOWS_MAIN
    #DLL_LIB
    #ButtonNext
    #ButtonClose
    #ListIcon_Res
    #TEXT
    #ButtonXilinx
    #ButtonPlx
    #ButtonOpencore
    #MENU_ABOUT
    #ButtonTest
    #SKIN_DLL2
  EndEnumeration
  
  ImageClose = CatchImage(0, ?Icon_close)
  ImageNext = CatchImage(1, ?Icon_next)
  ImageCard1 = CatchImage(2, ?Icon_card1)  
  ImageCard2 = CatchImage(3, ?Icon_card2) 
  ImageCard3 = CatchImage(4, ?Icon_card3) 
  ImageCard4 = CatchImage(5, ?Icon_card4)  
  ImageCard5 = CatchImage(6, ?Icon_card5) 
  ImageCard6 = CatchImage(7, ?Icon_card6) 
  ImageCard7 = CatchImage(8, ?Icon_card7)  
  ImageCard8 = CatchImage(9, ?Icon_card8) 
  ImageCard9 = CatchImage(10, ?Icon_card9)   
  ImageXilinx = CatchImage(11, ?Icon_xilinx) 
  ImagePlxIcon = CatchImage(12, ?Icon_PlxIcon) 
  ImageOpencore = CatchImage(13, ?Icon_opencore) 
  
  ExamineDesktops()
  OutputDebugString_("select_card_pb():: color depth is :" + Str(DesktopDepth(0)) + Chr(13))
  If  (DesktopDepth(0)  >=  16)
    OpenLibrary(#SKIN_DLL2, "SkinH.dll")
    CallFunction(#SKIN_DLL2, "SkinH_Attach")
  Else
    ;
  EndIf
  
  hWnd  = OpenWindow(#WINDOWS_MAIN, 0, 0, 390, 305, "in cvPXILib_PB.dll::select_card_pb()", #PB_Window_SystemMenu | #PB_Window_ScreenCentered)
  
  If  (DesktopDepth(0)  >=  16)
    CallFunction(#SKIN_DLL2, "SkinH_SetAero", hWnd)
  Else
    ;
  EndIf    
  
  SetWindowColor(#WINDOWS_MAIN, $D8E9EC) 
  SetWindowPos_(hWnd, #HWND_TOP, 0, 0, 0, 0, #SWP_NOMOVE|#SWP_NOSIZE) ; 总在最上
  SetWinTransparency(#WINDOWS_MAIN, 98)	; 设置透明度
  TextGadget(#TEXT, 20,  7, 300, 25, "PLEASE CHOOSE ONE CARD FIRST",#PB_Text_Center)
  
  CreateStatusBar(#WINDOWS_MAIN, hWnd)
  AddStatusBarField(120)  
  StatusBarText(#WINDOWS_MAIN, 0, "cccc", #PB_StatusBar_Center | #PB_StatusBar_Raised)
  AddStatusBarField(120) 
  SetTimer_(WindowID(#WINDOWS_MAIN), 1, 200, @Uhr()) ;alle 200 mS die Uhr aktualisieren 

  
  CreateMenu(#WINDOWS_MAIN, WindowID(#WINDOWS_MAIN))    ; here the menu creating starts....
  MenuTitle("&Help")
  MenuItem(#MENU_ABOUT, "&About")
  
  ButtonGadget(#ButtonNext, 300, 220, 80, 40, "Next-->", #PB_Button_Default)
  AddKeyboardShortcut(#WINDOWS_MAIN, #PB_Shortcut_Return, #ButtonNext) 
  GadgetToolTip(#ButtonNext, "下一步")
  
  ButtonGadget(#ButtonClose, 10, 220, 60, 40, "Close_X")
  AddKeyboardShortcut(#WINDOWS_MAIN, #PB_Shortcut_Escape, #ButtonClose) 
  GadgetToolTip(#ButtonClose, "取消")
  
  ButtonGadget(#ButtonXilinx, 160, 220, 50, 40, "Xilinx", #PB_Button_Toggle)
  BalloonTip(GadgetID(#ButtonXilinx), #ButtonXilinx, "cv", "列出使用xilinx pci ipcore的板卡", #TOOLTIP_INFO_ICON)
  
  
  ButtonGadget(#ButtonPlx, 90, 220, 50, 40, "Plx9054", #PB_Button_Toggle)
  BalloonTip(GadgetID(#ButtonPlx), #ButtonPlx, "cv", "列出使用plx9054桥接芯片的板卡", #TOOLTIP_INFO_ICON)
  
  
  ButtonGadget(#ButtonOpencore, 230, 220, 50, 40, "OC", #PB_Button_Toggle)
  BalloonTip(GadgetID(#ButtonOpencore), #ButtonOpencore, "cv", "列出使用open core pci核的板卡", #TOOLTIP_INFO_ICON)

  
  ListIconGadget(#ListIcon_Res, 0, 25, 390, 195, "CARD_FIND", 80, #PB_ListIcon_GridLines|#PB_ListIcon_FullRowSelect|#PB_ListIcon_HeaderDragDrop)
  AddGadgetColumn(#ListIcon_Res, 1, "IDENTIFIER", 135)
  AddGadgetColumn(#ListIcon_Res, 2, "DID/VID", 65)
  AddGadgetColumn(#ListIcon_Res, 3, "Bridge", 65)
  SendMessage_(WindowID(#WINDOWS_MAIN), #WM_SETICON, #False, ImageCard6) 
  
  OpenLibrary(#DLL_LIB, "cvPXILib.dll")
  For x.l = 0 To $1fff
    temp.q = x*$800
    temp  | $80000000
    temp2.q = CallFunction(#DLL_LIB, "_PCR_Read@8", temp, 0)
    temp3.q = temp2 & $ffff
    temp4.q = temp2 & $ffffffff
    If  ((temp2  <>  $ffffffffffffffff) And  (temp3 <> $8086))
      bus	=	(temp&$00ff0000)/$10000;
	    device	=	(temp&$0000f800)/$800;
	    function	=	(temp&$700)/$100;
	    identifer.s = "bus:"  + RSet(Hex(bus), 2, "0") + " dev:" + RSet(Hex(device), 2, "0") + " fun:" + RSet(Hex(function), 2, "0")
      AddGadgetItem(#ListIcon_Res, -1, Hex(temp)+Chr(10)+identifer+Chr(10)+RSet(Hex(temp4), 8, "0"), ImageCard1)
    EndIf
  Next x  
  CloseLibrary(#DLL_LIB)

  quit.b  = #False
  
  Repeat
    Event.l = WaitWindowEvent()
    Select  Event
      Case  #PB_Event_Gadget
        Select  EventGadget()
          Case  #ButtonClose
            quit  = #True
          Case  #ButtonNext
            Result.l = GetGadgetState(#ListIcon_Res)  
            If  (Result = -1)
              MessageRequester("select_card_pb()", "Please select one card!", #PB_MessageRequester_Ok)
              Continue
            Else
              cccc.q = Val("$"  + GetGadgetItemText(#ListIcon_Res, Result, 0))
            EndIf
            quit  = #True
          Case  #ListIcon_Res
            Select EventType()
              Case #PB_EventType_LeftDoubleClick
                Result = GetGadgetState(#ListIcon_Res)  
                If  (Result = -1)
                  MessageRequester("select_card_pb()", "Please select one card!", #PB_MessageRequester_Ok)
                  Continue
                Else
                  cccc.q = Val("$"  + GetGadgetItemText(#ListIcon_Res, Result, 0))
                EndIf
                quit  = #True
            EndSelect
        EndSelect
      Case  #PB_Event_Menu
          Select EventMenu()
            Case  #ButtonClose
              quit  = #True
            Case  #ButtonNext
              Result.l = GetGadgetState(#ListIcon_Res)  
              If  (Result = -1)
                MessageRequester("select_card_pb()", "Please select one card!", #PB_MessageRequester_Ok)
                Continue
              Else
                cccc.q = Val("$"  + GetGadgetItemText(#ListIcon_Res, Result, 0))
              EndIf
              quit  = #True
            Case  #MENU_ABOUT
              CreateThread(@About(), #Null)
          EndSelect 
    EndSelect
  Until Event = #PB_Event_CloseWindow Or  quit  = #True  
  
  KillTimer_(WindowID(#WINDOWS_MAIN), 1)
  CloseWindow(#WINDOWS_MAIN)
  
  If  (DesktopDepth(0)  >=  16)
    CallFunction(#SKIN_DLL2, "SkinH_Detach")
    CloseLibrary(#SKIN_DLL2)
  Else
    ;
  EndIf   
  
  FreeImage(0)
  FreeImage(1)
  FreeImage(2)
  
  OutputDebugString_("select_card_pb():: card id is : 0x" + Hex(cccc) + Chr(13))
  ProcedureReturn cccc
  
EndProcedure





;
; PureBUILD Build = 1 [generated by PureBUILD Plugin]
; IDE Options = PureBasic 4.50 (Windows - x86)
; CursorPosition = 188
; FirstLine = 177
; Folding = -
; EnableXP