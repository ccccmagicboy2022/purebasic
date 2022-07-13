// Page8.cpp : implementation file
//

#include "stdafx.h"
#include "F241_PXI5871B.h"
#include "Page8.h"

#ifdef _DEBUG
#define new DEBUG_NEW
#undef THIS_FILE
static char THIS_FILE[] = __FILE__;
#endif

/////////////////////////////////////////////////////////////////////////////
// CPage8 property page

IMPLEMENT_DYNCREATE(CPage8, CPropertyPage)

CPage8::CPage8() : CPropertyPage(CPage8::IDD)
{
	//{{AFX_DATA_INIT(CPage8)
		// NOTE: the ClassWizard will add member initialization here
	//}}AFX_DATA_INIT
}

CPage8::~CPage8()
{
}

void CPage8::DoDataExchange(CDataExchange* pDX)
{
	CPropertyPage::DoDataExchange(pDX);
	//{{AFX_DATA_MAP(CPage8)
		// NOTE: the ClassWizard will add DDX and DDV calls here
	//}}AFX_DATA_MAP
}


BEGIN_MESSAGE_MAP(CPage8, CPropertyPage)
	//{{AFX_MSG_MAP(CPage8)
	//}}AFX_MSG_MAP
END_MESSAGE_MAP()

/////////////////////////////////////////////////////////////////////////////
// CPage8 message handlers
	

BOOL CPage8::OnInitDialog() 
{
	CPropertyPage::OnInitDialog();
	
	// TODO: Add extra initialization here	
	return TRUE;  // return TRUE unless you set the focus to a control
	              // EXCEPTION: OCX Property Pages should return FALSE
}

BOOL CPage8::OnSetActive() 
{
	// TODO: Add your specialized code here and/or call the base class
	CWnd* pHelpButton = GetParent()->GetDlgItem (IDHELP);
	pHelpButton->ShowWindow (SW_HIDE);
	
	return CPropertyPage::OnSetActive();
}
