#if !defined(AFX_PAGE7_H__316247F8_3469_407A_A095_AEC88CAB27D6__INCLUDED_)
#define AFX_PAGE7_H__316247F8_3469_407A_A095_AEC88CAB27D6__INCLUDED_

#if _MSC_VER > 1000
#pragma once
#endif // _MSC_VER > 1000
// Page7.h : header file
//

/////////////////////////////////////////////////////////////////////////////
// CPage7 dialog

class CPage7 : public CPropertyPage
{
	DECLARE_DYNCREATE(CPage7)

// Construction
public:
	CPage7();
	~CPage7();

// Dialog Data
	//{{AFX_DATA(CPage7)
	enum { IDD = IDD_DIALOG7 };
		// NOTE - ClassWizard will add data members here.
		//    DO NOT EDIT what you see in these blocks of generated code !
	//}}AFX_DATA


// Overrides
	// ClassWizard generate virtual function overrides
	//{{AFX_VIRTUAL(CPage7)
	public:
	virtual BOOL OnSetActive();
	protected:
	virtual void DoDataExchange(CDataExchange* pDX);    // DDX/DDV support
	//}}AFX_VIRTUAL

// Implementation
protected:
	// Generated message map functions
	//{{AFX_MSG(CPage7)
	virtual BOOL OnInitDialog();
	//}}AFX_MSG
	DECLARE_MESSAGE_MAP()

};

//{{AFX_INSERT_LOCATION}}
// Microsoft Visual C++ will insert additional declarations immediately before the previous line.

#endif // !defined(AFX_PAGE7_H__316247F8_3469_407A_A095_AEC88CAB27D6__INCLUDED_)
