  IncludePath  "BIN"
  
  Global  ip.s
  Global  host.s
  Global  EOL$ = Chr(13)+Chr(10)
  Global  client_ip.s
  
  Structure NEW_LUID_AND_ATTRIBUTES
     pLuid.LUID
     Attributes.l
  EndStructure
   
  Structure NEW_TOKEN_PRIVILEGES
    PrivilegeCount.l
    Privileges.NEW_LUID_AND_ATTRIBUTES[#ANYSIZE_ARRAY]
  EndStructure
  ; -----------------------------------------------------------------------------------------------------
  ; Main shutdown/logoff procedure (you can use it directly with ExitWindowsEx_ () flags if you want)...
  ; -----------------------------------------------------------------------------------------------------
  Procedure.b DitchWindows(flags)
    Protected os.OSVERSIONINFO:os\dwOSVersionInfoSize=SizeOf(OSVERSIONINFO)
    GetVersionEx_(os)
    If os\dwPlatformId=#VER_PLATFORM_WIN32_NT
      If OpenProcessToken_(GetCurrentProcess_(),#TOKEN_ADJUST_PRIVILEGES|#TOKEN_QUERY,@token)
        If LookupPrivilegeValue_(#Null,"SeShutdownPrivilege",tkp.NEW_TOKEN_PRIVILEGES\Privileges[0]\pLuid)
          tkp\PrivilegeCount=1
          tkp\Privileges[0]\Attributes=#SE_PRIVILEGE_ENABLED
          If AdjustTokenPrivileges_(token,#False,tkp,#Null,#Null,#Null)
            If ExitWindowsEx_(flags,0)=0:ProcedureReturn 4:EndIf
          Else:ProcedureReturn 3
          EndIf
        Else:ProcedureReturn 2
        EndIf
      Else:ProcedureReturn 1
      EndIf
    Else
      If ExitWindowsEx_(flags,0)=0
        ProcedureReturn 4
      EndIf
    EndIf
  EndProcedure
  ; -----------------------------------------------------------------------------------------------------
  ; Convenience functions (force = 1 to ignore applications that don't want to shut down, 0 otherwise)
  ; -----------------------------------------------------------------------------------------------------
  Procedure.b LogOff(force=0)
    If force:force=#EWX_FORCE:EndIf
    DitchWindows(#EWX_LOGOFF|force)
  EndProcedure
  
  Procedure.b ShutDown(force=0)
    If force:force=#EWX_FORCE:EndIf
    DitchWindows(#EWX_LOGOFF|#EWX_SHUTDOWN|force)
  EndProcedure
  
  Procedure.b Reboot(force=0)
    If force:force=#EWX_FORCE:EndIf
    DitchWindows(#EWX_LOGOFF|#EWX_REBOOT|force)
  EndProcedure
  
  Procedure.b PowerOff(force=0)
    If force:force=#EWX_FORCE:EndIf
    DitchWindows(#EWX_LOGOFF|#EWX_POWEROFF|force)
  EndProcedure   
  
  Procedure.s ReadRegKey(OpenKey.l, SubKey.s, ValueName.s)
      hKey.l = 0
      KeyValue.s = Space(255)
      Datasize.l = 255
      If RegOpenKeyEx_(OpenKey, SubKey, 0, #KEY_READ, @hKey)
          KeyValue = "Error Opening Key"
      Else
          If RegQueryValueEx_(hKey, ValueName, 0, 0, @KeyValue, @Datasize)
              KeyValue = "Error Reading Key"
          Else 
              KeyValue = Left(KeyValue, Datasize - 1)
          EndIf
          RegCloseKey_(hKey)
      EndIf
      ProcedureReturn KeyValue
  EndProcedure
  
  Procedure release_file()
    
    temp.s = GetTemporaryDirectory()
  ;-------------------------------------------------
    file1_name.s  = temp  + "nirpc.dll"
    result.q = FileSize(file1_name)
    If  result > 0
      ;
    Else
      file1 = CreateFile(#PB_Any, file1_name)
      WriteData(file1, ?filestart1, ?fileend1 - ?filestart1)
      CloseFile(file1)
    EndIf
  ;--------------------------------------------------
    file1_name.s  = temp  + "NIVisaServer.exe"
    result.q = FileSize(file1_name)
    If  result > 0
      ;
    Else
      file1 = CreateFile(#PB_Any, file1_name)
      WriteData(file1, ?filestart2, ?fileend2 - ?filestart2)
      CloseFile(file1)
    EndIf  
  ;--------------------------------------------------
    file1_name.s  = temp  + "nirpc.ini"
    result.q = FileSize(file1_name)
    If  result > 0
      ;
    Else
      file1 = CreateFile(#PB_Any, file1_name)
      WriteData(file1, ?filestart3, ?fileend3 - ?filestart3)
      CloseFile(file1)
    EndIf    
    
  ;--------------------------------------------------
    file1_name.s  = temp  + "visaconf.ini"
    result.q = FileSize(file1_name)
    If  result > 0
      ;
    Else
      file1 = CreateFile(#PB_Any, file1_name)
      WriteData(file1, ?filestart4, ?fileend4 - ?filestart4)
      CloseFile(file1)
    EndIf 
    
  EndProcedure
  
  Procedure delete_file()
    
    temp.s = GetTemporaryDirectory()
    
    DeleteFile(temp  + "nirpc.dll")
    DeleteFile(temp  + "NIVisaServer.exe")
    DeleteFile(temp  + "nirpc.ini")
    DeleteFile(temp  + "visaconf.ini")
    
  EndProcedure
  
  Procedure  message_cv(cccc)
    MessageBox_(WindowID(cccc), "Get Resource Use Below: "+Chr(10)+"visa://"+host+"/?* or"+Chr(10)+"visa://"+ip+"/?*", "..cv..", #MB_OK|#MB_ICONINFORMATION|#MB_SYSTEMMODAL)  
  EndProcedure
  
  Procedure  message_cv2(cccc)
    MessageBox_(WindowID(cccc), "New user from " + client_ip + " connected!", "..cv..", #MB_OK | #MB_ICONINFORMATION|#MB_SYSTEMMODAL)
  EndProcedure
  
  Procedure  udp_server(null)
    
    Port = 6890 
    *buffer = AllocateMemory(512) 
    
    udp_id  = CreateNetworkServer(#PB_Any, Port, #PB_Network_UDP) 
    
    Repeat 
      Delay(5)
      SEvent = NetworkServerEvent() 
      If SEvent 
        ClientID = EventClient()
        ClientIP$ = IPString(GetClientIP(ClientID))
        Select SEvent 
          Case 2 
            ReceiveNetworkData(ClientID, *buffer, 512)
            command.s = PeekS(*buffer, 512, #PB_Ascii)
            Select command
              Case  "reboot"
                Reboot()
              Case  "shutdown"  
                ShutDown()
              Case  "logoff"
                LogOff()
            EndSelect
        EndSelect 
      EndIf 
    ForEver
    
    CloseNetworkServer(udp_id)
    FreeMemory(*buffer)
    
  EndProcedure


  server_icon = CatchImage(#PB_Any, ?filestart5)

  If  ProgramParameter(0) = ""
    parameter.s = ""
  Else
    parameter = ProgramParameter(0)
  EndIf

  release_file()

  temp.s = GetTemporaryDirectory()
  
  name.s  = Chr(34) + temp + "NIVisaServer.exe"  + Chr(34)
  
  version.s = ReadRegKey(#HKEY_LOCAL_MACHINE, "SOFTWARE\National Instruments\NI-VISA for Windows 95/NT\CurrentVersion", "Version")
  
  If  version <> "3.3.1"
    If  version = "Error Opening Key"
      MessageBox_(#Null, "请先安装ni-visa v3.3.1 runtime", "..cv..", #MB_OK|#MB_ICONINFORMATION|#MB_SYSTEMMODAL)
	    End
    Else
      MessageBox_(#Null, "当前ni-visa版本为v"	+	version	+	Chr(10) + "推荐使用 ni-visa v3.3.1", "..cv..", #MB_OK|#MB_ICONINFORMATION|#MB_SYSTEMMODAL)
    EndIf  
  Else
    ;
  EndIf
  
  dir.s = ReadRegKey(#HKEY_LOCAL_MACHINE, "SOFTWARE\National Instruments\NI-VISA for Windows 95/NT", "InstDir")
  dir = dir + "WinNT\NIvisa\visaconf.ini"
  
  file1 = CreateFile(#PB_Any, dir)
  WriteData(file1, ?filestart4, ?fileend4 - ?filestart4)
  CloseFile(file1)  
  
  hwnd  = OpenWindow(#PB_Any, 0, 0, 100, 100, "nivisaserver_cv", #PB_Window_ScreenCentered|#PB_Window_SystemMenu|#PB_Window_Minimize)
  SetWindowPos_(WindowID(hwnd), #HWND_TOP, 0, 0, 0, 0, #SWP_NOMOVE|#SWP_NOSIZE)
  SendMessage_(WindowID(hwnd), #WM_SETICON, #False, ImageID(server_icon))
  HideWindow(hwnd, #True)  
  SmartWindowRefresh(hwnd, #True)
  AddWindowTimer(hwnd, 0, 20)
  AddWindowTimer(hwnd, 1, 500)
  
  If  InitNetwork()
    If  ExamineIPAddresses()
      
      CreateThread(@udp_server(), 0)
      
      While(1)
        Result = NextIPAddress()
        If  Result <> 0
          ip = ip + ";" + IPString(Result)
        Else
          Break
        EndIf
      Wend
      
      ip  = LTrim(ip, ";") 
      
      host = Hostname()
      server  = CreateNetworkServer(#PB_Any, 6888)
      
      process_id2 = RunProgram("qprocess", "", temp, #PB_Program_Open | #PB_Program_Read | #PB_Program_Hide)
      output.s  = ""
      If process_id2
         While ProgramRunning(process_id2)
            output  = output + ReadProgramString(process_id2) + Chr(13)
         Wend
         CloseProgram(process_id2) 
      EndIf      
       
      If  FindString(output, "nivisaserver", 1)
        MessageBox_(WindowID(hwnd), "ni-visa server is already running. ", "..cv..", #MB_OK | #MB_ICONINFORMATION|#MB_SYSTEMMODAL)    
      Else
        ;-----------------------main---------------------
        CreateThread(@message_cv(), hwnd)        
        process_id = RunProgram(name, "", temp, #PB_Program_Open)
        
        Define HtmlFile.s        
        
        Repeat
          Event.l = WaitWindowEvent()
          Select  Event
            Case  #WM_CLOSE
              quit  = #True
            Case  #PB_Event_Timer
              Select  EventTimer()
                Case  0
                  If  ProgramRunning(process_id)=0
                    quit  = #True
                  EndIf
                Case  1
                  SendUDPBroadcast(6889, ip + ";" + host + ";visa32v" + version)
                  Select  NetworkServerEvent()
                    Case  #PB_NetworkEvent_Connect
                      client_ip = IPString(GetClientIP(EventClient()))  
                      CreateThread(@message_cv2(), hwnd)        
                    Case  #PB_NetworkEvent_Disconnect
                      ;
                    Case  2
                      *Buffer = AllocateMemory(1000) 
                      Repeat 
                        gelesen=ReceiveNetworkData(EventClient(),*Buffer,1000) 
                      Until gelesen<=0                       
                      
                      DatenZuSenden.s = "Welcome to NI-VISA Server @cccc"
                      HtmlFile=  "HTTP/1.1 200 OK"+EOL$
                      HtmlFile+  "Date: Wed, 07 Aug 1996 11:15:43 GMT"+EOL$
                      HtmlFile+  "Server: Atomic Web Server 0.2b"+EOL$
                      HtmlFile+  "Content-Length: "+Str(Len(DatenZuSenden))+EOL$
                      HtmlFile+  "Content-Type: text/html" +EOL$
                      HtmlFile+  EOL$
                      HtmlFile+  DatenZuSenden
                      
                      SendNetworkString(EventClient(), HtmlFile)
                  EndSelect
              EndSelect
            Case  #PB_Event_Gadget
              Select  EventGadget()
                Case  0
                  ;
              EndSelect
            Case  #PB_Event_Menu
              Select EventMenu()
                Case  0
                  ;
              EndSelect
          EndSelect
        Until quit  = #True
        
        KillProgram(process_id)
        CloseProgram(process_id)
        MessageBox_(WindowID(hwnd), "ni-visa server is shutdown. ", "..cv..", #MB_OK|#MB_ICONINFORMATION|#MB_SYSTEMMODAL)   
        
      EndIf
      
      CloseNetworkServer(server)
    Else
      MessageBox_(WindowID(hwnd), "请检查网络连接！IP等", "..cv..", #MB_OK|#MB_ICONERROR|#MB_SYSTEMMODAL)
    EndIf
  Else
    MessageBox_(WindowID(hwnd), "请检查网络连接！", "..cv..", #MB_OK|#MB_ICONERROR|#MB_SYSTEMMODAL)
  EndIf   
  
  CloseWindow(hwnd)  
  delete_file()
  
  End

  DataSection
    
    filestart1: 
      IncludeBinary "nirpc.dll" 
    fileend1: 
      
    filestart2: 
      IncludeBinary "NIVisaServer.exe" 
    fileend2: 
      
    filestart3: 
      IncludeBinary "nirpc.ini" 
    fileend3: 
      
    filestart4: 
      IncludeBinary "visaconf.ini" 
    fileend4: 
      
    filestart5:
      IncludeBinary "NIVisaServer.ico"
    fileend5:
    
  EndDataSection  

;
; PureBUILD Build = 84 [generated by PureBUILD Plugin]
; IDE Options = PureBasic 5.00 (Windows - x86)
; CursorPosition = 222
; FirstLine = 186
; Folding = --
; EnableThread
; EnableXP
; EnableAdmin
; UseIcon = BIN\NIVisaServer.ico
; Executable = Release\NIVISA_SERVER_cv.exe
; EnableCompileCount = 179
; EnableBuildCount = 72
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
; Watchlist = output