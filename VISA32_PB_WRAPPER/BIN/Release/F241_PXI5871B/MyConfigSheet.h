#if !defined(AFX_MYCONFIGSHEET_H__E6CD1B0F_43B6_4BD0_AF97_4BCAC4C3E87E__INCLUDED_)
#define AFX_MYCONFIGSHEET_H__E6CD1B0F_43B6_4BD0_AF97_4BCAC4C3E87E__INCLUDED_

#if _MSC_VER > 1000
#pragma once
#endif // _MSC_VER > 1000
// MyConfigSheet.h : header file
//
#include "Page1.h"
#include "Page2.h"
#include "Page3.h"
#include "Page4.h"
#include "Page5.h"
#include "Page6.h"
#include "Page7.h"
#include "Page8.h"

/////////////////////////////////////////////////////////////////////////////
// CMyConfigSheet

class CMyConfigSheet : public CPropertySheet
{
	DECLARE_DYNAMIC(CMyConfigSheet)

// Construction
public:
	CMyConfigSheet(UINT nIDCaption, CWnd* pParentWnd = NULL, UINT iSelectPage = 0);
	CMyConfigSheet(LPCTSTR pszCaption, CWnd* pParentWnd = NULL, UINT iSelectPage = 0);

// Attributes
public:
	CPage1 m_page1;
	CPage2 m_page2;
	CPage3 m_page3;
	CPage4 m_page4;
	CPage5 m_page5;
	CPage6 m_page6;
	CPage7 m_page7;
// Operations
public:

// Overrides
	// ClassWizard generated virtual function overrides
	//{{AFX_VIRTUAL(CMyConfigSheet)
	public:
	virtual BOOL OnInitDialog();
	//}}AFX_VIRTUAL

// Implementation
public:
	CPage8 m_page8;
	virtual ~CMyConfigSheet();

	// Generated message map functions
protected:
	//{{AFX_MSG(CMyConfigSheet)
		// NOTE - the ClassWizard will add and remove member functions here.
	//}}AFX_MSG
	DECLARE_MESSAGE_MAP()
};

/////////////////////////////////////////////////////////////////////////////

//{{AFX_INSERT_LOCATION}}
// Microsoft Visual C++ will insert additional declarations immediately before the previous line.

#endif // !defined(AFX_MYCONFIGSHEET_H__E6CD1B0F_43B6_4BD0_AF97_4BCAC4C3E87E__INCLUDED_)
