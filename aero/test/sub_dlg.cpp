// sub_dlg.cpp : implementation file
//

#include "stdafx.h"
#include "test.h"
#include "sub_dlg.h"
#include "..\aero.h"

#ifdef _DEBUG
#define new DEBUG_NEW
#undef THIS_FILE
static char THIS_FILE[] = __FILE__;
#endif

/////////////////////////////////////////////////////////////////////////////
// Csub_dlg dialog


Csub_dlg::Csub_dlg(CWnd* pParent /*=NULL*/)
	: CDialog(Csub_dlg::IDD, pParent)
{
	//{{AFX_DATA_INIT(Csub_dlg)
		// NOTE: the ClassWizard will add member initialization here
	//}}AFX_DATA_INIT
}


void Csub_dlg::DoDataExchange(CDataExchange* pDX)
{
	CDialog::DoDataExchange(pDX);
	//{{AFX_DATA_MAP(Csub_dlg)
		// NOTE: the ClassWizard will add DDX and DDV calls here
	//}}AFX_DATA_MAP
}


BEGIN_MESSAGE_MAP(Csub_dlg, CDialog)
	//{{AFX_MSG_MAP(Csub_dlg)
	ON_BN_CLICKED(IDC_BUTTON1, OnButton1)
	//}}AFX_MSG_MAP
END_MESSAGE_MAP()

/////////////////////////////////////////////////////////////////////////////
// Csub_dlg message handlers

void Csub_dlg::OnButton1() 
{
	// TODO: Add your control notification handler code here
	aero_remove(GetSafeHwnd());
}

BOOL Csub_dlg::OnInitDialog() 
{
	CDialog::OnInitDialog();
	
	// TODO: Add extra initialization here
	aero_apply(GetSafeHwnd(), 10, 10, 10, 10);


	return TRUE;  // return TRUE unless you set the focus to a control
	              // EXCEPTION: OCX Property Pages should return FALSE
}
