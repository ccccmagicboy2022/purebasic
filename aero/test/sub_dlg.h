#if !defined(AFX_SUB_DLG_H__CC4487AE_9D8C_44F4_92DB_06EBB64292CE__INCLUDED_)
#define AFX_SUB_DLG_H__CC4487AE_9D8C_44F4_92DB_06EBB64292CE__INCLUDED_

#if _MSC_VER > 1000
#pragma once
#endif // _MSC_VER > 1000
// sub_dlg.h : header file
//

/////////////////////////////////////////////////////////////////////////////
// Csub_dlg dialog

class Csub_dlg : public CDialog
{
// Construction
public:
	Csub_dlg(CWnd* pParent = NULL);   // standard constructor

// Dialog Data
	//{{AFX_DATA(Csub_dlg)
	enum { IDD = IDD_DIALOG1 };
		// NOTE: the ClassWizard will add data members here
	//}}AFX_DATA


// Overrides
	// ClassWizard generated virtual function overrides
	//{{AFX_VIRTUAL(Csub_dlg)
	protected:
	virtual void DoDataExchange(CDataExchange* pDX);    // DDX/DDV support
	//}}AFX_VIRTUAL

// Implementation
protected:

	// Generated message map functions
	//{{AFX_MSG(Csub_dlg)
	afx_msg void OnButton1();
	virtual BOOL OnInitDialog();
	//}}AFX_MSG
	DECLARE_MESSAGE_MAP()
};

//{{AFX_INSERT_LOCATION}}
// Microsoft Visual C++ will insert additional declarations immediately before the previous line.

#endif // !defined(AFX_SUB_DLG_H__CC4487AE_9D8C_44F4_92DB_06EBB64292CE__INCLUDED_)
