// F241_PXI5871B.h : main header file for the F241_PXI5871B application
//

#if !defined(AFX_F241_PXI5871B_H__E475E814_3DAD_444D_AB8C_AA5165E6A841__INCLUDED_)
#define AFX_F241_PXI5871B_H__E475E814_3DAD_444D_AB8C_AA5165E6A841__INCLUDED_

#if _MSC_VER > 1000
#pragma once
#endif // _MSC_VER > 1000

#ifndef __AFXWIN_H__
	#error include 'stdafx.h' before including this file for PCH
#endif

#include "resource.h"		// main symbols
#include "visa32_pb_wrapper/visa32_base.h"	// visa32_base¿‡

/////////////////////////////////////////////////////////////////////////////
// CF241_PXI5871BApp:
// See F241_PXI5871B.cpp for the implementation of this class
//

class CF241_PXI5871BApp : public CWinApp
{
public:
	CF241_PXI5871BApp();

// Overrides
	// ClassWizard generated virtual function overrides
	//{{AFX_VIRTUAL(CF241_PXI5871BApp)
	public:
	virtual BOOL InitInstance();
	//}}AFX_VIRTUAL

// Implementation

	//{{AFX_MSG(CF241_PXI5871BApp)
		// NOTE - the ClassWizard will add and remove member functions here.
		//    DO NOT EDIT what you see in these blocks of generated code !
	//}}AFX_MSG
	DECLARE_MESSAGE_MAP()
private:
	visa32_base visa32;
};

/////////////////////////////////////////////////////////////////////////////

//{{AFX_INSERT_LOCATION}}
// Microsoft Visual C++ will insert additional declarations immediately before the previous line.

#endif // !defined(AFX_F241_PXI5871B_H__E475E814_3DAD_444D_AB8C_AA5165E6A841__INCLUDED_)
