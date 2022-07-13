///将部分VISA32_PB_WRAPPER.dll中的函数重新封装成非成员函数
/**
 * @file
 * @author  Cui Wei <cuiwei_cv@163.com>
 * @version 1.0
 *
 * @section LICENSE
 *
 * This program is not free software, and you must pay for it!
 *
 * @section DESCRIPTION
 *
 * 对导出函数的重新封装
 */
 
#if !defined(_VISA32_PB_WRAPPER_KIT_H)
#define _VISA32_PB_WRAPPER_KIT_H

#include "pc_info.h"
#include "visa32_device.h"
#include "VISA32_PB_WRAPPER_DLL.h"
 
///重新封装的非成员函数统一放在VISA32_PB_WRAPPER_KIT命名空间
/** 
 *	大部分函数重新封装成线程运行
 */	
namespace	VISA32_PB_WRAPPER_KIT
{
	///以线程的方式运行pxi_bit_access窗体
	/** 
	 *	@param		[in]	param1	card_info类的引用
	 *	@return		void
	 *	@see		VISA32_PB_WRAPPER_DLL::pxi_bit_access()
	 */
	void	pxi_bit_access_thread(const	card_info&	param1);
	///以线程的方式运行pxi_block_access窗体
	/** 
	 *	@param		[in]	param1	card_info类的引用
	 *	@return		void	 
	 *	@see		VISA32_PB_WRAPPER_DLL::pxi_block_access()
	 */	
	void	pxi_block_access_thread(const	card_info&	param1);
	///以线程的方式运行pxi_register_access窗体
	/** 
	 *	@param		[in]	param1	card_info类的引用
	 *	@return		void	 
	 *	@see		VISA32_PB_WRAPPER_DLL::pxi_register_access()
	 */	
	void	pxi_register_access_thread(const	card_info&	param1);
	///以线程的方式运行plx9054_dma_controlpanel窗体
	/** 
	 *	@param		[in]	param1	card_info类的引用
	 *	@return		void	 
	 *	@see		VISA32_PB_WRAPPER_DLL::plx9054_dma_controlpanel()
	 */		
	void	plx9054_dma_controlpanel_thread(const	card_info&	param1);
	///以线程的方式运行plx9054_dma_spy窗体
	/** 
	 *	@param		[in]	param1	card_info类的引用
	 *	@return		void	 
	 *	@see		VISA32_PB_WRAPPER_DLL::plx9054_dma_spy()
	 */		
	void	plx9054_dma_spy_thread(const	card_info&	param1);
	///以线程的方式运行plx9054_reset_card_gui窗体
	/** 
	 *	@param		[in]	param1	card_info类的引用
	 *	@return		void	 
	 *	@see		VISA32_PB_WRAPPER_DLL::plx9054_reset_card_gui()
	 */		
	void	plx9054_reset_card_gui_thread(const	card_info&	param1);
	///以线程的方式运行plx9054_interrupt_spy窗体
	/** 
	 *	@param		[in]	param1	card_info类的引用
	 *	@return		void	 
	 *	@see		VISA32_PB_WRAPPER_DLL::plx9054_interrupt_spy()
	 */		
	void	plx9054_interrupt_spy_thread(const	card_info&	param1);
	///以线程的方式运行plx9054_doorbell_interrupt_spy窗体
	/** 
	 *	@param		[in]	param1	card_info类的引用
	 *	@return		void	 
	 *	@see		VISA32_PB_WRAPPER_DLL::plx9054_doorbell_interrupt_spy()
	 */		
	void	plx9054_doorbell_interrupt_spy_thread(const	card_info&	param1);
	///以线程的方式运行plx9054_eeprom_access窗体
	/** 
	 *	@param		[in]	param1	card_info类的引用
	 *	@return		void	 
	 *	@see		VISA32_PB_WRAPPER_DLL::plx9054_eeprom_access()
	 */		
	void	plx9054_eeprom_access_thread(const	card_info&	param1);
	///以线程的方式运行plx9054_eeprom_user_data_viewer窗体
	/** 
	 *	@param		[in]	param1	card_info类的引用
	 *	@return		void	 
	 *	@see		VISA32_PB_WRAPPER_DLL::plx9054_eeprom_user_data_viewer()
	 */		
	void	plx9054_eeprom_user_data_viewer_thread(const	card_info&	param1);
	///重新封装的is_plx9054_eeprom_exist函数
	/** 
	 *	@param		[in]	param1	card_info类的引用
	 *	@retval		true	存在
	 *	@retval		false	不存在	 
	 *	@see		VISA32_PB_WRAPPER_DLL::is_plx9054_eeprom_exist()
	 */		
	bool	is_plx9054_eeprom_exist(const	card_info&	param1);
	///重新封装的is_plx9054_exist函数
	/** 
	 *	@param		[in]	param1	card_info类的引用
	 *	@retval		true	存在
	 *	@retval		false	不存在
	 *	@see		VISA32_PB_WRAPPER_DLL::is_plx9054_exist()
	 */		
	bool	is_plx9054_exist(const	card_info&	param1);
	///以线程的方式运行visa_server_remote窗体
	/** 
	 *	@param		[in]	param1	pc_info类的引用
	 *	@return		void
	 *	@see		VISA32_PB_WRAPPER_DLL::visa_server_remote()
	 */		
	void	visa_server_remote_thread(const	pc_info&	param1);
	///以线程的方式运行AG34410A_controlpanel窗体
	/** 
	 *	@param		[in]	param1	visa32_device类的引用
	 *	@return		void	 
	 *	@see		VISA32_PB_WRAPPER_DLL::AG34410A_controlpanel()
	 */		
	void	AG34410A_controlpanel_thread(const	visa32_device&	param1);
	///以线程的方式运行MSO7034B_controlpanel_thread窗体
	/** 
	 *	@param		[in]	param1	visa32_device类的引用
	 *	@return		void	 
	 *	@see		VISA32_PB_WRAPPER_DLL::MSO7034B_controlpanel()
	 */		
	void	MSO7034B_controlpanel_thread(const	visa32_device&	param1);
	///以线程的方式运行UART_controlpanel窗体
	/** 
	 *	@param		[in]	param1	visa32_device类的引用
	 *	@return		void	 
	 *	@see		VISA32_PB_WRAPPER_DLL::UART_controlpanel()
	 */		
	void	UART_controlpanel_thread(const	visa32_device&	param1);
	///以线程的方式运行about_cv窗体
	/** 
	 *	@return		void	
	 *	@see		VISA32_PB_WRAPPER_DLL::about_cv()
	 */		
	void	about_cv_thread();
	///以线程的方式运行pci_usb_pnp_list窗体
	/** 
	 *	@return		void	
	 *	@see		VISA32_PB_WRAPPER_DLL::pci_usb_pnp_list()
	 */		
	void	pci_usb_pnp_list_thread();
	///以线程的方式运行visa_alias_editor窗体
	/** 
	 *	@return		void	
	 *	@see		VISA32_PB_WRAPPER_DLL::visa_alias_editor()
	 */			
	void	visa_alias_editor_thread();
	///以线程的方式运行visa_remote_system_editor窗体
	/** 
	 *	@return		void	
	 *	@see		VISA32_PB_WRAPPER_DLL::visa_remote_system_editor()
	 */			
	void	visa_remote_system_editor_thread();	
	///以线程的方式运行float_hex_convert窗体
	/** 
	 *	@return		void	
	 *	@see		VISA32_PB_WRAPPER_DLL::float_hex_convert()
	 */	
	void	float_hex_convert_thread();
	///以线程的方式运行visa_pxi_tree窗体
	/** 
	 *	@return		void	
	 *	@see		VISA32_PB_WRAPPER_DLL::visa_pxi_tree()
	 */	
	void	visa_pxi_tree_thread();	
}

