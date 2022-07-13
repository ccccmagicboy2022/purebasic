#if !defined(AFX_PAGE4_H__EC0636F6_96A1_4A7E_965A_CEF85F59ECA2__INCLUDED_)
#define AFX_PAGE4_H__EC0636F6_96A1_4A7E_965A_CEF85F59ECA2__INCLUDED_

#if _MSC_VER > 1000
#pragma once
#endif // _MSC_VER > 1000
// Page4.h : header file
//

/////////////////////////////////////////////////////////////////////////////
// CPage4 dialog
#include "HexEdit.h"

class CPage4 : public CPropertyPage
{
	DECLARE_DYNCREATE(CPage4)

// Construction
public:
	DWORD m_param_num;		//串口的参数
	WORD	m_param_num2;	//txd的参数
	CPage4();
	~CPage4();

// Dialog Data
	//{{AFX_DATA(CPage4)
	enum { IDD = IDD_DIALOG4 };
	CHexEdit	m_param2;
	CHexEdit	m_param;
	CComboBox	m_txd_buffer_select;
	CComboBox	m_stopbit;
	CComboBox	m_parity;
	CComboBox	m_bps;
	BYTE	m_txd_num;
	//}}AFX_DATA


// Overrides
	// ClassWizard generate virtual function overrides
	//{{AFX_VIRTUAL(CPage4)
	public:
	virtual BOOL OnSetActive();
	protected:
	virtual void DoDataExchange(CDataExchange* pDX);    // DDX/DDV support
	//}}AFX_VIRTUAL

// Implementation
protected:
	// Generated message map functions
	//{{AFX_MSG(CPage4)
	virtual BOOL OnInitDialog();
	afx_msg void OnSelchangeComboBps();
	afx_msg void OnSelchangeComboParityBit();
	afx_msg void OnSelchangeComboStopBit();
	afx_msg void OnSelchangeComboTxdBuffer();
	afx_msg void OnChangeTxdNum();
	//}}AFX_MSG
	DECLARE_MESSAGE_MAP()

};

//{{AFX_INSERT_LOCATION}}
// Microsoft Visual C++ will insert additional declarations immediately before the previous line.

#endif // !defined(AFX_PAGE4_H__EC0636F6_96A1_4A7E_965A_CEF85F59ECA2__INCLUDED_)
