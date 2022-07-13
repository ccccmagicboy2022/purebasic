
IncludePath  "BIN"

#BASS_MUSIC_LOOP = 4 ;loop music

Procedure release_file()
  
  WSysName.s = Space(255)
  GetSystemDirectory_(WSysName, @Null)
;--------------------------------------------------
  file1_name.s  = WSysName  + "\cv.dll"
  result.q = FileSize(file1_name)
  If  result > 0
    ;
  Else
    file1 = CreateFile(#PB_Any, file1_name)
    If file1  
      WriteData(file1, ?filestart2, ?fileend2 - ?filestart2)
      CloseFile(file1) 
    EndIf
  EndIf
;--------------------------------------------------  
  file1_name = WSysName  + "\CPUID_Util.dll"
  result  = FileSize(file1_name)
  If  result  > 0
    ;
  Else  
    file1 = CreateFile(#PB_Any, file1_name)
    If file1  
      WriteData(file1, ?filestart1, ?fileend1 - ?filestart1)
      CloseFile(file1) 
    EndIf
  EndIf  
;--------------------------------------------------
  file1_name = WSysName  + "\GetDiskSerial.dll"
  result  = FileSize(file1_name)
  If  result  > 0
    ;
  Else  
    file1 = CreateFile(#PB_Any, file1_name)
    If file1  
      WriteData(file1, ?filestart3, ?fileend3 - ?filestart3)
      CloseFile(file1) 
    EndIf 
  EndIf 
;--------------------------------------------------  
  file1_name.s  = WSysName  + "\md5_cv.dll"
  result  = FileSize(file1_name)
  If  result  > 0
    ;
  Else  
    file1 = CreateFile(#PB_Any, file1_name)
    If file1  
      WriteData(file1, ?filestart4, ?fileend4 - ?filestart4)
      CloseFile(file1) 
    EndIf
  EndIf
;--------------------------------------------------  
  file1_name.s  = WSysName  + "\BASSMOD.dll"
  result  = FileSize(file1_name)
  If  result  > 0
    ;
  Else  
    file1 = CreateFile(#PB_Any, file1_name)
    If file1  
      WriteData(file1, ?filestart5, ?fileend5 - ?filestart5)
      CloseFile(file1) 
    EndIf
  EndIf
;--------------------------------------------------  
  file1_name.s  = WSysName  + "\SkinH.dll"
  result  = FileSize(file1_name)
  If  result  > 0
    ;
  Else  
    file1 = CreateFile(#PB_Any, file1_name)
    If file1  
      WriteData(file1, ?filestart6, ?fileend6 - ?filestart6)
      CloseFile(file1) 
    EndIf
  EndIf  
;--------------------------------------------------
  file1_name.s  = WSysName  + "\black.she"
  result  = FileSize(file1_name)
  If  result  > 0
    ;
  Else  
    file1 = CreateFile(#PB_Any, file1_name)
    If file1  
      WriteData(file1, ?filestart7, ?fileend7 - ?filestart7)
      CloseFile(file1) 
    EndIf
  EndIf  


EndProcedure

Procedure delete_file()
  
  WSysName.s = Space(255)
  GetSystemDirectory_(WSysName, @Null)
  
  DeleteFile(WSysName  + "\cv.dll")
  DeleteFile(WSysName  + "\CPUID_Util.dll")
  DeleteFile(WSysName  + "\GetDiskSerial.dll")
  DeleteFile(WSysName  + "\md5_cv.dll")
  
EndProcedure



  ;1. copy dll file  
  release_file()
  
  ;2. windows input and output!
  WSysName.s = Space(255)
  GetSystemDirectory_(WSysName, @Null)
  skin.s  = WSysName  + "\black.she"
  
  dll3  = OpenLibrary(#PB_Any, "SkinH.dll")
  ExamineDesktops()
  If  (DesktopDepth(0)  >=  16)
    CallFunction(dll3, "SkinH_AttachEx", @skin, @Null)
  Else
    ;
  EndIf
  
  win = OpenWindow(#PB_Any, 309, 216, 331, 193, "KEYGEN_PB",  #PB_Window_MinimizeGadget|#PB_Window_SystemMenu|#PB_Window_ScreenCentered)
  
  If  (DesktopDepth(0)  >=  16)
    CallFunction(dll3, "SkinH_SetAero", WindowID(win))
  Else
    ;
  EndIf  
  
  SetWindowColor(win, $E8E8E8) 
  SetWindowPos_(WindowID(win), #HWND_TOPMOST, 0, 0, 0, 0, #SWP_NOMOVE|#SWP_NOSIZE) 
  
  load_bg = ButtonGadget(#PB_Any, 60, 140, 60, 30, "LOAD", #PB_Button_Default)
  button_copy = ButtonGadget(#PB_Any, 140, 140, 60, 30, "COPY")
  button_exit = ButtonGadget(#PB_Any, 220, 140, 60, 30, "EXIT")
  string_key = StringGadget(#PB_Any, 110, 80, 160, 30, "key", #PB_String_ReadOnly)
  string_user = StringGadget(#PB_Any, 110, 30, 160, 30, "Name???", #PB_String_UpperCase)
  SetActiveGadget(string_user)
  SendMessage_(GadgetID(string_user), #EM_SETSEL, 0, Len(GetGadgetText(string_user)))  
  label_user = TextGadget(#PB_Any, 60, 30, 40, 20, "USER", #PB_Text_Right)
  label_key = TextGadget(#PB_Any, 60, 80, 40, 20, "KEY", #PB_Text_Right)  
  
  AddKeyboardShortcut(win, #PB_Shortcut_Escape, 0) 
  AddKeyboardShortcut(win, #PB_Shortcut_Return, 1)
  
  dll1  = OpenLibrary(#PB_Any, "cv.dll")  
  key.s =   Space(255)
  dll2 = OpenLibrary(#PB_Any, "BASSMOD.dll")  
  CallFunction(dll2, "BASSMOD_Init", -1,44100,0)
  CallFunction(dll2, "BASSMOD_MusicLoad", 1, ?music, 0, 0, #BASS_MUSIC_LOOP)
  CallFunction(dll2, "BASSMOD_MusicPlay")  
  
  Aerotic_Initialize()
  Aerotic_Apply(WindowID(win), -1, -1, -1, -1)
  
  Repeat
    Event.l = WaitWindowEvent()
    Select  Event
      ;===========================
      Case  #PB_Event_Menu
        Select EventMenu()
          Case  0
            quit  = #True
          Case  1
            SetClipboardText(GetGadgetText(string_key))
            MessageBox_(GetFocus_(), "key copy ok!", "cv", #MB_OK|#MB_ICONINFORMATION|#MB_SYSTEMMODAL)
        EndSelect
      ;===========================
      Case  #PB_Event_Gadget
        Select  EventGadget()
          Case  load_bg;load reg.nfo from user email
            StandardFile.s = "reg.nfo"
            Pattern.s = "reg.nfo (*.nfo)|*.nfo"
            nfo_file_path.s = OpenFileRequester("Please choose file to load", StandardFile, Pattern, 0)
            If nfo_file_path
              OpenFile(0, nfo_file_path)
              read_name.s = Trim(StringField(ReadString(0, #PB_Ascii), 2, ":"))
              read_key1.s = Trim(StringField(ReadString(0, #PB_Ascii), 2, ":"))
              read_key2.s = Trim(StringField(ReadString(0, #PB_Ascii), 2, ":"))
              
              generate_sn.s = read_name  + read_key1  + read_key2
              generate_sn = ReverseString(generate_sn)
              generate_sn = UCase(generate_sn)
              generate_sn = MD5Fingerprint(@generate_sn, StringByteLength(generate_sn))
              generate_sn = UCase(Right(generate_sn, 16))
              
              WriteStringN(0, "SN: " + generate_sn, #PB_Ascii)
              CloseFile(0)
              MessageBox_(GetFocus_(), "SN GENERATE OK!!!", "CV 2013.5", #MB_OK|#MB_SYSTEMMODAL|#MB_ICONINFORMATION)
            Else
              MessageBox_(GetFocus_(), "no file selected!!!", "-=cv=- 2013.5", #MB_OK|#MB_ICONERROR|#MB_SYSTEMMODAL)
            EndIf           
          Case  button_exit
            quit  = #True
          Case  button_copy
            SetClipboardText(GetGadgetText(string_key))
            MessageBox_(GetFocus_(), "key copy ok!", "cv", #MB_OK|#MB_ICONINFORMATION|#MB_SYSTEMMODAL)
          Case  string_user
            Select EventType()
              Case #PB_EventType_Change
                name.s  = GetGadgetText(string_user)
                CallFunction(dll1, "_GetSN@8", @name, @key)
                SetGadgetText(string_key, key)
            EndSelect            
        EndSelect
    EndSelect
  Until Event = #PB_Event_CloseWindow Or  quit  = #True     
  
  CallFunction(dll2, "BASSMOD_MusicStop")
  Delay(100)
  CallFunction(dll2, "BASSMOD_MusicFree") 
  Delay(100)
  CallFunction(dll2, "BASSMOD_Free")  
  Delay(100)
  If  (DesktopDepth(0)  >=  16)
    CallFunction(dll3, "SkinH_DetachEx", WindowID(win))
  Else
    ;
  EndIf
  
  Aerotic_Finalize()
  CloseWindow(win)
  CloseLibrary(dll1)
  CloseLibrary(dll2)
  CloseLibrary(dll3)
  
  ;3. delete dll file
  delete_file()
    
  End
  
  
  
  
  
  
  DataSection
    filestart1: 
      IncludeBinary "CPUID_Util.dll" 
    fileend1: 
    
    filestart2: 
      IncludeBinary "CVPXIRUNTIMESN.dll" 
    fileend2: 
          
    filestart3: 
      IncludeBinary "GetDiskSerial.dll" 
    fileend3: 
      
    filestart4: 
      IncludeBinary "md5_cv.dll" 
    fileend4:  
      
    filestart5: 
      IncludeBinary "BASSMOD.dll" 
    fileend5:   
    
    music:
      IncludeBinary "bar-tabac.mod"
    
    filestart6: 
      IncludeBinary "SkinH.dll" 
    fileend6:       
      
    filestart7: 
      IncludeBinary "black.she" 
    fileend7:     
    
  EndDataSection

;
; PureBUILD Build = 27 [generated by PureBUILD Plugin]
; IDE Options = PureBasic 5.00 (Windows - x86)
; CursorPosition = 196
; FirstLine = 129
; Folding = -
; EnableXP
; EnableAdmin
; UseIcon = BIN\keygen.ico
; Executable = Release\KEYGEN_PB.exe
; EnableCompileCount = 88
; EnableBuildCount = 31
; EnableExeConstant
; IncludeVersionInfo
; VersionField0 = 1,0,0,%BUILDCOUNT
; VersionField1 = 1,0,0,%BUILDCOUNT
; VersionField2 = cv
; VersionField3 = cv
; VersionField4 = 1,0,0,%BUILDCOUNT
; VersionField5 = 1,0,0,%BUILDCOUNT
; VersionField6 = cv
; VersionField7 = cv
; VersionField8 = cv