// PXI5871B.cpp: implementation of the PXI5871B class.
//
//////////////////////////////////////////////////////////////////////

#include "stdafx.h"
#include "F241_PXI5871B.h"
#include "PXI5871B.h"
#include "visa/visa.h"

#ifdef _DEBUG
#undef THIS_FILE
static char THIS_FILE[]=__FILE__;
#define new DEBUG_NEW
#endif

//////////////////////////////////////////////////////////////////////
// Construction/Destruction
//////////////////////////////////////////////////////////////////////

PXI5871B::PXI5871B()
{

}

PXI5871B::~PXI5871B()
{

}

bool PXI5871B::select_visa_pci_pxi_card() const
{
	#ifdef _DEBUG
		return	set_card_rscs(0x0, 0x0); 
	#else 
		return	set_card_rscs(0x10b5, 0x5871);
	#endif
}

void PXI5871B::clear_counter(int channel)	const
{
	int	index;
	switch (channel)
	{
	case 0:
		index	=	17;
		break;
	case 1:
		index	=	16;
		break;
	case 2:
		index	=	0;
		break;
	case 3:
		index	=	1;
		break;
	}
	memory_bit_set(VI_PXI_BAR2_SPACE, 0x408, index);
	::Sleep(10);
	memory_bit_clear(VI_PXI_BAR2_SPACE, 0x408, index);
}

BOOL PXI5871B::get_enable_state(int channel)	const
{
	BOOL	result;
	switch (channel)
	{
	case 0:
		result	=	!memory_bit_test(VI_PXI_BAR2_SPACE, 0x408, 23);
		break;
	case 1:
		result	=	!memory_bit_test(VI_PXI_BAR2_SPACE, 0x408, 22);
		break;
	case 2:
		result	=	!memory_bit_test(VI_PXI_BAR2_SPACE, 0x40C, 1);
		break;
	case 3:
		result	=	!memory_bit_test(VI_PXI_BAR2_SPACE, 0x40C, 0);
		break;
	}
	return	result;
}

void PXI5871B::set_enable_state(int channel, BOOL value)	const
{
	switch (channel)
	{
	case 0:
		memory_bit(VI_PXI_BAR2_SPACE, 0x408, 23, !value);
		break;
	case 1:
		memory_bit(VI_PXI_BAR2_SPACE, 0x408, 22, !value);
		break;
	case 2:
		memory_bit(VI_PXI_BAR2_SPACE, 0x40C, 1, !value);
		break;
	case 3:
		memory_bit(VI_PXI_BAR2_SPACE, 0x40C, 0, !value);
		break;
	}
}

BOOL PXI5871B::get_bit_state(int channel)	const
{
	BOOL	result;
	switch (channel)
	{
	case 0:
		result	=	memory_bit_test(VI_PXI_BAR2_SPACE, 0x478, 0);
		break;
	}
	return	result;
}

WORD PXI5871B::get_counter(int channel)	const
{
	WORD	counter;
	switch (channel)
	{
	case 0:
		viIn16(get_card_res(), VI_PXI_BAR2_SPACE, 0x41C, &counter);
		break;
	case 1:
		viIn16(get_card_res(), VI_PXI_BAR2_SPACE, 0x418, &counter);
		break;
	case 2:
		viIn16(get_card_res(), VI_PXI_BAR2_SPACE, 0x474, &counter);
		break;
	case 3:
		viIn16(get_card_res(), VI_PXI_BAR2_SPACE, 0x484, &counter);
		break;
	}
	return	counter;
}

WORD PXI5871B::get_duty(int channel)	const
{
	WORD	duty;
	switch (channel)
	{
	case 0:
		viIn16(get_card_res(), VI_PXI_BAR2_SPACE, 0x44C, &duty);
		break;
	case 1:
		viIn16(get_card_res(), VI_PXI_BAR2_SPACE, 0x448, &duty);
		break;
	}
	return	duty;
}

DWORD PXI5871B::get_rpm(int channel)	const
{
	DWORD	sum	=	0;
	DWORD	temp3	=	0;
	DWORD	result	=	0;
	int	i;
	if (!get_stop_state(channel))
	{
		for (i=0x0;i<24;i++)
		{
			switch (channel)
			{
			case 0:
				viIn32(get_card_res(), VI_PXI_BAR2_SPACE, 0x520 + i*4, &temp3);
				break;
			case 1:
				viIn32(get_card_res(), VI_PXI_BAR2_SPACE, 0x580 + i*4, &temp3);
				break;
			case 2:
				viIn32(get_card_res(), VI_PXI_BAR2_SPACE, 0x5E0 + i*4, &temp3);
				break;
			case 3:
				viIn32(get_card_res(), VI_PXI_BAR2_SPACE, 0x640 + i*4, &temp3);
				break;
			case 4:
				viIn32(get_card_res(), VI_PXI_BAR2_SPACE, 0x6A0 + i*4, &temp3);
				break;
			}
			sum	+=	temp3;
		}
		
		if (0	!=	sum)
		{
			result	=	60000/sum;
		}
		else
		{
			result	=	0;
		}
	}
	else
	{
		result	=	0;
	}
	return	result;
}

