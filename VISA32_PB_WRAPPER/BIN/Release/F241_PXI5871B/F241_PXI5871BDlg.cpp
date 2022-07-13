// F241_PXI5871BDlg.cpp : implementation file
//

#include "stdafx.h"
#include "F241_PXI5871B.h"
#include "F241_PXI5871BDlg.h"
#include "MyConfigSheet.h"
#include "visa32_pb_wrapper/VISA32_PB_WRAPPER_KIT.h"
#include "visa/visa.h"
#include "VersionInfo.h"

#ifdef _DEBUG
#define new DEBUG_NEW
#undef THIS_FILE
static char THIS_FILE[] = __FILE__;
#endif


static UINT indicators[] =
{
	IDS_INDICATOR_MESSAGE,
	IDS_INDICATOR_TIME
};

/////////////////////////////////////////////////////////////////////////////
// CAboutDlg dialog used for App About

class CAboutDlg : public CDialog
{
public:
	CAboutDlg();

// Dialog Data
	//{{AFX_DATA(CAboutDlg)
	enum { IDD = IDD_ABOUTBOX };
	//}}AFX_DATA

	// ClassWizard generated virtual function overrides
	//{{AFX_VIRTUAL(CAboutDlg)
	protected:
	virtual void DoDataExchange(CDataExchange* pDX);    // DDX/DDV support
	//}}AFX_VIRTUAL

// Implementation
protected:
	//{{AFX_MSG(CAboutDlg)
	//}}AFX_MSG
	DECLARE_MESSAGE_MAP()
private:
	CString m_version;
};

CAboutDlg::CAboutDlg() : CDialog(CAboutDlg::IDD)
{
	//{{AFX_DATA_INIT(CAboutDlg)
	m_version = _T("");
	//}}AFX_DATA_INIT
	CVersionInfo	ver;
	ver.GetVersionInfo(AfxGetInstanceHandle());
	m_version	=	_T("版本 v") + ver.m_strFixedProductVersion;
}

void CAboutDlg::DoDataExchange(CDataExchange* pDX)
{
	CDialog::DoDataExchange(pDX);
	//{{AFX_DATA_MAP(CAboutDlg)
	DDX_Text(pDX, IDC_VERSION, m_version);
	//}}AFX_DATA_MAP
}

BEGIN_MESSAGE_MAP(CAboutDlg, CDialog)
	//{{AFX_MSG_MAP(CAboutDlg)
		// No message handlers
	//}}AFX_MSG_MAP
END_MESSAGE_MAP()

/////////////////////////////////////////////////////////////////////////////
// CF241_PXI5871BDlg dialog

CF241_PXI5871BDlg::CF241_PXI5871BDlg(CWnd* pParent /*=NULL*/)
	: CDialog(CF241_PXI5871BDlg::IDD, pParent)
{
	//{{AFX_DATA_INIT(CF241_PXI5871BDlg)
	m_pps_count1 = 0;
	m_timer1 = 0;
	//}}AFX_DATA_INIT
	// Note that LoadIcon does not require a subsequent DestroyIcon in Win32
	m_hIcon = AfxGetApp()->LoadIcon(IDR_MAINFRAME);
}

void CF241_PXI5871BDlg::DoDataExchange(CDataExchange* pDX)
{
	CDialog::DoDataExchange(pDX);
	//{{AFX_DATA_MAP(CF241_PXI5871BDlg)
	DDX_Control(pDX, IDC_STOP5, m_stop5);
	DDX_Control(pDX, IDC_STOP4, m_stop4);
	DDX_Control(pDX, IDC_STOP3, m_stop3);
	DDX_Control(pDX, IDC_STOP2, m_stop2);
	DDX_Control(pDX, IDC_STOP1, m_stop1);
	DDX_Control(pDX, IDC_LED_DI0, m_di0);
	DDX_Control(pDX, IDC_HEALTH, m_health);
	DDX_Control(pDX, IDC_COUNTER1, m_counter1);
	DDX_Control(pDX, IDC_COUNTER2, m_counter2);
	DDX_Control(pDX, IDC_DUTY1, m_duty1);
	DDX_Control(pDX, IDC_DUTY2, m_duty2);
	DDX_Control(pDX, IDC_SPEED1, m_speed1);
	DDX_Control(pDX, IDC_SPEED2, m_speed2);
	DDX_Control(pDX, IDC_SPEED3, m_speed3);
	DDX_Control(pDX, IDC_SPEED4, m_speed4);
	DDX_Control(pDX, IDC_SPEED5, m_speed5);
	DDX_Text(pDX, IDC_PPS_COUNT1, m_pps_count1);
	DDX_Text(pDX, IDC_TIMER1, m_timer1);
	//}}AFX_DATA_MAP
}

