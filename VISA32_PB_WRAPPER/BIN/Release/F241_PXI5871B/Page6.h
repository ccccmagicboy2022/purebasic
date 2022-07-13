#if !defined(AFX_PAGE6_H__B3A9607B_3712_4D81_9AB1_DC00784B3452__INCLUDED_)
#define AFX_PAGE6_H__B3A9607B_3712_4D81_9AB1_DC00784B3452__INCLUDED_

#if _MSC_VER > 1000
#pragma once
#endif // _MSC_VER > 1000
// Page6.h : header file
//

/////////////////////////////////////////////////////////////////////////////
// CPage6 dialog

class CPage6 : public CPropertyPage
{
	DECLARE_DYNCREATE(CPage6)

// Construction
public:
	CPage6();
	~CPage6();

// Dialog Data
	//{{AFX_DATA(CPage6)
	enum { IDD = IDD_DIALOG6 };
		// NOTE - ClassWizard will add data members here.
		//    DO NOT EDIT what you see in these blocks of generated code !
	//}}AFX_DATA


// Overrides
	// ClassWizard generate virtual function overrides
	//{{AFX_VIRTUAL(CPage6)
	public:
	virtual BOOL OnSetActive();
	protected:
	virtual void DoDataExchange(CDataExchange* pDX);    // DDX/DDV support
	//}}AFX_VIRTUAL

// Implementation
protected:
	// Generated message map functions
	//{{AFX_MSG(CPage6)
	virtual BOOL OnInitDialog();
	//}}AFX_MSG
	DECLARE_MESSAGE_MAP()

};

//{{AFX_INSERT_LOCATION}}
// Microsoft Visual C++ will insert additional declarations immediately before the previous line.

#endif // !defined(AFX_PAGE6_H__B3A9607B_3712_4D81_9AB1_DC00784B3452__INCLUDED_)
