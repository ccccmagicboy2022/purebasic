// PXI5871B.h: interface for the PXI5871B class.
//
//////////////////////////////////////////////////////////////////////

#if !defined(AFX_PXI5871B_H__ED9332E1_94E9_40D3_91E8_2EC3E80AAAE5__INCLUDED_)
#define AFX_PXI5871B_H__ED9332E1_94E9_40D3_91E8_2EC3E80AAAE5__INCLUDED_

#if _MSC_VER > 1000
#pragma once
#endif // _MSC_VER > 1000

#include "visa32_pb_wrapper/plx9054_card.h"

class PXI5871B : public plx9054_card  
{
public:
	virtual DWORD get_freetimer_value(int channel)	const;
	virtual void set_serial_txd_param(int channel, WORD value)	const;
	virtual void set_serial_param(int channel, DWORD value)	const;
	virtual	WORD get_serial_txd_param(int channel)	const;
	virtual DWORD get_serial_param(int channel)	const;
	virtual BOOL get_stop_state(int channel)	const;
	virtual DWORD get_rpm(int channel)	const;
	virtual WORD get_duty(int channel)	const;
	virtual WORD get_counter(int channel)	const;
	virtual BOOL get_bit_state(int channel)	const;
	virtual void set_enable_state(int channel, BOOL value)	const;
	virtual BOOL get_enable_state(int channel)	const;
	virtual void clear_counter(int channel)	const;
	virtual bool select_visa_pci_pxi_card() const;
	PXI5871B();
	virtual ~PXI5871B();

};

#endif // !defined(AFX_PXI5871B_H__ED9332E1_94E9_40D3_91E8_2EC3E80AAAE5__INCLUDED_)
