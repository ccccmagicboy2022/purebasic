;capture a piece of screen
Procedure.l CaptureScreen(Left.l, Top.l, Width.l, Height.l)
    dm.DEVMODE
    BMPHandle.l
    srcDC = CreateDC_("DISPLAY", "", "", dm)
    trgDC = CreateCompatibleDC_(srcDC)
    BMPHandle = CreateCompatibleBitmap_(srcDC, Width, Height)
    SelectObject_( trgDC, BMPHandle)
    BitBlt_( trgDC, 0, 0, Width, Height, srcDC, Left, Top, #SRCCOPY)
    DeleteDC_( trgDC)
    ReleaseDC_( BMPHandle, srcDC)
    ProcedureReturn BMPHandle
EndProcedure
;-------------------------------------------------------------
ProcedureDLL CaptureWindow(WindowName.s)
    WinHndl = FindWindow_(0, WindowName)
    Delay(500)
    SetWindowPos_(WinHndl, #HWND_TOP, 0, 0, 0, 0, #SWP_NOMOVE|#SWP_NOSIZE)
    If WinHndl
        WindowSize.RECT
        GetWindowRect_(WinHndl, @WindowSize)
        ScreenCaptureAddress = CaptureScreen(WindowSize\Left, WindowSize\Top, WindowSize\Right - WindowSize\Left, WindowSize\Bottom - WindowSize\Top)
        CreateImage(0, WindowSize\Right - WindowSize\Left, WindowSize\Bottom - WindowSize\Top)
        StartDrawing(ImageOutput(0))
        DrawImage(ScreenCaptureAddress, 0, 0)
        StopDrawing()
        File.s = SaveFileRequester("Please choose file to save", "cccc.bmp", "BMP (*.bmp)|*.bmp | All Files (*.*)|*.*", 0)
        If File
          SaveImage(0, File)
          MessageRequester("in cvPXILib_PB.dll::CaptureWindow()", "BMP have saved following file:"+Chr(10)+File, 0)
        Else
          MessageRequester("in cvPXILib_PB.dll::CaptureWindow()", "The requester was canceled.", 0) 
        EndIf
    Else
        ProcedureReturn 0
    EndIf
    ProcedureReturn 1
EndProcedure
;-------------------------------------------------------------
ProcedureDLL  About()
  
  icon = CatchImage(#PB_Any, ?Icon_card1)
  angry_bird1 = CatchImage(#PB_Any, ?bird1)
  
  hWnd  = OpenWindow(#PB_Any, 0, 0, 350, 120, "in cvPXILib_PB.dll::About()", #PB_Window_SystemMenu | #PB_Window_ScreenCentered)
  
  SetWindowColor(hWnd, $E8E8E8) 
  SetWindowPos_(WindowID(hWnd), #HWND_TOPMOST, 0, 0, 0, 0, #SWP_NOMOVE|#SWP_NOSIZE) ; 总在最上
  SetWinTransparency(hWnd, 90)	; 设置透明度  
  SendMessage_(WindowID(hWnd), #WM_SETICON, #False, ImageID(icon))  
  
  button1 = ButtonGadget(#PB_Any, 20, 80, 50, 25, "确定", #PB_Button_Default)
  AddKeyboardShortcut(hWnd, #PB_Shortcut_Return, 0) 
  GadgetToolTip(button1, "OK!")
  
  button2 = ButtonGadget(#PB_Any, 120, 80, 50, 25, "注册我", #PB_Button_Toggle)
  GadgetToolTip(button2, "REGISTER FOR ME!")
  
  button3 = ButtonGadget(#PB_Any, 220, 80, 25, 20, "BMP")
  GadgetToolTip(button3, "SAVE BMP!")
  
  ImageGadget(#PB_Any, 10, 10, 100, 92, ImageID(angry_bird1))
  
  
  dll = OpenLibrary(#PB_Any, "BASSMOD.dll")  
  CallFunction(dll, "BASSMOD_Init", -1,44100,0)
  CallFunction(dll, "BASSMOD_MusicLoad", 1, ?AboutSoundFile, 0, 0, 1)
  CallFunction(dll, "BASSMOD_MusicPlay")

  Repeat
    Event.l = WaitWindowEvent()
    Select  Event
      Case  #PB_Event_Gadget
        Select  EventGadget()
          Case  button1
            quit  = #True
          Case  button3
            CaptureWindow("in cvPXILib_PB.dll::About()")
        EndSelect
      Case  #PB_Event_Menu
        Select EventMenu()
          Case  0
            quit  = #True
        EndSelect 
    EndSelect
  Until Event = #PB_Event_CloseWindow Or  quit  = #True    
  
  CallFunction(dll, "BASSMOD_MusicStop")
  Delay(100)
  CallFunction(dll, "BASSMOD_MusicFree") 
  Delay(100)
  CallFunction(dll, "BASSMOD_Free")  
  Delay(100)
  CloseLibrary(dll)
  
  CloseWindow(hWnd)
  FreeImage(icon)
  
  OutputDebugString_("About()::cccc 2011")  
  
  
EndProcedure  

; IDE Options = PureBasic 4.50 (Windows - x86)
; CursorPosition = 61
; FirstLine = 43
; Folding = -
; EnableXP