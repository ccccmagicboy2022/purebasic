// F241_PXI5871BDlg.h : header file
//
//{{AFX_INCLUDES()
#include "_led.h"
//}}AFX_INCLUDES

#if !defined(AFX_F241_PXI5871BDLG_H__7A118105_409B_4F16_A9CF_31C6FD0F6FB2__INCLUDED_)
#define AFX_F241_PXI5871BDLG_H__7A118105_409B_4F16_A9CF_31C6FD0F6FB2__INCLUDED_

#include "PXI5871B.h"	// Added by ClassView
#if _MSC_VER > 1000
#pragma once
#endif // _MSC_VER > 1000

#include "Page1.h"
#include "Page2.h"
#include "Page3.h"
#include "Page4.h"
#include "Page5.h"
#include "Page6.h"
#include "Page7.h"

/////////////////////////////////////////////////////////////////////////////
// CF241_PXI5871BDlg dialog

class CF241_PXI5871BDlg : public CDialog
{
// Construction
public:
	~CF241_PXI5871BDlg();
	CF241_PXI5871BDlg(CWnd* pParent = NULL);	// standard constructor

// Dialog Data
	//{{AFX_DATA(CF241_PXI5871BDlg)
	enum { IDD = IDD_F241_PXI5871B_DIALOG };
	CLedButton	m_stop5;
	CLedButton	m_stop4;
	CLedButton	m_stop3;
	CLedButton	m_stop2;
	CLedButton	m_stop1;
	CLedButton	m_di0;
	CLedButton	m_health;
	C_LED	m_counter1;
	C_LED	m_counter2;
	C_LED	m_duty1;
	C_LED	m_duty2;
	C_LED	m_speed1;
	C_LED	m_speed2;
	C_LED	m_speed3;
	C_LED	m_speed4;
	C_LED	m_speed5;
	DWORD	m_pps_count1;
	DWORD	m_timer1;
	//}}AFX_DATA

	// ClassWizard generated virtual function overrides
	//{{AFX_VIRTUAL(CF241_PXI5871BDlg)
	public:
	virtual void WinHelp(DWORD dwData, UINT nCmd = HELP_CONTEXT);
	virtual BOOL PreTranslateMessage(MSG* pMsg);
	protected:
	virtual void DoDataExchange(CDataExchange* pDX);	// DDX/DDV support
	//}}AFX_VIRTUAL

// Implementation
protected:
	HICON m_hIcon;

	// Generated message map functions
	//{{AFX_MSG(CF241_PXI5871BDlg)
	virtual BOOL OnInitDialog();
	afx_msg void OnSysCommand(UINT nID, LPARAM lParam);
	afx_msg void OnPaint();
	afx_msg HCURSOR OnQueryDragIcon();
	afx_msg void OnSize(UINT nType, int cx, int cy);
	afx_msg void OnGetMinMaxInfo(MINMAXINFO FAR* lpMMI);
	afx_msg void OnTimer(UINT nIDEvent);
	afx_msg void OnMenuConfig();
	afx_msg void OnMenuAbout();
	afx_msg void OnMenuSelectCard();
	afx_msg void OnMenuCheckEep();
	afx_msg void OnMenuMem();
	afx_msg void OnMenuReset();
	afx_msg void OnCounter1Clear();
	afx_msg void OnCounter2Clear();
	afx_msg void OnMenuR1();
	afx_msg void OnMenuR2();
	afx_msg void OnMenuRemoteConfig();
	afx_msg void OnHealth();
	afx_msg void OnBnTxd1Buffer1();
	afx_msg void OnBnTxd1Buffer2();
	afx_msg void OnBnRxdBuffer();
	afx_msg void OnPpsClear1();
	afx_msg void OnMenuSerialLegend();
	//}}AFX_MSG
	DECLARE_MESSAGE_MAP()
public:
	void SetWinTransparency(int level);
	PXI5871B m_5871b;
	PXI5871B m_5871b_debug_mem;
	PXI5871B m_5871b_serial_data;
	BYTE m_last_config_page;
private:
	CToolTipCtrl m_tt;
	CStatusBar m_bar;
	//
};

//{{AFX_INSERT_LOCATION}}
// Microsoft Visual C++ will insert additional declarations immediately before the previous line.

extern	"C"	__declspec(dllimport) void	WINAPI	check_ocx();

extern	"C"	__declspec(dllimport) void	WINAPI	pxi5871_r_pinout_thread(int	model);

#endif // !defined(AFX_F241_PXI5871BDLG_H__7A118105_409B_4F16_A9CF_31C6FD0F6FB2__INCLUDED_)
