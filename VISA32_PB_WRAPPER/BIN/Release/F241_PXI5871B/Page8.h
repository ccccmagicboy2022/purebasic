#if !defined(AFX_PAGE8_H__EF0DE5B8_2626_4312_B4BB_D8AA325CF4F1__INCLUDED_)
#define AFX_PAGE8_H__EF0DE5B8_2626_4312_B4BB_D8AA325CF4F1__INCLUDED_

#if _MSC_VER > 1000
#pragma once
#endif // _MSC_VER > 1000
// Page8.h : header file
//

/////////////////////////////////////////////////////////////////////////////
// CPage8 dialog

class CPage8 : public CPropertyPage
{
	DECLARE_DYNCREATE(CPage8)

// Construction
public:
	CPage8();
	~CPage8();

// Dialog Data
	//{{AFX_DATA(CPage8)
	enum { IDD = IDD_DIALOG8 };
		// NOTE: the ClassWizard will add data members here
	//}}AFX_DATA


// Overrides
	// ClassWizard generated virtual function overrides
	//{{AFX_VIRTUAL(CPage8)
	public:
	virtual BOOL OnSetActive();
	protected:
	virtual void DoDataExchange(CDataExchange* pDX);    // DDX/DDV support
	//}}AFX_VIRTUAL

// Implementation
protected:

	// Generated message map functions
	//{{AFX_MSG(CPage8)
	virtual BOOL OnInitDialog();
	//}}AFX_MSG
	DECLARE_MESSAGE_MAP()
};

//{{AFX_INSERT_LOCATION}}
// Microsoft Visual C++ will insert additional declarations immediately before the previous line.

#endif // !defined(AFX_PAGE8_H__EF0DE5B8_2626_4312_B4BB_D8AA325CF4F1__INCLUDED_)
