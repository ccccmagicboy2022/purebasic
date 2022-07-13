// Page4.cpp : implementation file
//

#include "stdafx.h"
#include "F241_PXI5871B.h"
#include "Page4.h"
#include "F241_PXI5871BDlg.h"

#define	setbit(x,y) x|=(1<<y) 	//将X的第Y位置1
#define	clrbit(x,y) x&=~(1<<y)	//将X的第Y位清0
#define	getbit(x,y) x&(1<<y)?	1:	0	//将x的第Y位读出

#ifdef _DEBUG
#define new DEBUG_NEW
#undef THIS_FILE
static char THIS_FILE[] = __FILE__;
#endif

/////////////////////////////////////////////////////////////////////////////
// CPage4 property page

IMPLEMENT_DYNCREATE(CPage4, CPropertyPage)

CPage4::CPage4() : CPropertyPage(CPage4::IDD)
{
	//{{AFX_DATA_INIT(CPage4)
	m_txd_num = 0;
	//}}AFX_DATA_INIT
}

CPage4::~CPage4()
{
}

void CPage4::DoDataExchange(CDataExchange* pDX)
{
	CPropertyPage::DoDataExchange(pDX);
	//{{AFX_DATA_MAP(CPage4)
	DDX_Control(pDX, IDC_PARAM2, m_param2);
	DDX_Control(pDX, IDC_PARAM, m_param);
	DDX_Control(pDX, IDC_COMBO_TXD_BUFFER, m_txd_buffer_select);
	DDX_Control(pDX, IDC_COMBO_STOP_BIT, m_stopbit);
	DDX_Control(pDX, IDC_COMBO_PARITY_BIT, m_parity);
	DDX_Control(pDX, IDC_COMBO_BPS, m_bps);
	DDX_Text(pDX, IDC_TXD_NUM, m_txd_num);
	DDV_MinMaxUInt(pDX, m_txd_num, 0, 255);
	//}}AFX_DATA_MAP
}


BEGIN_MESSAGE_MAP(CPage4, CPropertyPage)
	//{{AFX_MSG_MAP(CPage4)
	ON_CBN_SELCHANGE(IDC_COMBO_BPS, OnSelchangeComboBps)
	ON_CBN_SELCHANGE(IDC_COMBO_PARITY_BIT, OnSelchangeComboParityBit)
	ON_CBN_SELCHANGE(IDC_COMBO_STOP_BIT, OnSelchangeComboStopBit)
	ON_CBN_SELCHANGE(IDC_COMBO_TXD_BUFFER, OnSelchangeComboTxdBuffer)
	ON_EN_CHANGE(IDC_TXD_NUM, OnChangeTxdNum)
	//}}AFX_MSG_MAP
END_MESSAGE_MAP()

/////////////////////////////////////////////////////////////////////////////
// CPage4 message handlers


BOOL CPage4::OnInitDialog() 
{
	CPropertyPage::OnInitDialog();
	
	// TODO: Add extra initialization here
	m_bps.AddString("115200 bps");
	m_bps.AddString("38400 bps");
	m_bps.AddString("9600 bps");

	m_parity.AddString("Even");
	m_parity.AddString("Odd");
	m_parity.AddString("None");

	m_stopbit.AddString("1bit");
	m_stopbit.AddString("2bits");

	m_txd_buffer_select.AddString(_T("buffer1"));
	m_txd_buffer_select.AddString(_T("buffer2"));

	m_param.SetValue(m_param_num, TRUE);
	m_param2.SetValue(m_param_num2, TRUE);

	DWORD	param_bps;
	
	param_bps	=	m_param_num	&	0xffff;
	switch (param_bps)
	{
	case 0x1B2:	//d434
		m_bps.SetCurSel(0);
		break;
	case 0x516:	//d1302
		m_bps.SetCurSel(1);
		break;
	case 0x1458://d5208
		m_bps.SetCurSel(2);
		break;
	}

	DWORD	param_parity;

	param_parity	=	(m_param_num	&	0x00030000)>>16;
	switch (param_parity)
	{
	case 0x0:	//none
		m_parity.SetCurSel(2);
		break;
	case 0x1:	//odd
		m_parity.SetCurSel(1);
		break;
	case 0x2:	//even
		m_parity.SetCurSel(0);
		break;
	}

	bool	param_stop;

	param_stop	=	getbit(m_param_num, 18);
	switch (param_stop)
	{
	case FALSE:
		m_stopbit.SetCurSel(0);
		break;
	case TRUE:
		m_stopbit.SetCurSel(1);
		break;
	}

	m_txd_num	=	m_param_num2	&	0x000000ff;

	bool	txd_param_buffer_select;
	txd_param_buffer_select	=	getbit(m_param_num2, 8);
	switch (txd_param_buffer_select)
	{
	case FALSE:
		m_txd_buffer_select.SetCurSel(0);
		break;
	case TRUE:
		m_txd_buffer_select.SetCurSel(1);
		break;
	}
	
	UpdateData(FALSE);

	return TRUE;  // return TRUE unless you set the focus to a control
	              // EXCEPTION: OCX Property Pages should return FALSE
}