BEGIN_MESSAGE_MAP(CF241_PXI5871BDlg, CDialog)
	//{{AFX_MSG_MAP(CF241_PXI5871BDlg)
	ON_WM_SYSCOMMAND()
	ON_WM_PAINT()
	ON_WM_QUERYDRAGICON()
	ON_WM_SIZE()
	ON_WM_GETMINMAXINFO()
	ON_WM_TIMER()
	ON_COMMAND(ID_MENU_CONFIG, OnMenuConfig)
	ON_COMMAND(ID_MENU_ABOUT, OnMenuAbout)
	ON_COMMAND(ID_MENU_SELECT_CARD, OnMenuSelectCard)
	ON_COMMAND(ID_MENU_CHECK_EEP, OnMenuCheckEep)
	ON_COMMAND(ID_MENU_MEM, OnMenuMem)
	ON_COMMAND(ID_MENU_RESET, OnMenuReset)
	ON_BN_CLICKED(IDC_COUNTER1_CLEAR, OnCounter1Clear)
	ON_BN_CLICKED(IDC_COUNTER2_CLEAR, OnCounter2Clear)
	ON_COMMAND(ID_MENU_R1, OnMenuR1)
	ON_COMMAND(ID_MENU_R2, OnMenuR2)
	ON_COMMAND(ID_MENU_REMOTE_CONFIG, OnMenuRemoteConfig)
	ON_BN_CLICKED(IDC_HEALTH, OnHealth)
	ON_BN_CLICKED(IDC_BN_TXD1_BUFFER1, OnBnTxd1Buffer1)
	ON_BN_CLICKED(IDC_BN_TXD1_BUFFER2, OnBnTxd1Buffer2)
	ON_BN_CLICKED(IDC_BN_RXD_BUFFER, OnBnRxdBuffer)
	ON_BN_CLICKED(IDC_PPS_CLEAR1, OnPpsClear1)
	ON_COMMAND(ID_MENU_SERIAL_LEGEND, OnMenuSerialLegend)
	//}}AFX_MSG_MAP
END_MESSAGE_MAP()

/////////////////////////////////////////////////////////////////////////////
// CF241_PXI5871BDlg message handlers

