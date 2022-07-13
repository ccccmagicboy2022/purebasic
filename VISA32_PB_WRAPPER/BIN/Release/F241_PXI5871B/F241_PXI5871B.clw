; CLW file contains information for the MFC ClassWizard

[General Info]
Version=1
LastClass=CF241_PXI5871BDlg
LastTemplate=CDialog
NewFileInclude1=#include "stdafx.h"
NewFileInclude2=#include "F241_PXI5871B.h"

ClassCount=12
Class1=CF241_PXI5871BApp
Class2=CF241_PXI5871BDlg
Class3=CAboutDlg

ResourceCount=13
Resource1=IDD_DIALOG6
Resource2=IDR_MAINFRAME
Resource3=IDD_ABOUTBOX
Resource4=IDD_DIALOG4
Resource5=IDD_DIALOG8
Class4=CPage1
Class5=CPage2
Class6=CPage3
Resource6=IDD_DIALOG3
Resource7=IDD_F241_PXI5871B_DIALOG
Resource8=IDD_DIALOG7
Resource9=IDD_REAR_CARD
Resource10=IDD_DIALOG5
Class7=CPage4
Class8=CPage5
Class9=CPage6
Class10=CPage7
Class11=CMyConfigSheet
Resource11=IDD_DIALOG1
Resource12=IDD_DIALOG2
Class12=CPage8
Resource13=IDR_MENU_MAIN

[CLS:CF241_PXI5871BApp]
Type=0
HeaderFile=F241_PXI5871B.h
ImplementationFile=F241_PXI5871B.cpp
Filter=N
LastObject=CF241_PXI5871BApp

[CLS:CF241_PXI5871BDlg]
Type=0
HeaderFile=F241_PXI5871BDlg.h
ImplementationFile=F241_PXI5871BDlg.cpp
Filter=W
LastObject=ID_MENU_SERIAL_LEGEND
BaseClass=CDialog
VirtualFilter=dWC

[CLS:CAboutDlg]
Type=0
HeaderFile=F241_PXI5871BDlg.h
ImplementationFile=F241_PXI5871BDlg.cpp
Filter=D

[DLG:IDD_ABOUTBOX]
Type=1
Class=CAboutDlg
ControlCount=5
Control1=IDC_STATIC,static,1342177283
Control2=IDC_VERSION,static,1342308480
Control3=IDC_STATIC,static,1342308352
Control4=IDOK,button,1342373889
Control5=IDC_BUTTON_HELP,button,1342242816

[DLG:IDD_F241_PXI5871B_DIALOG]
Type=1
Class=CF241_PXI5871BDlg
ControlCount=49
Control1=IDC_HEALTH,button,1342242819
Control2=IDC_LED_DI0,button,1342243363
Control3=IDC_COUNTER1,{7B22D231-8148-4808-96A3-768E57B96355},1342242816
Control4=IDC_COUNTER2,{7B22D231-8148-4808-96A3-768E57B96355},1342242816
Control5=IDC_COUNTER1_CLEAR,button,1342242817
Control6=IDC_COUNTER2_CLEAR,button,1342242816
Control7=IDC_STATIC,button,1342177287
Control8=IDC_STATIC,button,1342177287
Control9=IDC_STATIC,button,1342177287
Control10=IDC_STATIC,static,1342308352
Control11=IDC_STATIC,static,1342308352
Control12=IDC_DUTY1,{7B22D231-8148-4808-96A3-768E57B96355},1342242816
Control13=IDC_DUTY2,{7B22D231-8148-4808-96A3-768E57B96355},1342242816
Control14=IDC_STATIC,button,1342177287
Control15=IDC_STATIC,static,1342308352
Control16=IDC_STATIC,static,1342308352
Control17=IDC_STATIC,static,1342308352
Control18=IDC_STATIC,static,1342308352
Control19=IDC_STOP1,button,1342242819
Control20=IDC_SPEED1,{7B22D231-8148-4808-96A3-768E57B96355},1342242816
Control21=IDC_STATIC,button,1342177287
Control22=IDC_STATIC,static,1342308352
Control23=IDC_STOP2,button,1342242819
Control24=IDC_SPEED2,{7B22D231-8148-4808-96A3-768E57B96355},1342242816
Control25=IDC_STATIC,button,1342177287
Control26=IDC_STATIC,static,1342308352
Control27=IDC_STOP3,button,1342242819
Control28=IDC_SPEED3,{7B22D231-8148-4808-96A3-768E57B96355},1342242816
Control29=IDC_STATIC,button,1342177287
Control30=IDC_STATIC,static,1342308352
Control31=IDC_STOP4,button,1342242819
Control32=IDC_SPEED4,{7B22D231-8148-4808-96A3-768E57B96355},1342242816
Control33=IDC_STATIC,button,1342177287
Control34=IDC_STATIC,static,1342308352
Control35=IDC_STOP5,button,1342242819
Control36=IDC_SPEED5,{7B22D231-8148-4808-96A3-768E57B96355},1342242816
Control37=IDC_STATIC,button,1342177287
Control38=IDC_STATIC,static,1342308352
Control39=IDC_BN_TXD1_BUFFER1,button,1342242816
Control40=IDC_BN_TXD1_BUFFER2,button,1342242816
Control41=IDC_STATIC,button,1342177287
Control42=IDC_BN_RXD_BUFFER,button,1342242816
Control43=IDC_STATIC,button,1342177287
Control44=IDC_STATIC,button,1342177287
Control45=IDC_TIMER1,edit,1350641792
Control46=IDC_STATIC,static,1342308352
Control47=IDC_PPS_COUNT1,edit,1350641792
Control48=IDC_STATIC,static,1342308352
Control49=IDC_PPS_CLEAR1,button,1342242816

