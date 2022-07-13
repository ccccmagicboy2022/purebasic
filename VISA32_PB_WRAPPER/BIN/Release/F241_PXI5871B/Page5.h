#if !defined(AFX_PAGE5_H__15D1DB2F_FCF0_4488_849E_91C3F60BE151__INCLUDED_)
#define AFX_PAGE5_H__15D1DB2F_FCF0_4488_849E_91C3F60BE151__INCLUDED_

#if _MSC_VER > 1000
#pragma once
#endif // _MSC_VER > 1000
// Page5.h : header file
//

/////////////////////////////////////////////////////////////////////////////
// CPage5 dialog

class CPage5 : public CPropertyPage
{
	DECLARE_DYNCREATE(CPage5)

// Construction
public:
	CPage5();
	~CPage5();

// Dialog Data
	//{{AFX_DATA(CPage5)
	enum { IDD = IDD_DIALOG5 };
		// NOTE - ClassWizard will add data members here.
		//    DO NOT EDIT what you see in these blocks of generated code !
	//}}AFX_DATA


// Overrides
	// ClassWizard generate virtual function overrides
	//{{AFX_VIRTUAL(CPage5)
	public:
	virtual BOOL OnSetActive();
	protected:
	virtual void DoDataExchange(CDataExchange* pDX);    // DDX/DDV support
	//}}AFX_VIRTUAL

// Implementation
protected:
	// Generated message map functions
	//{{AFX_MSG(CPage5)
	virtual BOOL OnInitDialog();
	//}}AFX_MSG
	DECLARE_MESSAGE_MAP()

};

//{{AFX_INSERT_LOCATION}}
// Microsoft Visual C++ will insert additional declarations immediately before the previous line.

#endif // !defined(AFX_PAGE5_H__15D1DB2F_FCF0_4488_849E_91C3F60BE151__INCLUDED_)