BOOL CF241_PXI5871BDlg::OnInitDialog()
{
	CDialog::OnInitDialog();

	// Add "About..." menu item to system menu.

	// IDM_ABOUTBOX must be in the system command range.
	ASSERT((IDM_ABOUTBOX & 0xFFF0) == IDM_ABOUTBOX);
	ASSERT(IDM_ABOUTBOX < 0xF000);

	CMenu* pSysMenu = GetSystemMenu(FALSE);
	if (pSysMenu != NULL)
	{
		CString strAboutMenu;
		strAboutMenu.LoadString(IDS_ABOUTBOX);
		if (!strAboutMenu.IsEmpty())
		{
			pSysMenu->AppendMenu(MF_SEPARATOR);
			pSysMenu->AppendMenu(MF_STRING, IDM_ABOUTBOX, strAboutMenu);
		}
	}

	// Set the icon for this dialog.  The framework does this automatically
	//  when the application's main window is not a dialog
	SetIcon(m_hIcon, TRUE);			// Set big icon
	SetIcon(m_hIcon, FALSE);		// Set small icon
	
	// TODO: Add extra initialization here
	m_di0.SetIcons(IDI_ICON_GRAY, IDI_ICON_GREEN);
	m_health.SetIcons(IDI_ICON_CARD_GRAY, IDI_ICON_CARD);
	m_stop1.SetIcons(IDI_ICON_NEW_GRAY, IDI_ICON_NEW_RED);
	m_stop2.SetIcons(IDI_ICON_NEW_GRAY, IDI_ICON_NEW_RED);
	m_stop3.SetIcons(IDI_ICON_NEW_GRAY, IDI_ICON_NEW_RED);
	m_stop4.SetIcons(IDI_ICON_NEW_GRAY, IDI_ICON_NEW_RED);
	m_stop5.SetIcons(IDI_ICON_NEW_GRAY, IDI_ICON_NEW_RED);

	CMenu*	pMenu	=	GetMenu();
	pMenu->EnableMenuItem(ID_MENU_CONFIG, MF_GRAYED);
	pMenu->EnableMenuItem(ID_MENU_MEM, MF_GRAYED);
	pMenu->EnableMenuItem(ID_MENU_RESET, MF_GRAYED);
	pMenu->EnableMenuItem(ID_MENU_CHECK_EEP, MF_GRAYED);
	AfxGetMainWnd()->DrawMenuBar();

	m_bar.Create(this); //We create the state bar
	m_bar.SetIndicators(indicators, 2); //Set the number of panes
	CRect rect;
	GetClientRect(&rect);
	m_bar.SetPaneInfo(0, IDS_INDICATOR_MESSAGE, SBPS_NORMAL, rect.Width() - 100);      
	m_bar.SetPaneInfo(1, IDS_INDICATOR_TIME, SBPS_STRETCH, 0);
	//显示状态栏
	RepositionBars(AFX_IDW_CONTROLBAR_FIRST, AFX_IDW_CONTROLBAR_LAST, IDS_INDICATOR_TIME);
	m_bar.SetPaneText(0, _T("cccc"), TRUE);

	SetTimer(1, 10, NULL);//ram0_1区，电平量检测
	SetTimer(2, 30, NULL);//ram0_1区，脉冲计数
	SetTimer(3, 1000, NULL);//状态栏的显示
	SetTimer(4, 100, NULL);

	SetWinTransparency(88);

	EnableToolTips(TRUE);
	m_tt.Create(this);
	m_tt.Activate(TRUE);
	m_tt.SetTipTextColor(RGB(0,0,255));
	m_tt.SetDelayTime(500);
	m_tt.SetMaxTipWidth(100);

	m_tt.AddTool(GetDlgItem(IDC_HEALTH), _T("板卡健康标志\n板卡图标为彩色时证明板卡正常。"));
	m_tt.AddTool(GetDlgItem(IDC_COUNTER1_CLEAR), _T("计数器1清0"));
	m_tt.AddTool(GetDlgItem(IDC_COUNTER2_CLEAR), _T("计数器2清0"));

	return TRUE;  // return TRUE  unless you set the focus to a control
}

void CF241_PXI5871BDlg::OnSysCommand(UINT nID, LPARAM lParam)
{
	if ((nID & 0xFFF0) == IDM_ABOUTBOX)
	{
		CAboutDlg dlgAbout;
		dlgAbout.DoModal();
	}
	else
	{
		CDialog::OnSysCommand(nID, lParam);
	}
}

// If you add a minimize button to your dialog, you will need the code below
//  to draw the icon.  For MFC applications using the document/view model,
//  this is automatically done for you by the framework.

void CF241_PXI5871BDlg::OnPaint() 
{
	if (IsIconic())
	{
		CPaintDC dc(this); // device context for painting

		SendMessage(WM_ICONERASEBKGND, (WPARAM) dc.GetSafeHdc(), 0);

		// Center icon in client rectangle
		int cxIcon = GetSystemMetrics(SM_CXICON);
		int cyIcon = GetSystemMetrics(SM_CYICON);
		CRect rect;
		GetClientRect(&rect);
		int x = (rect.Width() - cxIcon + 1) / 2;
		int y = (rect.Height() - cyIcon + 1) / 2;

		// Draw the icon
		dc.DrawIcon(x, y, m_hIcon);
	}
	else
	{
		CDialog::OnPaint();
	}
}