[DLG:IDD_DIALOG1]
Type=1
Class=CPage1
ControlCount=1
Control1=IDC_STATIC,static,1342308352

[DLG:IDD_DIALOG2]
Type=1
Class=CPage2
ControlCount=3
Control1=IDC_CHECK1,button,1342242819
Control2=IDC_CHECK2,button,1342242819
Control3=IDC_STATIC,button,1342177287

[DLG:IDD_DIALOG3]
Type=1
Class=CPage3
ControlCount=3
Control1=IDC_CHECK1,button,1342242819
Control2=IDC_CHECK2,button,1342242819
Control3=IDC_STATIC,button,1342177287

[CLS:CPage1]
Type=0
HeaderFile=Page1.h
ImplementationFile=Page1.cpp
BaseClass=CPropertyPage
Filter=D
LastObject=CPage1
VirtualFilter=idWC

[CLS:CPage2]
Type=0
HeaderFile=Page2.h
ImplementationFile=Page2.cpp
BaseClass=CPropertyPage
Filter=D
LastObject=CPage2
VirtualFilter=idWC

[CLS:CPage3]
Type=0
HeaderFile=Page3.h
ImplementationFile=Page3.cpp
BaseClass=CPropertyPage
Filter=D
LastObject=CPage3
VirtualFilter=idWC

[DLG:IDD_DIALOG4]
Type=1
Class=CPage4
ControlCount=16
Control1=IDC_COMBO_BPS,combobox,1344339971
Control2=IDC_STATIC,static,1342308352
Control3=IDC_COMBO_PARITY_BIT,combobox,1344339971
Control4=IDC_STATIC,static,1342308352
Control5=IDC_COMBO_STOP_BIT,combobox,1344339971
Control6=IDC_STATIC,static,1342308352
Control7=IDC_STATIC,button,1342177287
Control8=IDC_COMBO_TXD_BUFFER,combobox,1344339971
Control9=IDC_TXD_NUM,edit,1350639744
Control10=IDC_STATIC,static,1342308352
Control11=IDC_STATIC,button,1342177287
Control12=IDC_STATIC,static,1342308352
Control13=IDC_STATIC,static,1342308352
Control14=IDC_PARAM,edit,1350633600
Control15=IDC_STATIC,button,1342177287
Control16=IDC_PARAM2,edit,1350633600

[DLG:IDD_DIALOG5]
Type=1
Class=CPage5
ControlCount=0

[DLG:IDD_DIALOG6]
Type=1
Class=CPage6
ControlCount=0

[DLG:IDD_DIALOG7]
Type=1
Class=CPage7
ControlCount=0

[CLS:CPage4]
Type=0
HeaderFile=Page4.h
ImplementationFile=Page4.cpp
BaseClass=CPropertyPage
Filter=D
LastObject=IDC_TXD_NUM
VirtualFilter=idWC

[CLS:CPage5]
Type=0
HeaderFile=Page5.h
ImplementationFile=Page5.cpp
BaseClass=CPropertyPage
Filter=D
LastObject=CPage5
VirtualFilter=idWC

[CLS:CPage6]
Type=0
HeaderFile=Page6.h
ImplementationFile=Page6.cpp
BaseClass=CPropertyPage
Filter=D
LastObject=CPage6
VirtualFilter=idWC

[CLS:CPage7]
Type=0
HeaderFile=Page7.h
ImplementationFile=Page7.cpp
BaseClass=CPropertyPage
Filter=D
LastObject=CPage7
VirtualFilter=idWC

[MNU:IDR_MENU_MAIN]
Type=1
Class=?
Command1=ID_MENU_SELECT_CARD
Command2=ID_MENU_CONFIG
Command3=ID_MENU_RESET
Command4=ID_MENU_MEM
Command5=ID_MENU_CHECK_EEP
Command6=ID_MENU_REMOTE_CONFIG
Command7=ID_MENU_FPGA_JTAG_DOWN
Command8=ID_MENU_FPGA_FLASH_DOWN
Command9=ID_MENU_START_SERVER
Command10=ID_MENU_STOP_SERVER
Command11=ID_MENU_R1
Command12=ID_MENU_R2
Command13=ID_MENU_SERIAL_LEGEND
Command14=ID_MENU_ABOUT
CommandCount=14

[CLS:CMyConfigSheet]
Type=0
HeaderFile=MyConfigSheet.h
ImplementationFile=MyConfigSheet.cpp
BaseClass=CPropertySheet
Filter=C
VirtualFilter=hWC
LastObject=CMyConfigSheet

[DLG:IDD_REAR_CARD]
Type=1
Class=?
ControlCount=3
Control1=IDOK,button,1342242817
Control2=IDCANCEL,button,1342242816
Control3=IDC_STATIC,static,1342177287

[DLG:IDD_DIALOG8]
Type=1
Class=CPage8
ControlCount=1
Control1=IDC_STATIC,static,1342308352

[CLS:CPage8]
Type=0
HeaderFile=Page8.h
ImplementationFile=Page8.cpp
BaseClass=CPropertyPage
Filter=D
LastObject=ID_MENU_R1
VirtualFilter=idWC

