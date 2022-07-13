IncludePath   "BIN"
XIncludeFile  "VISA32_PB_WRAPPER.pbi"

Structure parameter_str
  dword0.l
  dword1.l
  dword2.l
  dword3.l
  dword4.l
  dword5.l
  dword6.l
  dword7.l
  dword8.l
  dword9.l  
EndStructure

Declare.q get_vs_count(card_res)
Declare manual_trigger(card_res)
Declare set_parameter(card_res, offset_addr, *parameter)

ProcedureDLL.q  get_vs_count(card_res)    ;
  Define  value = 0
  viIn32(card_res, #VI_PXI_BAR2_SPACE, $20, @value) 
  ProcedureReturn value  
EndProcedure

ProcedureDLL  manual_trigger(card_res)    ;
  viOut32(card_res, #VI_PXI_BAR3_SPACE, $00, $00)
  beeper_wrapper1(200)
EndProcedure

ProcedureDLL  set_parameter(card_res, offset_addr, *parameter)
  Define  i.l = 0
  For i=0 To  9 Step  1
    temp.l  = PeekL(*parameter + i*SizeOf(i))
    viOut32(card_res, #VI_PXI_BAR3_SPACE, offset_addr, temp)
  Next  i
EndProcedure

load_wrapper_dll()
ExamineDesktops()

ori_y = (DesktopHeight(0) -  320)/2
ori_x = (DesktopWidth(0)  - 560)/2

card_select.s{4096} = Space(4096)
card_res_name.s{4096} = Space(4096)
memory_res_name.s{4096} = Space(4096)

Dim card_array.card_info(2)
Dim buffer8.b($200000 - 1)

Define  send.parameter_str
Define  receive.parameter_str

If  ProgramParameter(0) = ""
  result  = select_visa_pci_pxi_card(@card_select, $10b5, $5800)
  If  result  <>  #True
    close_wrapper_dll()
    End
  EndIf
Else
  card_select =  ProgramParameter(0)
EndIf

result  = is_plx9054_exist(@card_select)

If  result  = #False
  close_wrapper_dll()
  End
EndIf

logo.s  = "F222 PCI5800 TDI三维成像模拟器"
splash_launcher(@logo)

visa_default.q  = 0
viOpenDefaultRM(@visa_default)
    
card_res.q  = 0
viOpen(visa_default, @card_select, #VI_NO_LOCK, 1000, @card_res)

viInstallHandler(card_res, #VI_EVENT_EXCEPTION, @visa32_error_handler(), #VI_NULL)
viEnableEvent(card_res, #VI_EVENT_EXCEPTION, #VI_HNDLR, #VI_NULL)

viGetAttribute(card_res, #VI_ATTR_RSRC_NAME, @card_res_name)
    
If  FindString(card_res_name, "visa://", 1)
  ip_address.s  = RemoveString(card_res_name, "visa://", 0, 1, 1)
  ip_address  = StringField(ip_address, 1, "/")
  ip_address  = "visa://" + ip_address  + "/PXI0::MEMACC"
  viOpen(visa_default, @ip_address, #VI_NO_LOCK, 1000, @memory_res)
Else
  viOpen(visa_default, @"PXI0::MEMACC", #VI_NO_LOCK, 1000, @memory_res)  
EndIf
    
viInstallHandler(memory_res, #VI_EVENT_EXCEPTION, @visa32_error_handler(), #VI_NULL)
viEnableEvent(memory_res, #VI_EVENT_EXCEPTION, #VI_HNDLR, #VI_NULL)
    
;dma_ch0_buffer_header.l = 0
;result = 0
;Repeat
;  result  = viMemAlloc(memory_res, $200000, @dma_ch0_buffer_header)  ;2MB for ch0 dma
;Until dma_ch0_buffer_header <>  0 And result  = 0

send\dword0 = $0
send\dword1 = $0
send\dword2 = $80000000
send\dword3 = 12502
send\dword4 = 23
send\dword5 = $10
send\dword6 = $0
send\dword7 = $0
send\dword8 = $0
send\dword9 = $0
set_parameter(card_res, $04, @send)

;viOut32(card_res, #VI_PXI_BAR0_SPACE, #PCI9054_DMAPADR0, dma_ch0_buffer_header)

hwnd  = OpenWindow(#PB_Any, 0, 0, 600, 300, "F222 PCI5800 TDI模拟器", #PB_Window_ScreenCentered|#PB_Window_SystemMenu|#PB_Window_MinimizeGadget)
SmartWindowRefresh(hwnd, 1)
AddWindowTimer(hwnd, 0, 200)    ;界面显示

statusbar_t = CreateStatusBar(#PB_Any, WindowID(hwnd))
If statusbar_t
  AddStatusBarField(WindowWidth(hwnd))  
EndIf

viGetAttribute(card_res, #VI_ATTR_RSRC_NAME, @card_res_name)
viGetAttribute(memory_res, #VI_ATTR_RSRC_NAME, @memory_res_name)
    
StatusBarText(statusbar_t, 0, card_res_name + " & " + memory_res_name)

frame0  = Frame3DGadget(#PB_Any, 10, 10, 190, WindowHeight(hwnd) - 20 - StatusBarHeight(statusbar_t) - 190, "Data")
frame1  = Frame3DGadget(#PB_Any, 210, 10, 190, WindowHeight(hwnd) - 20 - StatusBarHeight(statusbar_t), "Manual trigger")
frame2  = Frame3DGadget(#PB_Any, 410, 10, 180, WindowHeight(hwnd) - 20 - StatusBarHeight(statusbar_t), "Status display")

start_bg  = ButtonGadget(#PB_Any, 220, 30, 50, 25, "Start", #PB_Button_Default)
manual_sg = StringGadget(#PB_Any, 275, 32, 100, 20, "1", #PB_String_Numeric)
stop_bg  = ButtonGadget(#PB_Any, 220, 60, 50, 25, "Stop")
DisableGadget(stop_bg, 1)

vs_count_tg = TextGadget(#PB_Any, 420, 30, 150, 20, "Total VS count")
vs_count_sg = StringGadget(#PB_Any, 420, 50, 150, 20, "0", #PB_String_ReadOnly)

load_file_bg  = ButtonGadget(#PB_Any, 20, 30, 40, 35, "Load File", #PB_Button_MultiLine)
access_buffer_bg  = ButtonGadget(#PB_Any, 70, 30, 50, 35, "Access Buffer", #PB_Button_MultiLine)

GadgetToolTip(start_bg, "开始按右侧输入的数量开始输出VS")
GadgetToolTip(manual_sg, "要手动输出的VS数量")
GadgetToolTip(stop_bg, "停止运行中的手动输出")
GadgetToolTip(vs_count_sg, "上电后总输出的VS的数量")
GadgetToolTip(load_file_bg, "加载数据文件到数据缓冲区")
GadgetToolTip(access_buffer_bg, "访问DMA缓冲区")
big_font2  = LoadFont(#PB_Any,"Courier",12, #PB_Font_HighQuality)        
SetGadgetFont(manual_sg, FontID(big_font2))
SetGadgetFont(vs_count_sg, FontID(big_font2))

Repeat
  Event.l = WaitWindowEvent()
  Select  Event
    Case  #PB_Event_Timer
      Select  EventTimer()
        Case  0
          SetGadgetText(vs_count_sg, Str(get_vs_count(card_res)))          
        Case  1
          If  Val(GetGadgetText(vs_count_sg)) >= finish_count
            RemoveWindowTimer(hwnd, 1)
            DisableGadget(stop_bg, 1)
            DisableGadget(start_bg, 0)
            MessageBox_(WindowID(hwnd), "Finish!", "..cv..", #MB_OK|#MB_ICONINFORMATION|#MB_SYSTEMMODAL)
          Else
            manual_trigger(card_res)
          EndIf          
      EndSelect
    Case  #PB_Event_Gadget
      Select  EventGadget()
        Case  start_bg
          AddWindowTimer(hwnd, 1, 5000)   ;控制手动输出 
          finish_count = Val(GetGadgetText(vs_count_sg)) + Val(GetGadgetText(manual_sg))
          manual_trigger(card_res)
          DisableGadget(stop_bg, 0)
          DisableGadget(start_bg, 1)
        Case  stop_bg
          RemoveWindowTimer(hwnd, 1)
          DisableGadget(stop_bg, 1)
          DisableGadget(start_bg, 0)
        Case  access_buffer_bg
          card_array.card_info(0)\card  = @card_select
          card_array.card_info(0)\bar  = #VI_PXI_BAR2_SPACE
          card_array.card_info(0)\x  = ori_x
          card_array.card_info(0)\y  = ori_y   
          card_array.card_info(0)\offset_address  = $200000
          card_array.card_info(0)\title  = @"RAM1"
          card_array.card_info(0)\backup1  = $200000  ;2Mbyte
          thread2  = CreateThread(@pxi_block_access(), @card_array() + 0*SizeOf(card_info))
        Case  load_file_bg
          Pattern$ = "二进制文件(*.*)|*.*"
          file2.s = OpenFileRequester("Please choose file to open", "", Pattern$, #PB_Window_WindowCentered)
          If  file2 = ""
            MessageBox_(WindowID(hwnd), "no file selected!" + Chr(10) + "plz choose again!", "..cv..", #MB_OK | #MB_ICONINFORMATION|#MB_SYSTEMMODAL)
          Else 
            If  $8C674 =  FileSize(file2)
              If ReadFile(0, file2)
                For i=0 To $8C674 - 1 Step 1
                  buffer8(i) = ReadByte(0)
                Next  i
                CloseFile(0)
                viMoveOut8(card_res, #VI_PXI_BAR2_SPACE, $200000, $200000, @buffer8())                
                SetWindowTitle(hwnd, GetWindowTitle(hwnd) + " - " + file2)
                MessageBox_(WindowID(hwnd), "load this file: " + Chr(10) + file2 + Chr(10) + MD5FileFingerprint(file2), "..cv..", #MB_OK | #MB_ICONINFORMATION|#MB_SYSTEMMODAL)
              Else
                MessageBox_(WindowID(hwnd), "Couldn't open the file!" + Chr(10) + "Couldn't open the file!", "..cv..", #MB_OK | #MB_ICONERROR|#MB_SYSTEMMODAL)                  
              EndIf             
            Else
              MessageBox_(WindowID(hwnd), file2 + " size is not 0x8C674. ", "..cv..", #MB_OK | #MB_ICONERROR|#MB_SYSTEMMODAL)                  
            EndIf
          EndIf         
      EndSelect
    Case  #PB_Event_Menu
      Select EventMenu()
        Case  0
          ;
      EndSelect
  EndSelect
Until Event = #PB_Event_CloseWindow Or  quit  = #True

;viMemFree(memory_res, dma_ch0_buffer_header)
viDisableEvent(card_res, #VI_ALL_ENABLED_EVENTS, #VI_ALL_MECH)
viDisableEvent(memory_res, #VI_ALL_ENABLED_EVENTS, #VI_ALL_MECH)
viUninstallHandler(card_res, #VI_EVENT_EXCEPTION, @visa32_error_handler(), #VI_NULL)  
viUninstallHandler(memory_res, #VI_EVENT_EXCEPTION, @visa32_error_handler(), #VI_NULL) 
viClose(card_res)
viClose(memory_res)
viClose(visa_default)

close_wrapper_dll()
CloseWindow(hwnd)

End





;
; PureBUILD Build = 199 [generated by PureBUILD Plugin]
; IDE Options = PureBasic 5.00 (Windows - x86)
; CursorPosition = 207
; FirstLine = 61
; Folding = -
; EnableThread
; EnableXP
; UseIcon = new_icon\PCI5800_TDI.ico
; Executable = Release\F222_PCI5800_TDI_send.exe
; SubSystem = UserLibThreadSafe
; CommandLine = visa://192.168.1.2/PXI3::1::INSTR
; CompileSourceDirectory
; EnableCompileCount = 317
; EnableBuildCount = 190
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