// The system calls this to obtain the cursor to display while the user drags
//  the minimized window.
HCURSOR CF241_PXI5871BDlg::OnQueryDragIcon()
{
	return (HCURSOR) m_hIcon;
}

CF241_PXI5871BDlg::~CF241_PXI5871BDlg()
{
	m_5871b.release();
}

void CF241_PXI5871BDlg::OnSize(UINT nType, int cx, int cy) 
{
	CDialog::OnSize(nType, cx, cy);
	
	// TODO: Add your message handler code here
	
}

void CF241_PXI5871BDlg::OnGetMinMaxInfo(MINMAXINFO *lpMMI)
{
	CPoint   pt(800, 600); //定义宽和高  
	lpMMI-> ptMinTrackSize=pt; //限制最小宽和高  
	CDialog::OnGetMinMaxInfo(lpMMI);  
}

void CF241_PXI5871BDlg::OnTimer(UINT nIDEvent) 
{
	VARIANT	temp;
	temp.vt	=	VT_I4;
	
	CTime t1;		//显示时间

	// TODO: Add your message handler code here and/or call default
	if (m_health.GetLedState())
	{
		switch (nIDEvent)
		{
		case 1:	
			//电平量
			m_di0.SetLedState(m_5871b.get_bit_state(0));
			//CMG停止标志
			m_stop1.SetLedState(m_5871b.get_stop_state(0));
			m_stop2.SetLedState(m_5871b.get_stop_state(1));
			m_stop3.SetLedState(m_5871b.get_stop_state(2));
			m_stop4.SetLedState(m_5871b.get_stop_state(3));
			m_stop5.SetLedState(m_5871b.get_stop_state(4));
			break;
		case 2:
			temp.lVal	=	m_5871b.get_counter(0);
			m_counter1.SetNumber(&temp);
			temp.lVal	=	m_5871b.get_counter(1);
			m_counter2.SetNumber(&temp);

			temp.lVal	=	m_5871b.get_duty(0);
			m_duty1.SetNumber(&temp);
			temp.lVal	=	m_5871b.get_duty(1);
			m_duty2.SetNumber(&temp);

			m_pps_count1	=	m_5871b.get_counter(2);
			m_timer1	=	m_5871b.get_freetimer_value(0);
			UpdateData(FALSE);

			break;
		case 3:
			t1 = CTime::GetCurrentTime();
			m_bar.SetPaneText(1,t1.Format("%H:%M:%S"));
			break;
		case 4:
			//CMG1
			temp.lVal	=	m_5871b.get_rpm(0);
			m_speed1.SetNumber(&temp);
			//CMG2
			temp.lVal	=	m_5871b.get_rpm(1);
			m_speed2.SetNumber(&temp);
			//CMG3
			temp.lVal	=	m_5871b.get_rpm(2);
			m_speed3.SetNumber(&temp);
			//CMG4
			temp.lVal	=	m_5871b.get_rpm(3);
			m_speed4.SetNumber(&temp);
			//CMG5
			temp.lVal	=	m_5871b.get_rpm(4);
			m_speed5.SetNumber(&temp);
			break;
		}
	}

	CDialog::OnTimer(nIDEvent);
}

void CF241_PXI5871BDlg::OnMenuConfig() 
{
	// TODO: Add your command handler code here
	CMyConfigSheet	dlg(_T("参数设置"), this, m_last_config_page);

	dlg.m_page2.m_enable1	=	m_5871b.get_enable_state(0);
	dlg.m_page2.m_enable2	=	m_5871b.get_enable_state(1);

	dlg.m_page3.m_enable1	=	m_5871b.get_enable_state(2);
	dlg.m_page3.m_enable2	=	m_5871b.get_enable_state(3);
	
	dlg.m_page4.m_param_num	=	m_5871b.get_serial_param(0);	//星敏3模拟器串口参数，波特、停止、校验位等
	dlg.m_page4.m_param_num2	=	m_5871b.get_serial_txd_param(0);//星敏3模拟器txd的参数

	if (dlg.DoModal()	==	IDOK)
	{
		m_5871b.set_enable_state(0, dlg.m_page2.m_enable1);
		m_5871b.set_enable_state(1, dlg.m_page2.m_enable2);

		m_5871b.set_enable_state(2, dlg.m_page3.m_enable1);
		m_5871b.set_enable_state(3, dlg.m_page3.m_enable2);
		
		m_5871b.set_serial_param(0, dlg.m_page4.m_param_num);
		m_5871b.set_serial_txd_param(0, dlg.m_page4.m_param_num2);
	}
}