BOOL CPage4::OnSetActive() 
{
	// TODO: Add your specialized code here and/or call the base class
	CWnd* pHelpButton = GetParent()->GetDlgItem (IDHELP);
	pHelpButton->ShowWindow (SW_HIDE);
	
	CF241_PXI5871BDlg* pDialog	=	(CF241_PXI5871BDlg*)AfxGetMainWnd();

	pDialog->m_last_config_page	=	4;

	return CPropertyPage::OnSetActive();
}

void CPage4::OnSelchangeComboBps() 
{
	// TODO: Add your control notification handler code here
	m_param_num	&=	0xffff0000;

	switch (m_bps.GetCurSel())
	{
	case 0:	//115200
		m_param_num	|=	0x1B2;
		break;
	case 1:
		m_param_num	|=	0x516;
		break;
	case 2:
		m_param_num	|=	0x1458;
		break;
	}
	m_param.SetValue(m_param_num, TRUE);
}

void CPage4::OnSelchangeComboParityBit() 
{
	// TODO: Add your control notification handler code here
	m_param_num	&=	0xfffcffff;

	switch (m_parity.GetCurSel())
	{
	case 0:	//even
		clrbit(m_param_num, 16);
		setbit(m_param_num, 17);
		break;
	case 1:	//odd
		setbit(m_param_num, 16);
		clrbit(m_param_num, 17);
		break;
	case 2:	//none
		clrbit(m_param_num, 16);
		clrbit(m_param_num, 17);
		break;
	}
	m_param.SetValue(m_param_num, TRUE);
}

void CPage4::OnSelchangeComboStopBit() 
{
	// TODO: Add your control notification handler code here
	switch (m_stopbit.GetCurSel())
	{
	case 0:	//1 bit
		clrbit(m_param_num, 18);
		break;
	case 1:	//2 bits
		setbit(m_param_num, 18);
		break;
	}
	m_param.SetValue(m_param_num, TRUE);
}

void CPage4::OnSelchangeComboTxdBuffer() 
{
	// TODO: Add your control notification handler code here
	switch (m_txd_buffer_select.GetCurSel())
	{
	case 0:	//buffer1
		clrbit(m_param_num2, 8);
		break;
	case 1:	//buffer2
		setbit(m_param_num2, 8);
		break;
	}
	m_param2.SetValue(m_param_num2, TRUE);	
}

void CPage4::OnChangeTxdNum() 
{
	// TODO: If this is a RICHEDIT control, the control will not
	// send this notification unless you override the CPropertyPage::OnInitDialog()
	// function and call CRichEditCtrl().SetEventMask()
	// with the ENM_CHANGE flag ORed into the mask.
	
	// TODO: Add your control notification handler code here
	UpdateData(TRUE);
	m_param_num2	&=	0xffffff00;
	m_param_num2	|=	m_txd_num;
	m_param2.SetValue(m_param_num2, TRUE);
}
