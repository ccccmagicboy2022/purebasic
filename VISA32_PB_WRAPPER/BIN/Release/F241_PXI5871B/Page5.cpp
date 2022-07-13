// Page5.cpp : implementation file
//

#include "stdafx.h"
#include "F241_PXI5871B.h"
#include "Page5.h"

#ifdef _DEBUG
#define new DEBUG_NEW
#undef THIS_FILE
static char THIS_FILE[] = __FILE__;
#endif

/////////////////////////////////////////////////////////////////////////////
// CPage5 property page

IMPLEMENT_DYNCREATE(CPage5, CPropertyPage)

CPage5::CPage5() : CPropertyPage(CPage5::IDD)
{
	//{{AFX_DATA_INIT(CPage5)
		// NOTE: the ClassWizard will add member initialization here
	//}}AFX_DATA_INIT
}

CPage5::~CPage5()
{
}

void CPage5::DoDataExchange(CDataExchange* pDX)
{
	CPropertyPage::DoDataExchange(pDX);
	//{{AFX_DATA_MAP(CPage5)
		// NOTE: the ClassWizard will add DDX and DDV calls here
	//}}AFX_DATA_MAP
}


BEGIN_MESSAGE_MAP(CPage5, CPropertyPage)
	//{{AFX_MSG_MAP(CPage5)
	//}}AFX_MSG_MAP
END_MESSAGE_MAP()

/////////////////////////////////////////////////////////////////////////////
// CPage5 message handlers


BOOL CPage5::OnInitDialog() 
{
	CPropertyPage::OnInitDialog();
	
	// TODO: Add extra initialization here
	return TRUE;  // return TRUE unless you set the focus to a control
	              // EXCEPTION: OCX Property Pages should return FALSE
}

BOOL CPage5::OnSetActive() 
{
	// TODO: Add your specialized code here and/or call the base class
	CWnd* pHelpButton = GetParent()->GetDlgItem (IDHELP);
	pHelpButton->ShowWindow (SW_HIDE);
	
	return CPropertyPage::OnSetActive();
}
