// F241_PXI5871B.cpp : Defines the class behaviors for the application.
//

#include "stdafx.h"
#include "F241_PXI5871B.h"
#include "F241_PXI5871BDlg.h"

#pragma comment(lib, ".\\visa32.lib")				//visa32
#pragma	comment(lib, ".\\VISA32_PB_WRAPPER.lib")	//visa32_cv_wrapper
#pragma comment(lib, "version.lib")
#pragma comment(lib, "F241_PXI5871B.lib")


#include	"VISA32_PB_WRAPPER/visa32_base.h"

#ifdef _DEBUG
#define new DEBUG_NEW
#undef THIS_FILE
static char THIS_FILE[] = __FILE__;
#endif

/////////////////////////////////////////////////////////////////////////////
// CF241_PXI5871BApp

BEGIN_MESSAGE_MAP(CF241_PXI5871BApp, CWinApp)
	//{{AFX_MSG_MAP(CF241_PXI5871BApp)
		// NOTE - the ClassWizard will add and remove mapping macros here.
		//    DO NOT EDIT what you see in these blocks of generated code!
	//}}AFX_MSG
	ON_COMMAND(ID_HELP, CWinApp::OnHelp)
END_MESSAGE_MAP()

/////////////////////////////////////////////////////////////////////////////
// CF241_PXI5871BApp construction

CF241_PXI5871BApp::CF241_PXI5871BApp()
{
	// TODO: add construction code here,
	// Place all significant initialization in InitInstance
}

/////////////////////////////////////////////////////////////////////////////
// The one and only CF241_PXI5871BApp object

CF241_PXI5871BApp theApp;

/////////////////////////////////////////////////////////////////////////////
// CF241_PXI5871BApp initialization

BOOL CF241_PXI5871BApp::InitInstance()
{
	//ÊÍ·ÅOCX²¢×¢²á
	check_ocx();
	AfxEnableControlContainer();

	// Standard initialization
	// If you are not using these features and wish to reduce the size
	//  of your final executable, you should remove from the following
	//  the specific initialization routines you do not need.

#ifdef _AFXDLL
	Enable3dControls();			// Call this when using MFC in a shared DLL
#else
	Enable3dControlsStatic();	// Call this when linking to MFC statically
#endif

	if (visa32.get_visalib_status())
	{
		AfxMessageBox("visa32 lib error!");
	}
	else
	{
		//ÎÞ´íÎó
	}

	CF241_PXI5871BDlg dlg;

	m_pMainWnd = &dlg;
	int nResponse = dlg.DoModal();
	if (nResponse == IDOK)
	{
		// TODO: Place code here to handle when the dialog is
		//  dismissed with OK
	}
	else if (nResponse == IDCANCEL)
	{
		// TODO: Place code here to handle when the dialog is
		//  dismissed with Cancel
	}

	// Since the dialog has been closed, return FALSE so that we exit the
	//  application, rather than start the application's message pump.



	return FALSE;
}