BOOL PXI5871B::get_stop_state(int channel)	const
{
	BOOL	result;
	switch (channel)
	{
	case 0:
		result	=	memory_bit_test(VI_PXI_BAR2_SPACE, 0x478, 1);
		break;
	case 1:
		result	=	memory_bit_test(VI_PXI_BAR2_SPACE, 0x478, 2);
		break;
	case 2:
		result	=	memory_bit_test(VI_PXI_BAR2_SPACE, 0x478, 3);
		break;
	case 3:
		result	=	memory_bit_test(VI_PXI_BAR2_SPACE, 0x478, 4);
		break;
	case 4:
		result	=	memory_bit_test(VI_PXI_BAR2_SPACE, 0x478, 5);
		break;
	}
	return	result;
}

DWORD PXI5871B::get_serial_param(int channel)	const
{
	DWORD	result;
	switch (channel)
	{
	case 0:		//ÐÇÃô3Ä£ÄâÆ÷
		viIn32(get_card_res(), VI_PXI_BAR2_SPACE, 0x820, &result);
		break;
	case 1:		//ÐÇÃô1µØ¼ì
		viIn32(get_card_res(), VI_PXI_BAR2_SPACE, 0x808, &result);
		break;
	case 2:		//ÐÇÃô2µØ¼ì
		viIn32(get_card_res(), VI_PXI_BAR2_SPACE, 0x80C, &result);
		break;
	case 3:		//ÐÇÃô3µØ¼ì
		viIn32(get_card_res(), VI_PXI_BAR2_SPACE, 0x810, &result);
		break;
	}
	return	result;
}

WORD PXI5871B::get_serial_txd_param(int channel)	const
{
	WORD	result;
	switch (channel)
	{
	case 0:		//ÐÇÃô3Ä£ÄâÆ÷
		viIn16(get_card_res(), VI_PXI_BAR2_SPACE, 0x1C00, &result);
		break;
	case 1:		//ÐÇÃô1µØ¼ì
		viIn16(get_card_res(), VI_PXI_BAR2_SPACE, 0x1000, &result);
		break;
	case 2:		//ÐÇÃô2µØ¼ì
		viIn16(get_card_res(), VI_PXI_BAR2_SPACE, 0x1400, &result);
		break;
	case 3:		//ÐÇÃô3µØ¼ì
		viIn16(get_card_res(), VI_PXI_BAR2_SPACE, 0x1800, &result);
		break;
	}
	return	result;
}

void PXI5871B::set_serial_param(int channel, DWORD value)	const
{
	switch (channel)
	{
	case 0:
		viOut32(get_card_res(), VI_PXI_BAR2_SPACE, 0x820, value);
		break;
	case 1:
		viOut32(get_card_res(), VI_PXI_BAR2_SPACE, 0x808, value);
		break;
	case 2:
		viOut32(get_card_res(), VI_PXI_BAR2_SPACE, 0x80C, value);
		break;
	case 3:
		viOut32(get_card_res(), VI_PXI_BAR2_SPACE, 0x810, value);
		break;
	}
}

void PXI5871B::set_serial_txd_param(int channel, WORD value)	const
{
	switch (channel)
	{
	case 0:
		viOut16(get_card_res(), VI_PXI_BAR2_SPACE, 0x1C00, value);
		break;
	case 1:
		viOut16(get_card_res(), VI_PXI_BAR2_SPACE, 0x1000, value);
		break;
	case 2:
		viOut16(get_card_res(), VI_PXI_BAR2_SPACE, 0x1400, value);
		break;
	case 3:
		viOut16(get_card_res(), VI_PXI_BAR2_SPACE, 0x1800, value);
		break;
	}
}

DWORD PXI5871B::get_freetimer_value(int channel)	const
{
	DWORD	counter;
	switch (channel)
	{
	case 0:
		viIn32(get_card_res(), VI_PXI_BAR2_SPACE, 0x470, &counter);
		break;
	case 1:
		viIn32(get_card_res(), VI_PXI_BAR2_SPACE, 0x480, &counter);
		break;
	}
	return	counter;
}