void CF241_PXI5871BDlg::OnMenuAbout() 
{
	// TODO: Add your command handler code here
	CAboutDlg	dlg;
	dlg.DoModal();
}

void CF241_PXI5871BDlg::OnMenuSelectCard() 
{
	// TODO: Add your command handler code here
	int	result;
	CString	temp;
	CString temp2;
	CString	temp3;

	result	=	m_5871b.select_visa_pci_pxi_card();
	
	CMenu*	pMenu	=	GetMenu();

	if (result)
	{
		m_5871b.release();
		m_health.SetLedState(m_5871b.init());
		temp3.Format("%08x", m_5871b.get_card_res());
		temp3.MakeUpper();
		temp3	=	"0x"	+	temp3;
		m_health.SetWindowText(temp3);
		temp2.Format("%d", m_5871b.get_card_slot());
		this->SetWindowText(temp + "F241_PXI5871B@" + m_5871b.get_card_rscs() + "@SLOT" + temp2);
		
		pMenu->EnableMenuItem(ID_MENU_CONFIG, MF_ENABLED);
		pMenu->EnableMenuItem(ID_MENU_MEM, MF_ENABLED);
		pMenu->EnableMenuItem(ID_MENU_RESET, MF_ENABLED);
		pMenu->EnableMenuItem(ID_MENU_CHECK_EEP, MF_ENABLED);
		AfxGetMainWnd()->DrawMenuBar();//refresh menu
	}
	else
	{
		AfxMessageBox("rscs error!", MB_OK|MB_SYSTEMMODAL|MB_ICONERROR);
		m_health.SetLedState(FALSE);
		m_health.SetWindowText("error");

		pMenu->EnableMenuItem(ID_MENU_CONFIG, MF_GRAYED);
		pMenu->EnableMenuItem(ID_MENU_MEM, MF_GRAYED);
		pMenu->EnableMenuItem(ID_MENU_RESET, MF_GRAYED);
		pMenu->EnableMenuItem(ID_MENU_CHECK_EEP, MF_GRAYED);
		AfxGetMainWnd()->DrawMenuBar();//refresh menu
	}	
}

void CF241_PXI5871BDlg::WinHelp(DWORD dwData, UINT nCmd) 
{
	// TODO: Add your specialized code here and/or call the base class
	CAboutDlg	dlg;
	dlg.DoModal();
}

void CF241_PXI5871BDlg::OnMenuCheckEep() 
{
	// TODO: Add your command handler code here
	if (m_5871b.check_plx9054_eeprom_is_cv_style())
	{
		AfxMessageBox("OK!");
	}
	else
	{
		int	result;
		result	=	AfxMessageBox(_T("非法EEPROM内容，是否更新?"), MB_YESNO|MB_SYSTEMMODAL|MB_ICONQUESTION);
		switch (result)
		{
		case IDYES:
			m_5871b.burn_cv_style_eeprom_for_this_plx9054();
			break;
		case IDNO:
			break;
		}
	}
	
}

void CF241_PXI5871BDlg::OnMenuMem() 
{
	m_5871b_debug_mem	=	m_5871b;

	int	result;
	result	=	m_5871b_debug_mem.select_ram0();
	if (result)
	{
		m_5871b_debug_mem.set_win_x(100);
		m_5871b_debug_mem.set_win_y(100);
		VISA32_PB_WRAPPER_KIT::pxi_block_access_thread(m_5871b_debug_mem);
	} 
	else
	{
		//
	}
}

void CF241_PXI5871BDlg::OnMenuReset() 
{
	// TODO: Add your command handler code here
	m_5871b.plx9054_reset_card();
}

void CF241_PXI5871BDlg::OnCounter1Clear() 
{
	// TODO: Add your control notification handler code here
	if (m_health.GetLedState())
	{
		m_5871b.clear_counter(0);
	}
}

