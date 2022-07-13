  Macro ValidateGadgetID(Result, ID, gadget)
    If ID = #PB_Any
      ID  = Result
      gadget  = GadgetID(ID)
    Else
      gadget  = Result
    EndIf
  EndMacro
  
  #ICON_SMALL = 0 
  #ICON_BIG   = 1   

  XIncludeFile  "COMatePLUS.pbi"
  XIncludeFile  "qrcodelib.pbi"
  XIncludeFile  "OSD_cv.pbi"
  XIncludeFile  "GetDiskSerial.pbi"
  XIncludeFile  "CPUID_Util.pbi"
  XIncludeFile  "SkinH.pbi"
  XIncludeFile  "BASSMOD.pbi"
  XIncludeFile  "pivxi11.pbi"
  XIncludeFile  "ini_file.pbi"
  XIncludeFile  "ping.pbi"
  XIncludeFile  "tree_gadget.pbi"
  XIncludeFile  "progress_win.pbi"
  XIncludeFile  "polyfit.pbi"
  XIncludeFile  "fft.pbi"
  
  ;Declare
  Declare.l check_reg_sn()
  Declare.l plx9054_reset_card_gui(*card_info)
  Declare.l pxi_block_access(*card_info)
  Declare.l plx9054_doorbell_interrupt_spy(*card_info)
  Declare.l ToolbarContainerHeight()
  Declare.l ToolbarContainer(ID, offsetX, width, flag=0)
  Declare.l check_plx9054_eeprom_is_cv_style(card_res)
  Declare splash_launcher(*text) 
  Declare.l hex_input(*value, limit.l)
  Declare load_wrapper_dll()
  Declare close_wrapper_dll()
  Declare.i visa32_LoadDLL()
  Declare mmt(uID, uMsg, dwUser, dw1, dw2)
  Declare about_cv()
  Declare.l dec_input(*value)
  Declare.l dword_reverse_bits(value.l)
  Declare.l dword_change_endian(value.l)
  Declare float_hex_convert()
  
  ;structure define
  Structure card_info
    *card             ;4byte
    bar.l             ;4byte
    offset_address.l  ;4byte
    x.l               ;4byte
    y.l               ;4byte
    *title            ;4byte
    backup1.l         ;4byte      ;size
    backup2.l         ;4byte    
    backup3.l         ;4byte
  EndStructure
  
  Structure pc_info
    ip_address_pt.l ;ip地址的字符串指针
    x.l
    y.l    
  EndStructure  
  
  Structure osd_param
    lp_text.l
    font_size.l
    x.l
    y.l
    color_value.l
    long_time.l
  EndStructure 
  
  #DIGCF_PRESENT                     =   2 
  #DIGCF_ALLCLASSES                  =   4 
  
  Structure SP_DEVINFO_DATA 
    cbSize.l 
    ClassGuid.GUID 
    DevInst.l 
    Reserved.l 
  EndStructure   
    
  ProcedureDLL AttachProcess(Instance.l)
    
    ;MessageBox_(GetFocus_(), "cv attach@0x" + Hex(Instance), "..cv..", #MB_OK|#MB_ICONINFORMATION|#MB_SYSTEMMODAL)

  EndProcedure
  
  ProcedureDLL DetachProcess(Instance.l)    
    
    ;MessageBox_(GetFocus_(), "cv detach@0x" + Hex(Instance), "..cv..", #MB_OK|#MB_ICONINFORMATION|#MB_SYSTEMMODAL)
    
  EndProcedure  
  
  ProcedureDLL AttachThread(Instance.l)
    ;
  EndProcedure
  
  ProcedureDLL DetachThread(Instance.l)
    ;
  EndProcedure   
  
  Procedure  beeper1(long.l)
    Beep_($Aff, long) ;7fff is max 0x25 is min
  EndProcedure
  
  ProcedureDLL  beeper_wrapper1(long.l)
    CreateThread(@beeper1(), long)  
  EndProcedure 
  
  Procedure  beeper2(long.l)
    Beep_($2ff, long)
  EndProcedure
  
  ProcedureDLL  beeper_wrapper2(long.l)
    CreateThread(@beeper2(), long)  
  EndProcedure   
  
  Procedure mmt(uID, uMsg, dwUser, dw1, dw2)
    splash_launcher(@"Unregistered Copy")
  EndProcedure  

;-------------------plx9054_reg-----------------------
  ; PCI Configuration Registers base on PCI CONFIG SPACE
  #PCI9054_VENDOR_ID            = $000
  #PCI9054_COMMAND              = $004
  #PCI9054_REV_ID               = $008
  #PCI9054_CACHE_SIZE           = $00C
  #PCI9054_PCIBAR0              = $010
  #PCI9054_PCIBAR1              = $014
  #PCI9054_PCIBAR2              = $018
  #PCI9054_PCIBAR3              = $01C
  #PCI9054_PCIBAR4              = $020
  #PCI9054_PCIBAR5              = $024
  #PCI9054_CIS_PTR              = $028
  #PCI9054_SUB_ID               = $02C
  #PCI9054_EXP_ROM_BASE         = $030
  #PCI9054_CAP_PTR              = $034
  #PCI9054_RESERVED2            = $038
  #PCI9054_INT_LINE             = $03C
  #PCI9054_PM_CAP_ID            = $040
  #PCI9054_PM_CSR               = $044
  #PCI9054_HS_CAP_ID            = $048
  #PCI9054_PVPDCNTL             = $04c
  #PCI9054_PVPDATA              = $050
  
  ; Local Configuration Registers base on BAR0
  #PCI9054_SPACE0_RANGE         = $000
  #PCI9054_SPACE0_REMAP         = $004
  #PCI9054_LOCAL_DMA_ARBIT      = $008
  #PCI9054_BIGEND_LMISC_PROT_AREA = $00c
  #PCI9054_EXP_ROM_RANGE        = $010
  #PCI9054_EXP_ROM_REMAP        = $014
  #PCI9054_SPACE0_ROM_DESC      = $018
  #PCI9054_DM_RANGE             = $01c
  #PCI9054_DM_MEM_BASE          = $020
  #PCI9054_DM_IO_BASE           = $024
  #PCI9054_DM_PCI_MEM_REMAP     = $028
  #PCI9054_DM_PCI_IO_CONFIG     = $02c
  #PCI9054_SPACE1_RANGE         = $0f0
  #PCI9054_SPACE1_REMAP         = $0f4
  #PCI9054_SPACE1_DESC          = $0f8
  #PCI9054_DM_DAC               = $0fc
  
  ; Runtime Registers base on BAR0
  #PCI9054_MAILBOX0             = $078
  #PCI9054_MAILBOX1             = $07c
  #PCI9054_MAILBOX2             = $048
  #PCI9054_MAILBOX3             = $04c
  #PCI9054_MAILBOX4             = $050
  #PCI9054_MAILBOX5             = $054
  #PCI9054_MAILBOX6             = $058
  #PCI9054_MAILBOX7             = $05c
  #PCI9054_LOCAL_DOORBELL       = $060
  #PCI9054_PCI_DOORBELL         = $064
  #PCI9054_INTCSR               = $068  ;中断控制及状态寄存器
  #PCI9054_CNTRL                = $06c
  #PCI9054_PCIHIDR              = $070
  #PCI9054_PCIHREV              = $074
  
  ; DMA Registers base on BAR0
  #PCI9054_DMAMODE0             = $080
  #PCI9054_DMAPADR0             = $084
  #PCI9054_DMALADR0             = $088
  #PCI9054_DMASIZ0              = $08c
  #PCI9054_DMADPR0              = $090
  #PCI9054_DMAMODE1             = $094
  #PCI9054_DMAPADR1             = $098
  #PCI9054_DMALADR1             = $09c
  #PCI9054_DMASIZ1              = $0a0
  #PCI9054_DMADPR1              = $0a4
  #PCI9054_DMACSR0_DMACSR1      = $0a8    ;DMA两个通道的控制及状态寄存器
  #PCI9054_DMAARB               = $0ac
  #PCI9054_DMATHR               = $0b0
  #PCI9054_DMADAC0              = $0b4
  #PCI9054_DMADAC1              = $0b8
  
  ; Messaging Unit Registers  base on BAR0
  #PCI9054_OUTPOST_INT_STAT     = $030
  #PCI9054_OUTPOST_INT_MASK     = $034
  #PCI9054_MU_CONFIG            = $0c0
  #PCI9054_FIFO_BASE_ADDR       = $0c4
  #PCI9054_INFREE_HEAD_PTR      = $0c8
  #PCI9054_INFREE_TAIL_PTR      = $0cc
  #PCI9054_INPOST_HEAD_PTR      = $0d0
  #PCI9054_INPOST_TAIL_PTR      = $0d4
  #PCI9054_OUTFREE_HEAD_PTR     = $0d8
  #PCI9054_OUTFREE_TAIL_PTR     = $0dc
  #PCI9054_OUTPOST_HEAD_PTR     = $0e0
  #PCI9054_OUTPOST_TAIL_PTR     = $0e4
  #PCI9054_FIFO_CTRL_STAT       = $0e8
  
  ;--------visa32 const define---------------------
  #VI_ATTR_FIND_RSRC_MODE      =($3FFF0190)  
  
  
  ;------------------------------------------------
  #VI_SUCCESS          = (0)
  #VI_NULL             = (0)

  #VI_TRUE             = (1)
  #VI_FALSE            = (0)
  
  #VI_ATTR_RSRC_CLASS          =($BFFF0001)
  #VI_ATTR_RSRC_NAME           =($BFFF0002)
  #VI_ATTR_RSRC_IMPL_VERSION   =($3FFF0003)
  #VI_ATTR_RSRC_LOCK_STATE     =($3FFF0004)
  #VI_ATTR_MAX_QUEUE_LENGTH    =($3FFF0005)
  #VI_ATTR_USER_DATA_32        =($3FFF0007)
  #VI_ATTR_FDC_CHNL            =($3FFF000D)
  #VI_ATTR_FDC_MODE            =($3FFF000F)
  #VI_ATTR_FDC_GEN_SIGNAL_EN   =($3FFF0011)
  #VI_ATTR_FDC_USE_PAIR        =($3FFF0013)
  #VI_ATTR_SEND_END_EN         =($3FFF0016)
  #VI_ATTR_TERMCHAR            =($3FFF0018)
  #VI_ATTR_TMO_VALUE           =($3FFF001A)
  #VI_ATTR_GPIB_READDR_EN      =($3FFF001B)
  #VI_ATTR_IO_PROT             =($3FFF001C)
  #VI_ATTR_DMA_ALLOW_EN        =($3FFF001E)
  #VI_ATTR_ASRL_BAUD           =($3FFF0021)
  #VI_ATTR_ASRL_DATA_BITS      =($3FFF0022)
  #VI_ATTR_ASRL_PARITY         =($3FFF0023)
  #VI_ATTR_ASRL_STOP_BITS      =($3FFF0024)
  #VI_ATTR_ASRL_FLOW_CNTRL     =($3FFF0025)
  #VI_ATTR_RD_BUF_OPER_MODE    =($3FFF002A)
  #VI_ATTR_RD_BUF_SIZE         =($3FFF002B)
  #VI_ATTR_WR_BUF_OPER_MODE    =($3FFF002D)
  #VI_ATTR_WR_BUF_SIZE         =($3FFF002E)
  #VI_ATTR_SUPPRESS_END_EN     =($3FFF0036)
  #VI_ATTR_TERMCHAR_EN         =($3FFF0038)
  #VI_ATTR_DEST_ACCESS_PRIV    =($3FFF0039)
  #VI_ATTR_DEST_BYTE_ORDER     =($3FFF003A)
  #VI_ATTR_SRC_ACCESS_PRIV     =($3FFF003C)
  #VI_ATTR_SRC_BYTE_ORDER      =($3FFF003D)
  #VI_ATTR_SRC_INCREMENT       =($3FFF0040)
  #VI_ATTR_DEST_INCREMENT      =($3FFF0041)
  #VI_ATTR_WIN_ACCESS_PRIV     =($3FFF0045)
  #VI_ATTR_WIN_BYTE_ORDER      =($3FFF0047)
  #VI_ATTR_GPIB_ATN_STATE      =($3FFF0057)
  #VI_ATTR_GPIB_ADDR_STATE     =($3FFF005C)
  #VI_ATTR_GPIB_CIC_STATE      =($3FFF005E)
  #VI_ATTR_GPIB_NDAC_STATE     =($3FFF0062)
  #VI_ATTR_GPIB_SRQ_STATE      =($3FFF0067)
  #VI_ATTR_GPIB_SYS_CNTRL_STATE =($3FFF0068)
  #VI_ATTR_GPIB_HS488_CBL_LEN  =($3FFF0069)
  #VI_ATTR_CMDR_LA             =($3FFF006B)
  #VI_ATTR_VXI_DEV_CLASS       =($3FFF006C)
  #VI_ATTR_MAINFRAME_LA        =($3FFF0070)
  #VI_ATTR_MANF_NAME           =($BFFF0072)
  #VI_ATTR_MODEL_NAME          =($BFFF0077)
  #VI_ATTR_VXI_VME_INTR_STATUS =($3FFF008B)
  #VI_ATTR_VXI_TRIG_STATUS     =($3FFF008D)
  #VI_ATTR_VXI_VME_SYSFAIL_STATE =($3FFF0094)
  #VI_ATTR_WIN_BASE_ADDR_32    =($3FFF0098)
  #VI_ATTR_WIN_SIZE_32         =($3FFF009A)
  #VI_ATTR_ASRL_AVAIL_NUM      =($3FFF00AC)
  #VI_ATTR_MEM_BASE_32         =($3FFF00AD)
  #VI_ATTR_ASRL_CTS_STATE      =($3FFF00AE)
  #VI_ATTR_ASRL_DCD_STATE      =($3FFF00AF)
  #VI_ATTR_ASRL_DSR_STATE      =($3FFF00B1)
  #VI_ATTR_ASRL_DTR_STATE      =($3FFF00B2)
  #VI_ATTR_ASRL_END_IN         =($3FFF00B3)
  #VI_ATTR_ASRL_END_OUT        =($3FFF00B4)
  #VI_ATTR_ASRL_REPLACE_CHAR   =($3FFF00BE)
  #VI_ATTR_ASRL_RI_STATE       =($3FFF00BF)
  #VI_ATTR_ASRL_RTS_STATE      =($3FFF00C0)
  #VI_ATTR_ASRL_XON_CHAR       =($3FFF00C1)
  #VI_ATTR_ASRL_XOFF_CHAR      =($3FFF00C2)
  #VI_ATTR_WIN_ACCESS          =($3FFF00C3)
  #VI_ATTR_RM_SESSION          =($3FFF00C4)
  #VI_ATTR_VXI_LA              =($3FFF00D5)
  #VI_ATTR_MANF_ID             =($3FFF00D9)
  #VI_ATTR_MEM_SIZE_32         =($3FFF00DD)
  #VI_ATTR_MEM_SPACE           =($3FFF00DE)
  #VI_ATTR_MODEL_CODE          =($3FFF00DF)
  #VI_ATTR_SLOT                =($3FFF00E8)
  #VI_ATTR_INTF_INST_NAME      =($BFFF00E9)
  #VI_ATTR_IMMEDIATE_SERV      =($3FFF0100)
  #VI_ATTR_INTF_PARENT_NUM     =($3FFF0101)
  #VI_ATTR_RSRC_SPEC_VERSION   =($3FFF0170)
  #VI_ATTR_INTF_TYPE           =($3FFF0171)
  #VI_ATTR_GPIB_PRIMARY_ADDR   =($3FFF0172)
  #VI_ATTR_GPIB_SECONDARY_ADDR =($3FFF0173)
  #VI_ATTR_RSRC_MANF_NAME      =($BFFF0174)
  #VI_ATTR_RSRC_MANF_ID        =($3FFF0175)
  #VI_ATTR_INTF_NUM            =($3FFF0176)
  #VI_ATTR_TRIG_ID             =($3FFF0177)
  #VI_ATTR_GPIB_REN_STATE      =($3FFF0181)
  #VI_ATTR_GPIB_UNADDR_EN      =($3FFF0184)
  #VI_ATTR_DEV_STATUS_BYTE     =($3FFF0189)
  #VI_ATTR_FILE_APPEND_EN      =($3FFF0192)
  #VI_ATTR_VXI_TRIG_SUPPORT    =($3FFF0194)
  #VI_ATTR_TCPIP_ADDR          =($BFFF0195)
  #VI_ATTR_TCPIP_HOSTNAME      =($BFFF0196)
  #VI_ATTR_TCPIP_PORT          =($3FFF0197)
  #VI_ATTR_TCPIP_DEVICE_NAME   =($BFFF0199)
  #VI_ATTR_TCPIP_NODELAY       =($3FFF019A)
  #VI_ATTR_TCPIP_KEEPALIVE     =($3FFF019B)
  #VI_ATTR_4882_COMPLIANT      =($3FFF019F)
  #VI_ATTR_USB_SERIAL_NUM      =($BFFF01A0)
  #VI_ATTR_USB_INTFC_NUM       =($3FFF01A1)
  #VI_ATTR_USB_PROTOCOL        =($3FFF01A7)
  #VI_ATTR_USB_MAX_INTR_SIZE   =($3FFF01AF)
  #VI_ATTR_PXI_DEV_NUM         =($3FFF0201)
  #VI_ATTR_PXI_FUNC_NUM        =($3FFF0202)
  #VI_ATTR_PXI_BUS_NUM         =($3FFF0205)
  #VI_ATTR_PXI_CHASSIS         =($3FFF0206)
  #VI_ATTR_PXI_SLOTPATH        =($BFFF0207)
  #VI_ATTR_PXI_SLOT_LBUS_LEFT  =($3FFF0208)
  #VI_ATTR_PXI_SLOT_LBUS_RIGHT =($3FFF0209)
  #VI_ATTR_PXI_TRIG_BUS        =($3FFF020A)
  #VI_ATTR_PXI_STAR_TRIG_BUS   =($3FFF020B)
  #VI_ATTR_PXI_STAR_TRIG_LINE  =($3FFF020C)
  #VI_ATTR_PXI_MEM_TYPE_BAR0   =($3FFF0211)
  #VI_ATTR_PXI_MEM_TYPE_BAR1   =($3FFF0212)
  #VI_ATTR_PXI_MEM_TYPE_BAR2   =($3FFF0213)
  #VI_ATTR_PXI_MEM_TYPE_BAR3   =($3FFF0214)
  #VI_ATTR_PXI_MEM_TYPE_BAR4   =($3FFF0215)
  #VI_ATTR_PXI_MEM_TYPE_BAR5   =($3FFF0216)
  #VI_ATTR_PXI_MEM_BASE_BAR0   =($3FFF0221)
  #VI_ATTR_PXI_MEM_BASE_BAR1   =($3FFF0222)
  #VI_ATTR_PXI_MEM_BASE_BAR2   =($3FFF0223)
  #VI_ATTR_PXI_MEM_BASE_BAR3   =($3FFF0224)
  #VI_ATTR_PXI_MEM_BASE_BAR4   =($3FFF0225)
  #VI_ATTR_PXI_MEM_BASE_BAR5   =($3FFF0226)
  #VI_ATTR_PXI_MEM_SIZE_BAR0   =($3FFF0231)
  #VI_ATTR_PXI_MEM_SIZE_BAR1   =($3FFF0232)
  #VI_ATTR_PXI_MEM_SIZE_BAR2   =($3FFF0233)
  #VI_ATTR_PXI_MEM_SIZE_BAR3   =($3FFF0234)
  #VI_ATTR_PXI_MEM_SIZE_BAR4   =($3FFF0235)
  #VI_ATTR_PXI_MEM_SIZE_BAR5   =($3FFF0236)
  #VI_ATTR_PXI_IS_EXPRESS      =($3FFF0240)
  #VI_ATTR_PXI_SLOT_LWIDTH     =($3FFF0241)
  #VI_ATTR_PXI_MAX_LWIDTH      =($3FFF0242)
  #VI_ATTR_PXI_ACTUAL_LWIDTH   =($3FFF0243)
  #VI_ATTR_PXI_DSTAR_BUS       =($3FFF0244)
  #VI_ATTR_PXI_DSTAR_SET       =($3FFF0245)
  #VI_ATTR_PXI_RECV_INTR_SEQ   =($3FFF4240)
  
  #VI_ATTR_TCPIP_HISLIP_OVERLAP_EN      =($3FFF0300)
  #VI_ATTR_TCPIP_HISLIP_VERSION         =($3FFF0301)
  #VI_ATTR_TCPIP_HISLIP_MAX_MESSAGE_KB  =($3FFF0302)
  
  #VI_ATTR_JOB_ID              =($3FFF4006)
  #VI_ATTR_EVENT_TYPE          =($3FFF4010)
  #VI_ATTR_SIGP_STATUS_ID      =($3FFF4011)
  #VI_ATTR_RECV_TRIG_ID        =($3FFF4012)
  #VI_ATTR_INTR_STATUS_ID      =($3FFF4023)
  #VI_ATTR_STATUS              =($3FFF4025)
  #VI_ATTR_RET_COUNT_32        =($3FFF4026)
  #VI_ATTR_BUFFER              =($3FFF4027)
  #VI_ATTR_RECV_INTR_LEVEL     =($3FFF4041)
  #VI_ATTR_OPER_NAME           =($BFFF4042)
  #VI_ATTR_GPIB_RECV_CIC_STATE =($3FFF4193)
  #VI_ATTR_RECV_TCPIP_ADDR     =($BFFF4198)
  #VI_ATTR_USB_RECV_INTR_SIZE  =($3FFF41B0)
  #VI_ATTR_USB_RECV_INTR_DATA  =($BFFF41B1)
  
  #VI_EVENT_IO_COMPLETION      =($3FFF2009)
  #VI_EVENT_TRIG               =($BFFF200A)
  #VI_EVENT_SERVICE_REQ        =($3FFF200B)
  #VI_EVENT_CLEAR              =($3FFF200D)
  #VI_EVENT_EXCEPTION          =($BFFF200E)
  #VI_EVENT_GPIB_CIC           =($3FFF2012)
  #VI_EVENT_GPIB_TALK          =($3FFF2013)
  #VI_EVENT_GPIB_LISTEN        =($3FFF2014)
  #VI_EVENT_VXI_VME_SYSFAIL    =($3FFF201D)
  #VI_EVENT_VXI_VME_SYSRESET   =($3FFF201E)
  #VI_EVENT_VXI_SIGP           =($3FFF2020)
  #VI_EVENT_VXI_VME_INTR       =($BFFF2021)
  #VI_EVENT_PXI_INTR           =($3FFF2022)
  #VI_EVENT_TCPIP_CONNECT      =($3FFF2036)
  #VI_EVENT_USB_INTR           =($3FFF2037)
  
  #VI_ALL_ENABLED_EVENTS       =($3FFF7FFF)
  
  #VI_FIND_BUFLEN              =(256)
  
  #VI_INTF_GPIB                =(1)
  #VI_INTF_VXI                 =(2)
  #VI_INTF_GPIB_VXI            =(3)
  #VI_INTF_ASRL                =(4)
  #VI_INTF_PXI                 =(5)
  #VI_INTF_TCPIP               =(6)
  #VI_INTF_USB                 =(7)
  
  #VI_PROT_NORMAL              =(1)
  #VI_PROT_FDC                 =(2)
  #VI_PROT_HS488               =(3)
  #VI_PROT_4882_STRS           =(4)
  #VI_PROT_USBTMC_VENDOR       =(5)
  
  #VI_FDC_NORMAL               =(1)
  #VI_FDC_STREAM               =(2)
  
  #VI_LOCAL_SPACE              =(0)
  #VI_A16_SPACE                =(1)
  #VI_A24_SPACE                =(2)
  #VI_A32_SPACE                =(3)
  #VI_A64_SPACE                =(4)
  
  #VI_PXI_ALLOC_SPACE          =(9)
  #VI_PXI_CFG_SPACE            =(10)
  #VI_PXI_BAR0_SPACE           =(11)
  #VI_PXI_BAR1_SPACE           =(12)
  #VI_PXI_BAR2_SPACE           =(13)
  #VI_PXI_BAR3_SPACE           =(14)
  #VI_PXI_BAR4_SPACE           =(15)
  #VI_PXI_BAR5_SPACE           =(16)
    
  #VI_OPAQUE_SPACE             =($FFFF)
  
  #VI_UNKNOWN_LA               =(-1)
  #VI_UNKNOWN_SLOT             =(-1)
  #VI_UNKNOWN_LEVEL            =(-1)
  #VI_UNKNOWN_CHASSIS          =(-1)
  
  #VI_QUEUE                    =(1)
  #VI_HNDLR                    =(2)
  #VI_SUSPEND_HNDLR            =(4)
  #VI_ALL_MECH                 =($FFFF)
  
  #VI_ANY_HNDLR                =(0)
  
  #VI_TRIG_ALL                 =(-2)
  #VI_TRIG_SW                  =(-1)
  #VI_TRIG_TTL0                =(0)
  #VI_TRIG_TTL1                =(1)
  #VI_TRIG_TTL2                =(2)
  #VI_TRIG_TTL3                =(3)
  #VI_TRIG_TTL4                =(4)
  #VI_TRIG_TTL5                =(5)
  #VI_TRIG_TTL6                =(6)
  #VI_TRIG_TTL7                =(7)
  #VI_TRIG_ECL0                =(8)
  #VI_TRIG_ECL1                =(9)
  #VI_TRIG_PANEL_IN            =(27)
  #VI_TRIG_PANEL_OUT           =(28)
  
  #VI_TRIG_PROT_DEFAULT        =(0)
  #VI_TRIG_PROT_ON             =(1)
  #VI_TRIG_PROT_OFF            =(2)
  #VI_TRIG_PROT_SYNC           =(5)
  #VI_TRIG_PROT_RESERVE        =(6)
  #VI_TRIG_PROT_UNRESERVE      =(7)
  
  #VI_READ_BUF                 =(1)
  #VI_WRITE_BUF                =(2)
  #VI_READ_BUF_DISCARD         =(4)
  #VI_WRITE_BUF_DISCARD        =(8)
  #VI_IO_IN_BUF                =(16)
  #VI_IO_OUT_BUF               =(32)
  #VI_IO_IN_BUF_DISCARD        =(64)
  #VI_IO_OUT_BUF_DISCARD       =(128)
  
  #VI_FLUSH_ON_ACCESS          =(1)
  #VI_FLUSH_WHEN_FL          =(2)
  #VI_FLUSH_DISABLE            =(3)
  
  #VI_NMAPPED                  =(1)
  #VI_USE_OPERS                =(2)
  #VI_DEREF_ADDR               =(3)
  #VI_DEREF_ADDR_BYTE_SWAP     =(4)
  
  #VI_TMO_IMMEDIATE            =(0)
  #VI_TMO_INFINITE             =($FFFFFFFF)
  
  #VI_NO_LOCK                  =(0)
  #VI_EXCLUSIVE_LOCK           =(1)
  #VI_SHARED_LOCK              =(2)
  #VI_LOAD_CONFIG              =(4)
  
  #VI_NO_SEC_ADDR              =($FFFF)
  
  #VI_ASRL_PAR_NONE            =(0)
  #VI_ASRL_PAR_ODD             =(1)
  #VI_ASRL_PAR_EVEN            =(2)
  #VI_ASRL_PAR_MARK            =(3)
  #VI_ASRL_PAR_SPACE           =(4)
  
  #VI_ASRL_STOP_ONE            =(10)
  #VI_ASRL_STOP_ONE5           =(15)
  #VI_ASRL_STOP_TWO            =(20)
  
  #VI_ASRL_FLOW_NONE           =(0)
  #VI_ASRL_FLOW_XON_XOFF       =(1)
  #VI_ASRL_FLOW_RTS_CTS        =(2)
  #VI_ASRL_FLOW_DTR_DSR        =(4)
  
  #VI_ASRL_END_NONE            =(0)
  #VI_ASRL_END_LAST_BIT        =(1)
  #VI_ASRL_END_TERMCHAR        =(2)
  #VI_ASRL_END_BREAK           =(3)
  
  #VI_STATE_ASSERTED           =(1)
  #VI_STATE_UNASSERTED         =(0)
  #VI_STATE_UNKNOWN            =(-1)
  
  #VI_BIG_ENDIAN               =(0)
  #VI_LITTLE_ENDIAN            =(1)
  
  #VI_DATA_PRIV                =(0)
  #VI_DATA_NPRIV               =(1)
  #VI_PROG_PRIV                =(2)
  #VI_PROG_NPRIV               =(3)
  #VI_BLCK_PRIV                =(4)
  #VI_BLCK_NPRIV               =(5)
  #VI_D64_PRIV                 =(6)
  #VI_D64_NPRIV                =(7)
  
  #VI_WIDTH_8                  =(1)
  #VI_WIDTH_16                 =(2)
  #VI_WIDTH_32                 =(4)
  #VI_WIDTH_64                 =(8)
  
  #VI_GPIB_REN_DEASSERT        =(0)
  #VI_GPIB_REN_ASSERT          =(1)
  #VI_GPIB_REN_DEASSERT_GTL    =(2)
  #VI_GPIB_REN_ASSERT_ADDRESS  =(3)
  #VI_GPIB_REN_ASSERT_LLO      =(4)
  #VI_GPIB_REN_ASSERT_ADDRESS_LLO =(5)
  #VI_GPIB_REN_ADDRESS_GTL     =(6)
  
  #VI_GPIB_ATN_DEASSERT        =(0)
  #VI_GPIB_ATN_ASSERT          =(1)
  #VI_GPIB_ATN_DEASSERT_HANDSHAKE =(2)
  #VI_GPIB_ATN_ASSERT_IMMEDIATE =(3)
  
  #VI_GPIB_HS488_DISABLED      =(0)
  #VI_GPIB_HS488_NIMPL         =(-1)
  
  #VI_GPIB_UNADDRESSED         =(0)
  #VI_GPIB_TALKER              =(1)
  #VI_GPIB_LISTENER            =(2)
  
  #VI_VXI_CMD16                =($0200)
  #VI_VXI_CMD16_RESP16         =($0202)
  #VI_VXI_RESP16               =($0002)
  #VI_VXI_CMD32                =($0400)
  #VI_VXI_CMD32_RESP16         =($0402)
  #VI_VXI_CMD32_RESP32         =($0404)
  #VI_VXI_RESP32               =($0004)
  
  #VI_ASSERT_SIGNAL            =(-1)
  #VI_ASSERT_USE_ASSIGNED      =(0)
  #VI_ASSERT_IRQ1              =(1)
  #VI_ASSERT_IRQ2              =(2)
  #VI_ASSERT_IRQ3              =(3)
  #VI_ASSERT_IRQ4              =(4)
  #VI_ASSERT_IRQ5              =(5)
  #VI_ASSERT_IRQ6              =(6)
  #VI_ASSERT_IRQ7              =(7)
  
  #VI_UTIL_ASSERT_SYSRESET     =(1)
  #VI_UTIL_ASSERT_SYSFAIL      =(2)
  #VI_UTIL_DEASSERT_SYSFAIL    =(3)
  
  #VI_VXI_CLASS_MEMORY         =(0)
  #VI_VXI_CLASS_EXTENDED       =(1)
  #VI_VXI_CLASS_MESSAGE        =(2)
  #VI_VXI_CLASS_REGISTER       =(3)
  #VI_VXI_CLASS_OTHER          =(4)
  
  #VI_PXI_ADDR_NONE            =(0)
  #VI_PXI_ADDR_MEM             =(1)
  #VI_PXI_ADDR_IO              =(2)
  #VI_PXI_ADDR_CFG             =(3)
  
  #VI_TRIG_UNKNOWN             =(-1)
  
  #VI_PXI_LBUS_UNKNOWN         =(-1)
  #VI_PXI_LBUS_NONE            =(0)
  #VI_PXI_LBUS_STAR_TRIG_BUS_0 =(1000)
  #VI_PXI_LBUS_STAR_TRIG_BUS_1 =(1001)
  #VI_PXI_LBUS_STAR_TRIG_BUS_2 =(1002)
  #VI_PXI_LBUS_STAR_TRIG_BUS_3 =(1003)
  #VI_PXI_LBUS_STAR_TRIG_BUS_4 =(1004)
  #VI_PXI_LBUS_STAR_TRIG_BUS_5 =(1005)
  #VI_PXI_LBUS_STAR_TRIG_BUS_6 =(1006)
  #VI_PXI_LBUS_STAR_TRIG_BUS_7 =(1007)
  #VI_PXI_LBUS_STAR_TRIG_BUS_8 =(1008)
  #VI_PXI_LBUS_STAR_TRIG_BUS_9 =(1009)
  #VI_PXI_STAR_TRIG_CONTROLLER =(1413)
  
  #VI_INTF_RIO                 =(8)
  #VI_INTF_FIREWIRE            =(9) 
  
  #VI_ATTR_SYNC_MXI_ALLOW_EN   =($3FFF0161) ; ViBoolean, Read/write */
  
  ; This is For VXI SERVANT resources */
  #VI_EVENT_VXI_DEV_CMD        =($BFFF200F)
  #VI_ATTR_VXI_DEV_CMD_TYPE    =($3FFF4037) ; ViInt16, Read-only */
  #VI_ATTR_VXI_DEV_CMD_VALUE   =($3FFF4038) ; ViUInt32, Read-only */
  
  #VI_VXI_DEV_CMD_TYPE_16      =(16)
  #VI_VXI_DEV_CMD_TYPE_32      =(32)
  
  ; mode values include VI_VXI_RESP16, VI_VXI_RESP32, And the Next 2 values */
  #VI_VXI_RESP_NONE            =(0)
  #VI_VXI_RESP_PROT_ERROR      =(-1)
  
  ; This is For VXI TTL Trigger routing */
  #VI_ATTR_VXI_TRIG_LINES_EN   =($3FFF4043)
  #VI_ATTR_VXI_TRIG_DIR        =($3FFF4044)
  
  ; This allows extended Serial support on Win32 And on NI ENET Serial products */
  #VI_ATTR_ASRL_DISCARD_NL     =($3FFF00B0)
  #VI_ATTR_ASRL_CONNECTED      =($3FFF01BB)
  #VI_ATTR_ASRL_BREAK_STATE    =($3FFF01BC)
  #VI_ATTR_ASRL_BREAK_LEN      =($3FFF01BD)
  #VI_ATTR_ASRL_ALLOW_TRANSMIT =($3FFF01BE)
  #VI_ATTR_ASRL_WIRE_MODE      =($3FFF01BF)
  
  #VI_ASRL_WIRE_485_4          =(0)
  #VI_ASRL_WIRE_485_2_DTR_ECHO =(1)
  #VI_ASRL_WIRE_485_2_DTR_CTRL =(2)
  #VI_ASRL_WIRE_485_2_AUTO     =(3)
  #VI_ASRL_WIRE_232_DTE        =(128)
  #VI_ASRL_WIRE_232_DCE        =(129)
  #VI_ASRL_WIRE_232_AUTO       =(130)
  
  #VI_EVENT_ASRL_BREAK         =($3FFF2023)
  #VI_EVENT_ASRL_CTS           =($3FFF2029)
  #VI_EVENT_ASRL_DSR           =($3FFF202A)
  #VI_EVENT_ASRL_DCD           =($3FFF202C)
  #VI_EVENT_ASRL_RI            =($3FFF202E)
  #VI_EVENT_ASRL_CHAR          =($3FFF2035)
  #VI_EVENT_ASRL_TERMCHAR      =($3FFF2024)
    
  #VI_ERROR_SYSTEM_ERROR         = $BFFF0000 ;; BFFF0000, -1073807360 */
  #VI_ERROR_INV_OBJECT           = $BFFF000E ;; BFFF000E, -1073807346 */
  #VI_ERROR_RSRC_LOCKED          = $BFFF000F ;; BFFF000F, -1073807345 */
  #VI_ERROR_INV_EXPR             = $BFFF0010 ;; BFFF0010, -1073807344 */
  #VI_ERROR_RSRC_NFOUND          = $BFFF0011 ;; BFFF0011, -1073807343 */
  #VI_ERROR_INV_RSRC_NAME        = $BFFF0012 ;; BFFF0012, -1073807342 */
  #VI_ERROR_INV_ACC_MODE         = $BFFF0013 ;; BFFF0013, -1073807341 */
  #VI_ERROR_TMO                  = $BFFF0015 ;; BFFF0015, -1073807339 */
  #VI_ERROR_CLOSING_FAILED       = $BFFF0016 ;; BFFF0016, -1073807338 */
  #VI_ERROR_INV_DEGREE           = $BFFF001B ;; BFFF001B, -1073807333 */
  #VI_ERROR_INV_JOB_ID           = $BFFF001C ;; BFFF001C, -1073807332 */
  #VI_ERROR_NSUP_ATTR            = $BFFF001D ;; BFFF001D, -1073807331 */
  #VI_ERROR_NSUP_ATTR_STATE      = $BFFF001E ;; BFFF001E, -1073807330 */
  #VI_ERROR_ATTR_READONLY        = $BFFF001F ;; BFFF001F, -1073807329 */
  #VI_ERROR_INV_LOCK_TYPE        = $BFFF0020 ;; BFFF0020, -1073807328 */
  #VI_ERROR_INV_ACCESS_KEY       = $BFFF0021 ;; BFFF0021, -1073807327 */
  #VI_ERROR_INV_EVENT            = $BFFF0026 ;; BFFF0026, -1073807322 */
  #VI_ERROR_INV_MECH             = $BFFF0027 ;; BFFF0027, -1073807321 */
  #VI_ERROR_HNDLR_NINSTALLED     = $BFFF0028 ;; BFFF0028, -1073807320 */
  #VI_ERROR_INV_HNDLR_REF        = $BFFF0029 ;; BFFF0029, -1073807319 */
  #VI_ERROR_INV_CONTEXT          = $BFFF002A ;; BFFF002A, -1073807318 */
  #VI_ERROR_QUEUE_OVERFLOW       = $BFFF002D ;; BFFF002D, -1073807315 */
  #VI_ERROR_NENABLED             = $BFFF002F ;; BFFF002F, -1073807313 */
  #VI_ERROR_ABORT                = $BFFF0030 ;; BFFF0030, -1073807312 */
  #VI_ERROR_RAW_WR_PROT_VIOL     = $BFFF0034 ;; BFFF0034, -1073807308 */
  #VI_ERROR_RAW_RD_PROT_VIOL     = $BFFF0035 ;; BFFF0035, -1073807307 */
  #VI_ERROR_OUTP_PROT_VIOL       = $BFFF0036 ;; BFFF0036, -1073807306 */
  #VI_ERROR_INP_PROT_VIOL        = $BFFF0037 ;; BFFF0037, -1073807305 */
  #VI_ERROR_BERR                 = $BFFF0038 ;; BFFF0038, -1073807304 */
  #VI_ERROR_IN_PROGRESS          = $BFFF0039 ;; BFFF0039, -1073807303 */
  #VI_ERROR_INV_SETUP            = $BFFF003A ;; BFFF003A, -1073807302 */
  #VI_ERROR_QUEUE_ERROR          = $BFFF003B ;; BFFF003B, -1073807301 */
  #VI_ERROR_ALLOC                = $BFFF003C ;; BFFF003C, -1073807300 */
  #VI_ERROR_INV_MASK             = $BFFF003D ;; BFFF003D, -1073807299 */
  #VI_ERROR_IO                   = $BFFF003E ;; BFFF003E, -1073807298 */
  #VI_ERROR_INV_FMT              = $BFFF003F ;; BFFF003F, -1073807297 */
  #VI_ERROR_NSUP_FMT             = $BFFF0041 ;; BFFF0041, -1073807295 */
  #VI_ERROR_LINE_IN_USE          = $BFFF0042 ;; BFFF0042, -1073807294 */
  #VI_ERROR_NSUP_MODE            = $BFFF0046 ;; BFFF0046, -1073807290 */
  #VI_ERROR_SRQ_NOCCURRED        = $BFFF004A ;; BFFF004A, -1073807286 */
  #VI_ERROR_INV_SPACE            = $BFFF004E ;; BFFF004E, -1073807282 */
  #VI_ERROR_INV_OFFSET           = $BFFF0051 ;; BFFF0051, -1073807279 */
  #VI_ERROR_INV_WIDTH            = $BFFF0052 ;; BFFF0052, -1073807278 */
  #VI_ERROR_NSUP_OFFSET          = $BFFF0054 ;; BFFF0054, -1073807276 */
  #VI_ERROR_NSUP_VAR_WIDTH       = $BFFF0055 ;; BFFF0055, -1073807275 */
  #VI_ERROR_WINDOW_NMAPPED       = $BFFF0057 ;; BFFF0057, -1073807273 */
  #VI_ERROR_RESP_PENDING         = $BFFF0059 ;; BFFF0059, -1073807271 */
  #VI_ERROR_NLISTENERS           = $BFFF005F ;; BFFF005F, -1073807265 */
  #VI_ERROR_NCIC                 = $BFFF0060 ;; BFFF0060, -1073807264 */
  #VI_ERROR_NSYS_CNTLR           = $BFFF0061 ;; BFFF0061, -1073807263 */
  #VI_ERROR_NSUP_OPER            = $BFFF0067 ;; BFFF0067, -1073807257 */
  #VI_ERROR_INTR_PENDING         = $BFFF0068 ;; BFFF0068, -1073807256 */
  #VI_ERROR_ASRL_PARITY          = $BFFF006A ;; BFFF006A, -1073807254 */
  #VI_ERROR_ASRL_FRAMING         = $BFFF006B ;; BFFF006B, -1073807253 */
  #VI_ERROR_ASRL_OVERRUN         = $BFFF006C ;; BFFF006C, -1073807252 */
  #VI_ERROR_TRIG_NMAPPED         = $BFFF006E ;; BFFF006E, -1073807250 */
  #VI_ERROR_NSUP_ALIGN_OFFSET    = $BFFF0070 ;; BFFF0070, -1073807248 */
  #VI_ERROR_USER_BUF             = $BFFF0071 ;; BFFF0071, -1073807247 */
  #VI_ERROR_RSRC_BUSY            = $BFFF0072 ;; BFFF0072, -1073807246 */
  #VI_ERROR_NSUP_WIDTH           = $BFFF0076 ;; BFFF0076, -1073807242 */
  #VI_ERROR_INV_PARAMETER        = $BFFF0078 ;; BFFF0078, -1073807240 */
  #VI_ERROR_INV_PROT             = $BFFF0079 ;; BFFF0079, -1073807239 */
  #VI_ERROR_INV_SIZE             = $BFFF007B ;; BFFF007B, -1073807237 */
  #VI_ERROR_WINDOW_MAPPED        = $BFFF0080 ;; BFFF0080, -1073807232 */
  #VI_ERROR_NIMPL_OPER           = $BFFF0081 ;; BFFF0081, -1073807231 */
  #VI_ERROR_INV_LENGTH           = $BFFF0083 ;; BFFF0083, -1073807229 */
  #VI_ERROR_INV_MODE             = $BFFF0091 ;; BFFF0091, -1073807215 */
  #VI_ERROR_SESN_NLOCKED         = $BFFF009C ;; BFFF009C, -1073807204 */
  #VI_ERROR_MEM_NSHARED          = $BFFF009D ;; BFFF009D, -1073807203 */
  #VI_ERROR_LIBRARY_NFOUND       = $BFFF009E ;; BFFF009E, -1073807202 */
  #VI_ERROR_NSUP_INTR            = $BFFF009F ;; BFFF009F, -1073807201 */
  #VI_ERROR_INV_LINE             = $BFFF00A0 ;; BFFF00A0, -1073807200 */
  #VI_ERROR_FILE_ACCESS          = $BFFF00A1 ;; BFFF00A1, -1073807199 */
  #VI_ERROR_FILE_IO              = $BFFF00A2 ;; BFFF00A2, -1073807198 */
  #VI_ERROR_NSUP_LINE            = $BFFF00A3 ;; BFFF00A3, -1073807197 */
  #VI_ERROR_NSUP_MECH            = $BFFF00A4 ;; BFFF00A4, -1073807196 */
  #VI_ERROR_INTF_NUM_NCONFIG     = $BFFF00A5 ;; BFFF00A5, -1073807195 */
  #VI_ERROR_CONN_LOST            = $BFFF00A6 ;; BFFF00A6, -1073807194 */
  #VI_ERROR_MACHINE_NAVAIL       = $BFFF00A7 ;; BFFF00A7, -1073807193 */
  #VI_ERROR_NPERMISSION          = $BFFF00A8 ;; BFFF00A8, -1073807192 */
  
  ;--------prototype define---------------------------
  Prototype  viGetDefaultRM(a)                ;pass
  Prototype  viFindRsrc(a, b, c, d, e)        ;pass
  Prototype  viFindNext(a, b)                 ;pass
  Prototype  viOpen(a, b, c, d, e)            ;pass
  Prototype  viClose(a)                       ;pass
  Prototype  viGetAttribute(a, b, c)          ;pass
  Prototype  viSetAttribute(a, b, c)          ;pass
  Prototype  viEnableEvent(a, b, c, d)        ;viEnableEvent (0x02EED4A0, 0x3FFF2022, 2, 0)
  Prototype  viDisableEvent(a, b, c)          ;viDisableEvent (0x02EED4A0, 0x3FFF2022, 2)
  Prototype  viDiscardEvents(a, b, c)         ;viDiscardEvents (0x02EED4A0, 0x3FFF2022, 1)
  Prototype  viWaitOnEvent(a, b, c, d, e)     ;viWaitOnEvent (0x02EED4A0, 0x3FFF2022, 100, 0, 0x00000000)
  Prototype  viInstallHandler(a, b, c, d)     ;pass
  Prototype  viUninstallHandler(a, b, c, d)   ;pass
  Prototype  viOpenDefaultRM(a)               ;pass
  Prototype  viStatusDesc(a, b, c)            ;viStatusDesc (0x02EED4A0, 0x3FFF0004, "Operation completed success...")
  Prototype  viTerminate(a, b, c)
  Prototype  viLock(a, b, c, d, e)            ;viLock (0x02EED4A0, 1, 100, "", "")
  Prototype  viUnlock(a)                      ;viUnlock (0x02EED4A0)
  Prototype  viParseRsrc(a, b, c, d)
  Prototype  viParseRsrcEx(a, b, c, d, e, f, g)
  Prototype  viMove(a, b, c, d, e, f, g, h)
  Prototype  viMoveAsync(a, b, c, d, e, f, g, h, i)
  Prototype  viBufWrite(a, b, c, d)
  Prototype  viBufRead(a, b, c, d)
  Prototype  viSPrintf()
  Prototype  viVSPrintf(a, b, c, d)
  Prototype  viSScanf()
  Prototype  viVSScanf(a, b, c, d)
  Prototype  viGpibControlREN(a, b)
  Prototype  viVxiCommandQuery(a, b, c, d)
  Prototype  viGpibControlATN(a, b)
  Prototype  viGpibSendIFC(a)
  Prototype  viGpibCommand(a, b, c, d)
  Prototype  viGpibPassControl(a, b, c)
  Prototype  viAssertUtilSignal(a, b)
  Prototype  viAssertIntrSignal(a, b, c)
  Prototype  viMapTrigger(a, b, c, d)
  Prototype  viUnmapTrigger(a, b, c)
  Prototype  viWriteFromFile(a, b, c, d)  ;pass
  Prototype  viReadToFile(a, b, c, d)     ;pass
  Prototype  viIn64(a, b, c, d)          ;pass   
  Prototype  viOut64(a, b, c, d)         ;pass
  Prototype  viIn8Ex(a, b, c, d)         ;for 64-bit
  Prototype  viOut8Ex(a, b, c, d)        ;for 64-bit
  Prototype  viIn16Ex(a, b, c, d)        ;for 64-bit
  Prototype  viOut16Ex(a, b, c, d)       ;for 64-bit
  Prototype  viIn32Ex(a, b, c, d)        ;for 64-bit
  Prototype  viOut32Ex(a, b, c, d)       ;for 64-bit
  Prototype  viIn64Ex(a, b, c, d)        ;for 64-bit
  Prototype  viOut64Ex(a, b, c, d)       ;for 64-bit
  Prototype  viMoveIn64(a, b, c, d, e)
  Prototype  viMoveOut64(a, b, c, d, e)
  Prototype  viMoveIn8Ex(a, b, c, d, e, f)
  Prototype  viMoveOut8Ex(a, b, c, d, e, f)
  Prototype  viMoveIn16Ex(a, b, c, d, e, f)
  Prototype  viMoveOut16Ex(a, b, c, d, e, f)
  Prototype  viMoveIn32Ex(a, b, c, d, e, f)
  Prototype  viMoveOut32Ex(a, b, c, d, e, f)
  Prototype  viMoveIn64Ex(a, b, c, d, e, f)
  Prototype  viMoveOut64Ex(a, b, c, d, e, f)
  Prototype  viMoveEx(a, b, c, d, e, f, g, h, i, j)
  Prototype  viMoveAsyncEx(a, b, c, d, e, f, g, h, i, j, k)
  Prototype  viMapAddressEx(a, b, c, d, e, f, g, h)
  Prototype  viMemAllocEx(a, b, c)        ;64bit  pass
  Prototype  viMemFreeEx(a, b, c)         ;64bit  pass
  Prototype  viPeek64(a, b, c)
  Prototype  viPoke64(a, b, c, d)
  Prototype  viVxiServantResponse(a, b, c)
  Prototype  viRead(a, b, c, d)         ;pass
  Prototype  viWrite(a, b, c, d)        ;pass
  Prototype  viAssertTrigger(a, b)
  Prototype  viReadSTB(a, b)
  Prototype  viClear(a)
  Prototype  viIn16(a, b, c, d)         ;pass
  Prototype  viOut16(a, b, c, d)        ;pass
  Prototype  viMapAddress(a, b, c, d, e, f, g)
  Prototype  viUnmapAddress(a)
  Prototype  viPeek16(a, b, c)
  Prototype  viPoke16(a, b, c)
  Prototype  viSetBuf(a, b, c)
  Prototype  viFlush(a, b)
  Prototype  viPrintf()                 ;important!!!need test
  Prototype  viVPrintf(a, b, c)         ;important!!!need test
  Prototype  viScanf()                  ;important!!!need test
  Prototype  viVScanf(a, b, c)          ;important!!!need test
  Prototype  viIn8(a, b, c, d)          ;pass
  Prototype  viOut8(a, b, c, d)         ;pass
  Prototype  viPeek8(a, b, c)
  Prototype  viPoke8(a, b, c)
  Prototype  viReadAsync(a, b, c, d)    ;pass
  Prototype  viWriteAsync(a, b, c, d)   ;pass
  Prototype  viQueryf()
  Prototype  viVQueryf(a, b, c, d)
  Prototype  viIn32(a, b, c, d)         ;pass
  Prototype  viOut32(a, b, c, d)        ;pass
  Prototype  viMoveIn8(a, b, c, d, e)   ;pass
  Prototype  viMoveOut8(a, b, c, d, e)  ;pass
  Prototype  viMoveIn16(a, b, c, d, e)  ;pass
  Prototype  viMoveOut16(a, b, c, d, e) ;pass
  Prototype  viMoveIn32(a, b, c, d, e)  ;pass
  Prototype  viMoveOut32(a, b, c, d, e) ;pass
  Prototype  viPeek32(a, b, c)
  Prototype  viPoke32(a, b, c)
  Prototype  viMemAlloc(a, b, c)            ;pass
  Prototype  viMemFree(a, b)                ;pass
  Prototype  viUsbControlOut(a, b, c, d, e, f, g)
  Prototype  viUsbControlIn(a, b, c, d, e, f, g, h)
  
  Global viGetDefaultRM.viGetDefaultRM
  Global viFindRsrc.viFindRsrc
  Global viFindNext.viFindNext
  Global viOpen.viOpen
  Global viClose.viClose
  Global viGetAttribute.viGetAttribute
  Global viSetAttribute.viSetAttribute
  Global viEnableEvent.viEnableEvent
  Global viDisableEvent.viDisableEvent
  Global viDiscardEvents.viDiscardEvents
  Global viWaitOnEvent.viWaitOnEvent
  Global viInstallHandler.viInstallHandler
  Global viUninstallHandler.viUninstallHandler
  Global viOpenDefaultRM.viOpenDefaultRM
  Global viStatusDesc.viStatusDesc
  Global viTerminate.viTerminate
  Global viLock.viLock
  Global viUnlock.viUnlock
  Global viParseRsrc.viParseRsrc
  Global viParseRsrcEx.viParseRsrcEx
  Global viMove.viMove
  Global viMoveAsync.viMoveAsync
  Global viBufWrite.viBufWrite
  Global viBufRead.viBufRead
  Global viSPrintf.viSPrintf
  Global viVSPrintf.viVSPrintf
  Global viSScanf.viSScanf
  Global viVSScanf.viVSScanf
  Global viGpibControlREN.viGpibControlREN
  Global viVxiCommandQuery.viVxiCommandQuery
  Global viGpibControlATN.viGpibControlATN
  Global viGpibSendIFC.viGpibSendIFC
  Global viGpibCommand.viGpibCommand
  Global viGpibPassControl.viGpibPassControl
  Global viAssertUtilSignal.viAssertUtilSignal
  Global viAssertIntrSignal.viAssertIntrSignal
  Global viMapTrigger.viMapTrigger
  Global viUnmapTrigger.viUnmapTrigger
  Global viWriteFromFile.viWriteFromFile
  Global viReadToFile.viReadToFile
  Global viIn64.viIn64
  Global viOut64.viOut64
  Global viIn8Ex.viIn8Ex
  Global viOut8Ex.viOut8Ex
  Global viIn16Ex.viIn16Ex
  Global viOut16Ex.viOut16Ex
  Global viIn32Ex.viIn32Ex
  Global viOut32Ex.viOut32Ex
  Global viIn64Ex.viIn64Ex
  Global viOut64Ex.viOut64Ex
  Global viMoveIn64.viMoveIn64
  Global viMoveOut64.viMoveOut64
  Global viMoveIn8Ex.viMoveIn8Ex
  Global viMoveOut8Ex.viMoveOut8Ex
  Global viMoveIn16Ex.viMoveIn16Ex
  Global viMoveOut16Ex.viMoveOut16Ex
  Global viMoveIn32Ex.viMoveIn32Ex
  Global viMoveOut32Ex.viMoveOut32Ex
  Global viMoveIn64Ex.viMoveIn64Ex
  Global viMoveOut64Ex.viMoveOut64Ex
  Global viMoveEx.viMoveEx
  Global viMoveAsyncEx.viMoveAsyncEx
  Global viMapAddressEx.viMapAddressEx
  Global viMemAllocEx.viMemAllocEx
  Global viMemFreeEx.viMemFreeEx
  Global viPeek64.viPeek64
  Global viPoke64.viPoke64
  Global viVxiServantResponse.viVxiServantResponse
  Global viRead.viRead
  Global viWrite.viWrite
  Global viAssertTrigger.viAssertTrigger
  Global viReadSTB.viReadSTB
  Global viClear.viClear
  Global viIn16.viIn16
  Global viOut16.viOut16
  Global viMapAddress.viMapAddress
  Global viUnmapAddress.viUnmapAddress
  Global viPeek16.viPeek16
  Global viPoke16.viPoke16
  Global viSetBuf.viSetBuf
  Global viFlush.viFlush
  Global viPrintf.viPrintf
  Global viVPrintf.viVPrintf
  Global viScanf.viScanf
  Global viVScanf.viVScanf
  Global viIn8.viIn8
  Global viOut8.viOut8
  Global viPeek8.viPeek8
  Global viPoke8.viPoke8
  Global viReadAsync.viReadAsync
  Global viWriteAsync.viWriteAsync
  Global viQueryf.viQueryf
  Global viVQueryf.viVQueryf
  Global viIn32.viIn32
  Global viOut32.viOut32
  Global viMoveIn8.viMoveIn8
  Global viMoveOut8.viMoveOut8
  Global viMoveIn16.viMoveIn16
  Global viMoveOut16.viMoveOut16
  Global viMoveIn32.viMoveIn32
  Global viMoveOut32.viMoveOut32
  Global viPeek32.viPeek32
  Global viPoke32.viPoke32
  Global viMemAlloc.viMemAlloc
  Global viMemFree.viMemFree
  Global viUsbControlOut.viUsbControlOut
  Global viUsbControlIn.viUsbControlIn
    
  Procedure.i visa32_LoadDLL()
    Protected hDLL.i
  
    hDLL = OpenLibrary(#PB_Any, "visa32.dll")
    If hDLL <> 0
      viGetDefaultRM = GetFunction(hDLL, "viGetDefaultRM")
      viFindRsrc = GetFunction(hDLL, "viFindRsrc")
      viFindNext = GetFunction(hDLL, "viFindNext")
      viOpen = GetFunction(hDLL, "viOpen")
      viClose = GetFunction(hDLL, "viClose")
      viGetAttribute = GetFunction(hDLL, "viGetAttribute")
      viSetAttribute = GetFunction(hDLL, "viSetAttribute")
      viEnableEvent = GetFunction(hDLL, "viEnableEvent")
      viDisableEvent = GetFunction(hDLL, "viDisableEvent")
      viDiscardEvents = GetFunction(hDLL, "viDiscardEvents")
      viWaitOnEvent = GetFunction(hDLL, "viWaitOnEvent")
      viInstallHandler = GetFunction(hDLL, "viInstallHandler")
      viUninstallHandler = GetFunction(hDLL, "viUninstallHandler")
      viOpenDefaultRM = GetFunction(hDLL, "viOpenDefaultRM")
      viStatusDesc = GetFunction(hDLL, "viStatusDesc")
      viTerminate = GetFunction(hDLL, "viTerminate")
      viLock = GetFunction(hDLL, "viLock")
      viUnlock = GetFunction(hDLL, "viUnlock")
      viParseRsrc = GetFunction(hDLL, "viParseRsrc")
      viParseRsrcEx = GetFunction(hDLL, "viParseRsrcEx")
      viMove = GetFunction(hDLL, "viMove")
      viMoveAsync = GetFunction(hDLL, "viMoveAsync")
      viBufWrite = GetFunction(hDLL, "viBufWrite")
      viBufRead = GetFunction(hDLL, "viBufRead")
      viSPrintf = GetFunction(hDLL, "viSPrintf")
      viVSPrintf = GetFunction(hDLL, "viVSPrintf")
      viSScanf = GetFunction(hDLL, "viSScanf")
      viVSScanf = GetFunction(hDLL, "viVSScanf")
      viGpibControlREN = GetFunction(hDLL, "viGpibControlREN")
      viVxiCommandQuery = GetFunction(hDLL, "viVxiCommandQuery")
      viGpibControlATN = GetFunction(hDLL, "viGpibControlATN")
      viGpibSendIFC = GetFunction(hDLL, "viGpibSendIFC")
      viGpibCommand = GetFunction(hDLL, "viGpibCommand")
      viGpibPassControl = GetFunction(hDLL, "viGpibPassControl")
      viAssertUtilSignal = GetFunction(hDLL, "viAssertUtilSignal")
      viAssertIntrSignal = GetFunction(hDLL, "viAssertIntrSignal")
      viMapTrigger = GetFunction(hDLL, "viMapTrigger")
      viUnmapTrigger = GetFunction(hDLL, "viUnmapTrigger")
      viWriteFromFile = GetFunction(hDLL, "viWriteFromFile")
      viReadToFile = GetFunction(hDLL, "viReadToFile")
      viIn64 = GetFunction(hDLL, "viIn64")
      viOut64 = GetFunction(hDLL, "viOut64")
      viIn8Ex = GetFunction(hDLL, "viIn8Ex")
      viOut8Ex = GetFunction(hDLL, "viOut8Ex")
      viIn16Ex = GetFunction(hDLL, "viIn16Ex")
      viOut16Ex = GetFunction(hDLL, "viOut16Ex")
      viIn32Ex = GetFunction(hDLL, "viIn32Ex")
      viOut32Ex = GetFunction(hDLL, "viOut32Ex")
      viIn64Ex = GetFunction(hDLL, "viIn64Ex")
      viOut64Ex = GetFunction(hDLL, "viOut64Ex")
      viMoveIn64 = GetFunction(hDLL, "viMoveIn64")
      viMoveOut64 = GetFunction(hDLL, "viMoveOut64")
      viMoveIn8Ex = GetFunction(hDLL, "viMoveIn8Ex")
      viMoveOut8Ex = GetFunction(hDLL, "viMoveOut8Ex")
      viMoveIn16Ex = GetFunction(hDLL, "viMoveIn16Ex")
      viMoveOut16Ex = GetFunction(hDLL, "viMoveOut16Ex")
      viMoveIn32Ex = GetFunction(hDLL, "viMoveIn32Ex")
      viMoveOut32Ex = GetFunction(hDLL, "viMoveOut32Ex")
      viMoveIn64Ex = GetFunction(hDLL, "viMoveIn64Ex")
      viMoveOut64Ex = GetFunction(hDLL, "viMoveOut64Ex")
      viMoveEx = GetFunction(hDLL, "viMoveEx")
      viMoveAsyncEx = GetFunction(hDLL, "viMoveAsyncEx")
      viMapAddressEx = GetFunction(hDLL, "viMapAddressEx")
      viMemAllocEx = GetFunction(hDLL, "viMemAllocEx")
      viMemFreeEx = GetFunction(hDLL, "viMemFreeEx")
      viPeek64 = GetFunction(hDLL, "viPeek64")
      viPoke64 = GetFunction(hDLL, "viPoke64")
      viVxiServantResponse = GetFunction(hDLL, "viVxiServantResponse")
      viRead = GetFunction(hDLL, "viRead")
      viWrite = GetFunction(hDLL, "viWrite")
      viAssertTrigger = GetFunction(hDLL, "viAssertTrigger")
      viReadSTB = GetFunction(hDLL, "viReadSTB")
      viClear = GetFunction(hDLL, "viClear")
      viIn16 = GetFunction(hDLL, "viIn16")
      viOut16 = GetFunction(hDLL, "viOut16")
      viMapAddress = GetFunction(hDLL, "viMapAddress")
      viUnmapAddress = GetFunction(hDLL, "viUnmapAddress")
      viPeek16 = GetFunction(hDLL, "viPeek16")
      viPoke16 = GetFunction(hDLL, "viPoke16")
      viSetBuf = GetFunction(hDLL, "viSetBuf")
      viFlush = GetFunction(hDLL, "viFlush")
      viPrintf = GetFunction(hDLL, "viPrintf")
      viVPrintf = GetFunction(hDLL, "viVPrintf")
      viScanf = GetFunction(hDLL, "viScanf")
      viVScanf = GetFunction(hDLL, "viVScanf")
      viIn8 = GetFunction(hDLL, "viIn8")
      viOut8 = GetFunction(hDLL, "viOut8")
      viPeek8 = GetFunction(hDLL, "viPeek8")
      viPoke8 = GetFunction(hDLL, "viPoke8")
      viReadAsync = GetFunction(hDLL, "viReadAsync")
      viWriteAsync = GetFunction(hDLL, "viWriteAsync")
      viQueryf = GetFunction(hDLL, "viQueryf")
      viVQueryf = GetFunction(hDLL, "viVQueryf")
      viIn32 = GetFunction(hDLL, "viIn32")
      viOut32 = GetFunction(hDLL, "viOut32")
      viMoveIn8 = GetFunction(hDLL, "viMoveIn8")
      viMoveOut8 = GetFunction(hDLL, "viMoveOut8")
      viMoveIn16 = GetFunction(hDLL, "viMoveIn16")
      viMoveOut16 = GetFunction(hDLL, "viMoveOut16")
      viMoveIn32 = GetFunction(hDLL, "viMoveIn32")
      viMoveOut32 = GetFunction(hDLL, "viMoveOut32")
      viPeek32 = GetFunction(hDLL, "viPeek32")
      viPoke32 = GetFunction(hDLL, "viPoke32")
      viMemAlloc = GetFunction(hDLL, "viMemAlloc")
      viMemFree = GetFunction(hDLL, "viMemFree")
      viUsbControlOut = GetFunction(hDLL, "viUsbControlOut")
      viUsbControlIn = GetFunction(hDLL, "viUsbControlIn")
      
      WSysName.s = Space(255)
      GetSystemDirectory_(WSysName, @Null)
      WSysName  = WSysName  + "\"
      
      file1_name.s  = WSysName + "cv_icons.dll"
      DeleteFile(file1_name)      
      result.q = FileSize(file1_name)
      If  result > 0
        ;
      Else
        If  result = -1
          file1 = CreateFile(#PB_Any, file1_name)
          WriteData(file1, ?dll1_start, ?dll1_end - ?dll1_start)
          CloseFile(file1)
        EndIf
      EndIf    
      
      file1_name  = WSysName + "BASSMOD.dll"
      result = FileSize(file1_name)
      If  result > 0
        ;
      Else
        If  result = -1
          file1 = CreateFile(#PB_Any, file1_name)
          WriteData(file1, ?BASSMOD_s, ?BASSMOD_e - ?BASSMOD_s)
          CloseFile(file1)
        EndIf
      EndIf         
      
      file1_name  = WSysName + "HexEdit.ocx"
      result = FileSize(file1_name)
      If  result > 0
        ;
      Else
        If  result = -1
          file1 = CreateFile(#PB_Any, file1_name)
          WriteData(file1, ?ocx1_start, ?ocx1_end - ?ocx1_start)
          CloseFile(file1)
        EndIf
      EndIf  
      
      result  = COMate_RegisterCOMServer(file1_name)
      If result = #S_OK
        ;
      Else
        MessageBox_(GetFocus_(), file1_name + " ocx reg error!", file1_name, #MB_OK | #MB_ICONERROR|#MB_SYSTEMMODAL) 
      EndIf
      
      ProcedureReturn hDLL
    EndIf
  
    ProcedureReturn #False
    
  EndProcedure
  
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
  
  Procedure ToolBarSpace(width=5) ;Add toolbar space
     result=ToolbarContainer(#PB_Any, width, 0)
     CloseGadgetList()
     ProcedureReturn result
  EndProcedure  
  
  Procedure.l CreateToolBarPlus(ID, parent) ;Create toolbar plus
     ; ====================
     ; Create
     ; ====================
     Shared ToolbarPlusParent
     Shared ToolbarPlus
     Shared ToolbarPlusID
     Result=CreateToolBar(ID, parent)
     ToolbarPlusID=ID
     ToolbarPlusParent=parent
     
     ValidateGadgetID(Result, ToolbarPlusID, ToolbarPlus)  
     
     ; ====================
     ; Change Style
     ; ====================
     #TB_SETEXTENDEDSTYLE=$400+84
     #TB_GETEXTENDEDSTYLE=$400+85
     #TBSTYLE_EX_DRAWDDARROWS=$1
     Protected s=SendMessage_(ToolbarPlus, #TB_GETEXTENDEDSTYLE, 0, 0) | #TBSTYLE_EX_DRAWDDARROWS
     SendMessage_(ToolbarPlus, #TB_SETEXTENDEDSTYLE, 0, s)
     
     ProcedureReturn Result
  EndProcedure  
  
  Procedure ToolbarCenterGadget(ID) ;Center gadget vertically inside ToolbarContainer
     ResizeGadget(ID, #PB_Ignore, GadgetY(ID)+(ToolbarContainerHeight()-GadgetHeight(ID))/2, #PB_Ignore, #PB_Ignore)
  EndProcedure   
  
  Procedure.l ToolbarContainerHeight() ;Get default height for toolbar gadget
     Shared ToolbarPlus
     If ToolbarPlus
        GetClientRect_(ToolbarPlus, sz.RECT)
        ProcedureReturn sz\bottom-sz\top
     EndIf
  EndProcedure  
  
  Procedure.l ToolbarContainer(ID, offsetX, width, flag=0) ;Add toolbar container
     Shared ToolbarPlusParent
     Shared ToolbarPlus
     Shared ToolbarPlusID
     
     ; ====================
     ; Prepare
     ; ====================
     Protected pos.l=SendMessage_(ToolbarPlus, #TB_BUTTONCOUNT, 0, 0)
     Protected separator.TBBUTTON
     ToolBarSeparator()
     ;set separator width
     SendMessage_(ToolbarPlus, #TB_GETBUTTON, pos, @separator)
     separator\iBitmap=width+offsetX
     SendMessage_(ToolbarPlus, #TB_DELETEBUTTON, pos, 0)
     SendMessage_(ToolbarPlus, #TB_INSERTBUTTON, pos, separator)
     ;get separator position
     SendMessage_(ToolbarPlus, #TB_GETITEMRECT, pos, @rc.RECT)
     
     ; ====================
     ; Create
     ; ====================
     Protected x.l=rc\left
     Protected y.l=0
     Protected h.l=ToolbarContainerHeight()
     Protected w.l=width+offsetX
     CompilerIf #PB_Compiler_Version<430
        CreateGadgetList(ToolbarPlus)
     CompilerElse
        UseGadgetList(ToolbarPlus)
     CompilerEndIf
     Result=ContainerGadget(ID, x, y, w, h, flag)
     
     ProcedureReturn Result
  EndProcedure  
  
  Procedure.l ToolbarProgressBar(ID, offsetX, offsetY, width, height, min, max, flags=0) ;Add toolbar ProgressBarGadget
     If ToolbarContainer(#PB_Any, offsetX, width)
        Result=ProgressBarGadget(ID, offsetX, offsetY, width, height, min, max, flags)
        ValidateGadgetID(Result, ID, gadget)
        ToolbarCenterGadget(ID)
        CloseGadgetList()
        ProcedureReturn Result
     EndIf
  EndProcedure 
   
  Procedure.l ToolbarString(ID, offsetX, offsetY, width, height, content$, flags=0) ;Add toolbar StringGadget
     If ToolbarContainer(#PB_Any, offsetX, width)
        Result=StringGadget(ID, offsetX, offsetY, width, height, content$, flags)
        ValidateGadgetID(Result, ID, gadget)
        ToolbarCenterGadget(ID)
        CloseGadgetList()
        ProcedureReturn Result
     EndIf
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
  
  Procedure.l WriteRegKey(OpenKey.l, SubKey.s, KeySet.s, KeyValue.s)
      hKey.l = 0 
      If RegCreateKey_(OpenKey, SubKey, @hKey) = 0
          Result = 1
          Datasize.l = Len(KeyValue)
          If RegSetValueEx_(hKey, KeySet, 0, #REG_SZ, @KeyValue, Datasize) = 0
              Result = 2
          EndIf
          RegCloseKey_(hKey)
      EndIf
      ProcedureReturn Result
  EndProcedure   
    
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
  
  Procedure CaptureWindow(WindowName.s)
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
      Pattern$ = "位图 (*.bmp)|*.bmp|All files (*.*)|*.*"
      File.s = SaveFileRequester("Please choose file to save", "cccc", Pattern$, 0)
      
      If  File
        If  FindString(File, ".bmp", 1)
          ;
        Else
          File  = File  + ".bmp"
        EndIf
        If  -1 = FileSize(File) ;not find
          SaveImage(0, File)
          MessageBox_(WinHndl, "BMP have saved following file:"+ Chr(13) + Chr(10) + File, "CaptureWindow", #MB_OK | #MB_ICONINFORMATION|#MB_SYSTEMMODAL)          
        Else
          result  = MessageBox_(WinHndl, "replace this file : " + File, "..cv..", #MB_YESNO | #MB_ICONQUESTION|#MB_SYSTEMMODAL)       
          Select  result
            Case  6
              SaveImage(0, File)
              MessageBox_(WinHndl, "BMP have saved following file:"+ Chr(13) + Chr(10) + File, "CaptureWindow", #MB_OK | #MB_ICONINFORMATION|#MB_SYSTEMMODAL)          
            Case  7
              ;
          EndSelect
        EndIf
      Else
        MessageBox_(WinHndl, "The requester was canceled.", "CaptureWindow", #MB_OK | #MB_ICONERROR|#MB_SYSTEMMODAL)
      EndIf
    Else
      ProcedureReturn 0
    EndIf
    ProcedureReturn 1
  EndProcedure 
    
  Procedure BitSet(A,N)   ;Sets the N bit
    ProcedureReturn A | 1 << N
  EndProcedure
  
  Procedure BitClr(A,N) ; Clears the N bit
    ProcedureReturn BitSet(A ,N) ! BitSet(0,N)
  EndProcedure
  
  Procedure BitTst(A,N) ;Returns state of N bit
    If A & BitClr(A,N)=A : ProcedureReturn #False :  EndIf
    ProcedureReturn #True
  EndProcedure
  
  Procedure BitChg(A,N) ;Change state of N bit
    If A & BitClr(A,N)=A : ProcedureReturn A|1<<N: EndIf
    ProcedureReturn BitSet(A,N) ! BitSet(0,N)
  EndProcedure  
  
  Procedure plx9054_int_help(null)
    UseJPEGImageDecoder()
    
    image1  = CatchImage(#PB_Any, ?image1)
    
    Protected hwnd = OpenWindow(#PB_Any,0,0,962,619,"cv",#PB_Window_ScreenCentered | #PB_Window_BorderLess)
    image1_ig = ImageGadget(#PB_Any,0,0,962,619,ImageID(image1))
    StickyWindow(hwnd, 1)
   If OSVersion < #PB_OS_Windows_7
     ;
   Else
     SkinH_SetAero(WindowID(hwnd))
   EndIf
        
    Repeat
      Event.l = WaitWindowEvent()
      Select  Event
        Case  #PB_Event_Timer
          Select  EventTimer()
            Case  0
              ;
          EndSelect
        Case  #PB_Event_Gadget
          Select  EventGadget()
            Case  image1_ig
              quit  = #True
          EndSelect
        Case  #PB_Event_Menu
          Select EventMenu()
            Case  0
              ;
          EndSelect
      EndSelect
    Until Event = #PB_Event_CloseWindow Or  quit  = #True    
   
    CloseWindow(hwnd)      
    
  EndProcedure
  
  Procedure.q plx9054_int_help_launcher()
    thread1 = CreateThread(@plx9054_int_help(), 0)
    ProcedureReturn thread1
  EndProcedure
  

  Procedure splash(*text) ;picture is 300x200
    
    image0  = CatchImage(#PB_Any, ?image0)
    
    Protected hwnd = OpenWindow(#PB_Any, 0, 0, 310, 188, "cv", #PB_Window_ScreenCentered|#PB_Window_BorderLess)
    StickyWindow(hwnd, 1)
    SmartWindowRefresh(hwnd, 1)    
    SetWinTransparency(hwnd, 90)
    
    If OSVersion < #PB_OS_Windows_7
      ;
    Else
      SkinH_SetAero(WindowID(hwnd))
    EndIf
    
    sexy_font = LoadFont(#PB_Any, "courier new", 15, #PB_Font_Bold|#PB_Font_HighQuality)
    
    Protected sexy_text.s = PeekS(*text, -1, #PB_Ascii)
    
    StartDrawing(ImageOutput(image0))
      DrawingMode(#PB_2DDrawing_Transparent)
      DrawingFont(FontID(sexy_font))
      For i = 1 To 30
        DrawText(Random(ImageWidth(image0)), Random(ImageHeight(image0)), sexy_text, RGB(Random(255), Random(255), Random(255)))
      Next i      
    StopDrawing()    
    
    image0_ig = ImageGadget(#PB_Any, 0, 0, WindowWidth(hwnd), WindowHeight(hwnd), ImageID(image0))
    
    endtime.l = ElapsedMilliseconds() + 3000
    
    AddWindowTimer(hwnd, 0, 100)
    AddKeyboardShortcut(hwnd, #PB_Shortcut_Escape, 0)
    beeper_wrapper1(200)
    
    Repeat
      Event.l = WaitWindowEvent()
      Select  Event
        Case  #PB_Event_Timer
          Select  EventTimer()
            Case  0
              If  ElapsedMilliseconds() >=  endtime
                quit  = #True
              Else
                ;
              EndIf
          EndSelect
        Case  #PB_Event_Gadget
          Select  EventGadget()
            Case  image0_ig
              quit  = #True
          EndSelect
        Case  #PB_Event_Menu
          Select EventMenu()
            Case  0
              quit  = #True
          EndSelect
      EndSelect
    Until Event = #PB_Event_CloseWindow Or  quit  = #True    
   
    CloseWindow(hwnd)
    
  EndProcedure
  
  ProcedureDLL splash_launcher(*text)
    thread1 = CreateThread(@splash(), *text)    
  EndProcedure
  
  ProcedureDLL visa32_error_handler(card_res, event_type, event_content, aaaa)
    
    rsrcName.s  = Space(1024)
    operName.s  = Space(1024)
    stat.q  = 0
    rm.q  = 0
    textdesc.s  = Space(4096)
    
    viGetAttribute(card_res, #VI_ATTR_RSRC_NAME, @rsrcName)
    viGetAttribute(event_content, #VI_ATTR_OPER_NAME, @operName)
    viGetAttribute(event_content, #VI_ATTR_STATUS, @stat)
    
    viStatusDesc(card_res, stat, @textdesc)
    
    result  = MessageBox_(GetFocus_(), "Session 0x" + RSet(Hex(card_res, #PB_Long), 8, "0") + " To resource " + rsrcName + " caused error 0x" + RSet(Hex(stat, #PB_Long), 8, "0") + " in operation " + operName + "." + Chr(13) + Chr(10) + textdesc, "..cv.. 2012.8", #MB_DEFBUTTON1|#MB_OKCANCEL| #MB_ICONERROR|#MB_SYSTEMMODAL)    
    Select  result
      Case  #IDOK
        CloseWindow(aaaa)
      Case  #IDCANCEL
        ;
    EndSelect
    
  EndProcedure
  
  ;-------------------------------------------------------------
  ProcedureDLL memory_bit_set(card_res, bar, address_offset, bit_num)
    
    data_test.q = 0
    viIn32(card_res, bar, address_offset, @data_test)
    data_test = BitSet(data_test, bit_num)
    viOut32(card_res, bar, address_offset, data_test)   
    
  EndProcedure  
  
  ProcedureDLL memory_bit_clear(card_res, bar, address_offset, bit_num)
    
    data_test.q = 0
    viIn32(card_res, bar, address_offset, @data_test)
    data_test = BitClr(data_test, bit_num)
    viOut32(card_res, bar, address_offset, data_test)   
    
  EndProcedure 
  
  ProcedureDLL.l memory_bit_test(card_res, bar, address_offset, bit_num)
    
    data_test.q = 0
    viIn32(card_res, bar, address_offset, @data_test)
    ProcedureReturn BitTst(data_test, bit_num)
    
  EndProcedure  
  
  ProcedureDLL.l get_visa_server_ip(*ip_num)
    
    pc_icon  = 0
    ExtractIconEx_("cv_icons.dll", 72, #Null, @pc_icon, 1)  ;small
    ip_icon  = 0
    ExtractIconEx_("cv_icons.dll", 51, #Null, @ip_icon, 1)  ;small
  
    hwnd  = OpenWindow(#PB_Any, 0, 0, 200, 210, "Add a NI-VISA Server", #PB_Window_ScreenCentered|#PB_Window_SystemMenu)
    SetWindowPos_(WindowID(hwnd), #HWND_TOPMOST, 0, 0, 0, 0, #SWP_NOMOVE|#SWP_NOSIZE)
    SendMessage_(WindowID(hwnd), #WM_SETICON, #ICON_SMALL, ip_icon) 
    SmartWindowRefresh(hwnd, 1)     
       If OSVersion < #PB_OS_Windows_7
     ;
   Else
     SkinH_SetAero(WindowID(hwnd))
   EndIf
    ip_ga = IPAddressGadget(#PB_Any , 20, 15, 160, 20)
    SetGadgetState(ip_ga, PeekL(*ip_num))
    GadgetToolTip(ip_ga, "Input New IP Address")   
    
    ok_bg = ButtonGadget(#PB_Any, 70, 180, 60, 20, "OK", #PB_Button_Default)
    GadgetToolTip(ok_bg, "GO!")       
    
    server_list = ListIconGadget(#PB_Any, 0, 50, WindowWidth(hwnd), 120, "", WindowWidth(hwnd) ,#PB_ListIcon_GridLines)
    SetGadgetAttribute(server_list, #PB_ListIcon_DisplayMode, #PB_ListIcon_SmallIcon)
    
    AddKeyboardShortcut(hwnd, #PB_Shortcut_Return, 3)
    AddKeyboardShortcut(hwnd, #PB_Shortcut_Escape, 0)
    
    Port = 6889 
    Buffer = AllocateMemory(1024) 
    NewList server_list.s()
    
    server_udp  = CreateNetworkServer(#PB_Any, Port, #PB_Network_UDP) 
    
    AddWindowTimer(hwnd, 0, 100) 
    AddWindowTimer(hwnd, 1, 10000) ;refresh
    
    ip_ava.q  = 0
    ip_count.q  = 0    
    
    Repeat
      Event.l = WaitWindowEvent()
      Select  Event
        Case  #PB_Event_Timer
          Select  EventTimer()
            Case  0
              SEvent = NetworkServerEvent() 
              If SEvent 
                ClientID = EventClient()
                ClientIP$ = IPString(GetClientIP(ClientID))
                aa  = 1;unique
                Select SEvent 
                  Case 2
                    ForEach server_list()   
                      If  ClientIP$ = server_list()
                        aa  = 0
                        Break
                      Else
                        aa  = 1
                      EndIf
                    Next
                    If  aa =  1
                      AddElement(server_list())
                      server_list() = ClientIP$
                      AddGadgetItem(server_list, -1, ClientIP$, pc_icon)
                    Else
                      ;
                    EndIf
                    ;ReceiveNetworkData(ClientID, Buffer, 1000) 
                    ;Debug PeekS(Buffer, -1, #PB_Ascii)
                EndSelect 
              EndIf
            Case  1
              ClearGadgetItems(server_list)
              ClearList(server_list())
          EndSelect
        Case  #PB_Event_Gadget
          Select  EventGadget()
            Case  ok_bg ;点击按钮
              ExamineIPAddresses()
              ip_ava = NextIPAddress()
              ip_count = 0
              While(ip_ava)
                ip_count  + 1
                If  IPAddressField(ip_ava, 0) = IPAddressField(GetGadgetState(ip_ga), 0) And  IPAddressField(ip_ava, 1) = IPAddressField(GetGadgetState(ip_ga), 1) And  IPAddressField(ip_ava, 2) = IPAddressField(GetGadgetState(ip_ga), 2)
                  ip_ava  = NextIPAddress()
                  Continue
                Else
                  MessageBox_(GetFocus_(), "check local ip: " + IPString(ip_ava), "cv@ip" + Str(ip_count), #MB_OK|#MB_ICONEXCLAMATION|#MB_SYSTEMMODAL)
                EndIf                    
                ip_ava  = NextIPAddress()                    
              Wend              
              result  = MessageBox_(GetFocus_(), "continue to use " + IPString(GetGadgetState(ip_ga)) + "?", "cv", #MB_YESNO|#MB_ICONQUESTION|#MB_SYSTEMMODAL|#MB_DEFBUTTON2)
              Select  result
                Case  #IDYES
                  quit  = #True
                Case  #IDNO
                  ;
              EndSelect
            Case  server_list
              Select EventType()
                Case #PB_EventType_LeftClick
                  If GetGadgetState(server_list) <> -1 
                    bbbb.s  = GetGadgetItemText(server_list, GetGadgetState(server_list))
                    SetGadgetState(ip_ga, MakeIPAddress(Val(StringField(bbbb, 1, ".")), Val(StringField(bbbb, 2, ".")), Val(StringField(bbbb, 3, ".")), Val(StringField(bbbb, 4, "."))))   
                  EndIf               
                Case #PB_EventType_RightClick
                  ;
                Case #PB_EventType_LeftDoubleClick
                  If GetGadgetState(server_list) <> -1 
                    bbbb.s  = GetGadgetItemText(server_list, GetGadgetState(server_list))
                    SetGadgetState(ip_ga, MakeIPAddress(Val(StringField(bbbb, 1, ".")), Val(StringField(bbbb, 2, ".")), Val(StringField(bbbb, 3, ".")), Val(StringField(bbbb, 4, "."))))   
                  EndIf
                  ExamineIPAddresses()
                  ip_ava = NextIPAddress()
                  ip_count = 0
                  While(ip_ava)
                    ip_count  + 1
                    If  IPAddressField(ip_ava, 0) = IPAddressField(GetGadgetState(ip_ga), 0) And  IPAddressField(ip_ava, 1) = IPAddressField(GetGadgetState(ip_ga), 1) And  IPAddressField(ip_ava, 2) = IPAddressField(GetGadgetState(ip_ga), 2)
                      ip_ava  = NextIPAddress()
                      Continue
                    Else
                      MessageBox_(GetFocus_(), "check local ip: " + IPString(ip_ava), "cv@ip" + Str(ip_count), #MB_OK|#MB_ICONEXCLAMATION|#MB_SYSTEMMODAL)
                    EndIf                    
                    ip_ava  = NextIPAddress()                    
                  Wend                  
                  result  = MessageBox_(GetFocus_(), "continue to use " + IPString(GetGadgetState(ip_ga)) + "?", "cv", #MB_YESNO|#MB_ICONQUESTION|#MB_SYSTEMMODAL|#MB_DEFBUTTON2)
                  Select  result
                    Case  #IDYES
                      quit  = #True
                    Case  #IDNO
                      ;
                  EndSelect
                Case #PB_EventType_RightDoubleClick
                  ;
                Case  #PB_EventType_Change
                  ;                  
              EndSelect
          EndSelect
        Case  #PB_Event_Menu
          Select EventMenu()
            Case  0 ;escape
              CloseWindow(hwnd)
              FreeList(server_list())
              ProcedureReturn #False
            Case  3 ;回车
              ExamineIPAddresses()
              ip_ava = NextIPAddress()
              ip_count = 0
              While(ip_ava)
                ip_count  + 1
                If  IPAddressField(ip_ava, 0) = IPAddressField(GetGadgetState(ip_ga), 0) And  IPAddressField(ip_ava, 1) = IPAddressField(GetGadgetState(ip_ga), 1) And  IPAddressField(ip_ava, 2) = IPAddressField(GetGadgetState(ip_ga), 2)
                  ip_ava  = NextIPAddress()
                  Continue
                Else
                  MessageBox_(GetFocus_(), "check local ip: " + IPString(ip_ava), "cv@ip" + Str(ip_count), #MB_OK|#MB_ICONEXCLAMATION|#MB_SYSTEMMODAL)
                EndIf                    
                ip_ava  = NextIPAddress()                    
              Wend                                
              result  = MessageBox_(GetFocus_(), "continue to use " + IPString(GetGadgetState(ip_ga)) + "?", "cv", #MB_YESNO|#MB_ICONQUESTION|#MB_SYSTEMMODAL|#MB_DEFBUTTON2)
              Select  result
                Case  #IDYES
                  quit  = #True
                Case  #IDNO
                  ;
              EndSelect
          EndSelect 
        Case  #PB_Event_CloseWindow
          CloseWindow(hwnd)
          FreeList(server_list())
          ProcedureReturn #False
      EndSelect
    Until quit  = #True
    
    PokeL(*ip_num, GetGadgetState(ip_ga))
    
    CloseNetworkServer(server_udp)
    
;     id  = OpenNetworkConnection(IPString(GetGadgetState(ip_ga)), 6888, #PB_Network_TCP)
;     If  id  <>  0 
;       Delay(100)
;       CloseNetworkConnection(id)
;     EndIf
    
    CloseWindow(hwnd) 
    FreeList(server_list())
    ProcedureReturn #True
    
  EndProcedure  
  
  ProcedureDLL.l  select_visa_device(*resource, mode.l=0) ;支持显示所有的visa32资源
    ;  
    visa_pci_icon_big  = 0
    visa_pci_icon_small = 0
    ExtractIconEx_("cv_icons.dll", 10, @visa_pci_icon_big, @visa_pci_icon_small, 1) 
  
    hwnd  = OpenWindow(#PB_Any, 0, 0, 450, 85, "Pick a NI-VISA Resource", #PB_Window_MinimizeGadget|#PB_Window_ScreenCentered|#PB_Window_SystemMenu)
    SendMessage_(WindowID(hwnd), #WM_SETICON, #ICON_SMALL, visa_pci_icon_small)    
    card_cb = ComboBoxGadget(#PB_Any , 10, 15, 430, 20, #PB_ComboBox_Image)
    SendMessage_(GadgetID(card_cb), #CB_SETDROPPEDWIDTH, 600, 0)
    GadgetToolTip(card_cb, "Select a Resource")   
    SmartWindowRefresh(hwnd, 1)
    StickyWindow(hwnd, #True)
       If OSVersion < #PB_OS_Windows_7
     ;
   Else
     SkinH_SetAero(WindowID(hwnd))
   EndIf
    visa_default  = 0
    viOpenDefaultRM(@visa_default)
        
    numInstrs = 0
    findList  = 0
    descriptor.s{256}  = Space(256)
    
    If  0 = mode
      pattern_res.s  = "?*INSTR"
    Else
      pattern_res = "?*"
    EndIf
    
    result  = viFindRsrc(visa_default, @pattern_res, @findList, @numInstrs, @descriptor)  
    retry_time.l  = 1
    
    While  result  = #VI_ERROR_RSRC_NFOUND
      result  = viFindRsrc(visa_default, @pattern_res, @findList, @numInstrs, @descriptor)
      Delay(100)
      retry_time  + 1
      If  5 = retry_time
        Break
      EndIf
    Wend     
    
    Select  result
      Case  #VI_ERROR_RSRC_NFOUND
        MessageBox_(WindowID(hwnd), "-=cv=- 2012.12" + Chr(13) + Chr(10) + "no visa32 resource found at host", "..cv.. " + Str(retry_time), #MB_OK | #MB_ICONERROR|#MB_SYSTEMMODAL)
      Case  #VI_ERROR_MACHINE_NAVAIL
        MessageBox_(WindowID(hwnd), "-=cv=- 2012.12" + Chr(13) + Chr(10) + "host is not ready!", "..cv..", #MB_OK | #MB_ICONERROR|#MB_SYSTEMMODAL)
      Default
        ;       
    EndSelect
           
    Select  numInstrs
      Case  0
        ;
      Default       
        AddGadgetItem(card_cb, -1, descriptor, visa_pci_icon_small, 1)        
        numInstrs - 1
        While(numInstrs)
          viFindNext(findList, @descriptor)
          AddGadgetItem(card_cb, -1, descriptor, visa_pci_icon_small, 1)
          numInstrs - 1
        Wend 
        viClose(findList)
    EndSelect
    
    SetGadgetState(card_cb, 0)
    
    ok_bg = ButtonGadget(#PB_Any, 195, 50, 65, 25, "OK", #PB_Button_Default)  
    GadgetToolTip(ok_bg, "下一步")
    
    alias_bg  = ButtonGadget(#PB_Any, 50, 50, 40, 25, "ALIAS", #PB_Button_Toggle)
    GadgetToolTip(alias_bg, "按别名显示")
    
    AddKeyboardShortcut(hwnd, #PB_Shortcut_Return, 0) 
    AddKeyboardShortcut(hwnd, #PB_Shortcut_Escape, 1)    
    
    menu1 = CreatePopupMenu(#PB_Any)
    If menu1
      MenuItem(2, "Add NI-VISA Server")
      MenuItem(3, "COPY")
      MenuItem(4, "Clear and Refresh")
    EndIf    
    
    find_mode.l  = 0
        
    Repeat
      Event.l = WaitWindowEvent()
      Select  Event
        Case  #WM_RBUTTONDOWN       
          DisplayPopupMenu(menu1, WindowID(hwnd))      
        Case  #PB_Event_Gadget
          Select  EventGadget()
            Case  ok_bg
              quit  = #True
            Case  card_cb
              ;
            Case  alias_bg
              viGetAttribute(visa_default, #VI_ATTR_FIND_RSRC_MODE, @find_mode)
              If  $8008 = find_mode
                viSetAttribute(visa_default, #VI_ATTR_FIND_RSRC_MODE, $800A)
              Else
                viSetAttribute(visa_default, #VI_ATTR_FIND_RSRC_MODE, $8008)
              EndIf
          EndSelect
        Case  #PB_Event_Menu
          Select EventMenu()
            Case  0
              quit  = #True
            Case  1
              CloseWindow(hwnd) 
              viClose(visa_default)
              ProcedureReturn #False
            Case  2
              ip_num.q  = Val(ReadRegKey(#HKEY_LOCAL_MACHINE, "Software\cv\visa32_pb_wrapper", "ip1"))
              DisableWindow(hwnd, 1)
              result  = get_visa_server_ip(@ip_num)
              DisableWindow(hwnd, 0)
              SetWindowPos_(WindowID(hwnd), #HWND_TOP, 0, 0, 0, 0, #SWP_NOMOVE|#SWP_NOSIZE)
              ip_address.s =  IPString(ip_num)
              If  result
                numInstrs = 0
                findList = 0
                descriptor = Space(256)
                          
                If  0 = mode
                  resource.s  = "visa://" + ip_address + "/?*INSTR"
                Else
                  resource  = "visa://" + ip_address + "/?*"
                EndIf                
                
                result  = viFindRsrc(visa_default, @resource, @findList, @numInstrs, @descriptor)
                retry_time  = 1
                
                While  result  = #VI_ERROR_RSRC_NFOUND
                  result  = viFindRsrc(visa_default, @resource, @findList, @numInstrs, @descriptor)
                  Delay(100)
                  retry_time  + 1
                  If  15 = retry_time
                    Break
                  EndIf
                Wend
                  
                Select  result
                  Case  #VI_ERROR_RSRC_NFOUND
                    MessageBox_(WindowID(hwnd), "-=cv=- 2012.12" + Chr(13) + Chr(10) + "no visa32 resource found at " + ip_address, "..cv.. " + Str(retry_time), #MB_OK | #MB_ICONERROR|#MB_SYSTEMMODAL)
                  Case  #VI_ERROR_MACHINE_NAVAIL
                    MessageBox_(WindowID(hwnd), "-=cv=- 2012.12" + Chr(13) + Chr(10) + "visa server at " + ip_address + " is Not ready!", "..cv..", #MB_OK | #MB_ICONERROR|#MB_SYSTEMMODAL)
                  Default
                    ;       
                EndSelect                
                
                Select  numInstrs
                  Case  0
                    ;
                  Default                 
                    AddGadgetItem(card_cb, -1, descriptor, visa_pci_icon_small, 1)                            
                    numInstrs - 1
                    While(numInstrs)
                      viFindNext(findList, @descriptor)
                      AddGadgetItem(card_cb, -1, descriptor, visa_pci_icon_small, 1)
                      numInstrs - 1
                    Wend
                    viClose(findList)
                EndSelect 
                SetGadgetState(card_cb, 0)
                WriteRegKey(#HKEY_LOCAL_MACHINE, "Software\cv\visa32_pb_wrapper", "ip1", Str(ip_num))
              Else
                ;
              EndIf
            Case  3
              SetClipboardText(GetGadgetText(card_cb))
            Case  4 ;clear and refresh host
              ClearGadgetItems(card_cb)
              
              If  0 = mode
                pattern_res = "?*INSTR"
              Else
                pattern_res = "?*"
              EndIf              
              
              result  = viFindRsrc(visa_default, @pattern_res, @findList, @numInstrs, @descriptor)  
              retry_time = 1
              
              While  result  = #VI_ERROR_RSRC_NFOUND
                result  = viFindRsrc(visa_default, @pattern_res, @findList, @numInstrs, @descriptor)
                Delay(100)
                retry_time  + 1
                If  5 = retry_time
                  Break
                EndIf
              Wend     
              
              Select  result
                Case  #VI_ERROR_RSRC_NFOUND
                  MessageBox_(WindowID(hwnd), "-=cv=- 2012.12" + Chr(13) + Chr(10) + "no visa32 resource found at host", "..cv.. " + Str(retry_time), #MB_OK | #MB_ICONERROR|#MB_SYSTEMMODAL)
                Case  #VI_ERROR_MACHINE_NAVAIL
                  MessageBox_(WindowID(hwnd), "-=cv=- 2012.12" + Chr(13) + Chr(10) + "host is not ready!", "..cv..", #MB_OK | #MB_ICONERROR|#MB_SYSTEMMODAL)
                Default
                  ;       
              EndSelect
                               
              Select  numInstrs
                Case  0
                  ;
                Default       
                  AddGadgetItem(card_cb, -1, descriptor, visa_pci_icon_small, 1)        
                  numInstrs - 1
                  While(numInstrs)
                    viFindNext(findList, @descriptor)
                    AddGadgetItem(card_cb, -1, descriptor, visa_pci_icon_small, 1)
                    numInstrs - 1
                  Wend 
                  viClose(findList)
              EndSelect
              
              SetGadgetState(card_cb, 0)
          EndSelect
        Case  #PB_Event_CloseWindow
          CloseWindow(hwnd)
          viClose(visa_default)
          ProcedureReturn #False
      EndSelect
    Until quit  = #True
       
    PokeS(*resource, GetGadgetText(card_cb), -1, #PB_Ascii)
    CloseWindow(hwnd)
    
    result  = viOpen(visa_default, *resource, #VI_NO_LOCK, 1000, @card_res)  
    viClose(card_res)
    viClose(visa_default)    
    
    If  result  <>  #VI_SUCCESS
      ProcedureReturn #False
    Else
      ProcedureReturn #True
    EndIf

  EndProcedure
  
  ProcedureDLL.l  select_visa_serialport(*resource) ;支持显示所有的visa32 串口资源
    ;  
    visa_serial_icon_big  = 0
    visa_serial_icon_small = 0
    ExtractIconEx_("cv_icons.dll", 79, @visa_serial_icon_big, @visa_serial_icon_small, 1) 
  
    hwnd  = OpenWindow(#PB_Any, 0, 0, 450, 85, "Pick a NI-VISA Serial Resource", #PB_Window_MinimizeGadget|#PB_Window_ScreenCentered|#PB_Window_SystemMenu)
    SendMessage_(WindowID(hwnd), #WM_SETICON, #ICON_SMALL, visa_serial_icon_small)    
    card_cb = ComboBoxGadget(#PB_Any , 10, 15, 430, 20, #PB_ComboBox_Image)
    SendMessage_(GadgetID(card_cb), #CB_SETDROPPEDWIDTH, 500, 0)
    GadgetToolTip(card_cb, "Select a Resource")   
    SmartWindowRefresh(hwnd, 1)
    StickyWindow(hwnd, #True)
       If OSVersion < #PB_OS_Windows_7
     ;
   Else
     SkinH_SetAero(WindowID(hwnd))
   EndIf
    visa_default  = 0
    viOpenDefaultRM(@visa_default)
        
    numInstrs = 0
    findList  = 0
    descriptor.s{256}  = Space(256)
    pattern_res.s  = "?*(ASRL)?*INSTR"
    
    viSetAttribute(visa_default, #VI_ATTR_FIND_RSRC_MODE, $800A);使用别名找
    result  = viFindRsrc(visa_default, @pattern_res, @findList, @numInstrs, @descriptor)  
    retry_time.l  = 1
    
    While  result  = #VI_ERROR_RSRC_NFOUND
      result  = viFindRsrc(visa_default, @pattern_res, @findList, @numInstrs, @descriptor)
      Delay(100)
      retry_time  + 1
      If  5 = retry_time
        Break
      EndIf
    Wend     
    
    Select  result
      Case  #VI_ERROR_RSRC_NFOUND
        MessageBox_(WindowID(hwnd), "-=cv=- 2012.12" + Chr(13) + Chr(10) + "no visa32 serial port resource found at host", "..cv.. " + Str(retry_time), #MB_OK | #MB_ICONERROR|#MB_SYSTEMMODAL)
      Case  #VI_ERROR_MACHINE_NAVAIL
        MessageBox_(WindowID(hwnd), "-=cv=- 2012.12" + Chr(13) + Chr(10) + "host is not ready!", "..cv..", #MB_OK | #MB_ICONERROR|#MB_SYSTEMMODAL)
      Default
        ;       
    EndSelect
           
    Select  numInstrs
      Case  0
        ;
      Default       
        AddGadgetItem(card_cb, -1, descriptor, visa_serial_icon_small, 1)        
        numInstrs - 1
        While(numInstrs)
          viFindNext(findList, @descriptor)
          AddGadgetItem(card_cb, -1, descriptor, visa_serial_icon_small, 1)
          numInstrs - 1
        Wend 
        viClose(findList)
    EndSelect
    
    SetGadgetState(card_cb, 0)
    
    ok_bg = ButtonGadget(#PB_Any, 195, 50, 65, 25, "OK", #PB_Button_Default)  
    GadgetToolTip(ok_bg, "下一步")
    
    alias_bg  = ButtonGadget(#PB_Any, 50, 50, 40, 25, "ALIAS", #PB_Button_Toggle)
    GadgetToolTip(alias_bg, "按别名显示")
    SetGadgetState(alias_bg, #True)
    
    AddKeyboardShortcut(hwnd, #PB_Shortcut_Return, 0) 
    AddKeyboardShortcut(hwnd, #PB_Shortcut_Escape, 1)    
    
    menu1 = CreatePopupMenu(#PB_Any)
    If menu1
      MenuItem(2, "Add NI-VISA Server")
      MenuItem(3, "COPY")
      MenuItem(4, "Clear and Refresh")
    EndIf    
    
    find_mode.l = 0
    
    Repeat
      Event.l = WaitWindowEvent()
      Select  Event
        Case  #WM_RBUTTONDOWN       
          DisplayPopupMenu(menu1, WindowID(hwnd))      
        Case  #PB_Event_Gadget
          Select  EventGadget()
            Case  ok_bg
              quit  = #True
            Case  card_cb
              ;
            Case  alias_bg
              viGetAttribute(visa_default, #VI_ATTR_FIND_RSRC_MODE, @find_mode)
              If  $8008 = find_mode
                viSetAttribute(visa_default, #VI_ATTR_FIND_RSRC_MODE, $800A)
              Else
                viSetAttribute(visa_default, #VI_ATTR_FIND_RSRC_MODE, $8008)
              EndIf              
          EndSelect
        Case  #PB_Event_Menu
          Select EventMenu()
            Case  0
              quit  = #True
            Case  1
              CloseWindow(hwnd) 
              viClose(visa_default)
              ProcedureReturn #False
            Case  2
              ip_num.q  = Val(ReadRegKey(#HKEY_LOCAL_MACHINE, "Software\cv\visa32_pb_wrapper", "ip1"))
              DisableWindow(hwnd, 1)
              result  = get_visa_server_ip(@ip_num)
              DisableWindow(hwnd, 0)
              SetWindowPos_(WindowID(hwnd), #HWND_TOP, 0, 0, 0, 0, #SWP_NOMOVE|#SWP_NOSIZE)
              ip_address.s =  IPString(ip_num)
              If  result
                numInstrs = 0
                findList = 0
                descriptor = Space(256)
                resource.s  = "visa://" + ip_address + "/?*(ASRL)?*INSTR"             
                
                result  = viFindRsrc(visa_default, @resource, @findList, @numInstrs, @descriptor)
                retry_time  = 1
                
                While  result  = #VI_ERROR_RSRC_NFOUND
                  result  = viFindRsrc(visa_default, @resource, @findList, @numInstrs, @descriptor)
                  Delay(100)
                  retry_time  + 1
                  If  15 = retry_time
                    Break
                  EndIf
                Wend
                  
                Select  result
                  Case  #VI_ERROR_RSRC_NFOUND
                    MessageBox_(WindowID(hwnd), "-=cv=- 2012.12" + Chr(13) + Chr(10) + "no visa32 serial port resource found at " + ip_address, "..cv.. " + Str(retry_time), #MB_OK | #MB_ICONERROR|#MB_SYSTEMMODAL)
                  Case  #VI_ERROR_MACHINE_NAVAIL
                    MessageBox_(WindowID(hwnd), "-=cv=- 2012.12" + Chr(13) + Chr(10) + "visa server at " + ip_address + " is Not ready!", "..cv..", #MB_OK | #MB_ICONERROR|#MB_SYSTEMMODAL)
                  Default
                    ;       
                EndSelect                
                
                Select  numInstrs
                  Case  0
                    ;
                  Default                 
                    AddGadgetItem(card_cb, -1, descriptor, visa_serial_icon_small, 1)                            
                    numInstrs - 1
                    While(numInstrs)
                      viFindNext(findList, @descriptor)
                      AddGadgetItem(card_cb, -1, descriptor, visa_serial_icon_small, 1)
                      numInstrs - 1
                    Wend 
                    viClose(findList)
                EndSelect 
                SetGadgetState(card_cb, 0)
                WriteRegKey(#HKEY_LOCAL_MACHINE, "Software\cv\visa32_pb_wrapper", "ip1", Str(ip_num))
              Else
                ;
              EndIf
            Case  3
              SetClipboardText(GetGadgetText(card_cb))
            Case  4 ;clear and refresh host
              ClearGadgetItems(card_cb)
              result  = viFindRsrc(visa_default, @"?*(ASRL)?*INSTR", @findList, @numInstrs, @descriptor)  
              retry_time = 1
              
              While  result  = #VI_ERROR_RSRC_NFOUND
                result  = viFindRsrc(visa_default, @pattern_res, @findList, @numInstrs, @descriptor)
                Delay(100)
                retry_time  + 1
                If  5 = retry_time
                  Break
                EndIf
              Wend     
              
              Select  result
                Case  #VI_ERROR_RSRC_NFOUND
                  MessageBox_(WindowID(hwnd), "-=cv=- 2012.12" + Chr(13) + Chr(10) + "no visa32 serial port resource found at host", "..cv.. " + Str(retry_time), #MB_OK | #MB_ICONERROR|#MB_SYSTEMMODAL)
                Case  #VI_ERROR_MACHINE_NAVAIL
                  MessageBox_(WindowID(hwnd), "-=cv=- 2012.12" + Chr(13) + Chr(10) + "host is not ready!", "..cv..", #MB_OK | #MB_ICONERROR|#MB_SYSTEMMODAL)
                Default
                  ;       
              EndSelect
                               
              Select  numInstrs
                Case  0
                  ;
                Default       
                  AddGadgetItem(card_cb, -1, descriptor, visa_serial_icon_small, 1)        
                  numInstrs - 1
                  While(numInstrs)
                    viFindNext(findList, @descriptor)
                    AddGadgetItem(card_cb, -1, descriptor, visa_serial_icon_small, 1)
                    numInstrs - 1
                  Wend 
                  viClose(findList)
              EndSelect
              
              SetGadgetState(card_cb, 0)
          EndSelect
        Case  #PB_Event_CloseWindow
          CloseWindow(hwnd)
          viClose(visa_default)
          ProcedureReturn #False
      EndSelect
    Until quit  = #True
       
    PokeS(*resource, GetGadgetText(card_cb), -1, #PB_Ascii)    
    result  = viOpen(visa_default, *resource, #VI_NO_LOCK, 1000, @card_res)  
    viClose(card_res)
    viClose(visa_default)    
    
    If  result  <>  #VI_SUCCESS
      If  #VI_ERROR_RSRC_BUSY = result
        MessageBox_(GetFocus_(), GetGadgetText(card_cb) + ">>The resource is valid, but VISA cannot currently access it.", "cv", #MB_ICONERROR|#MB_SYSTEMMODAL)
        CloseWindow(hwnd)
      EndIf
      ProcedureReturn #False
    Else
      CloseWindow(hwnd)
      ProcedureReturn #True
    EndIf    
  EndProcedure  

  ProcedureDLL.l select_visa_pci_pxi_card(*resource, vid.w=0, did.w=0)  ;vid  ==  0x10b5;did为subsystemid，在EPPROM里定义，如6888, 9054;
  
    card1  = 0
    ExtractIconEx_("cv_icons.dll", 4, #Null, @card1, 1)
      
    hwnd  = OpenWindow(#PB_Any, 0, 0, 450, 85, "Pick a PXI/PCI NI-VISA Card", #PB_Window_MinimizeGadget|#PB_Window_ScreenCentered|#PB_Window_SystemMenu)
    SendMessage_(WindowID(hwnd), #WM_SETICON, #ICON_SMALL, card1)    
    card_cb = ComboBoxGadget(#PB_Any , 10, 15, 430, 20, #PB_ComboBox_Image)
    SendMessage_(GadgetID(card_cb), #CB_SETDROPPEDWIDTH, 600, 0)
    GadgetToolTip(card_cb, "Select a Card")   
    SmartWindowRefresh(hwnd, 1) 
    StickyWindow(hwnd, #True)
       If OSVersion < #PB_OS_Windows_7
     ;
   Else
     SkinH_SetAero(WindowID(hwnd))
   EndIf
    visa_default  = 0
    viOpenDefaultRM(@visa_default)
        
    numInstrs = 0
    findList  = 0
    descriptor.s  = Space(256)
    
    vid_string.s  = "0x" + RSet(Hex(vid, #PB_Word), 4, "0")
    did_string.s  = "0x" + RSet(Hex(did, #PB_Word), 4, "0")
    
    If  0 <> vid
      SetWindowTitle(hwnd, GetWindowTitle(hwnd) + " - " + vid_string + " - " + did_string)
    EndIf
    
    Select vid
      Case  0
        pattern_res.s  = "?*(PXI)?*INSTR"
      Default
        pattern_res = "?*(PXI)?*INSTR{VI_ATTR_MANF_ID==" + vid_string + " && VI_ATTR_MODEL_CODE==" + did_string + "}"    
    EndSelect
    
    result  = viFindRsrc(visa_default, @pattern_res, @findList, @numInstrs, @descriptor)  
    retry_time.l  = 1
    
    While  result  = #VI_ERROR_RSRC_NFOUND
      result  = viFindRsrc(visa_default, @pattern_res, @findList, @numInstrs, @descriptor)
      Delay(100)
      retry_time  = retry_time  + 1
      If  3 = retry_time
        Break
      EndIf
    Wend     
    
    Select  result
      Case  #VI_ERROR_RSRC_NFOUND
        MessageBox_(WindowID(hwnd), "-=cv=- 2012.7" + Chr(13) + Chr(10) + "no visa32@pxi/pci/cpci card found at host", "..cv.. " + Str(retry_time), #MB_OK | #MB_ICONERROR|#MB_SYSTEMMODAL)
      Case  #VI_ERROR_MACHINE_NAVAIL
        MessageBox_(WindowID(hwnd), "-=cv=- 2012.7" + Chr(13) + Chr(10) + "host is not ready!", "..cv..", #MB_OK | #MB_ICONERROR|#MB_SYSTEMMODAL)
      Default
        ;       
    EndSelect
    
    card_res  = 0
    slot_id = 0
    model_name.s  = Space(1024)
    model_code  = 0
    
    Select  numInstrs
      Case  0
        ;
      Default
        viOpen(visa_default, @descriptor, #VI_NO_LOCK, 1000, @card_res)        
        viGetAttribute(card_res, #VI_ATTR_SLOT, @slot_id)    
        viGetAttribute(card_res, #VI_ATTR_MODEL_NAME, @model_name)
        viGetAttribute(card_res, #VI_ATTR_MODEL_CODE, @model_code)        
        AddGadgetItem(card_cb, -1, descriptor + "@Slot" + Str(slot_id) + "@" + model_name + "@" + RSet(Hex(model_code, #PB_Word), 4, "0"), card1, 1)        
        numInstrs = numInstrs - 1
        viClose(card_res)
        While(numInstrs)
          viFindNext(findList, @descriptor)
          viOpen(visa_default, @descriptor, #VI_NO_LOCK, 1000, @card_res)
          viGetAttribute(card_res, #VI_ATTR_SLOT, @slot_id) 
          viGetAttribute(card_res, #VI_ATTR_MODEL_NAME, @model_name)
          viGetAttribute(card_res, #VI_ATTR_MODEL_CODE, @model_code)
          AddGadgetItem(card_cb, -1, descriptor + "@Slot" + Str(slot_id) + "@" + model_name + "@" + RSet(Hex(model_code, #PB_Word), 4, "0"), card1, 1)
          numInstrs = numInstrs - 1
          viClose(card_res)
        Wend 
        viClose(findList)
    EndSelect
    
    SetGadgetState(card_cb, 0)
    
    ok_bg = ButtonGadget(#PB_Any, 195, 50, 65, 25, "OK", #PB_Button_Default)  
    GadgetToolTip(ok_bg, "下一步")
    
    alias_bg  = ButtonGadget(#PB_Any, 50, 50, 40, 25, "ALIAS", #PB_Button_Toggle)
    GadgetToolTip(alias_bg, "按别名显示")    
    
    AddKeyboardShortcut(hwnd, #PB_Shortcut_Return, 0) 
    AddKeyboardShortcut(hwnd, #PB_Shortcut_Escape, 1)    
    
    menu1 = CreatePopupMenu(#PB_Any)
    If menu1
      MenuItem(2, "Add NI-VISA Server")
      MenuItem(3, "COPY")
    EndIf    
        
    find_mode.l = 0
    
    Repeat
      Event.l = WaitWindowEvent()
      Select  Event
        Case  #WM_RBUTTONDOWN       
          DisplayPopupMenu(menu1, WindowID(hwnd))      
        Case  #PB_Event_Gadget
          Select  EventGadget()
            Case  ok_bg
              quit  = #True
            Case  card_cb
              ;
            Case  alias_bg
              viGetAttribute(visa_default, #VI_ATTR_FIND_RSRC_MODE, @find_mode)
              If  $8008 = find_mode
                viSetAttribute(visa_default, #VI_ATTR_FIND_RSRC_MODE, $800A)
              Else
                viSetAttribute(visa_default, #VI_ATTR_FIND_RSRC_MODE, $8008)
              EndIf              
          EndSelect
        Case  #PB_Event_Menu
          Select EventMenu()
            Case  0
              quit  = #True
            Case  1
              CloseWindow(hwnd) 
              viClose(visa_default)
              ProcedureReturn #False
            Case  2
              ip_num.q  = Val(ReadRegKey(#HKEY_LOCAL_MACHINE, "Software\cv\visa32_pb_wrapper", "ip1"))
              DisableWindow(hwnd, 1)
              result  = get_visa_server_ip(@ip_num)
              DisableWindow(hwnd, 0)
              SetWindowPos_(WindowID(hwnd), #HWND_TOP, 0, 0, 0, 0, #SWP_NOMOVE|#SWP_NOSIZE)
              ip_address.s =  IPString(ip_num)
              If  result
                numInstrs = 0
                findList  = 0
                descriptor.s  = Space(256)
                
                Select vid
                  Case  0
                    resource.s  = "visa://" + ip_address + "/?*(PXI)?*INSTR"
                  Default
                    pattern_res = "/?*(PXI)?*INSTR{VI_ATTR_MANF_ID==" + vid_string + " && VI_ATTR_MODEL_CODE==" + did_string + "}"                    
                    resource  = "visa://" + ip_address + pattern_res
                EndSelect                
                
                result  = viFindRsrc(visa_default, @resource, @findList, @numInstrs, @descriptor)
                retry_time  = 1
                
                While  result  = #VI_ERROR_RSRC_NFOUND
                  result  = viFindRsrc(visa_default, @resource, @findList, @numInstrs, @descriptor)
                  Delay(100)
                  retry_time  = retry_time  + 1
                  If  15 = retry_time
                    Break
                  EndIf
                Wend
                  
                Select  result
                  Case  #VI_ERROR_RSRC_NFOUND
                    MessageBox_(WindowID(hwnd), "-=cv=- 2012.7" + Chr(13) + Chr(10) + "no visa32@pxi/pci/cpci card found at " + ip_address, "..cv.. " + Str(retry_time), #MB_OK | #MB_ICONERROR|#MB_SYSTEMMODAL)
                  Case  #VI_ERROR_MACHINE_NAVAIL
                    MessageBox_(WindowID(hwnd), "-=cv=- 2012.7" + Chr(13) + Chr(10) + "visa server at " + ip_address + " is Not ready!", "..cv..", #MB_OK | #MB_ICONERROR|#MB_SYSTEMMODAL)
                  Default
                    ;       
                EndSelect                
                
                Select  numInstrs
                  Case  0
                    ;
                  Default
                    viOpen(visa_default, @descriptor, #VI_NO_LOCK, 1000, @card_res)
                    viGetAttribute(card_res, #VI_ATTR_SLOT, @slot_id)    
                    viGetAttribute(card_res, #VI_ATTR_MODEL_NAME, @model_name)
                    viGetAttribute(card_res, #VI_ATTR_MODEL_CODE, @model_code)                    
                    AddGadgetItem(card_cb, -1, descriptor + "@Slot" + Str(slot_id) + "@" + model_name + "@" + RSet(Hex(model_code, #PB_Word), 4, "0"), card1, 1)                            
                    numInstrs = numInstrs - 1
                    viClose(card_res)
                    While(numInstrs)
                      viFindNext(findList, @descriptor)
                      viOpen(visa_default, @descriptor, #VI_NO_LOCK, 1000, @card_res)
                      viGetAttribute(card_res, #VI_ATTR_SLOT, @slot_id)    
                      viGetAttribute(card_res, #VI_ATTR_MODEL_NAME, @model_name)
                      viGetAttribute(card_res, #VI_ATTR_MODEL_CODE, @model_code)
                      AddGadgetItem(card_cb, -1, descriptor + "@Slot" + Str(slot_id) + "@" + model_name + "@" + RSet(Hex(model_code, #PB_Word), 4, "0"), card1, 1)
                      numInstrs = numInstrs - 1
                      viClose(card_res)
                    Wend 
                    viClose(findList)
                EndSelect 
                SetGadgetState(card_cb, 0)
                WriteRegKey(#HKEY_LOCAL_MACHINE, "Software\cv\visa32_pb_wrapper", "ip1", Str(ip_num))
              Else
                ;
              EndIf
            Case  3
              SetClipboardText(StringField(GetGadgetText(card_cb), 1, "@"))
          EndSelect
        Case  #PB_Event_CloseWindow
          CloseWindow(hwnd)
          viClose(visa_default)
          ProcedureReturn #False
      EndSelect
    Until quit  = #True
       
    PokeS(*resource, StringField(GetGadgetText(card_cb), 1, "@"), -1, #PB_Ascii)
    
    CloseWindow(hwnd) 
    
    result  = viOpen(visa_default, *resource, #VI_NO_LOCK, 1000, @card_res)  
    viClose(card_res)
    viClose(visa_default)    
    
    If  result  <>  #VI_SUCCESS
      ProcedureReturn #False
    Else
      ProcedureReturn #True
    EndIf        
    
  EndProcedure
  
  ProcedureDLL.l select_visa_gpib_device(*resource)   ;;;;;;;gpib
  
    gpib1  = CatchImage(#PB_Any, ?gpib1)  
    tcpip1  = CatchImage(#PB_Any, ?tcpip1)  

  
    hwnd  = OpenWindow(#PB_Any, 0, 0, 200, 85, "Pick a GPIB Device", #PB_Window_ScreenCentered|#PB_Window_SystemMenu)
    SendMessage_(WindowID(hwnd), #WM_SETICON, #ICON_SMALL, ImageID(gpib1))    
    card_cb = ComboBoxGadget(#PB_Any , 10, 15, 180, 20, #PB_ComboBox_Image)
    SendMessage_(GadgetID(card_cb), #CB_SETDROPPEDWIDTH, 300, 0)
    SetGadgetText(card_cb, PeekS(*resource, -1, #PB_Ascii))
    GadgetToolTip(card_cb, "Select a Card")  
    SmartWindowRefresh(hwnd, 1)     
       If OSVersion < #PB_OS_Windows_7
     ;
   Else
     SkinH_SetAero(WindowID(hwnd))
   EndIf
    StickyWindow(hwnd, #True)    
    
    visa_default  = 0
    viOpenDefaultRM(@visa_default)
    numInstrs = 0
    findList  = 0
    descriptor.s  = Space(256)
    
    result  = viFindRsrc(visa_default, @"?*(GPIB)?*INSTR", @findList, @numInstrs, @descriptor)
    If  result  = #VI_ERROR_RSRC_NFOUND
      result  = viFindRsrc(visa_default, @"?*(GPIB)?*INSTR", @findList, @numInstrs, @descriptor)
    EndIf    
    
    Select  result
      Case  #VI_ERROR_RSRC_NFOUND
        MessageBox_(WindowID(hwnd), "-=cv=- 2012.7" + Chr(13) + Chr(10) + "no visa32@gpib device found at host", "..cv..", #MB_OK | #MB_ICONERROR|#MB_SYSTEMMODAL)
      Case  #VI_ERROR_MACHINE_NAVAIL
        MessageBox_(WindowID(hwnd), "-=cv=- 2012.7" + Chr(13) + Chr(10) + "host is not ready!", "..cv..", #MB_OK | #MB_ICONERROR|#MB_SYSTEMMODAL)
      Default
        ;       
    EndSelect    
    
    card_res  = 0
    
    Select  numInstrs
      Case  0
        ;
      Default
        viOpen(visa_default, @descriptor, #VI_NO_LOCK, 1000, @card_res)         
        AddGadgetItem(card_cb, -1, descriptor, ImageID(gpib1), 1)        
        numInstrs = numInstrs - 1
        viClose(card_res)
        While(numInstrs)
          viFindNext(findList, @descriptor)
          viOpen(visa_default, @descriptor, #VI_NO_LOCK, 1000, @card_res)
          AddGadgetItem(card_cb, -1, descriptor, ImageID(gpib1), 1)
          numInstrs = numInstrs - 1
          viClose(card_res)
        Wend      
        viClose(findList)
    EndSelect
    
    SetGadgetState(card_cb, 0)
    
    ok_bg = ButtonGadget(#PB_Any, 70, 50, 65, 25, "OK", #PB_Button_Default)  
    GadgetToolTip(ok_bg, "下一步")
    
    alias_bg  = ButtonGadget(#PB_Any, 15, 50, 40, 25, "ALIAS", #PB_Button_Toggle)
    GadgetToolTip(alias_bg, "按别名显示")    
    
    AddKeyboardShortcut(hwnd, #PB_Shortcut_Return, 0) 
    AddKeyboardShortcut(hwnd, #PB_Shortcut_Escape, 1)    
    
    menu1 = CreatePopupMenu(#PB_Any)
    If menu1
      MenuItem(2, "Add NI-VISA Server")
      MenuItem(3, "Add LXI-C Device")
      MenuItem(4, "COPY")
    EndIf    
    
    find_mode.l  = 0
    
    Repeat
      Event.l = WaitWindowEvent()
      Select  Event
        Case  #WM_RBUTTONDOWN       
          DisplayPopupMenu(menu1, WindowID(hwnd))      
        Case  #PB_Event_Gadget
          Select  EventGadget()
            Case  ok_bg
              quit  = #True
            Case  card_cb
              ;
            Case  alias_bg
              viGetAttribute(visa_default, #VI_ATTR_FIND_RSRC_MODE, @find_mode)
              If  $8008 = find_mode
                viSetAttribute(visa_default, #VI_ATTR_FIND_RSRC_MODE, $800A)
              Else
                viSetAttribute(visa_default, #VI_ATTR_FIND_RSRC_MODE, $8008)
              EndIf              
          EndSelect
        Case  #PB_Event_Menu
          Select EventMenu()
            Case  0
              quit  = #True
            Case  1
              FreeImage(gpib1)
              FreeMenu(menu1)
              CloseWindow(hwnd) 
              viClose(visa_default)
              ProcedureReturn #False
            Case  2
              ip_num.q  = Val(ReadRegKey(#HKEY_LOCAL_MACHINE, "Software\cv\visa32_pb_wrapper", "ip1"))
              DisableWindow(hwnd, 1)
              result  = get_visa_server_ip(@ip_num)
              DisableWindow(hwnd, 0)
              SetWindowPos_(WindowID(hwnd), #HWND_TOP, 0, 0, 0, 0, #SWP_NOMOVE|#SWP_NOSIZE)
              ip_address.s =  IPString(ip_num)
              If  result
                numInstrs = 0
                findList  = 0
                descriptor.s  = Space(256)
                
                resource.s  = "visa://" + ip_address + "/?*(GPIB)?*INSTR"               
                
                result  = viFindRsrc(visa_default, @resource, @findList, @numInstrs, @descriptor)
                If  result  = #VI_ERROR_RSRC_NFOUND
                  result  = viFindRsrc(visa_default, @resource, @findList, @numInstrs, @descriptor)
                EndIf                 
                
                Select  result
                  Case  #VI_ERROR_RSRC_NFOUND
                    MessageBox_(WindowID(hwnd), "-=cv=- 2012.7" + Chr(13) + Chr(10) + "no visa32@gpib device found at " + ip_address, "..cv..", #MB_OK | #MB_ICONERROR|#MB_SYSTEMMODAL)
                  Case  #VI_ERROR_MACHINE_NAVAIL
                    MessageBox_(WindowID(hwnd), "-=cv=- 2012.7" + Chr(13) + Chr(10) + "visa server at " + ip_address + " is Not ready!", "..cv..", #MB_OK | #MB_ICONERROR|#MB_SYSTEMMODAL)
                  Default
                    ;       
                EndSelect                  
                
                Select  numInstrs
                  Case  0
                    ;
                  Default
                    viOpen(visa_default, @descriptor, #VI_NO_LOCK, 1000, @card_res)                  
                    AddGadgetItem(card_cb, -1, descriptor, ImageID(gpib1), 1)                            
                    numInstrs = numInstrs - 1
                    viClose(card_res)
                    While(numInstrs)
                      viFindNext(findList, @descriptor)
                      viOpen(visa_default, @descriptor, #VI_NO_LOCK, 1000, @card_res)
                      AddGadgetItem(card_cb, -1, descriptor, ImageID(gpib1), 1)
                      numInstrs = numInstrs - 1
                      viClose(card_res)
                    Wend 
                    viClose(findList)
                EndSelect 
                SetGadgetState(card_cb, 0)
                WriteRegKey(#HKEY_LOCAL_MACHINE, "Software\cv\visa32_pb_wrapper", "ip1", Str(ip_num))
              Else
                ;
              EndIf
            Case  3   ;LXI
              ip_num  = Val(ReadRegKey(#HKEY_LOCAL_MACHINE, "Software\cv\visa32_pb_wrapper", "ip2"))
              DisableWindow(hwnd, 1)
              result  = get_visa_server_ip(@ip_num)
              DisableWindow(hwnd, 0)
              SetWindowPos_(WindowID(hwnd), #HWND_TOP, 0, 0, 0, 0, #SWP_NOMOVE|#SWP_NOSIZE)
              ip_address.s =  IPString(ip_num)
              If  result
                lxi_c_name.s  = "TCPIP0::" + ip_address + "::INSTR"
                result  = viOpen(visa_default, @lxi_c_name, #VI_NO_LOCK, 1000, @card_res)
                If  result <> #VI_ERROR_RSRC_NFOUND
                  AddGadgetItem(card_cb, -1, lxi_c_name, ImageID(tcpip1), 1)
                  viClose(card_res)
                  SetGadgetState(card_cb, 0)
                Else
                  MessageBox_(WindowID(hwnd), "-=cv=- 2012.7" + Chr(13) + Chr(10) + "no visa32@LXI device found at " + ip_address, "..cv..", #MB_OK | #MB_ICONINFORMATION|#MB_SYSTEMMODAL)
                EndIf                
                WriteRegKey(#HKEY_LOCAL_MACHINE, "Software\cv\visa32_pb_wrapper", "ip2", Str(ip_num))
              Else
                ;
              EndIf
            Case  4
              SetClipboardText(StringField(GetGadgetText(card_cb), 1, "@"))
          EndSelect
        Case  #PB_Event_CloseWindow
          FreeImage(gpib1)
          FreeMenu(menu1)
          CloseWindow(hwnd)         
          viClose(visa_default)
          ProcedureReturn #False
      EndSelect
    Until quit  = #True   
        
    PokeS(*resource, GetGadgetText(card_cb), -1, #PB_Ascii)
    CloseWindow(hwnd)
    
    result  = viOpen(visa_default, *resource, #VI_NO_LOCK, 1000, @card_res)  
    viClose(card_res)
    viClose(visa_default)    
    
    If  result  <>  #VI_SUCCESS
      ProcedureReturn #False
    Else
      ProcedureReturn #True
    EndIf    
    
  EndProcedure  
  
  ProcedureDLL.l select_visa_usb_device(*resource, vid.w=0, did.w=0)    ;;;;;usb的vid/did
  
    usb1  = CatchImage(#PB_Any, ?usb1)  
    usb2  = CatchImage(#PB_Any, ?usb2) 
    tcpip1  = CatchImage(#PB_Any, ?tcpip1)  
  
    hwnd  = OpenWindow(#PB_Any, 0, 0, 450, 85, "Pick a USB Device", #PB_Window_MinimizeGadget|#PB_Window_ScreenCentered|#PB_Window_SystemMenu)
    SendMessage_(WindowID(hwnd), #WM_SETICON, #ICON_SMALL, ImageID(usb2))    
    card_cb = ComboBoxGadget(#PB_Any , 10, 15, 430, 20, #PB_ComboBox_Image)
    SendMessage_(GadgetID(card_cb), #CB_SETDROPPEDWIDTH, 600, 0)
    GadgetToolTip(card_cb, "Select a Device")
    SmartWindowRefresh(hwnd, 1)     
       If OSVersion < #PB_OS_Windows_7
     ;
   Else
     SkinH_SetAero(WindowID(hwnd))
   EndIf
    StickyWindow(hwnd, #True)
    
    visa_default  = 0
    viOpenDefaultRM(@visa_default)
    numInstrs = 0
    findList  = 0
    descriptor.s  = Space(256)
    
    vid_string.s  = "0x" + RSet(Hex(vid, #PB_Word), 4, "0")
    did_string.s  = "0x" + RSet(Hex(did, #PB_Word), 4, "0")
    
    If  0 <> vid
      SetWindowTitle(hwnd, GetWindowTitle(hwnd) + " - " + vid_string + " - " + did_string)
    EndIf    
        
    Select  vid
      Case  0
        pattern_res.s = "?*(USB)?*INSTR"
      Default
        pattern_res = "?*(USB)?*INSTR{VI_ATTR_MANF_ID==" + vid_string + " && VI_ATTR_MODEL_CODE==" + did_string + "}"        
    EndSelect
    
    result  = viFindRsrc(visa_default, @pattern_res, @findList, @numInstrs, @descriptor)
    retry_time.l  = 1
    
    While  result  = #VI_ERROR_RSRC_NFOUND
      result  = viFindRsrc(visa_default, @pattern_res, @findList, @numInstrs, @descriptor)
      Delay(100)
      retry_time  = retry_time  + 1
      If  3 = retry_time
        Break
      EndIf
    Wend
        
    Select  result
      Case  #VI_ERROR_RSRC_NFOUND
        MessageBox_(WindowID(hwnd), "-=cv=- 2012.7" + Chr(13) + Chr(10) + "no visa32@usb device found at host", "..cv.. " + Str(retry_time), #MB_OK | #MB_ICONERROR|#MB_SYSTEMMODAL)
      Case  #VI_ERROR_MACHINE_NAVAIL
        MessageBox_(WindowID(hwnd), "-=cv=- 2012.7" + Chr(13) + Chr(10) + "host is not ready!", "..cv..", #MB_OK | #MB_ICONERROR|#MB_SYSTEMMODAL)
      Default
        ;       
    EndSelect     
    
    card_res  = 0
    model_name.s  = Space(1024)
    
    Select  numInstrs
      Case  0
        ;
      Default
        viOpen(visa_default, @descriptor, #VI_NO_LOCK, 1000, @card_res)        
        viGetAttribute(card_res, #VI_ATTR_MODEL_NAME, @model_name)
        AddGadgetItem(card_cb, -1, descriptor + "@" + model_name, ImageID(usb1), 1)        
        numInstrs = numInstrs - 1
        viClose(card_res)
        While(numInstrs)
          viFindNext(findList, @descriptor)
          viOpen(visa_default, @descriptor, #VI_NO_LOCK, 1000, @card_res)
          viGetAttribute(card_res, #VI_ATTR_MODEL_NAME, @model_name)
          AddGadgetItem(card_cb, -1, descriptor + "@" + model_name, ImageID(usb1), 1)
          numInstrs = numInstrs - 1
          viClose(card_res)
        Wend      
        viClose(findList)
    EndSelect
    
    SetGadgetState(card_cb, 0)
    
    ok_bg = ButtonGadget(#PB_Any, 195, 50, 65, 25, "OK", #PB_Button_Default)  
    GadgetToolTip(ok_bg, "下一步")
    
    alias_bg  = ButtonGadget(#PB_Any, 50, 50, 40, 25, "ALIAS", #PB_Button_Toggle)
    GadgetToolTip(alias_bg, "按别名显示")    
    
    AddKeyboardShortcut(hwnd, #PB_Shortcut_Return, 0) 
    AddKeyboardShortcut(hwnd, #PB_Shortcut_Escape, 1)    
    
    menu1 = CreatePopupMenu(#PB_Any)
    If menu1
      MenuItem(2, "Add NI-VISA Server")
      MenuItem(3, "Add LXI-C Device")
      MenuItem(4, "COPY")
    EndIf    
    
    find_mode.l = 0
    
    Repeat
      Event.l = WaitWindowEvent()
      Select  Event
        Case  #WM_RBUTTONDOWN       
          DisplayPopupMenu(menu1, WindowID(hwnd))      
        Case  #PB_Event_Gadget
          Select  EventGadget()
            Case  ok_bg
              quit  = #True
            Case  card_cb
              ;
            Case  alias_bg
              viGetAttribute(visa_default, #VI_ATTR_FIND_RSRC_MODE, @find_mode)
              If  $8008 = find_mode
                viSetAttribute(visa_default, #VI_ATTR_FIND_RSRC_MODE, $800A)
              Else
                viSetAttribute(visa_default, #VI_ATTR_FIND_RSRC_MODE, $8008)
              EndIf              
          EndSelect
        Case  #PB_Event_Menu
          Select EventMenu()
            Case  0
              quit  = #True
            Case  1
              FreeImage(usb1)
              FreeMenu(menu1)
              CloseWindow(hwnd) 
              viClose(visa_default)
              ProcedureReturn #False
            Case  2
              ip_num.q  = Val(ReadRegKey(#HKEY_LOCAL_MACHINE, "Software\cv\visa32_pb_wrapper", "ip1"))
              DisableWindow(hwnd, 1)
              result  = get_visa_server_ip(@ip_num)
              DisableWindow(hwnd, 0)
              SetWindowPos_(WindowID(hwnd), #HWND_TOP, 0, 0, 0, 0, #SWP_NOMOVE|#SWP_NOSIZE)
              ip_address.s =  IPString(ip_num)
              If  result
                numInstrs = 0
                findList  = 0
                descriptor.s  = Space(256)
                
                Select vid
                  Case  0
                    resource.s  = "visa://" + ip_address + "/?*(USB)?*INSTR"
                  Default
                    pattern_res = "/?*(USB)?*INSTR{VI_ATTR_MANF_ID==" + vid_string + " && VI_ATTR_MODEL_CODE==" + did_string + "}"                    
                    resource  = "visa://" + ip_address + pattern_res
                EndSelect                
                
                result  = viFindRsrc(visa_default, @resource, @findList, @numInstrs, @descriptor)
                retry_time  = 1
                
                While  result  = #VI_ERROR_RSRC_NFOUND
                  result  = viFindRsrc(visa_default, @resource, @findList, @numInstrs, @descriptor)
                  Delay(100)
                  retry_time  = retry_time  + 1
                  If  15 = retry_time
                    Break
                  EndIf
                Wend                
                
                Select  result
                  Case  #VI_ERROR_RSRC_NFOUND
                    MessageBox_(WindowID(hwnd), "-=cv=- 2012.7" + Chr(13) + Chr(10) + "no visa32@usb device found at " + ip_address, "..cv.. " + Str(retry_time), #MB_OK | #MB_ICONERROR|#MB_SYSTEMMODAL)
                  Case  #VI_ERROR_MACHINE_NAVAIL
                    MessageBox_(WindowID(hwnd), "-=cv=- 2012.7" + Chr(13) + Chr(10) + "visa server at " + ip_address + " is Not ready!", "..cv..", #MB_OK | #MB_ICONERROR|#MB_SYSTEMMODAL)
                  Default
                    ;       
                EndSelect                 
                
                Select  numInstrs
                  Case  0
                    ;
                  Default
                    viOpen(visa_default, @descriptor, #VI_NO_LOCK, 1000, @card_res)
                    viGetAttribute(card_res, #VI_ATTR_MODEL_NAME, @model_name)
                    AddGadgetItem(card_cb, -1, descriptor + "@" + model_name, ImageID(usb1), 1)                            
                    numInstrs = numInstrs - 1
                    viClose(card_res)
                    While(numInstrs)
                      viFindNext(findList, @descriptor)
                      viOpen(visa_default, @descriptor, #VI_NO_LOCK, 1000, @card_res)
                      viGetAttribute(card_res, #VI_ATTR_MODEL_NAME, @model_name)
                      AddGadgetItem(card_cb, -1, descriptor + "@" + model_name, ImageID(usb1), 1)
                      numInstrs = numInstrs - 1
                      viClose(card_res)
                    Wend 
                    viClose(findList)
                EndSelect 
                SetGadgetState(card_cb, 0)
                WriteRegKey(#HKEY_LOCAL_MACHINE, "Software\cv\visa32_pb_wrapper", "ip1", Str(ip_num))
              Else
                ;
              EndIf
            Case  3
              ip_num  = Val(ReadRegKey(#HKEY_LOCAL_MACHINE, "Software\cv\visa32_pb_wrapper", "ip2"))
              DisableWindow(hwnd, 1)
              result  = get_visa_server_ip(@ip_num)
              DisableWindow(hwnd, 0)
              SetWindowPos_(WindowID(hwnd), #HWND_TOP, 0, 0, 0, 0, #SWP_NOMOVE|#SWP_NOSIZE)
              
              ip_address.s =  IPString(ip_num)
              If  result
                lxi_c_name.s  = "TCPIP0::" + ip_address + "::INSTR"
                result  = viOpen(visa_default, @lxi_c_name, #VI_NO_LOCK, 1000, @card_res)
                If  result <> #VI_ERROR_RSRC_NFOUND
                  viGetAttribute(card_res, #VI_ATTR_MODEL_NAME, @model_name)
                  AddGadgetItem(card_cb, -1, lxi_c_name + "@" + model_name, ImageID(tcpip1), 1)
                  viClose(card_res)
                  SetGadgetState(card_cb, 0)
                Else
                  MessageBox_(WindowID(hwnd), "-=cv=- 2012.7" + Chr(13) + Chr(10) + "no visa32@LXI found at " + ip_address, "..cv..", #MB_OK | #MB_ICONINFORMATION|#MB_SYSTEMMODAL)
                EndIf                
                WriteRegKey(#HKEY_LOCAL_MACHINE, "Software\cv\visa32_pb_wrapper", "ip2", Str(ip_num))
              Else
                ;
              EndIf
            Case  4
              SetClipboardText(StringField(GetGadgetText(card_cb), 1, "@"))
          EndSelect
        Case  #PB_Event_CloseWindow
          FreeImage(usb1)
          FreeMenu(menu1)
          CloseWindow(hwnd)         
          viClose(visa_default)
          ProcedureReturn #False
      EndSelect
    Until quit  = #True
    
    PokeS(*resource, StringField(GetGadgetText(card_cb), 1, "@"), -1, #PB_Ascii)
    CloseWindow(hwnd)   
    
    result  = viOpen(visa_default, *resource, #VI_NO_LOCK, 1000, @card_res)  
    viClose(card_res)
    viClose(visa_default)    
    
    If  result  <>  #VI_SUCCESS
      ProcedureReturn #False
    Else
      ProcedureReturn #True
    EndIf    
    
  EndProcedure  
  
  ProcedureDLL.l  select_visa_lxi_device(*resource)
    ;找支持lxi-c的VISA32设备
    ;
    lxi_icon  = 0
    ExtractIconEx_("cv_icons.dll", 141, #Null, @lxi_icon, 1)      
        
    Protected hwnd = OpenWindow(#PB_Any, 0, 0, 250, 190, "select_visa_lxi_device", #PB_Window_SystemMenu | #PB_Window_MinimizeGadget | #PB_Window_ScreenCentered)
    SetWindowPos_(WindowID(hwnd), #HWND_TOPMOST, 0, 0, 0, 0, #SWP_NOMOVE|#SWP_NOSIZE)
    SendMessage_(WindowID(hwnd), #WM_SETICON, #ICON_SMALL, lxi_icon)
       If OSVersion < #PB_OS_Windows_7
     ;
   Else
     SkinH_SetAero(WindowID(hwnd))
   EndIf    
    
    refresh_bg = ButtonGadget(#PB_Any, 10, 10, 30, 30, "刷新")
    lxi_lig = ListIconGadget(#PB_Any, 10, 50, 230, 130, "server", 100, #PB_ListIcon_GridLines | #PB_ListIcon_FullRowSelect | #PB_ListIcon_AlwaysShowSelection)
    
    AddKeyboardShortcut(hwnd, #PB_Shortcut_Escape, 0)
    AddKeyboardShortcut(hwnd, #PB_Shortcut_Return, 3) 
    
    Repeat
      Event.l = WaitWindowEvent()
      Select  Event
        Case  #PB_Event_Gadget
          Select  EventGadget()
            Case  lxi_lig
              quit  = #True
            Case  refresh_bg
              ;
          EndSelect
        Case  #PB_Event_Menu
          Select EventMenu()
            Case  3 ;回车
              quit  = #True
            Case  0 ;ESC
              CloseWindow(hwnd)
              ProcedureReturn #False              
          EndSelect 
        Case  #PB_Event_CloseWindow
          CloseWindow(hwnd)
          ProcedureReturn #False
      EndSelect
    Until quit  = #True
            
    CloseWindow(hwnd)
    ProcedureReturn #True
        
  EndProcedure
  
  ProcedureDLL pxi_register_access(*card_info)
    
    *card = PeekL(*card_info)   ;read 4byte
    bar.l = PeekL(*card_info  + 4)  ;read 4byte
    offset_address.l = PeekL(*card_info  + 8) ;read 4byte
    x.l = PeekL(*card_info  + 12) ;read 4byte
    y.l = PeekL(*card_info  + 16) ;read 4byte
    *title  = PeekL(*card_info  + 20) ;read 4byte    
        
    chip1 = CatchImage(#PB_Any, ?chip1) 
    chip2 = CatchImage(#PB_Any, ?chip2) 
    
    Protected visa_default.q  = 0
    viOpenDefaultRM(@visa_default)
    
    Protected card_res.q  = 0
    result  = viOpen(visa_default, *card, #VI_NO_LOCK, 1000, @card_res)
    
    If result <> #VI_SUCCESS
      MessageBox_(GetFocus_(), "error resource open!" + Chr(10) + PeekS(*card, -1, #PB_Ascii), "..cv..", #MB_OK | #MB_ICONERROR|#MB_SYSTEMMODAL)
      ProcedureReturn #False
    EndIf    
    
    
    Protected hwnd  = OpenWindow(#PB_Any, x, y, 290, 100, "some reg", #PB_Window_MinimizeGadget|#PB_Window_SystemMenu)
    
    viInstallHandler(card_res, #VI_EVENT_EXCEPTION, @visa32_error_handler(), hwnd)
    viEnableEvent(card_res, #VI_EVENT_EXCEPTION, #VI_HNDLR, #VI_NULL)        
    
    SetWindowPos_(WindowID(hwnd), #HWND_TOP, 0, 0, 0, 0, #SWP_NOMOVE|#SWP_NOSIZE)
    SendMessage_(WindowID(hwnd), #WM_SETICON, #ICON_SMALL, ImageID(chip2))
    SetWindowTitle(hwnd, PeekS(*title, -1, #PB_Ascii))
    SmartWindowRefresh(hwnd, 1)     
       If OSVersion < #PB_OS_Windows_7
     ;
   Else
     SkinH_SetAero(WindowID(hwnd))
   EndIf
    value_sg  = StringGadget(#PB_Any, 5, 30, 100, 20, "00000000", #PB_String_UpperCase)
    SetGadgetColor(value_sg, #PB_Gadget_FrontColor, RGB(00, $FF, 00))
    SetGadgetColor(value_sg, #PB_Gadget_BackColor, RGB(00, 00, 00))
    SendMessage_(GadgetID(value_sg), #EM_SETLIMITTEXT, 8, 0)
    SendMessage_(GadgetID(value_sg), #EM_SETSEL, 0, Len(GetGadgetText(value_sg)))    
    GadgetToolTip(value_sg, "Hex Display")   

    
    hex_tg  = TextGadget(#PB_Any, 5, 5, 100, 20, "HEX DISPLAY", #PB_Text_Border|#PB_Text_Center)
    SetGadgetColor(hex_tg, #PB_Gadget_FrontColor, RGB(00, $FF, 00))
    SetGadgetColor(hex_tg, #PB_Gadget_BackColor, RGB(00, 00, 00))
    
    big_font1  = LoadFont(#PB_Any,"Courier",12, #PB_Font_Bold|#PB_Font_HighQuality)
    big_font2  = LoadFont(#PB_Any,"Courier",10, #PB_Font_HighQuality)    
    SetGadgetFont(value_sg, FontID(big_font1))
    SetGadgetFont(hex_tg, FontID(big_font2))
    
    r8_bg = ButtonGadget(#PB_Any, 110, 5, 40, 20, "R8")
    r16_bg = ButtonGadget(#PB_Any, 110, 30, 40, 20, "R16")
    r32_bg = ButtonGadget(#PB_Any, 110, 55, 40, 20, "R32")
    w8_bg = ButtonGadget(#PB_Any, 155, 5, 40, 20, "W8")
    w16_bg = ButtonGadget(#PB_Any, 155, 30, 40, 20, "W16")
    w32_bg = ButtonGadget(#PB_Any, 155, 55, 40, 20, "W32")
    
    r8r_bg = ButtonGadget(#PB_Any, 200, 5, 40, 20, "R8R", #PB_Button_Toggle)
    r16r_bg = ButtonGadget(#PB_Any, 200, 30, 40, 20, "R16R", #PB_Button_Toggle)
    r32r_bg = ButtonGadget(#PB_Any, 200, 55, 40, 20, "R32R", #PB_Button_Toggle)
    w8r_bg = ButtonGadget(#PB_Any, 245, 5, 40, 20, "W8R", #PB_Button_Toggle)
    w16r_bg = ButtonGadget(#PB_Any, 245, 30, 40, 20, "W16R", #PB_Button_Toggle)
    w32r_bg = ButtonGadget(#PB_Any, 245, 55, 40, 20, "W32R", #PB_Button_Toggle) 
    
    GadgetToolTip(r8_bg, "8bit单次读取")   
    GadgetToolTip(r16_bg, "16bit单次读取")   
    GadgetToolTip(r32_bg, "32bit单次读取")   
    GadgetToolTip(w8_bg, "8bit单次写入")   
    GadgetToolTip(w16_bg, "16bit单次写入")   
    GadgetToolTip(w32_bg, "32bit单次写入")   
    GadgetToolTip(r8r_bg, "8bit连续读取")   
    GadgetToolTip(r16r_bg, "16bit连续读取")   
    GadgetToolTip(r32r_bg, "32bit连续读取")   
    GadgetToolTip(w8r_bg, "8bit连续写入")   
    GadgetToolTip(w16r_bg, "16bit连续写入")   
    GadgetToolTip(w32r_bg, "32bit连续写入")     
    
    capture_bg  = ButtonGadget(#PB_Any, 5, 55, 40, 20, "BMP")
    GadgetToolTip(capture_bg, "Take a Pic")   
    
    top_bg  = ButtonGadget(#PB_Any, 50, 55, 20, 20, "↑", #PB_Button_Toggle)
    GadgetToolTip(top_bg, "Always On The Top")
    
    lock_bg = ButtonGadget(#PB_Any, 75, 55, 20, 20, "L", #PB_Button_Toggle)
    GadgetToolTip(lock_bg, "LOCK resource")
    
    status_sb = CreateStatusBar(#PB_Any, WindowID(hwnd))
    
    If status_sb
      AddStatusBarField(150)
      AddStatusBarField(50)
      AddStatusBarField(90)
    EndIf
      
    slot_id = 0
    model_name.s = Space(4096)
    viGetAttribute(card_res, #VI_ATTR_SLOT, @slot_id)   
    viGetAttribute(card_res, #VI_ATTR_MODEL_NAME, @model_name)
    StatusBarText(status_sb, 0, model_name + "@Slot" + Str(slot_id))

    Select  bar
        Case  #VI_PXI_BAR2_SPACE
          StatusBarText(status_sb, 1, "BAR2")
        Case  #VI_PXI_BAR0_SPACE 
          StatusBarText(status_sb, 1, "BAR0")
        Case  #VI_PXI_BAR3_SPACE
          StatusBarText(status_sb, 1, "BAR3")
        Case  #VI_PXI_CFG_SPACE
          StatusBarText(status_sb, 1, "CFG")
        Case  #VI_PXI_ALLOC_SPACE
          StatusBarText(status_sb, 1, "PC MEMORY")
        Default
          StatusBarText(status_sb, 1, "no support")
    EndSelect
         
    StatusBarText(status_sb, 2, "0x" + RSet(Hex(offset_address, #PB_Long), 8, "0"))
        
    AddWindowTimer(hwnd, 0, 200)
    AddKeyboardShortcut(hwnd, #PB_Shortcut_Escape, 100)
        
    value = 0
    
    Repeat      
      Event.l = WaitWindowEvent()      
      Select  Event
        Case #PB_Event_Menu
          Select  EventGadget()
            Case  100
              quit  = #True
          EndSelect
        Case  #PB_Event_Timer
          If  GetGadgetState(r8r_bg)
            viIn8(card_res, bar, offset_address, @value)
            SetGadgetText(value_sg, RSet(Hex(value, #PB_Byte), 2, "0")) 
          Else
            ;
          EndIf
          
          If  GetGadgetState(r16r_bg)
            viIn16(card_res, bar, offset_address, @value)
            SetGadgetText(value_sg, RSet(Hex(value, #PB_Word), 4, "0"))      
          Else
            ;
          EndIf
          
          If  GetGadgetState(r32r_bg)
            viIn32(card_res, bar, offset_address, @value)
            SetGadgetText(value_sg, RSet(Hex(value, #PB_Long), 8, "0"))       
          Else
            ;
          EndIf      
          
          If  GetGadgetState(w8r_bg)
            viOut8(card_res, bar, offset_address, Val("$" + GetGadgetText(value_sg)))
          Else
            ;
          EndIf     
          
          If  GetGadgetState(w16r_bg)
            viOut16(card_res, bar, offset_address, Val("$" + GetGadgetText(value_sg)))       
          Else
            ;
          EndIf     
          
          If  GetGadgetState(w32r_bg)
            viOut32(card_res, bar, offset_address, Val("$" + GetGadgetText(value_sg)))
          Else
            ;
          EndIf    
                  
        Case  #PB_Event_Gadget
          Select  EventGadget()
            Case  lock_bg
              Delay(10)
              If  GetGadgetState(lock_bg)
                viLock(card_res, #VI_EXCLUSIVE_LOCK, 200, #VI_NULL, #VI_NULL)
              Else
                viUnlock(card_res)
              EndIf              
            Case  top_bg
              Select EventType()
                Case #PB_EventType_LeftClick
                  Delay(10)
                  If  GetGadgetState(top_bg)
                    SetWindowPos_(WindowID(hwnd), #HWND_TOPMOST, 0, 0, 0, 0, #SWP_NOMOVE|#SWP_NOSIZE)
                  Else
                    SetWindowPos_(WindowID(hwnd), #HWND_NOTOPMOST, 0, 0, 0, 0, #SWP_NOMOVE|#SWP_NOSIZE)
                  EndIf 
                Case #PB_EventType_RightClick
                  ;
                Case #PB_EventType_LeftDoubleClick
                  ;
                Case #PB_EventType_RightDoubleClick
                  ;
                Case  #PB_EventType_Change
                  ;                  
              EndSelect                        
            Case  capture_bg
              CaptureWindow(GetWindowTitle(hwnd))
            Case  r8r_bg
              If  GetGadgetState(r8r_bg)
                HideGadget(r16r_bg, 1);
                HideGadget(r32r_bg, 1);
                HideGadget(w8r_bg, 1);
                HideGadget(w16r_bg, 1);
                HideGadget(w32r_bg, 1);
              Else
                HideGadget(r16r_bg, 0);
                HideGadget(r32r_bg, 0);
                HideGadget(w8r_bg, 0);
                HideGadget(w16r_bg, 0);
                HideGadget(w32r_bg, 0);                
              EndIf
            Case  r16r_bg 
              If  GetGadgetState(r16r_bg)
                HideGadget(r8r_bg, 1);
                HideGadget(r32r_bg, 1);
                HideGadget(w8r_bg, 1);
                HideGadget(w16r_bg, 1);
                HideGadget(w32r_bg, 1);
              Else
                HideGadget(r8r_bg, 0);
                HideGadget(r32r_bg, 0);
                HideGadget(w8r_bg, 0);
                HideGadget(w16r_bg, 0);
                HideGadget(w32r_bg, 0);                
              EndIf 
            Case  r32r_bg 
              If  GetGadgetState(r32r_bg)
                HideGadget(r8r_bg, 1);
                HideGadget(r16r_bg, 1);
                HideGadget(w8r_bg, 1);
                HideGadget(w16r_bg, 1);
                HideGadget(w32r_bg, 1);
              Else
                HideGadget(r8r_bg, 0);
                HideGadget(r16r_bg, 0);
                HideGadget(w8r_bg, 0);
                HideGadget(w16r_bg, 0);
                HideGadget(w32r_bg, 0);                
              EndIf
            Case  w8r_bg 
              If  GetGadgetState(w8r_bg)
                HideGadget(r8r_bg, 1);
                HideGadget(r16r_bg, 1);
                HideGadget(r32r_bg, 1);
                HideGadget(w16r_bg, 1);
                HideGadget(w32r_bg, 1);
              Else
                HideGadget(r8r_bg, 0);
                HideGadget(r16r_bg, 0);
                HideGadget(r32r_bg, 0);
                HideGadget(w16r_bg, 0);
                HideGadget(w32r_bg, 0);                
              EndIf
            Case  w16r_bg 
              If  GetGadgetState(w16r_bg)
                HideGadget(r8r_bg, 1);
                HideGadget(r16r_bg, 1);
                HideGadget(w8r_bg, 1);
                HideGadget(r32r_bg, 1);
                HideGadget(w32r_bg, 1);
              Else
                HideGadget(r8r_bg, 0);
                HideGadget(r16r_bg, 0);
                HideGadget(w8r_bg, 0);
                HideGadget(r32r_bg, 0);
                HideGadget(w32r_bg, 0);                
              EndIf
            Case  w32r_bg 
              If  GetGadgetState(w32r_bg)
                HideGadget(r8r_bg, 1);
                HideGadget(r16r_bg, 1);
                HideGadget(w8r_bg, 1);
                HideGadget(w16r_bg, 1);
                HideGadget(r32r_bg, 1);
              Else
                HideGadget(r8r_bg, 0);
                HideGadget(r16r_bg, 0);
                HideGadget(w8r_bg, 0);
                HideGadget(w16r_bg, 0);
                HideGadget(r32r_bg, 0);                
              EndIf              
            Case  r8_bg
              viIn8(card_res, bar, offset_address, @value)
              SetGadgetText(value_sg, RSet(Hex(value, #PB_Byte), 2, "0")) 
            Case  r16_bg
              viIn16(card_res, bar, offset_address, @value)
              SetGadgetText(value_sg, RSet(Hex(value, #PB_Word), 4, "0"))  
            Case  r32_bg
              viIn32(card_res, bar, offset_address, @value)
              SetGadgetText(value_sg, RSet(Hex(value, #PB_Long), 8, "0"))
            Case  w8_bg
              viOut8(card_res, bar, offset_address, Val("$" + GetGadgetText(value_sg)))
            Case  w16_bg
              viOut16(card_res, bar, offset_address, Val("$" + GetGadgetText(value_sg)))
            Case  w32_bg
              viOut32(card_res, bar, offset_address, Val("$" + GetGadgetText(value_sg)))
            Case  value_sg
              Select EventType()
                Case  #PB_EventType_Change
                  start_p.l = 0
                  end_p.l = 0
                  SendMessage_(GadgetID(value_sg), #EM_GETSEL, @start_p, @end_p)
                  sInput.s = GetGadgetText(value_sg)
                  iLen = Len(sInput)
                  sNumber.s = ""
                                         
                  For iCnt = 1 To iLen
                    sChar.s = Mid(sInput,iCnt,1)
                    iAscii = Asc(sChar)
                    iIncludeChar = #True
                                        
                    Select iAscii
                      Case 48, 49, 50, 51, 52, 53, 54, 55, 56, 57
                      Case 65, 66, 67, 68, 69, 70
                      Case 97, 98, 99, 100, 101, 102
                      Default: iIncludeChar = #False
                    EndSelect
                                        
                    If(iIncludeChar = #True) : sNumber = sNumber + sChar: EndIf              
                   
                  Next
                 
                  SetGadgetText(value_sg,sNumber)
                  SendMessage_(GadgetID(value_sg), #EM_SETSEL, start_p, end_p)
                 
               Default
                 ;
             EndSelect
          EndSelect
      EndSelect
    Until Event = #PB_Event_CloseWindow Or  quit  = #True  
    
    RemoveWindowTimer(hwnd, 0)
    CloseWindow(hwnd)
    
    viDisableEvent(card_res, #VI_ALL_ENABLED_EVENTS, #VI_ALL_MECH)
    viUninstallHandler(card_res, #VI_EVENT_EXCEPTION, @visa32_error_handler(), hwnd)
        
    viClose(card_res)
    viClose(visa_default)
    
  EndProcedure  
  
  ProcedureDLL.l pxi_bit_access(*card_info)
        
    *card = PeekL(*card_info)   ;read 4byte
    bar.l = PeekL(*card_info  + 4)  ;read 4byte
    offset_address.l = PeekL(*card_info  + 8) ;read 4byte
    x.l = PeekL(*card_info  + 12) ;read 4byte
    y.l = PeekL(*card_info  + 16) ;read 4byte
    *title  = PeekL(*card_info  + 20) ;read 4byte     
    
    chip1  = CatchImage(#PB_Any, ?chip1)
    chip2 = CatchImage(#PB_Any, ?chip2) 
    
    Protected visa_default.q  = 0
    viOpenDefaultRM(@visa_default)
    
    Protected card_res.q  = 0
    result  = viOpen(visa_default, *card, #VI_NO_LOCK, 1000, @card_res)
    
    If result <> #VI_SUCCESS
      MessageBox_(GetFocus_(), "error resource open!" + Chr(10) + PeekS(*card, -1, #PB_Ascii), "..cv..", #MB_OK | #MB_ICONERROR|#MB_SYSTEMMODAL)
      ProcedureReturn #False
    EndIf    
        
    Protected hwnd  = OpenWindow(#PB_Any, x, y, 290, 150, "some reg", #PB_Window_MinimizeGadget|#PB_Window_SystemMenu)
    
    viInstallHandler(card_res, #VI_EVENT_EXCEPTION, @visa32_error_handler(), hwnd)
    viEnableEvent(card_res, #VI_EVENT_EXCEPTION, #VI_HNDLR, #VI_NULL)        
    
    SetWindowPos_(WindowID(hwnd), #HWND_TOP, 0, 0, 0, 0, #SWP_NOMOVE|#SWP_NOSIZE)
    SendMessage_(WindowID(hwnd), #WM_SETICON, #ICON_SMALL, ImageID(chip2))
    SetWindowTitle(hwnd, PeekS(*title, -1, #PB_Ascii))
    SmartWindowRefresh(hwnd, 1)     
       If OSVersion < #PB_OS_Windows_7
     ;
   Else
     SkinH_SetAero(WindowID(hwnd))
   EndIf
    bit_bg31 = ButtonGadget(#PB_Any, 5, 30, 25, 20, "31", #PB_Button_Toggle)
    bit_bg30 = ButtonGadget(#PB_Any, 35, 30, 25, 20, "30", #PB_Button_Toggle)
    bit_bg29 = ButtonGadget(#PB_Any, 65, 30, 25, 20, "29", #PB_Button_Toggle)
    bit_bg28 = ButtonGadget(#PB_Any, 95, 30, 25, 20, "28", #PB_Button_Toggle)
    bit_bg27 = ButtonGadget(#PB_Any, 125, 30, 25, 20, "27", #PB_Button_Toggle)
    bit_bg26 = ButtonGadget(#PB_Any, 155, 30, 25, 20, "26", #PB_Button_Toggle)
    bit_bg25 = ButtonGadget(#PB_Any, 185, 30, 25, 20, "25", #PB_Button_Toggle)
    bit_bg24 = ButtonGadget(#PB_Any, 215, 30, 25, 20, "24", #PB_Button_Toggle)
    
    bit_bg23 = ButtonGadget(#PB_Any, 5, 55, 25, 20, "23", #PB_Button_Toggle)
    bit_bg22 = ButtonGadget(#PB_Any, 35, 55, 25, 20, "22", #PB_Button_Toggle)
    bit_bg21 = ButtonGadget(#PB_Any, 65, 55, 25, 20, "21", #PB_Button_Toggle)
    bit_bg20 = ButtonGadget(#PB_Any, 95, 55, 25, 20, "20", #PB_Button_Toggle)
    bit_bg19 = ButtonGadget(#PB_Any, 125, 55, 25, 20, "19", #PB_Button_Toggle)
    bit_bg18 = ButtonGadget(#PB_Any, 155, 55, 25, 20, "18", #PB_Button_Toggle)
    bit_bg17 = ButtonGadget(#PB_Any, 185, 55, 25, 20, "17", #PB_Button_Toggle)
    bit_bg16 = ButtonGadget(#PB_Any, 215, 55, 25, 20, "16", #PB_Button_Toggle)
    
    bit_bg15 = ButtonGadget(#PB_Any, 5, 80, 25, 20, "15", #PB_Button_Toggle)
    bit_bg14 = ButtonGadget(#PB_Any, 35, 80, 25, 20, "14", #PB_Button_Toggle)
    bit_bg13 = ButtonGadget(#PB_Any, 65, 80, 25, 20, "13", #PB_Button_Toggle)
    bit_bg12 = ButtonGadget(#PB_Any, 95, 80, 25, 20, "12", #PB_Button_Toggle)
    bit_bg11 = ButtonGadget(#PB_Any, 125, 80, 25, 20, "11", #PB_Button_Toggle)
    bit_bg10 = ButtonGadget(#PB_Any, 155, 80, 25, 20, "10", #PB_Button_Toggle)
    bit_bg9 = ButtonGadget(#PB_Any, 185, 80, 25, 20, "9", #PB_Button_Toggle)
    bit_bg8 = ButtonGadget(#PB_Any, 215, 80, 25, 20, "8", #PB_Button_Toggle)
    
    bit_bg7 = ButtonGadget(#PB_Any, 5, 105, 25, 20, "7", #PB_Button_Toggle)
    bit_bg6 = ButtonGadget(#PB_Any, 35, 105, 25, 20, "6", #PB_Button_Toggle)
    bit_bg5 = ButtonGadget(#PB_Any, 65, 105, 25, 20, "5", #PB_Button_Toggle)
    bit_bg4 = ButtonGadget(#PB_Any, 95, 105, 25, 20, "4", #PB_Button_Toggle)
    bit_bg3 = ButtonGadget(#PB_Any, 125, 105, 25, 20, "3", #PB_Button_Toggle)
    bit_bg2 = ButtonGadget(#PB_Any, 155, 105, 25, 20, "2", #PB_Button_Toggle)
    bit_bg1 = ButtonGadget(#PB_Any, 185, 105, 25, 20, "1", #PB_Button_Toggle)
    bit_bg0 = ButtonGadget(#PB_Any, 215, 105, 25, 20, "0", #PB_Button_Toggle)  
    
    GadgetToolTip(bit_bg0, "bit0")   
    GadgetToolTip(bit_bg1, "bit1")   
    GadgetToolTip(bit_bg2, "bit2")   
    GadgetToolTip(bit_bg3, "bit3")   
    GadgetToolTip(bit_bg4, "bit4")   
    GadgetToolTip(bit_bg5, "bit5")   
    GadgetToolTip(bit_bg6, "bit6")   
    GadgetToolTip(bit_bg7, "bit7")   
    
    GadgetToolTip(bit_bg8, "bit8")   
    GadgetToolTip(bit_bg9, "bit9")   
    GadgetToolTip(bit_bg10, "bit10")   
    GadgetToolTip(bit_bg11, "bit11")   
    GadgetToolTip(bit_bg12, "bit12")   
    GadgetToolTip(bit_bg13, "bit13")   
    GadgetToolTip(bit_bg14, "bit14")   
    GadgetToolTip(bit_bg15, "bit15") 
    
    GadgetToolTip(bit_bg16, "bit16")   
    GadgetToolTip(bit_bg17, "bit17")   
    GadgetToolTip(bit_bg18, "bit18")   
    GadgetToolTip(bit_bg19, "bit19")   
    GadgetToolTip(bit_bg20, "bit20")   
    GadgetToolTip(bit_bg21, "bit21")   
    GadgetToolTip(bit_bg22, "bit22")   
    GadgetToolTip(bit_bg23, "bit23") 
    
    GadgetToolTip(bit_bg24, "bit24")   
    GadgetToolTip(bit_bg25, "bit25")   
    GadgetToolTip(bit_bg26, "bit26")   
    GadgetToolTip(bit_bg27, "bit27")   
    GadgetToolTip(bit_bg28, "bit28")   
    GadgetToolTip(bit_bg29, "bit29")   
    GadgetToolTip(bit_bg30, "bit30")   
    GadgetToolTip(bit_bg31, "bit31")     
    
    all_one_bg  = ButtonGadget(#PB_Any, 245, 30, 40, 40, "SET ALL", #PB_Button_MultiLine) 
    none_one_bg  = ButtonGadget(#PB_Any, 245, 80, 40, 40, "CLEAR ALL", #PB_Button_MultiLine) 
    
    GadgetToolTip(all_one_bg, "All Set To 1")     
    GadgetToolTip(none_one_bg, "All Clear To 0")         
    
    capture_bg  = ButtonGadget(#PB_Any, 170, 5, 40, 20, "BMP")
    GadgetToolTip(capture_bg, "Take a Pic") 
    
    top_bg  = ButtonGadget(#PB_Any, 215, 5, 20, 20, "↑", #PB_Button_Toggle)
    GadgetToolTip(top_bg, "Always On The Top")
    
    lock_bg  = ButtonGadget(#PB_Any, 240, 5, 20, 20, "L", #PB_Button_Toggle)
    GadgetToolTip(lock_bg, "LOCK resource")     
        
    Protected value_sg  = StringGadget(#PB_Any, 55, 5, 100, 20, "00000000", #PB_String_UpperCase|#PB_String_ReadOnly)
    SetGadgetColor(value_sg, #PB_Gadget_FrontColor, RGB(00, $FF, 00))
    SetGadgetColor(value_sg, #PB_Gadget_BackColor, RGB(00, 00, 00))
    SendMessage_(GadgetID(value_sg), #EM_SETLIMITTEXT, 8, 0)
    GadgetToolTip(value_sg, "Hex Read Value")   
    
    hex_tg  = TextGadget(#PB_Any, 5, 5, 40, 20, "HEX", #PB_Text_Border|#PB_Text_Center)
    SetGadgetColor(hex_tg, #PB_Gadget_FrontColor, $00FFFF)
    SetGadgetColor(hex_tg, #PB_Gadget_BackColor, $FF6600)
    
    big_font1  = LoadFont(#PB_Any,"Courier",12, #PB_Font_Bold|#PB_Font_HighQuality)
    big_font2  = LoadFont(#PB_Any,"Courier",10, #PB_Font_Bold|#PB_Font_HighQuality)    
    SetGadgetFont(value_sg, FontID(big_font1))
    SetGadgetFont(hex_tg, FontID(big_font2))
    
    popup_menu  = CreatePopupMenu(#PB_Any)
    If  popup_menu
      OpenSubMenu("Set")
        MenuItem(1, "bit31")
        MenuItem(2, "bit30")
        MenuItem(3, "bit29")
        MenuItem(4, "bit28")
        MenuItem(5, "bit27")
        MenuItem(6, "bit26")
        MenuItem(7, "bit25")
        MenuItem(8, "bit24")  
        MenuBar()
        MenuItem(9, "bit23")
        MenuItem(10, "bit22")
        MenuItem(11, "bit21")
        MenuItem(12, "bit20")
        MenuItem(13, "bit19")
        MenuItem(14, "bit18")
        MenuItem(15, "bit17")
        MenuItem(16, "bit16")  
        MenuBar()
        MenuItem(17, "bit15")
        MenuItem(18, "bit14")
        MenuItem(19, "bit13")
        MenuItem(20, "bit12")
        MenuItem(21, "bit11")
        MenuItem(22, "bit10")
        MenuItem(23, "bit9")
        MenuItem(24, "bit8")  
        MenuBar()
        MenuItem(25, "bit7")
        MenuItem(26, "bit6")
        MenuItem(27, "bit5")
        MenuItem(28, "bit4")
        MenuItem(29, "bit3")
        MenuItem(30, "bit2")
        MenuItem(31, "bit1")
        MenuItem(32, "bit0")          
      CloseSubMenu()
      MenuBar()  
      OpenSubMenu("Clear")
        MenuItem(33, "bit31")
        MenuItem(34, "bit30")
        MenuItem(35, "bit29")
        MenuItem(36, "bit28")
        MenuItem(37, "bit27")
        MenuItem(38, "bit26")
        MenuItem(39, "bit25")
        MenuItem(40, "bit24")  
        MenuBar()
        MenuItem(41, "bit23")
        MenuItem(42, "bit22")
        MenuItem(43, "bit21")
        MenuItem(44, "bit20")
        MenuItem(45, "bit19")
        MenuItem(46, "bit18")
        MenuItem(47, "bit17")
        MenuItem(48, "bit16")  
        MenuBar()
        MenuItem(49, "bit15")
        MenuItem(50, "bit14")
        MenuItem(51, "bit13")
        MenuItem(52, "bit12")
        MenuItem(53, "bit11")
        MenuItem(54, "bit10")
        MenuItem(55, "bit9")
        MenuItem(56, "bit8")  
        MenuBar()
        MenuItem(57, "bit7")
        MenuItem(58, "bit6")
        MenuItem(59, "bit5")
        MenuItem(60, "bit4")
        MenuItem(61, "bit3")
        MenuItem(62, "bit2")
        MenuItem(63, "bit1")
        MenuItem(64, "bit0")             
      CloseSubMenu()
    EndIf
        
    status_sb = CreateStatusBar(#PB_Any, WindowID(hwnd))
    
    If status_sb
      AddStatusBarField(150)
      AddStatusBarField(50)
      AddStatusBarField(90)
    EndIf
      
    slot_id = 0
    model_name.s = Space(4096)
    viGetAttribute(card_res, #VI_ATTR_SLOT, @slot_id)   
    viGetAttribute(card_res, #VI_ATTR_MODEL_NAME, @model_name)
    StatusBarText(status_sb, 0, model_name + "@Slot" + Str(slot_id))

    Select  bar
        Case  13
          StatusBarText(status_sb, 1, "BAR2")
        Case  11 
          StatusBarText(status_sb, 1, "BAR0")
        Case  14
          StatusBarText(status_sb, 1, "BAR3")
        Case  10
          StatusBarText(status_sb, 1, "CFG")
        Default
          StatusBarText(status_sb, 1, "unkown")
    EndSelect
         
    StatusBarText(status_sb, 2, "0x" + RSet(Hex(offset_address, #PB_Long), 8, "0"))
    
    AddWindowTimer(hwnd, 0, 500)
    AddKeyboardShortcut(hwnd, #PB_Shortcut_Escape, 100)
    AddKeyboardShortcut(hwnd, #PB_Shortcut_F5, 200)
    AddKeyboardShortcut(hwnd, #PB_Shortcut_F1, 300)
    
    toggle_flag.l = 1
    toggle_time.l = 100
    value.l = 0
    
    Repeat         
      Event.l = WaitWindowEvent()      
      Select  Event
        Case #PB_Event_Menu
          Select EventMenu()
            Case  300 ;help
              MessageBox_(GetFocus_(), "F5-toggle bit", "cv", #MB_OK|#MB_ICONINFORMATION|#MB_DEFBUTTON1|#MB_SYSTEMMODAL)
            Case  200 ;toggle bit
              If  toggle_flag
                dec_input(@toggle_time)
                AddWindowTimer(hwnd, 1, toggle_time)
                toggle_flag = 0
              Else
                RemoveWindowTimer(hwnd, 1)
                toggle_flag = 1
              EndIf
            Case  100 ;exit
              quit  = #True
            Case 1
              memory_bit_set(card_res, bar, offset_address, 31)             
            Case 2
              memory_bit_set(card_res, bar, offset_address, 30)
            Case 3
              memory_bit_set(card_res, bar, offset_address, 29)
            Case 4
              memory_bit_set(card_res, bar, offset_address, 28)
            Case 5
              memory_bit_set(card_res, bar, offset_address, 27)             
            Case 6
              memory_bit_set(card_res, bar, offset_address, 26)
            Case 7
              memory_bit_set(card_res, bar, offset_address, 25)
            Case 8
              memory_bit_set(card_res, bar, offset_address, 24)    
            ;----------------------------------------------------
            Case 9
              memory_bit_set(card_res, bar, offset_address, 23)             
            Case 10
              memory_bit_set(card_res, bar, offset_address, 22)
            Case 11
              memory_bit_set(card_res, bar, offset_address, 21)
            Case 12
              memory_bit_set(card_res, bar, offset_address, 20)
            Case 13
              memory_bit_set(card_res, bar, offset_address, 19)             
            Case 14
              memory_bit_set(card_res, bar, offset_address, 18)
            Case 15
              memory_bit_set(card_res, bar, offset_address, 17)
            Case 16
              memory_bit_set(card_res, bar, offset_address, 16)    
            ;----------------------------------------------------
            Case 17
              memory_bit_set(card_res, bar, offset_address, 15)             
            Case 18
              memory_bit_set(card_res, bar, offset_address, 14)
            Case 19
              memory_bit_set(card_res, bar, offset_address, 13)
            Case 20
              memory_bit_set(card_res, bar, offset_address, 12)
            Case 21
              memory_bit_set(card_res, bar, offset_address, 11)             
            Case 22
              memory_bit_set(card_res, bar, offset_address, 10)
            Case 23
              memory_bit_set(card_res, bar, offset_address, 9)
            Case 24
              memory_bit_set(card_res, bar, offset_address, 8)    
            ;----------------------------------------------------             
            Case 25
              memory_bit_set(card_res, bar, offset_address, 7)             
            Case 26
              memory_bit_set(card_res, bar, offset_address, 6)
            Case 27
              memory_bit_set(card_res, bar, offset_address, 5)
            Case 28
              memory_bit_set(card_res, bar, offset_address, 4)
            Case 29
              memory_bit_set(card_res, bar, offset_address, 3)             
            Case 30
              memory_bit_set(card_res, bar, offset_address, 2)
            Case 31
              memory_bit_set(card_res, bar, offset_address, 1)
            Case 32
              memory_bit_set(card_res, bar, offset_address, 0)    
            ;----------------------------------------------------             
            Case 33
              memory_bit_clear(card_res, bar, offset_address, 31)  
            Case 34
              memory_bit_clear(card_res, bar, offset_address, 30)    
            Case 35
              memory_bit_clear(card_res, bar, offset_address, 29)  
            Case 36
              memory_bit_clear(card_res, bar, offset_address, 28)    
            Case 37
              memory_bit_clear(card_res, bar, offset_address, 27)  
            Case 38
              memory_bit_clear(card_res, bar, offset_address, 26)    
            Case 39
              memory_bit_clear(card_res, bar, offset_address, 25)  
            Case 40
              memory_bit_clear(card_res, bar, offset_address, 24) 
            ;----------------------------------------------------
            Case 41
              memory_bit_clear(card_res, bar, offset_address, 23)  
            Case 42
              memory_bit_clear(card_res, bar, offset_address, 22)    
            Case 43
              memory_bit_clear(card_res, bar, offset_address, 21)  
            Case 44
              memory_bit_clear(card_res, bar, offset_address, 20)    
            Case 45
              memory_bit_clear(card_res, bar, offset_address, 19)  
            Case 46
              memory_bit_clear(card_res, bar, offset_address, 18)    
            Case 47
              memory_bit_clear(card_res, bar, offset_address, 17)  
            Case 48
              memory_bit_clear(card_res, bar, offset_address, 16) 
            ;----------------------------------------------------
            Case 49
              memory_bit_clear(card_res, bar, offset_address, 15)  
            Case 50
              memory_bit_clear(card_res, bar, offset_address, 14)    
            Case 51
              memory_bit_clear(card_res, bar, offset_address, 13)  
            Case 52
              memory_bit_clear(card_res, bar, offset_address, 12)    
            Case 53
              memory_bit_clear(card_res, bar, offset_address, 11)  
            Case 54
              memory_bit_clear(card_res, bar, offset_address, 10)    
            Case 55
              memory_bit_clear(card_res, bar, offset_address, 9)  
            Case 56
              memory_bit_clear(card_res, bar, offset_address, 8) 
            ;----------------------------------------------------             
            Case 57
              memory_bit_clear(card_res, bar, offset_address, 7)  
            Case 58
              memory_bit_clear(card_res, bar, offset_address, 6)    
            Case 59
              memory_bit_clear(card_res, bar, offset_address, 5)  
            Case 60
              memory_bit_clear(card_res, bar, offset_address, 4)    
            Case 61
              memory_bit_clear(card_res, bar, offset_address, 3)  
            Case 62
              memory_bit_clear(card_res, bar, offset_address, 2)    
            Case 63
              memory_bit_clear(card_res, bar, offset_address, 1)  
            Case 64
              memory_bit_clear(card_res, bar, offset_address, 0) 
            ;----------------------------------------------------                 
        EndSelect          
        Case #WM_RBUTTONDOWN
          DisplayPopupMenu(popup_menu, WindowID(hwnd))
        Case  #PB_Event_Gadget
          Select  EventGadget() 
            Case  lock_bg
              Delay(10)
              If  GetGadgetState(lock_bg)
                viLock(card_res, #VI_EXCLUSIVE_LOCK, 200, #VI_NULL, #VI_NULL)
              Else
                viUnlock(card_res)
              EndIf
            Case  top_bg
              Select EventType()
                Case #PB_EventType_LeftClick
                  Delay(10)
                  If  GetGadgetState(top_bg)
                    SetWindowPos_(WindowID(hwnd), #HWND_TOPMOST, 0, 0, 0, 0, #SWP_NOMOVE|#SWP_NOSIZE)
                  Else
                    SetWindowPos_(WindowID(hwnd), #HWND_NOTOPMOST, 0, 0, 0, 0, #SWP_NOMOVE|#SWP_NOSIZE)
                  EndIf 
                Case #PB_EventType_RightClick
                  ;
                Case #PB_EventType_LeftDoubleClick
                  ;
                Case #PB_EventType_RightDoubleClick
                  ;
                Case  #PB_EventType_Change
                  ;                  
              EndSelect                        
            Case  capture_bg
              CaptureWindow(GetWindowTitle(hwnd))
            Case  all_one_bg
              viOut32(card_res, bar, offset_address, Val("$FFFFFFFF"))  
            Case  none_one_bg
              viOut32(card_res, bar, offset_address, Val("$00000000"))
            Case  bit_bg0
              Select EventType()
                Case #PB_EventType_LeftClick
                  viIn32(card_res, bar, offset_address, @value)
                  If  BitTst(value, 0)
                    value = bitclr(value, 0)
                    viOut32(card_res, bar, offset_address, value)
                  Else
                    value = BitSet(value, 0)
                    viOut32(card_res, bar, offset_address, value)                
                  EndIf
                Case #PB_EventType_RightClick
                  ;
                Case #PB_EventType_LeftDoubleClick
                  ;
                Case #PB_EventType_RightDoubleClick
                  ;
              EndSelect          
            Case  bit_bg1
              Select EventType()
                Case #PB_EventType_LeftClick
                  viIn32(card_res, bar, offset_address, @value)
                  If  BitTst(value, 1)
                    value = bitclr(value, 1)
                    viOut32(card_res, bar, offset_address, value)
                  Else
                    value = BitSet(value, 1)
                    viOut32(card_res, bar, offset_address, value)                
                  EndIf
                Case #PB_EventType_RightClick
                  ;
                Case #PB_EventType_LeftDoubleClick
                  ;
                Case #PB_EventType_RightDoubleClick
                  ;
              EndSelect
            Case  bit_bg2
              Select EventType()
                Case #PB_EventType_LeftClick
                  viIn32(card_res, bar, offset_address, @value)
                  If  BitTst(value, 2)
                    value = bitclr(value, 2)
                    viOut32(card_res, bar, offset_address, value)
                  Else
                    value = BitSet(value, 2)
                    viOut32(card_res, bar, offset_address, value)                
                  EndIf
                Case #PB_EventType_RightClick
                  ;
                Case #PB_EventType_LeftDoubleClick
                  ;
                Case #PB_EventType_RightDoubleClick
                  ;
              EndSelect
            Case  bit_bg3
              Select EventType()
                Case #PB_EventType_LeftClick
                  viIn32(card_res, bar, offset_address, @value)
                  If  BitTst(value, 3)
                    value = bitclr(value, 3)
                    viOut32(card_res, bar, offset_address, value)
                  Else
                    value = BitSet(value, 3)
                    viOut32(card_res, bar, offset_address, value)                
                  EndIf
                Case #PB_EventType_RightClick
                  ;
                Case #PB_EventType_LeftDoubleClick
                  ;
                Case #PB_EventType_RightDoubleClick
                  ;
              EndSelect
            Case  bit_bg4
              Select EventType()
                Case #PB_EventType_LeftClick
                  viIn32(card_res, bar, offset_address, @value)
                  If  BitTst(value, 4)
                    value = bitclr(value, 4)
                    viOut32(card_res, bar, offset_address, value)
                  Else
                    value = BitSet(value, 4)
                    viOut32(card_res, bar, offset_address, value)                
                  EndIf
                Case #PB_EventType_RightClick
                  ;
                Case #PB_EventType_LeftDoubleClick
                  ;
                Case #PB_EventType_RightDoubleClick
                  ;
              EndSelect
            Case  bit_bg5
              Select EventType()
                Case #PB_EventType_LeftClick
                  viIn32(card_res, bar, offset_address, @value)
                  If  BitTst(value, 5)
                    value = bitclr(value, 5)
                    viOut32(card_res, bar, offset_address, value)
                  Else
                    value = BitSet(value, 5)
                    viOut32(card_res, bar, offset_address, value)                
                  EndIf
                Case #PB_EventType_RightClick
                  ;
                Case #PB_EventType_LeftDoubleClick
                  ;
                Case #PB_EventType_RightDoubleClick
                  ;
              EndSelect 
            Case  bit_bg6
              Select EventType()
                Case #PB_EventType_LeftClick
                  viIn32(card_res, bar, offset_address, @value)
                  If  BitTst(value, 6)
                    value = bitclr(value, 6)
                    viOut32(card_res, bar, offset_address, value)
                  Else
                    value = BitSet(value, 6)
                    viOut32(card_res, bar, offset_address, value)                
                  EndIf
                Case #PB_EventType_RightClick
                  ;
                Case #PB_EventType_LeftDoubleClick
                  ;
                Case #PB_EventType_RightDoubleClick
                  ;
              EndSelect
            Case  bit_bg7
              Select EventType()
                Case #PB_EventType_LeftClick
                  viIn32(card_res, bar, offset_address, @value)
                  If  BitTst(value, 7)
                    value = bitclr(value, 7)
                    viOut32(card_res, bar, offset_address, value)
                  Else
                    value = BitSet(value, 7)
                    viOut32(card_res, bar, offset_address, value)                
                  EndIf
                Case #PB_EventType_RightClick
                  ;
                Case #PB_EventType_LeftDoubleClick
                  ;
                Case #PB_EventType_RightDoubleClick
                  ;
              EndSelect
            Case  bit_bg8
              Select EventType()
                Case #PB_EventType_LeftClick
                  viIn32(card_res, bar, offset_address, @value)
                  If  BitTst(value, 8)
                    value = bitclr(value, 8)
                    viOut32(card_res, bar, offset_address, value)
                  Else
                    value = BitSet(value, 8)
                    viOut32(card_res, bar, offset_address, value)                
                  EndIf
                Case #PB_EventType_RightClick
                  ;
                Case #PB_EventType_LeftDoubleClick
                  ;
                Case #PB_EventType_RightDoubleClick
                  ;
              EndSelect
            Case  bit_bg9
              Select EventType()
                Case #PB_EventType_LeftClick
                  viIn32(card_res, bar, offset_address, @value)
                  If  BitTst(value, 9)
                    value = bitclr(value, 9)
                    viOut32(card_res, bar, offset_address, value)
                  Else
                    value = BitSet(value, 9)
                    viOut32(card_res, bar, offset_address, value)                
                  EndIf
                Case #PB_EventType_RightClick
                  ;
                Case #PB_EventType_LeftDoubleClick
                  ;
                Case #PB_EventType_RightDoubleClick
                  ;
              EndSelect
            Case  bit_bg10
              Select EventType()
                Case #PB_EventType_LeftClick
                  viIn32(card_res, bar, offset_address, @value)
                  If  BitTst(value, 10)
                    value = bitclr(value, 10)
                    viOut32(card_res, bar, offset_address, value)
                  Else
                    value = BitSet(value, 10)
                    viOut32(card_res, bar, offset_address, value)                
                  EndIf
                Case #PB_EventType_RightClick
                  ;
                Case #PB_EventType_LeftDoubleClick
                  ;
                Case #PB_EventType_RightDoubleClick
                  ;
              EndSelect
            Case  bit_bg11
              Select EventType()
                Case #PB_EventType_LeftClick
                  viIn32(card_res, bar, offset_address, @value)
                  If  BitTst(value, 11)
                    value = bitclr(value, 11)
                    viOut32(card_res, bar, offset_address, value)
                  Else
                    value = BitSet(value, 11)
                    viOut32(card_res, bar, offset_address, value)                
                  EndIf
                Case #PB_EventType_RightClick
                  ;
                Case #PB_EventType_LeftDoubleClick
                  ;
                Case #PB_EventType_RightDoubleClick
                  ;
              EndSelect
            Case  bit_bg12
              Select EventType()
                Case #PB_EventType_LeftClick
                  viIn32(card_res, bar, offset_address, @value)
                  If  BitTst(value, 12)
                    value = bitclr(value, 12)
                    viOut32(card_res, bar, offset_address, value)
                  Else
                    value = BitSet(value, 12)
                    viOut32(card_res, bar, offset_address, value)                
                  EndIf
                Case #PB_EventType_RightClick
                  ;
                Case #PB_EventType_LeftDoubleClick
                  ;
                Case #PB_EventType_RightDoubleClick
                  ;
              EndSelect
            Case  bit_bg13
              Select EventType()
                Case #PB_EventType_LeftClick
                  viIn32(card_res, bar, offset_address, @value)
                  If  BitTst(value, 13)
                    value = bitclr(value, 13)
                    viOut32(card_res, bar, offset_address, value)
                  Else
                    value = BitSet(value, 13)
                    viOut32(card_res, bar, offset_address, value)                
                  EndIf
                Case #PB_EventType_RightClick
                  ;
                Case #PB_EventType_LeftDoubleClick
                  ;
                Case #PB_EventType_RightDoubleClick
                  ;
              EndSelect
            Case  bit_bg14
              Select EventType()
                Case #PB_EventType_LeftClick
                  viIn32(card_res, bar, offset_address, @value)
                  If  BitTst(value, 14)
                    value = bitclr(value, 14)
                    viOut32(card_res, bar, offset_address, value)
                  Else
                    value = BitSet(value, 14)
                    viOut32(card_res, bar, offset_address, value)                
                  EndIf
                Case #PB_EventType_RightClick
                  ;
                Case #PB_EventType_LeftDoubleClick
                  ;
                Case #PB_EventType_RightDoubleClick
                  ;
              EndSelect  
            Case  bit_bg15
              Select EventType()
                Case #PB_EventType_LeftClick
                  viIn32(card_res, bar, offset_address, @value)
                  If  BitTst(value, 15)
                    value = bitclr(value, 15)
                    viOut32(card_res, bar, offset_address, value)
                  Else
                    value = BitSet(value, 15)
                    viOut32(card_res, bar, offset_address, value)                
                  EndIf
                Case #PB_EventType_RightClick
                  ;
                Case #PB_EventType_LeftDoubleClick
                  ;
                Case #PB_EventType_RightDoubleClick
                  ;
              EndSelect
            Case  bit_bg16
              Select EventType()
                Case #PB_EventType_LeftClick
                  viIn32(card_res, bar, offset_address, @value)
                  If  BitTst(value, 16)
                    value = bitclr(value, 16)
                    viOut32(card_res, bar, offset_address, value)
                  Else
                    value = BitSet(value, 16)
                    viOut32(card_res, bar, offset_address, value)                
                  EndIf
                Case #PB_EventType_RightClick
                  ;
                Case #PB_EventType_LeftDoubleClick
                  ;
                Case #PB_EventType_RightDoubleClick
                  ;
              EndSelect
            Case  bit_bg17
              Select EventType()
                Case #PB_EventType_LeftClick
                  viIn32(card_res, bar, offset_address, @value)
                  If  BitTst(value, 17)
                    value = bitclr(value, 17)
                    viOut32(card_res, bar, offset_address, value)
                  Else
                    value = BitSet(value, 17)
                    viOut32(card_res, bar, offset_address, value)                
                  EndIf
                Case #PB_EventType_RightClick
                  ;
                Case #PB_EventType_LeftDoubleClick
                  ;
                Case #PB_EventType_RightDoubleClick
                  ;
              EndSelect 
            Case  bit_bg18
              Select EventType()
                Case #PB_EventType_LeftClick
                  viIn32(card_res, bar, offset_address, @value)
                  If  BitTst(value, 18)
                    value = bitclr(value, 18)
                    viOut32(card_res, bar, offset_address, value)
                  Else
                    value = BitSet(value, 18)
                    viOut32(card_res, bar, offset_address, value)                
                  EndIf
                Case #PB_EventType_RightClick
                  ;
                Case #PB_EventType_LeftDoubleClick
                  ;
                Case #PB_EventType_RightDoubleClick
                  ;
              EndSelect
            Case  bit_bg19
              Select EventType()
                Case #PB_EventType_LeftClick
                  viIn32(card_res, bar, offset_address, @value)
                  If  BitTst(value, 19)
                    value = bitclr(value, 19)
                    viOut32(card_res, bar, offset_address, value)
                  Else
                    value = BitSet(value, 19)
                    viOut32(card_res, bar, offset_address, value)                
                  EndIf
                Case #PB_EventType_RightClick
                  ;
                Case #PB_EventType_LeftDoubleClick
                  ;
                Case #PB_EventType_RightDoubleClick
                  ;
              EndSelect
            Case  bit_bg20
              Select EventType()
                Case #PB_EventType_LeftClick
                  viIn32(card_res, bar, offset_address, @value)
                  If  BitTst(value, 20)
                    value = bitclr(value, 20)
                    viOut32(card_res, bar, offset_address, value)
                  Else
                    value = BitSet(value, 20)
                    viOut32(card_res, bar, offset_address, value)                
                  EndIf
                Case #PB_EventType_RightClick
                  ;
                Case #PB_EventType_LeftDoubleClick
                  ;
                Case #PB_EventType_RightDoubleClick
                  ;
              EndSelect  
            Case  bit_bg21
              Select EventType()
                Case #PB_EventType_LeftClick
                  viIn32(card_res, bar, offset_address, @value)
                  If  BitTst(value, 21)
                    value = bitclr(value, 21)
                    viOut32(card_res, bar, offset_address, value)
                  Else
                    value = BitSet(value, 21)
                    viOut32(card_res, bar, offset_address, value)                
                  EndIf
                Case #PB_EventType_RightClick
                  ;
                Case #PB_EventType_LeftDoubleClick
                  ;
                Case #PB_EventType_RightDoubleClick
                  ;
              EndSelect
            Case  bit_bg22
              Select EventType()
                Case #PB_EventType_LeftClick
                  viIn32(card_res, bar, offset_address, @value)
                  If  BitTst(value, 22)
                    value = bitclr(value, 22)
                    viOut32(card_res, bar, offset_address, value)
                  Else
                    value = BitSet(value, 22)
                    viOut32(card_res, bar, offset_address, value)                
                  EndIf
                Case #PB_EventType_RightClick
                  ;
                Case #PB_EventType_LeftDoubleClick
                  ;
                Case #PB_EventType_RightDoubleClick
                  ;
              EndSelect
            Case  bit_bg23
              Select EventType()
                Case #PB_EventType_LeftClick
                  viIn32(card_res, bar, offset_address, @value)
                  If  BitTst(value, 23)
                    value = bitclr(value, 23)
                    viOut32(card_res, bar, offset_address, value)
                  Else
                    value = BitSet(value, 23)
                    viOut32(card_res, bar, offset_address, value)                
                  EndIf
                Case #PB_EventType_RightClick
                  ;
                Case #PB_EventType_LeftDoubleClick
                  ;
                Case #PB_EventType_RightDoubleClick
                  ;
              EndSelect 
            Case  bit_bg24
              Select EventType()
                Case #PB_EventType_LeftClick
                  viIn32(card_res, bar, offset_address, @value)
                  If  BitTst(value, 24)
                    value = bitclr(value, 24)
                    viOut32(card_res, bar, offset_address, value)
                  Else
                    value = BitSet(value, 24)
                    viOut32(card_res, bar, offset_address, value)                
                  EndIf
                Case #PB_EventType_RightClick
                  ;
                Case #PB_EventType_LeftDoubleClick
                  ;
                Case #PB_EventType_RightDoubleClick
                  ;
              EndSelect
            Case  bit_bg25
              Select EventType()
                Case #PB_EventType_LeftClick
                  viIn32(card_res, bar, offset_address, @value)
                  If  BitTst(value, 25)
                    value = bitclr(value, 25)
                    viOut32(card_res, bar, offset_address, value)
                  Else
                    value = BitSet(value, 25)
                    viOut32(card_res, bar, offset_address, value)                
                  EndIf
                Case #PB_EventType_RightClick
                  ;
                Case #PB_EventType_LeftDoubleClick
                  ;
                Case #PB_EventType_RightDoubleClick
                  ;
              EndSelect
            Case  bit_bg26
              Select EventType()
                Case #PB_EventType_LeftClick
                  viIn32(card_res, bar, offset_address, @value)
                  If  BitTst(value, 26)
                    value = bitclr(value, 26)
                    viOut32(card_res, bar, offset_address, value)
                  Else
                    value = BitSet(value, 26)
                    viOut32(card_res, bar, offset_address, value)                
                  EndIf
                Case #PB_EventType_RightClick
                  ;
                Case #PB_EventType_LeftDoubleClick
                  ;
                Case #PB_EventType_RightDoubleClick
                  ;
              EndSelect
            Case  bit_bg27
              Select EventType()
                Case #PB_EventType_LeftClick
                  viIn32(card_res, bar, offset_address, @value)
                  If  BitTst(value, 27)
                    value = bitclr(value, 27)
                    viOut32(card_res, bar, offset_address, value)
                  Else
                    value = BitSet(value, 27)
                    viOut32(card_res, bar, offset_address, value)                
                  EndIf
                Case #PB_EventType_RightClick
                  ;
                Case #PB_EventType_LeftDoubleClick
                  ;
                Case #PB_EventType_RightDoubleClick
                  ;
              EndSelect
            Case  bit_bg28
              Select EventType()
                Case #PB_EventType_LeftClick
                  viIn32(card_res, bar, offset_address, @value)
                  If  BitTst(value, 28)
                    value = bitclr(value, 28)
                    viOut32(card_res, bar, offset_address, value)
                  Else
                    value = BitSet(value, 28)
                    viOut32(card_res, bar, offset_address, value)                
                  EndIf
                Case #PB_EventType_RightClick
                  ;
                Case #PB_EventType_LeftDoubleClick
                  ;
                Case #PB_EventType_RightDoubleClick
                  ;
              EndSelect
            Case  bit_bg29
              Select EventType()
                Case #PB_EventType_LeftClick
                  viIn32(card_res, bar, offset_address, @value)
                  If  BitTst(value, 29)
                    value = bitclr(value, 29)
                    viOut32(card_res, bar, offset_address, value)
                  Else
                    value = BitSet(value, 29)
                    viOut32(card_res, bar, offset_address, value)                
                  EndIf
                Case #PB_EventType_RightClick
                  ;
                Case #PB_EventType_LeftDoubleClick
                  ;
                Case #PB_EventType_RightDoubleClick
                  ;
              EndSelect  
            Case  bit_bg30
              Select EventType()
                Case #PB_EventType_LeftClick
                  viIn32(card_res, bar, offset_address, @value)
                  If  BitTst(value, 30)
                    value = bitclr(value, 30)
                    viOut32(card_res, bar, offset_address, value)
                  Else
                    value = BitSet(value, 30)
                    viOut32(card_res, bar, offset_address, value)                
                  EndIf
                Case #PB_EventType_RightClick
                  ;
                Case #PB_EventType_LeftDoubleClick
                  ;
                Case #PB_EventType_RightDoubleClick
                  ;
              EndSelect
            Case  bit_bg31
              Select EventType()
                Case #PB_EventType_LeftClick
                  viIn32(card_res, bar, offset_address, @value)
                  If  BitTst(value, 31)
                    value = bitclr(value, 31)
                    viOut32(card_res, bar, offset_address, value)
                  Else
                    value = BitSet(value, 31)
                    viOut32(card_res, bar, offset_address, value)                
                  EndIf
                Case #PB_EventType_RightClick
                  ;
                Case #PB_EventType_LeftDoubleClick
                  ;
                Case #PB_EventType_RightDoubleClick
                  ;
              EndSelect
            Default
              ;
          EndSelect
        Case  #PB_Event_Timer
          Select  EventTimer()
            Case  0
              viIn32(card_res, bar, offset_address, @value)
              
              SetGadgetText(value_sg, RSet(Hex(value, #PB_Long), 8, "0"))
              
              SetGadgetState(bit_bg0, BitTst(value, 0))
              SetGadgetState(bit_bg1, BitTst(value, 1))
              SetGadgetState(bit_bg2, BitTst(value, 2))
              SetGadgetState(bit_bg3, BitTst(value, 3))    
              SetGadgetState(bit_bg4, BitTst(value, 4))
              SetGadgetState(bit_bg5, BitTst(value, 5))
              SetGadgetState(bit_bg6, BitTst(value, 6))
              SetGadgetState(bit_bg7, BitTst(value, 7))
              
              SetGadgetState(bit_bg8, BitTst(value, 8))
              SetGadgetState(bit_bg9, BitTst(value, 9))
              SetGadgetState(bit_bg10, BitTst(value, 10))
              SetGadgetState(bit_bg11, BitTst(value, 11))    
              SetGadgetState(bit_bg12, BitTst(value, 12))
              SetGadgetState(bit_bg13, BitTst(value, 13))
              SetGadgetState(bit_bg14, BitTst(value, 14))
              SetGadgetState(bit_bg15, BitTst(value, 15)) 
              
              SetGadgetState(bit_bg16, BitTst(value, 16))
              SetGadgetState(bit_bg17, BitTst(value, 17))
              SetGadgetState(bit_bg18, BitTst(value, 18))
              SetGadgetState(bit_bg19, BitTst(value, 19))    
              SetGadgetState(bit_bg20, BitTst(value, 20))
              SetGadgetState(bit_bg21, BitTst(value, 21))
              SetGadgetState(bit_bg22, BitTst(value, 22))
              SetGadgetState(bit_bg23, BitTst(value, 23)) 
              
              SetGadgetState(bit_bg24, BitTst(value, 24))
              SetGadgetState(bit_bg25, BitTst(value, 25))
              SetGadgetState(bit_bg26, BitTst(value, 26))
              SetGadgetState(bit_bg27, BitTst(value, 27))    
              SetGadgetState(bit_bg28, BitTst(value, 28))
              SetGadgetState(bit_bg29, BitTst(value, 29))
              SetGadgetState(bit_bg30, BitTst(value, 30))
              SetGadgetState(bit_bg31, BitTst(value, 31))    
            Case  1
              If  GetActiveWindow() = hwnd
                Select  GetActiveGadget()
                  Case  bit_bg0, bit_bg1, bit_bg2, bit_bg3, bit_bg4, bit_bg5, bit_bg6, bit_bg7, all_one_bg, none_one_bg
                    keybd_event_(#VK_SPACE,0,0,0)           
                    keybd_event_(#VK_SPACE,0,#KEYEVENTF_KEYUP,0)
                  Case  bit_bg8, bit_bg9, bit_bg10, bit_bg11, bit_bg12, bit_bg13, bit_bg14, bit_bg15
                    keybd_event_(#VK_SPACE,0,0,0)           
                    keybd_event_(#VK_SPACE,0,#KEYEVENTF_KEYUP,0)
                  Case  bit_bg16, bit_bg17, bit_bg18, bit_bg19, bit_bg20, bit_bg21, bit_bg22, bit_bg23
                    keybd_event_(#VK_SPACE,0,0,0)           
                    keybd_event_(#VK_SPACE,0,#KEYEVENTF_KEYUP,0)
                  Case  bit_bg24, bit_bg25, bit_bg26, bit_bg27, bit_bg28, bit_bg29, bit_bg30, bit_bg31
                    keybd_event_(#VK_SPACE,0,0,0)           
                    keybd_event_(#VK_SPACE,0,#KEYEVENTF_KEYUP,0)                    
                EndSelect
              EndIf
          EndSelect
        Default
          ;
      EndSelect
    Until Event = #PB_Event_CloseWindow Or  quit  = #True  
    
    RemoveWindowTimer(hwnd, 0)    
    CloseWindow(hwnd)
    
    viDisableEvent(card_res, #VI_ALL_ENABLED_EVENTS, #VI_ALL_MECH)
    viUninstallHandler(card_res, #VI_EVENT_EXCEPTION, @visa32_error_handler(), hwnd)    
       
    viClose(card_res)
    viClose(visa_default)    
    
  EndProcedure   
  
  ProcedureDLL plx9054_dma_spy(*card)
  
    Dim card_array.card_info(16)
    
    card_array.card_info(0)\card  = *card
    card_array.card_info(0)\bar  = #VI_PXI_BAR0_SPACE
    card_array.card_info(0)\offset_address  = #PCI9054_DMAMODE0    
    card_array.card_info(0)\x  = 10
    card_array.card_info(0)\y  = 10
    card_array.card_info(0)\title  = @"DMAMODE0"
    
    card_array.card_info(1)\card  = *card
    card_array.card_info(1)\bar  = #VI_PXI_BAR0_SPACE
    card_array.card_info(1)\offset_address  = #PCI9054_DMAPADR0    
    card_array.card_info(1)\x  = 10
    card_array.card_info(1)\y  = 200
    card_array.card_info(1)\title  = @"DMAPADR0"  
    
    card_array.card_info(2)\card  = *card
    card_array.card_info(2)\bar  = #VI_PXI_BAR0_SPACE
    card_array.card_info(2)\offset_address  = #PCI9054_DMALADR0    
    card_array.card_info(2)\x  = 10
    card_array.card_info(2)\y  = 340
    card_array.card_info(2)\title  = @"DMALADR0"  
    
    card_array.card_info(3)\card  = *card
    card_array.card_info(3)\bar  = #VI_PXI_BAR0_SPACE
    card_array.card_info(3)\offset_address  = #PCI9054_DMASIZ0    
    card_array.card_info(3)\x  = 10
    card_array.card_info(3)\y  = 480
    card_array.card_info(3)\title  = @"DMASIZ0"  
    
    card_array.card_info(4)\card  = *card
    card_array.card_info(4)\bar  = #VI_PXI_BAR0_SPACE
    card_array.card_info(4)\offset_address  = #PCI9054_DMADPR0    
    card_array.card_info(4)\x  = 10
    card_array.card_info(4)\y  = 620
    card_array.card_info(4)\title  = @"DMADPR0"   
    
    card_array.card_info(5)\card  = *card
    card_array.card_info(5)\bar  = #VI_PXI_BAR0_SPACE
    card_array.card_info(5)\offset_address  = #PCI9054_DMAMODE1    
    card_array.card_info(5)\x  = 320
    card_array.card_info(5)\y  = 10
    card_array.card_info(5)\title  = @"DMAMODE1"
    
    card_array.card_info(6)\card  = *card
    card_array.card_info(6)\bar  = #VI_PXI_BAR0_SPACE
    card_array.card_info(6)\offset_address  = #PCI9054_DMAPADR1    
    card_array.card_info(6)\x  = 320
    card_array.card_info(6)\y  = 200
    card_array.card_info(6)\title  = @"DMAPADR1"  
    
    card_array.card_info(7)\card  = *card
    card_array.card_info(7)\bar  = #VI_PXI_BAR0_SPACE
    card_array.card_info(7)\offset_address  = #PCI9054_DMALADR1    
    card_array.card_info(7)\x  = 320
    card_array.card_info(7)\y  = 340
    card_array.card_info(7)\title  = @"DMALADR1"  
    
    card_array.card_info(8)\card  = *card
    card_array.card_info(8)\bar  = #VI_PXI_BAR0_SPACE
    card_array.card_info(8)\offset_address  = #PCI9054_DMASIZ1    
    card_array.card_info(8)\x  = 320
    card_array.card_info(8)\y  = 480
    card_array.card_info(8)\title  = @"DMASIZ1"  
    
    card_array.card_info(9)\card  = *card
    card_array.card_info(9)\bar  = #VI_PXI_BAR0_SPACE
    card_array.card_info(9)\offset_address  = #PCI9054_DMADPR1    
    card_array.card_info(9)\x  = 320
    card_array.card_info(9)\y  = 620
    card_array.card_info(9)\title  = @"DMADPR1"
    
    card_array.card_info(10)\card  = *card
    card_array.card_info(10)\bar  = #VI_PXI_BAR0_SPACE
    card_array.card_info(10)\offset_address  = #PCI9054_DMACSR0_DMACSR1    
    card_array.card_info(10)\x  = 630
    card_array.card_info(10)\y  = 10
    card_array.card_info(10)\title  = @"DMACSR0 & DMACSR1"
    
    card_array.card_info(11)\card  = *card
    card_array.card_info(11)\bar  = #VI_PXI_BAR0_SPACE
    card_array.card_info(11)\offset_address  = #PCI9054_DMAARB    
    card_array.card_info(11)\x  = 630
    card_array.card_info(11)\y  = 200
    card_array.card_info(11)\title  = @"DMAARB"  
    
    card_array.card_info(12)\card  = *card
    card_array.card_info(12)\bar  = #VI_PXI_BAR0_SPACE
    card_array.card_info(12)\offset_address  = #PCI9054_DMATHR    
    card_array.card_info(12)\x  = 630
    card_array.card_info(12)\y  = 390
    card_array.card_info(12)\title  = @"DMATHR"  
    
    card_array.card_info(13)\card  = *card
    card_array.card_info(13)\bar  = #VI_PXI_BAR0_SPACE
    card_array.card_info(13)\offset_address  = #PCI9054_DMADAC0    
    card_array.card_info(13)\x  = 940
    card_array.card_info(13)\y  = 200
    card_array.card_info(13)\title  = @"DMADAC0"  
    
    card_array.card_info(14)\card  = *card
    card_array.card_info(14)\bar  = #VI_PXI_BAR0_SPACE
    card_array.card_info(14)\offset_address  = #PCI9054_DMADAC1    
    card_array.card_info(14)\x  = 940
    card_array.card_info(14)\y  = 340
    card_array.card_info(14)\title  = @"DMADAC1"  
    
    card_array.card_info(15)\card  = *card
    card_array.card_info(15)\bar  = #VI_PXI_BAR0_SPACE
    card_array.card_info(15)\offset_address  = #PCI9054_INTCSR    
    card_array.card_info(15)\x  = 940
    card_array.card_info(15)\y  = 10
    card_array.card_info(15)\title  = @"INTCSR"  
    
    card_array.card_info(16)\card  = *card
    card_array.card_info(16)\x  = 940
    card_array.card_info(16)\y  = 480
    card_array.card_info(16)\title  = @"aaaaaaaaaaaaaa"     
    
    thread1 = CreateThread(@pxi_bit_access(), @card_array() + 0*SizeOf(card_info)) 
    thread2 = CreateThread(@pxi_register_access(), @card_array()  + 1*SizeOf(card_info))
    thread3 = CreateThread(@pxi_register_access(), @card_array()  + 2*SizeOf(card_info))
    thread4 = CreateThread(@pxi_register_access(), @card_array()  + 3*SizeOf(card_info))
    thread5 = CreateThread(@pxi_register_access(), @card_array()  + 4*SizeOf(card_info))

    thread6 = CreateThread(@pxi_bit_access(), @card_array()  + 5*SizeOf(card_info)) 
    thread7 = CreateThread(@pxi_register_access(), @card_array()  + 6*SizeOf(card_info))
    thread8 = CreateThread(@pxi_register_access(), @card_array()  + 7*SizeOf(card_info))
    thread9 = CreateThread(@pxi_register_access(), @card_array()  + 8*SizeOf(card_info))
    thread10 = CreateThread(@pxi_register_access(), @card_array()  + 9*SizeOf(card_info))
    
    thread11  = CreateThread(@pxi_bit_access(), @card_array()  + 10*SizeOf(card_info)) 
    thread12  = CreateThread(@pxi_bit_access(), @card_array()  + 11*SizeOf(card_info))
    thread13  = CreateThread(@pxi_register_access(), @card_array()  + 12*SizeOf(card_info))
    thread14  = CreateThread(@pxi_register_access(), @card_array()  + 13*SizeOf(card_info))
    thread15  = CreateThread(@pxi_register_access(), @card_array()  + 14*SizeOf(card_info))
    
    thread16  = CreateThread(@pxi_bit_access(), @card_array()  + 15*SizeOf(card_info)) 
    
    thread17  = CreateThread(@plx9054_reset_card_gui(), @card_array()  + 16*SizeOf(card_info))
    
    WaitThread(thread1)    
    WaitThread(thread2)   
    WaitThread(thread3)    
    WaitThread(thread4)
    WaitThread(thread5)
    WaitThread(thread6)    
    WaitThread(thread7)
    WaitThread(thread8)
    WaitThread(thread9)
    WaitThread(thread10) 
    WaitThread(thread11)
    WaitThread(thread12)
    WaitThread(thread13)
    WaitThread(thread14) 
    WaitThread(thread15)
    WaitThread(thread16)
    WaitThread(thread17)
    
  EndProcedure
  
  ProcedureDLL.l plx9054_reset_card(card_res)
    
    Define  status.q
    viGetAttribute(card_res, #VI_ATTR_RSRC_LOCK_STATE, @status)
    If  (1 =  status)
      MessageBox_(GetFocus_(), "RSRC locked already!Abort reset card!", "cccc", #MB_ICONERROR|#MB_SYSTEMMODAL)
      ProcedureReturn #False
    Else
      viLock(card_res, #VI_EXCLUSIVE_LOCK, 200, #VI_NULL, #VI_NULL)
      memory_bit_set(card_res, #VI_PXI_BAR0_SPACE, #PCI9054_CNTRL, 30)  ;software reset
      Delay(5)
      memory_bit_clear(card_res, #VI_PXI_BAR0_SPACE, #PCI9054_CNTRL, 30)
      Delay(5)    
      memory_bit_set(card_res, #VI_PXI_BAR0_SPACE, #PCI9054_CNTRL, 29)  ;reload eeprom
      Delay(5)
      memory_bit_clear(card_res, #VI_PXI_BAR0_SPACE, #PCI9054_CNTRL, 29)
      Delay(5)    
      viUnlock(card_res)
    EndIf
    
    ProcedureReturn #True
    
  EndProcedure   

  ProcedureDLL.l plx9054_reset_card_gui(*card_info)
        
    *card = PeekL(*card_info)   ;read 4byte
    x.l = PeekL(*card_info  + 12) ;read 4byte
    y.l = PeekL(*card_info  + 16) ;read 4byte
    
    Protected visa_default.q  = 0
    viOpenDefaultRM(@visa_default)
        
    Protected card_res.q  = 0
    result  = viOpen(visa_default, *card, #VI_NO_LOCK, 1000, @card_res)  
    
    If result <> #VI_SUCCESS
      MessageBox_(GetFocus_(), "error resource open!" + Chr(10) + PeekS(*card, -1, #PB_Ascii), "..cv..", #MB_OK | #MB_ICONERROR|#MB_SYSTEMMODAL)
      ProcedureReturn #False
    EndIf    
      
    card3  = CatchImage(#PB_Any, ?card3)   
    Protected hwnd  = OpenWindow(#PB_Any, x, y, 150, 46, "Reset Card", #PB_Window_SystemMenu)
    
    viInstallHandler(card_res, #VI_EVENT_EXCEPTION, @visa32_error_handler(), hwnd)
    viEnableEvent(card_res, #VI_EVENT_EXCEPTION, #VI_HNDLR, #VI_NULL)    
    
    slot_id.q = 0
    viGetAttribute(card_res, #VI_ATTR_SLOT, @slot_id)    
    
    SetWindowPos_(WindowID(hwnd), #HWND_TOPMOST, 0, 0, 0, 0, #SWP_NOMOVE|#SWP_NOSIZE)
    SendMessage_(WindowID(hwnd), #WM_SETICON, #ICON_SMALL, ImageID(card3))
    SmartWindowRefresh(hwnd, 1)     
       If OSVersion < #PB_OS_Windows_7
     ;
   Else
     SkinH_SetAero(WindowID(hwnd))
   EndIf
    SetWindowTitle(hwnd, "slot" + Str(slot_id))
    
    reset_bg  = ButtonImageGadget(#PB_Any, 5, 5, 36, 36, ImageID(card3))
    tips_tg = TextGadget(#PB_Any, 46, 5, 100, 36, "<--Click To Reset Card", #PB_Text_Border)
    SetGadgetColor(tips_tg, #PB_Gadget_FrontColor, RGB(00, $FF, 00))
    SetGadgetColor(tips_tg, #PB_Gadget_BackColor, RGB(00, 00, 00))
    
    big_font1  = LoadFont(#PB_Any,"Courier",14, #PB_Font_Bold|#PB_Font_HighQuality)
    SetGadgetFont(tips_tg, FontID(big_font1))    
    
    Repeat
      Event.l = WaitWindowEvent()
      Select  Event
        Case  #PB_Event_Gadget
          Select  EventGadget()
            Case  reset_bg
              plx9054_reset_card(card_res)
              MessageBox_(GetFocus_(), "-=cv=- 2012.8" + Chr(13) + Chr(10) + "plx9054 card@slot" + Str(slot_id) + " reset ok!", "..cv..", #MB_OK | #MB_ICONINFORMATION|#MB_SYSTEMMODAL)
          EndSelect
      EndSelect
    Until Event = #PB_Event_CloseWindow Or  quit  = #True    
    
    CloseWindow(hwnd) 
    
    viDisableEvent(card_res, #VI_ALL_ENABLED_EVENTS, #VI_ALL_MECH)
    viUninstallHandler(card_res, #VI_EVENT_EXCEPTION, @visa32_error_handler(), hwnd)    
    
    viClose(card_res)
    viClose(visa_default) 
    
  EndProcedure   
  
  ProcedureDLL.l  is_plx9054_exist(*card)
    
    visa_default.q  = 0
    viOpenDefaultRM(@visa_default)
    
    card_res.q  = 0
    viOpen(visa_default, *card, #VI_NO_LOCK, 1000, @card_res) 
    
    value.q = 0
    viIn32(card_res, #VI_PXI_BAR0_SPACE, #PCI9054_PCIHIDR, @value)
    
    viClose(card_res)
    viClose(visa_default) 
    
    If  $905410b5 = value
      MessageBox_(GetFocus_(), "-=cv=- 2012.8" + Chr(13) + Chr(10) + PeekS(*card, -1, #PB_Ascii) + Chr(13) + Chr(10) + "使用了PLX9054桥芯片！", "..cv..", #MB_OK | #MB_ICONINFORMATION|#MB_SYSTEMMODAL)
      ProcedureReturn #True  
    Else
      MessageBox_(GetFocus_(), "-=cv=- 2012.8" + Chr(13) + Chr(10) + PeekS(*card, -1, #PB_Ascii) + Chr(13) + Chr(10) + "没有使用PLX9054芯片，或者由于FPGA导致读取PLX9054寄存器出错！" + " or resource is locked by others", "..cv..", #MB_OK | #MB_ICONERROR|#MB_SYSTEMMODAL)      
      ProcedureReturn #False
    EndIf    
      
  EndProcedure  
  
  ProcedureDLL.l  is_plx9054_eeprom_exist(*card)
    
    visa_default.q  = 0
    viOpenDefaultRM(@visa_default)
    
    card_res.q  = 0
    viOpen(visa_default, *card, #VI_NO_LOCK, 1000, @card_res) 
    
    value.q = 0
    viIn32(card_res, #VI_PXI_BAR0_SPACE, #PCI9054_CNTRL, @value)
        
    viClose(card_res)
    viClose(visa_default)      
    
    If  #True = BitTst(value, 28)
      MessageBox_(GetFocus_(), "-=cv=- 2012.8" + Chr(13) + Chr(10) + PeekS(*card, -1, #PB_Ascii) + Chr(13) + Chr(10) + "存在EEPROM，刷写EEPROM风险自负！", "..cv..", #MB_OK | #MB_ICONINFORMATION|#MB_SYSTEMMODAL)
      ProcedureReturn #True  
    Else
      MessageBox_(GetFocus_(), "-=cv=- 2012.8" + Chr(13) + Chr(10) + PeekS(*card, -1, #PB_Ascii) + Chr(13) + Chr(10) + "未发现EEPROM" + " or resource is locked by others", "..cv..", #MB_OK | #MB_ICONERROR|#MB_SYSTEMMODAL)      
      ProcedureReturn #False
    EndIf       
      
  EndProcedure
  
  ProcedureDLL  plx9054_read_eeprom_32(card_res, offset_address, *new_data)
        
    While 1
      viOut32(card_res, #VI_PXI_CFG_SPACE, #PCI9054_PVPDCNTL, offset_address<<16)
      Delay(30)
      test_value.l  = 0
      viIn32(card_res, #VI_PXI_CFG_SPACE, #PCI9054_PVPDCNTL, @test_value)
      If  BitTst(test_value, 31)  = #True
        Break
      EndIf
      Delay(10)
    Wend
    
    viIn32(card_res, #VI_PXI_CFG_SPACE, #PCI9054_PVPDATA, *new_data)

  EndProcedure
  
  ProcedureDLL  plx9054_write_eeprom_32(card_res, offset_address, new_data)
    
    address_bound.q = 0    
    viIn32(card_res, #VI_PXI_BAR0_SPACE, #PCI9054_BIGEND_LMISC_PROT_AREA, @address_bound)
    address_bound = address_bound & $000000000000ffff    
    viOut32(card_res, #VI_PXI_BAR0_SPACE, #PCI9054_BIGEND_LMISC_PROT_AREA, address_bound)      
    
    viOut32(card_res, #VI_PXI_CFG_SPACE, #PCI9054_PVPDATA, new_data)  
    While 1
      viOut32(card_res, #VI_PXI_CFG_SPACE, #PCI9054_PVPDCNTL, (offset_address<<16) | ($8000<<16))
      Delay(30)
      test_value.l  = 0
      viIn32(card_res, #VI_PXI_CFG_SPACE, #PCI9054_PVPDCNTL, @test_value)
      If  BitTst(test_value, 31)  = #False
        Break
      EndIf
      Delay(10)
    Wend
    
    address_bound = address_bound | ($30<<16)
    viOut32(card_res, #VI_PXI_BAR0_SPACE, #PCI9054_BIGEND_LMISC_PROT_AREA, address_bound) 
    
  EndProcedure  
  
  ProcedureDLL.l visa_check_setup()
    version.s = ReadRegKey(#HKEY_LOCAL_MACHINE, "SOFTWARE\National Instruments\NI-VISA for Windows 95/NT\CurrentVersion", "Version")
    If  version <> "3.3.1"
      If  version = "Error Opening Key"
        MessageBox_(GetFocus_(), "请先安装ni-visa v3.3.1 runtime", "..cv..", #MB_OK | #MB_ICONINFORMATION|#MB_SYSTEMMODAL)
        ProcedureReturn #False  
      Else
        MessageBox_(GetFocus_(), "当前ni-visa版本为v"	+	version	+	Chr(13) + Chr(10) + "推荐使用 ni-visa v3.3.1", "..cv..", #MB_OK | #MB_ICONINFORMATION|#MB_SYSTEMMODAL)
        ProcedureReturn #True  
      EndIf  
    Else
      ProcedureReturn #True
    EndIf         
  EndProcedure  
  
  Procedure plx9054_int_spy_handler(card_res, event_type, event_content, *int_count_array)
    
    flag  = 0
    Define  k.q  = 0
    viGetAttribute(event_content, #VI_ATTR_PXI_RECV_INTR_SEQ, @flag)    
    ;OutputDebugString_("Sequence : " + Str(flag))
    
    k = PeekQ(*int_count_array  + flag*SizeOf(k))
    k = k + 1
    PokeQ(*int_count_array  + flag*SizeOf(k), k)
    
    beeper_wrapper1(200)
  EndProcedure  
  
  ProcedureDLL.l  plx9054_interrupt_spy(*card_info)
    
    *card = PeekL(*card_info)   ;read 4byte
    x.l = PeekL(*card_info  + 12) ;read 4byte
    y.l = PeekL(*card_info  + 16) ;read 4byte
    
    ;相关的寄存器：
    ;Mailbox Interrupt Enable INTCSR:bit3
    ;PCI Interrupt Enable INTCSR:bit8
    ;PCI Doorbell Interrupt Enable  INTCSR:bit9
    ;Local Interrupt Input Enable INTCSR:bit11
    ;Local Interrupt Output Enable  INTCSR:bit16
    ;Local Doorbell Interrupt Enable  INTCSR:bit17
    ;Local DMA Channel 0 Interrupt Enable INTCSR:bit18
    ;Local DMA Channel 1 Interrupt Enable INTCSR:bit19
    ;Done Interrupt Enable  DMAMODE0:bit10
    ;DMA Channel 0 Interrupt Select DMAMODE0:bit17
    ;Interrupt after Terminal Count DMADPR0:bit2
    ;Done Interrupt Enable  DMAMODE1:bit10
    ;DMA Channel 1 Interrupt Select DMAMODE1:bit17
    ;Interrupt after Terminal Count DMADPR1:bit2   
    
    ;后加上的：
    ;PCI Abort Interrupt Enable INTCSR:bit10
    ;Retry Abort Enable         INTCSR:bit12
    
    ExamineDesktops()
    
    card1  = 0
    ExtractIconEx_("cv_icons.dll", 4, #Null, @card1, 1)    
    
    Dim card_array.card_info(16)  
    Protected thread1.q = 0
    Dim count_array.q(33)  ; total 34*8byte
    
    Protected visa_default.q  = 0
    viOpenDefaultRM(@visa_default)
    
    Protected card_res.q  = 0
    result  = viOpen(visa_default, *card, #VI_NO_LOCK, 1000, @card_res)
    
    If result <> #VI_SUCCESS
      MessageBox_(GetFocus_(), "error resource open!" + Chr(10) + PeekS(*card, -1, #PB_Ascii), "..cv..", #MB_OK | #MB_ICONERROR|#MB_SYSTEMMODAL)
      ProcedureReturn #False
    EndIf
    
    Protected hwnd  = OpenWindow(#PB_Any, x, y, 470, 360, "plx9054 interrupt", #PB_Window_MinimizeGadget|#PB_Window_SystemMenu)    
    
    viInstallHandler(card_res, #VI_EVENT_EXCEPTION, @visa32_error_handler(), hwnd)    
    viEnableEvent(card_res, #VI_EVENT_EXCEPTION, #VI_HNDLR, #VI_NULL)    
    viInstallHandler(card_res, #VI_EVENT_PXI_INTR, @plx9054_int_spy_handler(), @count_array())
    viEnableEvent(card_res, #VI_EVENT_PXI_INTR, #VI_HNDLR, #VI_NULL)
    
    SetWindowPos_(WindowID(hwnd), #HWND_TOP, 0, 0, 0, 0, #SWP_NOMOVE|#SWP_NOSIZE)
    
    SendMessage_(WindowID(hwnd), #WM_SETICON, #ICON_SMALL, card1)
    SmartWindowRefresh(hwnd, 1)     
       If OSVersion < #PB_OS_Windows_7
     ;
   Else
     SkinH_SetAero(WindowID(hwnd))
   EndIf
    slot_id = 0
    model_name.s = Space(4096)
    viGetAttribute(card_res, #VI_ATTR_SLOT, @slot_id)   
    viGetAttribute(card_res, #VI_ATTR_MODEL_NAME, @model_name)
    
    SetWindowTitle(hwnd, PeekS(*card, -1, #PB_Ascii) + "@Slot" + Str(slot_id) + "@" + model_name)
    
    Frame3DGadget(#PB_Any, 5,  5, 150, 195, "INTA#")
    Frame3DGadget(#PB_Any, 160,  5, 150, 195, "LINT#(output)")
    Frame3DGadget(#PB_Any, 315, 5, 150, 230, "DMA中断")
    
    pci_doorbell_en_bg  = ButtonGadget(#PB_Any, 10, 20, 140, 30, "PCI Doorbell Interrupt Enable", #PB_Button_MultiLine|#PB_Button_Toggle)
    lint_input_en_bg  = ButtonGadget(#PB_Any, 10, 55, 140, 30, "Local Interrupt Input Enable", #PB_Button_MultiLine|#PB_Button_Toggle)
    Retry_Abort_En = ButtonGadget(#PB_Any, 10, 90, 140, 30, "Retry Abort Enable", #PB_Button_MultiLine|#PB_Button_Toggle)   
    PCI_Abort_Int_En  = ButtonGadget(#PB_Any, 10, 125, 140, 30, "PCI Abort Interrupt Enable", #PB_Button_MultiLine|#PB_Button_Toggle)        
    pci_int_en_bg  = ButtonGadget(#PB_Any, 10, 160, 140, 30, "PCI Interrupt Enable", #PB_Button_MultiLine|#PB_Button_Toggle)
    
    local_doorbell_en_bg  = ButtonGadget(#PB_Any, 165, 20, 140, 30, "Local Doorbell Interrupt Enable", #PB_Button_MultiLine|#PB_Button_Toggle)
    mailbox_int_en_bg  = ButtonGadget(#PB_Any, 165, 55, 140, 30, "Mailbox Interrupt Enable", #PB_Button_MultiLine|#PB_Button_Toggle)
    local_dma_ch0_en_bg  = ButtonGadget(#PB_Any, 165, 90, 140, 30, "Local DMA Channel 0 Interrupt Enable", #PB_Button_MultiLine|#PB_Button_Toggle)
    local_dma_ch1_en_bg  = ButtonGadget(#PB_Any, 165, 125, 140, 30, "Local DMA Channel 1 Interrupt Enable", #PB_Button_MultiLine|#PB_Button_Toggle)
    lint_output_en_bg  = ButtonGadget(#PB_Any, 165, 160, 140, 30, "Local Interrupt Output Enable", #PB_Button_MultiLine|#PB_Button_Toggle)
    
    dma_ch0_done_en_bg  = ButtonGadget(#PB_Any, 320, 20, 140, 30, "DMA Ch0 Done Interrupt Enable", #PB_Button_MultiLine|#PB_Button_Toggle)
    dma_ch0_select_en_bg  = ButtonGadget(#PB_Any, 320, 55, 140, 30, "DMA Ch0 Interrupt Select", #PB_Button_MultiLine|#PB_Button_Toggle)
    dma_ch0_count_en_bg  = ButtonGadget(#PB_Any, 320, 90, 140, 30, "DMA Ch0 Int after Terminal Count En", #PB_Button_MultiLine|#PB_Button_Toggle)
    dma_ch1_done_en_bg  = ButtonGadget(#PB_Any, 320, 125, 140, 30, "DMA Ch1 Done Interrupt Enable", #PB_Button_MultiLine|#PB_Button_Toggle)
    dma_ch1_select_en_bg  = ButtonGadget(#PB_Any, 320, 160, 140, 30, "DMA Ch1 Interrupt Select", #PB_Button_MultiLine|#PB_Button_Toggle)
    dma_ch1_count_en_bg  = ButtonGadget(#PB_Any, 320, 195, 140, 30, "DMA Ch1 Int after Terminal Count En", #PB_Button_MultiLine|#PB_Button_Toggle)
    
    clear_all_bg  = ButtonGadget(#PB_Any, 385, 240, 50, 35, "CLEAR ALL", #PB_Button_MultiLine)
    help_bg = ButtonGadget(#PB_Any, 385, 285, 50, 20, "HELP")
    bmp_bg  = ButtonGadget(#PB_Any, 385, 315, 50, 20, "BMP")
    lock_bg = ButtonGadget(#PB_Any, 440, 315, 20, 20, "L", #PB_Button_Toggle)
    GadgetToolTip(lock_bg, "LOCK resource")         
    
    top_bg  = ButtonGadget(#PB_Any, 440, 285, 20, 20, "↑", #PB_Button_Toggle)
    GadgetToolTip(top_bg, "Always On The Top")    
    
    doorbell_spy_bg  = ButtonGadget(#PB_Any, 440, 240, 20, 35, "DB→", #PB_Button_Toggle|#PB_Button_MultiLine)
    GadgetToolTip(doorbell_spy_bg, "show doorbell_spy")     
    
    intscr_sg = StringGadget(#PB_Any, 5, 260, 90, 20, "0", #PB_String_ReadOnly)
    lint_input_sg = StringGadget(#PB_Any, 5, 305, 90, 20, "0", #PB_String_ReadOnly)
    dma_ch0_sg  = StringGadget(#PB_Any, 100, 260, 90, 20, "0", #PB_String_ReadOnly)
    dma_ch1_sg  = StringGadget(#PB_Any, 100, 305, 90, 20, "0", #PB_String_ReadOnly)
    doorbell_com3 = StringGadget(#PB_Any, 195, 260, 90, 20, "0", #PB_String_ReadOnly)
    doorbell_com4 = StringGadget(#PB_Any, 195, 305, 90, 20, "0", #PB_String_ReadOnly)
    doorbell_com5 = StringGadget(#PB_Any, 290, 260, 90, 20, "0", #PB_String_ReadOnly)
    doorbell_com6 = StringGadget(#PB_Any, 290, 305, 90, 20, "0", #PB_String_ReadOnly)
        
    GadgetToolTip(pci_doorbell_en_bg, "PCI Doorbell Interrupt Enable  INTCSR:bit9")
    GadgetToolTip(lint_input_en_bg, "Local Interrupt Input Enable INTCSR:bit11")    
    GadgetToolTip(pci_int_en_bg, "PCI Interrupt Enable INTCSR:bit8")    
    GadgetToolTip(local_doorbell_en_bg, "Local Doorbell Interrupt Enable  INTCSR:bit17")    
    GadgetToolTip(mailbox_int_en_bg, "Mailbox Interrupt Enable INTCSR:bit3")   
    GadgetToolTip(local_dma_ch0_en_bg, "Local DMA Channel 0 Interrupt Enable INTCSR:bit18")
    GadgetToolTip(local_dma_ch1_en_bg, "Local DMA Channel 1 Interrupt Enable INTCSR:bit19")    
    GadgetToolTip(lint_output_en_bg, "Local Interrupt Output Enable  INTCSR:bit16")    
    GadgetToolTip(dma_ch0_done_en_bg, "Done Interrupt Enable  DMAMODE0:bit10")    
    GadgetToolTip(dma_ch0_select_en_bg, "DMA Channel 0 Interrupt Select DMAMODE0:bit17 - 1 To PCI;0 to Local")   
    GadgetToolTip(dma_ch0_count_en_bg, "Interrupt after Terminal Count DMADPR0:bit2")
    GadgetToolTip(dma_ch1_done_en_bg, "Done Interrupt Enable  DMAMODE1:bit10")    
    GadgetToolTip(dma_ch1_select_en_bg, "DMA Channel 1 Interrupt Select DMAMODE1:bit17 - 1 To PCI;0 to Local")    
    GadgetToolTip(dma_ch1_count_en_bg, "Interrupt after Terminal Count DMADPR1:bit2")  
    GadgetToolTip(PCI_Abort_Int_En, "PCI Abort Interrupt Enable INTCSR:bit10")  
    GadgetToolTip(Retry_Abort_En, "Retry Abort Enable INTCSR:bit12")  
    
    GadgetToolTip(clear_all_bg, "清0")   
    GadgetToolTip(help_bg, "帮助")
    GadgetToolTip(bmp_bg, "截图")    
    GadgetToolTip(intscr_sg, "INTSCR")    
    GadgetToolTip(lint_input_sg, "Sequence 0: lint_input中断计数")    
    GadgetToolTip(dma_ch0_sg, "Sequence 1: dma_ch0中断计数")   
    GadgetToolTip(dma_ch1_sg, "Sequence 2: dma_ch1中断计数")
    GadgetToolTip(doorbell_com3, "Sequence 3: doorbell中断com3计数")    
    GadgetToolTip(doorbell_com4, "Sequence 4: doorbell中断com4计数")    
    GadgetToolTip(doorbell_com5, "Sequence 5: doorbell中断com5计数")    
    GadgetToolTip(doorbell_com6, "Sequence 6: doorbell中断com6计数")   
    
    TextGadget(#PB_Any, 5, 245, 90, 16, "INTCSR")
    TextGadget(#PB_Any, 5, 290, 90, 16, "lint_count")
    TextGadget(#PB_Any, 100, 245, 90, 16, "dma_ch0_count")
    TextGadget(#PB_Any, 100, 290, 90, 16, "dma_ch1_count")
    TextGadget(#PB_Any, 195, 245, 90, 16, "doorbell_com3")
    TextGadget(#PB_Any, 195, 290, 90, 16, "doorbell_com4")
    TextGadget(#PB_Any, 290, 245, 90, 16, "doorbell_com5")
    TextGadget(#PB_Any, 290, 290, 90, 16, "doorbell_com6")  
    
    TextGadget(#PB_Any, 5, 205, 90, 16, "Target Abort")  
    TextGadget(#PB_Any, 120, 205, 130, 16, "Received Master Abort") 
    target_abort_count = StringGadget(#PB_Any, 5, 220, 90, 20, "0", #PB_String_ReadOnly)    
    master_abort_count = StringGadget(#PB_Any, 120, 220, 90, 20, "0", #PB_String_ReadOnly)
    GadgetToolTip(target_abort_count, "Sequence 32: Target Abort Error计数")       
    GadgetToolTip(master_abort_count, "Sequence 33: Received Master Abort Error计数")           
    
    big_font1  = LoadFont(#PB_Any,"Courier",12, #PB_Font_Bold|#PB_Font_HighQuality)
    
    SetGadgetFont(intscr_sg, FontID(big_font1))
    SetGadgetColor(intscr_sg, #PB_Gadget_FrontColor, RGB(00, $FF, 00))
    SetGadgetColor(intscr_sg, #PB_Gadget_BackColor, RGB(00, 00, 00))   
    
    SetGadgetFont(lint_input_sg, FontID(big_font1))
    SetGadgetColor(lint_input_sg, #PB_Gadget_FrontColor, RGB(00, $FF, $FF))
    SetGadgetColor(lint_input_sg, #PB_Gadget_BackColor, RGB(00, 00, 00))   
    
    SetGadgetFont(dma_ch0_sg, FontID(big_font1))
    SetGadgetColor(dma_ch0_sg, #PB_Gadget_FrontColor, RGB(00, $FF, $FF))
    SetGadgetColor(dma_ch0_sg, #PB_Gadget_BackColor, RGB(00, 00, 00))   
    
    SetGadgetFont(dma_ch1_sg, FontID(big_font1))
    SetGadgetColor(dma_ch1_sg, #PB_Gadget_FrontColor, RGB(00, $FF, $FF))
    SetGadgetColor(dma_ch1_sg, #PB_Gadget_BackColor, RGB(00, 00, 00))   
    
    SetGadgetFont(doorbell_com3, FontID(big_font1))
    SetGadgetColor(doorbell_com3, #PB_Gadget_FrontColor, RGB(00, $FF, $FF))
    SetGadgetColor(doorbell_com3, #PB_Gadget_BackColor, RGB(00, 00, 00))       
    
    SetGadgetFont(doorbell_com4, FontID(big_font1))
    SetGadgetColor(doorbell_com4, #PB_Gadget_FrontColor, RGB(00, $FF, $FF))
    SetGadgetColor(doorbell_com4, #PB_Gadget_BackColor, RGB(00, 00, 00))   
    
    SetGadgetFont(doorbell_com5, FontID(big_font1))
    SetGadgetColor(doorbell_com5, #PB_Gadget_FrontColor, RGB(00, $FF, $FF))
    SetGadgetColor(doorbell_com5, #PB_Gadget_BackColor, RGB(00, 00, 00))   
    
    SetGadgetFont(doorbell_com6, FontID(big_font1))
    SetGadgetColor(doorbell_com6, #PB_Gadget_FrontColor, RGB(00, $FF, $FF))
    SetGadgetColor(doorbell_com6, #PB_Gadget_BackColor, RGB(00, 00, 00))  
    
    SetGadgetFont(target_abort_count, FontID(big_font1))
    SetGadgetColor(target_abort_count, #PB_Gadget_FrontColor, RGB($FF, $00, $00))
    SetGadgetColor(target_abort_count, #PB_Gadget_BackColor, RGB(00, 00, 00))  
    SetGadgetFont(master_abort_count, FontID(big_font1))
    SetGadgetColor(master_abort_count, #PB_Gadget_FrontColor, RGB($FF, $00, $00))
    SetGadgetColor(master_abort_count, #PB_Gadget_BackColor, RGB(00, 00, 00))  
    
    
    name_bar  = CreateStatusBar(#PB_Any, WindowID(hwnd))
    If name_bar
      AddStatusBarField(470)
    EndIf
    
    res_name.s = Space(4096)
    viGetAttribute(card_res, #VI_ATTR_RSRC_NAME, @res_name)
    
    StatusBarText(name_bar, 0, res_name)
    
    AddWindowTimer(hwnd, 0, 100)
        
    Repeat
      Event.l = WaitWindowEvent()
      Select  Event
        Case  #PB_Event_Timer
          Select  EventTimer()
            Case  0
              test1 = 0
              viIn32(card_res, #VI_PXI_BAR0_SPACE, #PCI9054_INTCSR, @test1)
              SetGadgetText(intscr_sg, RSet(Hex(test1, #PB_Long), 8, "0"))
              test2 = 0
              viIn32(card_res, #VI_PXI_BAR0_SPACE, #PCI9054_DMAMODE0, @test2)
              test3 = 0
              viIn32(card_res, #VI_PXI_BAR0_SPACE, #PCI9054_DMADPR0, @test3)     
              test4 = 0
              viIn32(card_res, #VI_PXI_BAR0_SPACE, #PCI9054_DMAMODE1, @test4)
              test5 = 0
              viIn32(card_res, #VI_PXI_BAR0_SPACE, #PCI9054_DMADPR1, @test5)
              SetGadgetState(pci_doorbell_en_bg, BitTst(test1, 9))
              SetGadgetState(PCI_Abort_Int_En, BitTst(test1, 10))              
              SetGadgetState(lint_input_en_bg, BitTst(test1, 11))
              SetGadgetState(Retry_Abort_En, BitTst(test1, 12))              
              SetGadgetState(pci_int_en_bg, BitTst(test1, 8))
              SetGadgetState(local_doorbell_en_bg, BitTst(test1, 17))
              SetGadgetState(mailbox_int_en_bg, BitTst(test1, 3))
              SetGadgetState(local_dma_ch0_en_bg, BitTst(test1, 18))
              SetGadgetState(local_dma_ch1_en_bg, BitTst(test1, 19))
              SetGadgetState(lint_output_en_bg, BitTst(test1, 16))
              SetGadgetState(dma_ch0_done_en_bg, BitTst(test2, 10))
              SetGadgetState(dma_ch0_select_en_bg, BitTst(test2, 17))
              SetGadgetState(dma_ch0_count_en_bg, BitTst(test3, 2))
              SetGadgetState(dma_ch1_done_en_bg, BitTst(test4, 10))
              SetGadgetState(dma_ch1_select_en_bg, BitTst(test4, 17))
              SetGadgetState(dma_ch1_count_en_bg, BitTst(test5, 2))
            ;-----------------------------------
              SetGadgetText(lint_input_sg, Str(count_array(0)))
              SetGadgetText(dma_ch0_sg, Str(count_array(1)))
              SetGadgetText(dma_ch1_sg, Str(count_array(2)))
              SetGadgetText(doorbell_com3, Str(count_array(3)))
              SetGadgetText(doorbell_com4, Str(count_array(4)))
              SetGadgetText(doorbell_com5, Str(count_array(5)))
              SetGadgetText(doorbell_com6, Str(count_array(6)))
              SetGadgetText(target_abort_count, Str(count_array(32)))
              SetGadgetText(master_abort_count, Str(count_array(33)))   
              
          EndSelect
        Case  #PB_Event_Gadget
          Select  EventGadget()
            Case  doorbell_spy_bg
              Delay(10)                  
              If  GetGadgetState(doorbell_spy_bg)
                ResizeWindow(hwnd, 20, WindowY(hwnd), WindowWidth(hwnd), WindowHeight(hwnd))
                card_array.card_info(0)\card  = *card
                card_array.card_info(0)\y  = WindowY(hwnd)
                card_array.card_info(0)\x  = WindowWidth(hwnd) + 50
                thread1 = CreateThread(@plx9054_doorbell_interrupt_spy(), @card_array())
              Else
                ori_y = (DesktopHeight(0) -  360)/2
                ori_x = (DesktopWidth(0)  - 470)/2
                ResizeWindow(hwnd, ori_x, WindowY(hwnd), WindowWidth(hwnd), WindowHeight(hwnd))
                KillThread(thread1)
              EndIf
            Case  top_bg
              Select EventType()
                Case #PB_EventType_LeftClick
                  Delay(10)
                  If  GetGadgetState(top_bg)
                    SetWindowPos_(WindowID(hwnd), #HWND_TOPMOST, 0, 0, 0, 0, #SWP_NOMOVE|#SWP_NOSIZE)
                  Else
                    SetWindowPos_(WindowID(hwnd), #HWND_NOTOPMOST, 0, 0, 0, 0, #SWP_NOMOVE|#SWP_NOSIZE)
                  EndIf 
                Case #PB_EventType_RightClick
                  ;
                Case #PB_EventType_LeftDoubleClick
                  ;
                Case #PB_EventType_RightDoubleClick
                  ;
                Case  #PB_EventType_Change
                  ;                  
              EndSelect               
            Case  lock_bg
              Delay(10)
              If  GetGadgetState(lock_bg)
                viLock(card_res, #VI_EXCLUSIVE_LOCK, 200, #VI_NULL, #VI_NULL)
              Else
                viUnlock(card_res)
              EndIf
            Case  bmp_bg
              CaptureWindow(GetWindowTitle(hwnd))
            Case  clear_all_bg
              For i=0 To 33 Step 1
                count_array(i)  = 0
              Next  i
            Case  help_bg
              plx9054_int_help_launcher()
            ;-----------------------------------
            Case  PCI_Abort_Int_En
              Select EventType()
                Case #PB_EventType_LeftClick
                  test1 = 0
                  viIn32(card_res, #VI_PXI_BAR0_SPACE, #PCI9054_INTCSR, @test1)
                  If  BitTst(test1, 10)
                    test1 = bitclr(test1, 10)
                    viOut32(card_res, #VI_PXI_BAR0_SPACE, #PCI9054_INTCSR, test1)
                  Else
                    test1 = BitSet(test1, 10)
                    viOut32(card_res, #VI_PXI_BAR0_SPACE, #PCI9054_INTCSR, test1)                
                  EndIf                 
              EndSelect 
            Case  Retry_Abort_En
              Select EventType()
                Case #PB_EventType_LeftClick
                  test1 = 0
                  viIn32(card_res, #VI_PXI_BAR0_SPACE, #PCI9054_INTCSR, @test1)
                  If  BitTst(test1, 12)
                    test1 = bitclr(test1, 12)
                    viOut32(card_res, #VI_PXI_BAR0_SPACE, #PCI9054_INTCSR, test1)
                  Else
                    test1 = BitSet(test1, 12)
                    viOut32(card_res, #VI_PXI_BAR0_SPACE, #PCI9054_INTCSR, test1)                
                  EndIf                 
              EndSelect               
            Case  pci_doorbell_en_bg
              Select EventType()
                Case #PB_EventType_LeftClick
                  test1 = 0
                  viIn32(card_res, #VI_PXI_BAR0_SPACE, #PCI9054_INTCSR, @test1)
                  If  BitTst(test1, 9)
                    test1 = bitclr(test1, 9)
                    viOut32(card_res, #VI_PXI_BAR0_SPACE, #PCI9054_INTCSR, test1)
                  Else
                    test1 = BitSet(test1, 9)
                    viOut32(card_res, #VI_PXI_BAR0_SPACE, #PCI9054_INTCSR, test1)                
                  EndIf                 
              EndSelect 
            Case  lint_input_en_bg
              Select EventType()
                Case #PB_EventType_LeftClick
                  test1 = 0
                  viIn32(card_res, #VI_PXI_BAR0_SPACE, #PCI9054_INTCSR, @test1)
                  If  BitTst(test1, 11)
                    test1 = bitclr(test1, 11)
                    viOut32(card_res, #VI_PXI_BAR0_SPACE, #PCI9054_INTCSR, test1)
                  Else
                    test1 = BitSet(test1, 11)
                    viOut32(card_res, #VI_PXI_BAR0_SPACE, #PCI9054_INTCSR, test1)                
                  EndIf                 
              EndSelect 
            Case  pci_int_en_bg
              Select EventType()
                Case #PB_EventType_LeftClick
                  test1 = 0
                  viIn32(card_res, #VI_PXI_BAR0_SPACE, #PCI9054_INTCSR, @test1)
                  If  BitTst(test1, 8)
                    test1 = bitclr(test1, 8)
                    viOut32(card_res, #VI_PXI_BAR0_SPACE, #PCI9054_INTCSR, test1)
                  Else
                    test1 = BitSet(test1, 8)
                    viOut32(card_res, #VI_PXI_BAR0_SPACE, #PCI9054_INTCSR, test1)                
                  EndIf                 
              EndSelect 
            Case  local_doorbell_en_bg
              Select EventType()
                Case #PB_EventType_LeftClick
                  test1 = 0
                  viIn32(card_res, #VI_PXI_BAR0_SPACE, #PCI9054_INTCSR, @test1)
                  If  BitTst(test1, 17)
                    test1 = bitclr(test1, 17)
                    viOut32(card_res, #VI_PXI_BAR0_SPACE, #PCI9054_INTCSR, test1)
                  Else
                    test1 = BitSet(test1, 17)
                    viOut32(card_res, #VI_PXI_BAR0_SPACE, #PCI9054_INTCSR, test1)                
                  EndIf                 
              EndSelect 
            Case  mailbox_int_en_bg
              Select EventType()
                Case #PB_EventType_LeftClick
                  test1 = 0
                  viIn32(card_res, #VI_PXI_BAR0_SPACE, #PCI9054_INTCSR, @test1)
                  If  BitTst(test1, 3)
                    test1 = bitclr(test1, 3)
                    viOut32(card_res, #VI_PXI_BAR0_SPACE, #PCI9054_INTCSR, test1)
                  Else
                    test1 = BitSet(test1, 3)
                    viOut32(card_res, #VI_PXI_BAR0_SPACE, #PCI9054_INTCSR, test1)                
                  EndIf                 
              EndSelect
            Case  local_dma_ch0_en_bg
              Select EventType()
                Case #PB_EventType_LeftClick
                  test1 = 0
                  viIn32(card_res, #VI_PXI_BAR0_SPACE, #PCI9054_INTCSR, @test1)
                  If  BitTst(test1, 18)
                    test1 = bitclr(test1, 18)
                    viOut32(card_res, #VI_PXI_BAR0_SPACE, #PCI9054_INTCSR, test1)
                  Else
                    test1 = BitSet(test1, 18)
                    viOut32(card_res, #VI_PXI_BAR0_SPACE, #PCI9054_INTCSR, test1)                
                  EndIf                 
              EndSelect        
            Case  local_dma_ch1_en_bg
              Select EventType()
                Case #PB_EventType_LeftClick
                  test1 = 0
                  viIn32(card_res, #VI_PXI_BAR0_SPACE, #PCI9054_INTCSR, @test1)
                  If  BitTst(test1, 19)
                    test1 = bitclr(test1, 19)
                    viOut32(card_res, #VI_PXI_BAR0_SPACE, #PCI9054_INTCSR, test1)
                  Else
                    test1 = BitSet(test1, 19)
                    viOut32(card_res, #VI_PXI_BAR0_SPACE, #PCI9054_INTCSR, test1)                
                  EndIf                 
              EndSelect
            Case  lint_output_en_bg
              Select EventType()
                Case #PB_EventType_LeftClick
                  test1 = 0
                  viIn32(card_res, #VI_PXI_BAR0_SPACE, #PCI9054_INTCSR, @test1)
                  If  BitTst(test1, 16)
                    test1 = bitclr(test1, 16)
                    viOut32(card_res, #VI_PXI_BAR0_SPACE, #PCI9054_INTCSR, test1)
                  Else
                    test1 = BitSet(test1, 16)
                    viOut32(card_res, #VI_PXI_BAR0_SPACE, #PCI9054_INTCSR, test1)                
                  EndIf                 
              EndSelect
            Case  dma_ch0_done_en_bg
              Select EventType()
                Case #PB_EventType_LeftClick
                  test1 = 0
                  viIn32(card_res, #VI_PXI_BAR0_SPACE, #PCI9054_DMAMODE0, @test1)
                  If  BitTst(test1, 10)
                    test1 = bitclr(test1, 10)
                    viOut32(card_res, #VI_PXI_BAR0_SPACE, #PCI9054_DMAMODE0, test1)
                  Else
                    test1 = BitSet(test1, 10)
                    viOut32(card_res, #VI_PXI_BAR0_SPACE, #PCI9054_DMAMODE0, test1)                
                  EndIf                 
              EndSelect  
            Case  dma_ch1_done_en_bg
              Select EventType()
                Case #PB_EventType_LeftClick
                  test1 = 0
                  viIn32(card_res, #VI_PXI_BAR0_SPACE, #PCI9054_DMAMODE1, @test1)
                  If  BitTst(test1, 10)
                    test1 = bitclr(test1, 10)
                    viOut32(card_res, #VI_PXI_BAR0_SPACE, #PCI9054_DMAMODE1, test1)
                  Else
                    test1 = BitSet(test1, 10)
                    viOut32(card_res, #VI_PXI_BAR0_SPACE, #PCI9054_DMAMODE1, test1)                
                  EndIf                 
              EndSelect  
            Case  dma_ch0_select_en_bg
              Select EventType()
                Case #PB_EventType_LeftClick
                  test1 = 0
                  viIn32(card_res, #VI_PXI_BAR0_SPACE, #PCI9054_DMAMODE0, @test1)
                  If  BitTst(test1, 17)
                    test1 = bitclr(test1, 17)
                    viOut32(card_res, #VI_PXI_BAR0_SPACE, #PCI9054_DMAMODE0, test1)
                  Else
                    test1 = BitSet(test1, 17)
                    viOut32(card_res, #VI_PXI_BAR0_SPACE, #PCI9054_DMAMODE0, test1)                
                  EndIf                 
              EndSelect  
            Case  dma_ch1_select_en_bg
              Select EventType()
                Case #PB_EventType_LeftClick
                  test1 = 0
                  viIn32(card_res, #VI_PXI_BAR0_SPACE, #PCI9054_DMAMODE1, @test1)
                  If  BitTst(test1, 17)
                    test1 = bitclr(test1, 17)
                    viOut32(card_res, #VI_PXI_BAR0_SPACE, #PCI9054_DMAMODE1, test1)
                  Else
                    test1 = BitSet(test1, 17)
                    viOut32(card_res, #VI_PXI_BAR0_SPACE, #PCI9054_DMAMODE1, test1)                
                  EndIf                 
              EndSelect 
            Case  dma_ch0_count_en_bg
              Select EventType()
                Case #PB_EventType_LeftClick
                  test1 = 0
                  viIn32(card_res, #VI_PXI_BAR0_SPACE, #PCI9054_DMADPR0, @test1)
                  If  BitTst(test1, 2)
                    test1 = bitclr(test1, 2)
                    viOut32(card_res, #VI_PXI_BAR0_SPACE, #PCI9054_DMADPR0, test1)
                  Else
                    test1 = BitSet(test1, 2)
                    viOut32(card_res, #VI_PXI_BAR0_SPACE, #PCI9054_DMADPR0, test1)                
                  EndIf                 
              EndSelect   
            Case  dma_ch1_count_en_bg
              Select EventType()
                Case #PB_EventType_LeftClick
                  test1 = 0
                  viIn32(card_res, #VI_PXI_BAR0_SPACE, #PCI9054_DMADPR1, @test1)
                  If  BitTst(test1, 2)
                    test1 = bitclr(test1, 2)
                    viOut32(card_res, #VI_PXI_BAR0_SPACE, #PCI9054_DMADPR1, test1)
                  Else
                    test1 = BitSet(test1, 2)
                    viOut32(card_res, #VI_PXI_BAR0_SPACE, #PCI9054_DMADPR1, test1)                
                  EndIf                 
              EndSelect               
          EndSelect
        Case  #PB_Event_Menu
          Select EventMenu()
            Case  0
              ;
          EndSelect
      EndSelect
    Until Event = #PB_Event_CloseWindow Or  quit  = #True
    
    viDisableEvent(card_res, #VI_ALL_ENABLED_EVENTS, #VI_ALL_MECH)
    viUninstallHandler(card_res, #VI_EVENT_PXI_INTR, @plx9054_int_spy_handler(), @count_array()) 
    viUninstallHandler(card_res, #VI_EVENT_EXCEPTION, @visa32_error_handler(), hwnd)
    viClose(card_res)
    viClose(visa_default)
    CloseWindow(hwnd)
    
  EndProcedure
  
  Procedure plx9054_dma_controlpanel_handler(card_res, event_type, event_content, *parameter_array)
    
    Define  flag.l  = 0
    Define  k.l  = 0
    Define  log_text_p.l  = 0
    Define  log_text.s  = ""
    Static  start_tick.l
    viGetAttribute(event_content, #VI_ATTR_PXI_RECV_INTR_SEQ, @flag)    
    ;OutputDebugString_("Sequence : " + Str(flag))
    
    Select  flag
      Case  1
        k = PeekL(*parameter_array + flag*SizeOf(k))
        k = k + 1
        PokeQ(*parameter_array + flag*SizeOf(k), k)
      Case  2
        k = PeekL(*parameter_array + flag*SizeOf(k))
        k = k + 1
        PokeL(*parameter_array + flag*SizeOf(k), k)        
    EndSelect
    
    log_text_p  = PeekL(*parameter_array)
    log_text  = PeekS(log_text_p, -1, #PB_Ascii)
    If  Len(log_text) > 204000
      log_text  = ""
    EndIf
    
    first_start_tick  = PeekL(*parameter_array + 4*SizeOf(k)) 
    done_tick.l   = timeGetTime_()
    log_text  = log_text + "<dma_finish>" + Str(k-1) + "@" + Str(done_tick-first_start_tick) + "ms" + Chr(13) + Chr(10)
    
    start_tick_old  = start_tick
    
    If  k >= PeekL(*parameter_array  + 3*SizeOf(k))
      ;last dma cycle.
      PokeL(*parameter_array  + 6*SizeOf(k), $0)
    Else
      If  flag  = 1
        memory_bit_set(card_res, #VI_PXI_BAR0_SPACE, #PCI9054_DMACSR0_DMACSR1, 1) ;ch0
      Else
        If  flag  = 2
          memory_bit_set(card_res, #VI_PXI_BAR0_SPACE, #PCI9054_DMACSR0_DMACSR1, 9) ;ch1
        EndIf        
      EndIf 
      start_tick  = timeGetTime_()
      log_text  = log_text + "<dma_start>" + Str(k) + "@"+ Str(start_tick-first_start_tick) + "ms" + Chr(13) + Chr(10)  
      PokeL(*parameter_array  + 6*SizeOf(k), $1)
    EndIf
    
    PokeS(log_text_p, log_text)
    
    If  1 = k
      delta_time.l  = done_tick - first_start_tick
    Else
      delta_time  = done_tick - start_tick_old
    EndIf 
           
    PokeL(*parameter_array  + 5*SizeOf(k), delta_time)   
    
  EndProcedure   
  
  ProcedureDLL.l  plx9054_dma_controlpanel(*card_info)
    ;2Mbyte + 2Mbyte内存申请做为buffer使用
    ;
    
    *card = PeekL(*card_info)   ;read 4byte
    x.l = PeekL(*card_info  + 12) ;read 4byte
    y.l = PeekL(*card_info  + 16) ;read 4byte
    
    Define  log_text.s{204800}
    Dim card_array.card_info(2)
    
    Define  active_channel.q  = 0
    ExamineDesktops()
    
    ori_x = (DesktopWidth(0)  - 560)/2
    ori_y = (DesktopHeight(0) -  320)/2    
    
    card1  = CatchImage(#PB_Any, ?card1)        
    
    Protected visa_default.q  = 0
    viOpenDefaultRM(@visa_default)
    
    Protected card_res.q  = 0
    Protected memory_res.q  = 0
    
    card_res_name.s = Space(4096)
    Dim parameter_array.l(31)  ; total 32*4byte
    ;0 is log string pointer. [in]
    ;1 is dma ch0 counter.    [out]
    ;2 is dma ch1 counter.    [out]
    ;3 is dma_times           [in]要触发的次数
    ;4 is start time          [in]开始的第一次的时间点
    ;5 is delta time          [out]时间差
    ;6 is busy flag           [out]完成标志 1 is busy/0 is finish    
    result  = viOpen(visa_default, *card, #VI_NO_LOCK, 1000, @card_res)
       
    If result <> #VI_SUCCESS
      MessageBox_(GetFocus_(), "error resource open!" + Chr(10) + PeekS(*card, -1, #PB_Ascii), "..cv..", #MB_OK | #MB_ICONERROR|#MB_SYSTEMMODAL)
      ProcedureReturn #False
    EndIf
    
    Protected hwnd  = OpenWindow(#PB_Any, x, y, 550, 300, "plx9054 DMA CH0", #PB_Window_MinimizeGadget|#PB_Window_SystemMenu)
    
    viInstallHandler(card_res, #VI_EVENT_EXCEPTION, @visa32_error_handler(), hwnd)
    viEnableEvent(card_res, #VI_EVENT_EXCEPTION, #VI_HNDLR, #VI_NULL) 
        
    viInstallHandler(card_res, #VI_EVENT_PXI_INTR, @plx9054_dma_controlpanel_handler(), @parameter_array())        
    viEnableEvent(card_res, #VI_EVENT_PXI_INTR, #VI_HNDLR, #VI_NULL)    
    
    viGetAttribute(card_res, #VI_ATTR_RSRC_NAME, @card_res_name)
    
    If  FindString(card_res_name, "visa://", 1)
      ip_address.s  = RemoveString(card_res_name, "visa://", 0, 1, 1)
      ip_address  = StringField(ip_address, 1, "/")
      ip_address  = "visa://" + ip_address  + "/PXI0::MEMACC"
      result  = viOpen(visa_default, @ip_address, #VI_NO_LOCK, 1000, @memory_res)
    Else
      result  = viOpen(visa_default, @"PXI0::MEMACC", #VI_NO_LOCK, 1000, @memory_res)  
    EndIf
    
    If result <> #VI_SUCCESS
      MessageBox_(GetFocus_(), "error memacc resource open!", "..cv..", #MB_OK | #MB_ICONERROR|#MB_SYSTEMMODAL)
      ProcedureReturn #False
    EndIf    
    
    viInstallHandler(memory_res, #VI_EVENT_EXCEPTION, @visa32_error_handler(), hwnd)
    viEnableEvent(memory_res, #VI_EVENT_EXCEPTION, #VI_HNDLR, #VI_NULL)
    
    dma_ch0_buffer_header.l = 0
    result  = 0
    Repeat
      result  = viMemAlloc(memory_res, $200000, @dma_ch0_buffer_header)  ;2MB for ch0
    Until dma_ch0_buffer_header <>  0 And result  = 0
    
    dma_ch1_buffer_header.l = 0    
    Repeat
      result  = viMemAlloc(memory_res, $200000, @dma_ch1_buffer_header)  ;2MB for ch1
    Until dma_ch1_buffer_header <>  0 And result  = 0  
    
    viout32(card_res, #VI_PXI_BAR0_SPACE, #PCI9054_DMAPADR0, dma_ch0_buffer_header)
    viout32(card_res, #VI_PXI_BAR0_SPACE, #PCI9054_DMAPADR1, dma_ch1_buffer_header)
    viout32(card_res, #VI_PXI_BAR0_SPACE, #PCI9054_INTCSR, $0F0C0180)   ;只使能dma必要的
    viOut32(card_res, #VI_PXI_BAR0_SPACE, #PCI9054_DMACSR0_DMACSR1, $00001111)  ;使能DMA功能
    
    SetWindowPos_(WindowID(hwnd), #HWND_TOP, 0, 0, 0, 0, #SWP_NOMOVE|#SWP_NOSIZE)
    
    SendMessage_(WindowID(hwnd), #WM_SETICON, #ICON_SMALL, ImageID(card1))
    SmartWindowRefresh(hwnd, 1)     
       If OSVersion < #PB_OS_Windows_7
     ;
   Else
     SkinH_SetAero(WindowID(hwnd))
   EndIf
    slot_id = 0
    model_name.s = Space(4096)
    viGetAttribute(card_res, #VI_ATTR_SLOT, @slot_id)   
    viGetAttribute(card_res, #VI_ATTR_MODEL_NAME, @model_name)
    
    SetWindowTitle(hwnd, PeekS(*card, -1, #PB_Ascii) + "@Slot" + Str(slot_id) + "@" + model_name)
    
    big_font1  = LoadFont(#PB_Any,"Courier",18, #PB_Font_Bold|#PB_Font_HighQuality)    
    text_tg  = TextGadget(#PB_Any, 5, 5, 500, 30, "PLX9054 DMA ControlPanel - Step 1", #PB_Text_Center)
    SetGadgetFont(text_tg, FontID(big_font1))
    SetGadgetColor(text_tg, #PB_Gadget_FrontColor, RGB(00, $FF, 00))
    SetGadgetColor(text_tg, #PB_Gadget_BackColor, RGB(00, 00, 00))    
    
    container1  = ContainerGadget(#PB_Any, 0, 40, 550, 230)
    frame1  = Frame3DGadget(#PB_Any, 20, 20, 200, 110, "Select Plx9054 Dma Channel")
    ch0_og  = OptionGadget(#PB_Any, 40, 45, 60, 25, "CH0")
    ch1_og  = OptionGadget(#PB_Any, 40, 75, 60, 25, "CH1")
    SetGadgetState(ch0_og, #True)
    next1_bg = ButtonGadget(#PB_Any, 120, 200, 80, 25, "Next >", #PB_Button_Default)
    GadgetToolTip(next1_bg, "下一步")
    SetActiveGadget(next1_bg)
    CloseGadgetList()
    
    big_font2  = LoadFont(#PB_Any,"Courier",12, #PB_Font_Bold|#PB_Font_HighQuality)        
    container2  = ContainerGadget(#PB_Any, 0, 40, 550, 230)
    frame2_0  = Frame3DGadget(#PB_Any, 20, 20, 270, 150, "Select Plx9054 Dma Mode")
    frame2_1  = Frame3DGadget(#PB_Any, 300, 20, 220, 150, "Select Dma Direction")
    text2_0 = TextGadget(#PB_Any, 35, 40, 200, 20, "DMAMODEx")
    text2_1 = TextGadget(#PB_Any, 315, 40, 200, 20, "DMADPRx")
    SetGadgetFont(text2_0, FontID(big_font2))
    SetGadgetFont(text2_1, FontID(big_font2))        
    mode_sg  = StringGadget(#PB_Any, 35, 60, 100, 20, "00000000", #PB_String_UpperCase|#PB_String_ReadOnly)
    dir_sg  = StringGadget(#PB_Any, 315, 60, 100, 20, "00000000", #PB_String_UpperCase|#PB_String_ReadOnly)
    GadgetToolTip(mode_sg, "回读的DMAMODEx的值") 
    GadgetToolTip(dir_sg, "回读的DMADPRx的值")    
    SetGadgetColor(mode_sg, #PB_Gadget_FrontColor, RGB(00, $FF, 00))
    SetGadgetColor(mode_sg, #PB_Gadget_BackColor, RGB(00, 00, 00))  
    SetGadgetColor(dir_sg, #PB_Gadget_FrontColor, RGB(00, $FF, 00))
    SetGadgetColor(dir_sg, #PB_Gadget_BackColor, RGB(00, 00, 00))
    SetGadgetFont(mode_sg, FontID(big_font2))
    SetGadgetFont(dir_sg, FontID(big_font2))            
    mode_select = ComboBoxGadget(#PB_Any, 30, 100, 250, 20)
    AddGadgetItem(mode_select, -1, "no change")
    AddGadgetItem(mode_select, -1, "32bit_block_0wait_lram")    
    AddGadgetItem(mode_select, -1, "32bit_block_0wait_lram_burst")    
    AddGadgetItem(mode_select, -1, "32bit_block_0wait_lram_burst_bterm#")    
    AddGadgetItem(mode_select, -1, "32bit_block_0wait_lfifo") 
    AddGadgetItem(mode_select, -1, "32bit_block_0wait_lfifo_burst")    
    AddGadgetItem(mode_select, -1, "32bit_block_0wait_lfifo_burst_bterm#")
    SetGadgetState(mode_select, 0)
    GadgetToolTip(mode_select, "修改DMAMODEx寄存器")
    dir_select = ComboBoxGadget(#PB_Any, 310, 100, 200, 20)
    AddGadgetItem(dir_select, -1, "no change")
    AddGadgetItem(dir_select, -1, "Local to PCI")    
    AddGadgetItem(dir_select, -1, "PCI to Local")
    SetGadgetState(dir_select, 0)
    GadgetToolTip(dir_select, "修改DMADPRx寄存器")   
    pre2_bg  = ButtonGadget(#PB_Any, 20, 200, 80, 25, "< Previous")
    next2_bg = ButtonGadget(#PB_Any, 120, 200, 80, 25, "Next >")
    GadgetToolTip(next2_bg, "下一步")
    GadgetToolTip(pre2_bg, "上一步")    
    CloseGadgetList()
    HideGadget(container2, #True)
    
    container3  = ContainerGadget(#PB_Any, 0, 40, 550, 230)
    frame3_0  = Frame3DGadget(#PB_Any, 10, 20, 170, 150, "Select Dma Local Address")
    frame3_1  = Frame3DGadget(#PB_Any, 190, 20, 170, 150, "Dma PCI Address")
    frame3_2  = Frame3DGadget(#PB_Any, 370, 20, 170, 150, "Dma Size(Bytes)")
    text3_0 = TextGadget(#PB_Any, 30, 40, 100, 20, "DMALADRx")
    text3_1 = TextGadget(#PB_Any, 210, 40, 100, 20, "DMAPADRx")
    text3_2 = TextGadget(#PB_Any, 390, 40, 100, 20, "DMASIZx")
    SetGadgetFont(text3_0, FontID(big_font2))
    SetGadgetFont(text3_1, FontID(big_font2))        
    SetGadgetFont(text3_2, FontID(big_font2)) 
    ladr_sg  = StringGadget(#PB_Any, 30, 60, 100, 20, "00000000", #PB_String_UpperCase|#PB_String_ReadOnly)
    padr_sg  = StringGadget(#PB_Any, 210, 60, 100, 20, "00000000", #PB_String_UpperCase|#PB_String_ReadOnly)
    size_sg  = StringGadget(#PB_Any, 390, 60, 100, 20, "00000000", #PB_String_UpperCase|#PB_String_ReadOnly) 
    ladr_bg = ButtonGadget(#PB_Any, 30, 140, 50, 20, "ACCESS")
    GadgetToolTip(ladr_bg, "直接访问Local内存")
    GadgetToolTip(ladr_sg, "回读的DMALADRx的值") 
    GadgetToolTip(padr_sg, "回读的DMAPADRx的值") 
    GadgetToolTip(size_sg, "回读的DMASIZx的值")
    SetGadgetColor(ladr_sg, #PB_Gadget_FrontColor, RGB(00, $FF, 00))
    SetGadgetColor(ladr_sg, #PB_Gadget_BackColor, RGB(00, 00, 00))  
    SetGadgetColor(padr_sg, #PB_Gadget_FrontColor, RGB(00, $FF, 00))
    SetGadgetColor(padr_sg, #PB_Gadget_BackColor, RGB(00, 00, 00))
    SetGadgetColor(size_sg, #PB_Gadget_FrontColor, RGB(00, $FF, 00))
    SetGadgetColor(size_sg, #PB_Gadget_BackColor, RGB(00, 00, 00))    
    SetGadgetFont(ladr_sg, FontID(big_font2))
    SetGadgetFont(padr_sg, FontID(big_font2))               
    SetGadgetFont(size_sg, FontID(big_font2))
    ladr_select = ComboBoxGadget(#PB_Any, 30, 100, 130, 20)
    size_select = ComboBoxGadget(#PB_Any, 390, 100, 130, 20)
    AddGadgetItem(size_select, -1, "no change")    
    AddGadgetItem(size_select, -1, "8byte")    
    AddGadgetItem(size_select, -1, "16byte")    
    AddGadgetItem(size_select, -1, "32byte")    
    AddGadgetItem(size_select, -1, "64byte")    
    AddGadgetItem(size_select, -1, "128byte")    
    AddGadgetItem(size_select, -1, "256byte")    
    AddGadgetItem(size_select, -1, "512byte")    
    AddGadgetItem(size_select, -1, "1Kbyte")    
    AddGadgetItem(size_select, -1, "2Kbyte")    
    AddGadgetItem(size_select, -1, "4Kbyte")    
    AddGadgetItem(size_select, -1, "8Kbyte")    
    AddGadgetItem(size_select, -1, "16Kbyte")    
    AddGadgetItem(size_select, -1, "32Kbyte")    
    AddGadgetItem(size_select, -1, "64Kbyte")    
    AddGadgetItem(size_select, -1, "128Kbyte")    
    AddGadgetItem(size_select, -1, "256Kbyte")    
    AddGadgetItem(size_select, -1, "512Kbyte")    
    AddGadgetItem(size_select, -1, "1Mbyte")    
    AddGadgetItem(size_select, -1, "2Mbyte")    
    SetGadgetState(size_select, 0)    
    padr_access_bg  = ButtonGadget(#PB_Any, 210, 100, 50, 20, "ACCESS") 
    GadgetToolTip(padr_access_bg, "直接访问PCI内存")
    pre3_bg  = ButtonGadget(#PB_Any, 20, 200, 80, 25, "< Previous")
    next3_bg = ButtonGadget(#PB_Any, 120, 200, 80, 25, "Next >")
    GadgetToolTip(next3_bg, "下一步")
    GadgetToolTip(pre3_bg, "上一步")    
    CloseGadgetList()
    HideGadget(container3, #True) 
    
    container4  = ContainerGadget(#PB_Any, 0, 40, 550, 230)
    frame4_0  = Frame3DGadget(#PB_Any, 10, 10, 530, 180, "DMA Arbitration仲裁")   
    Local_Bus_Latency_Timer_Enable_cbg  = CheckBoxGadget(#PB_Any, 30, 30, 200, 20, "Local Bus Latency Timer Enable")    
    Local_Bus_Latency_Timer_tbg = TrackBarGadget(#PB_Any, 240, 25, 270, 30, 0, 255)
    DisableGadget(Local_Bus_Latency_Timer_tbg, #True)
    Local_Bus_Pause_Timer_Enable_cbg  = CheckBoxGadget(#PB_Any, 30, 60, 200, 20, "Local Bus Pause Timer Enable")   
    Local_Bus_Pause_Timer_tbg = TrackBarGadget(#PB_Any, 240, 60, 270, 30, 0, 255)
    DisableGadget(Local_Bus_Pause_Timer_tbg, #True)    
    Local_Bus_BREQ_Enable_cbg = CheckBoxGadget(#PB_Any, 30, 92, 200, 20, "Local Bus BREQ Enable")    
    ch0_prio_og = OptionGadget(#PB_Any, 30, 125, 200, 20, "Ch0 has priority")
    ch1_prio_og = OptionGadget(#PB_Any, 30, 145, 200, 20, "Ch1 has priority")
    rotational_prio_og  = OptionGadget(#PB_Any, 30, 165, 200, 20, "Rotational priority")
    text4_0 = TextGadget(#PB_Any, 250, 110, 160, 20, "MARBR/DMAARB")
    SetGadgetFont(text4_0, FontID(big_font2))
    marb_sg  = StringGadget(#PB_Any, 250, 130, 100, 20, "00000000", #PB_String_UpperCase|#PB_String_ReadOnly)   
    SetGadgetColor(marb_sg, #PB_Gadget_FrontColor, RGB(00, $FF, 00))
    SetGadgetColor(marb_sg, #PB_Gadget_BackColor, RGB(00, 00, 00))
    SetGadgetFont(marb_sg, FontID(big_font2))
    GadgetToolTip(Local_Bus_Latency_Timer_Enable_cbg, "使能plx9054释放LHOLD前的延时")     
    GadgetToolTip(Local_Bus_Latency_Timer_tbg, "plx9054释放LHOLD前的延时周期，最大255个LCLK周期")     
    GadgetToolTip(Local_Bus_Pause_Timer_Enable_cbg, "使能plx9054再次发起LHOLD的间隔延时")     
    GadgetToolTip(Local_Bus_Pause_Timer_tbg, "plx9054再次发起LHOLD前的延时周期，最大255个LCLK周期")     
    GadgetToolTip(Local_Bus_BREQ_Enable_cbg, "允许其它master优先使用总线的请求")     
    GadgetToolTip(ch0_prio_og, "ch0占优先")     
    GadgetToolTip(ch1_prio_og, "ch1占优先")    
    GadgetToolTip(rotational_prio_og, "轮流占优先")
    GadgetToolTip(marb_sg, "回读的MARBR寄存器的值")    
    pre4_bg  = ButtonGadget(#PB_Any, 20, 200, 80, 25, "< Previous")
    next4_bg = ButtonGadget(#PB_Any, 120, 200, 80, 25, "Next >")
    GadgetToolTip(next4_bg, "下一步")
    GadgetToolTip(pre4_bg, "上一步")    
    CloseGadgetList()
    HideGadget(container4, #True)  
    
    small_font1  = LoadFont(#PB_Any,"Courier",8, #PB_Font_HighQuality)    
    container5  = ContainerGadget(#PB_Any, 0, 40, 550, 230)
    frame5_0  = Frame3DGadget(#PB_Any, 10, 10, 530, 180, "DMA 触发")   
    trigger_bg  = ButtonGadget(#PB_Any, 25, 35, 50, 20, "Start")
    trigger_times_sg  = StringGadget(#PB_Any, 25, 60, 150, 20, "10", #PB_String_Numeric)
    trigger_counts_sg = StringGadget(#PB_Any, 25, 85, 150, 20, "0", #PB_String_ReadOnly)
    SetGadgetFont(trigger_times_sg, FontID(big_font2))
    SetGadgetFont(trigger_counts_sg, FontID(big_font2))
    SendMessage_(GadgetID(trigger_times_sg), #EM_SETLIMITTEXT, 8, 0)
    log_eg  = EditorGadget(#PB_Any, 185, 20, 350, 165, #PB_Editor_ReadOnly|#ES_MULTILINE)
    SetGadgetFont(log_eg, FontID(small_font1))    
    GadgetToolTip(trigger_bg, "手动触发DMA")     
    GadgetToolTip(trigger_times_sg, "输入要连续触发的次数")     
    GadgetToolTip(trigger_counts_sg, "已触发的DMA的次数")     
    GadgetToolTip(log_eg, "log输出")
    pre5_bg  = ButtonGadget(#PB_Any, 20, 200, 80, 25, "< Previous", #PB_Button_Default)
    copy_log_bg = ButtonGadget(#PB_Any, 500, 195, 40, 35, "COPY LOG", #PB_Button_MultiLine)
    clear_log_bg = ButtonGadget(#PB_Any, 450, 195, 40, 35, "CLEAR LOG", #PB_Button_MultiLine)    
    GadgetToolTip(copy_log_bg, "COPY")    
    GadgetToolTip(clear_log_bg, "清空log")        
    GadgetToolTip(pre5_bg, "上一步")    
    CloseGadgetList()
    HideGadget(container5, #True)  
    
          
    capture_bg  = ButtonGadget(#PB_Any, 508, 0, 40, 20, "BMP")
    GadgetToolTip(capture_bg, "Take a Pic") 
    
    top_bg  = ButtonGadget(#PB_Any, 508, 20, 20, 20, "↑", #PB_Button_Toggle)
    GadgetToolTip(top_bg, "Always On The Top")
    
    lock_bg  = ButtonGadget(#PB_Any, 529, 20, 20, 20, "L", #PB_Button_Toggle)
    GadgetToolTip(lock_bg, "LOCK resource")     
        
    name_bar  = CreateStatusBar(#PB_Any, WindowID(hwnd))
    If name_bar
      AddStatusBarField(450)
      AddStatusBarField(100)
    EndIf
    
    card_res_name.s = Space(4096)
    memory_res_name.s = Space(4096)
    viGetAttribute(card_res, #VI_ATTR_RSRC_NAME, @card_res_name)
    viGetAttribute(memory_res, #VI_ATTR_RSRC_NAME, @memory_res_name)
    
    StatusBarText(name_bar, 0, card_res_name + " & " + memory_res_name)
    StatusBarText(name_bar, 1, "0Mbyte/s", #PB_StatusBar_Center)
    
    AddWindowTimer(hwnd, 0, 100)  ;for step1~4
    
    value1.q = 0    ;mode
    value2.q  = 0   ;dir
    value3.q  = 0   ;padr
    value4.q  = 0   ;ladr
    value5.q  = 0   ;size
    value6.q  = 0   ;marbr
    log_text  = ""
    
    Repeat
      Event.l = WaitWindowEvent()
      
      Select  Event
        Case  #PB_Event_Timer
          Select  EventTimer()
            Case  0
              If  active_channel
                viIn32(card_res, #VI_PXI_BAR0_SPACE, #PCI9054_DMAMODE0, @value1)
                viIn32(card_res, #VI_PXI_BAR0_SPACE, #PCI9054_DMADPR0, @value2)
                viIn32(card_res, #VI_PXI_BAR0_SPACE, #PCI9054_DMAPADR0, @value3)
                viIn32(card_res, #VI_PXI_BAR0_SPACE, #PCI9054_DMALADR0, @value4)
                viIn32(card_res, #VI_PXI_BAR0_SPACE, #PCI9054_DMASIZ0, @value5)
              Else
                viIn32(card_res, #VI_PXI_BAR0_SPACE, #PCI9054_DMAMODE1, @value1)
                viIn32(card_res, #VI_PXI_BAR0_SPACE, #PCI9054_DMADPR1, @value2) 
                viIn32(card_res, #VI_PXI_BAR0_SPACE, #PCI9054_DMAPADR1, @value3)
                viIn32(card_res, #VI_PXI_BAR0_SPACE, #PCI9054_DMALADR1, @value4)
                viIn32(card_res, #VI_PXI_BAR0_SPACE, #PCI9054_DMASIZ1, @value5)
              EndIf
              viIn32(card_res, #VI_PXI_BAR0_SPACE, #PCI9054_DMAARB, @value6)
              SetGadgetText(mode_sg, RSet(Hex(value1, #PB_Long), 8, "0"))
              SetGadgetText(dir_sg, RSet(Hex(value2, #PB_Long), 8, "0"))
              SetGadgetText(ladr_sg, RSet(Hex(value4, #PB_Long), 8, "0"))
              SetGadgetText(padr_sg, RSet(Hex(value3, #PB_Long), 8, "0"))
              SetGadgetText(size_sg, RSet(Hex(value5, #PB_Long), 8, "0"))
              SetGadgetText(marb_sg, RSet(Hex(value6, #PB_Long), 8, "0"))
              
              If  BitTst(value6, 16)
                SetGadgetState(Local_Bus_Latency_Timer_Enable_cbg, #True)
                DisableGadget(Local_Bus_Latency_Timer_tbg, #False)
              Else
                SetGadgetState(Local_Bus_Latency_Timer_Enable_cbg, #False)
                DisableGadget(Local_Bus_Latency_Timer_tbg, #True)
              EndIf
              If  BitTst(value6, 17)
                SetGadgetState(Local_Bus_pause_Timer_Enable_cbg, #True)
                DisableGadget(Local_Bus_pause_Timer_tbg, #False)
              Else
                SetGadgetState(Local_Bus_pause_Timer_Enable_cbg, #False)
                DisableGadget(Local_Bus_pause_Timer_tbg, #True)
              EndIf  
              If  BitTst(value6, 18)
                SetGadgetState(Local_Bus_BREQ_Enable_cbg, #True)
              Else
                SetGadgetState(Local_Bus_BREQ_Enable_cbg, #False)
              EndIf
              temp  = ($0000000000180000 & value6)>>19
              Select  temp
                Case  1
                  SetGadgetState(ch0_prio_og, #True)
                Case  2
                  SetGadgetState(ch1_prio_og, #True)
                Case  0
                  SetGadgetState(rotational_prio_og, #True)
                Case  3
                  ;
              EndSelect
              SetGadgetState(Local_Bus_Latency_Timer_tbg, $00000000000000FF  & value6)
              SetGadgetState(Local_Bus_Pause_Timer_tbg, ($000000000000FF00  & value6)>>8)
              If  GetGadgetText(trigger_times_sg) = ""
                DisableGadget(trigger_bg, #True)
              Else
                DisableGadget(trigger_bg, #False)
              EndIf
              
            Case  1
              If  active_channel
                SetGadgetText(trigger_counts_sg, Str(parameter_array(1)))
              Else
                SetGadgetText(trigger_counts_sg, Str(parameter_array(2)))
              EndIf
              
              If  log_text  <>  GetGadgetText(log_eg)
                SetGadgetText(log_eg, log_text)
                SendMessage_(GadgetID(log_eg), #EM_SETSEL, 0, -1)
                SendMessage_(GadgetID(log_eg), #EM_SETSEL, -1, 0)                  
              EndIf
              
              parameter_array(0)  = @log_text
              parameter_array(3)  = Val(GetGadgetText(trigger_times_sg))
              
              If  0 = parameter_array(5)
                parameter_array(5)  = 1
              EndIf
              
              speed.f = value5*1000/(1024*1024*parameter_array(5))
              If  1 <>  parameter_array(6)
                DisableGadget(trigger_bg, #False)
                StatusBarText(name_bar, 1, "0Mbyte/s", #PB_StatusBar_Center)                               
              Else
                DisableGadget(trigger_bg, #True)
                StatusBarText(name_bar, 1, StrF(speed, 2) + "Mbyte/s", #PB_StatusBar_Center)                
              EndIf
              
          EndSelect
        Case  #PB_Event_Menu
          Select  EventMenu()
            Case  0
              ;
            Case  1
              ;
          EndSelect
        Case  #PB_Event_Gadget
          Select  EventGadget()
            Case  ladr_bg              
              card_array.card_info(0)\card  = *card
              card_array.card_info(0)\bar  = #VI_PXI_BAR2_SPACE
              card_array.card_info(0)\x  = ori_x
              card_array.card_info(0)\y  = ori_y
              
              Select  GetGadgetText(ladr_select)
                Case  "no change"
                  MessageBox_(WindowID(hwnd), "-=cv=- 2012.9" + Chr(13) + Chr(10) + "please select a local ram", "..cv..", #MB_OK | #MB_ICONINFORMATION|#MB_SYSTEMMODAL)
                Case  "ram0_0"
                  card_array.card_info(0)\offset_address  = $0
                  card_array.card_info(0)\title  = @"ram0_0"                  
                  card_array.card_info(0)\backup1  = $400  ;1kbyte  
                  thread1  = CreateThread(@pxi_block_access(), @card_array())                   
                Case  "ram0_1"
                  card_array.card_info(0)\offset_address  = $400
                  card_array.card_info(0)\title  = @"ram0_1"                  
                  card_array.card_info(0)\backup1  = $400  ;1kbyte
                  thread1  = CreateThread(@pxi_block_access(), @card_array())
                Case  "ram0_2"
                  card_array.card_info(0)\offset_address  = $800
                  card_array.card_info(0)\title  = @"ram0_2"                  
                  card_array.card_info(0)\backup1  = $400  ;1kbyte
                  thread1  = CreateThread(@pxi_block_access(), @card_array())
                Case  "ram0_3"
                  card_array.card_info(0)\offset_address  = $C00
                  card_array.card_info(0)\title  = @"ram0_3"                  
                  card_array.card_info(0)\backup1  = $400  ;1kbyte
                  thread1  = CreateThread(@pxi_block_access(), @card_array())
                Case  "ram0_4"
                  card_array.card_info(0)\offset_address  = $1000
                  card_array.card_info(0)\title  = @"ram0_4"                  
                  card_array.card_info(0)\backup1  = $400  ;1kbyte 
                  thread1  = CreateThread(@pxi_block_access(), @card_array())
                Case  "ram0_5"
                  card_array.card_info(0)\offset_address  = $1400
                  card_array.card_info(0)\title  = @"ram0_5"                  
                  card_array.card_info(0)\backup1  = $400  ;1kbyte 
                  thread1  = CreateThread(@pxi_block_access(), @card_array())
                Case  "ram0_6"
                  card_array.card_info(0)\offset_address  = $1800
                  card_array.card_info(0)\title  = @"ram0_6"                  
                  card_array.card_info(0)\backup1  = $400  ;1kbyte 
                  thread1  = CreateThread(@pxi_block_access(), @card_array())
                Case  "ram0_7"
                  card_array.card_info(0)\offset_address  = $1C00
                  card_array.card_info(0)\title  = @"ram0_7"                  
                  card_array.card_info(0)\backup1  = $400  ;1kbyte 
                  thread1  = CreateThread(@pxi_block_access(), @card_array())
                Case  "ram1_0"
                  card_array.card_info(0)\offset_address  = $200000
                  card_array.card_info(0)\title  = @"ram1_0"                  
                  card_array.card_info(0)\backup1  = $100000  ;1Mbyte 
                  thread1  = CreateThread(@pxi_block_access(), @card_array())
                Case  "ram1_1"
                  card_array.card_info(0)\offset_address  = $300000
                  card_array.card_info(0)\title  = @"ram1_1"                  
                  card_array.card_info(0)\backup1  = $100000  ;1Mbyte        
                  thread1  = CreateThread(@pxi_block_access(), @card_array())
              EndSelect              
            Case  padr_access_bg
              card_array.card_info(1)\card  = memory_res
              card_array.card_info(1)\bar  = #VI_PXI_ALLOC_SPACE
              card_array.card_info(1)\x  = ori_x
              card_array.card_info(1)\y  = ori_y
              
              If active_channel          
                card_array.card_info(1)\offset_address  = dma_ch0_buffer_header
                card_array.card_info(1)\title  = @"DMA Buffer For CH0"
              Else
                card_array.card_info(1)\offset_address  = dma_ch1_buffer_header
                card_array.card_info(1)\title  = @"DMA Buffer For CH1"
              EndIf
              
              card_array.card_info(1)\backup1  = $200000  ;2Mbyte
              thread2  = CreateThread(@pxi_block_access(), @card_array() + SizeOf(card_info))               
            Case  copy_log_bg
              SetClipboardText(log_text)
              SendMessage_(GadgetID(log_eg), #EM_SETSEL, 0, -1)
            Case  clear_log_bg
              log_text  = ""
              If  active_channel
                log_text  = log_text  + "card_res: " + card_res_name + Chr(13) + Chr(10)
                log_text  = log_text  + "memory_res: " + memory_res_name + Chr(13) + Chr(10)                
                log_text  = log_text  + "PLX9054 DMA CH0" + Chr(13) + Chr(10)
                log_text  = log_text  + "DMAMODE0: 0x"  + RSet(Hex(value1, #PB_Long), 8, "0") + Chr(13) + Chr(10)
                log_text  = log_text  + "DMADPR0: 0x"  + RSet(Hex(value2, #PB_Long), 8, "0") + Chr(13) + Chr(10)
                log_text  = log_text  + "DMAPADR0: 0x"  + RSet(Hex(value3, #PB_Long), 8, "0") + Chr(13) + Chr(10)
                log_text  = log_text  + "DMALADR0: 0x"  + RSet(Hex(value4, #PB_Long), 8, "0") + Chr(13) + Chr(10)
                log_text  = log_text  + "DMASIZ0: 0x"  + RSet(Hex(value5, #PB_Long), 8, "0") + Chr(13) + Chr(10)
                log_text  = log_text  + "DMAARB: 0x"  + RSet(Hex(value6, #PB_Long), 8, "0") + Chr(13) + Chr(10)
              Else
                log_text  = "PLX9054 DMA CH1" + Chr(13) + Chr(10)
                log_text  = log_text  + "DMAMODE1: 0x"  + RSet(Hex(value1, #PB_Long), 8, "0") + Chr(13) + Chr(10)
                log_text  = log_text  + "DMADPR1: 0x"  + RSet(Hex(value2, #PB_Long), 8, "0") + Chr(13) + Chr(10)
                log_text  = log_text  + "DMAPADR1: 0x"  + RSet(Hex(value3, #PB_Long), 8, "0") + Chr(13) + Chr(10)
                log_text  = log_text  + "DMALADR1: 0x"  + RSet(Hex(value4, #PB_Long), 8, "0") + Chr(13) + Chr(10)
                log_text  = log_text  + "DMASIZ1: 0x"  + RSet(Hex(value5, #PB_Long), 8, "0") + Chr(13) + Chr(10)
                log_text  = log_text  + "DMAARB: 0x"  + RSet(Hex(value6, #PB_Long), 8, "0") + Chr(13) + Chr(10)                
              EndIf
              log_text  = log_text  + "Ready to Start!" + Chr(13) + Chr(10)
              SendMessage_(GadgetID(log_eg), #EM_SETSEL, -1, 0)              
            Case  log_eg
              ;   
            Case  trigger_bg
              If  active_channel
                memory_bit_set(card_res, #VI_PXI_BAR0_SPACE, #PCI9054_DMACSR0_DMACSR1, 1)
              Else
                memory_bit_set(card_res, #VI_PXI_BAR0_SPACE, #PCI9054_DMACSR0_DMACSR1, 9)
              EndIf 
              parameter_array(1)  = 0
              parameter_array(2)  = 0  
              start_time.l  = timeGetTime_()
              parameter_array(4)  = start_time
              log_text  = log_text  + "<dma_start>0@" + Str(0) + "ms" + Chr(13) + Chr(10)
            Case  Local_Bus_Latency_Timer_tbg
              Delay(10)
              viout8(card_res, #VI_PXI_BAR0_SPACE, #PCI9054_DMAARB, GetGadgetState(Local_Bus_Latency_Timer_tbg))
            Case  Local_Bus_Pause_Timer_tbg
              Delay(10)
              viout8(card_res, #VI_PXI_BAR0_SPACE, #PCI9054_DMAARB + 1, GetGadgetState(Local_Bus_Pause_Timer_tbg))
            Case  Local_Bus_Latency_Timer_Enable_cbg
              Delay(10)
              If  GetGadgetState(Local_Bus_Latency_Timer_Enable_cbg)
                memory_bit_set(card_res, #VI_PXI_BAR0_SPACE, #PCI9054_DMAARB, 16)
              Else
                memory_bit_clear(card_res, #VI_PXI_BAR0_SPACE, #PCI9054_DMAARB, 16)
              EndIf
            Case  Local_Bus_Pause_Timer_Enable_cbg
              Delay(10)
              If  GetGadgetState(Local_Bus_Pause_Timer_Enable_cbg)
                memory_bit_set(card_res, #VI_PXI_BAR0_SPACE, #PCI9054_DMAARB, 17)
              Else
                memory_bit_clear(card_res, #VI_PXI_BAR0_SPACE, #PCI9054_DMAARB, 17)
              EndIf
            Case  Local_Bus_BREQ_Enable_cbg
              Delay(10)
              If  GetGadgetState(Local_Bus_BREQ_Enable_cbg)
                memory_bit_set(card_res, #VI_PXI_BAR0_SPACE, #PCI9054_DMAARB, 18)
              Else
                memory_bit_clear(card_res, #VI_PXI_BAR0_SPACE, #PCI9054_DMAARB, 18)
              EndIf   
            Case  ch0_prio_og
              Delay(10)
              If  GetGadgetState(ch0_prio_og)
                memory_bit_clear(card_res, #VI_PXI_BAR0_SPACE, #PCI9054_DMAARB, 20)
                memory_bit_set(card_res, #VI_PXI_BAR0_SPACE, #PCI9054_DMAARB, 19)
              Else
                ;
              EndIf 
            Case  ch1_prio_og
              Delay(10)
              If  GetGadgetState(ch1_prio_og)
                memory_bit_set(card_res, #VI_PXI_BAR0_SPACE, #PCI9054_DMAARB, 20)
                memory_bit_clear(card_res, #VI_PXI_BAR0_SPACE, #PCI9054_DMAARB, 19)
              Else
                ;
              EndIf 
            Case  rotational_prio_og
              Delay(10)
              If  GetGadgetState(rotational_prio_og)
                memory_bit_clear(card_res, #VI_PXI_BAR0_SPACE, #PCI9054_DMAARB, 20)
                memory_bit_clear(card_res, #VI_PXI_BAR0_SPACE, #PCI9054_DMAARB, 19)
              Else
                ;
              EndIf               
            Case  lock_bg
              Delay(10)
              If  GetGadgetState(lock_bg)
                viLock(card_res, #VI_EXCLUSIVE_LOCK, 200, #VI_NULL, #VI_NULL)
              Else
                viUnlock(card_res)
              EndIf
            Case  top_bg
              Select EventType()
                Case #PB_EventType_LeftClick
                  Delay(10)
                  If  GetGadgetState(top_bg)
                    SetWindowPos_(WindowID(hwnd), #HWND_TOPMOST, 0, 0, 0, 0, #SWP_NOMOVE|#SWP_NOSIZE)
                  Else
                    SetWindowPos_(WindowID(hwnd), #HWND_NOTOPMOST, 0, 0, 0, 0, #SWP_NOMOVE|#SWP_NOSIZE)
                  EndIf                  
              EndSelect                        
            Case  capture_bg
              CaptureWindow(GetWindowTitle(hwnd)) 
            Case  ladr_select
              Select EventType()
                Case #PB_EventType_Change
                  Select  GetGadgetText(ladr_select)
                    Case  "ram0_0"
                      SetGadgetState(size_select, 0)
                      If  active_channel
                        viout32(card_res, #VI_PXI_BAR0_SPACE, #PCI9054_DMALADR0, $30000000)
                        viout32(card_res, #VI_PXI_BAR0_SPACE, #PCI9054_DMASIZ0, $00000400)
                      Else
                        viout32(card_res, #VI_PXI_BAR0_SPACE, #PCI9054_DMALADR1, $30000000)
                        viout32(card_res, #VI_PXI_BAR0_SPACE, #PCI9054_DMASIZ1, $00000400)
                      EndIf
                    Case  "ram0_1"
                      SetGadgetState(size_select, 0)
                      If  active_channel
                        viout32(card_res, #VI_PXI_BAR0_SPACE, #PCI9054_DMALADR0, $30000400)
                        viout32(card_res, #VI_PXI_BAR0_SPACE, #PCI9054_DMASIZ0, $00000400)                        
                      Else
                        viout32(card_res, #VI_PXI_BAR0_SPACE, #PCI9054_DMALADR1, $30000400)
                        viout32(card_res, #VI_PXI_BAR0_SPACE, #PCI9054_DMASIZ1, $00000400)                                                
                      EndIf
                    Case  "ram0_2"
                      SetGadgetState(size_select, 0)                      
                      If  active_channel
                        viout32(card_res, #VI_PXI_BAR0_SPACE, #PCI9054_DMALADR0, $30000800)
                        viout32(card_res, #VI_PXI_BAR0_SPACE, #PCI9054_DMASIZ0, $00000400)
                      Else
                        viout32(card_res, #VI_PXI_BAR0_SPACE, #PCI9054_DMALADR1, $30000800)
                        viout32(card_res, #VI_PXI_BAR0_SPACE, #PCI9054_DMASIZ1, $00000400)
                      EndIf
                    Case  "ram0_3"
                      SetGadgetState(size_select, 0)
                      If  active_channel
                        viout32(card_res, #VI_PXI_BAR0_SPACE, #PCI9054_DMALADR0, $30000C00)
                        viout32(card_res, #VI_PXI_BAR0_SPACE, #PCI9054_DMASIZ0, $00000400)
                      Else
                        viout32(card_res, #VI_PXI_BAR0_SPACE, #PCI9054_DMALADR1, $30000C00)
                        viout32(card_res, #VI_PXI_BAR0_SPACE, #PCI9054_DMASIZ1, $00000400)
                      EndIf   
                    Case  "ram0_4"
                      SetGadgetState(size_select, 0)
                      If  active_channel
                        viout32(card_res, #VI_PXI_BAR0_SPACE, #PCI9054_DMALADR0, $30001000)
                        viout32(card_res, #VI_PXI_BAR0_SPACE, #PCI9054_DMASIZ0, $00000400)
                      Else
                        viout32(card_res, #VI_PXI_BAR0_SPACE, #PCI9054_DMALADR1, $30001000)
                        viout32(card_res, #VI_PXI_BAR0_SPACE, #PCI9054_DMASIZ1, $00000400)
                      EndIf
                    Case  "ram0_5"
                      SetGadgetState(size_select, 0)
                      If  active_channel
                        viout32(card_res, #VI_PXI_BAR0_SPACE, #PCI9054_DMALADR0, $30001400)
                        viout32(card_res, #VI_PXI_BAR0_SPACE, #PCI9054_DMASIZ0, $00000400)
                      Else
                        viout32(card_res, #VI_PXI_BAR0_SPACE, #PCI9054_DMALADR1, $30001400)
                        viout32(card_res, #VI_PXI_BAR0_SPACE, #PCI9054_DMASIZ1, $00000400)
                      EndIf
                    Case  "ram0_6"
                      SetGadgetState(size_select, 0)
                      If  active_channel
                        viout32(card_res, #VI_PXI_BAR0_SPACE, #PCI9054_DMALADR0, $30001800)
                        viout32(card_res, #VI_PXI_BAR0_SPACE, #PCI9054_DMASIZ0, $00000400)
                      Else
                        viout32(card_res, #VI_PXI_BAR0_SPACE, #PCI9054_DMALADR1, $30001800)
                        viout32(card_res, #VI_PXI_BAR0_SPACE, #PCI9054_DMASIZ1, $00000400)
                      EndIf
                    Case  "ram0_7"
                      SetGadgetState(size_select, 0)
                      If  active_channel
                        viout32(card_res, #VI_PXI_BAR0_SPACE, #PCI9054_DMALADR0, $30001C00)
                        viout32(card_res, #VI_PXI_BAR0_SPACE, #PCI9054_DMASIZ0, $00000400)
                      Else
                        viout32(card_res, #VI_PXI_BAR0_SPACE, #PCI9054_DMALADR1, $30001C00)
                        viout32(card_res, #VI_PXI_BAR0_SPACE, #PCI9054_DMASIZ1, $00000400)
                      EndIf  
                    Case  "ram1_0"
                      SetGadgetState(size_select, 0)
                      If  active_channel
                        viout32(card_res, #VI_PXI_BAR0_SPACE, #PCI9054_DMALADR0, $30200000)
                        viout32(card_res, #VI_PXI_BAR0_SPACE, #PCI9054_DMASIZ0, $00100000)
                      Else
                        viout32(card_res, #VI_PXI_BAR0_SPACE, #PCI9054_DMALADR1, $30200000)
                        viout32(card_res, #VI_PXI_BAR0_SPACE, #PCI9054_DMASIZ1, $00100000)
                      EndIf 
                    Case  "ram1_1"
                      SetGadgetState(size_select, 0)
                      If  active_channel
                        viout32(card_res, #VI_PXI_BAR0_SPACE, #PCI9054_DMALADR0, $30300000)
                        viout32(card_res, #VI_PXI_BAR0_SPACE, #PCI9054_DMASIZ0, $00100000)
                      Else
                        viout32(card_res, #VI_PXI_BAR0_SPACE, #PCI9054_DMALADR1, $30300000)
                        viout32(card_res, #VI_PXI_BAR0_SPACE, #PCI9054_DMASIZ1, $00100000)
                      EndIf
                    Case  "fifo0_0"
                      If  active_channel
                        viout32(card_res, #VI_PXI_BAR0_SPACE, #PCI9054_DMALADR0, $20000000)
                      Else
                        viout32(card_res, #VI_PXI_BAR0_SPACE, #PCI9054_DMALADR1, $20000000)
                      EndIf  
                    Case  "fifo0_1"
                      If  active_channel
                        viout32(card_res, #VI_PXI_BAR0_SPACE, #PCI9054_DMALADR0, $20000004)
                      Else
                        viout32(card_res, #VI_PXI_BAR0_SPACE, #PCI9054_DMALADR1, $20000004)
                      EndIf  
                    Case  "fifo0_2"
                      If  active_channel
                        viout32(card_res, #VI_PXI_BAR0_SPACE, #PCI9054_DMALADR0, $20000008)
                      Else
                        viout32(card_res, #VI_PXI_BAR0_SPACE, #PCI9054_DMALADR1, $20000008)
                      EndIf  
                    Case  "fifo0_3"
                      If  active_channel
                        viout32(card_res, #VI_PXI_BAR0_SPACE, #PCI9054_DMALADR0, $2000000C)
                      Else
                        viout32(card_res, #VI_PXI_BAR0_SPACE, #PCI9054_DMALADR1, $2000000C)
                      EndIf   
                    Case  "fifo0_4"
                      If  active_channel
                        viout32(card_res, #VI_PXI_BAR0_SPACE, #PCI9054_DMALADR0, $20000010)
                      Else
                        viout32(card_res, #VI_PXI_BAR0_SPACE, #PCI9054_DMALADR1, $20000010)
                      EndIf  
                    Case  "fifo0_5"
                      If  active_channel
                        viout32(card_res, #VI_PXI_BAR0_SPACE, #PCI9054_DMALADR0, $20000014)
                      Else
                        viout32(card_res, #VI_PXI_BAR0_SPACE, #PCI9054_DMALADR1, $20000014)
                      EndIf  
                    Case  "fifo0_6"
                      If  active_channel
                        viout32(card_res, #VI_PXI_BAR0_SPACE, #PCI9054_DMALADR0, $20000018)
                      Else
                        viout32(card_res, #VI_PXI_BAR0_SPACE, #PCI9054_DMALADR1, $20000018)
                      EndIf  
                    Case  "fifo0_7"
                      If  active_channel
                        viout32(card_res, #VI_PXI_BAR0_SPACE, #PCI9054_DMALADR0, $2000001C)
                      Else
                        viout32(card_res, #VI_PXI_BAR0_SPACE, #PCI9054_DMALADR1, $2000001C)
                      EndIf  
                    Case  "fifo0_8"
                      If  active_channel
                        viout32(card_res, #VI_PXI_BAR0_SPACE, #PCI9054_DMALADR0, $20000020)
                      Else
                        viout32(card_res, #VI_PXI_BAR0_SPACE, #PCI9054_DMALADR1, $20000020)
                      EndIf  
                    Case  "fifo0_9"
                      If  active_channel
                        viout32(card_res, #VI_PXI_BAR0_SPACE, #PCI9054_DMALADR0, $20000024)
                      Else
                        viout32(card_res, #VI_PXI_BAR0_SPACE, #PCI9054_DMALADR1, $20000024)
                      EndIf  
                    Case  "fifo0_10"
                      If  active_channel
                        viout32(card_res, #VI_PXI_BAR0_SPACE, #PCI9054_DMALADR0, $20000028)
                      Else
                        viout32(card_res, #VI_PXI_BAR0_SPACE, #PCI9054_DMALADR1, $20000028)
                      EndIf  
                    Case  "fifo0_11"
                      If  active_channel
                        viout32(card_res, #VI_PXI_BAR0_SPACE, #PCI9054_DMALADR0, $2000002C)
                      Else
                        viout32(card_res, #VI_PXI_BAR0_SPACE, #PCI9054_DMALADR1, $2000002C)
                      EndIf   
                    Case  "fifo0_12"
                      If  active_channel
                        viout32(card_res, #VI_PXI_BAR0_SPACE, #PCI9054_DMALADR0, $20000030)
                      Else
                        viout32(card_res, #VI_PXI_BAR0_SPACE, #PCI9054_DMALADR1, $20000030)
                      EndIf  
                    Case  "fifo0_13"
                      If  active_channel
                        viout32(card_res, #VI_PXI_BAR0_SPACE, #PCI9054_DMALADR0, $20000034)
                      Else
                        viout32(card_res, #VI_PXI_BAR0_SPACE, #PCI9054_DMALADR1, $20000034)
                      EndIf  
                    Case  "fifo0_14"
                      If  active_channel
                        viout32(card_res, #VI_PXI_BAR0_SPACE, #PCI9054_DMALADR0, $20000038)
                      Else
                        viout32(card_res, #VI_PXI_BAR0_SPACE, #PCI9054_DMALADR1, $20000038)
                      EndIf  
                    Case  "fifo0_15"
                      If  active_channel
                        viout32(card_res, #VI_PXI_BAR0_SPACE, #PCI9054_DMALADR0, $2000003C)
                      Else
                        viout32(card_res, #VI_PXI_BAR0_SPACE, #PCI9054_DMALADR1, $2000003C)
                      EndIf 
                    Case  "fifo1_0"
                      If  active_channel
                        viout32(card_res, #VI_PXI_BAR0_SPACE, #PCI9054_DMALADR0, $20000080)
                      Else
                        viout32(card_res, #VI_PXI_BAR0_SPACE, #PCI9054_DMALADR1, $20000080)
                      EndIf  
                    Case  "fifo1_1"
                      If  active_channel
                        viout32(card_res, #VI_PXI_BAR0_SPACE, #PCI9054_DMALADR0, $20000084)
                      Else
                        viout32(card_res, #VI_PXI_BAR0_SPACE, #PCI9054_DMALADR1, $20000084)
                      EndIf  
                    Case  "fifo1_2"
                      If  active_channel
                        viout32(card_res, #VI_PXI_BAR0_SPACE, #PCI9054_DMALADR0, $20000088)
                      Else
                        viout32(card_res, #VI_PXI_BAR0_SPACE, #PCI9054_DMALADR1, $20000088)
                      EndIf  
                    Case  "fifo1_3"
                      If  active_channel
                        viout32(card_res, #VI_PXI_BAR0_SPACE, #PCI9054_DMALADR0, $2000008C)
                      Else
                        viout32(card_res, #VI_PXI_BAR0_SPACE, #PCI9054_DMALADR1, $2000008C)
                      EndIf   
                    Case  "fifo1_4"
                      If  active_channel
                        viout32(card_res, #VI_PXI_BAR0_SPACE, #PCI9054_DMALADR0, $20000090)
                      Else
                        viout32(card_res, #VI_PXI_BAR0_SPACE, #PCI9054_DMALADR1, $20000090)
                      EndIf  
                    Case  "fifo1_5"
                      If  active_channel
                        viout32(card_res, #VI_PXI_BAR0_SPACE, #PCI9054_DMALADR0, $20000094)
                      Else
                        viout32(card_res, #VI_PXI_BAR0_SPACE, #PCI9054_DMALADR1, $20000094)
                      EndIf  
                    Case  "fifo1_6"
                      If  active_channel
                        viout32(card_res, #VI_PXI_BAR0_SPACE, #PCI9054_DMALADR0, $20000098)
                      Else
                        viout32(card_res, #VI_PXI_BAR0_SPACE, #PCI9054_DMALADR1, $20000098)
                      EndIf  
                    Case  "fifo1_7"
                      If  active_channel
                        viout32(card_res, #VI_PXI_BAR0_SPACE, #PCI9054_DMALADR0, $2000009C)
                      Else
                        viout32(card_res, #VI_PXI_BAR0_SPACE, #PCI9054_DMALADR1, $2000009C)
                      EndIf  
                    Case  "fifo1_8"
                      If  active_channel
                        viout32(card_res, #VI_PXI_BAR0_SPACE, #PCI9054_DMALADR0, $200000A0)
                      Else
                        viout32(card_res, #VI_PXI_BAR0_SPACE, #PCI9054_DMALADR1, $200000A0)
                      EndIf  
                    Case  "fifo1_9"
                      If  active_channel
                        viout32(card_res, #VI_PXI_BAR0_SPACE, #PCI9054_DMALADR0, $200000A4)
                      Else
                        viout32(card_res, #VI_PXI_BAR0_SPACE, #PCI9054_DMALADR1, $200000A4)
                      EndIf  
                    Case  "fifo1_10"
                      If  active_channel
                        viout32(card_res, #VI_PXI_BAR0_SPACE, #PCI9054_DMALADR0, $200000A8)
                      Else
                        viout32(card_res, #VI_PXI_BAR0_SPACE, #PCI9054_DMALADR1, $200000A8)
                      EndIf  
                    Case  "fifo1_11"
                      If  active_channel
                        viout32(card_res, #VI_PXI_BAR0_SPACE, #PCI9054_DMALADR0, $200000AC)
                      Else
                        viout32(card_res, #VI_PXI_BAR0_SPACE, #PCI9054_DMALADR1, $200000AC)
                      EndIf   
                    Case  "fifo1_12"
                      If  active_channel
                        viout32(card_res, #VI_PXI_BAR0_SPACE, #PCI9054_DMALADR0, $200000B0)
                      Else
                        viout32(card_res, #VI_PXI_BAR0_SPACE, #PCI9054_DMALADR1, $200000B0)
                      EndIf  
                    Case  "fifo1_13"
                      If  active_channel
                        viout32(card_res, #VI_PXI_BAR0_SPACE, #PCI9054_DMALADR0, $200000B4)
                      Else
                        viout32(card_res, #VI_PXI_BAR0_SPACE, #PCI9054_DMALADR1, $200000B4)
                      EndIf  
                    Case  "fifo1_14"
                      If  active_channel
                        viout32(card_res, #VI_PXI_BAR0_SPACE, #PCI9054_DMALADR0, $200000B8)
                      Else
                        viout32(card_res, #VI_PXI_BAR0_SPACE, #PCI9054_DMALADR1, $200000B8)
                      EndIf  
                    Case  "fifo1_15"
                      If  active_channel
                        viout32(card_res, #VI_PXI_BAR0_SPACE, #PCI9054_DMALADR0, $200000BC)
                      Else
                        viout32(card_res, #VI_PXI_BAR0_SPACE, #PCI9054_DMALADR1, $200000BC)
                      EndIf                      
                    Default
                      ;
                  EndSelect
              EndSelect
            Case  size_select
              Select EventType()
                Case #PB_EventType_Change
                  Select  GetGadgetText(size_select)
                    Case  "8byte"
                      If  active_channel
                        viout32(card_res, #VI_PXI_BAR0_SPACE, #PCI9054_DMASIZ0, $8)
                      Else
                        viout32(card_res, #VI_PXI_BAR0_SPACE, #PCI9054_DMASIZ1, $8)
                      EndIf
                    Case  "16byte"
                      If  active_channel
                        viout32(card_res, #VI_PXI_BAR0_SPACE, #PCI9054_DMASIZ0, $10)
                      Else
                        viout32(card_res, #VI_PXI_BAR0_SPACE, #PCI9054_DMASIZ1, $10)
                      EndIf                      
                    Case  "32byte"
                      If  active_channel
                        viout32(card_res, #VI_PXI_BAR0_SPACE, #PCI9054_DMASIZ0, $20)
                      Else
                        viout32(card_res, #VI_PXI_BAR0_SPACE, #PCI9054_DMASIZ1, $20)
                      EndIf                      
                    Case  "64byte"
                      If  active_channel
                        viout32(card_res, #VI_PXI_BAR0_SPACE, #PCI9054_DMASIZ0, $40)
                      Else
                        viout32(card_res, #VI_PXI_BAR0_SPACE, #PCI9054_DMASIZ1, $40)
                      EndIf                      
                    Case  "128byte"
                      If  active_channel
                        viout32(card_res, #VI_PXI_BAR0_SPACE, #PCI9054_DMASIZ0, $80)
                      Else
                        viout32(card_res, #VI_PXI_BAR0_SPACE, #PCI9054_DMASIZ1, $80)
                      EndIf                      
                    Case  "256byte"
                      If  active_channel
                        viout32(card_res, #VI_PXI_BAR0_SPACE, #PCI9054_DMASIZ0, $100)
                      Else
                        viout32(card_res, #VI_PXI_BAR0_SPACE, #PCI9054_DMASIZ1, $100)
                      EndIf                      
                    Case  "512byte"
                      If  active_channel
                        viout32(card_res, #VI_PXI_BAR0_SPACE, #PCI9054_DMASIZ0, $200)
                      Else
                        viout32(card_res, #VI_PXI_BAR0_SPACE, #PCI9054_DMASIZ1, $200)
                      EndIf                      
                    Case  "1Kbyte"
                      If  active_channel
                        viout32(card_res, #VI_PXI_BAR0_SPACE, #PCI9054_DMASIZ0, $400)
                      Else
                        viout32(card_res, #VI_PXI_BAR0_SPACE, #PCI9054_DMASIZ1, $400)
                      EndIf                      
                    Case  "2Kbyte"
                      If  active_channel
                        viout32(card_res, #VI_PXI_BAR0_SPACE, #PCI9054_DMASIZ0, $800)
                      Else
                        viout32(card_res, #VI_PXI_BAR0_SPACE, #PCI9054_DMASIZ1, $800)
                      EndIf                      
                    Case  "4Kbyte"
                      If  active_channel
                        viout32(card_res, #VI_PXI_BAR0_SPACE, #PCI9054_DMASIZ0, $1000)
                      Else
                        viout32(card_res, #VI_PXI_BAR0_SPACE, #PCI9054_DMASIZ1, $1000)
                      EndIf                      
                    Case  "8Kbyte"
                      If  active_channel
                        viout32(card_res, #VI_PXI_BAR0_SPACE, #PCI9054_DMASIZ0, $2000)
                      Else
                        viout32(card_res, #VI_PXI_BAR0_SPACE, #PCI9054_DMASIZ1, $2000)
                      EndIf                      
                    Case  "16Kbyte"
                      If  active_channel
                        viout32(card_res, #VI_PXI_BAR0_SPACE, #PCI9054_DMASIZ0, $4000)
                      Else
                        viout32(card_res, #VI_PXI_BAR0_SPACE, #PCI9054_DMASIZ1, $4000)
                      EndIf                      
                    Case  "32Kbyte"
                      If  active_channel
                        viout32(card_res, #VI_PXI_BAR0_SPACE, #PCI9054_DMASIZ0, $8000)
                      Else
                        viout32(card_res, #VI_PXI_BAR0_SPACE, #PCI9054_DMASIZ1, $8000)
                      EndIf                      
                    Case  "64Kbyte"
                      If  active_channel
                        viout32(card_res, #VI_PXI_BAR0_SPACE, #PCI9054_DMASIZ0, $10000)
                      Else
                        viout32(card_res, #VI_PXI_BAR0_SPACE, #PCI9054_DMASIZ1, $10000)
                      EndIf                      
                    Case  "128Kbyte" 
                      If  active_channel
                        viout32(card_res, #VI_PXI_BAR0_SPACE, #PCI9054_DMASIZ0, $20000)
                      Else
                        viout32(card_res, #VI_PXI_BAR0_SPACE, #PCI9054_DMASIZ1, $20000)
                      EndIf                      
                    Case  "256Kbyte"
                      If  active_channel
                        viout32(card_res, #VI_PXI_BAR0_SPACE, #PCI9054_DMASIZ0, $40000)
                      Else
                        viout32(card_res, #VI_PXI_BAR0_SPACE, #PCI9054_DMASIZ1, $40000)
                      EndIf                      
                    Case  "512Kbyte"
                      If  active_channel
                        viout32(card_res, #VI_PXI_BAR0_SPACE, #PCI9054_DMASIZ0, $80000)
                      Else
                        viout32(card_res, #VI_PXI_BAR0_SPACE, #PCI9054_DMASIZ1, $80000)
                      EndIf                      
                    Case  "1Mbyte"
                      If  active_channel
                        viout32(card_res, #VI_PXI_BAR0_SPACE, #PCI9054_DMASIZ0, $100000)
                      Else
                        viout32(card_res, #VI_PXI_BAR0_SPACE, #PCI9054_DMASIZ1, $100000)
                      EndIf                      
                    Case  "2Mbyte"
                      If  active_channel
                        viout32(card_res, #VI_PXI_BAR0_SPACE, #PCI9054_DMASIZ0, $200000)
                      Else
                        viout32(card_res, #VI_PXI_BAR0_SPACE, #PCI9054_DMASIZ1, $200000)
                      EndIf                                                              
                    Default
                      ;
                  EndSelect
              EndSelect              
            Case  mode_select
              Select EventType()
                Case #PB_EventType_Change
                  Select  GetGadgetText(mode_select)
                    Case  "32bit_block_0wait_lram"
                      If  active_channel
                        viout32(card_res, #VI_PXI_BAR0_SPACE, #PCI9054_DMAMODE0, $00020443)
                      Else
                        viout32(card_res, #VI_PXI_BAR0_SPACE, #PCI9054_DMAMODE1, $00020443)
                      EndIf
                    Case  "32bit_block_0wait_lram_burst"
                      If  active_channel
                        viout32(card_res, #VI_PXI_BAR0_SPACE, #PCI9054_DMAMODE0, $00020543)
                      Else
                        viout32(card_res, #VI_PXI_BAR0_SPACE, #PCI9054_DMAMODE1, $00020543)
                      EndIf
                    Case  "32bit_block_0wait_lram_burst_bterm#"
                      If  active_channel
                        viout32(card_res, #VI_PXI_BAR0_SPACE, #PCI9054_DMAMODE0, $000205c3)
                      Else
                        viout32(card_res, #VI_PXI_BAR0_SPACE, #PCI9054_DMAMODE1, $000205c3)
                      EndIf
                    Case  "32bit_block_0wait_lfifo"
                      If  active_channel
                        viout32(card_res, #VI_PXI_BAR0_SPACE, #PCI9054_DMAMODE0, $00020c43)
                      Else
                        viout32(card_res, #VI_PXI_BAR0_SPACE, #PCI9054_DMAMODE1, $00020c43)
                      EndIf
                    Case  "32bit_block_0wait_lfifo_burst"
                      If  active_channel
                        viout32(card_res, #VI_PXI_BAR0_SPACE, #PCI9054_DMAMODE0, $00020d43)
                      Else
                        viout32(card_res, #VI_PXI_BAR0_SPACE, #PCI9054_DMAMODE1, $00020d43)
                      EndIf
                    Case  "32bit_block_0wait_lfifo_burst_bterm#"
                      If  active_channel
                        viout32(card_res, #VI_PXI_BAR0_SPACE, #PCI9054_DMAMODE0, $00020dc3)
                      Else
                        viout32(card_res, #VI_PXI_BAR0_SPACE, #PCI9054_DMAMODE1, $00020dc3)
                      EndIf
                    Default
                      ;
                  EndSelect
              EndSelect  
            Case  dir_select
              Select EventType()
                Case #PB_EventType_Change
                  Select  GetGadgetText(dir_select)
                    Case  "Local to PCI"
                      If  active_channel
                        memory_bit_set(card_res, #VI_PXI_BAR0_SPACE, #PCI9054_DMADPR0, 3)
                      Else
                        memory_bit_set(card_res, #VI_PXI_BAR0_SPACE, #PCI9054_DMADPR1, 3)
                      EndIf
                    Case  "PCI to Local"
                      If  active_channel
                        memory_bit_clear(card_res, #VI_PXI_BAR0_SPACE, #PCI9054_DMADPR0, 3)
                      Else
                        memory_bit_clear(card_res, #VI_PXI_BAR0_SPACE, #PCI9054_DMADPR1, 3)
                      EndIf
                    Default
                      ;
                  EndSelect
              EndSelect
            Case  next1_bg
              active_channel  = GetGadgetState(ch0_og)
              If  active_channel
                SetGadgetText(text_tg, "PLX9054 DMA CH0 ControlPanel - Step 2")
                SetGadgetText(text2_0, "DMAMODE0")
                SetGadgetText(text2_1, "DMADPR0")
                GadgetToolTip(mode_sg, "回读的DMAMODE0的值")                
                GadgetToolTip(dir_sg, "回读的DMADPR0的值")  
                GadgetToolTip(mode_select, "修改DMAMODE0寄存器")
                GadgetToolTip(dir_select, "修改DMADPR0寄存器")
                SetGadgetText(text3_0, "DMALADR0")
                SetGadgetText(text3_1, "DMAPADR0")
                SetGadgetText(text3_2, "DMASIZ0")                
                GadgetToolTip(ladr_sg, "回读的DMALADR0的值")                
                GadgetToolTip(padr_sg, "回读的DMAPADR0的值")
                GadgetToolTip(size_sg, "回读的DMASIZ0的值")                  
                GadgetToolTip(ladr_select, "修改DMALADR0寄存器")
                GadgetToolTip(size_select, "修改DMASIZ0寄存器") 
                
              Else
                SetGadgetText(text_tg, "PLX9054 DMA CH1 ControlPanel - Step 2")
                SetGadgetText(text2_0, "DMAMODE1")
                SetGadgetText(text2_1, "DMADPR1")
                GadgetToolTip(mode_sg, "回读的DMAMODE1的值")                
                GadgetToolTip(dir_sg, "回读的DMADPR1的值") 
                GadgetToolTip(mode_select, "修改DMAMODE1寄存器")
                GadgetToolTip(dir_select, "修改DMADPR1寄存器")
                SetGadgetText(text3_0, "DMALADR1")
                SetGadgetText(text3_1, "DMAPADR1")
                SetGadgetText(text3_2, "DMASIZ1")                
                GadgetToolTip(ladr_sg, "回读的DMALADR1的值")                
                GadgetToolTip(padr_sg, "回读的DMAPADR1的值")
                GadgetToolTip(size_sg, "回读的DMASIZ1的值")                  
                GadgetToolTip(ladr_select, "修改DMALADR1寄存器")
                GadgetToolTip(size_select, "修改DMASIZ1寄存器")                   
                
              EndIf
              HideGadget(container1, #True)
              HideGadget(container2, #False)
              SetActiveGadget(next2_bg)
              SetGadgetState(mode_select, 0)
              SetGadgetState(dir_select, 0)
              SetGadgetState(ladr_select, 0)
              SetGadgetState(size_select, 0)
            Case  pre2_bg
              SetGadgetText(text_tg, "PLX9054 DMA ControlPanel - Step 1")
              HideGadget(container1, #False)
              HideGadget(container2, #True)
              SetActiveGadget(next1_bg)
            Case  next2_bg
              If  active_channel
                SetGadgetText(text_tg, "PLX9054 DMA CH0 ControlPanel - Step 3")
              Else
                SetGadgetText(text_tg, "PLX9054 DMA CH1 ControlPanel - Step 3")
              EndIf              
              HideGadget(container3, #False)
              HideGadget(container2, #True)
              SetActiveGadget(next3_bg)
              ClearGadgetItems(ladr_select) 
              AddGadgetItem(ladr_select, -1, "no change")              
              If  BitTst(value1, 11)
                ;fifo
                DisableGadget(ladr_bg, #True)
                If  BitTst(value2, 3)
                  ;fifo1
                  AddGadgetItem(ladr_select, -1, "fifo1_0")                  
                  AddGadgetItem(ladr_select, -1, "fifo1_1")                  
                  AddGadgetItem(ladr_select, -1, "fifo1_2")                  
                  AddGadgetItem(ladr_select, -1, "fifo1_3")                  
                  AddGadgetItem(ladr_select, -1, "fifo1_4")                  
                  AddGadgetItem(ladr_select, -1, "fifo1_5")                  
                  AddGadgetItem(ladr_select, -1, "fifo1_6")                  
                  AddGadgetItem(ladr_select, -1, "fifo1_7")                  
                  AddGadgetItem(ladr_select, -1, "fifo1_8")                  
                  AddGadgetItem(ladr_select, -1, "fifo1_9")                  
                  AddGadgetItem(ladr_select, -1, "fifo1_10")                  
                  AddGadgetItem(ladr_select, -1, "fifo1_11")                  
                  AddGadgetItem(ladr_select, -1, "fifo1_12")                  
                  AddGadgetItem(ladr_select, -1, "fifo1_13")                  
                  AddGadgetItem(ladr_select, -1, "fifo1_14")                  
                  AddGadgetItem(ladr_select, -1, "fifo1_15")                  
                Else
                  ;fifo0
                  AddGadgetItem(ladr_select, -1, "fifo0_0")                  
                  AddGadgetItem(ladr_select, -1, "fifo0_1")                  
                  AddGadgetItem(ladr_select, -1, "fifo0_2")                  
                  AddGadgetItem(ladr_select, -1, "fifo0_3")                  
                  AddGadgetItem(ladr_select, -1, "fifo0_4")                  
                  AddGadgetItem(ladr_select, -1, "fifo0_5")                  
                  AddGadgetItem(ladr_select, -1, "fifo0_6")                  
                  AddGadgetItem(ladr_select, -1, "fifo0_7")                  
                  AddGadgetItem(ladr_select, -1, "fifo0_8")                  
                  AddGadgetItem(ladr_select, -1, "fifo0_9")                  
                  AddGadgetItem(ladr_select, -1, "fifo0_10")                  
                  AddGadgetItem(ladr_select, -1, "fifo0_11")                  
                  AddGadgetItem(ladr_select, -1, "fifo0_12")                  
                  AddGadgetItem(ladr_select, -1, "fifo0_13")                  
                  AddGadgetItem(ladr_select, -1, "fifo0_14")                  
                  AddGadgetItem(ladr_select, -1, "fifo0_15")                  
                EndIf
              Else
                DisableGadget(ladr_bg, #False)
                ;ram
                ;带burst, #bterm的
                AddGadgetItem(ladr_select, -1, "ram0_0")                  
                AddGadgetItem(ladr_select, -1, "ram0_1")                  
                AddGadgetItem(ladr_select, -1, "ram0_2")                  
                AddGadgetItem(ladr_select, -1, "ram0_3")                  
                AddGadgetItem(ladr_select, -1, "ram0_4")                  
                AddGadgetItem(ladr_select, -1, "ram0_5")                  
                AddGadgetItem(ladr_select, -1, "ram0_6")                  
                AddGadgetItem(ladr_select, -1, "ram0_7") 
                ;不带burst, #bterm的
                If  BitTst(value1, 7) | BitTst(value1, 8)
                  ;
                Else
                  AddGadgetItem(ladr_select, -1, "ram1_0")                  
                  AddGadgetItem(ladr_select, -1, "ram1_1")
                EndIf
              EndIf
              SetGadgetState(ladr_select, 0)  
            Case  pre3_bg
              If  active_channel
                SetGadgetText(text_tg, "PLX9054 DMA CH0 ControlPanel - Step 2")
              Else
                SetGadgetText(text_tg, "PLX9054 DMA CH1 ControlPanel - Step 2")
              EndIf              
              HideGadget(container2, #False)
              HideGadget(container3, #True)
              SetActiveGadget(pre2_bg)
            Case  next3_bg
              If  active_channel
                SetGadgetText(text_tg, "PLX9054 DMA ControlPanel - Step 4")
              Else
                SetGadgetText(text_tg, "PLX9054 DMA ControlPanel - Step 4")
              EndIf              
              HideGadget(container4, #False)
              HideGadget(container3, #True)  
              SetActiveGadget(next4_bg)
            Case  pre4_bg
              If  active_channel
                SetGadgetText(text_tg, "PLX9054 DMA CH0 ControlPanel - Step 3")
              Else
                SetGadgetText(text_tg, "PLX9054 DMA CH1 ControlPanel - Step 3")
              EndIf              
              HideGadget(container3, #False)
              HideGadget(container4, #True)
              SetActiveGadget(pre3_bg)
            Case  next4_bg
              If  active_channel
                SetGadgetText(text_tg, "PLX9054 DMA CH0 ControlPanel - Step 5")
              Else
                SetGadgetText(text_tg, "PLX9054 DMA CH1 ControlPanel - Step 5")
              EndIf              
              HideGadget(container5, #False)
              HideGadget(container4, #True)
              SetActiveGadget(pre5_bg)
              ;print value1~6 to log
              log_text  = ""
              If  active_channel
                log_text  = log_text  + "card_res: " + card_res_name + Chr(13) + Chr(10)
                log_text  = log_text  + "memory_res: " + memory_res_name + Chr(13) + Chr(10)                
                log_text  = log_text  + "PLX9054 DMA CH0" + Chr(13) + Chr(10)
                log_text  = log_text  + "DMAMODE0: 0x"  + RSet(Hex(value1, #PB_Long), 8, "0") + Chr(13) + Chr(10)
                log_text  = log_text  + "DMADPR0: 0x"  + RSet(Hex(value2, #PB_Long), 8, "0") + Chr(13) + Chr(10)
                log_text  = log_text  + "DMAPADR0: 0x"  + RSet(Hex(value3, #PB_Long), 8, "0") + Chr(13) + Chr(10)
                log_text  = log_text  + "DMALADR0: 0x"  + RSet(Hex(value4, #PB_Long), 8, "0") + Chr(13) + Chr(10)
                log_text  = log_text  + "DMASIZ0: 0x"  + RSet(Hex(value5, #PB_Long), 8, "0") + Chr(13) + Chr(10)
                log_text  = log_text  + "DMAARB: 0x"  + RSet(Hex(value6, #PB_Long), 8, "0") + Chr(13) + Chr(10)
              Else
                log_text  = "PLX9054 DMA CH1" + Chr(13) + Chr(10)
                log_text  = log_text  + "DMAMODE1: 0x"  + RSet(Hex(value1, #PB_Long), 8, "0") + Chr(13) + Chr(10)
                log_text  = log_text  + "DMADPR1: 0x"  + RSet(Hex(value2, #PB_Long), 8, "0") + Chr(13) + Chr(10)
                log_text  = log_text  + "DMAPADR1: 0x"  + RSet(Hex(value3, #PB_Long), 8, "0") + Chr(13) + Chr(10)
                log_text  = log_text  + "DMALADR1: 0x"  + RSet(Hex(value4, #PB_Long), 8, "0") + Chr(13) + Chr(10)
                log_text  = log_text  + "DMASIZ1: 0x"  + RSet(Hex(value5, #PB_Long), 8, "0") + Chr(13) + Chr(10)
                log_text  = log_text  + "DMAARB: 0x"  + RSet(Hex(value6, #PB_Long), 8, "0") + Chr(13) + Chr(10)                
              EndIf
              log_text  = log_text  + "Ready to Start!" + Chr(13) + Chr(10)
              
              RemoveWindowTimer(hwnd, 0)              
              AddWindowTimer(hwnd, 1, 150)  ;for step5              
            Case  pre5_bg
              If  active_channel
                SetGadgetText(text_tg, "PLX9054 DMA ControlPanel - Step 4")
              Else
                SetGadgetText(text_tg, "PLX9054 DMA ControlPanel - Step 4")
              EndIf              
              HideGadget(container4, #False)
              HideGadget(container5, #True)
              SetActiveGadget(pre4_bg)
              RemoveWindowTimer(hwnd, 1)              
              AddWindowTimer(hwnd, 0, 100) 
          EndSelect
      EndSelect
    Until Event = #PB_Event_CloseWindow Or  quit  = #True  
    
    viMemFree(memory_res, dma_ch0_buffer_header)    
    viMemFree(memory_res, dma_ch1_buffer_header)
    
    viDisableEvent(card_res, #VI_ALL_ENABLED_EVENTS, #VI_ALL_MECH)
    viDisableEvent(memory_res, #VI_ALL_ENABLED_EVENTS, #VI_ALL_MECH)
    viUninstallHandler(card_res, #VI_EVENT_EXCEPTION, @visa32_error_handler(), hwnd)  
    viUninstallHandler(card_res, #VI_EVENT_PXI_INTR, @plx9054_dma_controlpanel_handler(), @parameter_array())        
    viUninstallHandler(memory_res, #VI_EVENT_EXCEPTION, @visa32_error_handler(), hwnd)    
    viClose(card_res)
    viClose(memory_res)
    viClose(visa_default)
    RemoveWindowTimer(hwnd, 0)  
    RemoveWindowTimer(hwnd, 1)
    CloseWindow(hwnd)  
    
    ProcedureReturn #True
    
  EndProcedure  
  
  Procedure pxi_block_access_callback(hwnd, uMsg, wParam, lParam) 
    
    Select  uMsg
      Case  #WM_MOUSEWHEEL
        zDelta.w = ($ffff0000&wParam)>>16
        xPos.w = ($0000ffff&lParam)
        yPos.w = ($ffff0000&lParam)>>16

        re.RECT        
        GetWindowRect_(hwnd, re.RECT) 
        
        If  xPos > re\left
          If  xPos  < re\right
            If  yPos  > re\top + 28*3
              If  yPos  < re\bottom - 30*1
                If  zDelta  > 0 
                  ;mouse_event_(#MOUSEEVENTF_LEFTDOWN, 0, 0, 0, 0)            
                  ;mouse_event_(#MOUSEEVENTF_LEFTUP, 0, 0, 0, 0)              
                  keybd_event_(#VK_PRIOR,0,0,0)           
                  keybd_event_(#VK_PRIOR,0,#KEYEVENTF_KEYUP,0)
                Else
                  ;mouse_event_(#MOUSEEVENTF_LEFTDOWN, 0, 0, 0, 0)            
                  ;mouse_event_(#MOUSEEVENTF_LEFTUP, 0, 0, 0, 0)              
                  keybd_event_(#VK_NEXT,0,0,0)           
                  keybd_event_(#VK_NEXT,0,#KEYEVENTF_KEYUP,0)                  
                EndIf  
              EndIf
            EndIf
          EndIf
        EndIf
    EndSelect
   
    ProcedureReturn #PB_ProcessPureBasicEvents 
    
  EndProcedure   
  
  ProcedureDLL.l  pxi_block_access(*card_info)
    ;内存块访问   
    *card = PeekL(*card_info)   ;read 4byte
    bar.l = PeekL(*card_info  + 4)  ;read 4byte
    offset_address.l = PeekL(*card_info  + 8) ;read 4byte
    x.l = PeekL(*card_info  + 12) ;read 4byte
    y.l = PeekL(*card_info  + 16) ;read 4byte
    *title  = PeekL(*card_info  + 20) ;read 4byte     
    access_size.l = PeekL(*card_info  + 24) ;read 4byte
    
    Dim buffer8.b(0)
    Dim buffer16.w(0)
    Dim buffer32.l(0)    
    
    Dim card_array.card_info(3)
    
    card_array.card_info(0)\card  = *card
    card_array.card_info(0)\bar  = bar
        
    card1 = 0
    ExtractIconEx_("cv_icons.dll", 4, #Null, @card1, 1)    
    
    r8_icon = 0
    r8r_icon  = 0
    w8_icon = 0
    w8r_icon  = 0
    r16_icon = 0
    r16r_icon  = 0
    w16_icon = 0
    w16r_icon  = 0
    r32_icon = 0
    r32r_icon  = 0
    w32_icon = 0
    w32r_icon  = 0
    
    ExtractIconEx_("cv_icons.dll", 112, #Null, @r8_icon, 1)
    ExtractIconEx_("cv_icons.dll", 113, #Null, @r8r_icon, 1)
    ExtractIconEx_("cv_icons.dll", 114, #Null, @w8_icon, 1)
    ExtractIconEx_("cv_icons.dll", 115, #Null, @w8r_icon, 1)
    ExtractIconEx_("cv_icons.dll", 129, #Null, @r16_icon, 1)
    ExtractIconEx_("cv_icons.dll", 130, #Null, @r16r_icon, 1)
    ExtractIconEx_("cv_icons.dll", 131, #Null, @w16_icon, 1)
    ExtractIconEx_("cv_icons.dll", 132, #Null, @w16r_icon, 1)
    ExtractIconEx_("cv_icons.dll", 125, #Null, @r32_icon, 1)
    ExtractIconEx_("cv_icons.dll", 126, #Null, @r32r_icon, 1)
    ExtractIconEx_("cv_icons.dll", 127, #Null, @w32_icon, 1)
    ExtractIconEx_("cv_icons.dll", 128, #Null, @w32r_icon, 1)      
    
    random_icon  = 0
    ExtractIconEx_("cv_icons.dll", 136, #Null, @random_icon, 1)
    add_icon  = 0
    ExtractIconEx_("cv_icons.dll", 133, #Null, @add_icon, 1)
    user_input_icon8  = 0
    ExtractIconEx_("cv_icons.dll", 134, #Null, @user_input_icon8, 1)
    user_input_icon16  = 0
    ExtractIconEx_("cv_icons.dll", 137, #Null, @user_input_icon16, 1)
    user_input_icon32  = 0
    ExtractIconEx_("cv_icons.dll", 135, #Null, @user_input_icon32, 1)  
    
    test_icon  = 0
    ExtractIconEx_("cv_icons.dll", 22, #Null, @test_icon, 1)        
        
    open_icon = 0
    ExtractIconEx_("cv_icons.dll", 67, #Null, @open_icon, 1) 
    save_icon = 0
    ExtractIconEx_("cv_icons.dll", 89, #Null, @save_icon, 1)     
    top_icon = 0
    ExtractIconEx_("cv_icons.dll", 94, #Null, @top_icon, 1)    
    bmp_icon = 0
    ExtractIconEx_("cv_icons.dll", 101, #Null, @bmp_icon, 1)
    help_icon = 0
    ExtractIconEx_("cv_icons.dll", 38, #Null, @help_icon, 1)
    lock_icon = 0
    ExtractIconEx_("cv_icons.dll", 58, #Null, @lock_icon, 1)        
    
    byte_display_icon = 0
    word_display_icon = 0
    dword_display_icon  = 0
    smaller_icon  = 0
    bigger_icon = 0
    more_col_icon  = 0
    less_col_icon  = 0
    reset_display_icon = 0
    set_col_icon = 0
    ExtractIconEx_("cv_icons.dll", 118, #Null, @byte_display_icon, 1)        
    ExtractIconEx_("cv_icons.dll", 120, #Null, @word_display_icon, 1)        
    ExtractIconEx_("cv_icons.dll", 119, #Null, @dword_display_icon, 1)        
    ExtractIconEx_("cv_icons.dll", 117, #Null, @smaller_icon, 1)        
    ExtractIconEx_("cv_icons.dll", 116, #Null, @bigger_icon, 1)        
    ExtractIconEx_("cv_icons.dll", 122, #Null, @more_col_icon, 1)        
    ExtractIconEx_("cv_icons.dll", 121, #Null, @less_col_icon, 1)        
    ExtractIconEx_("cv_icons.dll", 123, #Null, @reset_display_icon, 1)        
    ExtractIconEx_("cv_icons.dll", 124, #Null, @set_col_icon, 1)        
    
    reset_card_icon = 0
    reg_access_icon = 0
    bit_access_icon = 0
    ExtractIconEx_("cv_icons.dll", 8, #Null, @reset_card_icon, 1)        
    ExtractIconEx_("cv_icons.dll", 30, #Null, @reg_access_icon, 1)        
    ExtractIconEx_("cv_icons.dll", 60, #Null, @bit_access_icon, 1)   
    
    black_green_icon  = 0
    black_white_icon  = 0
    ExtractIconEx_("cv_icons.dll", 138, #Null, @black_green_icon, 1)        
    ExtractIconEx_("cv_icons.dll", 139, #Null, @black_white_icon, 1)      
    
    float_hex_convert_icon  = 0
    ExtractIconEx_("cv_icons.dll", 44, #Null, @float_hex_convert_icon, 1)
    
    Define  object1.COMateObject    
    Dim safeArrayBound.SAFEARRAYBOUND(0)
    Dim indices(0)
    Define var.VARIANT
    ReDim buffer8.b(access_size-1)
    ReDim buffer16.w((access_size>>1)-1)
    ReDim buffer32.l((access_size>>2)-1) 
    Protected visa_default.q  = 0
    Protected card_res.q  = 0    
    
    Protected hwnd  = OpenWindow(#PB_Any, x, y, 560, 320, "block access", #PB_Window_MaximizeGadget|#PB_Window_MinimizeGadget|#PB_Window_SystemMenu)
    
    If  #VI_PXI_ALLOC_SPACE = bar
      card_res  = *card
    Else
      viOpenDefaultRM(@visa_default)
      result  = viOpen(visa_default, *card, #VI_NO_LOCK, 1000, @card_res)
      
      If result <> #VI_SUCCESS
        MessageBox_(GetFocus_(), "error resource open!" + Chr(10) + PeekS(*card, -1, #PB_Ascii), "..cv..", #MB_OK | #MB_ICONERROR|#MB_SYSTEMMODAL)
        ProcedureReturn #False
      EndIf       
      
      viInstallHandler(card_res, #VI_EVENT_EXCEPTION, @visa32_error_handler(), hwnd)       
      viEnableEvent(card_res, #VI_EVENT_EXCEPTION, #VI_HNDLR, #VI_NULL)          
    EndIf
    
    SetWindowPos_(WindowID(hwnd), #HWND_TOP, 0, 0, 0, 0, #SWP_NOMOVE|#SWP_NOSIZE)
    SendMessage_(WindowID(hwnd), #WM_SETICON, #ICON_SMALL, card1)
    SetWindowTitle(hwnd, PeekS(*title, -1, #PB_Ascii))
    SmartWindowRefresh(hwnd, 1) 
    If OSVersion < #PB_OS_Windows_7
      ;
    Else
      SkinH_SetAero(WindowID(hwnd))
    EndIf
    
    Protected toolbar_t = CreateToolBar(#PB_Any, WindowID(hwnd))
    If toolbar_t
      ToolBarImageButton(0, r8_icon)    ;R8
      ToolBarImageButton(1, w8_icon)    ;W8
      ToolBarImageButton(4, r16_icon)   ;R16
      ToolBarImageButton(5, w16_icon)   ;W16
      ToolBarImageButton(8, r32_icon)   ;R32
      ToolBarImageButton(9, w32_icon)   ;W32
      ToolBarSeparator()
      ToolBarImageButton(2, r8r_icon, #PB_ToolBar_Toggle)      ;R8R
      ToolBarImageButton(3, w8r_icon, #PB_ToolBar_Toggle)      ;W8R
      ToolBarImageButton(6, r16r_icon, #PB_ToolBar_Toggle)     ;R16R
      ToolBarImageButton(7, w16r_icon, #PB_ToolBar_Toggle)     ;W16R
      ToolBarImageButton(10, r32r_icon, #PB_ToolBar_Toggle)    ;R32R
      ToolBarImageButton(11, w32r_icon, #PB_ToolBar_Toggle)    ;W32R
      ToolBarSeparator()
      ToolBarImageButton(300, reset_card_icon)      ;reset card
      ToolBarImageButton(301, reg_access_icon)      ;bit access
      ToolBarImageButton(302, bit_access_icon)      ;reg access
      ToolBarSeparator()
      ToolBarImageButton(98, byte_display_icon)         ;byte display
      ToolBarImageButton(99, word_display_icon)         ;word display
      ToolBarImageButton(100, dword_display_icon)       ;dword display
      ToolBarImageButton(97, bigger_icon)               ;bigger font
      ToolBarImageButton(96, smaller_icon)              ;smaller font
      ToolBarImageButton(202, less_col_icon)            ;less col
      ToolBarImageButton(203, more_col_icon)            ;more col     
      ToolBarImageButton(95, reset_display_icon)        ;reset display
    EndIf  
    
    AddKeyboardShortcut(hwnd, #PB_Shortcut_Control|#PB_Shortcut_Up, 97) ;bigger
    AddKeyboardShortcut(hwnd, #PB_Shortcut_Control|#PB_Shortcut_Down, 96) ;smaller
    AddKeyboardShortcut(hwnd, #PB_Shortcut_Control|#PB_Shortcut_Left, 202)    ;less col
    AddKeyboardShortcut(hwnd, #PB_Shortcut_Control|#PB_Shortcut_Right, 203)   ;more col
    AddKeyboardShortcut(hwnd, #PB_Shortcut_Escape, 500) ;exit
    AddKeyboardShortcut(hwnd, #PB_Shortcut_F1, 501)     ;display help tips
    AddKeyboardShortcut(hwnd, #PB_Shortcut_F6, 502)     ;set max font
    AddKeyboardShortcut(hwnd, #PB_Shortcut_F5, 503)     ;set adjust cols
    
    statusbar_t = CreateStatusBar(#PB_Any, WindowID(hwnd))
    If statusbar_t
      AddStatusBarField(#PB_Ignore)
      AddStatusBarField(#PB_Ignore)
      AddStatusBarField(#PB_Ignore)
      AddStatusBarField(#PB_Ignore)
      AddStatusBarField(#PB_Ignore)      
    EndIf
    
    resource_name.s = Space(4096)
    viGetAttribute(card_res, #VI_ATTR_RSRC_NAME, @resource_name)    
    
    SetWindowTitle(hwnd, GetWindowTitle(hwnd) + " - " + resource_name)
    
    If  #VI_PXI_ALLOC_SPACE = bar
      StatusBarText(statusbar_t, 0, "N/A", #PB_StatusBar_BorderLess)   
      StatusBarText(statusbar_t, 1, "N/A", #PB_StatusBar_BorderLess) 
    Else
      slot_id = 0
      model_name.s = Space(4096)
      viGetAttribute(card_res, #VI_ATTR_SLOT, @slot_id)   
      viGetAttribute(card_res, #VI_ATTR_MODEL_NAME, @model_name)
      StatusBarText(statusbar_t, 0, model_name, #PB_StatusBar_BorderLess)   
      StatusBarText(statusbar_t, 1, "Slot" + Str(slot_id), #PB_StatusBar_BorderLess)          
    EndIf    

    Select  bar
        Case  #VI_PXI_BAR2_SPACE
          StatusBarText(statusbar_t, 2, "BAR2", #PB_StatusBar_BorderLess)
        Case  #VI_PXI_BAR0_SPACE
          StatusBarText(statusbar_t, 2, "BAR0", #PB_StatusBar_BorderLess)
        Case  #VI_PXI_BAR3_SPACE
          StatusBarText(statusbar_t, 2, "BAR3", #PB_StatusBar_BorderLess)
        Case  #VI_PXI_CFG_SPACE
          StatusBarText(statusbar_t, 2, "CFG", #PB_StatusBar_BorderLess)
        Case  #VI_PXI_ALLOC_SPACE
          StatusBarText(statusbar_t, 2, "PC MEMORY", #PB_StatusBar_BorderLess)          
        Default
          StatusBarText(statusbar_t, 2, "unknown", #PB_StatusBar_BorderLess)
    EndSelect
         
    StatusBarText(statusbar_t, 3, "0x" + RSet(Hex(offset_address, #PB_Long), 8, "0"), #PB_StatusBar_BorderLess)
    StatusBarText(statusbar_t, 4, Str(access_size) + " Byte", #PB_StatusBar_BorderLess)
            
    object1 = COMate_CreateActiveXControl(0, ToolBarHeight(toolbar_t)*2 + 5, WindowWidth(hwnd), WindowHeight(hwnd) - 5 - ToolBarHeight(toolbar_t)*2 - StatusBarHeight(statusbar_t), "HEXEDIT.HexEditCtrl.1")
    aaaa  = GetActiveGadget()
    
    Protected rebar_frame_cg  = ContainerGadget(#PB_Any, 0, ToolBarHeight(toolbar_t), WindowWidth(hwnd), ToolBarHeight(toolbar_t) + 5, #PB_Container_Raised)
    Protected rebar_tb = CreateToolBarPlus(0, GadgetID(rebar_frame_cg))
    rebar_tb  = 0
    ToolBarImageButton(12, open_icon)           ;open a bin file
    ToolBarImageButton(13, save_icon)           ;save to a bin file
    ToolBarSeparator()
    ToolBarImageButton(19, random_icon)         ;随机数
    ToolBarImageButton(20, add_icon)            ;等差数列
    ToolBarImageButton(25, user_input_icon8)    ;用户输入同样的数据byte
    ToolBarImageButton(18, user_input_icon16)   ;用户输入同样的数据word
    ToolBarImageButton(21, user_input_icon32)   ;用户输入同样的数据dword
    ToolBarImageButton(22, float_hex_convert_icon)  ;hex 与 dword 之间的转换
    ToolBarSeparator()
    ToolBarImageButton(14, top_icon, #PB_ToolBar_Toggle)
    ToolBarImageButton(15, lock_icon, #PB_ToolBar_Toggle)
    ToolBarImageButton(16, bmp_icon)
    speed_tbs = ToolbarString(#PB_Any, 130, 0, 150, 20, "0Mbyte/s", #PB_String_ReadOnly)
    UseGadgetList(WindowID(hwnd)) 
        
    ToolBarToolTip(toolbar_t, 0, "R8")
    ToolBarToolTip(toolbar_t, 1, "W8")
    ToolBarToolTip(toolbar_t, 2, "R8R")
    ToolBarToolTip(toolbar_t, 3, "W8R")
    ToolBarToolTip(toolbar_t, 4, "R16")
    ToolBarToolTip(toolbar_t, 5, "W16")
    ToolBarToolTip(toolbar_t, 6, "R16R")
    ToolBarToolTip(toolbar_t, 7, "W16R")
    ToolBarToolTip(toolbar_t, 8, "R32")
    ToolBarToolTip(toolbar_t, 9, "W32")
    ToolBarToolTip(toolbar_t, 10, "R32R")
    ToolBarToolTip(toolbar_t, 11, "W32R")
    ToolBarToolTip(toolbar_t, 300, "复位板卡")      
    ToolBarToolTip(toolbar_t, 301, "按寄存器位访问")    
    ToolBarToolTip(toolbar_t, 302, "按寄存器整体访问")   
    ToolBarToolTip(toolbar_t, 98, "按byte显示")     
    ToolBarToolTip(toolbar_t, 99, "按word显示")    
    ToolBarToolTip(toolbar_t, 100, "按dword显示")     
    ToolBarToolTip(toolbar_t, 97, "放大字体")   
    ToolBarToolTip(toolbar_t, 96, "缩小字体")    
    ToolBarToolTip(toolbar_t, 202, "减少列") 
    ToolBarToolTip(toolbar_t, 203, "增加列")   
    ToolBarToolTip(toolbar_t, 95, "恢复默认显示状态")    
    
    ToolBarToolTip(rebar_tb, 12, "Read From Bin File")      
    ToolBarToolTip(rebar_tb, 13, "Save To Bin File")
    ToolBarToolTip(rebar_tb, 14, "Always On Top") 
    ToolBarToolTip(rebar_tb, 15, "LOCK")
    ToolBarToolTip(rebar_tb, 16, "BMP截图")       
    ToolBarToolTip(rebar_tb, 17, "帮助") 
    ToolBarToolTip(rebar_tb, 19, "generate random number")
    ToolBarToolTip(rebar_tb, 20, "generate 等差数列")  
    ToolBarToolTip(rebar_tb, 25, "使用用户输入的特定byte整数")
    ToolBarToolTip(rebar_tb, 18, "使用用户输入的特定word整数")
    ToolBarToolTip(rebar_tb, 21, "使用用户输入的特定dword整数")
    ToolBarToolTip(rebar_tb, 22, "int32整形与float类型之间的转换")
    
    GadgetToolTip(speed_tbs, "读写速度显示")
    ;-----------------------------------------------------
    
    font_size = 13
    c_num.b = 16
    
    ;0x00，蓝  绿  红
    object1\SetProperty("ForeColor = " + Str($0000FF33))     ;绿
    object1\SetProperty("BackColor = " + Str($00000000))     ;黑
    object1\SetProperty("Appearance = 1")
    object1\SetProperty("ShowAddress = #TRUE")
    object1\SetProperty("ShowAscii = #TRUE")
    object1\SetProperty("Columns = " + Str(c_num))
    object1\SetProperty("FontHeight = " + Str(font_size))
    object1\SetProperty("DigitsInAddress = 8")
    object1\SetProperty("DigitsInData = 2")
    object1\SetProperty("AllowChangeSize = #FALSE") 
        
    With safeArrayBound(0)
      \lLbound = 0
      \cElements = access_size
    EndWith    
    
    *safeArray.SAFEARRAY = SafeArrayCreate_(#VT_UI1, 1, @safeArrayBound())
            
    start_tick.q  = timeGetTime_()
    
    viMoveIn8(card_res, bar, offset_address, access_size, @buffer8())  
    
    finish_tick.q = timeGetTime_()    
    
    For i = 0 To access_size-1 Step 1
      indices(0)  = i
      SafeArrayPutElement_(*safeArray, @indices(), @buffer8() + i)
    Next
            
    With var
      \vt = #VT_ARRAY|#VT_UI1
      \parray = *safeArray
    EndWith    
    
    ;object1\invoke("SetData(" + Str(var) + " as variant BYREF, " + Str(offset_address) + ")")
    object1\invoke("SetData(" + Str(var) + " as variant BYREF, " + Str(offset_address) + ")")
    
    delta_tick.f  = finish_tick-start_tick
    
    If  0 = delta_tick
      delta_tick  = 0.5
    EndIf
    
    speed.f = access_size*1000/(1024*1024*delta_tick)
    SetGadgetText(speed_tbs, StrF(speed, 4) + "Mbyte/s")   
    
    AddWindowTimer(hwnd, 0, 100)
    AddWindowTimer(hwnd, 1, 2500)
    
    menu1 = CreatePopupImageMenu(#PB_Any)
    If menu1
      MenuItem(94, "Set &column num", set_col_icon)
      MenuItem(350, "Black &Green", black_green_icon)
      MenuItem(351, "Black &White", black_white_icon)
    EndIf    
    
    hex_num.b = 0
    hex_num16.w = 0
    hex_num32.l = 0
    
    Define  pos.POINT
    Define  key_flag.l  = 0
    
    SetWindowCallback(@pxi_block_access_callback(), hwnd)
    
    Define  new_offset.l  = 0   
    
    PureRESIZE_SetGadgetResize(aaaa, 1, 1, 1, 1)    ;activex container
    PureRESIZE_SetGadgetResize(rebar_frame_cg, 1, 1, 0, 0)    
    PureRESIZE_SetWindowMinimumSize(hwnd, 560, 320)
    
    Repeat
      Event.l = WaitWindowEvent()
      Select  Event
        Case  #WM_SIZE
          object1\SetProperty("Columns  = 0") ;auto columns
        Case  #WM_RBUTTONDOWN
          GetCursorPos_(@pos)    
          If  pos\x > WindowX(hwnd)
            If  pos\x < WindowX(hwnd)+WindowWidth(hwnd)
              If  pos\y > WindowY(hwnd)+ 3*ToolBarHeight(toolbar_t)
                If  pos\y < WindowY(hwnd) + WindowHeight(hwnd) - ToolBarHeight(toolbar_t)*2 - StatusBarHeight(statusbar_t)
                  DisplayPopupMenu(menu1, WindowID(hwnd))
                EndIf
              EndIf
            EndIf
          EndIf          
        Case  #WM_LBUTTONDOWN
          If  1 = key_flag
            ;
          Else
            GetCursorPos_(@pos)    
            If  pos\x > WindowX(hwnd)
              If  pos\x < WindowX(hwnd)+WindowWidth(hwnd)
                If  pos\y > WindowY(hwnd) + 3*ToolBarHeight(toolbar_t) + 5
                  If  pos\y < WindowY(hwnd) + WindowHeight(hwnd) - ToolBarHeight(toolbar_t)*2 - StatusBarHeight(statusbar_t)
                    mouse_event_(#MOUSEEVENTF_LEFTDOWN, 0, 0, 0, 0)
                    mouse_event_(#MOUSEEVENTF_LEFTUP, 0, 0, 0, 0)   
                    keybd_event_(#VK_INSERT,0,0,0)             
                    keybd_event_(#VK_INSERT,0,#KEYEVENTF_KEYUP,0)
                    If  2 = key_flag
                      keybd_event_(#VK_INSERT,0,0,0)             
                      keybd_event_(#VK_INSERT,0,#KEYEVENTF_KEYUP,0)
                    EndIf
                    key_flag  = 1
                  EndIf
                EndIf
              EndIf
            EndIf
          EndIf          
        Case  #PB_Event_Timer
          Select  EventTimer()
            Case  1
              ;
            Case  0              
              If  GetToolBarButtonState(toolbar_t, 2)
                object1\SetProperty("DigitsInData = 2")
                
                start_tick  = timeGetTime_()
                viMoveIn8(card_res, bar, offset_address, access_size, @buffer8())
                finish_tick = timeGetTime_()
                delta_tick  = finish_tick-start_tick
                
                If  0 = delta_tick
                  delta_tick  = 0.5
                EndIf
                
                speed = access_size*1000/(1024*1024*delta_tick)
                SetGadgetText(speed_tbs, StrF(speed, 4) + "Mbyte/s")  
                
                For i = 0 To access_size-1 Step 1 
                  indices(0)  = i
                  SafeArrayPutElement_(*safeArray, @indices(), @buffer8() + i)
                Next          
                
                object1\invoke("SetData(" + Str(var) + " as variant BYREF, " + Str(offset_address) + ")")  
              Else
                ;
              EndIf
              
              If  GetToolBarButtonState(toolbar_t, 3)
                object1\SetProperty("DigitsInData = 2")
                
                For i = 0 To access_size-1 Step 1              
                  indices(0) = i
                  temp.b  = 0
                  SafeArrayGetElement_(*safeArray, @indices(), @temp)
                  buffer8(i)  = temp
                Next
                start_tick  = timeGetTime_()
                viMoveOut8(card_res, bar, offset_address, access_size, @buffer8())
                finish_tick = timeGetTime_()
                delta_tick  = finish_tick-start_tick
                
                If  0 = delta_tick
                  delta_tick  = 0.5
                EndIf
                
                speed = access_size*1000/(1024*1024*delta_tick)
                SetGadgetText(speed_tbs, StrF(speed, 4) + "Mbyte/s")
              Else
                ;
              EndIf
              
              If  GetToolBarButtonState(toolbar_t, 6)
                object1\SetProperty("DigitsInData = 4")
                
                start_tick  = timeGetTime_()
                viMoveIn16(card_res, bar, offset_address, access_size>>1, @buffer16())
                finish_tick = timeGetTime_()
                delta_tick  = finish_tick-start_tick
                
                If  0 = delta_tick
                  delta_tick  = 0.5
                EndIf
                
                speed = access_size*1000/(1024*1024*delta_tick)
                SetGadgetText(speed_tbs, StrF(speed, 4) + "Mbyte/s")  
                
                For i = 0 To access_size-1 Step 1 
                  indices(0)  = i
                  SafeArrayPutElement_(*safeArray, @indices(), @buffer16() + i)                
                Next          
                
                object1\invoke("SetData(" + Str(var) + " as variant BYREF, " + Str(offset_address) + ")") 
              Else
                ;
              EndIf
              
              If  GetToolBarButtonState(toolbar_t, 7)
                object1\SetProperty("DigitsInData = 4")
                
                For i = 0 To (access_size>>1)-1 Step 1   
                  indices(0) = 2*i
                  SafeArrayGetElement_(*safeArray, @indices(), @buffer16(i))
                  indices(0)  = 2*i + 1
                  SafeArrayGetElement_(*safeArray, @indices(), @buffer16(i) + 1)
                Next
                start_tick  = timeGetTime_()
                viMoveOut16(card_res, bar, offset_address, access_size>>1, @buffer16())
                finish_tick = timeGetTime_()
                delta_tick  = finish_tick-start_tick
                
                If  0 = delta_tick
                  delta_tick  = 0.5
                EndIf
                
                speed = access_size*1000/(1024*1024*delta_tick)
                SetGadgetText(speed_tbs, StrF(speed, 4) + "Mbyte/s") 
              Else
                ;
              EndIf              
              
              If  GetToolBarButtonState(toolbar_t, 10)
                object1\SetProperty("DigitsInData = 8")
                
                start_tick  = timeGetTime_()
                viMoveIn32(card_res, bar, offset_address, access_size>>2, @buffer32())
                finish_tick = timeGetTime_()
                delta_tick  = finish_tick-start_tick
                
                If  0 = delta_tick
                  delta_tick  = 0.5
                EndIf
                
                speed = access_size*1000/(1024*1024*delta_tick)
                SetGadgetText(speed_tbs, StrF(speed, 4) + "Mbyte/s")  
                
                For i = 0 To access_size-1 Step 1 
                  indices(0)  = i
                  SafeArrayPutElement_(*safeArray, @indices(), @buffer32() + i)                
                Next          
                
                object1\invoke("SetData(" + Str(var) + " as variant BYREF, " + Str(offset_address) + ")") 
              Else
                ;
              EndIf
              
              If  GetToolBarButtonState(toolbar_t, 11)
                object1\SetProperty("DigitsInData = 8")
                
                For i = 0 To (access_size>>2)-1 Step 1   
                  indices(0) = 4*i
                  SafeArrayGetElement_(*safeArray, @indices(), @buffer32(i))
                  indices(0)  = 4*i + 1
                  SafeArrayGetElement_(*safeArray, @indices(), @buffer32(i) + 1)
                  indices(0)  = 4*i + 2
                  SafeArrayGetElement_(*safeArray, @indices(), @buffer32(i) + 2)
                  indices(0)  = 4*i + 3
                  SafeArrayGetElement_(*safeArray, @indices(), @buffer32(i) + 3)                
                Next
                start_tick  = timeGetTime_()
                viMoveOut32(card_res, bar, offset_address, access_size>>2, @buffer32())
                finish_tick = timeGetTime_()
                delta_tick  = finish_tick-start_tick
                
                If  0 = delta_tick
                  delta_tick  = 0.5
                EndIf
                
                speed = access_size*1000/(1024*1024*delta_tick)
                SetGadgetText(speed_tbs, StrF(speed, 4) + "Mbyte/s")  
              Else
                ;
              EndIf              
          EndSelect
        Case  #PB_Event_Gadget
          Select  EventGadget()
            Case  0
              ;
          EndSelect
        Case  #PB_Event_Menu
          Select EventMenu()
            Case  500   ;exit
              quit  = #True
            Case  22    ;float to hex, hex to float
              CreateThread(@float_hex_convert(), #Null)
            Case  350   ;black green
              object1\SetProperty("ForeColor = " + Str($0000FF33))     ;绿
              object1\SetProperty("BackColor = " + Str($00000000))     ;黑
            Case  351   ;black white
              object1\SetProperty("ForeColor = " + Str($00CCFFFF))     ;似白
              object1\SetProperty("BackColor = " + Str($00000000))     ;黑                         
            Case  300   ;reset card
              result  = plx9054_reset_card(card_res)
              If  result
                MessageBox_(GetFocus_(), "Card Reset OK!!!", "cv", #MB_SYSTEMMODAL|#MB_OK|#MB_ICONINFORMATION|#MB_DEFBUTTON1)
              EndIf    
            Case  301   ;bit access
              StickyWindow(hwnd, #False)
              SetToolBarButtonState(rebar_tb, 14, #False)              
              DisableWindow(hwnd, #True)
              result  = hex_input(@new_offset, 16)              
              DisableWindow(hwnd, #False)
              SetActiveWindow(hwnd)              
              If  result
                card_array.card_info(0)\offset_address  = offset_address  + new_offset
                new_title.s = StringField(GetWindowTitle(hwnd), 1, "@") + " + 0x" + Hex(new_offset, #PB_Word)
                card_array.card_info(0)\title  = @new_title
                card_array.card_info(0)\x  = WindowX(hwnd)  + WindowWidth(hwnd) - 20
                card_array.card_info(0)\y  = WindowY(hwnd)  + 20
                CreateThread(@pxi_bit_access(), @card_array() + 0*SizeOf(card_info))
              EndIf
            Case  302   ;reg access
              StickyWindow(hwnd, #False)
              SetToolBarButtonState(rebar_tb, 14, #False)
              DisableWindow(hwnd, #True)
              result  = hex_input(@new_offset, 16)              
              DisableWindow(hwnd, #False)
              SetActiveWindow(hwnd)                
              If  result
                card_array.card_info(0)\offset_address  = offset_address  + new_offset
                new_title.s = StringField(GetWindowTitle(hwnd), 1, "@") + " + 0x" + Hex(new_offset, #PB_Word)
                card_array.card_info(0)\title  = @new_title
                card_array.card_info(0)\x  = WindowX(hwnd)  + WindowWidth(hwnd) - 20
                card_array.card_info(0)\y  = WindowY(hwnd)  + 20
                CreateThread(@pxi_register_access(), @card_array() + 0*SizeOf(card_info))
              EndIf
            Case  94  ;set columns number menu
              DisableWindow(hwnd, #True)
              result  = dec_input(@c_num)
              DisableWindow(hwnd, #False)
              SetActiveWindow(hwnd)              
              If  result
                object1\SetProperty("Columns  = " + Str(c_num))
              EndIf
            Case  95  ;reset default
              key_flag  = 2
              font_size = 13  
              object1\SetProperty("DigitsInData = 2")
              c_num = 16
              object1\SetProperty("Columns  = " + Str(c_num))                
              object1\SetProperty("FontHeight = " + Str(font_size))               
            Case  96  ;smaller
              If  font_size > 8
                key_flag  = 2
                font_size = font_size - 1
                object1\SetProperty("FontHeight = " + Str(font_size))   
              EndIf                
              object1\SetProperty("Columns  = 0")
            Case  97  ;bigger
              If  font_size < 24
                key_flag  = 2
                font_size = font_size + 1
                object1\SetProperty("FontHeight = " + Str(font_size))   
              EndIf
              object1\SetProperty("Columns  = 0")
            Case  202 ;less col
              If  c_num > 1
                c_num - 1
                object1\SetProperty("Columns = " + Str(c_num))   
              EndIf 
            Case  203 ;more col
              If  c_num < 32
                c_num + 1
                object1\SetProperty("Columns = " + Str(c_num))   
              EndIf   
            Case  501;help tip
              MessageBox_(GetFocus_(), "F6-Max font display" + Chr(13) + "F5-Adjust columns", "cv 2013.4", #MB_OK|#MB_ICONINFORMATION|#MB_DEFBUTTON1|#MB_SYSTEMMODAL)
            Case  502;max font size
              If  1 = key_flag
                key_flag  = 2
                font_size = 24
                object1\SetProperty("FontHeight = " + Str(font_size))
                object1\SetProperty("Columns = 0")
              Else
                If  0 = key_flag
                  key_flag  = 0
                  font_size = 24
                  object1\SetProperty("FontHeight = " + Str(font_size))
                  object1\SetProperty("Columns = 0")
                EndIf
              EndIf
            Case  503;adjust col
              object1\SetProperty("Columns = 0")
            Case  98  ;byte display
              object1\SetProperty("DigitsInData = 2")
            Case  99  ;word display
              object1\SetProperty("DigitsInData = 4")
            Case  100 ;dword display
              object1\SetProperty("DigitsInData = 8")
            Case  19  ;random
              temp_num.b  = 0
              For i = 0 To access_size-1 Step 1 
                indices(0)  = i
                temp_num  = Random($ff)
                SafeArrayPutElement_(*safeArray, @indices(), @temp_num)                
              Next                
              object1\invoke("SetData(" + Str(var) + " as variant BYREF, " + Str(offset_address) + ")")
              object1\SetProperty("DigitsInData = 2")
            Case  20  ;等差数列
              temp_num.b  = 0
              For i = 0 To access_size-1 Step 1 
                indices(0)  = i
                temp_num  = i
                SafeArrayPutElement_(*safeArray, @indices(), @temp_num)                
              Next
              object1\invoke("SetData(" + Str(var) + " as variant BYREF, " + Str(offset_address) + ")")
              object1\SetProperty("DigitsInData = 2")
            Case  25  ;set user byte data to ram byte              
              DisableWindow(hwnd, #True)
              result  = hex_input(@hex_num, 8)
              DisableWindow(hwnd, #False)
              SetActiveWindow(hwnd)                           
              If  result
                For i = 0 To access_size-1 Step 1 
                  indices(0)  = i
                  SafeArrayPutElement_(*safeArray, @indices(), @hex_num)                
                Next
                object1\invoke("SetData(" + Str(var) + " as variant BYREF, " + Str(offset_address) + ")")
                object1\SetProperty("DigitsInData = 2")                
              Else
                ;
              EndIf
            Case  18  ;set user byte data to ram word
              DisableWindow(hwnd, #True)
              result  = hex_input(@hex_num16, 16)
              DisableWindow(hwnd, #False)
              SetActiveWindow(hwnd)              
              If  result
                For i = 0 To access_size-1 Step 2 
                  indices(0)  = i
                  SafeArrayPutElement_(*safeArray, @indices(), @hex_num16)
                  indices(0)  = i + 1
                  SafeArrayPutElement_(*safeArray, @indices(), @hex_num16 + 1)                                  
                Next
                object1\invoke("SetData(" + Str(var) + " as variant BYREF, " + Str(offset_address) + ")")
                object1\SetProperty("DigitsInData = 4")                
              Else
                ;
              EndIf              
            Case  21  ;set user byte data to ram dword
              DisableWindow(hwnd, #True)
              result  = hex_input(@hex_num32, 32)
              DisableWindow(hwnd, #False)
              SetActiveWindow(hwnd)              
              If  result
                For i = 0 To access_size-1 Step 4 
                  indices(0)  = i
                  SafeArrayPutElement_(*safeArray, @indices(), @hex_num32)
                  indices(0)  = i + 1
                  SafeArrayPutElement_(*safeArray, @indices(), @hex_num32 + 1)
                  indices(0)  = i + 2
                  SafeArrayPutElement_(*safeArray, @indices(), @hex_num32 + 2)
                  indices(0)  = i + 3
                  SafeArrayPutElement_(*safeArray, @indices(), @hex_num32 + 3)                  
                Next
                object1\invoke("SetData(" + Str(var) + " as variant BYREF, " + Str(offset_address) + ")")
                object1\SetProperty("DigitsInData = 8")
              Else
                ;
              EndIf               
            Case  0       ;R8
              object1\SetProperty("DigitsInData = 2")
              start_tick  = timeGetTime_()
              viMoveIn8(card_res, bar, offset_address, access_size, @buffer8())
              finish_tick = timeGetTime_()
              delta_tick  = finish_tick-start_tick
              
              If  0 = delta_tick
                delta_tick  = 0.5
              EndIf
              
              speed = access_size*1000/(1024*1024*delta_tick)
              SetGadgetText(speed_tbs, StrF(speed, 4) + "Mbyte/s")  
              
              For i = 0 To access_size-1 Step 1 
                indices(0)  = i
                SafeArrayPutElement_(*safeArray, @indices(), @buffer8() + i)
              Next          
              
              object1\invoke("SetData(" + Str(var) + " as variant BYREF, " + Str(offset_address) + ")")  
            Case  1       ;W8
              object1\SetProperty("DigitsInData = 2")
              For i = 0 To access_size-1 Step 1              
                indices(0) = i
                temp.b  = 0
                SafeArrayGetElement_(*safeArray, @indices(), @temp)
                buffer8(i)  = temp
              Next
              start_tick  = timeGetTime_()
              viMoveOut8(card_res, bar, offset_address, access_size, @buffer8())
              finish_tick = timeGetTime_()
              delta_tick  = finish_tick-start_tick
              
              If  0 = delta_tick
                delta_tick  = 0.5
              EndIf
              
              speed = access_size*1000/(1024*1024*delta_tick)
              SetGadgetText(speed_tbs, StrF(speed, 4) + "Mbyte/s")                
            Case  2       ;R8R
              Delay(10)
              If  GetToolBarButtonState(toolbar_t, 2)
                SetToolBarButtonState(toolbar_t, 3, #False)
                SetToolBarButtonState(toolbar_t, 6, #False)
                SetToolBarButtonState(toolbar_t, 7, #False)
                SetToolBarButtonState(toolbar_t, 10, #False)
                SetToolBarButtonState(toolbar_t, 11, #False)       
                DisableToolBarButton(rebar_tb, 12, #True)
                DisableToolBarButton(rebar_tb, 13, #True)
              Else
                DisableToolBarButton(rebar_tb, 12, #False)
                DisableToolBarButton(rebar_tb, 13, #False)
              EndIf
            Case  3       ;W8R
              Delay(10)
              If  GetToolBarButtonState(toolbar_t, 3)
                SetToolBarButtonState(toolbar_t, 2, #False)
                SetToolBarButtonState(toolbar_t, 6, #False)
                SetToolBarButtonState(toolbar_t, 7, #False)
                SetToolBarButtonState(toolbar_t, 10, #False)
                SetToolBarButtonState(toolbar_t, 11, #False)                
                DisableToolBarButton(rebar_tb, 12, #True)
                DisableToolBarButton(rebar_tb, 13, #True)
              Else
                DisableToolBarButton(rebar_tb, 12, #False)
                DisableToolBarButton(rebar_tb, 13, #False)
              EndIf
            Case  4       ;R16
              object1\SetProperty("DigitsInData = 4")
              start_tick  = timeGetTime_()
              viMoveIn16(card_res, bar, offset_address, access_size>>1, @buffer16())
              finish_tick = timeGetTime_()
              delta_tick  = finish_tick-start_tick
              
              If  0 = delta_tick
                delta_tick  = 0.5
              EndIf
              
              speed = access_size*1000/(1024*1024*delta_tick)
              SetGadgetText(speed_tbs, StrF(speed, 4) + "Mbyte/s")  
              
              For i = 0 To access_size-1 Step 1 
                indices(0)  = i
                SafeArrayPutElement_(*safeArray, @indices(), @buffer16() + i)                
              Next          
              
              object1\invoke("SetData(" + Str(var) + " as variant BYREF, " + Str(offset_address) + ")") 
            Case  5       ;W16
              object1\SetProperty("DigitsInData = 4")
              
              For i = 0 To (access_size>>1)-1 Step 1   
                indices(0) = 2*i
                SafeArrayGetElement_(*safeArray, @indices(), @buffer16(i))
                indices(0)  = 2*i + 1
                SafeArrayGetElement_(*safeArray, @indices(), @buffer16(i) + 1)
              Next
              start_tick  = timeGetTime_()
              viMoveOut16(card_res, bar, offset_address, access_size>>1, @buffer16())
              finish_tick = timeGetTime_()
              delta_tick  = finish_tick-start_tick
              
              If  0 = delta_tick
                delta_tick  = 0.5
              EndIf
              
              speed = access_size*1000/(1024*1024*delta_tick)
              SetGadgetText(speed_tbs, StrF(speed, 4) + "Mbyte/s")                
            Case  6       ;R16R
              Delay(10)
              If  GetToolBarButtonState(toolbar_t, 6)
                SetToolBarButtonState(toolbar_t, 2, #False)
                SetToolBarButtonState(toolbar_t, 3, #False)
                SetToolBarButtonState(toolbar_t, 7, #False)
                SetToolBarButtonState(toolbar_t, 10, #False)
                SetToolBarButtonState(toolbar_t, 11, #False)                
                DisableToolBarButton(rebar_tb, 12, #True)
                DisableToolBarButton(rebar_tb, 13, #True)
              Else
                DisableToolBarButton(rebar_tb, 12, #False)
                DisableToolBarButton(rebar_tb, 13, #False)
              EndIf
            Case  7       ;W16R
              Delay(10)
              If  GetToolBarButtonState(toolbar_t, 7)
                SetToolBarButtonState(toolbar_t, 2, #False)
                SetToolBarButtonState(toolbar_t, 6, #False)
                SetToolBarButtonState(toolbar_t, 3, #False)
                SetToolBarButtonState(toolbar_t, 10, #False)
                SetToolBarButtonState(toolbar_t, 11, #False)                
                DisableToolBarButton(rebar_tb, 12, #True)
                DisableToolBarButton(rebar_tb, 13, #True)
              Else
                DisableToolBarButton(rebar_tb, 12, #False)
                DisableToolBarButton(rebar_tb, 13, #False)
              EndIf
            Case  8       ;R32
              object1\SetProperty("DigitsInData = 8")
              start_tick  = timeGetTime_()
              viMoveIn32(card_res, bar, offset_address, access_size>>2, @buffer32())
              finish_tick = timeGetTime_()
              delta_tick  = finish_tick-start_tick
              
              If  0 = delta_tick
                delta_tick  = 0.5
              EndIf
              
              speed = access_size*1000/(1024*1024*delta_tick)
              SetGadgetText(speed_tbs, StrF(speed, 4) + "Mbyte/s")  
              
              For i = 0 To access_size-1 Step 1 
                indices(0)  = i
                SafeArrayPutElement_(*safeArray, @indices(), @buffer32() + i)                
              Next          
              
              object1\invoke("SetData(" + Str(var) + " as variant BYREF, " + Str(offset_address) + ")") 
            Case  9       ;W32
              object1\SetProperty("DigitsInData = 8")
              
              For i = 0 To (access_size>>2)-1 Step 1   
                indices(0) = 4*i
                SafeArrayGetElement_(*safeArray, @indices(), @buffer32(i))
                indices(0)  = 4*i + 1
                SafeArrayGetElement_(*safeArray, @indices(), @buffer32(i) + 1)
                indices(0)  = 4*i + 2
                SafeArrayGetElement_(*safeArray, @indices(), @buffer32(i) + 2)
                indices(0)  = 4*i + 3
                SafeArrayGetElement_(*safeArray, @indices(), @buffer32(i) + 3)                
              Next
              start_tick  = timeGetTime_()
              viMoveOut32(card_res, bar, offset_address, access_size>>2, @buffer32())
              finish_tick = timeGetTime_()
              delta_tick  = finish_tick-start_tick
              
              If  0 = delta_tick
                delta_tick  = 0.5
              EndIf
              
              speed = access_size*1000/(1024*1024*delta_tick)
              SetGadgetText(speed_tbs, StrF(speed, 4) + "Mbyte/s")                
            Case  10       ;R32R
              Delay(10)
              If  GetToolBarButtonState(toolbar_t, 10)
                SetToolBarButtonState(toolbar_t, 2, #False)
                SetToolBarButtonState(toolbar_t, 6, #False)
                SetToolBarButtonState(toolbar_t, 7, #False)
                SetToolBarButtonState(toolbar_t, 3, #False)
                SetToolBarButtonState(toolbar_t, 11, #False)                
                DisableToolBarButton(rebar_tb, 12, #True)
                DisableToolBarButton(rebar_tb, 13, #True)
              Else
                DisableToolBarButton(rebar_tb, 12, #False)
                DisableToolBarButton(rebar_tb, 13, #False)
              EndIf
            Case  11       ;W32R
              Delay(10)
              If  GetToolBarButtonState(toolbar_t, 11)
                SetToolBarButtonState(toolbar_t, 2, #False)
                SetToolBarButtonState(toolbar_t, 6, #False)
                SetToolBarButtonState(toolbar_t, 7, #False)
                SetToolBarButtonState(toolbar_t, 10, #False)
                SetToolBarButtonState(toolbar_t, 3, #False)                
                DisableToolBarButton(rebar_tb, 12, #True)
                DisableToolBarButton(rebar_tb, 13, #True)
              Else
                DisableToolBarButton(rebar_tb, 12, #False)
                DisableToolBarButton(rebar_tb, 13, #False)
              EndIf 
            Case  12        ;open
              Pattern$ = "二进制文件(*.*)|*.*"
              file2.s = OpenFileRequester("Please choose file to open", "", Pattern$, #PB_Window_WindowCentered)
              If  file2 = ""
                MessageBox_(WindowID(hwnd), "no file selected!" + Chr(10) + "plz choose again!", "..cv..", #MB_OK | #MB_ICONINFORMATION|#MB_SYSTEMMODAL)
              Else                
                i = 0
                If ReadFile(0, file2)   ; if the file could be read, we continue...
                  While Eof(0) = 0           ; loop as long the 'end of file' isn't reached
                    indices(0) = i
                    temp = ReadByte(0)
                    SafeArrayPutElement_(*safeArray, @indices(), @temp)
                    i = i + 1
                  Wend
                  CloseFile(0)               ; close the previously opened file
                Else
                  MessageBox_(WindowID(hwnd), "Couldn't open the file!" + Chr(10) + "Couldn't open the file!", "..cv..", #MB_OK | #MB_ICONERROR|#MB_SYSTEMMODAL)                  
                EndIf                                 
                object1\invoke("SetData(" + Str(var) + " as variant BYREF, " + Str(offset_address) + ")")  
                object1\SetProperty("DigitsInData = 2")
                object1\SetProperty("Columns  = 16")
                MessageBox_(WindowID(hwnd), "load this file: " + Chr(10) + file2 + Chr(10) + MD5FileFingerprint(file2), "..cv..", #MB_OK | #MB_ICONINFORMATION|#MB_SYSTEMMODAL)                
              EndIf
            Case  13        ;save
              Pattern$ = "二进制文件(*.bin)|*.bin|All files (*.*)|*.*"
              file2.s = SaveFileRequester("Please choose file to save", "new_file.bin", Pattern$, 0)
              If  file2 = ""
                MessageBox_(WindowID(hwnd), "no file selected!" + Chr(10) + "plz choose again!", "..cv..", #MB_OK | #MB_ICONINFORMATION|#MB_SYSTEMMODAL)
              Else
                Select  FileSize(file2)
                  Case  -1  ;not exist
                    result  = FindString(file2, ".bin")
                    If  result
                      ;
                    Else
                      file2 = file2 + ".bin"
                    EndIf
                    If CreateFile(0, file2)         ; we create a new text file...
                      For i = 0 To access_size-1 Step 1
                        indices(0) = i
                        temp  = 0
                        SafeArrayGetElement_(*safeArray, @indices(), @temp)
                        WriteByte(0, temp)                
                      Next  		
                      CloseFile(0)                       ; close the previously opened file and store the written data this way
                      MessageBox_(WindowID(hwnd), "save to file: " + Chr(10) + file2 + Chr(10) + MD5FileFingerprint(file2), "..cv..", #MB_OK | #MB_ICONINFORMATION|#MB_SYSTEMMODAL)
                    Else
                      MessageBox_(WindowID(hwnd), "Couldn't write the file!" + Chr(10) + "Couldn't open the file!", "..cv..", #MB_OK | #MB_ICONERROR|#MB_SYSTEMMODAL)                  
                    EndIf
                  Case  -2  ;folder
                    ;
                  Default
                    result  = MessageBox_(WindowID(hwnd), "file existed, overwrite it? ", "..cv..", #MB_DEFBUTTON2|#MB_YESNO|#MB_ICONQUESTION|#MB_SYSTEMMODAL)
                    Select  result
                      Case  #IDYES
                        If CreateFile(0, file2)         ; we create a new text file...
                          For i = 0 To access_size-1 Step 1
                            indices(0) = i
                            temp  = 0
                            SafeArrayGetElement_(*safeArray, @indices(), @temp)
                            WriteByte(0, temp)                
                          Next  		
                          CloseFile(0)                       ; close the previously opened file and store the written data this way
                          MessageBox_(WindowID(hwnd), "save to file: " + Chr(10) + file2 + Chr(10) + MD5FileFingerprint(file2), "..cv..", #MB_OK | #MB_ICONINFORMATION|#MB_SYSTEMMODAL)
                        Else
                          MessageBox_(WindowID(hwnd), "Couldn't write the file!" + Chr(10) + "Couldn't open the file!", "..cv..", #MB_OK | #MB_ICONERROR|#MB_SYSTEMMODAL)                  
                        EndIf                        
                      Case  #IDNO
                        ;
                      Default
                        ;
                    EndSelect
                EndSelect    	      	
              EndIf  
            Case  14    ;top
              Delay(10)
              If  GetToolBarButtonState(rebar_tb, EventMenu())
                SetWindowPos_(WindowID(hwnd), #HWND_TOPMOST, 0, 0, 0, 0, #SWP_NOMOVE|#SWP_NOSIZE)
              Else
                SetWindowPos_(WindowID(hwnd), #HWND_NOTOPMOST, 0, 0, 0, 0, #SWP_NOMOVE|#SWP_NOSIZE)
              EndIf               
            Case  15    ;lock
              Delay(10)
              If  GetToolBarButtonState(rebar_tb, EventMenu())
                viLock(card_res, #VI_EXCLUSIVE_LOCK, 200, #VI_NULL, #VI_NULL)
              Else
                viUnlock(card_res)
              EndIf
            Case  16    ;capture
              CaptureWindow(GetWindowTitle(hwnd))
          EndSelect
      EndSelect
    Until Event = #PB_Event_CloseWindow Or  quit  = #True  
    
    If  #VI_PXI_ALLOC_SPACE = bar
      ;
    Else
      viDisableEvent(card_res, #VI_ALL_ENABLED_EVENTS, #VI_ALL_MECH)
      viUninstallHandler(card_res, #VI_EVENT_EXCEPTION, @visa32_error_handler(), hwnd)  
      viClose(card_res)
      viClose(visa_default)        
    EndIf    
    
    RemoveWindowTimer(hwnd, 0)  
    object1\Release()
    VariantClear_(var)    
    CloseWindow(hwnd)
    ProcedureReturn #True
     
  EndProcedure  
  
  ProcedureDLL.l  plx9054_doorbell_interrupt_spy(*card_info)
    ;3~31共29种情况doorbell的计数
        
    *card = PeekL(*card_info)   ;read 4byte
    x.l = PeekL(*card_info  + 12) ;read 4byte
    y.l = PeekL(*card_info  + 16) ;read 4byte  
    
    ExamineDesktops()
    
    card1  = 0
    ExtractIconEx_("cv_icons.dll", 4, #Null, @card1, 1)
    
    clear_icon = 0
    ExtractIconEx_("cv_icons.dll", 42, #Null, @clear_icon, 1)
    
    top_icon = 0
    ExtractIconEx_("cv_icons.dll", 94, #Null, @top_icon, 1)    
    bmp_icon = 0
    ExtractIconEx_("cv_icons.dll", 101, #Null, @bmp_icon, 1)
    help_icon = 0
    ExtractIconEx_("cv_icons.dll", 49, #Null, @help_icon, 1)
    lock_icon = 0
    ExtractIconEx_("cv_icons.dll", 58, #Null, @lock_icon, 1)     
    
    Protected visa_default.q  = 0
    viOpenDefaultRM(@visa_default)
    
    Protected card_res.q  = 0
    result  = viOpen(visa_default, *card, #VI_NO_LOCK, 1000, @card_res)
    
    If result <> #VI_SUCCESS
      MessageBox_(GetFocus_(), "error resource open!" + Chr(10) + PeekS(*card, -1, #PB_Ascii), "..cv..", #MB_OK|#MB_ICONERROR|#MB_SYSTEMMODAL)
      ProcedureReturn #False
    EndIf    
    
    Dim count_array.q(33)  ; total 34*8byte
    
    Protected hwnd  = OpenWindow(#PB_Any, x, y, 400, 300, "plx9054 interrupt", #PB_Window_MinimizeGadget|#PB_Window_SystemMenu)    
    
    viInstallHandler(card_res, #VI_EVENT_EXCEPTION, @visa32_error_handler(), hwnd)    
    viEnableEvent(card_res, #VI_EVENT_EXCEPTION, #VI_HNDLR, #VI_NULL)    
    viInstallHandler(card_res, #VI_EVENT_PXI_INTR, @plx9054_int_spy_handler(), @count_array())
    viEnableEvent(card_res, #VI_EVENT_PXI_INTR, #VI_HNDLR, #VI_NULL)
    
    SetWindowPos_(WindowID(hwnd), #HWND_TOP, 0, 0, 0, 0, #SWP_NOMOVE|#SWP_NOSIZE)
    
    SendMessage_(WindowID(hwnd), #WM_SETICON, #ICON_SMALL, card1)
    SmartWindowRefresh(hwnd, 1)     
       If OSVersion < #PB_OS_Windows_7
     ;
   Else
     SkinH_SetAero(WindowID(hwnd))
   EndIf
    slot_id = 0
    model_name.s = Space(4096)
    viGetAttribute(card_res, #VI_ATTR_SLOT, @slot_id)   
    viGetAttribute(card_res, #VI_ATTR_MODEL_NAME, @model_name)
    
    SetWindowTitle(hwnd, PeekS(*card, -1, #PB_Ascii) + "@Slot" + Str(slot_id) + "@" + model_name)
    
    Protected toolbar_t = CreateToolBar(#PB_Any, WindowID(hwnd))
    If toolbar_t
      ToolBarImageButton(0, clear_icon)    
    EndIf  
    
    statusbar_t = CreateStatusBar(#PB_Any, WindowID(hwnd))
    If statusbar_t
      AddStatusBarField(#PB_Ignore)
    EndIf  
    
    doorbell_list_lig  = ListIconGadget(#PB_Any, 0, ToolBarHeight(toolbar_t)*2, WindowWidth(hwnd), WindowHeight(hwnd)-StatusBarHeight(statusbar_t)-ToolBarHeight(toolbar_t)*2, "Interrupt Source", 200, #PB_ListIcon_GridLines|#PB_ListIcon_FullRowSelect)    
    AddGadgetColumn(doorbell_list_lig, 1, "Count", 160)
    AddGadgetItem(doorbell_list_lig, 0, "doorbell_com3" + Chr(10) + "0")   
    AddGadgetItem(doorbell_list_lig, 1, "doorbell_com4" + Chr(10) + "0")    
    AddGadgetItem(doorbell_list_lig, 2, "doorbell_com5" + Chr(10) + "0")    
    AddGadgetItem(doorbell_list_lig, 3, "doorbell_com6" + Chr(10) + "0")    
    AddGadgetItem(doorbell_list_lig, 4, "doorbell_com7" + Chr(10) + "0")    
    AddGadgetItem(doorbell_list_lig, 5, "doorbell_com8" + Chr(10) + "0")    
    AddGadgetItem(doorbell_list_lig, 6, "doorbell_com9" + Chr(10) + "0")    
    AddGadgetItem(doorbell_list_lig, 7, "doorbell_com10" + Chr(10) + "0")    
    AddGadgetItem(doorbell_list_lig, 8, "doorbell_com11" + Chr(10) + "0")    
    AddGadgetItem(doorbell_list_lig, 9, "doorbell_com12" + Chr(10) + "0")    
    AddGadgetItem(doorbell_list_lig, 10, "doorbell_com13" + Chr(10) + "0")    
    AddGadgetItem(doorbell_list_lig, 11, "doorbell_com14" + Chr(10) + "0")    
    AddGadgetItem(doorbell_list_lig, 12, "doorbell_com15" + Chr(10) + "0")    
    AddGadgetItem(doorbell_list_lig, 13, "doorbell_com16" + Chr(10) + "0")    
    AddGadgetItem(doorbell_list_lig, 14, "doorbell_com17" + Chr(10) + "0")    
    AddGadgetItem(doorbell_list_lig, 15, "doorbell_com18" + Chr(10) + "0")    
    AddGadgetItem(doorbell_list_lig, 16, "doorbell_com19" + Chr(10) + "0")    
    AddGadgetItem(doorbell_list_lig, 17, "doorbell_com20" + Chr(10) + "0")    
    AddGadgetItem(doorbell_list_lig, 18, "doorbell_com21" + Chr(10) + "0")    
    AddGadgetItem(doorbell_list_lig, 19, "doorbell_com22" + Chr(10) + "0")       
    AddGadgetItem(doorbell_list_lig, 20, "doorbell_com23" + Chr(10) + "0")       
    AddGadgetItem(doorbell_list_lig, 21, "doorbell_com24" + Chr(10) + "0")       
    AddGadgetItem(doorbell_list_lig, 22, "doorbell_com25" + Chr(10) + "0")       
    AddGadgetItem(doorbell_list_lig, 23, "doorbell_com26" + Chr(10) + "0")       
    AddGadgetItem(doorbell_list_lig, 24, "doorbell_com27" + Chr(10) + "0")       
    AddGadgetItem(doorbell_list_lig, 25, "doorbell_com28" + Chr(10) + "0")       
    AddGadgetItem(doorbell_list_lig, 26, "doorbell_com29" + Chr(10) + "0")       
    AddGadgetItem(doorbell_list_lig, 27, "doorbell_com30" + Chr(10) + "0")       
    AddGadgetItem(doorbell_list_lig, 28, "doorbell_com31" + Chr(10) + "0")
    
    For k=0 To 28 Step 2
      SetGadgetItemColor(doorbell_list_lig, k, #PB_Gadget_BackColor, $00FFFF)
    Next k
    
    rebar_frame_cg  = ContainerGadget(#PB_Any, 0, ToolBarHeight(toolbar_t), WindowWidth(hwnd), ToolBarHeight(toolbar_t))
    Protected rebar_tb = CreateToolBarPlus(0, GadgetID(rebar_frame_cg))
    rebar_tb  = 0
    ToolBarImageButton(14, top_icon, #PB_ToolBar_Toggle)
    ToolBarImageButton(15, lock_icon, #PB_ToolBar_Toggle)
    ToolBarImageButton(16, bmp_icon)
    ToolBarImageButton(17, help_icon)    
    ToolBarSpace()    
    UseGadgetList(WindowID(hwnd)) 
    
    ToolBarToolTip(toolbar_t, 0, "Clear ALL Count!")
    ToolBarToolTip(rebar_tb, 14, "Always On Top") 
    ToolBarToolTip(rebar_tb, 15, "LOCK")
    ToolBarToolTip(rebar_tb, 16, "BMP截图")       
    ToolBarToolTip(rebar_tb, 17, "帮助")
    
    res_name.s = Space(4096)
    viGetAttribute(card_res, #VI_ATTR_RSRC_NAME, @res_name)
    
    StatusBarText(statusbar_t, 0, res_name)    
    AddWindowTimer(hwnd, 0, 100)
    
    Repeat
      Event.l = WaitWindowEvent()
      Select  Event
        Case  #PB_Event_Timer
          Select  EventTimer()
            Case  0
              SetGadgetItemText(doorbell_list_lig, 0, Str(count_array(3)), 1)
              SetGadgetItemText(doorbell_list_lig, 1, Str(count_array(4)), 1)
              SetGadgetItemText(doorbell_list_lig, 2, Str(count_array(5)), 1)
              SetGadgetItemText(doorbell_list_lig, 3, Str(count_array(6)), 1)
              SetGadgetItemText(doorbell_list_lig, 4, Str(count_array(7)), 1)
              SetGadgetItemText(doorbell_list_lig, 5, Str(count_array(8)), 1)
              SetGadgetItemText(doorbell_list_lig, 6, Str(count_array(9)), 1)
              SetGadgetItemText(doorbell_list_lig, 7, Str(count_array(10)), 1)
              SetGadgetItemText(doorbell_list_lig, 8, Str(count_array(11)), 1)
              SetGadgetItemText(doorbell_list_lig, 9, Str(count_array(12)), 1)
              SetGadgetItemText(doorbell_list_lig, 10, Str(count_array(13)), 1)
              SetGadgetItemText(doorbell_list_lig, 11, Str(count_array(14)), 1)
              SetGadgetItemText(doorbell_list_lig, 12, Str(count_array(15)), 1)
              SetGadgetItemText(doorbell_list_lig, 13, Str(count_array(16)), 1)
              SetGadgetItemText(doorbell_list_lig, 14, Str(count_array(17)), 1)
              SetGadgetItemText(doorbell_list_lig, 15, Str(count_array(18)), 1)
              SetGadgetItemText(doorbell_list_lig, 16, Str(count_array(19)), 1)
              SetGadgetItemText(doorbell_list_lig, 17, Str(count_array(20)), 1)
              SetGadgetItemText(doorbell_list_lig, 18, Str(count_array(21)), 1)
              SetGadgetItemText(doorbell_list_lig, 19, Str(count_array(22)), 1)
              SetGadgetItemText(doorbell_list_lig, 20, Str(count_array(23)), 1)
              SetGadgetItemText(doorbell_list_lig, 21, Str(count_array(24)), 1)
              SetGadgetItemText(doorbell_list_lig, 22, Str(count_array(25)), 1)
              SetGadgetItemText(doorbell_list_lig, 23, Str(count_array(26)), 1)
              SetGadgetItemText(doorbell_list_lig, 24, Str(count_array(27)), 1)
              SetGadgetItemText(doorbell_list_lig, 25, Str(count_array(28)), 1)
              SetGadgetItemText(doorbell_list_lig, 26, Str(count_array(29)), 1)
              SetGadgetItemText(doorbell_list_lig, 27, Str(count_array(30)), 1)
              SetGadgetItemText(doorbell_list_lig, 28, Str(count_array(31)), 1)
          EndSelect
        Case  #PB_Event_Gadget
          Select  EventGadget()
            Case  0
              ;
          EndSelect
        Case  #PB_Event_Menu
          Select EventMenu()
            Case  0
              For k=3 To 31 Step 1
                count_array(k)  = 0
              Next  k
            Case  14    ;top
              Delay(10)
              If  GetToolBarButtonState(rebar_tb, 14)
                SetWindowPos_(WindowID(hwnd), #HWND_TOPMOST, 0, 0, 0, 0, #SWP_NOMOVE|#SWP_NOSIZE)
              Else
                SetWindowPos_(WindowID(hwnd), #HWND_NOTOPMOST, 0, 0, 0, 0, #SWP_NOMOVE|#SWP_NOSIZE)
              EndIf               
            Case  15    ;lock
              Delay(10)
              If  GetToolBarButtonState(rebar_tb, 15)
                viLock(card_res, #VI_EXCLUSIVE_LOCK, 200, #VI_NULL, #VI_NULL)
              Else
                viUnlock(card_res)
              EndIf
            Case  16    ;capture
              CaptureWindow(GetWindowTitle(hwnd))
            Case  17    ;help
              SetWindowPos_(WindowID(hwnd), #HWND_NOTOPMOST, 0, 0, 0, 0, #SWP_NOMOVE|#SWP_NOSIZE)              
              MessageBox_(WindowID(hwnd), "-=cv=- 2012.9" + Chr(13) + Chr(10) + "copyright 2012 cv", "..cv..", #MB_OK | #MB_ICONINFORMATION|#MB_SYSTEMMODAL)
              If  GetToolBarButtonState(rebar_tb, 14)
                SetWindowPos_(WindowID(hwnd), #HWND_TOPMOST, 0, 0, 0, 0, #SWP_NOMOVE|#SWP_NOSIZE)
              Else
                SetWindowPos_(WindowID(hwnd), #HWND_NOTOPMOST, 0, 0, 0, 0, #SWP_NOMOVE|#SWP_NOSIZE)
              EndIf               
              SetWindowPos_(WindowID(hwnd), #HWND_TOP, 0, 0, 0, 0, #SWP_NOMOVE|#SWP_NOSIZE)             
          EndSelect
      EndSelect
    Until Event = #PB_Event_CloseWindow Or  quit  = #True    
    
    viDisableEvent(card_res, #VI_ALL_ENABLED_EVENTS, #VI_ALL_MECH)
    viUninstallHandler(card_res, #VI_EVENT_PXI_INTR, @plx9054_int_spy_handler(), @count_array()) 
    viUninstallHandler(card_res, #VI_EVENT_EXCEPTION, @visa32_error_handler(), hwnd)
    viClose(card_res)
    viClose(visa_default)
    CloseWindow(hwnd)
    ProcedureReturn #True
        
  EndProcedure
   
  ProcedureDLL  load_wrapper_dll()
    visa32_handle  = visa32_LoadDLL()
    osd_handle  = OSD_cv_LoadDLL()
    hDLL  = SkinH_LoadDLL()
    polyfit_dll = polyfit_LoadDLL()
    fft_dll = fft_LoadDLL()
    
    Static  osd_para.osd_param
    Static  unreg_text_a.s{1024}
    
    unreg_text_a = "unregister copy"    
    osd_para\lp_text  = @unreg_text_a
    osd_para\font_size  = 32
    osd_para\x  = 0
    osd_para\y  = 0
    osd_para\color_value  = RGBA(Random($ff), Random($ff), Random($ff), $d0)
    osd_para\long_time  = 0
    
    If  check_reg_sn()
      ;  
    Else
      osd_cv_thread(osd_para)
      reg_tid = timeSetEvent_(3600000, 1, @mmt(), 0 , #TIME_PERIODIC)
    EndIf
        
    WSysName.s = Space(255)
    GetSystemDirectory_(WSysName, @Null)
    WSysName  = WSysName  + "\skinh.she"    
    SkinH_AttachEx(@WSysName, @Null)
    SkinH_AdjustAero(240, 0, 0, 5, 0, 0, 0, 0, 0)
    
    InitNetwork()
        
  EndProcedure    
  
  ProcedureDLL  close_wrapper_dll()
    title.s = "cccc_osd"
    class.s = "OSD_window_cv"
    handle.l = FindWindow_(@class, @title)
    PostMessage_(handle, #WM_CLOSE, 0, 0)    
  EndProcedure
  
  ProcedureDLL  visa_server_remote(*pc_info)
    *ip_address = PeekL(*pc_info)
    x.l = PeekL(*pc_info  + 4)
    y.l = PeekL(*pc_info  + 8)
    ;reboot, shutdown, logoff三个功能
    
    reboot_icon  = 0
    ExtractIconEx_("cv_icons.dll", 110, @reboot_icon, #Null, 1)
    shutdown_icon  = 0
    shutdown_small_icon = 0
    ExtractIconEx_("cv_icons.dll", 91, @shutdown_icon, @shutdown_small_icon, 1)
    logoff_icon  = 0
    ExtractIconEx_("cv_icons.dll", 111, @logoff_icon, #Null, 1)
    exit_icon = 0
    ExtractIconEx_("cv_icons.dll", 93, @exit_icon, #Null, 1)    
    
    ip_addr.s = PeekS(*ip_address, -1, #PB_Ascii)
    slave_id  = OpenNetworkConnection(ip_addr, 6890, #PB_Network_UDP)
    
    If  slave_id  = 0
      MessageBox_(GetFocus_(), "can not connect to " + ip_addr  + "!", "..cv..", #MB_OK | #MB_ICONERROR|#MB_SYSTEMMODAL)
      ProcedureReturn #False
    Else
      ;
    EndIf
    
    Protected hwnd  = OpenWindow(#PB_Any, x, y, 160, 63, "visa_server_remote_cv", #PB_Window_Normal)
    SetWindowPos_(WindowID(hwnd), #HWND_TOP, 0, 0, 0, 0, #SWP_NOMOVE|#SWP_NOSIZE)
    SendMessage_(WindowID(hwnd), #WM_SETICON, #ICON_SMALL, shutdown_small_icon)
    SmartWindowRefresh(hwnd, 1)     
    StickyWindow(hwnd, #True)
       If OSVersion < #PB_OS_Windows_7
     ;
   Else
     SkinH_SetAero(WindowID(hwnd))
   EndIf
    statusbar_t = CreateStatusBar(#PB_Any, WindowID(hwnd))
    If statusbar_t
      AddStatusBarField(#PB_Ignore)
    EndIf 
    
    StatusBarText(statusbar_t, 0, ip_addr , #PB_StatusBar_BorderLess)
    
    reboot_bg = ButtonImageGadget(#PB_Any, 0, 0, 40, 40, reboot_icon)
    shutdown_bg = ButtonImageGadget(#PB_Any, 40, 0, 40, 40, shutdown_icon)
    logoff_bg = ButtonImageGadget(#PB_Any, 80, 0, 40, 40, logoff_icon)
    exit_bg = ButtonImageGadget(#PB_Any, 120, 0, 40, 40, exit_icon)
    
    GadgetToolTip(reboot_bg, "reboot the server!")
    GadgetToolTip(shutdown_bg, "shutdown the server!")
    GadgetToolTip(logoff_bg, "logoff the server!")
    GadgetToolTip(exit_bg, "88")    
    
    Repeat
      Event.l = WaitWindowEvent()
      Select  Event
        Case  #PB_Event_Timer
          Select  EventTimer()
            Case  0
              ;
          EndSelect
        Case  #PB_Event_Gadget
          Select  EventGadget()
            Case  exit_bg
              quit  = #True
            Case  reboot_bg
              result  = MessageBox_(GetFocus_(), "reboot the server: " + ip_addr + "?", "..cv..", #MB_YESNO | #MB_ICONQUESTION|#MB_SYSTEMMODAL)
              Select  result
                Case  6 ;yes
                  SendNetworkString(slave_id, "reboot")
                  quit  = #True
                Case  7 ;no
                  ;
                Default
                  ;
              EndSelect               
            Case  shutdown_bg
              result  = MessageBox_(GetFocus_(), "shutdown the server: " + ip_addr + "?", "..cv..", #MB_YESNO | #MB_ICONQUESTION|#MB_SYSTEMMODAL)
              Select  result
                Case  6 ;yes
                  SendNetworkString(slave_id, "shutdown")
                  quit  = #True
                Case  7 ;no
                  ;
                Default
                  ;
              EndSelect               
            Case  logoff_bg
              result  = MessageBox_(GetFocus_(), "logoff the server: " + ip_addr + "?", "..cv..", #MB_YESNO | #MB_ICONQUESTION|#MB_SYSTEMMODAL)
              Select  result
                Case  6 ;yes
                  SendNetworkString(slave_id, "logoff")
                  quit  = #True
                Case  7 ;no
                  ;
                Default
                  ;
              EndSelect           
          EndSelect
        Case  #PB_Event_Menu
          Select EventMenu()
            Case  0
              ;
          EndSelect
      EndSelect
    Until Event = #PB_Event_CloseWindow Or  quit  = #True    
    
    CloseNetworkConnection(slave_id) 
    CloseWindow(hwnd)
    
  EndProcedure
  
  ProcedureDLL  plx9054_eeprom_access(*card_info)
    ;EEPROM操作程序每写入一次EEPROM后要有对回读的数据判断是否与写入的一至
    ;$0~$54 step 4 is plx9054的初值
    MessageBox_(GetFocus_(), "plx9054_eeprom_access not completed", "cv", #MB_ICONINFORMATION|#MB_SYSTEMMODAL)    
    
  EndProcedure 
  
  ProcedureDLL.l  plx9054_eeprom_user_data_viewer(*card_info)
    ;$58~$1FC step 4 is user section eeprom space. display these data as readonly. 
    
    *card = PeekL(*card_info)   ;read 4byte
    x.l = PeekL(*card_info  + 12) ;read 4byte
    y.l = PeekL(*card_info  + 16) ;read 4byte    
    
    ExamineDesktops()
    
    chip1  = 0
    ExtractIconEx_("cv_icons.dll", 30, #Null, @chip1, 1)
    
    top_icon = 0
    ExtractIconEx_("cv_icons.dll", 94, #Null, @top_icon, 1)    
    bmp_icon = 0
    ExtractIconEx_("cv_icons.dll", 101, #Null, @bmp_icon, 1)
    help_icon = 0
    ExtractIconEx_("cv_icons.dll", 49, #Null, @help_icon, 1)
    lock_icon = 0
    ExtractIconEx_("cv_icons.dll", 58, #Null, @lock_icon, 1)    
    
    Protected visa_default.q  = 0
    viOpenDefaultRM(@visa_default)
    
    Protected card_res.q  = 0
    result  = viOpen(visa_default, *card, #VI_NO_LOCK, 1000, @card_res)
    
    If result <> #VI_SUCCESS
      MessageBox_(GetFocus_(), "error resource open!" + Chr(10) + PeekS(*card, -1, #PB_Ascii), "..cv..", #MB_OK | #MB_ICONERROR|#MB_SYSTEMMODAL)
      ProcedureReturn #False
    EndIf     
    
    Protected hwnd  = OpenWindow(#PB_Any, x, y, 560, 300, "plx9054 eeprom", #PB_Window_MinimizeGadget|#PB_Window_SystemMenu)
    
    viInstallHandler(card_res, #VI_EVENT_EXCEPTION, @visa32_error_handler(), hwnd)
    viEnableEvent(card_res, #VI_EVENT_EXCEPTION, #VI_HNDLR, #VI_NULL)        
    
    SetWindowPos_(WindowID(hwnd), #HWND_TOP, 0, 0, 0, 0, #SWP_NOMOVE|#SWP_NOSIZE)
    
    SendMessage_(WindowID(hwnd), #WM_SETICON, #ICON_SMALL, chip1)
    SmartWindowRefresh(hwnd, 1)     
       If OSVersion < #PB_OS_Windows_7
     ;
   Else
     SkinH_SetAero(WindowID(hwnd))
   EndIf
    slot_id = 0
    model_name.s = Space(4096)
    viGetAttribute(card_res, #VI_ATTR_SLOT, @slot_id)   
    viGetAttribute(card_res, #VI_ATTR_MODEL_NAME, @model_name)
    
    SetWindowTitle(hwnd, PeekS(*card, -1, #PB_Ascii) + "@Slot" + Str(slot_id) + "@" + model_name)
    
    Protected toolbar_t = CreateToolBar(#PB_Any, WindowID(hwnd))
    If toolbar_t
      ToolBarImageButton(0, chip1)    
    EndIf  
    
    statusbar_t = CreateStatusBar(#PB_Any, WindowID(hwnd))
    If statusbar_t
      AddStatusBarField(#PB_Ignore)
    EndIf  
    
    user_data_list_lig  = ListIconGadget(#PB_Any, 0, ToolBarHeight(toolbar_t)*2, WindowWidth(hwnd), WindowHeight(hwnd)-StatusBarHeight(statusbar_t)-ToolBarHeight(toolbar_t)*2, "Name", 200, #PB_ListIcon_GridLines|#PB_ListIcon_FullRowSelect)    
    AddGadgetColumn(user_data_list_lig, 1, "HEX", 160)
    AddGadgetColumn(user_data_list_lig, 2, "FLOAT", 160)
    
    k = 0
    test_data = 0
    For i=$58 To $1FC Step 4
      plx9054_read_eeprom_32(card_res, i, @test_data)
      AddGadgetItem(user_data_list_lig, -1, "user_data_" + Str(k) + Chr(10) + "0x" + RSet(Hex(test_data, #PB_Long), 8, "0") + Chr(10) + StrF(PeekF(@test_data), 4))   
      k = k + 1
    Next  i
        
    rebar_frame_cg  = ContainerGadget(#PB_Any, 0, ToolBarHeight(toolbar_t), WindowWidth(hwnd), ToolBarHeight(toolbar_t))
    Protected rebar_tb = CreateToolBarPlus(0, GadgetID(rebar_frame_cg))
    rebar_tb  = 0
    ToolBarImageButton(14, top_icon, #PB_ToolBar_Toggle)
    ToolBarImageButton(15, lock_icon, #PB_ToolBar_Toggle)
    ToolBarImageButton(16, bmp_icon)
    ToolBarImageButton(17, help_icon)    
    ToolBarSpace()    
    UseGadgetList(WindowID(hwnd)) 
    
    ToolBarToolTip(toolbar_t, 0, "to be continue!")
    ToolBarToolTip(rebar_tb, 14, "Always On Top") 
    ToolBarToolTip(rebar_tb, 15, "LOCK")
    ToolBarToolTip(rebar_tb, 16, "BMP截图")       
    ToolBarToolTip(rebar_tb, 17, "帮助")
    
    res_name.s = Space(4096)
    viGetAttribute(card_res, #VI_ATTR_RSRC_NAME, @res_name)
    
    StatusBarText(statusbar_t, 0, res_name)    
    AddWindowTimer(hwnd, 0, 1000)
    
    Repeat
      Event.l = WaitWindowEvent()
      Select  Event
        Case  #PB_Event_Timer
          Select  EventTimer()
            Case  0
              For i=0 To k-1 Step 1
                plx9054_read_eeprom_32(card_res, 4*i + $58, @test_data)
                SetGadgetItemText(user_data_list_lig, i, "0x" + RSet(Hex(test_data, #PB_Long), 8, "0"), 1)
                SetGadgetItemText(user_data_list_lig, i, StrF(PeekF(@test_data), 4), 2)
              Next  i
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
            Case  14    ;top
              Delay(10)
              If  GetToolBarButtonState(0, 14)
                SetWindowPos_(WindowID(hwnd), #HWND_TOPMOST, 0, 0, 0, 0, #SWP_NOMOVE|#SWP_NOSIZE)
              Else
                SetWindowPos_(WindowID(hwnd), #HWND_NOTOPMOST, 0, 0, 0, 0, #SWP_NOMOVE|#SWP_NOSIZE)
              EndIf               
            Case  15    ;lock
              Delay(10)
              If  GetToolBarButtonState(0, 15)
                viLock(card_res, #VI_EXCLUSIVE_LOCK, 200, #VI_NULL, #VI_NULL)
              Else
                viUnlock(card_res)
              EndIf
            Case  16    ;capture
              CaptureWindow(GetWindowTitle(hwnd))
            Case  17    ;help
              SetWindowPos_(WindowID(hwnd), #HWND_NOTOPMOST, 0, 0, 0, 0, #SWP_NOMOVE|#SWP_NOSIZE)              
              MessageBox_(WindowID(hwnd), "-=cv=- 2012.9" + Chr(13) + Chr(10) + "copyright 2012 cv", "..cv..", #MB_OK | #MB_ICONINFORMATION|#MB_SYSTEMMODAL)
              If  GetToolBarButtonState(0, 14)
                SetWindowPos_(WindowID(hwnd), #HWND_TOPMOST, 0, 0, 0, 0, #SWP_NOMOVE|#SWP_NOSIZE)
              Else
                SetWindowPos_(WindowID(hwnd), #HWND_NOTOPMOST, 0, 0, 0, 0, #SWP_NOMOVE|#SWP_NOSIZE)
              EndIf               
              SetWindowPos_(WindowID(hwnd), #HWND_TOP, 0, 0, 0, 0, #SWP_NOMOVE|#SWP_NOSIZE)             
          EndSelect
      EndSelect
    Until Event = #PB_Event_CloseWindow Or  quit  = #True    
    
    viDisableEvent(card_res, #VI_ALL_ENABLED_EVENTS, #VI_ALL_MECH)
    viUninstallHandler(card_res, #VI_EVENT_EXCEPTION, @visa32_error_handler(), hwnd)
    viClose(card_res)
    viClose(visa_default)
    CloseWindow(hwnd)
    ProcedureReturn #True
    
  EndProcedure  
  
  ProcedureDLL.l  burn_cv_style_eeprom_for_this_plx9054(card_res, id.l)
    ;
    Restore cv_style_eeprom_v1
    
    result  = MessageBox_(GetFocus_(), "please confirm to burn eeprom, are you sure to do it?", "..cv..", #MB_DEFBUTTON2|#MB_YESNO|#MB_ICONQUESTION|#MB_SYSTEMMODAL)       
    
    Select  result
      Case  #IDYES ;yes
        For i=0 To  $54 Step 4
          Read.l aaaa
                
          If $44 = i
            plx9054_write_eeprom_32(card_res, i, id)
          Else
            plx9054_write_eeprom_32(card_res, i, aaaa)
          EndIf
        Next i
        If check_plx9054_eeprom_is_cv_style(card_res)
          MessageBox_(GetFocus_(), "cv_style_eeprom is burn ready!", "..cv..", #MB_OK|#MB_ICONINFORMATION|#MB_SYSTEMMODAL)
          ProcedureReturn #True
        Else
          MessageBox_(GetFocus_(), "error write eeprom!", "..cv..", #MB_OK|#MB_ICONERROR|#MB_SYSTEMMODAL)
          ProcedureReturn #False
        EndIf  
      Case  #IDNO ;no
        ProcedureReturn #False
    EndSelect    
    
  EndProcedure  
   
  ProcedureDLL.l  check_plx9054_eeprom_is_cv_style(card_res)
    ;
    Restore cv_style_eeprom_v1
    Define  test_data.l = 0
    Define  flag.l  = #False
    
    For i=0 To  $54 Step 4
      plx9054_read_eeprom_32(card_res, i, @test_data)
      Read.l aaaa
            
      If $44 = i
        ;subid is not care. 
      Else
        If Hex(aaaa, #PB_Long) <> Hex(test_data, #PB_Long)
          flag  = #False
          Break          
        Else
          flag  = #True
        EndIf
      EndIf
    Next i
    
    ProcedureReturn flag
    
  EndProcedure
  
  ProcedureDLL.l  get_plx9054_fpga_logic_version(card_res)
    Define  value = 0
    viIn32(card_res, #VI_PXI_BAR0_SPACE, #PCI9054_MAILBOX7, @value) 
    ProcedureReturn value
  EndProcedure
  
  ProcedureDLL.l  AG34410A_controlpanel(*card)
    ;
    MessageBox_(GetFocus_(), "AG34410A_controlpanel not completed", "cv", #MB_SYSTEMMODAL|#MB_ICONINFORMATION)
    
    ProcedureReturn #True
  EndProcedure
  
  ProcedureDLL.l  MSO7034B_controlpanel(*card)
    
    chip1  = 0
    ExtractIconEx_("cv_icons.dll", 30, #Null, @chip1, 1)
    
    case1  = 0
    ExtractIconEx_("cv_icons.dll", 27, @case1, #Null, 1)  ;use big icon  
    
    save_icon = 0
    ExtractIconEx_("cv_icons.dll", 89, #Null, @save_icon, 1)     
    top_icon = 0
    ExtractIconEx_("cv_icons.dll", 94, #Null, @top_icon, 1)    
    bmp_icon = 0
    ExtractIconEx_("cv_icons.dll", 101, #Null, @bmp_icon, 1)
    help_icon = 0
    ExtractIconEx_("cv_icons.dll", 49, #Null, @help_icon, 1)
    lock_icon = 0
    ExtractIconEx_("cv_icons.dll", 58, #Null, @lock_icon, 1)        
    
    
    Protected visa_default.q  = 0
    viOpenDefaultRM(@visa_default)
    
    Protected card_res.q  = 0
    result = viOpen(visa_default, *card, #VI_NO_LOCK, 1000, @card_res)
    
    If result <> #VI_SUCCESS
      MessageBox_(GetFocus_(), "error resource open!" + Chr(10) + PeekS(*card, -1, #PB_Ascii), "..cv..", #MB_OK | #MB_ICONERROR|#MB_SYSTEMMODAL)
      ProcedureReturn #False
    EndIf
               
    command.s = Space(4096)
    write_size  = 0
    read_size = 0
    
    command  =  "CHANnel1:DISPlay ON"
    viWrite(card_res, @command, StringByteLength(command), @write_size)
    command  =  "CHANnel2:DISPlay ON"
    viWrite(card_res, @command, StringByteLength(command), @write_size)
    command  =  "CHANnel3:DISPlay ON"
    viWrite(card_res, @command, StringByteLength(command), @write_size)
    command  =  "CHANnel4:DISPlay ON"
    viWrite(card_res, @command, StringByteLength(command), @write_size)    
    command = "CHANnel1:LABel " + Chr(34) + "CH0" + Chr(34)
    viWrite(card_res, @command, StringByteLength(command), @write_size)    
    command = "CHANnel2:LABel " + Chr(34) + "CH1" + Chr(34)
    viWrite(card_res, @command, StringByteLength(command), @write_size)    
    command = "CHANnel3:LABel " + Chr(34) + "CH2" + Chr(34)
    viWrite(card_res, @command, StringByteLength(command), @write_size)    
    command = "CHANnel4:LABel " + Chr(34) + "CH3" + Chr(34)
    viWrite(card_res, @command, StringByteLength(command), @write_size)    
    
    command  =  "CHANnel2:DISPlay OFF"
    viWrite(card_res, @command, StringByteLength(command), @write_size)
    command  =  "CHANnel3:DISPlay OFF"
    viWrite(card_res, @command, StringByteLength(command), @write_size)
    command  =  "CHANnel4:DISPlay OFF"
    viWrite(card_res, @command, StringByteLength(command), @write_size)       
    
    *reply = AllocateMemory($400000)    
    command = "DISPLAY:DATA? BMP,SCREEN,GRAYscale"
    viWrite(card_res, @command, StringByteLength(command), @write_size)
    viRead(card_res, *reply, 10, @read_size)
    viRead(card_res, *reply, 10000000, @read_size)
    
    bmp_capture = CatchImage(#PB_Any, *reply)
    bmp_copy  = CopyImage(bmp_capture, #PB_Any)
    
    result = ResizeImage(bmp_capture, ImageWidth(bmp_capture)>>1, ImageHeight(bmp_capture)>>1, #PB_Image_Smooth)    
    
    sexy_font = LoadFont(#PB_Any, "courier new", 12, #PB_Font_Bold|#PB_Font_HighQuality)
    
    sexy_text.s = "cccc 2012.9"
    
    qrcode_image  = CreateQRCode("cvcvcv", #PB_Any, #QR_ECLEVEL_M, 3)
    
    If StartDrawing(ImageOutput(bmp_capture))
      DrawingMode(#PB_2DDrawing_Transparent)
      DrawingFont(FontID(sexy_font))
      For i = 1 To 100
        DrawText(Random(ImageWidth(bmp_capture)), Random(ImageHeight(bmp_capture)), sexy_text, RGB(Random(255), Random(255), Random(255)))
      Next i   
      DrawingMode(#PB_2DDrawing_Default)
      DrawImage(ImageID(qrcode_image), ImageWidth(bmp_capture)-45, ImageHeight(bmp_capture)-45, ImageWidth(qrcode_image), ImageHeight(qrcode_image))
      StopDrawing() 
    EndIf    
    
    Protected hwnd  = OpenWindow(#PB_Any, 0, 0, ImageWidth(bmp_capture), ImageHeight(bmp_capture) + 28, "MSO7034B", #PB_Window_MinimizeGadget|#PB_Window_SystemMenu|#PB_Window_ScreenCentered)    
    viInstallHandler(card_res, #VI_EVENT_EXCEPTION, @visa32_error_handler(), hwnd)
    viEnableEvent(card_res, #VI_EVENT_EXCEPTION, #VI_HNDLR, #VI_NULL)            
    
    SetWindowPos_(WindowID(hwnd), #HWND_TOP, 0, 0, 0, 0, #SWP_NOMOVE|#SWP_NOSIZE)
    SendMessage_(WindowID(hwnd), #WM_SETICON, #ICON_SMALL, case1)
    SmartWindowRefresh(hwnd, 1)     
    
    If OSVersion < #PB_OS_Windows_7
      ;
    Else
      SkinH_SetAero(WindowID(hwnd))
    EndIf
    
    Protected toolbar_t = CreateToolBar(#PB_Any, WindowID(hwnd))
    If toolbar_t
      ToolBarImageButton(0, save_icon)
      ToolBarSeparator()
      ToolBarImageButton(1, top_icon, #PB_ToolBar_Toggle)
      ToolBarImageButton(2, bmp_icon)
      ToolBarImageButton(3, lock_icon, #PB_ToolBar_Toggle)
      ToolBarImageButton(4, help_icon)    
      ToolBarSeparator()
      ToolBarImageButton(5, chip1)
      ToolBarImageButton(6, chip1)
      ToolBarSeparator()
      ToolBarImageButton(7, chip1)
      ToolBarImageButton(8, chip1)
      ToolBarImageButton(9, chip1)
      ToolBarImageButton(10, chip1)
      
    EndIf   
    
    ToolBarToolTip(toolbar_t, 0, "Save to BMP file-->Ctrl+S")
    ToolBarToolTip(toolbar_t, 1, "Always On The Top")
    ToolBarToolTip(toolbar_t, 2, "BMP截图")
    ToolBarToolTip(toolbar_t, 3, "LOCK")
    ToolBarToolTip(toolbar_t, 4, "帮助")
    ToolBarToolTip(toolbar_t, 5, "取示波器彩图-->F5")
    ToolBarToolTip(toolbar_t, 6, "取示波器灰度图-->F6")
    ToolBarToolTip(toolbar_t, 7, "通道使能控制")
    ToolBarToolTip(toolbar_t, 8, "触发控制")
    ToolBarToolTip(toolbar_t, 9, "测量")    
    ToolBarToolTip(toolbar_t, 10, "标签修改")    
        
    image_box = ImageGadget(#PB_Any, 0, ToolBarHeight(toolbar_t), ImageWidth(bmp_capture), ImageHeight(bmp_capture), ImageID(bmp_capture))
    
    res_name.s = Space(4096)
    viGetAttribute(card_res, #VI_ATTR_RSRC_NAME, @res_name)
    
    SetWindowTitle(hwnd, GetWindowTitle(hwnd) + " - " + res_name)
    
    AddKeyboardShortcut(hwnd, #PB_Shortcut_F5, 5)
    AddKeyboardShortcut(hwnd, #PB_Shortcut_F6, 6)
    AddKeyboardShortcut(hwnd, #PB_Shortcut_Control|#PB_Shortcut_S, 0)
    
    Repeat
      Event.l = WaitWindowEvent()
      Select  Event
        Case  #PB_Event_Timer
          Select  EventTimer()
            Case  0
              ;
          EndSelect
        Case  #PB_Event_Gadget
          Select  EventGadget()
            Case  0
              ;
          EndSelect
        Case  #PB_Event_Menu
          Select EventMenu()
            Case  0 ;save to bmp
              qrcode_image  = CreateQRCode("-=cccc=-" + Chr(10) + FormatDate("%mm/%dd/%yyyy - %hh:%ii:%ss", Date()) + Chr(10) + res_name, #PB_Any, #QR_ECLEVEL_M, 3)              
              If StartDrawing(ImageOutput(bmp_copy)) 
                DrawingMode(#PB_2DDrawing_Default)
                DrawImage(ImageID(qrcode_image), ImageWidth(bmp_copy)-110, ImageHeight(bmp_copy)-110, ImageWidth(qrcode_image), ImageHeight(qrcode_image))
                StopDrawing() 
              EndIf              
              Pattern$ = "位图 (*.bmp)|*.bmp|All files (*.*)|*.*"
              File.s = SaveFileRequester("Please choose file to save", "cccc", Pattern$, 0)
              
              If  File
                If  FindString(File, ".bmp", 1)
                  ;
                Else
                  File  = File  + ".bmp"
                EndIf
                If  -1 = FileSize(File) ;not find
                  SaveImage(bmp_copy, File, #PB_ImagePlugin_BMP)
                  MessageBox_(WindowID(hwnd), "BMP have saved following file:"+ Chr(13) + Chr(10) + File, "MSO7034B", #MB_OK | #MB_ICONINFORMATION|#MB_SYSTEMMODAL)          
                Else
                  result  = MessageBox_(WindowID(hwnd), "replace this file : " + File, "..cv..", #MB_YESNO | #MB_ICONQUESTION|#MB_SYSTEMMODAL)       
                  Select  result
                    Case  6
                      SaveImage(bmp_copy, File, #PB_ImagePlugin_BMP)
                      MessageBox_(WindowID(hwnd), "BMP have saved following file:"+ Chr(13) + Chr(10) + File, "MSO7034B", #MB_OK | #MB_ICONINFORMATION|#MB_SYSTEMMODAL)          
                    Case  7
                      ;
                  EndSelect
                EndIf
              Else
                MessageBox_(WindowID(hwnd), "The requester was canceled.", "MSO7034B", #MB_OK | #MB_ICONERROR|#MB_SYSTEMMODAL)
              EndIf              
            Case  5, 6
              If  5 = EventMenu()
                command = "DISPLAY:DATA? BMP,SCREEN,COLor"
              Else
                command = "DISPLAY:DATA? BMP,SCREEN,GRAYscale"
              EndIf
              viWrite(card_res, @command, StringByteLength(command), @write_size)
              viRead(card_res, *reply, 10, @read_size)
              viRead(card_res, *reply, 10000000, @read_size)
              
              bmp_capture = CatchImage(#PB_Any, *reply)
              bmp_copy  = CopyImage(bmp_capture, #PB_Any)              
              
              result = ResizeImage(bmp_capture, ImageWidth(bmp_capture)>>1, ImageHeight(bmp_capture)>>1, #PB_Image_Smooth)    
              
              SetGadgetState(image_box, ImageID(bmp_capture))
            Case  1    ;top
              Delay(10)
              If  GetToolBarButtonState(toolbar_t, EventMenu())
                SetWindowPos_(WindowID(hwnd), #HWND_TOPMOST, 0, 0, 0, 0, #SWP_NOMOVE|#SWP_NOSIZE)
              Else
                SetWindowPos_(WindowID(hwnd), #HWND_NOTOPMOST, 0, 0, 0, 0, #SWP_NOMOVE|#SWP_NOSIZE)
              EndIf               
            Case  3    ;lock
              Delay(10)
              If  GetToolBarButtonState(toolbar_t, EventMenu())
                viLock(card_res, #VI_EXCLUSIVE_LOCK, 200, #VI_NULL, #VI_NULL)
              Else
                viUnlock(card_res)
              EndIf
            Case  2    ;capture
              CaptureWindow(GetWindowTitle(hwnd))
            Case  4    ;help
              MessageBox_(WindowID(hwnd), "-=cv=- 2012.9" + Chr(13) + Chr(10) + "copyright 2012 cv", "..cv..", #MB_OK | #MB_ICONINFORMATION|#MB_SYSTEMMODAL)
          EndSelect
      EndSelect
    Until Event = #PB_Event_CloseWindow Or  quit  = #True
  
    viDisableEvent(card_res, #VI_ALL_ENABLED_EVENTS, #VI_ALL_MECH)
    viUninstallHandler(card_res, #VI_EVENT_EXCEPTION, @visa32_error_handler(), hwnd)
    viClose(card_res)
    viClose(visa_default)   
    CloseWindow(hwnd)    
    FreeMemory(*reply)
    
  EndProcedure
  
  ProcedureDLL  do_FFT(*x, *y, n.l, mode.l)
    ;快速傅利叶变换
    FFT(*x, *y, n, mode)
    ;
  EndProcedure

  ProcedureDLL  least_squares(n.l, *x, *y, poly_n.l, *a)
    ;最小二乘法dll    
    polyfit(n, *x, *y, poly_n, *a)
    ;
  EndProcedure
  
  ProcedureDLL.l  dec_input(*value)
    ; 
    input_icon  = 0
    ExtractIconEx_("cv_icons.dll", 50, #Null, @input_icon, 1)  
  
    hwnd  = OpenWindow(#PB_Any, 0, 0, 200, 65, "DEC INPUT", #PB_Window_ScreenCentered|#PB_Window_SystemMenu)
    SetWindowPos_(WindowID(hwnd), #HWND_TOPMOST, 0, 0, 0, 0, #SWP_NOMOVE|#SWP_NOSIZE)
    SendMessage_(WindowID(hwnd), #WM_SETICON, #ICON_SMALL, input_icon) 
    SmartWindowRefresh(hwnd, 1)     
       If OSVersion < #PB_OS_Windows_7
     ;
   Else
     SkinH_SetAero(WindowID(hwnd))
   EndIf
    num_sg = StringGadget(#PB_Any , 20, 15, 160, 20, "0", #PB_String_UpperCase|#PB_String_Numeric)
    
    SetGadgetText(num_sg, RSet(Str(PeekL(*value)), 8, "0"))
    SendMessage_(GadgetID(num_sg), #EM_SETLIMITTEXT, 20, 0)   
    SendMessage_(GadgetID(num_sg), #EM_SETSEL, 0, Len(GetGadgetText(num_sg)))    
    GadgetToolTip(num_sg, "Input dec")   
    
    ok_bg = ButtonGadget(#PB_Any, 70, 40, 60, 20, "OK", #PB_Button_Default)
    GadgetToolTip(ok_bg, "GO!")       
    
    AddKeyboardShortcut(hwnd, #PB_Shortcut_Escape, 0)    
    AddKeyboardShortcut(hwnd, #PB_Shortcut_Return, 3)    
    AddWindowTimer(hwnd, 0, 100) 
    AddWindowTimer(hwnd, 1, 2000)
    SetActiveGadget(num_sg)
        
    Repeat
      Event.l = WaitWindowEvent()
      Select  Event
        Case  #PB_Event_Timer
          Select  EventTimer()
            Case  0
              ;
            Case  1
              ;
          EndSelect
        Case  #PB_Event_Gadget
          Select  EventGadget()
            Case  num_sg
              Select EventType()
                Case #PB_EventType_Change
                  ;  
              EndSelect
            Case  ok_bg
              PokeL(*value, Val(GetGadgetText(num_sg)))
              quit  = #True
          EndSelect
        Case  #PB_Event_Menu
          Select EventMenu()
            Case  0
              CloseWindow(hwnd)
              ProcedureReturn #False
            Case  3
              PokeL(*value, Val(GetGadgetText(num_sg)))
              quit  = #True
          EndSelect 
        Case  #PB_Event_CloseWindow
          CloseWindow(hwnd)
          ProcedureReturn #False
      EndSelect
    Until quit  = #True
            
    CloseWindow(hwnd) 
    ProcedureReturn #True    
  EndProcedure
  
  ProcedureDLL.l  hex_input(*value, limit.l)
    ;     
    input_icon  = 0
    ExtractIconEx_("cv_icons.dll", 50, #Null, @input_icon, 1)  
  
    hwnd  = OpenWindow(#PB_Any, 0, 0, 200, 65, "HEX INPUT", #PB_Window_ScreenCentered|#PB_Window_SystemMenu)
    SetWindowPos_(WindowID(hwnd), #HWND_TOPMOST, 0, 0, 0, 0, #SWP_NOMOVE|#SWP_NOSIZE)
    SendMessage_(WindowID(hwnd), #WM_SETICON, #ICON_SMALL, input_icon) 
    SmartWindowRefresh(hwnd, 1)  
       If OSVersion < #PB_OS_Windows_7
     ;
   Else
     SkinH_SetAero(WindowID(hwnd))
   EndIf    
    
    num_sg = StringGadget(#PB_Any , 27, 15, 160, 20, "0", #PB_String_UpperCase)
    word  = TextGadget(#PB_Any, 12, 18, 15, 20, "0x")
    
    Select  limit
      Case  8
        SetGadgetText(num_sg, RSet(Hex(PeekB(*value), #PB_Byte), 2, "0"))
        SendMessage_(GadgetID(num_sg), #EM_SETLIMITTEXT, 2, 0)
      Case  16
        SetGadgetText(num_sg, RSet(Hex(PeekW(*value), #PB_Word), 4, "0"))
        SendMessage_(GadgetID(num_sg), #EM_SETLIMITTEXT, 4, 0)
      Case  32
        SetGadgetText(num_sg, RSet(Hex(PeekL(*value), #PB_Long), 8, "0"))
        SendMessage_(GadgetID(num_sg), #EM_SETLIMITTEXT, 8, 0)        
    EndSelect
    
    GadgetToolTip(num_sg, "Input hex")   
    
    ok_bg = ButtonGadget(#PB_Any, 70, 40, 60, 20, "OK", #PB_Button_Default)
    GadgetToolTip(ok_bg, "GO!")       
    
    AddKeyboardShortcut(hwnd, #PB_Shortcut_Escape, 0)    
    AddKeyboardShortcut(hwnd, #PB_Shortcut_Return, 3)    
    AddWindowTimer(hwnd, 0, 100) 
    AddWindowTimer(hwnd, 1, 2000)
    SetActiveGadget(num_sg)
    
    SendMessage_(GadgetID(num_sg), #EM_SETSEL, 0, Len(GetGadgetText(num_sg)))   
    
    Repeat
      Event.l = WaitWindowEvent()
      Select  Event
        Case  #PB_Event_Timer
          Select  EventTimer()
            Case  0
              ;
            Case  1
              ;
          EndSelect
        Case  #PB_Event_Gadget
          Select  EventGadget()
            Case  num_sg
              Select EventType()
                Case #PB_EventType_Change
                  start_p.l = 0
                  end_p.l = 0
                  SendMessage_(GadgetID(EventGadget()), #EM_GETSEL, @start_p, @end_p)
         
                  sInput.s = GetGadgetText(EventGadget())
                  iLen = Len(sInput)
                  sNumber.s = ""
                                         
                  For iCnt = 1 To iLen
                    sChar.s = Mid(sInput,iCnt,1)
                    iAscii = Asc(sChar)
                    iIncludeChar = #True
                                        
                    Select iAscii
                      Case 48, 49, 50, 51, 52, 53, 54, 55, 56, 57
                      Case 65, 66, 67, 68, 69, 70
                      Case 97, 98, 99, 100, 101, 102
                      Default: iIncludeChar = #False
                    EndSelect
                                        
                    If(iIncludeChar = #True) : sNumber = sNumber + sChar: EndIf              
                   
                  Next
                 
                  SetGadgetText(EventGadget(), sNumber)
                  SendMessage_(GadgetID(EventGadget()), #EM_SETSEL,start_p,end_p)  
             EndSelect
            Case  ok_bg
              Select  limit
                Case  8
                  PokeB(*value, Val("$" + GetGadgetText(num_sg)))
                Case  16
                  PokeW(*value, Val("$" + GetGadgetText(num_sg)))
                Case  32
                  PokeL(*value, Val("$" + GetGadgetText(num_sg)))
              EndSelect               
              quit  = #True
          EndSelect
        Case  #PB_Event_Menu
          Select EventMenu()
            Case  0
              CloseWindow(hwnd)
              ProcedureReturn #False
            Case  3
              Select  limit
                Case  8
                  PokeB(*value, Val("$" + GetGadgetText(num_sg)))
                Case  16
                  PokeW(*value, Val("$" + GetGadgetText(num_sg)))
                Case  32
                  PokeL(*value, Val("$" + GetGadgetText(num_sg)))
              EndSelect              
              quit  = #True
          EndSelect 
        Case  #PB_Event_CloseWindow
          CloseWindow(hwnd)
          ProcedureReturn #False
      EndSelect
    Until quit  = #True
    
    CloseWindow(hwnd) 

    ProcedureReturn #True
    
  EndProcedure
    
  ProcedureDLL.l  float_input(*value, dot.l)
    ;
    input_icon  = 0
    ExtractIconEx_("cv_icons.dll", 50, #Null, @input_icon, 1)  
  
    hwnd  = OpenWindow(#PB_Any, 0, 0, 200, 65, "FLOAT INPUT", #PB_Window_ScreenCentered|#PB_Window_SystemMenu)
    SetWindowPos_(WindowID(hwnd), #HWND_TOPMOST, 0, 0, 0, 0, #SWP_NOMOVE|#SWP_NOSIZE)
    SendMessage_(WindowID(hwnd), #WM_SETICON, #ICON_SMALL, input_icon) 
    SmartWindowRefresh(hwnd, 1)     
       If OSVersion < #PB_OS_Windows_7
     ;
   Else
     SkinH_SetAero(WindowID(hwnd))
   EndIf
    
    num_sg = StringGadget(#PB_Any , 20, 15, 160, 20, "0", #PB_String_UpperCase)
    
    If  dot >= 7
      dot = 7
    EndIf
    
    SetGadgetText(num_sg, StrF(PeekF(*value), dot))    
    GadgetToolTip(num_sg, "Input float")   
    
    ok_bg = ButtonGadget(#PB_Any, 70, 40, 60, 20, "OK", #PB_Button_Default)
    GadgetToolTip(ok_bg, "GO!")       
    
    AddKeyboardShortcut(hwnd, #PB_Shortcut_Escape, 0)    
    AddKeyboardShortcut(hwnd, #PB_Shortcut_Return, 3)    
    AddWindowTimer(hwnd, 0, 100) 
    AddWindowTimer(hwnd, 1, 2000)
    SetActiveGadget(num_sg)
    
    SendMessage_(GadgetID(num_sg), #EM_SETLIMITTEXT, 9, 0)        
    SendMessage_(GadgetID(num_sg), #EM_SETSEL, 0, Len(GetGadgetText(num_sg)))   
    
    Repeat
      Event.l = WaitWindowEvent()
      Select  Event
        Case  #PB_Event_Timer
          Select  EventTimer()
            Case  0
              ;
            Case  1
              ;
          EndSelect
        Case  #PB_Event_Gadget
          Select  EventGadget()
            Case  num_sg
              Select EventType()
                Case #PB_EventType_Change
                  start_p.l = 0
                  end_p.l = 0
                  SendMessage_(GadgetID(EventGadget()), #EM_GETSEL, @start_p, @end_p)
         
                  sInput.s = GetGadgetText(EventGadget())
                  iLen = Len(sInput)
                  sNumber.s = ""
                  
                  dot_flag.l  = #False
                  minus_flag.l  = #False
                  
                  For iCnt = 1 To iLen
                    sChar.s = Mid(sInput,iCnt,1)
                    iAscii = Asc(sChar)
                    iIncludeChar = #True
                                        
                    Select iAscii
                      Case 48, 49, 50, 51, 52, 53, 54, 55, 56, 57
                        Select  iCnt
                          Case  8
                            If  (dot_flag Or minus_flag)
                              ;
                            Else
                              iIncludeChar  = #False
                            EndIf 
                          Case  9
                            If  (dot_flag And  minus_flag)
                              ;
                            Else
                              iIncludeChar  = #False
                            EndIf
                        EndSelect
                      Case 46 ;dot
                        If  (#True = dot_flag)
                          iIncludeChar  = #False
                        Else
                          If  (9 <> iCnt  And 1 <>  iCnt)
                            iIncludeChar  = #True
                            dot_flag  = #True
                          Else
                            iIncludeChar  = #False
                          EndIf
                        EndIf
                      Case  45  ;minus
                        If  (#True = minus_flag)
                          iIncludeChar  = #False
                        Else
                          If  (9 <> iCnt)
                            iIncludeChar  = #True
                            minus_flag  = #True
                          Else
                            iIncludeChar  = #False
                          EndIf
                        EndIf                      
                      Default: iIncludeChar = #False
                    EndSelect
                                        
                    If(iIncludeChar = #True) : sNumber = sNumber + sChar: EndIf              
                   
                  Next
                 
                  SetGadgetText(EventGadget(), sNumber)
                  SendMessage_(GadgetID(EventGadget()), #EM_SETSEL,start_p,end_p)  
             EndSelect
            Case  ok_bg
              quit  = #True
          EndSelect
        Case  #PB_Event_Menu
          Select EventMenu()
            Case  0
              CloseWindow(hwnd)
              ProcedureReturn #False
            Case  3           
              quit  = #True
          EndSelect 
        Case  #PB_Event_CloseWindow
          CloseWindow(hwnd)
          ProcedureReturn #False
      EndSelect
    Until quit  = #True
    
    PokeF(*value, ValF(GetGadgetText(num_sg)))
    CloseWindow(hwnd) 
    ProcedureReturn #True
  EndProcedure
  
  ProcedureDLL  float_hex_convert()
    ;浮点数转成4字节的十六进制值，提供双向转换
    ;应用上大小端转换的函数
    float_hex_icon  = 0
    ExtractIconEx_("cv_icons.dll", 44, #Null, @float_hex_icon, 1)
    
    Protected hwnd = OpenWindow(#PB_Any, 0, 0, 300, 70, "float<->hex", #PB_Window_SystemMenu | #PB_Window_MinimizeGadget | #PB_Window_ScreenCentered)
    SetWindowPos_(WindowID(hwnd), #HWND_TOPMOST, 0, 0, 0, 0, #SWP_NOMOVE|#SWP_NOSIZE)
    SendMessage_(WindowID(hwnd), #WM_SETICON, #ICON_SMALL, float_hex_icon)
       If OSVersion < #PB_OS_Windows_7
     ;
   Else
     SkinH_SetAero(WindowID(hwnd))
   EndIf    
    
    float_sg = StringGadget(#PB_Any, 30, 10, 200, 20, "")
    hex_tg = TextGadget(#PB_Any, 10, 45, 20, 20, "0x")
    hex_sg = StringGadget(#PB_Any, 30, 40, 200, 20, "")
    bit_order_bg = ButtonGadget(#PB_Any, 240, 40, 20, 20, "B")
    endian_bg = ButtonGadget(#PB_Any, 270, 40, 20, 20, "E")
    less_accurate_bg = ButtonGadget(#PB_Any, 240, 10, 20, 20, "<-")
    more_accurate_bg = ButtonGadget(#PB_Any, 270, 10, 20, 20, "->")    
    
    GadgetToolTip(float_sg, "输入要转换的单精度浮点值")
    GadgetToolTip(hex_sg, "输入要转换的32bit整数hex值")
    GadgetToolTip(bit_order_bg, "改变位序")
    GadgetToolTip(endian_bg, "改变大小端（字节序）")
    GadgetToolTip(more_accurate_bg, "增加精度显示")
    GadgetToolTip(less_accurate_bg, "减少精度显示")
    
    SendMessage_(GadgetID(float_sg), #EM_SETLIMITTEXT, 9, 0)        
    SendMessage_(GadgetID(float_sg), #EM_SETSEL, 0, Len(GetGadgetText(float_sg)))       
    SendMessage_(GadgetID(hex_sg), #EM_SETLIMITTEXT, 8, 0)  
    SendMessage_(GadgetID(hex_sg), #EM_SETSEL, 0, Len(GetGadgetText(hex_sg)))  
    
    AddKeyboardShortcut(hwnd, #PB_Shortcut_Escape, 500) ;exit
    
    Define  hex_num.l = 0
    Define  start_p.l = 0
    Define  end_p.l = 0
    Define  float_num.f = 0
    Define  accurate_num.l  = 0
    
    Repeat
      Event.l = WaitWindowEvent()
      Select  Event
        Case  #PB_Event_Menu
          Select  EventMenu()
            Case  500
              quit  = #True
          EndSelect
        Case  #PB_Event_Gadget
          Select  EventGadget()
            Case  more_accurate_bg
              If  accurate_num  < 8
                accurate_num  + 1
                SetGadgetText(float_sg, StrF(ValF(GetGadgetText(float_sg)), accurate_num))
              EndIf
            Case  less_accurate_bg
              If  accurate_num  > 1
                accurate_num  - 1
                SetGadgetText(float_sg, StrF(ValF(GetGadgetText(float_sg)), accurate_num))
              EndIf
            Case  bit_order_bg
              SetGadgetText(hex_sg, Hex(dword_reverse_bits(Val("$" + GetGadgetText(hex_sg))), #PB_Long))
              hex_num = Val("$" + GetGadgetText(hex_sg))
              SetGadgetText(float_sg, StrF(PeekF(@hex_num), 3))              
            Case  endian_bg
              SetGadgetText(hex_sg, Hex(dword_change_endian(Val("$" + GetGadgetText(hex_sg))), #PB_Long))
              hex_num = Val("$" + GetGadgetText(hex_sg))
              SetGadgetText(float_sg, StrF(PeekF(@hex_num), 3))                
            Case  float_sg
              Select EventType()
                Case #PB_EventType_Change
                  start_p = 0
                  end_p = 0
                  SendMessage_(GadgetID(EventGadget()), #EM_GETSEL, @start_p, @end_p)
         
                  sInput.s = GetGadgetText(EventGadget())
                  iLen = Len(sInput)
                  sNumber.s = ""
                  
                  dot_flag.l  = #False
                  minus_flag.l  = #False
                  
                  For iCnt = 1 To iLen
                    sChar.s = Mid(sInput,iCnt,1)
                    iAscii = Asc(sChar)
                    iIncludeChar = #True
                                        
                    Select iAscii
                      Case 48, 49, 50, 51, 52, 53, 54, 55, 56, 57
                        Select  iCnt
                          Case  8
                            If  (dot_flag Or minus_flag)
                              ;
                            Else
                              iIncludeChar  = #False
                            EndIf 
                          Case  9
                            If  (dot_flag And  minus_flag)
                              ;
                            Else
                              iIncludeChar  = #False
                            EndIf
                        EndSelect
                      Case 46 ;dot
                        If  (#True = dot_flag)
                          iIncludeChar  = #False
                        Else
                          If  (9 <> iCnt  And 1 <>  iCnt)
                            iIncludeChar  = #True
                            dot_flag  = #True
                          Else
                            iIncludeChar  = #False
                          EndIf
                        EndIf
                      Case  45  ;minus
                        If  (#True = minus_flag)
                          iIncludeChar  = #False
                        Else
                          If  (9 <> iCnt)
                            iIncludeChar  = #True
                            minus_flag  = #True
                          Else
                            iIncludeChar  = #False
                          EndIf
                        EndIf                      
                      Default: iIncludeChar = #False
                    EndSelect
                                        
                    If(iIncludeChar = #True) : sNumber = sNumber + sChar: EndIf              
                   
                  Next
                 
                  SetGadgetText(EventGadget(), sNumber)
                  float_num = ValF(GetGadgetText(EventGadget()))
                  SetGadgetText(hex_sg, LSet(Hex(PeekL(@float_num), #PB_Long), 8, "0"))
                  SendMessage_(GadgetID(EventGadget()), #EM_SETSEL,start_p,end_p)  
              EndSelect
            Case  hex_sg
              Select EventType()
                Case #PB_EventType_Change
                  start_p = 0
                  end_p = 0
                  SendMessage_(GadgetID(EventGadget()), #EM_GETSEL, @start_p, @end_p)
         
                  sInput.s = GetGadgetText(EventGadget())
                  iLen = Len(sInput)
                  sNumber.s = ""
                                         
                  For iCnt = 1 To iLen
                    sChar.s = Mid(sInput,iCnt,1)
                    iAscii = Asc(sChar)
                    iIncludeChar = #True
                                        
                    Select iAscii
                      Case 48, 49, 50, 51, 52, 53, 54, 55, 56, 57
                      Case 65, 66, 67, 68, 69, 70
                      Case 97, 98, 99, 100, 101, 102
                      Default: iIncludeChar = #False
                    EndSelect
                                        
                    If(iIncludeChar = #True) : sNumber = sNumber + sChar: EndIf              
                   
                  Next
                 
                  SetGadgetText(EventGadget(), sNumber)
                  hex_num = Val("$" + GetGadgetText(EventGadget()))
                  SetGadgetText(float_sg, StrF(PeekF(@hex_num), 3))                  
                  SendMessage_(GadgetID(EventGadget()), #EM_SETSEL,start_p,end_p)  
              EndSelect
          EndSelect
        Case  #PB_Event_CloseWindow
          quit  = #True
      EndSelect
    Until quit  = #True
    
    CloseWindow(hwnd)    
    
  EndProcedure
  
  ProcedureDLL.l  select_ram0(*value)
    
    ram0_icon  = 0
    ExtractIconEx_("cv_icons.dll", 30, #Null, @ram0_icon, 1)      
    
    hwnd  = OpenWindow(#PB_Any, 0, 0, 200, 80, "Pick a ram0", #PB_Window_ScreenCentered|#PB_Window_SystemMenu)
    SetWindowPos_(WindowID(hwnd), #HWND_TOPMOST, 0, 0, 0, 0, #SWP_NOMOVE|#SWP_NOSIZE)
    SendMessage_(WindowID(hwnd), #WM_SETICON, #ICON_SMALL, ram0_icon)
       If OSVersion < #PB_OS_Windows_7
     ;
   Else
     SkinH_SetAero(WindowID(hwnd))
   EndIf    
    ram0_cb = ComboBoxGadget(#PB_Any , 20, 20, 160, 20, #PB_ComboBox_Image)
    
    For i =0  To 31 Step  1
      AddGadgetItem(ram0_cb, -1, "ram0_" + Str(i), ram0_icon)
    Next  i
        
    SetGadgetState(ram0_cb, PeekL(*value))
        
    ok_bg = ButtonGadget(#PB_Any, 70, 50, 60, 20, "OK", #PB_Button_Default)
    GadgetToolTip(ok_bg, "下一步")    
    
    AddKeyboardShortcut(hwnd, #PB_Shortcut_Escape, 0)
    AddKeyboardShortcut(hwnd, #PB_Shortcut_Return, 3) 
    
    Repeat
      Event.l = WaitWindowEvent()
      Select  Event
        Case  #PB_Event_Gadget
          Select  EventGadget()
            Case  ok_bg
              quit  = #True
          EndSelect
        Case  #PB_Event_Menu
          Select EventMenu()
            Case  3 ;回车
              quit  = #True
            Case  0 ;ESC
              CloseWindow(hwnd)
              ProcedureReturn #False              
          EndSelect 
        Case  #PB_Event_CloseWindow
          CloseWindow(hwnd)
          ProcedureReturn #False
      EndSelect
    Until quit  = #True
    
    PokeL(*value, Val(StringField(GetGadgetText(ram0_cb), 2, "_")))
            
    CloseWindow(hwnd)
    ProcedureReturn #True
    
  EndProcedure
  
  ProcedureDLL.l  select_bar(*value)
    
    bar_icon  = 0
    ExtractIconEx_("cv_icons.dll", 33, #Null, @bar_icon, 1)      
    
    hwnd  = OpenWindow(#PB_Any, 0, 0, 200, 80, "Pick a bar", #PB_Window_ScreenCentered|#PB_Window_SystemMenu)
    SetWindowPos_(WindowID(hwnd), #HWND_TOPMOST, 0, 0, 0, 0, #SWP_NOMOVE|#SWP_NOSIZE)
    SendMessage_(WindowID(hwnd), #WM_SETICON, #ICON_SMALL, bar_icon)
       If OSVersion < #PB_OS_Windows_7
     ;
   Else
     SkinH_SetAero(WindowID(hwnd))
   EndIf
    bar_cb = ComboBoxGadget(#PB_Any , 20, 20, 160, 20, #PB_ComboBox_Image)
    AddGadgetItem(bar_cb, -1, "#VI_PXI_BAR0_SPACE", bar_icon)
    AddGadgetItem(bar_cb, -1, "#VI_PXI_BAR1_SPACE", bar_icon)
    AddGadgetItem(bar_cb, -1, "#VI_PXI_BAR2_SPACE", bar_icon)
    AddGadgetItem(bar_cb, -1, "#VI_PXI_BAR3_SPACE", bar_icon)
    AddGadgetItem(bar_cb, -1, "#VI_PXI_BAR4_SPACE", bar_icon)
    AddGadgetItem(bar_cb, -1, "#VI_PXI_BAR5_SPACE", bar_icon)
    
    init_s.l  = PeekL(*value)
    Select  init_s
      Case  #VI_PXI_BAR0_SPACE
        SetGadgetState(bar_cb, 0)
      Case  #VI_PXI_BAR1_SPACE
        SetGadgetState(bar_cb, 1)
      Case  #VI_PXI_BAR2_SPACE
        SetGadgetState(bar_cb, 2)
      Case  #VI_PXI_BAR3_SPACE
        SetGadgetState(bar_cb, 3)
      Case  #VI_PXI_BAR4_SPACE
        SetGadgetState(bar_cb, 4)
      Case  #VI_PXI_BAR5_SPACE
        SetGadgetState(bar_cb, 5)        
    EndSelect
    
    ok_bg = ButtonGadget(#PB_Any, 70, 50, 60, 20, "OK", #PB_Button_Default)
    GadgetToolTip(ok_bg, "下一步")    
    
    AddKeyboardShortcut(hwnd, #PB_Shortcut_Escape, 0)
    AddKeyboardShortcut(hwnd, #PB_Shortcut_Return, 3) 
    
    Repeat
      Event.l = WaitWindowEvent()
      Select  Event
        Case  #PB_Event_Gadget
          Select  EventGadget()
            Case  ok_bg
              quit  = #True
          EndSelect
        Case  #PB_Event_Menu
          Select EventMenu()
            Case  3
              quit  = #True
            Case  0
              CloseWindow(hwnd)
              ProcedureReturn #False              
          EndSelect 
        Case  #PB_Event_CloseWindow
          CloseWindow(hwnd)
          ProcedureReturn #False
      EndSelect
    Until quit  = #True
    
    Select  GetGadgetText(bar_cb)
      Case  "#VI_PXI_BAR0_SPACE"
        PokeL(*value, #VI_PXI_BAR0_SPACE)
      Case  "#VI_PXI_BAR1_SPACE"
        PokeL(*value, #VI_PXI_BAR1_SPACE)
      Case  "#VI_PXI_BAR2_SPACE"
        PokeL(*value, #VI_PXI_BAR2_SPACE)
      Case  "#VI_PXI_BAR3_SPACE"
        PokeL(*value, #VI_PXI_BAR3_SPACE)
      Case  "#VI_PXI_BAR4_SPACE"
        PokeL(*value, #VI_PXI_BAR4_SPACE)
      Case  "#VI_PXI_BAR5_SPACE"
        PokeL(*value, #VI_PXI_BAR5_SPACE)
    EndSelect
            
    CloseWindow(hwnd)
    ProcedureReturn #True
    
  EndProcedure
  
  ProcedureDLL.l  string_input(*value)
    ; 
    input_icon  = 0
    ExtractIconEx_("cv_icons.dll", 50, #Null, @input_icon, 1)  
  
    hwnd  = OpenWindow(#PB_Any, 0, 0, 200, 65, "STRING INPUT", #PB_Window_ScreenCentered|#PB_Window_SystemMenu)
    SetWindowPos_(WindowID(hwnd), #HWND_TOPMOST, 0, 0, 0, 0, #SWP_NOMOVE|#SWP_NOSIZE)
    SendMessage_(WindowID(hwnd), #WM_SETICON, #ICON_SMALL, input_icon) 
    SmartWindowRefresh(hwnd, 1)     
       If OSVersion < #PB_OS_Windows_7
     ;
   Else
     SkinH_SetAero(WindowID(hwnd))
   EndIf
    num_sg = StringGadget(#PB_Any , 20, 15, 160, 20, "abcd")
    
    SetGadgetText(num_sg, PeekS(*value, -1, #PB_Ascii))
    string_size.l = StringByteLength(PeekS(*value, -1, #PB_Ascii))
    GadgetToolTip(num_sg, "Input string")   
    
    ok_bg = ButtonGadget(#PB_Any, 70, 40, 60, 20, "OK", #PB_Button_Default)
    GadgetToolTip(ok_bg, "GO!")       
    
    AddKeyboardShortcut(hwnd, #PB_Shortcut_Escape, 0)    
    AddKeyboardShortcut(hwnd, #PB_Shortcut_Return, 3)    
    AddWindowTimer(hwnd, 0, 100) 
    AddWindowTimer(hwnd, 1, 2000)
    SetActiveGadget(num_sg)
    
    ;SendMessage_(GadgetID(num_sg), #EM_SETLIMITTEXT, string_size, 0)   
    SendMessage_(GadgetID(num_sg), #EM_SETSEL, 0, Len(GetGadgetText(num_sg)))    
        
    Repeat
      Event.l = WaitWindowEvent()
      Select  Event
        Case  #PB_Event_Timer
          Select  EventTimer()
            Case  0
              ;
            Case  1
              ;
          EndSelect
        Case  #PB_Event_Gadget
          Select  EventGadget()
            Case  num_sg
              Select EventType()
                Case #PB_EventType_Change
                  ;  
             EndSelect
            Case  ok_bg
              quit  = #True
          EndSelect
        Case  #PB_Event_Menu
          Select EventMenu()
            Case  0
              CloseWindow(hwnd)
              ProcedureReturn #False
            Case  3
              quit  = #True
          EndSelect 
        Case  #PB_Event_CloseWindow
          CloseWindow(hwnd)
          ProcedureReturn #False
      EndSelect
    Until quit  = #True
    
    PokeS(*value, GetGadgetText(num_sg), -1, #PB_Ascii)
            
    CloseWindow(hwnd) 
    ProcedureReturn #True    
    
  EndProcedure  
  
  ProcedureDLL about_cv()
    
    UsePNGImageDecoder()
    
    cv_icon  = 0
    ExtractIconEx_("cv_icons.dll", 38, #Null, @cv_icon, 1)  
  
    hwnd  = OpenWindow(#PB_Any, 0, 0, 400, 250, "=CV=", #PB_Window_ScreenCentered|#PB_Window_SystemMenu)
    SetWindowPos_(WindowID(hwnd), #HWND_TOPMOST, 0, 0, 0, 0, #SWP_NOMOVE|#SWP_NOSIZE)
    SendMessage_(WindowID(hwnd), #WM_SETICON, #ICON_SMALL, cv_icon) 
    SmartWindowRefresh(hwnd, 1)        
       If OSVersion < #PB_OS_Windows_7
     ;
   Else
     SkinH_SetAero(WindowID(hwnd))
   EndIf
    
    container1  = ContainerGadget(#PB_Any, 50, 30, 200, 100)    
    name_sg = StringGadget(#PB_Any , 8, 12, 180, 20, "cccc")
    sn_sg = StringGadget(#PB_Any, 8, 35, 180, 20, "1234567890", #PB_String_Password)
    ok_bg = ButtonGadget(#PB_Any, 70, 65, 60, 20, "REG!", #PB_Button_Default)
    GadgetToolTip(ok_bg, "Thanks!")       
    CloseGadgetList()
    HideGadget(container1, #True)
        
    container3  = ContainerGadget(#PB_Any, 50, 30, 200, 100)
    
    WSysName.s = Space(255)
    GetSystemDirectory_(WSysName, @Null)
    WSysName  = WSysName  + "\"
      
    file1_name.s  = WSysName + "cv.gif"
    DeleteFile(file1_name)      
    result.q = FileSize(file1_name)
    If  result > 0
      ;
    Else
      If  result = -1
        file1 = CreateFile(#PB_Any, file1_name)
        WriteData(file1, ?gif1_start, ?gif1_end - ?gif1_start)
        CloseFile(file1)
      EndIf
    EndIf       
    
    url.s{1024*8}  = PeekS(?html1_start, ?html1_end  - ?html1_start, #PB_Ascii)
    url_2.s{1024*10} = ReplaceString(url, "%gif_name%", file1_name)
    
    cv_gif_wg = WebGadget(#PB_Any, 0, 0, 200, 100, url_2)
    CloseGadgetList()
    HideGadget(container3, #False)       
    
    angry_bird1 = CatchImage(#PB_Any, ?image3)
    angry_bird2 = CatchImage(#PB_Any, ?image4)
    angry_bird3 = CatchImage(#PB_Any, ?image5)
    
    logo_ig = ImageGadget(#PB_Any, 265, 30, 100, 100, ImageID(angry_bird1))
    If  check_reg_sn()
      SetGadgetState(logo_ig, ImageID(angry_bird1))
    Else
      SetGadgetState(logo_ig, ImageID(angry_bird3))
    EndIf       
    
    AddKeyboardShortcut(hwnd, #PB_Shortcut_Escape, 0)
    SetActiveGadget(name_sg)    
    SendMessage_(GadgetID(name_sg), #EM_SETSEL, 0, Len(GetGadgetText(name_sg)))   
    
    hdll.i = OpenLibrary(#PB_Any, "BASSMOD.dll")  
    CallFunction(hdll, "BASSMOD_Init", -1,44100,0)
    CallFunction(hdll, "BASSMOD_MusicLoad", 1, ?MUSIC1, 0, 0, #BASS_MUSIC_LOOP)
    CallFunction(hdll, "BASSMOD_MusicPlay")
    
    email_hlg = HyperLinkGadget(#PB_Any, 50, 190, 100, 20,"Check Update!", RGB(0, 0, 255), #PB_HyperLink_Underline)
    SetGadgetFont(email_hlg,  #PB_Default)    
    
    If OSVersion() < #PB_OS_Windows_7
      ;
    Else
      Aerotic_Apply(WindowID(hwnd), 20, 0, 20, 20)
    EndIf
    
    Repeat
      Event.l = WaitWindowEvent()
      Select  Event
        Case  #PB_Event_Timer
          Select  EventTimer()
            Case  0
              ;
            Case  1
              ;
          EndSelect
        Case  #PB_Event_Gadget
          Select  EventGadget()
            Case  logo_ig
              If  check_reg_sn()
                HideGadget(container3, #False)
                HideGadget(container1, #True)
              Else
                HideGadget(container1, #False)
                HideGadget(container3, #True)
              EndIf
            Case  name_sg
              Select EventType()
                Case #PB_EventType_Change
                  ;  
              EndSelect
            Case  email_hlg
              RunProgram("http://ccccmagicboy.f3322.org:100/?page_id=76", "", "", #PB_Program_Hide)
            Case  ok_bg
              WriteRegKey(#HKEY_LOCAL_MACHINE, "Software\cv\visa32_pb_wrapper", "user", GetGadgetText(name_sg))
              WriteRegKey(#HKEY_LOCAL_MACHINE, "Software\cv\visa32_pb_wrapper", "serial", GetGadgetText(sn_sg))
              If  check_reg_sn()
                HideGadget(container1, #True)
                HideGadget(container3, #False)
                SetGadgetState(logo_ig, ImageID(angry_bird2))
              Else
                HideGadget(container1, #False)
                SetGadgetState(logo_ig, ImageID(angry_bird3))
              EndIf              
          EndSelect
        Case  #PB_Event_Menu
          Select EventMenu()
            Case  0
              quit  = #True
          EndSelect 
        Case  #PB_Event_CloseWindow
          quit  = #True
      EndSelect
    Until quit  = #True
    
    CloseWindow(hwnd) 
    CallFunction(hdll, "BASSMOD_MusicStop")
    CallFunction(hdll, "BASSMOD_MusicFree")
    CallFunction(hdll, "BASSMOD_Free")  
    CloseLibrary(hdll)
        
  EndProcedure
  
  ProcedureDLL.l dword_change_endian(value.l)
    ;for example:
    ;Debug Hex(ChangeEndian($12345678))
    
    Structure bquad
      byte.a[4]
    EndStructure
   
    Protected result.l = 0
    *thismem.bquad = @result
    *thatmem.bquad = @value
    For i=0 To 3
      *thismem\byte[i] = *thatmem\byte[3-i]
    Next
   
    ProcedureReturn result
   
  EndProcedure
    
  ProcedureDLL  pci_usb_pnp_list()
        
    NewList pnplist.s()
    
    DeviceInfoData.SP_DEVINFO_DATA 
    Define  f111.l   
    pnplen = 255 
    pnp.s{4096} = ""    
    Define  i.l
    
    hDeviceInfoSet = SetupDiGetClassDevs_(0,0,0,#DIGCF_PRESENT|#DIGCF_ALLCLASSES) 
    
    DeviceInfoData\cbSize=SizeOf(DeviceInfoData) 
    
    i=0
    lib11 = OpenLibrary(#PB_Any,"cfgmgr32.dll") 
    f111 = GetFunction(lib11, "CM_Get_Device_IDA") 
    
    Repeat 
      If SetupDiEnumDeviceInfo_(hDeviceInfoSet,i,@DeviceInfoData) = 0 
        Break 
      EndIf  
      i+1
      pnp = "" 
      CallFunctionFast(f111,DeviceInfoData\DevInst,@pnp,pnplen,0) 
      If  FindString(pnp, "PCI\VEN", 1) Or  FindString(pnp, "USB\VID", 1)
        AddElement(pnplist())
        pnplist() = pnp
      EndIf
    ForEver 
    CloseLibrary(lib11) 
    
    SetupDiDestroyDeviceInfoList_(hDeviceInfoSet) 
    
    SortList(pnplist(), #PB_Sort_Ascending)
        
    pci_icon_big  = 0
    pci_icon_small  = 0
    ExtractIconEx_("cv_icons.dll", 8, @pci_icon_big, @pci_icon_small, 1)
    usb_icon  = 0
    ExtractIconEx_("cv_icons.dll", 156, @usb_icon, #Null, 1)
  
    hwnd  = OpenWindow(#PB_Any, 0, 0, 640, 480, "list of pnp device by cv 2012.12", #PB_Window_MaximizeGadget|#PB_Window_MinimizeGadget|#PB_Window_ScreenCentered|#PB_Window_SystemMenu)
    SetWindowPos_(WindowID(hwnd), #HWND_TOP, 0, 0, 0, 0, #SWP_NOMOVE|#SWP_NOSIZE)
    SendMessage_(WindowID(hwnd), #WM_SETICON, #ICON_SMALL, pci_icon_big) 
    SmartWindowRefresh(hwnd, 1)  
       If OSVersion < #PB_OS_Windows_7
     ;
   Else
     SkinH_SetAero(WindowID(hwnd))
   EndIf
        
    refresh_bg = ButtonGadget(#PB_Any, 20, 420, 60, 25, "Refresh", #PB_Button_Default)
    GadgetToolTip(refresh_bg, "刷新")       
    
    plx9054_bg = ButtonGadget(#PB_Any, 100, 420, 70, 25, "PLX only")
    GadgetToolTip(plx9054_bg, "只列出使用plx9054芯片的PCI板子")     
    
    export_bg = ButtonGadget(#PB_Any, 190, 420, 60, 25, "Export")
    GadgetToolTip(export_bg, "导出列表")    
    
    pnp_list_lig = ListIconGadget(#PB_Any, 0, 0, WindowWidth(hwnd), 400, "pnp device list", WindowWidth(hwnd) ,#PB_ListIcon_GridLines)
    SetGadgetAttribute(pnp_list_lig, #PB_ListIcon_DisplayMode, #PB_ListIcon_Report)
    ForEach pnplist()
      If  FindString(pnplist(), "PCI\VEN", 1)
        AddGadgetItem(pnp_list_lig, -1, pnplist(), pci_icon_small)
      Else
        AddGadgetItem(pnp_list_lig, -1, pnplist(), usb_icon)
      EndIf
    Next
    
    AddKeyboardShortcut(hwnd, #PB_Shortcut_Escape, 3)
    AddWindowTimer(hwnd, 0, 100) 
    
    PureRESIZE_SetGadgetResize(plx9054_bg, 1, 0, 0, 0)
    PureRESIZE_SetGadgetResize(refresh_bg, 1, 0, 0, 0)
    PureRESIZE_SetGadgetResize(export_bg, 1, 0, 0, 0)
    PureRESIZE_SetGadgetResize(pnp_list_lig, 1, 1, 1, 1)
    
    PureRESIZE_SetWindowMinimumSize(hwnd, WindowWidth(hwnd), WindowHeight(hwnd))    
    
    Repeat
      Event.l = WaitWindowEvent()
      Select  Event
        Case  #PB_Event_Timer
          Select  EventTimer()
            Case  0
              ;
          EndSelect
        Case  #PB_Event_Gadget
          Select  EventGadget()
            Case  plx9054_bg
              ClearGadgetItems(pnp_list_lig)
              ClearList(pnplist())
              hDeviceInfoSet = SetupDiGetClassDevs_(0,0,0,#DIGCF_PRESENT|#DIGCF_ALLCLASSES) 
              
              DeviceInfoData\cbSize=SizeOf(DeviceInfoData) 
              
              i=0
              lib11 = OpenLibrary(#PB_Any,"cfgmgr32.dll") 
              f111 = GetFunction(lib11, "CM_Get_Device_IDA") 
              
              Repeat 
                If SetupDiEnumDeviceInfo_(hDeviceInfoSet,i,@DeviceInfoData) = 0 
                  Break 
                EndIf  
                i+1
                pnp = "" 
                CallFunctionFast(f111,DeviceInfoData\DevInst,@pnp,pnplen,0) 
                If  FindString(pnp, "PCI\VEN", 1) Or  FindString(pnp, "USB\VID", 1)
                  AddElement(pnplist())
                  pnplist() = pnp
                EndIf
              ForEver 
              CloseLibrary(lib11) 
              
              SetupDiDestroyDeviceInfoList_(hDeviceInfoSet) 
              
              SortList(pnplist(), #PB_Sort_Ascending)
              
              ForEach pnplist()
                If  FindString(pnplist(), "PCI\VEN", 1) And FindString(pnplist(), "10B5", 1)
                  AddGadgetItem(pnp_list_lig, -1, pnplist(), pci_icon_small)
                Else
                  ;
                EndIf
              Next
            Case  export_bg
              StandardFile$ = "C:\result.txt"
              Pattern$ = "Text (*.txt)|*.txt|All files (*.*)|*.*"
              File$ = SaveFileRequester("Please choose file to save", StandardFile$, Pattern$, 0)
              If  File$
                If  FindString(File$, ".txt", 1)
                  ;
                Else
                  File$  = File$  + ".txt"
                EndIf
                If  -1 = FileSize(File$) ;not find
                  If CreateFile(0, File$)
                    For index = 0 To CountGadgetItems(pnp_list_lig) - 1
                      WriteStringN(0, GetGadgetItemText(pnp_list_lig, index))
                    Next                   
                    CloseFile(0)
                  EndIf                  
                  MessageBox_(GetFocus_(), "TXT have saved following file:"+ Chr(13) + Chr(10) + File$, "cv", #MB_OK|#MB_ICONINFORMATION|#MB_SYSTEMMODAL)          
                Else
                  result  = MessageBox_(GetFocus_(), "replace this file : " + File$, "..cv..", #MB_YESNO|#MB_ICONQUESTION|#MB_SYSTEMMODAL|#MB_DEFBUTTON2)       
                  Select  result
                    Case  6
                      If CreateFile(0, File$)
                        For index = 0 To CountGadgetItems(pnp_list_lig) - 1
                          WriteStringN(0, GetGadgetItemText(pnp_list_lig, index))
                        Next                   
                        CloseFile(0)
                      EndIf                                          
                      MessageBox_(GetFocus_(), "TXT have saved following file:"+ Chr(13) + Chr(10) + File$, "cv", #MB_OK|#MB_ICONINFORMATION|#MB_SYSTEMMODAL)          
                    Case  7
                      ;
                  EndSelect
                EndIf
              Else
                MessageBox_(GetFocus_(), "The save file requester was canceled.", "cv", #MB_OK|#MB_ICONERROR|#MB_SYSTEMMODAL)
              EndIf
            Case  refresh_bg
              ClearGadgetItems(pnp_list_lig)
              ClearList(pnplist())
              hDeviceInfoSet = SetupDiGetClassDevs_(0,0,0,#DIGCF_PRESENT|#DIGCF_ALLCLASSES) 
              
              DeviceInfoData\cbSize=SizeOf(DeviceInfoData) 
              
              i=0
              lib11 = OpenLibrary(#PB_Any,"cfgmgr32.dll") 
              f111 = GetFunction(lib11, "CM_Get_Device_IDA") 
              
              Repeat 
                If SetupDiEnumDeviceInfo_(hDeviceInfoSet,i,@DeviceInfoData) = 0 
                  Break 
                EndIf  
                i+1
                pnp = "" 
                CallFunctionFast(f111,DeviceInfoData\DevInst,@pnp,pnplen,0) 
                If  FindString(pnp, "PCI\VEN", 1) Or  FindString(pnp, "USB\VID", 1)
                  AddElement(pnplist())
                  pnplist() = pnp
                EndIf
              ForEver 
              CloseLibrary(lib11) 
              
              SetupDiDestroyDeviceInfoList_(hDeviceInfoSet) 
              
              SortList(pnplist(), #PB_Sort_Ascending)
              
              ForEach pnplist()
                If  FindString(pnplist(), "PCI\VEN", 1)
                  AddGadgetItem(pnp_list_lig, -1, pnplist(), pci_icon_small)
                Else
                  AddGadgetItem(pnp_list_lig, -1, pnplist(), usb_icon)
                EndIf
              Next
            Case  pnp_list_lig
              Select EventType()
                Case #PB_EventType_LeftClick
                  If GetGadgetState(pnp_list_lig) <> -1 
                    ;  
                  EndIf
                Case #PB_EventType_RightClick
                  ;
                Case #PB_EventType_LeftDoubleClick
                  If GetGadgetState(pnp_list_lig) <> -1 
                    ;  
                  EndIf
                Case #PB_EventType_RightDoubleClick
                  ;
                Case  #PB_EventType_Change
                  ;                  
              EndSelect
          EndSelect
        Case  #PB_Event_Menu
          Select EventMenu()
            Case  3
              quit  = #True
          EndSelect 
        Case  #PB_Event_CloseWindow
          quit  = #True
      EndSelect
    Until quit  = #True
            
    CloseWindow(hwnd) 
    FreeList(pnplist())
    
  EndProcedure
  
  ProcedureDLL.l  UART_controlpanel(card_res)
    ;串口参数设置窗口
    
   
    MessageBox_(GetFocus_(), "UART_controlpanel not completed", "cv", #MB_SYSTEMMODAL|#MB_ICONINFORMATION)
    ProcedureReturn #True
    
  EndProcedure
  
  ProcedureDLL.l  select_visa_bus(*resource, mask.l = $ffffffff)
    ;窗体支持选择GPIB/PXI/Serial/TCPIP/USB然后再调用不同的窗体，回写不同的资源名称
    
    bus_icon  = 0
    ExtractIconEx_("cv_icons.dll", 26, #Null, @bus_icon, 1)
    max_icon  = 0
    dev_icon  = 0    
    ExtractIconEx_("cv_icons.dll", 148, #Null, @max_icon, 1)
    ExtractIconEx_("cv_icons.dll", 149, #Null, @dev_icon, 1)   
    cccc_icon = 0
    ExtractIconEx_("cv_icons.dll", 38, #Null, @cccc_icon, 1)    
    
    netshell_icon = 0
    ExtractIconEx_("cv_icons.dll", 150, #Null, @netshell_icon, 1)
        
    Protected hwnd = OpenWindow(#PB_Any, 0, 0, 440, 190, "select_visa_bus", #PB_Window_SystemMenu | #PB_Window_MinimizeGadget | #PB_Window_ScreenCentered)
    SetWindowPos_(WindowID(hwnd), #HWND_TOP, 0, 0, 0, 0, #SWP_NOMOVE|#SWP_NOSIZE)
    SendMessage_(WindowID(hwnd), #WM_SETICON, #ICON_SMALL, bus_icon)
       If OSVersion < #PB_OS_Windows_7
     ;
   Else
     SkinH_SetAero(WindowID(hwnd))
   EndIf
    
    Protected toolbar_t = CreateToolBar(#PB_Any, WindowID(hwnd))
    If  toolbar_t
      ToolBarImageButton(11, max_icon)
      ToolBarToolTip(toolbar_t, 11, "Measurement & Automation Explorer")
      ToolBarImageButton(12, dev_icon)
      ToolBarToolTip(toolbar_t, 12, "设置管理器")
      ToolBarImageButton(13, netshell_icon)
      ToolBarToolTip(toolbar_t, 13, "网络连接")
      ToolBarSeparator()
      ToolBarImageButton(5,cccc_icon)
      ToolBarToolTip(toolbar_t, 5, "关于")
    EndIf    
    
    visa_dev = OptionGadget(#PB_Any, 10, 10 + ToolBarHeight(toolbar_t), 200, 20, "select_visa_device")
    visa_dev_instr = OptionGadget(#PB_Any, 220, 10 + ToolBarHeight(toolbar_t), 210, 20, "select_visa_device(INSTR)")
    visa_gpib = OptionGadget(#PB_Any, 10, 40 + ToolBarHeight(toolbar_t), 200, 20, "select_visa_gpib_device")
    visa_rs232 = OptionGadget(#PB_Any, 220, 40 + ToolBarHeight(toolbar_t), 210, 20, "select_visa_serialport")
    visa_pxi_pci = OptionGadget(#PB_Any, 10, 70 + ToolBarHeight(toolbar_t), 200, 20, "select_visa_pci_pxi_card")
    visa_pxi_pci_model = OptionGadget(#PB_Any, 220, 70 + ToolBarHeight(toolbar_t), 210, 20, "select_visa_pci_pxi_card(model)")
    visa_usb = OptionGadget(#PB_Any, 10, 100 + ToolBarHeight(toolbar_t), 200, 20, "select_visa_usb_device")
    visa_usb_model = OptionGadget(#PB_Any, 220, 100 + ToolBarHeight(toolbar_t), 210, 20, "select_visa_usb_device(model)")
    visa_lxi = OptionGadget(#PB_Any, 10, 130 + ToolBarHeight(toolbar_t), 200, 20, "input_visa_LXI")
    
    GadgetToolTip(visa_dev, "显示所有VISA32支持的资源")
    GadgetToolTip(visa_dev_instr, "显示所有VISA32的INSTR型的资源")
    GadgetToolTip(visa_gpib, "显示所有已驱动的VISA32的GPIB资源")
    GadgetToolTip(visa_rs232, "显示所有的串口VISA32资源")
    GadgetToolTip(visa_pxi_pci, "显示所有的已驱动的VISA32的PCI资源")
    GadgetToolTip(visa_pxi_pci_model, "显示指定型号的VISA32的PCI资源")
    GadgetToolTip(visa_usb, "显示所有的已驱动的VISA32的USB资源")
    GadgetToolTip(visa_usb_model, "显示指定型号的VISA32的USB资源")
    GadgetToolTip(visa_lxi, "增加LXI资源")    
    
    If  BitTst(mask, 0)
      DisableGadget(visa_dev, #False)
    Else
      DisableGadget(visa_dev, #True)
    EndIf
    
    If  BitTst(mask, 1)
      DisableGadget(visa_dev_instr, #False)
    Else
      DisableGadget(visa_dev_instr, #True)
    EndIf
    
    If  BitTst(mask, 2)
      DisableGadget(visa_gpib, #False)
    Else
      DisableGadget(visa_gpib, #True)
    EndIf
    
    If  BitTst(mask, 3)
      DisableGadget(visa_rs232, #False)
    Else
      DisableGadget(visa_rs232, #True)
    EndIf
    
    If  BitTst(mask, 4)
      DisableGadget(visa_pxi_pci, #False)
    Else
      DisableGadget(visa_pxi_pci, #True)
    EndIf
    
    If  BitTst(mask, 5)
      DisableGadget(visa_pxi_pci_model, #False)
    Else
      DisableGadget(visa_pxi_pci_model, #True)
    EndIf
    
    If  BitTst(mask, 6)
      DisableGadget(visa_usb, #False)
    Else
      DisableGadget(visa_usb, #True)
    EndIf
    
    If  BitTst(mask, 7)
      DisableGadget(visa_usb_model, #False)
    Else
      DisableGadget(visa_usb_model, #True)
    EndIf
    
    If  BitTst(mask, 8)
      DisableGadget(visa_lxi, #False)
    Else
      DisableGadget(visa_lxi, #True)
    EndIf   
    
    AddKeyboardShortcut(hwnd, #PB_Shortcut_Escape, 0)
    
    vid.w = 0
    did.w = 0
    
    Repeat
      Event.l = WaitWindowEvent()
      Select  Event
        Case  #PB_Event_Gadget
          Select  EventGadget()
            Case  visa_dev
              DisableWindow(hwnd, #True)
              result  = select_visa_device(*resource, 1)  ;所有类型
              DisableWindow(hwnd, #False)
              SetActiveWindow(hwnd)
              If  result
                quit  = #True
              Else
                ;
              EndIf
            Case  visa_dev_instr
              DisableWindow(hwnd, #True)
              result  = select_visa_device(*resource) ;instr only
              DisableWindow(hwnd, #False)
              SetActiveWindow(hwnd)
              If  result
                quit  = #True
              Else
                ;
              EndIf              
            Case  visa_gpib
              DisableWindow(hwnd, #True)
              result  = select_visa_gpib_device(*resource)
              DisableWindow(hwnd, #False)
              SetActiveWindow(hwnd)
              If  result
                quit  = #True
              Else
                ;
              EndIf    
            Case  visa_rs232
              DisableWindow(hwnd, #True)
              result  = select_visa_serialport(*resource)
              DisableWindow(hwnd, #False)
              SetActiveWindow(hwnd)
              If  result
                quit  = #True
              Else
                ;
              EndIf    
            Case  visa_pxi_pci
              DisableWindow(hwnd, #True)
              result  = select_visa_pci_pxi_card(*resource)
              DisableWindow(hwnd, #False)
              SetActiveWindow(hwnd)
              If  result
                quit  = #True
              Else
                ;
              EndIf 
            Case  visa_pxi_pci_model
              DisableWindow(hwnd, #True)
              hex_input(@vid, 16)
              hex_input(@did, 16)
              result  = select_visa_pci_pxi_card(*resource, vid, did)
              DisableWindow(hwnd, #False)
              SetActiveWindow(hwnd)
              If  result
                quit  = #True
              Else
                ;
              EndIf
            Case  visa_usb
              DisableWindow(hwnd, #True)
              result  = select_visa_usb_device(*resource)
              DisableWindow(hwnd, #False)
              SetActiveWindow(hwnd)
              If  result
                quit  = #True
              Else
                ;
              EndIf
            Case  visa_usb_model
              DisableWindow(hwnd, #True)
              hex_input(@vid, 16)
              hex_input(@did, 16)
              result  = select_visa_usb_device(*resource, vid, did)
              DisableWindow(hwnd, #False)
              SetActiveWindow(hwnd)
              If  result
                quit  = #True
              Else
                ;
              EndIf
            Case  visa_lxi
              DisableWindow(hwnd, #True)
              result  = select_visa_lxi_device(*resource)
              DisableWindow(hwnd, #False)
              SetActiveWindow(hwnd)
              If  result
                quit  = #True
              Else
                ;
              EndIf              
          EndSelect
        Case  #PB_Event_Menu
          Select EventMenu()
            Case  13    ;netshell
              RunProgram("ncpa.cpl")
            Case  12    ;设备管理器
              RunProgram("devmgmt.msc")
            Case  11  ;Measurement & Automation Explorer
              max.s = ReadRegKey(#HKEY_LOCAL_MACHINE, "SOFTWARE\National Instruments\Measurement & Automation Explorer", "CurrentPath")
              If "Error Opening Key" = max
                MessageBox_(GetFocus_(), "no NI-MAX founded!", "cv", #MB_OK|#MB_SYSTEMMODAL|#MB_ICONERROR)
              Else
                max  = max + "NIMax.exe"
                RunProgram(max)
              EndIf              
            Case  5    ;about
              CreateThread(@about_cv(), #Null)
            Case  0
              CloseWindow(hwnd)
              ProcedureReturn #False              
          EndSelect 
        Case  #PB_Event_CloseWindow
          CloseWindow(hwnd)
          ProcedureReturn #False
      EndSelect
    Until quit  = #True   
    
    CloseWindow(hwnd)
    ProcedureReturn #True
    
  EndProcedure
  
  ProcedureDLL.l  visa_interactive_io(card_res)
    
    ;功能上类似agilent io的一个小工具
    
    io_icon  = 0
    ExtractIconEx_("cv_icons.dll", 140, #Null, @io_icon, 1)
    
    cccc_icon = 0
    ExtractIconEx_("cv_icons.dll", 38, #Null, @cccc_icon, 1)    
    
    Protected hwnd = OpenWindow(#PB_Any, 0, 0, 560, 240, "visa_interactive_io", #PB_Window_SystemMenu | #PB_Window_MinimizeGadget | #PB_Window_ScreenCentered)
    SetWindowPos_(WindowID(hwnd), #HWND_TOP, 0, 0, 0, 0, #SWP_NOMOVE|#SWP_NOSIZE)
    SendMessage_(WindowID(hwnd), #WM_SETICON, #ICON_SMALL, io_icon)
       If OSVersion < #PB_OS_Windows_7
     ;
   Else
     SkinH_SetAero(WindowID(hwnd))
   EndIf
    resource_name.s = Space(4096)
    viGetAttribute(card_res, #VI_ATTR_RSRC_NAME, @resource_name) 
    SetWindowTitle(hwnd, GetWindowTitle(hwnd) + " - " + resource_name)
    
    Protected toolbar_t  = CreateToolBar(#PB_Any, WindowID(hwnd))
    If  toolbar_t
      ToolBarImageButton(8,io_icon)
      ToolBarImageButton(1,io_icon)
      ToolBarImageButton(2,io_icon)
      ToolBarImageButton(9,io_icon)
      ToolBarImageButton(4,io_icon)
      ToolBarSeparator()
      ToolBarImageButton(5,cccc_icon)   ;about this
    EndIf
    
    ToolBarToolTip(toolbar_t, 8, "aaaa")
    ToolBarToolTip(toolbar_t, 1, "bbbb")
    ToolBarToolTip(toolbar_t, 2, "cccc")
    ToolBarToolTip(toolbar_t, 9, "dddd")
    ToolBarToolTip(toolbar_t, 4, "eeee")
    ToolBarToolTip(toolbar_t, 5, "关于本程序")
    
    statusbar_t = CreateStatusBar(#PB_Any, WindowID(hwnd))
    If  statusbar_t
      AddStatusBarField(300)
      StatusBarText(statusbar_t, 0, resource_name)
      AddStatusBarField(200)
      StatusBarText(statusbar_t, 1, "copyright")
      AddStatusBarField(60)
      StatusBarText(statusbar_t, 2, "2013 cv")
    EndIf
    
    text0_tg = TextGadget(#PB_Any, 10, ToolBarHeight(toolbar_t) + 14, 70, 20, "Command:")
    send_bg = ButtonGadget(#PB_Any, 20, ToolBarHeight(toolbar_t) + 40, 100, 25, "Send Command")
    read_bg = ButtonGadget(#PB_Any, 140, ToolBarHeight(toolbar_t) + 40, 100, 25, "Read Response")
    send_and_read_bg = ButtonGadget(#PB_Any, 260, ToolBarHeight(toolbar_t) + 40, 100, 25, "Send & Read")
    history_cbg = ComboBoxGadget(#PB_Any, 390, ToolBarHeight(toolbar_t) + 10, 160, 20)
    AddGadgetItem(history_cbg, -1, "*RST")
    AddGadgetItem(history_cbg, -1, "*IDN?")
    AddGadgetItem(history_cbg, -1, "SYST:HELP?")
    AddGadgetItem(history_cbg, -1, "MEAS:VOLT:DC?")
    AddGadgetItem(history_cbg, -1, "MEAS:CURR:DC?")
    AddGadgetItem(history_cbg, -1, "MEAS:RES?")
    SetGadgetState(history_cbg, 0)
    
    command_sg = StringGadget(#PB_Any, 80, ToolBarHeight(toolbar_t) + 10, 300, 20, "")
    response_sg = StringGadget(#PB_Any, 10, ToolBarHeight(toolbar_t) + 100, 540, 80, "", #PB_String_ReadOnly)
    text1_tg = TextGadget(#PB_Any, 10, ToolBarHeight(toolbar_t) + 80, 200, 20, "Instrument Response:")    
    
    AddKeyboardShortcut(hwnd, #PB_Shortcut_Escape, 0)
    AddKeyboardShortcut(hwnd, #PB_Shortcut_F1, 5)
    
    Repeat
      Event.l = WaitWindowEvent()
      Select  Event
        Case  #PB_Event_Gadget
          Select  EventGadget()
            Case  send_bg
              ;
            Case  read_bg
              ;
            Case  send_and_read_bg
              ;
            Case  history_cbg
              SetGadgetText(command_sg, GetGadgetText(history_cbg))
          EndSelect
        Case  #PB_Event_Menu
          Select EventMenu()
            Case  5 ;about
              CreateThread(@about_cv(), #Null)
            Case  0 ;ESC
              CloseWindow(hwnd)
              ProcedureReturn #False              
          EndSelect 
        Case  #PB_Event_CloseWindow
          CloseWindow(hwnd)
          ProcedureReturn #False
      EndSelect
    Until quit  = #True
               
    CloseWindow(hwnd)
    ProcedureReturn #True       
    
  EndProcedure
  
  ProcedureDLL.l  visa_remote_system_editor()
    
    cccc_icon = 0
    ExtractIconEx_("cv_icons.dll", 38, #Null, @cccc_icon, 1)
    read_icon = 0
    write_icon  = 0
    check_icon  = 0
    add_icon  = 0
    remove_icon = 0
    remote_system_icon  = 0
    open_ini_icon = 0
    ExtractIconEx_("cv_icons.dll", 142, #Null, @read_icon, 1)
    ExtractIconEx_("cv_icons.dll", 143, #Null, @write_icon, 1)
    ExtractIconEx_("cv_icons.dll", 146, #Null, @check_icon, 1)
    ExtractIconEx_("cv_icons.dll", 144, #Null, @add_icon, 1)
    ExtractIconEx_("cv_icons.dll", 145, #Null, @remove_icon, 1)
    ExtractIconEx_("cv_icons.dll", 157, #Null, @remote_system_icon, 1)
    ExtractIconEx_("cv_icons.dll", 69, #Null, @open_ini_icon, 1)
    
    max_icon  = 0
    ExtractIconEx_("cv_icons.dll", 148, #Null, @max_icon, 1)
    netshell_icon = 0
    ExtractIconEx_("cv_icons.dll", 150, #Null, @netshell_icon, 1)    
    
    Define  ini_file.s{1024}  = ""
    Define  rsrc_name.s{1024} = ""
    Define  new_ip.s{1024} = ""
    Define  ip_address.s{1024}  = ""
    Define  item_num.l  = 0
    Define  ip_num.l  = 0
    Define  ip_num2.l = 0    
    
    result  = visa_check_setup()
    
    If  result
      ;
    Else
      ProcedureReturn #False
    EndIf
    
    ini_file  = ReadRegKey(#HKEY_LOCAL_MACHINE, "SOFTWARE\National Instruments\NI-VISA for Windows 95/NT", "InstDir")
    ini_file  = ini_file  + "WinNT\NIvisa\visaconf.ini"
        
    Protected hwnd = OpenWindow(#PB_Any, 0, 0, 450, 300, "visa_remote_system_editor", #PB_Window_MaximizeGadget|#PB_Window_SystemMenu | #PB_Window_MinimizeGadget | #PB_Window_ScreenCentered)
    SetWindowPos_(WindowID(hwnd), #HWND_TOP, 0, 0, 0, 0, #SWP_NOMOVE|#SWP_NOSIZE)
    SendMessage_(WindowID(hwnd), #WM_SETICON, #ICON_SMALL, remote_system_icon)
       If OSVersion < #PB_OS_Windows_7
     ;
   Else
     SkinH_SetAero(WindowID(hwnd))
   EndIf
    SetWindowTitle(hwnd, GetWindowTitle(hwnd) + " - " + ini_file)
        
    Protected toolbar_t = CreateToolBar(#PB_Any, WindowID(hwnd))
    If  toolbar_t
      ToolBarImageButton(8,read_icon)
      ToolBarToolTip(toolbar_t, 8, "读取ini")
      ToolBarImageButton(1,write_icon)
      ToolBarToolTip(toolbar_t, 1, "回写ini")
      ToolBarImageButton(2,check_icon)
      ToolBarToolTip(toolbar_t, 2, "CHECK ALL 远程系统有效性")
      ToolBarSeparator()
      ToolBarImageButton(9,add_icon)
      ToolBarToolTip(toolbar_t, 9, "添加远程系统")
      ToolBarImageButton(4,remove_icon)
      ToolBarToolTip(toolbar_t, 4, "删除远程系统")
      ToolBarSeparator()
      ToolBarImageButton(10, open_ini_icon)
      ToolBarToolTip(toolbar_t, 10, "open: " + ini_file)
      ToolBarImageButton(11, max_icon)
      ToolBarToolTip(toolbar_t, 11, "Measurement & Automation Explorer")
      ToolBarImageButton(13, netshell_icon)
      ToolBarToolTip(toolbar_t, 13, "网络连接")
      ToolBarSeparator()
      ToolBarImageButton(5,cccc_icon)
      ToolBarToolTip(toolbar_t, 5, "关于")
    EndIf

    ini_lig = ListIconGadget(#PB_Any, 0, ToolBarHeight(toolbar_t) + 0, 450, 270, "远程系统", WindowWidth(hwnd)  - 10, #PB_ListIcon_CheckBoxes|#PB_ListIcon_GridLines|#PB_ListIcon_FullRowSelect|#PB_ListIcon_AlwaysShowSelection)
    
    remote_system_num.l = Val(Pref_ReadString("REMOTE-CONFIG", "NumServers", ini_file))
    
    For i=0 To remote_system_num - 1
      single_line.s = Pref_ReadString("REMOTE-CONFIG", "Server" + Str(i), ini_file)
      AddGadgetItem(ini_lig, i, single_line)
      If  "1" = Pref_ReadString("REMOTE-CONFIG", "ServerEnabled" + Str(i), ini_file)
        SetGadgetItemState(ini_lig, i, #PB_ListIcon_Checked)
      Else
        SetGadgetItemState(ini_lig, i, 0)
      EndIf      
    Next  i
    
    item_num  = CountGadgetItems(ini_lig)
    For i=0 To  item_num  - 1
      ip_address  = GetGadgetItemText(ini_lig, i, 0)
      ip_num2 = MakeIPAddress_from_string(@ip_address)                
      If  TestInetConnection(ip_num2)
        ;
      Else
        SetGadgetItemColor(ini_lig,  i, #PB_Gadget_BackColor, $00FFFF, -1)
      EndIf
    Next  i    
    
    AddKeyboardShortcut(hwnd, #PB_Shortcut_Escape, 0)
    AddKeyboardShortcut(hwnd, #PB_Shortcut_Delete, 4)
    AddKeyboardShortcut(hwnd, #PB_Shortcut_F5, 2)
    
    PureRESIZE_SetGadgetResize(ini_lig, 1, 1, 1, 1)
    PureRESIZE_SetWindowMinimumSize(hwnd, 450, 300)    
        
    Repeat
      Event.l = WaitWindowEvent()
      Select  Event
        Case  #PB_Event_Gadget
          Select  EventGadget()
            Case  ini_lig
              Select EventType()
                Case #PB_EventType_LeftDoubleClick
                  DisableWindow(hwnd, #True)
                  pos.l = GetGadgetState(EventGadget())
                  new_ip = GetGadgetItemText(ini_lig, pos, 0)
                  result2 = string_input(@new_ip)
                  If  result2
                    SetGadgetItemText(ini_lig, pos, new_ip, 0)
                  EndIf
                  DisableWindow(hwnd, #False)
                  SetActiveWindow(hwnd)                   
              EndSelect
            Case  ok_bg
              quit  = #True
          EndSelect
        Case  #PB_Event_Menu
          Select EventMenu()
            Case  13    ;网络连接
              RunProgram("ncpa.cpl")
            Case  11  ;Measurement & Automation Explorer
              max.s = ReadRegKey(#HKEY_LOCAL_MACHINE, "SOFTWARE\National Instruments\Measurement & Automation Explorer", "CurrentPath")
              If "Error Opening Key" = max
                MessageBox_(GetFocus_(), "no NI-MAX founded!", "cv", #MB_OK|#MB_SYSTEMMODAL|#MB_ICONERROR)
              Else
                max  = max + "NIMax.exe"
                RunProgram(max)
              EndIf
            Case  10  ; open file
              RunProgram("notepad.exe", ini_file, GetCurrentDirectory())
            Case  8 ;read
              ClearGadgetItems(ini_lig)
              remote_system_num = Val(Pref_ReadString("REMOTE-CONFIG", "NumServers", ini_file))
              
              For i=0 To remote_system_num - 1
                single_line = Pref_ReadString("REMOTE-CONFIG", "Server" + Str(i), ini_file)
                AddGadgetItem(ini_lig, i, single_line)
                If "1" = Pref_ReadString("REMOTE-CONFIG", "ServerEnabled" + Str(i), ini_file)
                  SetGadgetItemState(ini_lig, i, #PB_ListIcon_Checked)
                Else
                  SetGadgetItemState(ini_lig, i, 0)
                EndIf
              Next  i
              
              MessageBox_(GetFocus_(), "read ok!", "-=cv=- 2013.2", #MB_OK|#MB_ICONINFORMATION)
            Case  1 ;rewrite
              item_num  = CountGadgetItems(ini_lig)
              Pref_WriteString("REMOTE-CONFIG", "NumServers", Str(item_num), ini_file)
              For i=0 To  item_num  - 1
                Pref_WriteString("REMOTE-CONFIG", "Server" + Str(i), Chr(34) + GetGadgetItemText(ini_lig, i, 0) + Chr(34), ini_file)
                If  GetGadgetItemState(ini_lig, i)
                  Pref_WriteString("REMOTE-CONFIG", "ServerEnabled" + Str(i), "1", ini_file)
                Else
                  Pref_WriteString("REMOTE-CONFIG", "ServerEnabled" + Str(i), "0", ini_file)
                EndIf
              Next  i
              MessageBox_(GetFocus_(), "rewrite ok!", "-=cv=- 2013.2", #MB_OK|#MB_ICONINFORMATION)
            Case  2 ;check all ip use ping
              item_num  = CountGadgetItems(ini_lig)
              For i=0 To  item_num  - 1
                ip_address  = GetGadgetItemText(ini_lig, i, 0)
                ip_num2 = MakeIPAddress_from_string(@ip_address)                
                If  TestInetConnection(ip_num2)
                  ;
                Else
                  SetGadgetItemColor(ini_lig,  i, #PB_Gadget_BackColor, $00FFFF, -1)
                EndIf
              Next  i
              MessageBox_(GetFocus_(), "check all alias ok!", "-=cv=- 2013.2", #MB_OK|#MB_ICONINFORMATION)
            Case  9 ;add ip
              DisableWindow(hwnd, #True)
              result  = get_visa_server_ip(@ip_num)
              ip_address =  IPString(ip_num)
              If  result
                AddGadgetItem(ini_lig, -1, ip_address)
              EndIf
              DisableWindow(hwnd, #False)
              SetActiveWindow(hwnd)          
            Case  4 ;delete ip
              RemoveGadgetItem(ini_lig, GetGadgetState(ini_lig))
            Case  5 ;about
              CreateThread(@about_cv(), #Null)
            Case  0 ;ESC
              CloseWindow(hwnd)
              ProcedureReturn #False              
          EndSelect 
        Case  #PB_Event_CloseWindow
          CloseWindow(hwnd)
          ProcedureReturn #False
      EndSelect
    Until quit  = #True
                
    CloseWindow(hwnd)
    ProcedureReturn #True       
  EndProcedure
  
  ProcedureDLL.l  visa_alias_editor()
    ;c:\VXIPNP\WinNT\NIvisa\visaconf.ini
    ;     [ALIASES]
    ;     Alias0 = "'vvv','ASRL10::INSTR'"
    ;     Alias1 = "'bbbb','ASRL3::INSTR'"
    ;     Alias2 = "'dddd','ASRL4::INSTR'"
    ;     Alias3 = "'dddewww','PXI0::MEMACC'"
    ;     Alias4 = "'aaa','GPIB0::INTFC'"
    ;     Alias5 = "'COM1','ASRL1::INSTR'"
    ;     Alias6 = "'COM2','ASRL2::INSTR'"
    ;     Alias7 = "'COM5','ASRL5::INSTR'"
    ;     NumAliases = 8    
    ;功能上类似ni-visa修改alias的一个小工具
    
    cccc_icon = 0
    ExtractIconEx_("cv_icons.dll", 38, #Null, @cccc_icon, 1)
    read_icon = 0
    write_icon  = 0
    check_icon  = 0
    add_icon  = 0
    remove_icon = 0
    alias_icon  = 0
    open_ini_icon = 0
    ExtractIconEx_("cv_icons.dll", 142, #Null, @read_icon, 1)
    ExtractIconEx_("cv_icons.dll", 143, #Null, @write_icon, 1)
    ExtractIconEx_("cv_icons.dll", 146, #Null, @check_icon, 1)
    ExtractIconEx_("cv_icons.dll", 144, #Null, @add_icon, 1)
    ExtractIconEx_("cv_icons.dll", 145, #Null, @remove_icon, 1)
    ExtractIconEx_("cv_icons.dll", 147, #Null, @alias_icon, 1)
    ExtractIconEx_("cv_icons.dll", 69, #Null, @open_ini_icon, 1)
    
    max_icon  = 0
    dev_icon  = 0    
    ExtractIconEx_("cv_icons.dll", 148, #Null, @max_icon, 1)
    ExtractIconEx_("cv_icons.dll", 149, #Null, @dev_icon, 1)
    
    Define  ini_file.s{1024}  = ""
    Define  rsrc_name.s{1024} = ""
    Define  new_alias.s{1024} = ""
    Define  card.s{1024}  = ""
    Define  card_res.l = 0
    Define  item_num.l  = 0    
    
    result  = visa_check_setup()
    
    If  result
      ;
    Else
      ProcedureReturn #False
    EndIf
    
    ini_file  = ReadRegKey(#HKEY_LOCAL_MACHINE, "SOFTWARE\National Instruments\NI-VISA for Windows 95/NT", "InstDir")
    ini_file  = ini_file  + "WinNT\NIvisa\visaconf.ini"
        
    Protected hwnd = OpenWindow(#PB_Any, 0, 0, 450, 300, "visa_alias_editor", #PB_Window_MaximizeGadget|#PB_Window_SystemMenu|#PB_Window_MinimizeGadget|#PB_Window_ScreenCentered)
    SetWindowPos_(WindowID(hwnd), #HWND_TOP, 0, 0, 0, 0, #SWP_NOMOVE|#SWP_NOSIZE)
    SendMessage_(WindowID(hwnd), #WM_SETICON, #ICON_SMALL, alias_icon)
       If OSVersion < #PB_OS_Windows_7
     ;
   Else
     SkinH_SetAero(WindowID(hwnd))
   EndIf
    SetWindowTitle(hwnd, GetWindowTitle(hwnd) + " - " + ini_file)
    
    Protected visa_default.q  = 0
    viOpenDefaultRM(@visa_default)    
    
    Protected toolbar_t = CreateToolBar(#PB_Any, WindowID(hwnd))
    If  toolbar_t
      ToolBarImageButton(8,read_icon)
      ToolBarToolTip(toolbar_t, 8, "读取ini")
      ToolBarImageButton(1,write_icon)
      ToolBarToolTip(toolbar_t, 1, "回写ini")
      ToolBarImageButton(2,check_icon)
      ToolBarToolTip(toolbar_t, 2, "CHECK ALL ALIAS有效性")
      ToolBarSeparator()
      ToolBarImageButton(9,add_icon)
      ToolBarToolTip(toolbar_t, 9, "添加RSRC ALIAS")
      ToolBarImageButton(4,remove_icon)
      ToolBarToolTip(toolbar_t, 4, "删除RSRC ALIAS")
      ToolBarSeparator()
      ToolBarImageButton(10, open_ini_icon)
      ToolBarToolTip(toolbar_t, 10, "open: " + ini_file)
      ToolBarImageButton(11, max_icon)
      ToolBarToolTip(toolbar_t, 11, "Measurement & Automation Explorer")
      ToolBarImageButton(12, dev_icon)
      ToolBarToolTip(toolbar_t, 12, "设置管理器")
      ToolBarSeparator()
      ToolBarImageButton(5,cccc_icon)
      ToolBarToolTip(toolbar_t, 5, "关于")
    EndIf

    ini_lig = ListIconGadget(#PB_Any, 0, ToolBarHeight(toolbar_t) + 0, 450, 270, "RSRC", 215, #PB_ListIcon_GridLines | #PB_ListIcon_FullRowSelect | #PB_ListIcon_AlwaysShowSelection)
    AddGadgetColumn(ini_lig, 1, "ALIAS", 225)
    
    ali_num.l = Val(Pref_ReadString("ALIASES", "NumAliases", ini_file))
    
    For i=0 To ali_num - 1
      single_line.s = Pref_ReadString("ALIASES", "Alias" + Str(i), ini_file)
      rsrc_part.s = RemoveString(StringField(single_line, 2, ","), "'")
      alias_part.s  = RemoveString(StringField(single_line, 1, ","), "'")
      AddGadgetItem(ini_lig, -1, rsrc_part + Chr(10) + alias_part)
    Next  i
    
    item_num  = CountGadgetItems(ini_lig)
    For i=0 To  item_num  - 1
      card  = GetGadgetItemText(ini_lig, i, 1)
      result  = viOpen(visa_default, @card, #VI_NO_LOCK, 1000, @card_res)
              
      If result <> #VI_SUCCESS
        SetGadgetItemColor(ini_lig,  i, #PB_Gadget_BackColor, $00FFFF, -1)
      Else
        viClose(card_res)
      EndIf
    Next  i    
    
    AddKeyboardShortcut(hwnd, #PB_Shortcut_Escape, 0)
    AddKeyboardShortcut(hwnd, #PB_Shortcut_Delete, 4)
    AddKeyboardShortcut(hwnd, #PB_Shortcut_F5, 2)
    
    PureRESIZE_SetGadgetResize(ini_lig, 1, 1, 1, 1)
    PureRESIZE_SetWindowMinimumSize(hwnd, 450, 300)    
    
    Repeat
      Event.l = WaitWindowEvent()
      Select  Event
        Case  #PB_Event_Gadget
          Select  EventGadget()
            Case  ini_lig
              Select EventType()
                Case #PB_EventType_LeftDoubleClick
                  DisableWindow(hwnd, #True)
                  pos.l = GetGadgetState(EventGadget())
                  new_alias = GetGadgetItemText(ini_lig, pos, 1)
                  result2 = string_input(@new_alias)
                  If  result2
                    SetGadgetItemText(ini_lig, pos, new_alias, 1)
                  EndIf
                  DisableWindow(hwnd, #False)
                  SetActiveWindow(hwnd)                   
              EndSelect
            Case  ok_bg
              quit  = #True
          EndSelect
        Case  #PB_Event_Menu
          Select EventMenu()
            Case  12    ;设备管理器
              RunProgram("devmgmt.msc")
            Case  11  ;Measurement & Automation Explorer
              max.s = ReadRegKey(#HKEY_LOCAL_MACHINE, "SOFTWARE\National Instruments\Measurement & Automation Explorer", "CurrentPath")
              If "Error Opening Key" = max
                MessageBox_(GetFocus_(), "no NI-MAX founded!", "cv", #MB_OK|#MB_SYSTEMMODAL|#MB_ICONERROR)
              Else
                max  = max + "NIMax.exe"
                RunProgram(max)
              EndIf
            Case  10  ; open file
              RunProgram("notepad.exe", ini_file, GetCurrentDirectory())
            Case  8 ;read
              ClearGadgetItems(ini_lig)
              ali_num = Val(Pref_ReadString("ALIASES", "NumAliases", ini_file))
              For i=0 To ali_num - 1
                single_line = Pref_ReadString("ALIASES", "Alias" + Str(i), ini_file)
                rsrc_part = RemoveString(StringField(single_line, 2, ","), "'")
                alias_part  = RemoveString(StringField(single_line, 1, ","), "'")
                AddGadgetItem(ini_lig, -1, rsrc_part + Chr(10) + alias_part)
              Next  i
              MessageBox_(GetFocus_(), "read ok!", "-=cv=- 2013.2", #MB_OK|#MB_ICONINFORMATION)
            Case  1 ;rewrite
              item_num  = CountGadgetItems(ini_lig)
              Pref_WriteString("ALIASES", "NumAliases", Str(item_num), ini_file)
              For i=0 To  item_num  - 1
                Pref_WriteString("ALIASES", "Alias" + Str(i), Chr(34) + "'" + GetGadgetItemText(ini_lig, i, 1) + "','" + GetGadgetItemText(ini_lig, i, 0) + "'" + Chr(34), ini_file)
              Next  i
              MessageBox_(GetFocus_(), "rewrite ok!", "-=cv=- 2013.2", #MB_OK|#MB_ICONINFORMATION)
            Case  2 ;check all alias
              item_num  = CountGadgetItems(ini_lig)
              For i=0 To  item_num  - 1
                card  = GetGadgetItemText(ini_lig, i, 1)
                result  = viOpen(visa_default, @card, #VI_NO_LOCK, 1000, @card_res)
              
                If result <> #VI_SUCCESS
                  SetGadgetItemColor(ini_lig,  i, #PB_Gadget_BackColor, $00FFFF, -1)
                Else
                  viClose(card_res)
                EndIf
              Next  i
              MessageBox_(GetFocus_(), "check all alias ok!", "-=cv=- 2013.2", #MB_OK|#MB_ICONINFORMATION)
            Case  9 ;add rsrc alias
              DisableWindow(hwnd, #True)
              result1 = select_visa_bus(@rsrc_name)
              If  result1
                result2 = string_input(@new_alias)
                If  result2
                  AddGadgetItem(ini_lig, -1, rsrc_name + Chr(10) + new_alias)
                EndIf
              EndIf
              DisableWindow(hwnd, #False)
              SetActiveWindow(hwnd)              
            Case  4 ;delete rsrc alias
              RemoveGadgetItem(ini_lig, GetGadgetState(ini_lig))
            Case  5 ;about
              CreateThread(@about_cv(), #Null)
            Case  0 ;ESC
              CloseWindow(hwnd)
              viClose(visa_default)
              ProcedureReturn #False              
          EndSelect 
        Case  #PB_Event_CloseWindow
          CloseWindow(hwnd)
          viClose(visa_default)
          ProcedureReturn #False
      EndSelect
    Until quit  = #True
                
    CloseWindow(hwnd)
    viClose(visa_default)
    ProcedureReturn #True    
    
  EndProcedure
  
  ProcedureDLL.l check_reg_sn()   ;读注册表内的注册信息
    result.l  = 0
    reg_sn.s{255} = ReadRegKey(#HKEY_LOCAL_MACHINE, "Software\cv\visa32_pb_wrapper", "serial")
    user.s{255} = ReadRegKey(#HKEY_LOCAL_MACHINE, "Software\cv\visa32_pb_wrapper", "user")
    
    disk_hdll.i = GetDiskSerial_LoadDLL()    
    hdid.s  = PeekS(GetSerialNumber(0))
    MemoryFreeLibrary(disk_hdll)
    
    cpuid_hdll.i  = CPUID_Util_LoadDLL()
    cpuid_p = AllocateMemory(1024)
    GetCPUID(cpuid_p)
    cpuid.s = PeekS(cpuid_p)
    FreeMemory(cpuid_p)
    MemoryFreeLibrary(cpuid_hdll)
    
    generate_sn.s = user  + hdid  + cpuid
    generate_sn = ReverseString(generate_sn)
    generate_sn = UCase(generate_sn)
    generate_sn = MD5Fingerprint(@generate_sn, StringByteLength(generate_sn))
    generate_sn = UCase(Right(generate_sn, 16))
    ;OutputDebugString_(generate_sn)
    
    If  generate_sn = reg_sn
      result  = 1
    Else
      result  = 0
    EndIf
    
    ProcedureReturn result
  EndProcedure
  
  ProcedureDLL  select_lib_skin()
    ;
    WSysName.s = Space(255)
    GetSystemDirectory_(WSysName, @Null)
    WSysName  = WSysName  + "\"      
    StandardFile.s = "skinh.she"
    Pattern.s = "she (*.she)|*.she|All files (*.*)|*.*"
    she_file_path.s = OpenFileRequester("Please choose skin file to load", StandardFile, Pattern, 0)
    
    file1_name.s  = WSysName + "skinh.she"
    
    If she_file_path
      DeleteFile(file1_name)
      CopyFile(she_file_path, file1_name)
      SkinH_AttachEx(@file1_name, @Null)
      MessageBox_(GetFocus_(), "skin set ok!", "-=cv=- 2013.1", #MB_OK|#MB_ICONINFORMATION)
    Else
      result  = MessageBox_(GetFocus_(), "no skin file selected! use native skin?", "-=cv=- 2013.1", #MB_DEFBUTTON2|#MB_YESNO|#MB_ICONQUESTION|#MB_SYSTEMMODAL)
      Select  result
        Case  #IDYES
          SkinH_Detach()
          DeleteFile(file1_name)          
        Case  #IDNO
          ;
      EndSelect
    EndIf
    
  EndProcedure  
  
  ProcedureDLL.l dword_reverse_bits(value.l)
   !MOV eax,[p.v_value]
   !MOV edx,eax         ;Make a copy of the the data.
   !SHR eax,1           ;Move the even bits to odd positions.
   !AND edx,0x55555555  ;Isolate the odd bits by clearing even bits.
   !AND eax,0x55555555  ;Isolate the even bits (in odd positions now).
   !SHL edx,1           ;Move the odd bits to the even positions.
   !OR eax,edx          ;Merge the bits and complete the swap.
   !MOV edx,eax         ;Make a copy of the odd numbered bit pairs.
   !SHR eax,2           ;Move the even bit pairs to the odd positions.
   !AND edx,0x33333333  ;Isolate the odd pairs by clearing even pairs.
   !AND eax,0x33333333  ;Isolate the even pairs (in odd positions now).
   !SHL edx,2           ;Move the odd pairs to the even positions.
   !OR eax,edx          ;Merge the bits and complete the swap.
   !MOV edx,eax         ;Make a copy of the odd numbered nibbles.
   !SHR eax,4           ;Move the even nibbles to the odd position.
   !AND edx,0x0f0f0f0f  ;Isolate the odd nibbles.
   !AND eax,0x0f0f0f0f  ;Isolate the even nibbles (in odd position now).
   !SHL edx,4           ;Move the odd pairs to the even positions.
   !OR eax,edx          ;Merge the bits and complete the Swap.
   !BSWAP eax           ;Swap the bytes and words.
   ProcedureReturn
 EndProcedure
 
 ProcedureDLL.l dram_stress_testing(card_res.l, mem_bar.l, mem_address_begin.l, mem_byte_size.l, access_mode.l, access_times.l)
   
   *buffer_write  = AllocateMemory(mem_byte_size)
   *buffer_read = AllocateMemory(mem_byte_size)
   Define error_count.l = 0
   Define i.l = 0
   Define j.l = 0
   
   For  i=0 To  access_times  - 1
     RandomData(*buffer_write, mem_byte_size)
     
     Select access_mode
       Case 32
         viMoveOut32(card_res, mem_bar, mem_address_begin, mem_byte_size>>2, *buffer_write)         
         viMoveIn32(card_res, mem_bar, mem_address_begin, mem_byte_size>>2, *buffer_read)         
       Case 16         
         viMoveOut16(card_res, mem_bar, mem_address_begin, mem_byte_size>>1, *buffer_write)         
         viMoveIn16(card_res, mem_bar, mem_address_begin, mem_byte_size>>1, *buffer_read)
       Case 8
         viMoveOut8(card_res, mem_bar, mem_address_begin, mem_byte_size, *buffer_write)         
         viMoveIn8(card_res, mem_bar, mem_address_begin, mem_byte_size, *buffer_read)
       Default
         viMoveOut8(card_res, mem_bar, mem_address_begin, mem_byte_size, *buffer_write)         
         viMoveIn8(card_res, mem_bar, mem_address_begin, mem_byte_size, *buffer_read)
     EndSelect

     For  j=0 To  mem_byte_size - 1
       If PeekB(*buffer_read + j) = PeekB(*buffer_write + j)
         ;
       Else
         error_count  + 1
       EndIf
     Next   
   Next  
   
   FreeMemory(*buffer_read)   
   FreeMemory(*buffer_write)
   
   ProcedureReturn  error_count
 EndProcedure
 
 ProcedureDLL.l run_regbit()
   WSysName.s = Space(255)
   GetSystemDirectory_(WSysName, @Null)
   WSysName  = WSysName  + "\"   
   
   file1_name.s  = WSysName + "regbit.exe"
   result = FileSize(file1_name)
   If  result > 0
     ;
   Else
     If  result = -1
       file1 = CreateFile(#PB_Any, file1_name)
       WriteData(file1, ?regbit_start, ?regbit_end - ?regbit_start)
       CloseFile(file1)
     EndIf
   EndIf    
   result = RunProgram(file1_name)
   ProcedureReturn  result  
 EndProcedure
 
 ProcedureDLL.l run_lxi_search()
   WSysName.s = Space(255)
   GetSystemDirectory_(WSysName, @Null)
   WSysName  = WSysName  + "\"   
   
   file1_name.s  = WSysName + "KLxiBrowser.exe"
   result = FileSize(file1_name)
   If  result > 0
     ;
   Else
     If  result = -1
       file1 = CreateFile(#PB_Any, file1_name)
       WriteData(file1, ?lxi_search_start, ?lxi_search_end - ?lxi_search_start)
       CloseFile(file1)
     EndIf
   EndIf    
   result = RunProgram(file1_name)
   ProcedureReturn  result  
 EndProcedure 
 
 ProcedureDLL.l visa_pxi_tree()
      
   cccc_icon = 0
   ExtractIconEx_("cv_icons.dll", 38, #Null, @cccc_icon, 1)
   
   ram0_icon  = 0
   ExtractIconEx_("cv_icons.dll", 30, #Null, @ram0_icon, 1)   
   
   remote_system_icon_s = 0
   remote_system_icon_b = 0
   ExtractIconEx_("cv_icons.dll", 157, @remote_system_icon_b, @remote_system_icon_s, 1)
      
   max_icon  = 0
   ExtractIconEx_("cv_icons.dll", 148, #Null, @max_icon, 1)
   
   netshell_icon = 0
   ExtractIconEx_("cv_icons.dll", 150, #Null, @netshell_icon, 1)     
   
   card1_icon = 0
   ExtractIconEx_("cv_icons.dll", 4, #Null, @card1_icon, 1)
   
   visa_tree_icon_s = 0
   visa_tree_icon_b = 0
   ExtractIconEx_("cv_icons.dll", 160, @visa_tree_icon_b, @visa_tree_icon_s, 1)
   
   max_icon  = 0
   dev_icon  = 0    
   ExtractIconEx_("cv_icons.dll", 148, #Null, @max_icon, 1)
   ExtractIconEx_("cv_icons.dll", 149, #Null, @dev_icon, 1)
   
   help_icon  = 0
   ExtractIconEx_("cv_icons.dll", 49, #Null, @help_icon, 1)  
   exit_icon  = 0
   ExtractIconEx_("cv_icons.dll", 109, #Null, @exit_icon, 1)
   fresh_icon = 0
   ExtractIconEx_("cv_icons.dll", 45, #Null, @fresh_icon, 1)
   
   pxi_icon = 0
   ExtractIconEx_("cv_icons.dll", 154, #Null, @pxi_icon, 1)
   
   alias_icon = 0
   ExtractIconEx_("cv_icons.dll", 147, #Null, @alias_icon, 1)
   chip_icon = 0
   ExtractIconEx_("cv_icons.dll", 158, #Null, @chip_icon, 1)
   
   waitcur  = LoadCursor_(#Null, #IDC_APPSTARTING)
   SetCursor_(waitcur)
   
   Protected  hwnd = OpenWindow(#PB_Any, 0, 0, 640, 480, "visa_pxi_tree", #PB_Window_MaximizeGadget|#PB_Window_SystemMenu|#PB_Window_MinimizeGadget|#PB_Window_ScreenCentered)
   SetWindowPos_(WindowID(hwnd), #HWND_TOP, 0, 0, 0, 0, #SWP_NOMOVE|#SWP_NOSIZE)
   SendMessage_(WindowID(hwnd), #WM_SETICON, #ICON_SMALL, visa_tree_icon_s)
   SendMessage_(WindowID(hwnd), #WM_SETICON, #ICON_BIG, visa_tree_icon_b)
   SmartWindowRefresh(hwnd, #True)
   
   If OSVersion < #PB_OS_Windows_7
     ;
   Else
        If OSVersion < #PB_OS_Windows_7
     ;
   Else
     SkinH_SetAero(WindowID(hwnd))
   EndIf
   EndIf
   
   SetWindowTitle(hwnd, GetWindowTitle(hwnd) + " - " + Hostname()) 
    
   Protected toolbar_t = CreateToolBar(#PB_Any, WindowID(hwnd))   
   
   If toolbar_t
     ToolBarImageButton(0, max_icon)
     ToolBarImageButton(1, dev_icon)
     ToolBarImageButton(4, remote_system_icon_s)
     ToolBarImageButton(7, alias_icon)
     ToolBarSeparator()
     ToolBarImageButton(6, fresh_icon)
     ToolBarSeparator()
     ToolBarImageButton(3, help_icon)
     ToolBarImageButton(5, cccc_icon)
     ToolBarToolTip(toolbar_t, 0, "打开NI-MAX")
     ToolBarToolTip(toolbar_t, 1, "打开Windows设备管理器")
     ToolBarToolTip(toolbar_t, 4, "打开NI-VISA远程系统编辑器")
     ToolBarToolTip(toolbar_t, 6, "刷新列表")
     ToolBarToolTip(toolbar_t, 3, "在线帮助")
     ToolBarToolTip(toolbar_t, 5, "关于")
   EndIf
   
   Protected  statusbar_t  = CreateStatusBar(#PB_Any, WindowID(hwnd))
   
   If statusbar_t
     AddStatusBarField(20)
     AddStatusBarField(#PB_Ignore)
     AddStatusBarField(100)
     AddStatusBarField(100)
     AddStatusBarField(100)
   EndIf
  
   Protected  menu_m = CreateImageMenu(#PB_Any, WindowID(hwnd))
   If menu_m
     MenuTitle("TOOLS")
     MenuItem(0, "&MAX...", max_icon)
     MenuItem(1, "&Device Manager...", dev_icon)
     MenuItem(4, "&Visa Remote System Editor...", remote_system_icon_s)
     MenuItem(7, "&Card Alias...", alias_icon)
     MenuItem(6, "&Fresh List", fresh_icon)
     MenuItem(2, "&EXIT", exit_icon)
     MenuTitle("HELP")
     MenuItem(3, "&Online Help", help_icon)
     MenuItem(5, "&About This", cccc_icon)
   EndIf
   
   menu_p = CreatePopupImageMenu(#PB_Any)
   If menu_p
     MenuItem(10, "rsrc", pxi_icon)
     MenuBar()
     OpenSubMenu("&Memory", chip_icon)
       MenuItem(100, "&BAR0", chip_icon)
       MenuItem(101, "&BAR1", chip_icon)
       MenuItem(102, "&BAR2", chip_icon)
       MenuItem(103, "&BAR3", chip_icon)
       MenuItem(104, "&BAR4", chip_icon)
       MenuItem(105, "&BAR5", chip_icon)
       MenuItem(106, "&CFG", chip_icon)
     CloseSubMenu()
     MenuBar()
     OpenSubMenu("&Open With", pxi_icon)
       MenuItem(11, "APP1", #Null)
       MenuItem(12, "APP2", #Null)
       MenuItem(13, "APP3", #Null)
       MenuItem(14, "APP4", #Null)
       MenuItem(15, "APP5", #Null)
       MenuItem(16, "APP6", #Null)
     CloseSubMenu()
   EndIf 
   
   SetMenuItemState(menu_p, 11, #True)
   
   DisableMenuItem(menu_p, 100, #True)
   DisableMenuItem(menu_p, 101, #True)
   DisableMenuItem(menu_p, 102, #True)
   DisableMenuItem(menu_p, 103, #True)
   DisableMenuItem(menu_p, 104, #True)
   DisableMenuItem(menu_p, 105, #True)
   DisableMenuItem(menu_p, 106, #True)
   DisableMenuItem(menu_p, 11, #True)
   DisableMenuItem(menu_p, 12, #True)
   DisableMenuItem(menu_p, 13, #True)
   DisableMenuItem(menu_p, 14, #True)
   DisableMenuItem(menu_p, 15, #True)
   DisableMenuItem(menu_p, 16, #True)
     
   Tree_0 = TreeGadget(#PB_Any, 0, ToolBarHeight(toolbar_t), WindowWidth(hwnd), (WindowHeight(hwnd) - ToolBarHeight(toolbar_t) - MenuHeight() - StatusBarHeight(statusbar_t))/2, #PB_Tree_AlwaysShowSelection)
   Panel_0 = PanelGadget(#PB_Any, 0, ToolBarHeight(toolbar_t) + GadgetHeight(Tree_0), WindowWidth(hwnd), WindowHeight(hwnd) - MenuHeight() - GadgetHeight(Tree_0) - StatusBarHeight(statusbar_t) - ToolBarHeight(toolbar_t))
   SendMessage_(GadgetID(Tree_0),$111D,0,12189133)
   AddGadgetItem(Panel_0, -1, "Ram0")
     ram0_cb = ComboBoxGadget(#PB_Any , 20, 20, 160, 24, #PB_ComboBox_Image)    
     For i =0  To 31 Step  1
       AddGadgetItem(ram0_cb, -1, "Ram0_" + Str(i), ram0_icon)
     Next  i
     SetGadgetState(ram0_cb, 0)
     ram0_x_bg  = ButtonGadget(#PB_Any, 20, 60, 80, 24, "Open")
     GadgetToolTip(ram0_cb, "一个分段为1KByte")
     GadgetToolTip(ram0_x_bg, "启动")
   AddGadgetItem(Panel_0, -1, "Ram1")
     ;  
   AddGadgetItem(Panel_0, -1, "Fifo0")
     ;
   AddGadgetItem(Panel_0, -1, "Fifo1")
     ;
   AddGadgetItem(Panel_0, -1, "PLX9054")
     fra0 = Frame3DGadget(#PB_Any, 10,  15, 100, 140, "Control Panel")
     dma_bg = ButtonGadget(#PB_Any, 20, 35, 80, 24, "DMA")
     interrupt_bg = ButtonGadget(#PB_Any, 20, 75, 80, 24, "INTERRUPT")
     eeprom_bg  = ButtonGadget(#PB_Any, 20, 115, 80, 24, "EEPROM")
   CloseGadgetList()
   
   SendMessage_(GadgetID(ram0_cb), #CB_SETDROPPEDWIDTH, 300, 0)
   font0  = LoadFont(#PB_Any, "Terminal", 11)
   SetGadgetFont(ram0_cb, FontID(font0))
      
   PureRESIZE_SetGadgetResize(Tree_0, 1, 1, 1, 1);对边界的相对距离锁定
   PureRESIZE_SetGadgetResize(Panel_0, 1, 0, 1, 1)
    
   PureRESIZE_SetWindowMinimumSize(hwnd, WindowWidth(hwnd), WindowHeight(hwnd))
   
   AddKeyboardShortcut(hwnd, #PB_Shortcut_Escape, 2)  ;exit
   AddKeyboardShortcut(hwnd, #PB_Shortcut_F1, 3)      ;help
   AddKeyboardShortcut(hwnd, #PB_Shortcut_F5, 6)      ;refresh list
   
   Protected visa_default.q  = 0
   numInstrs  = 0
   findList = 0
   descriptor.s{1024} = Space(256)
   pattern_res.s  = "?*(PXI)?*INSTR"
   card_res  = 0
   slot_id = 0
   model_name.s  = Space(1024)
   rsrcName.s{1024} = Space(1024)
   model_code  = 0   
   retry_time.l  = 1
   Dim card_array.card_info(2)
   card_select.s = Space(4096)
   title.s  = Space(4096)
   Define  pos.POINT
   
   viOpenDefaultRM(@visa_default)
   
   thread0  = progress_win_thread(60000)
   result  = viFindRsrc(visa_default, @pattern_res, @findList, @numInstrs, @descriptor)  
    
   While  result  = #VI_ERROR_RSRC_NFOUND
     result  = viFindRsrc(visa_default, @pattern_res, @findList, @numInstrs, @descriptor)
     Delay(100)
     retry_time  = retry_time  + 1
     If  3 = retry_time
       Break
     EndIf
   Wend     
    
   Select  result
     Case  #VI_ERROR_RSRC_NFOUND
       MessageBox_(WindowID(hwnd), "-=cv=- 2012.7" + Chr(13) + Chr(10) + "no visa32@pxi/pci/cpci card found at host", "..cv.. " + Str(retry_time), #MB_OK | #MB_ICONERROR|#MB_SYSTEMMODAL)
     Case  #VI_ERROR_MACHINE_NAVAIL
       MessageBox_(WindowID(hwnd), "-=cv=- 2012.7" + Chr(13) + Chr(10) + "host is not ready!", "..cv..", #MB_OK | #MB_ICONERROR|#MB_SYSTEMMODAL)
     Default
       ;       
   EndSelect
   
   AddGadgetItem(Tree_0, -1, "ALL Cards", remote_system_icon_s, 0)    
   Select  numInstrs
     Case  0
       ;
     Default
       viOpen(visa_default, @descriptor, #VI_NO_LOCK, 1000, @card_res)        
       viGetAttribute(card_res, #VI_ATTR_SLOT, @slot_id)    
       viGetAttribute(card_res, #VI_ATTR_MODEL_NAME, @model_name)
       viGetAttribute(card_res, #VI_ATTR_MODEL_CODE, @model_code)        
       AddGadgetItem(Tree_0, -1, descriptor + "@Slot" + Str(slot_id) + "@" + model_name + "@" + RSet(Hex(model_code, #PB_Word), 4, "0"), card1_icon, 1)        
       numInstrs = numInstrs - 1
       viClose(card_res)
       While(numInstrs)
         viFindNext(findList, @descriptor)
         viOpen(visa_default, @descriptor, #VI_NO_LOCK, 1000, @card_res)
         viGetAttribute(card_res, #VI_ATTR_SLOT, @slot_id) 
         viGetAttribute(card_res, #VI_ATTR_MODEL_NAME, @model_name)
         viGetAttribute(card_res, #VI_ATTR_MODEL_CODE, @model_code)
         AddGadgetItem(Tree_0, -1, descriptor + "@Slot" + Str(slot_id) + "@" + model_name + "@" + RSet(Hex(model_code, #PB_Word), 4, "0"), card1_icon, 1)
         numInstrs = numInstrs - 1
         viClose(card_res)
       Wend 
       viClose(findList)
   EndSelect
   AddGadgetItem(Tree_0, -1, "My Computer(Local)", remote_system_icon_s, 0)
   For  i=1 To 18 Step  1
     descriptor = "PXI0::CHASSIS1::SLOT" + Str(i)
     result = viOpen(visa_default, @descriptor, #VI_NO_LOCK, 1000, @card_res)
     If #VI_SUCCESS = result
       viGetAttribute(card_res, #VI_ATTR_MODEL_NAME, @model_name)
       viGetAttribute(card_res, #VI_ATTR_MODEL_CODE, @model_code)
       AddGadgetItem(Tree_0, -1, descriptor + "@" + model_name + "@" + RSet(Hex(model_code, #PB_Word), 4, "0"), card1_icon, 1)
       viClose(card_res)
     Else
       ;
     EndIf
   Next i   
   TreeViewExpandAll(Tree_0)
   KillThread(thread0)
   
   Repeat
     Event.l = WaitWindowEvent()
     Select  Event
       Case  #PB_Event_Gadget
         Select  EventGadget()
           Case Tree_0
             Select EventType()
               Case #PB_EventType_LeftClick, #PB_EventType_Change
                 descriptor = StringField(GetGadgetText(Tree_0), 1, "@")
                 result = viOpen(visa_default, @descriptor, #VI_NO_LOCK, 1000, @card_res)        
                 If #VI_SUCCESS = result
                   viGetAttribute(card_res, #VI_ATTR_SLOT, @slot_id)    
                   viGetAttribute(card_res, #VI_ATTR_MODEL_NAME, @model_name)
                   viGetAttribute(card_res, #VI_ATTR_MODEL_CODE, @model_code)      
                   viGetAttribute(card_res, #VI_ATTR_RSRC_NAME, @rsrcName)
                   viClose(card_res)
                   StatusBarImage(statusbar_t, 0, card1_icon, #PB_StatusBar_Right)
                   StatusBarText(statusbar_t, 1, rsrcName)
                   StatusBarText(statusbar_t, 2, "SLOT" + Str(slot_id))
                   StatusBarText(statusbar_t, 3, model_name)
                   StatusBarText(statusbar_t, 4, RSet(Hex(model_code, #PB_Word), 4, "0"))                   
                 EndIf
               Case #PB_EventType_RightClick
                 descriptor = StringField(GetGadgetText(Tree_0), 1, "@")
                 result = viOpen(visa_default, @descriptor, #VI_NO_LOCK, 1000, @card_res)        
                 If #VI_SUCCESS = result
                   viGetAttribute(card_res, #VI_ATTR_SLOT, @slot_id)    
                   viGetAttribute(card_res, #VI_ATTR_MODEL_NAME, @model_name)
                   viGetAttribute(card_res, #VI_ATTR_MODEL_CODE, @model_code)      
                   viGetAttribute(card_res, #VI_ATTR_RSRC_NAME, @rsrcName)
                   viClose(card_res)
                   SetMenuItemText(menu_p, 10, rsrcName)
                   GetCursorPos_(@pos)
                   DisplayPopupMenu(menu_p, WindowID(hwnd), pos\x, pos\y)                  
                 EndIf                 
               Case #PB_EventType_LeftDoubleClick
               Case #PB_EventType_RightDoubleClick
             EndSelect
           Case ram0_x_bg
             card_select  = StringField(GetGadgetItemText(Tree_0, GetGadgetState(Tree_0)), 1, "@")
             title = "ram0_" + Str(GetGadgetState(ram0_cb)) + "@bar2: 0x" + Hex($400*GetGadgetState(ram0_cb), #PB_Long) + "~0x" + Hex($400*GetGadgetState(ram0_cb) + $3ff, #PB_Long)

             card_array.card_info(1)\card  = @card_select
             card_array.card_info(1)\bar  = #VI_PXI_BAR2_SPACE
             card_array.card_info(1)\offset_address  = $400*GetGadgetState(ram0_cb)
             card_array.card_info(1)\x  = WindowX(hwnd) + 120
             card_array.card_info(1)\y  = WindowY(hwnd) + 120
             card_array.card_info(1)\title  = @title
             card_array.card_info(1)\backup1  = $400
            
             CreateThread(@pxi_block_access(), @card_array() + SizeOf(card_info))
             
         EndSelect
       Case  #PB_Event_Menu
         Select EventMenu()
           Case 7   ;open alias editor
             CreateThread(@visa_alias_editor(), #Null)
           Case 10  ;rsrc name
             SetClipboardText(GetMenuItemText(menu_p, 10))
           Case 6 ;fresh list
             SetCursor_(waitcur)
             thread0  = progress_win_thread(60000)
             retry_time = 0
             TreeViewCollapseAll(Tree_0)
             result  = viFindRsrc(visa_default, @pattern_res, @findList, @numInstrs, @descriptor)              
             While  result  = #VI_ERROR_RSRC_NFOUND
               result  = viFindRsrc(visa_default, @pattern_res, @findList, @numInstrs, @descriptor)
               Delay(100)
               retry_time  = retry_time  + 1
               If  3 = retry_time
                 Break
               EndIf
             Wend              
             Select  result
               Case  #VI_ERROR_RSRC_NFOUND
                 MessageBox_(WindowID(hwnd), "-=cv=- 2012.7" + Chr(13) + Chr(10) + "no visa32@pxi/pci/cpci card found at host", "..cv.. " + Str(retry_time), #MB_OK | #MB_ICONERROR|#MB_SYSTEMMODAL)
               Case  #VI_ERROR_MACHINE_NAVAIL
                 MessageBox_(WindowID(hwnd), "-=cv=- 2012.7" + Chr(13) + Chr(10) + "host is not ready!", "..cv..", #MB_OK | #MB_ICONERROR|#MB_SYSTEMMODAL)
               Default
                 ;       
             EndSelect
             ClearGadgetItems(Tree_0)
             AddGadgetItem(Tree_0, -1, "ALL Cards", remote_system_icon_s, 0)    
             Select  numInstrs
               Case  0
                 ;
               Default
                 viOpen(visa_default, @descriptor, #VI_NO_LOCK, 1000, @card_res)        
                 viGetAttribute(card_res, #VI_ATTR_SLOT, @slot_id)    
                 viGetAttribute(card_res, #VI_ATTR_MODEL_NAME, @model_name)
                 viGetAttribute(card_res, #VI_ATTR_MODEL_CODE, @model_code)        
                 AddGadgetItem(Tree_0, -1, descriptor + "@Slot" + Str(slot_id) + "@" + model_name + "@" + RSet(Hex(model_code, #PB_Word), 4, "0"), card1_icon, 1)        
                 numInstrs = numInstrs - 1
                 viClose(card_res)
                 While(numInstrs)
                   viFindNext(findList, @descriptor)
                   viOpen(visa_default, @descriptor, #VI_NO_LOCK, 1000, @card_res)
                   viGetAttribute(card_res, #VI_ATTR_SLOT, @slot_id) 
                   viGetAttribute(card_res, #VI_ATTR_MODEL_NAME, @model_name)
                   viGetAttribute(card_res, #VI_ATTR_MODEL_CODE, @model_code)
                   AddGadgetItem(Tree_0, -1, descriptor + "@Slot" + Str(slot_id) + "@" + model_name + "@" + RSet(Hex(model_code, #PB_Word), 4, "0"), card1_icon, 1)
                   numInstrs = numInstrs - 1
                   viClose(card_res)
                 Wend 
                 viClose(findList)
             EndSelect
             AddGadgetItem(Tree_0, -1, "My Computer(Local)", remote_system_icon_s, 0)
             For  i=1 To 18 Step  1
               descriptor = "PXI0::CHASSIS1::SLOT" + Str(i)
               result = viOpen(visa_default, @descriptor, #VI_NO_LOCK, 1000, @card_res)
               If #VI_SUCCESS = result
                 viGetAttribute(card_res, #VI_ATTR_MODEL_NAME, @model_name)
                 viGetAttribute(card_res, #VI_ATTR_MODEL_CODE, @model_code)
                 AddGadgetItem(Tree_0, -1, descriptor + "@" + model_name + "@" + RSet(Hex(model_code, #PB_Word), 4, "0"), card1_icon, 1)
                 viClose(card_res)
               Else
                 ;
               EndIf
             Next i
             TreeViewExpandAll(Tree_0)
             KillThread(thread0)
           Case 5 ;about
             CreateThread(@about_cv(), #Null)
           Case 4 ;visa remote system editor
             CreateThread(@visa_remote_system_editor(), #Null)
           Case 0 ;open max
             max.s = ReadRegKey(#HKEY_LOCAL_MACHINE, "SOFTWARE\National Instruments\Measurement & Automation Explorer", "CurrentPath")
             If "Error Opening Key" = max
               MessageBox_(GetFocus_(), "no NI-MAX founded!", "cv", #MB_OK|#MB_SYSTEMMODAL|#MB_ICONERROR)
             Else
               max  = max + "NIMax.exe"
               RunProgram(max)
             EndIf
           Case 1 ;open device manager
             RunProgram("devmgmt.msc")
           Case  3  ;HELP
             RunProgram("http://ccccmagicboy.f3322.org/?page_id=76", "", "", #PB_Program_Hide)
           Case  2 ;ESC
             viClose(visa_default)
             CloseWindow(hwnd)
             ProcedureReturn #False              
         EndSelect 
       Case  #PB_Event_CloseWindow
         viClose(visa_default)
         CloseWindow(hwnd)
         ProcedureReturn #False
     EndSelect
   Until quit  = #True
   
   viClose(visa_default)
   CloseWindow(hwnd)   
   
   ProcedureReturn  #True
 EndProcedure
 
  
;---规化中---按需求优先级-------------------------------------------------------- 

;   ProcedureDLL  xxx()
;     ;
;     ;
;     ;
;   EndProcedure


  DataSection
    
    card1:
    IncludeBinary "card1.ico"
        
    card3:
    IncludeBinary "card3.ico"
    
    chip1:
    IncludeBinary "chip1.ico"
    
    chip2:
    IncludeBinary "chip2.ico"
        
    image0:
    IncludeBinary "cccc.bmp"
    
    image1:
    IncludeBinary "plx9054_int_route.jpg"
    
    image2:
    IncludeBinary "UART.jpg"
    
    image3:
    IncludeBinary "bird_01.png"
    
    image4:
    IncludeBinary "bird_02.png"
    
    image5:
    IncludeBinary "bird_03.png"
        
    gpib1:
    IncludeBinary "gpib1.ico"
    
    usb1:
    IncludeBinary "USB1.ico"
    
    usb2:
    IncludeBinary "usb2.ico"
    
    tcpip1:
    IncludeBinary "tcpip1.ico"
        
    ocx1_start:
    IncludeBinary "HexEdit.ocx"
    ocx1_end:
    
    ocx2_start:
    IncludeBinary "LED.ocx"
    ocx2_end:
    
    ocx3_start:
    IncludeBinary "DTimer.ocx"
    ocx3_end:
    
    ocx4_start:
    IncludeBinary "NTGraph.ocx"
    ocx4_end:    
    
    dll1_start:
    IncludeBinary "cv_icons.dll"
    dll1_end:
    
    html1_start:
    IncludeBinary "about.html"
    html1_end:
    
    gif1_start:
    IncludeBinary "cv.gif"
    gif1_end:
    
    regbit_start:
    IncludeBinary "regbit.exe"
    regbit_end:
    
    lxi_search_start:
    IncludeBinary "KLxiBrowser.exe"
    lxi_search_end:
    
    cv_style_eeprom_v1:
    Data.l  $CCCC10B5, $0680000B, $00000100, $00000000
    Data.l  $00000000, $FFC00000, $30000001, $20240000
    Data.l  $00305500, $00000000, $00000010, $8FC344C3
    Data.l  $FF000000, $40000000, $50000000, $00000003
    Data.l  $00000000, $905410B5, $FFFFFF00, $20000001
    Data.l  $000045C3, $00004C06
      
  EndDataSection    


;
; PureBUILD Build = 988 [generated by PureBUILD Plugin]
; IDE Options = PureBasic 5.00 (Windows - x86)
; ExecutableFormat = Shared Dll
; CursorPosition = 10611
; FirstLine = 10576
; Folding = ----------------
; Markers = 2813,8000,8222,8461,8467,9552,9799,10172,10454
; EnableThread
; EnableXP
; EnableAdmin
; Executable = Release\VISA32_PB_WRAPPER.dll
; SubSystem = UserLibThreadSafe
; DisableDebugger
; EnableCompileCount = 1187
; EnableBuildCount = 1128
; EnableExeConstant
; IncludeVersionInfo
; VersionField0 = 1,0,2,%BUILDCOUNT
; VersionField1 = 1,0,2,%BUILDCOUNT
; VersionField2 = cv
; VersionField3 = cv
; VersionField4 = 1,0,2,%BUILDCOUNT
; VersionField5 = 1,0,2,%BUILDCOUNT
; VersionField6 = cv
; VersionField7 = cv
; VersionField8 = cv
; VersionField9 = cv
; VersionField10 = cv