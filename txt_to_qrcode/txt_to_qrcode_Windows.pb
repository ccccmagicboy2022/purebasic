  ;11/04/2012 20:58:21
  IncludePath "BIN"
  XIncludeFile  "qrcodelib.pbi"
  
  Macro AddIncludeFile(num, In)
    DataSection
      file_start#num:
        IncludeBinary In
      file_end#num:
    EndDataSection   
  EndMacro
  
  AddIncludeFile(1, "cv.ico")  
  
  Procedure HookCB(uMsg, wParam, lParam)
     
     Select uMsg
       Case #HCBT_SETFOCUS
         r.RECT
         hwnd = FindWindow_(#Null, "Please choose file to load")
         SendMessage_(hwnd, #WM_SIZE, #SIZE_MAXIMIZED, #Null)
     EndSelect
     
     ProcedureReturn #False
  EndProcedure  
  
  Procedure WinCallBack(hwnd, uMsg, wParam, lParam) 
    
    Select  uMsg
      Case  #WM_MOUSEWHEEL
        zDelta.w = ($CC000000&wParam)>>16
        xPos.w = ($0000ffff&lParam)
        yPos.w = ($CC000000&lParam)>>16
      Case  #WM_LBUTTONDOWN
        ;
      Case #WM_SIZE
        Select wParam
          Case #SIZE_MINIMIZED
            ShowWindow_(hwnd, #SW_HIDE)
          Case #SIZE_RESTORED
            ; 
          Case #SIZE_MAXIMIZED
            ;
        EndSelect
    EndSelect
   
    ProcedureReturn #PB_ProcessPureBasicEvents 
    
  EndProcedure    
  
  Procedure Uhr() 
	  ;
	EndProcedure   
	
	
	;PureValid_CheckFile("cccc");check
  current.s = Space(255)
  GetModuleFileName_(0, current, #MAX_PATH)
  ;current.s = GetCurrentDirectory()
  
  
  current = GetPathPart(current)	
  current = current + ProgramParameter(0)
  Debug current
  ;MessageRequester(current, "cc")
  
  If  ProgramParameter(0) = ""
    MessageBox_(GetFocus_(), "no parameter!", "-=cv=- 2012.6", #MB_OK|#MB_ICONERROR|#MB_SYSTEMMODAL)
    StandardFile.s = "txt.txt"
    Pattern.s = "txt (*.txt)|*.txt|All files (*.*)|*.*"
    hook.l = SetWindowsHookEx_(#WH_CBT, @HookCB(), GetModuleHandle_(0), GetCurrentThreadId_())
    txt_file_path.s = OpenFileRequester("Please choose file to load", StandardFile, Pattern, 0)
    UnhookWindowsHookEx_(hook)
    
    If txt_file_path
      ;
    Else
      MessageBox_(GetFocus_(), "no file selected!!!", "-=cv=- 2012.6", #MB_OK|#MB_ICONERROR|#MB_SYSTEMMODAL)
      End
    EndIf
  Else
    Select  FileSize(current)
      Case  -1
        MessageBox_(GetFocus_(), "file is not exist!", "-=cv=- 2012.6", #MB_OK|#MB_ICONERROR|#MB_SYSTEMMODAL)
        End
      Case  -2
        MessageBox_(GetFocus_(), "please do not use folder!", "-=cv=- 2012.6", #MB_OK|#MB_ICONERROR|#MB_SYSTEMMODAL)
        End
      Default
        If  "txt" = GetExtensionPart(current)
          txt_file_path  = current

        Else
          MessageBox_(GetFocus_(), "txt file only!", "-=cv=- 2012.6", #MB_OK|#MB_ICONERROR|#MB_SYSTEMMODAL)
          End          
        EndIf
    EndSelect    
  EndIf  
    
  test_icon  = 0  
  ExtractIconEx_("shell32.dll", 2, #Null, @test_icon, 1)  ;small icon
  test_icon2  = 0  
  ExtractIconEx_("shell32.dll", 2, @test_icon2, #Null, 1)  ;big icon
  
  cv_icon = CatchImage(#PB_Any, ?file_start1)
  
  Define  usrW.s{1048576} = ""
  
  
  hwnd  = OpenWindow(#PB_Any, 0, 0, 480, 352, "txt_to_qrcode_cv", #PB_Window_MinimizeGadget|#PB_Window_ScreenCentered|#PB_Window_SystemMenu)
  SetWindowPos_(WindowID(hWnd), #HWND_TOPMOST, 0, 0, 0, 0, #SWP_NOMOVE|#SWP_NOSIZE)
  SendMessage_(WindowID(hwnd), #WM_SETICON, #False, test_icon)  ;small icon
  SendMessage_(WindowID(hwnd), #WM_SETICON, #True, test_icon2)  ;big icon
  SetWindowTitle(hwnd, GetPathPart(txt_file_path))
  
  SmartWindowRefresh(hwnd, 1)     
      
  toolbar_t = CreateToolBar(#PB_Any, WindowID(hwnd))
  If toolbar_t
    ToolBarStandardButton(1, #PB_ToolBarIcon_Print, #PB_ToolBar_Normal)
  EndIf  
  
  ToolBarToolTip(toolbar_t, 1, "打印")  
  
  statusbar_t = CreateStatusBar(#PB_Any, WindowID(hwnd))
  
  If statusbar_t
    AddStatusBarField(#PB_Ignore)
  EndIf    
  
  StatusBarText(statusbar_t, 0, UCase("welcome to txt to qrcode design by cv 2013!"))
  
  tray  = AddSysTrayIcon(#PB_Any, WindowID(hwnd), test_icon)
  SysTrayIconToolTip(tray, "build by cccc")
  
  menu1 = CreatePopupImageMenu(#PB_Any)
  If menu1
    MenuItem(2, "&EXIT")
  EndIf  
  
  menu2 = CreateImageMenu(#PB_Any, WindowID(hwnd))
  If  menu2 
    MenuTitle("HELP")
      MenuItem(3, "&About", test_icon)  
    MenuTitle("EXIT")
      MenuItem(2, "&Exit", test_icon)
  EndIf
  
  explor  = ExplorerListGadget(#PB_Any, 0, ToolBarHeight(toolbar_t), 200, 2+WindowHeight(hwnd)-ToolBarHeight(toolbar_t)-StatusBarHeight(statusbar_t)*2, GetPathPart(txt_file_path) + "*.txt", #PB_Explorer_AlwaysShowSelection|#PB_Explorer_NoFolders|#PB_Explorer_NoParentFolder|#PB_Explorer_NoDirectoryChange|#PB_Explorer_GridLines|#PB_Explorer_AutoSort)
  SetGadgetAttribute(explor, #PB_Explorer_DisplayMode, #PB_Explorer_List)    
  SetGadgetColor(explor, #PB_Gadget_BackColor, $00FFFF)
  
  image_frame = CreateImage(#PB_Any, 280, 280)
  qrcode_image  = CreateQRCode("cv@2012 TXT --> QRCODE", #PB_Any, #QR_ECLEVEL_M, 8)
  ResizeImage(qrcode_image, 180, 180, #PB_Image_Raw)  
  
  If StartDrawing(ImageOutput(image_frame))
    DrawingMode(#PB_2DDrawing_Default)
    Box(0, 0, ImageWidth(image_frame), ImageHeight(image_frame), RGB(255, 255, 255))
    x_p = (280 - ImageWidth(qrcode_image))>>1
    y_p = (280 - ImageHeight(qrcode_image))>>1
    Box(x_p-20, y_p-20, 30, 3, $CC0000)
    Box(x_p-20, y_p-20, 3, 30, $CC0000)
    Box(x_p+ImageWidth(qrcode_image) -10, y_p-20, 30, 3, $CC0000)
    Box(x_p+ImageWidth(qrcode_image) +17, y_p-20, 3, 30, $CC0000)
    Box(x_p-20, y_p+ImageHeight(qrcode_image)+17, 30, 3, $CC0000)    
    Box(x_p-20, y_p+ImageHeight(qrcode_image)-10, 3, 30, $CC0000)
    Box(x_p+ImageWidth(qrcode_image) -10, y_p+ImageHeight(qrcode_image)+17, 30, 3, $CC0000)
    Box(x_p+ImageWidth(qrcode_image) +17, y_p+ImageHeight(qrcode_image)-10, 3, 30, $CC0000)
    DrawImage(ImageID(qrcode_image), x_p, y_p)
    DrawImage(ImageID(cv_icon), 120, 80)
    DrawText(125, 125, "cccc", $000000, $FFFFFF)
    StopDrawing() 
  EndIf
    
  barcode_ig  = ImageGadget(#PB_Any, 200, ToolBarHeight(toolbar_t), 280, 280, #Null, #PB_Image_Border)

  SetGadgetState(barcode_ig, ImageID(image_frame))
  
  AddKeyboardShortcut(hwnd, #PB_Shortcut_Escape, 4)
  
  SetTimer_(WindowID(hwnd), 1, 500, @Uhr())
  
  AddWindowTimer(hwnd, 0, 100)
  SetWindowCallback(@WinCallBack(), hwnd)
  
  Define  file_data.s{1048576}  ;1mbyte max
  Define  file_name.s
  Define  file_h.l
  
  Repeat
    Event.l = WaitWindowEvent()
    Select  Event
      Case	#WM_RBUTTONDOWN
        ;
      Case #PB_Event_SysTray
        Select  EventType()
          Case  #PB_EventType_RightClick
            DisplayPopupMenu(menu1, WindowID(hwnd))
          Case  #PB_EventType_LeftDoubleClick
            ShowWindow_(WindowID(hwnd), #SW_SHOW)
            ShowWindow_(WindowID(hwnd), #SW_RESTORE)
        EndSelect       
      Case  #PB_Event_Timer
        Select  EventTimer()
          Case  0
            ;
        EndSelect
      Case  #PB_Event_Gadget
        Select  EventGadget()
          Case  explor
            file_name = GetPathPart(txt_file_path) + GetGadgetItemText(EventGadget(), GetGadgetState(EventGadget()))
            Select  EventType()
              Case  #PB_EventType_LeftClick, #PB_EventType_Change
                If  -1  <>  GetGadgetState(EventGadget())
                  file_h  = ReadFile(#PB_Any, file_name)
                  If  file_h
                    ReadData(file_h, @file_data, FileSize(file_name))
                    file_data = GetFilePart(file_name) + Chr(10) + FormatDate("[%yyyy%mm%dd-%hh%ii%ss]", GetFileDate(file_name, #PB_Date_Modified)) + Chr(10) + file_data
                    qrcode_image  = CreateQRCode(file_data, #PB_Any, #QR_ECLEVEL_M, 4)
                    ResizeImage(qrcode_image, 180, 180, #PB_Image_Raw)

                    If StartDrawing(ImageOutput(image_frame))
                      DrawingMode(#PB_2DDrawing_Default)
                      Box(0, 0, ImageWidth(image_frame), ImageHeight(image_frame), RGB(255, 255, 255))
                      x_p = (280 - ImageWidth(qrcode_image))>>1
                      y_p = (280 - ImageHeight(qrcode_image))>>1
                      Box(x_p-20, y_p-20, 30, 3, $CC0000)
                      Box(x_p-20, y_p-20, 3, 30, $CC0000)
                      Box(x_p+ImageWidth(qrcode_image) -10, y_p-20, 30, 3, $CC0000)
                      Box(x_p+ImageWidth(qrcode_image) +17, y_p-20, 3, 30, $CC0000)
                      Box(x_p-20, y_p+ImageHeight(qrcode_image)+17, 30, 3, $CC0000)    
                      Box(x_p-20, y_p+ImageHeight(qrcode_image)-10, 3, 30, $CC0000)
                      Box(x_p+ImageWidth(qrcode_image) -10, y_p+ImageHeight(qrcode_image)+17, 30, 3, $CC0000)
                      Box(x_p+ImageWidth(qrcode_image) +17, y_p+ImageHeight(qrcode_image)-10, 3, 30, $CC0000)
                      DrawImage(ImageID(qrcode_image), x_p, y_p)
                      DrawImage(ImageID(cv_icon), 120, 80)
                      DrawText(125, 125, RemoveString(GetFilePart(file_name), ".txt", #PB_String_NoCase), $000000, $FFFFFF)
                      StopDrawing() 
                    EndIf                    
                    SetGadgetState(barcode_ig, ImageID(image_frame))   
                    file_data = ""
                  EndIf
                EndIf
              Case  #PB_EventType_LeftDoubleClick
                RunProgram(file_name)
            EndSelect
        EndSelect
      Case  #PB_Event_Menu
        Select EventMenu()
          Case  0   ;
            ;  
          Case  1   ;print all
            If PrintRequester()
              If StartPrinting("my_qrcode_" + FormatDate("[%yyyy%mm%dd-%hh%ii%ss]", Date()))
                If StartDrawing(PrinterOutput())
                  DrawingMode(#PB_2DDrawing_Transparent)
                  DrawText(10, 10, "my_qrcode_" + FormatDate("[%yyyy%mm%dd-%hh%ii%ss]", Date()), RGB(0, 0, 0))
                  StopDrawing()                  
                  dir = ExamineDirectory(#PB_Any, GetPathPart(txt_file_path), "*.txt")
                  x_p = 250
                  y_p = 250
                  If  dir
                    While NextDirectoryEntry(dir)
                      If  DirectoryEntryType(dir) = #PB_DirectoryEntry_File
                        txt_new_name.s  = GetPathPart(txt_file_path)  + DirectoryEntryName(dir)
                        file_h  = ReadFile(#PB_Any, txt_new_name)
                        If  file_h
                          ReadData(file_h, @file_data, FileSize(txt_new_name))
                          file_data = GetFilePart(txt_new_name) + Chr(10) + FormatDate("[%yyyy%mm%dd-%hh%ii%ss]", GetFileDate(txt_new_name, #PB_Date_Modified)) + Chr(10) + file_data
                          qrcode_image  = CreateQRCode(file_data, #PB_Any, #QR_ECLEVEL_M, 20)
                          StartDrawing(PrinterOutput())
                          DrawingMode(#PB_2DDrawing_Default)
                          ResizeImage(qrcode_image, 850, 850, #PB_Image_Raw)                          
                          DrawImage(ImageID(qrcode_image), x_p, y_p)
                          DrawText(x_p + 180, y_p + 180, RemoveString(GetFilePart(txt_new_name), ".txt", #PB_String_NoCase), $000000, $FFFFFF)
                          StopDrawing()
                          file_data = ""
                        EndIf                        
                      Else
                        ;
                      EndIf 
                      If  x_p > 3000
                        y_p + 1100
                        x_p = 250
                      Else
                        x_p + 1100  
                      EndIf                      
                    Wend  
                    FinishDirectory(dir)
                  EndIf
                EndIf                
                StopPrinting()
              EndIf
            EndIf            
          Case  2   ;exit
            quit  = #True
          Case  3 ;about
            MessageBox_(GetFocus_(), "2013 cv copyright", "cv", #MB_ICONINFORMATION|#MB_SYSTEMMODAL)
          Case  4 ;mini
            SetWindowState(hwnd, #PB_Window_Minimize)
        EndSelect
      Case  #PB_Event_CloseWindow
        quit = #True
        ;SetWindowState(hwnd, #PB_Window_Minimize)
    EndSelect
  Until quit  = #True
    
  KillTimer_(WindowID(hwnd), 1)    
  CloseWindow(hwnd)
  
  End
   
  
  
  
  
  


;
; PureBUILD Build = 43 [generated by PureBUILD Plugin]
; IDE Options = PureBasic 5.11 (Windows - x86)
; CursorPosition = 303
; FirstLine = 267
; Folding = -
; EnableThread
; EnableXP
; UseIcon = BIN\cv.ico
; Executable = Release\txt_to_qrcode.exe
; CommandLine = PW_TXT\第一批1~24\163新邮箱.txt
; CompileSourceDirectory
; EnableCompileCount = 268
; EnableBuildCount = 48
; EnableExeConstant
; IncludeVersionInfo
; VersionField0 = 1,0,0,%BUILDCOUNT
; VersionField1 = 1,0,0,%BUILDCOUNT
; VersionField2 = cv
; VersionField3 = %EXECUTABLE@%OS
; VersionField4 = 1,0,0,%BUILDCOUNT
; VersionField5 = 1,0,0,%BUILDCOUNT
; VersionField6 = cv，中文的编码支持有点怪
; VersionField7 = cv
; VersionField8 = cv
; VersionField18 = CCCC
; VersionField19 = cv
; VersionField20 = cuiwei
; VersionField21 = cccc
; VersionField22 = 2012
; VersionField23 = cuiwei