void	VISA32_PB_WRAPPER_KIT::pxi_bit_access_thread(const card_info& param1)
{
	::CreateThread(
		NULL,            
		NULL,
		(DWORD	(WINAPI*)(LPVOID))VISA32_PB_WRAPPER_DLL::pxi_bit_access,
		(LPVOID)(&param1), 
		NULL,
		NULL
	);
}
void	VISA32_PB_WRAPPER_KIT::pxi_block_access_thread(const card_info& param1)
{
	::CreateThread(
		NULL,            
		NULL,
		(DWORD	(WINAPI*)(LPVOID))VISA32_PB_WRAPPER_DLL::pxi_block_access,
		(LPVOID)(&param1), 
		NULL,
		NULL
		);
}
void	VISA32_PB_WRAPPER_KIT::pxi_register_access_thread(const card_info& param1)
{
	::CreateThread(
		NULL,            
		NULL,
		(DWORD	(WINAPI*)(LPVOID))VISA32_PB_WRAPPER_DLL::pxi_register_access,
		(LPVOID)(&param1), 
		NULL,
		NULL
		);
}
void	VISA32_PB_WRAPPER_KIT::plx9054_dma_controlpanel_thread(const card_info& param1)
{
	::CreateThread(
		NULL,            
		NULL,
		(DWORD	(WINAPI*)(LPVOID))VISA32_PB_WRAPPER_DLL::plx9054_dma_controlpanel,
		(LPVOID)(&param1), 
		NULL,
		NULL
		);
}
void	VISA32_PB_WRAPPER_KIT::plx9054_dma_spy_thread(const card_info& param1)
{
	::CreateThread(
		NULL,            
		NULL,
		(DWORD	(WINAPI*)(LPVOID))VISA32_PB_WRAPPER_DLL::plx9054_dma_spy,
		(LPVOID)(param1.get_card_rscs()),
		NULL,
		NULL
		);
}
void	VISA32_PB_WRAPPER_KIT::plx9054_reset_card_gui_thread(const card_info& param1)
{
	::CreateThread(
		NULL,            
		NULL,
		(DWORD	(WINAPI*)(LPVOID))VISA32_PB_WRAPPER_DLL::plx9054_reset_card_gui,
		(LPVOID)(&param1), 
		NULL,
		NULL
		);
}
void	VISA32_PB_WRAPPER_KIT::plx9054_interrupt_spy_thread(const card_info& param1)
{
	::CreateThread(
		NULL,            
		NULL,
		(DWORD	(WINAPI*)(LPVOID))VISA32_PB_WRAPPER_DLL::plx9054_interrupt_spy,
		(LPVOID)(&param1), 
		NULL,
		NULL
		);
}
void	VISA32_PB_WRAPPER_KIT::plx9054_doorbell_interrupt_spy_thread(const card_info& param1)
{
	::CreateThread(
		NULL,            
		NULL,
		(DWORD	(WINAPI*)(LPVOID))VISA32_PB_WRAPPER_DLL::plx9054_doorbell_interrupt_spy,
		(LPVOID)(&param1), 
		NULL,
		NULL
		);
}
void	VISA32_PB_WRAPPER_KIT::plx9054_eeprom_access_thread(const card_info& param1)
{
	::CreateThread(
		NULL,            
		NULL,
		(DWORD	(WINAPI*)(LPVOID))VISA32_PB_WRAPPER_DLL::plx9054_eeprom_access,
		(LPVOID)(&param1), 
		NULL,
		NULL
		);
}
void	VISA32_PB_WRAPPER_KIT::plx9054_eeprom_user_data_viewer_thread(const card_info& param1)
{
	::CreateThread(
		NULL,            
		NULL,
		(DWORD	(WINAPI*)(LPVOID))VISA32_PB_WRAPPER_DLL::plx9054_eeprom_user_data_viewer,
		(LPVOID)(&param1), 
		NULL,
		NULL
		);
}
bool	VISA32_PB_WRAPPER_KIT::is_plx9054_eeprom_exist(const card_info& param1)
{
	return	VISA32_PB_WRAPPER_DLL::is_plx9054_eeprom_exist(param1.get_card_rscs());
}
bool	VISA32_PB_WRAPPER_KIT::is_plx9054_exist(const card_info& param1)
{
	return	VISA32_PB_WRAPPER_DLL::is_plx9054_exist(param1.get_card_rscs());
}
void	VISA32_PB_WRAPPER_KIT::visa_server_remote_thread(const	pc_info&	param1)
{
	::CreateThread(
		NULL,            
		NULL,
		(DWORD	(WINAPI*)(LPVOID))VISA32_PB_WRAPPER_DLL::visa_server_remote,
		(LPVOID)(&param1), 
		NULL,
		NULL
		);
}
void	VISA32_PB_WRAPPER_KIT::AG34410A_controlpanel_thread(const	visa32_device&	param1)
{
	::CreateThread(
		NULL,            
		NULL,
		(DWORD	(WINAPI*)(LPVOID))VISA32_PB_WRAPPER_DLL::AG34410A_controlpanel,
		(LPVOID)(param1.get_device_rscs()), 
		NULL,
		NULL
		);
}
void	VISA32_PB_WRAPPER_KIT::MSO7034B_controlpanel_thread(const	visa32_device&	param1)
{
	::CreateThread(
		NULL,            
		NULL,
		(DWORD	(WINAPI*)(LPVOID))VISA32_PB_WRAPPER_DLL::MSO7034B_controlpanel,
		(LPVOID)(param1.get_device_rscs()), 
		NULL,
		NULL
		);
}
void	VISA32_PB_WRAPPER_KIT::UART_controlpanel_thread(const	visa32_device&	param1)
{
	::CreateThread(
		NULL,            
		NULL,
		(DWORD	(WINAPI*)(LPVOID))VISA32_PB_WRAPPER_DLL::UART_controlpanel,
		(LPVOID)(param1.get_device_rscs()), 
		NULL,
		NULL
		);
}
void	VISA32_PB_WRAPPER_KIT::about_cv_thread()
{
	::CreateThread(
		NULL,            
		NULL,
		(DWORD	(WINAPI*)	(void*))VISA32_PB_WRAPPER_DLL::about_cv,
		NULL, 
		NULL,
		NULL
	);
}
void	VISA32_PB_WRAPPER_KIT::pci_usb_pnp_list_thread()
{
	::CreateThread(
		NULL,            
		NULL,
		(DWORD	(WINAPI*)	(void*))VISA32_PB_WRAPPER_DLL::pci_usb_pnp_list,
		NULL, 
		NULL,
		NULL
		);	
}
void	VISA32_PB_WRAPPER_KIT::visa_alias_editor_thread()
{
	::CreateThread(
		NULL,            
		NULL,
		(DWORD	(WINAPI*)	(void*))VISA32_PB_WRAPPER_DLL::visa_alias_editor,
		NULL, 
		NULL,
		NULL
		);	
}
void	VISA32_PB_WRAPPER_KIT::visa_remote_system_editor_thread()
{
	::CreateThread(
		NULL,            
		NULL,
		(DWORD	(WINAPI*)	(void*))VISA32_PB_WRAPPER_DLL::visa_remote_system_editor,
		NULL, 
		NULL,
		NULL
		);	
}
void	VISA32_PB_WRAPPER_KIT::float_hex_convert_thread()
{
	::CreateThread(
		NULL,            
		NULL,
		(DWORD	(WINAPI*)	(void*))VISA32_PB_WRAPPER_DLL::float_hex_convert,
		NULL, 
		NULL,
		NULL
		);	
}
void	VISA32_PB_WRAPPER_KIT::visa_pxi_tree_thread()
{
	::CreateThread(
		NULL,            
		NULL,
		(DWORD	(WINAPI*)	(void*))VISA32_PB_WRAPPER_DLL::visa_pxi_tree,
		NULL, 
		NULL,
		NULL
		);	
}

#endif  //_VISA32_PB_WRAPPER_KIT_H