void CF241_PXI5871BDlg::OnCounter2Clear() 
{
	// TODO: Add your control notification handler code here
	if (m_health.GetLedState())
	{
		m_5871b.clear_counter(1);
	}	
}

void CF241_PXI5871BDlg::SetWinTransparency(int level)
{
	if (level	>=	0 &&	level<101)
	{
		SetWindowLong(this->GetSafeHwnd(), GWL_EXSTYLE, GetWindowLong(this->GetSafeHwnd(), GWL_EXSTYLE)^0x80000);
		HINSTANCE hInst = LoadLibrary("User32.DLL");
		if(hInst) 
		{ 
		typedef BOOL (WINAPI *MYFUNC)(HWND,COLORREF,BYTE,DWORD); 
		MYFUNC fun = NULL;
		//取得SetLayeredWindowAttributes函数指针 
		fun=(MYFUNC)GetProcAddress(hInst, "SetLayeredWindowAttributes");
		if(fun)fun(this->GetSafeHwnd(), 0, 255*level/100, 2); //128为半透明，0为完全透明
		FreeLibrary(hInst);
		}
	}
}

void CF241_PXI5871BDlg::OnMenuR1() 
{
	// TODO: Add your command handler code here
	pxi5871_r_pinout_thread(1);
	Sleep(100);
	pxi5871_r_pinout_thread(0);
}

void CF241_PXI5871BDlg::OnMenuR2() 
{
	// TODO: Add your command handler code here
	pxi5871_r_pinout_thread(3);
	Sleep(100);
	pxi5871_r_pinout_thread(2);	
}

void CF241_PXI5871BDlg::OnMenuRemoteConfig() 
{
	// TODO: Add your command handler code here
	VISA32_PB_WRAPPER_KIT::visa_remote_system_editor_thread();
}

void CF241_PXI5871BDlg::OnHealth() 
{
	// TODO: Add your control notification handler code here
	if (m_health.GetLedState())
	{
		m_5871b.plx9054_reset_card();
	}
}

BOOL CF241_PXI5871BDlg::PreTranslateMessage(MSG* pMsg) 
{
	// TODO: Add your specialized code here and/or call the base class
	m_tt.RelayEvent(pMsg);

	return CDialog::PreTranslateMessage(pMsg);
}

void CF241_PXI5871BDlg::OnBnTxd1Buffer1() 
{
	if (m_health.GetLedState())
	{
		m_5871b_serial_data	=	m_5871b;
		m_5871b_serial_data.set_mem_offset(0x1D00);
		m_5871b_serial_data.set_mem_size(0x100);
		m_5871b_serial_data.set_win_title("txd buffer2");
		VISA32_PB_WRAPPER_KIT::pxi_block_access_thread(m_5871b_serial_data);
	}
}

void CF241_PXI5871BDlg::OnBnTxd1Buffer2() 
{
	if (m_health.GetLedState())
	{
		m_5871b_serial_data	=	m_5871b;
		m_5871b_serial_data.set_mem_offset(0x1E00);
		m_5871b_serial_data.set_mem_size(0x100);
		m_5871b_serial_data.set_win_title("txd buffer2");
		VISA32_PB_WRAPPER_KIT::pxi_block_access_thread(m_5871b_serial_data);
	}	
}

void CF241_PXI5871BDlg::OnBnRxdBuffer() 
{
	if (m_health.GetLedState())
	{
		m_5871b_serial_data	=	m_5871b;
		m_5871b_serial_data.set_mem_offset(0xC00);
		m_5871b_serial_data.set_mem_size(0x100);
		m_5871b_serial_data.set_win_title("rxd buffer");
		VISA32_PB_WRAPPER_KIT::pxi_block_access_thread(m_5871b_serial_data);
	}	
}

void CF241_PXI5871BDlg::OnPpsClear1() 
{
	// TODO: Add your control notification handler code here
	m_5871b.clear_counter(2);
}

void CF241_PXI5871BDlg::OnMenuSerialLegend() 
{
	// TODO: Add your command handler code here
	pxi5871_r_pinout_thread(4);
}
