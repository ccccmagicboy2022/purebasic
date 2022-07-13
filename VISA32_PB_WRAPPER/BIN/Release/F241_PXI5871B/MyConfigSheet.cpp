// MyConfigSheet.cpp : implementation file
//

#include "stdafx.h"
#include "F241_PXI5871B.h"
#include "MyConfigSheet.h"

#ifdef _DEBUG
#define new DEBUG_NEW
#undef THIS_FILE
static char THIS_FILE[] = __FILE__;
#endif

/////////////////////////////////////////////////////////////////////////////
// CMyConfigSheet

IMPLEMENT_DYNAMIC(CMyConfigSheet, CPropertySheet)

CMyConfigSheet::CMyConfigSheet(UINT nIDCaption, CWnd* pParentWnd, UINT iSelectPage)
	:CPropertySheet(nIDCaption, pParentWnd, iSelectPage)
{
	AddPage(&m_page1);
	AddPage(&m_page2);
	AddPage(&m_page3);
	AddPage(&m_page8);	//CMG
	AddPage(&m_page4);
	AddPage(&m_page5);
	AddPage(&m_page6);
	AddPage(&m_page7);
	m_psh.dwFlags |= PSH_NOAPPLYNOW;
}

CMyConfigSheet::CMyConfigSheet(LPCTSTR pszCaption, CWnd* pParentWnd, UINT iSelectPage)
	:CPropertySheet(pszCaption, pParentWnd, iSelectPage)
{
	AddPage(&m_page1);
	AddPage(&m_page2);
	AddPage(&m_page3);
	AddPage(&m_page8);	//CMG
	AddPage(&m_page4);
	AddPage(&m_page5);
	AddPage(&m_page6);
	AddPage(&m_page7);
	m_psh.dwFlags |= PSH_NOAPPLYNOW;
}

CMyConfigSheet::~CMyConfigSheet()
{
}


BEGIN_MESSAGE_MAP(CMyConfigSheet, CPropertySheet)
	//{{AFX_MSG_MAP(CMyConfigSheet)
		// NOTE - the ClassWizard will add and remove mapping macros here.
	//}}AFX_MSG_MAP
END_MESSAGE_MAP()

/////////////////////////////////////////////////////////////////////////////
// CMyConfigSheet message handlers

BOOL CMyConfigSheet::OnInitDialog() 
{
	BOOL bResult = CPropertySheet::OnInitDialog();
	
	// TODO: Add your specialized code here

	return bResult;
}
