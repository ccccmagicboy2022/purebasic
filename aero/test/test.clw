; CLW file contains information for the MFC ClassWizard

[General Info]
Version=1
LastClass=Csub_dlg
LastTemplate=CDialog
NewFileInclude1=#include "stdafx.h"
NewFileInclude2=#include "test.h"

ClassCount=4
Class1=CTestApp
Class2=CTestDlg
Class3=CAboutDlg

ResourceCount=4
Resource1=IDD_ABOUTBOX
Resource2=IDR_MAINFRAME
Resource3=IDD_TEST_DIALOG
Class4=Csub_dlg
Resource4=IDD_DIALOG1

[CLS:CTestApp]
Type=0
HeaderFile=test.h
ImplementationFile=test.cpp
Filter=N
BaseClass=CWinApp
VirtualFilter=AC

[CLS:CTestDlg]
Type=0
HeaderFile=testDlg.h
ImplementationFile=testDlg.cpp
Filter=D
BaseClass=CDialog
VirtualFilter=dWC
LastObject=CTestDlg

[CLS:CAboutDlg]
Type=0
HeaderFile=testDlg.h
ImplementationFile=testDlg.cpp
Filter=D

[DLG:IDD_ABOUTBOX]
Type=1
Class=CAboutDlg
ControlCount=4
Control1=IDC_STATIC,static,1342177283
Control2=IDC_STATIC,static,1342308480
Control3=IDC_STATIC,static,1342308352
Control4=IDOK,button,1342373889

[DLG:IDD_TEST_DIALOG]
Type=1
Class=CTestDlg
ControlCount=1
Control1=IDC_BUTTON1,button,1342242816

[DLG:IDD_DIALOG1]
Type=1
Class=Csub_dlg
ControlCount=1
Control1=IDC_BUTTON1,button,1342242816

[CLS:Csub_dlg]
Type=0
HeaderFile=sub_dlg.h
ImplementationFile=sub_dlg.cpp
BaseClass=CDialog
Filter=D
LastObject=Csub_dlg
VirtualFilter=dWC

