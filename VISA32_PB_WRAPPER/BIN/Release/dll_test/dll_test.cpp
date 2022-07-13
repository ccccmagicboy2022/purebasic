///VISA32_PB_WRAPPER.dll的dll_test程序
/**
 * @file
 * @author  Cui Wei <cuiwei_cv@163.com>
 * @version 1.0
 *
 * @section LICENSE
 *
 * This program is free software, and you must pay for it!
 *
 * @section DESCRIPTION
 *
 * exe for VISA32_PB_WRAPPER.dll functions test.
 */

#include	<string>		//增加对c++中string类的支持
#include	<iostream>		//增加std中I/O流的支持
#include	<Windows.h>		//增加winapi支持
//-----------------------------------------------------------------------
#pragma comment(lib, ".\\visa32.lib")				//visa32
#pragma	comment(lib, ".\\VISA32_PB_WRAPPER.lib")	//visa32_cv_wrapper
//-----------------------------------------------------------------------
#include	"visa/visa.h"								//visa32 header file
#include	"VISA32_PB_WRAPPER/VISA32_PB_WRAPPER_DLL.h"				//VISA32_PB_WRAPPER DLL header file
#include	"VISA32_PB_WRAPPER/visa32_device.h"					//visa32_device class
#include	"VISA32_PB_WRAPPER/AG34410A.h"						//AG34410A class
#include	"VISA32_PB_WRAPPER/MSO7034B.h"						//MSO7034B class
#include	"VISA32_PB_WRAPPER/visa32_base.h"					//visa32_base class
#include	"VISA32_PB_WRAPPER/pc_info.h"						//pc_info class
#include	"VISA32_PB_WRAPPER/cable_tester.h"					//cable_tester class
#include	"VISA32_PB_WRAPPER/card_info.h"						//card_info class
#include	"VISA32_PB_WRAPPER/plx9054_card.h"					//plx9054_card class
#include	"VISA32_PB_WRAPPER/GX6888.h"						//GX6888 class
#include	"VISA32_PB_WRAPPER/PXI5477.h"						//PXI5477 class
#include	"VISA32_PB_WRAPPER/PXI5487.h"						//PXI5487_card class
#include	"VISA32_PB_WRAPPER/VISA32_PB_WRAPPER_KIT.h"				//VISA32_PB_WRAPPER KIT header file
//-----------------------------------------------------------------------
typedef HWND (WINAPI *PROCGETCONSOLEWINDOW)();
PROCGETCONSOLEWINDOW GetConsoleWindow;

///DLL测试应用程序框架类
/** 
 *	建立一个测试DLL功能的框架，为此类的默认的构造函数及主函数。
 */
class	dll_test_frame
{
private:
	///使用visa32库
	/** 
	 *	按默认的构造函数执行visa32库的初始化
	 */
	visa32_base	visa32;
public:
	void test34();
	///主函数
	/** 
	 *	建立一个测试DLL功能的框架，为此类的默认的构造函数及程序的主函数。
	 */
	dll_test_frame();
	///打印测试项目单
	/** 
	 *	列出所有测试项目
	 */
	void	print_instruction();	
	///测试项目1 - visa_server_remote
	/** 
	 *	新建一个visa_server_remote
	 *	@warning  	用户保证IP地址的有效性。
	 *	@return		void
	 *  @see		pc_info
	 */
	void	test1();
	///测试项目2 - about_cv
	/** 
	 *	新建一个about_cv。
	 *	@return		void
	 */
	void	test2();
	///测试项目3 - 高音beep
	/** 
	 *	启动一次高音beep。
	 *	@return		void		 
	 */
	void	test3();
	///测试项目4 - 低音beep
	/** 
	 *	启动一次低音beep。
	 *	@return		void		 
	 */
	void	test4();
	///测试项目5 - pci_usb_pnp_list & visa_alias_editor
	/** 
	 *	建立一个pci_usb_pnp_list的线程，可以查看系统内的PNP设备名（包括PCI以及USB）。再建立visa_alias_editor的线程
	 *	@return		void
	 */
	void	test5();
	///测试项目6 - get_visa_server_ip等函数
	/** 
	 *	测试get_visa_server_ip窗体
	 *	@return		void	 
	 */	
	void	test6();
	///测试项目7 - dword_change_endian
	/** 
	 *	测试dword_change_endian函数
	 *	@return		void	 
	 */	
	void	test7();
	///测试项目8 - pxi_bit_access
	/** 
	 *	测试pxi_bit_access窗体
	 *	@return		void	 
	 */	
	void	test8();	
	///测试项目9 - pxi_block_access
	/** 
	 *	测试pxi_block_access窗体
	 *	@return		void	 
	 */	
	void	test9();
	///测试项目10 - pxi_register_access
	/** 
	 *	测试pxi_register_access窗体
	 *	@return		void	 
	 */	
	void	test10();
	///测试项目11 - plx9054_dma_controlpanel
	/** 
	 *	测试plx9054_dma_controlpanel窗体
	 *	@return		void	 
	 */	
	void	test11();
	///测试项目12 - plx9054_reset_card_gui
	/** 
	 *	测试plx9054_reset_card_gui窗体
	 *	@return		void	 
	 */		
	void	test12();
	///测试项目13 - plx9054_doorbell_interrupt_spy
	/** 
	 *	测试plx9054_doorbell_interrupt_spy窗体
	 *	@return		void	 
	 */	
	void	test13();
	///测试项目14 - plx9054_eeprom_access
	/** 
	 *	测试plx9054_eeprom_access窗体
	 *	@return		void	 
	 */	
	void	test14();	
	///测试项目15 - plx9054_eeprom_user_data_viewer
	/** 
	 *	测试plx9054_eeprom_user_data_viewer窗体
	 *	@return		void	 
	 */	
	void	test15();	
	///测试项目16 - plx9054_interrupt_spy
	/** 
	 *	测试plx9054_interrupt_spy窗体
	 *	@return		void	 
	 */	
	void	test16();	
	///测试项目17 - plx9054_dma_spy
	/** 
	 *	测试plx9054_dma_spy窗体
	 *	@return		void	 
	 */	
	void	test17();
	///测试项目18 - is_plx9054_exist & is_plx9054_eeprom_exist
	/** 
	 *	is_plx9054_exist函数以及is_plx9054_eeprom_exist函数
	 *	@return		void	 
	 */	
	void	test18();	
	///测试项目19 - AG34410A_controlpanel
	/** 
	 *	测试AG34410A_controlpanel窗体
	 *	@return		void	 
	 */		
	void	test19();
	///测试项目20 - MSO7034B_controlpanel
	/** 
	 *	测试MSO7034B_controlpanel窗体
	 *	@return		void	 
	 */		
	void	test20();
	///测试项目21 - UART_controlpanel
	/** 
	 *	测试UART_controlpanel窗体
	 *	@return		void	 
	 */
	void	test21();
	///测试项目22 - check_plx9054_eeprom_is_cv_style
	/** 
	 *	测试check_plx9054_eeprom_is_cv_style函数
	 *	@return		void	 
	 */
	void	test22();	
	///测试项目23 - get_plx9054_fpga_logic_version
	/** 
	 *	测试get_plx9054_fpga_logic_version函数
	 *	@return		void	 
	 */
	void	test23();
	///测试项目24 - burn_cv_style_eeprom_for_this_plx9054
	/** 
	 *	测试burn_cv_style_eeprom_for_this_plx9054函数
	 *	@return		void	 
	 */
	void	test24();	
	///测试项目25 - memory_bit_clear memory_bit_set memory_bit_test
	/** 
	 *	测试memory_bit_clear memory_bit_set memory_bit_test三个函数
	 *	@return		void	 
	 */
	void	test25();
	///测试项目26 - plx9054_reset_card
	/** 
	 *	测试plx9054_reset_card函数
	 *	@return		void	 
	 */	
	void	test26();	
	///测试项目27 - plx9054_write_eeprom_32 plx9054_read_eeprom_32
	/** 
	 *	测试plx9054_write_eeprom_32 plx9054_read_eeprom_32两个函数
	 *	@return		void	 
	 */	
	void	test27();
	///测试项目28 - select_visa_device select_visa_gpib_device select_visa_bus visa_interactive_io
	/** 
	 *	测试select_visa_device select_visa_gpib_device select_visa_bus visa_interactive_io四个函数
	 *	@return		void	 
	 */	
	void	test28();	
	///测试项目29 - fft
	/** 
	 *	测试fft函数
	 *	@return		void	 
	 */	
	void	test29();
	///测试项目30 - float_hex_convert
	/** 
	 *	测试float_hex_convert窗体
	 *	@return		void	 
	 */	
	void	test30();	
	///测试项目31 - least_squares
	/** 
	 *	测试least_squares函数
	 *	@return		void	 
	 */	
	void	test31();
	///测试项目32 - test only强度测试
	/** 
	 *	just for test!
	 *	@return		void	 
	 */	
	void	test32();
	///测试项目33 - test only窗口进度条
	/** 
	 *	just for test!
	 *	@return		void	 
	 */	
	void	test33();
	///测试项目100 - AG34410A
	void	test100();
	///测试项目101 - 电缆测试仪
	void	test101();
};
dll_test_frame::dll_test_frame()
{
	DWORD	select_function_item	=	0;
	bool	quit	=	false;

	HMODULE hKernel32 = ::GetModuleHandle("kernel32");
	GetConsoleWindow = (PROCGETCONSOLEWINDOW)GetProcAddress(hKernel32,"GetConsoleWindow");
	HWND cmd=GetConsoleWindow();
	SetWindowPos(cmd, HWND_TOP, 0, 0, 0, 0, SWP_NOMOVE|SWP_NOSIZE);
	SendMessage(cmd, WM_SYSCOMMAND, SC_MAXIMIZE, 0); 

	::system("title VISA32_PB_WRAPPER.dll 测试程序 v1.0");
	::system("mode con: cols=180 lines=100 ScreenBufferSize=300"); 
	print_instruction();
	while(!quit)
	{
		DWORD	result	=	0;

		std::cin>>select_function_item;

		try
		{
			if(!std::cin.good())
			{
				throw	1;
			}
			if (select_function_item>200)
			{
				throw	2;
			}
		}
		catch (int	e)
		{
			std::cout <<"Error code: "<<e<<std::endl<< "Input Error! Try again!" << std::endl;
			std::cin.clear();	//复位错误
			std::cin.sync();	//清空流
			system("pause");
		}

		switch (select_function_item)
		{
		case 0:
			
			result	=	MessageBox(GetFocus(), "exit or not?", "cv", MB_ICONQUESTION|MB_DEFBUTTON2|MB_YESNO|MB_SYSTEMMODAL);
			switch (result)
			{
				case	IDYES:
					quit	=	true;
					break;
				default:
					break;
			}
			break;
		case 1:
			test1();
			break;
		case 2:
			test2();
			break;
		case 3:
			test3();
			break;
		case 4:
			test4();
			break;
		case 5:
			test5();
			break;
		case 6:
			test6();
			break;
		case 7:
			test7();
			break;
		case 8:
			test8();
			break;
		case 9:
			test9();
			break;
		case 10:
			test10();
			break;
		case 11:
			test11();
			break;
		case 12:
			test12();
			break;
		case 13:
			test13();
			break;
		case 14:
			test14();
			break;
		case 15:
			test15();
			break;
		case 16:
			test16();
			break;
		case 17:
			test17();
			break;
		case 18:
			test18();
			break;
		case 19:
			test19();
			break;
		case 20:
			test20();
			break;
		case 21:
			test21();
			break;
		case 22:
			test22();
			break;
		case 23:
			test23();
			break;
		case 24:
			test24();
			break;
		case 25:
			test25();
			break;
		case 26:
			test26();
			break;
		case 27:
			test27();
			break;
		case 28:
			test28();
			break;
		case 29:
			test29();
			break;
		case 30:
			test30();
			break;
		case 31:
			test31();
			break;
		case 32:
			test32();
			break;
		case 33:
			test33();
			break;
		case 34:
			test34();
			break;
		case 100:
			test100();
			break;
		case 101:
			test101();
			break;			
		default:
			break;
		}
		print_instruction();
	}
}
void	dll_test_frame::test1()
{
	pc_info	pc1;
	bool	result	=	false;

	::system("cls");
	std::cout<<"Welcome to TEST1"<<std::endl;
	result	=	pc1.set_ip();
	if (result)
	{
		result	=	pc1.set_win_x();
		result	=	pc1.set_win_y();
		VISA32_PB_WRAPPER_KIT::visa_server_remote_thread(pc1);
		::system("pause");//在线程完成读取完成变量后再退出函数		
	}
}
void	dll_test_frame::test2()
{
	DWORD	result	=	0;
	::system("cls");
	std::cout<<"Welcome to TEST2"<<std::endl;
	if (false	==	VISA32_PB_WRAPPER_DLL::check_reg_sn())
	{
		VISA32_PB_WRAPPER_KIT::about_cv_thread();//about窗体展示
	}
	else
	{
		result	=	MessageBox(GetFocus(), "already reg, and open about?", "thank you", MB_ICONQUESTION|MB_YESNO|MB_SYSTEMMODAL|MB_DEFBUTTON2);
		switch (result)
		{
			case	IDYES:
				VISA32_PB_WRAPPER_KIT::about_cv_thread();//about窗体展示
				break;
			default:
				break;
		}	
	}
}
void	dll_test_frame::test3()
{
	::system("cls");
	std::cout<<"Welcome to TEST3"<<std::endl;
	VISA32_PB_WRAPPER_DLL::beeper_wrapper1(300);
}
void	dll_test_frame::test4()
{
	::system("cls");
	std::cout<<"Welcome to TEST4"<<std::endl;
	VISA32_PB_WRAPPER_DLL::beeper_wrapper2(300);
}
void	dll_test_frame::test5()
{
	::system("cls");
	std::cout<<"Welcome to TEST5"<<std::endl;	
	VISA32_PB_WRAPPER_KIT::pci_usb_pnp_list_thread();
	Sleep(100);
	VISA32_PB_WRAPPER_KIT::visa_alias_editor_thread();
	Sleep(100);
	VISA32_PB_WRAPPER_KIT::visa_remote_system_editor_thread();
	Sleep(100);
	VISA32_PB_WRAPPER_KIT::visa_pxi_tree_thread();
}
void	dll_test_frame::test6()
{
	DWORD	ip_num	=	0;

	std::cout<<"Welcome to TEST6"<<std::endl;
	VISA32_PB_WRAPPER_DLL::get_visa_server_ip(&ip_num);
	std::cout<<std::hex<<std::showbase<<ip_num<<std::endl;
	VISA32_PB_WRAPPER_DLL::select_lib_skin();
	::system("pause");
}
void	dll_test_frame::test7()
{
	DWORD	dword_hex	=	0x12345678;

	::system("cls");
	std::cout<<"Welcome to TEST7"<<std::endl;
	VISA32_PB_WRAPPER_DLL::hex_input(&dword_hex, 32);
	std::cout<<std::hex<<std::showbase<<dword_hex<<std::endl;
	std::cout<<std::hex<<std::showbase<<VISA32_PB_WRAPPER_DLL::dword_change_endian(dword_hex)<<std::endl;
	std::cout<<std::hex<<std::showbase<<VISA32_PB_WRAPPER_DLL::dword_reverse_bits(dword_hex)<<std::endl;
	::system("pause");
}
void	dll_test_frame::test8()
{
	plx9054_card	card1;
	bool	result	=	false;

	::system("cls");
	std::cout<<"Welcome to TEST8"<<std::endl;
	result	=	card1.select_visa_pci_pxi_card();
	if (result)
	{
		result	=	card1.set_mem_bar();
		if (result)
		{
			result	=	card1.set_mem_offset();
			if (result)
			{
				result	=	card1.set_win_x();
				result	=	card1.set_win_y();
				result	=	card1.set_win_title();
				VISA32_PB_WRAPPER_KIT::pxi_bit_access_thread(card1);
				::system("pause");//等线程启动完成
			} 
			else
			{
			}
		} 
		else
		{
		}
	} 
	else
	{
	}
}
void	dll_test_frame::test9()
{
	plx9054_card	card1;	
	bool	result	=	false;
	
	::system("cls");
	std::cout<<"Welcome to TEST9"<<std::endl;
	result	=	card1.select_visa_pci_pxi_card();
	if (result)
	{
		result	=	card1.select_ram0();
		if (result)
		{
			result	=	card1.set_win_x();
			result	=	card1.set_win_y();
			VISA32_PB_WRAPPER_KIT::pxi_block_access_thread(card1);
			::system("pause");
		} 
		else
		{
		}
	} 
	else
	{
	}
}
void	dll_test_frame::test10()
{
	plx9054_card	card1;
	bool	result	=	false;
	
	::system("cls");
	std::cout<<"Welcome to TEST10"<<std::endl;
	result	=	card1.select_visa_pci_pxi_card();
	if (result)
	{
		result	=	card1.set_mem_bar();
		if (result)
		{
			result	=	card1.set_mem_offset();
			if (result)
			{
				result	=	card1.set_win_x();
				result	=	card1.set_win_y();
				result	=	card1.set_win_title();
				VISA32_PB_WRAPPER_KIT::pxi_register_access_thread(card1);
				::system("pause");
			} 
			else
			{
			}
		} 
		else
		{
		}
	} 
	else
	{
	}
}
void	dll_test_frame::test11()
{
	plx9054_card	card1;	
	bool	result	=	false;

	::system("cls");
	std::cout<<"Welcome to TEST11"<<std::endl;
	result	=	card1.select_visa_pci_pxi_card();
	if (result)
	{
		VISA32_PB_WRAPPER_KIT::plx9054_dma_controlpanel_thread(card1);
		::system("pause");
	} 
	else
	{
	}
}
void	dll_test_frame::test12()
{
	plx9054_card	card1;
	bool	result	=	false;
	
	::system("cls");
	std::cout<<"Welcome to TEST12"<<std::endl;
	result	=	card1.select_visa_pci_pxi_card();
	if (result)
	{
		VISA32_PB_WRAPPER_KIT::plx9054_reset_card_gui_thread(card1);
		::system("pause");
	}
}
void	dll_test_frame::test13()
{
	plx9054_card	card1;
	bool	result	=	false;
	
	::system("cls");
	std::cout<<"Welcome to TEST13"<<std::endl;
	result	=	card1.select_visa_pci_pxi_card();
	if (result)
	{
		VISA32_PB_WRAPPER_KIT::plx9054_doorbell_interrupt_spy_thread(card1);
		::system("pause");
	}
}
void	dll_test_frame::test14()
{
	plx9054_card	card1;	
	bool	result	=	false;
	
	::system("cls");
	std::cout<<"Welcome to TEST14"<<std::endl;
	result	=	card1.select_visa_pci_pxi_card();
	if (result)
	{
		VISA32_PB_WRAPPER_KIT::plx9054_eeprom_access_thread(card1);
		::system("pause");
	}
}
void	dll_test_frame::test15()
{
	plx9054_card	card1;
	bool	result	=	false;
	
	::system("cls");
	std::cout<<"Welcome to TEST15"<<std::endl;
	result	=	card1.select_visa_pci_pxi_card();
	if (result)
	{
		VISA32_PB_WRAPPER_KIT::plx9054_eeprom_user_data_viewer_thread(card1);
		::system("pause");
	}
}
void	dll_test_frame::test16()
{
	plx9054_card	card1;
	bool	result	=	false;
	
	::system("cls");
	std::cout<<"Welcome to TEST16"<<std::endl;
	result	=	card1.select_visa_pci_pxi_card();
	if (result)
	{
		VISA32_PB_WRAPPER_KIT::plx9054_interrupt_spy_thread(card1);
		::system("pause");
	}
}
void	dll_test_frame::test17()
{
	plx9054_card	card1;
	bool	result	=	false;
	
	::system("cls");
	std::cout<<"Welcome to TEST17"<<std::endl;
	result	=	card1.select_visa_pci_pxi_card();
	if (result)
	{
		VISA32_PB_WRAPPER_KIT::plx9054_dma_spy_thread(card1);
		::system("pause");
	}
}
void	dll_test_frame::test18()
{
	plx9054_card	card1;
	bool	result	=	false;
	
	::system("cls");
	std::cout<<"Welcome to TEST18"<<std::endl;
	result	=	card1.select_visa_pci_pxi_card();
	if (result)
	{
		VISA32_PB_WRAPPER_KIT::is_plx9054_exist(card1);
		VISA32_PB_WRAPPER_KIT::is_plx9054_eeprom_exist(card1);
		::system("pause");
	}
}
void	dll_test_frame::test19()
{
	visa32_device	card1;
	bool	result	=	false;
	
	::system("cls");
	std::cout<<"Welcome to TEST19"<<std::endl;
	result	=	card1.select_visa_usb_device();
	if (result)
	{
		VISA32_PB_WRAPPER_KIT::AG34410A_controlpanel_thread(card1);
		::system("pause");
	}
}
void	dll_test_frame::test20()
{
	visa32_device*	card1	=	new MSO7034B();
	bool	result	=	false;
	
	::system("cls");
	std::cout<<"Welcome to TEST20"<<std::endl;
	result	=	card1->select_visa_usb_device();
	if (result)
	{
		VISA32_PB_WRAPPER_KIT::MSO7034B_controlpanel_thread(*card1);
		::system("pause");
	}
	delete	card1;
}
void	dll_test_frame::test21()
{
	visa32_device	card1;
	bool	result	=	false;
	
	::system("cls");
	std::cout<<"Welcome to TEST21"<<std::endl;
	result	=	card1.select_visa_serialport();
	if (result)
	{
		VISA32_PB_WRAPPER_KIT::UART_controlpanel_thread(card1);
		::system("pause");
	}
}
void	dll_test_frame::test22()
{
	plx9054_card	card1;
	bool	result	=	false;
	
	::system("cls");
	std::cout<<"Welcome to TEST22"<<std::endl;
	result	=	card1.select_visa_pci_pxi_card();
	if (result)
	{
		result	=	card1.init();
		if (result)
		{
			std::cout<<card1.check_plx9054_eeprom_is_cv_style()<<std::endl;
			card1.release();
			::system("pause");
		}
	}
}
void	dll_test_frame::test23()
{
	plx9054_card	card1;
	bool	result	=	false;
	
	::system("cls");
	std::cout<<"Welcome to TEST23"<<std::endl;
	result	=	card1.select_visa_pci_pxi_card();
	if (result)
	{
		result	=	card1.init();
		if (result)
		{
			std::cout<<card1.get_plx9054_fpga_logic_version()<<std::endl;
			card1.release();
			::system("pause");
		}
	}
}
void	dll_test_frame::test24()
{
	plx9054_card	card1;
	bool	result	=	false;

	::system("cls");
	std::cout<<"Welcome to TEST24"<<std::endl;
	result	=	card1.select_visa_pci_pxi_card();
	if (result)
	{
		result	=	card1.init();
		if (result)
		{
			std::cout<<card1.burn_cv_style_eeprom_for_this_plx9054()<<std::endl;
			card1.release();
			::system("pause");
		}
	}
}
void	dll_test_frame::test25()
{
	plx9054_card	card1;
	bool	result	=	false;
	
	::system("cls");
	std::cout<<"Welcome to TEST25"<<std::endl;
	result	=	card1.select_visa_pci_pxi_card();
	if (result)
	{
		result	=	card1.init();
		if (result)
		{
			result	=	card1.set_mem_bar();
			if (result)
			{
				result	=	card1.set_mem_offset();
				if (result)
				{
					result	=	card1.set_bit_num();
					if (result)
					{
						card1.memory_bit_clear();
						Sleep(1000);
						card1.memory_bit_set();
						Sleep(1000);
						card1.memory_bit_clear();
						Sleep(1000);
						card1.memory_bit_set();
						Sleep(1000);
						card1.memory_bit_clear();
						std::cout<<card1.memory_bit_test()<<std::endl;
						card1.release();
						::system("pause");
					}
				}
			}
		}
	}
}
void	dll_test_frame::test26()
{
	plx9054_card	card1;
	bool	result	=	false;
	
	::system("cls");
	std::cout<<"Welcome to TEST26"<<std::endl;
	result	=	card1.select_visa_pci_pxi_card();
	if (result)
	{
		result	=	card1.init();
		if (result)
		{
			card1.plx9054_reset_card();
			card1.release();
			::system("pause");
		}
	}
}
void	dll_test_frame::test27()
{
	plx9054_card	card1;
	float	data	=	1.101f;
	DWORD	data_32	=	0;
	bool	result	=	false;

	::system("cls");
	std::cout<<"Welcome to TEST27"<<std::endl;
	result	=	card1.select_visa_pci_pxi_card();
	if (result)
	{
		result	=	card1.init();
		if (result)
		{
			result	=	card1.set_eeprom_addr();
			if (result)
			{
				std::cout<<std::hex<<std::showbase<<card1.plx9054_read_eeprom_32()<<std::endl;
				VISA32_PB_WRAPPER_DLL::float_input(&data, 4);
				data_32	=	*((DWORD*)(&data));
				card1.plx9054_write_eeprom_32(data_32);
				std::cout<<std::hex<<std::showbase<<card1.plx9054_read_eeprom_32()<<std::endl;
				card1.release();
				::system("pause");
			}
		}
	}
}
void	dll_test_frame::test28()
{
	visa32_device	device1;
	bool	result	=	false;
	
	::system("cls");
	std::cout<<"Welcome to TEST28"<<std::endl;
	result	=	device1.select_visa_device();
	result	=	device1.select_visa_gpib_device();
	result	=	device1.select_visa_lxi_device();
	result	=	device1.select_visa_bus(0xfffff000);
	result	=	device1.select_visa_bus(0xfffffff0);
	result	=	device1.select_visa_bus(0xffffffff);
	std::cout<<device1.get_device_rscs()<<std::endl;
	
	if (result)
	{
		result	=	device1.init();
		if (result)
		{
			device1.visa_interactive_io();
			device1.release();
		}
	}
}
void	dll_test_frame::test29()
{
	double x[4] = {1,2,-1,3};//郑君里《信号与系统》上的例子，下P145
	double y[4] = {0};
	int i;
	for(i=0; i<4; i++)
		printf("%d %f %fn\n",i,x[i],y[i]);
	VISA32_PB_WRAPPER_DLL::do_FFT(x,y,4,1);
	for(i=0; i<4; i++)
		printf("%d %f %fn\n",i,x[i],y[i]);
	VISA32_PB_WRAPPER_DLL::do_FFT(x,y,4,-1);
	for(i=0; i<4; i++)
		printf("%d %f %fn\n",i,x[i],y[i]);
	::system("pause");
}
void	dll_test_frame::test30()
{
	VISA32_PB_WRAPPER_KIT::float_hex_convert_thread();
}
void	dll_test_frame::test31()
{
	int i,n=7,poly_n=2;
	double x[7]={1,2,3,4,6,7,8},y[7]={2,3,6,7,5,3,2};
	double a[3];
	
	::system("cls");
	VISA32_PB_WRAPPER_DLL::least_squares(n,x,y,poly_n,a);
	
	for (i=0;i<poly_n+1;i++)/*这里是升序排列，Matlab是降序排列*/
		printf("a[%d]=%g\n",i,a[i]);
	::system("pause");
}
//////////////////////////////////////////////////////////////////////////
void	dll_test_frame::test32()
{
	PXI5477	card1;
	GX6888	card2;
	plx9054_card	card3;
	bool	result	=	false;
	DWORD	counter	=	1000;

// 	result	=	card1.select_visa_pci_pxi_card();
// 	if (result)
// 	{
// 		VISA32_PB_WRAPPER_KIT::plx9054_dma_controlpanel_thread(card1);
// 	}
// 	result	=	card2.select_visa_pci_pxi_card();
// 	if (result)
// 	{
// 		VISA32_PB_WRAPPER_KIT::plx9054_dma_controlpanel_thread(card2);
// 		::system("pause");
// 	}
// 	result	=	card3.select_visa_pci_pxi_card();
// 	if (result)
// 	{
// 		result	=	card3.init();
// 		if (result)
// 		{
// 			result	=	card3.select_ram0();
// 			if (result)
// 			{
// 				VISA32_PB_WRAPPER_DLL::dec_input(&counter);
// 				std::cout<<"byte access: "<<card3.dram_stress_testing(8, counter)<<std::endl;
// 				std::cout<<"word access: "<<card3.dram_stress_testing(16, counter)<<std::endl;
// 				std::cout<<"dword access: "<<card3.dram_stress_testing(32, counter)<<std::endl;
// 			}
// 			card3.release();
// 			::system("pause");
// 		}
// 	}	
	result	=	card3.select_visa_pci_pxi_card();
	if (result)
	{
		result	=	card3.init();
		if (result)
		{
			card3.set_mem_bar(VI_PXI_BAR2_SPACE);
			card3.set_mem_offset(0x200000);
			card3.set_mem_size(0x200000);
			if (result)
			{
				VISA32_PB_WRAPPER_DLL::dec_input(&counter);
				std::cout<<"byte access: "<<card3.dram_stress_testing(8, counter)<<std::endl;
				std::cout<<"word access: "<<card3.dram_stress_testing(16, counter)<<std::endl;
				std::cout<<"dword access: "<<card3.dram_stress_testing(32, counter)<<std::endl;
			}
			card3.release();
			::system("pause");
		}
	}	
}

void	dll_test_frame::test33()
{
	VISA32_PB_WRAPPER_DLL::progress_win_thread(10000);
	::system("pause");
}

void	dll_test_frame::test100()
{
	AG34410A	card1;
	bool	result	=	false;

	result	=	card1.select_visa_usb_device();
	if (result)
	{
		result	=	card1.init();
		if (result)
		{
			card1.clear();
			card1.reset();
			std::cout.setf(std::ios::left|std::ios::fixed);
			std::cout.precision(12);
			std::cout<<card1.read_dci(0)<<std::endl;
			std::cout<<card1.read_dci(1)<<std::endl;
			std::cout<<card1.read_dci(2)<<std::endl;
			std::cout<<card1.read_dci(3)<<std::endl;
			std::cout<<card1.read_dcv(0)<<std::endl;
			std::cout<<card1.read_dcv(1)<<std::endl;
			std::cout<<card1.read_dcv(2)<<std::endl;
			std::cout<<card1.read_res(0)<<std::endl;
			std::cout<<card1.read_res(1)<<std::endl;
			std::cout<<card1.read_res(2)<<std::endl;
			card1.identify();
			std::cout<<card1.get_device_id()<<std::endl;
			card1.display("aaaaaaaaaaaa", "bbbbbbbbbbbbbbbbbb");
			card1.release();
			::system("pause");
		}
	}
}
void	dll_test_frame::test101()
{
	cable_tester	cable;
	DWORD	temp	=	0;
	bool	result	=	false;

	::system("cls");
	result	=	cable.select_visa_serialport();
	if (result)
	{
		result	=	cable.init();
		if (result)
		{
			if	(cable.connect_test())
			{
				//单点测用的硬件有问题，测试第20(0x14)点无法回数
				// 	for (size_t	i=1; i<75; i++)
				// 	{
				// 		cable.single_test(i);
				// 	}
				while(1)
				{
					::system("cls");
					cable.clear_rxd_buffer();
					if (cable.continue_test())
					{
						//
					}
					else
					{
						break;
					}
					::system("pause");
				}	
			}
			cable.release();
			::system("pause");
		}
	}
}
void	dll_test_frame::print_instruction()
{
	HANDLE hOut;

	::system("cls");	
	hOut = ::GetStdHandle(STD_OUTPUT_HANDLE);
   	::SetConsoleTextAttribute(hOut, BACKGROUND_RED|BACKGROUND_GREEN|BACKGROUND_INTENSITY);
	std::cout<<"Welcome to VISA32_PB_WRAPPER.dll TEST [55 of 63 completed]"<<std::endl<<std::endl;
	::SetConsoleTextAttribute(hOut,0xA);
	std::cout<<"Please choose a test to continue:"<<std::endl<<std::endl;
	std::cout<<"[visa_check_setup load_wrapper_dll close_wrapper_dll splash_launcher] already loaded!"<<std::endl<<std::endl;
	std::cout<<"1	visa_server_remote [string_input dec_input]"<<std::endl;
	std::cout<<"2	about_cv check_reg_sn"<<std::endl;
	std::cout<<"3	beeper_wrapper1"<<std::endl;
	std::cout<<"4	beeper_wrapper2"<<std::endl;
	std::cout<<"5	pci_usb_pnp_list visa_alias_editor visa_remote_system_editor visa_pxi_tree"<<std::endl;
	std::cout<<"6	get_visa_server_ip select_lib_skin"<<std::endl;
	std::cout<<"7	dword_change_endian dword_reverse_bits"<<std::endl;
	std::cout<<"8	pxi_bit_access [select_visa_pci_pxi_card select_bar hex_input]"<<std::endl;
	std::cout<<"9	pxi_block_access [select_ram0]"<<std::endl;
	std::cout<<"10	pxi_register_access"<<std::endl;
	std::cout<<"11	plx9054_dma_controlpanel"<<std::endl;
	std::cout<<"12	plx9054_reset_card_gui"<<std::endl;
	std::cout<<"13	plx9054_doorbell_interrupt_spy"<<std::endl;
	std::cout<<"14	plx9054_eeprom_access"<<std::endl;
	std::cout<<"15	plx9054_eeprom_user_data_viewer"<<std::endl;
	std::cout<<"16	plx9054_interrupt_spy"<<std::endl;
	std::cout<<"17	plx9054_dma_spy"<<std::endl;
	std::cout<<"18	is_plx9054_exist [is_plx9054_eeprom_exist]"<<std::endl;
	std::cout<<"19	AG34410A_controlpanel [select_visa_usb_device]"<<std::endl;
	std::cout<<"20	MSO7034B_controlpanel"<<std::endl;
	std::cout<<"21	UART_controlpanel [select_visa_serialport]"<<std::endl;
	std::cout<<"22	check_plx9054_eeprom_is_cv_style [visa32_error_handler]"<<std::endl;
	std::cout<<"23	get_plx9054_fpga_logic_version"<<std::endl;
	std::cout<<"24	burn_cv_style_eeprom_for_this_plx9054 [plx9054_read_eeprom_32]"<<std::endl;
	std::cout<<"25	memory_bit_clear memory_bit_set memory_bit_test"<<std::endl;
	std::cout<<"26	plx9054_reset_card"<<std::endl;
	std::cout<<"27	plx9054_write_eeprom_32 [float_input]"<<std::endl;
	std::cout<<"28	select_visa_device select_visa_gpib_device select_visa_lxi_device select_visa_bus visa_interactive_io"<<std::endl;
	std::cout<<"29	fft"<<std::endl;
	std::cout<<"30	float_hex_convert"<<std::endl;
	std::cout<<"31	least_squares"<<std::endl;
	std::cout<<"32	dram_stress_testing"<<std::endl;
	std::cout<<"33	progress_win_thread"<<std::endl;
	std::cout<<"34	run_regbit and run_lxi_search"<<std::endl;
	std::cout<<"--------end--------"<<std::endl;
	std::cout<<"100	for AG34410A"<<std::endl;
	std::cout<<"101	for cable_tester"<<std::endl;

//-----------------------------------------------------------------------
	std::cout<<std::endl<<">>";
}
//-----------------------------------------------------------------------
///主函数放在这里面了
dll_test_frame	app;
//-----------------------------------------------------------------------
///main主函数未使用
int main(int argc, char* argv[])
{
	return 0;
}

void dll_test_frame::test34()
{
	VISA32_PB_WRAPPER_DLL::run_regbit();
	VISA32_PB_WRAPPER_DLL::run_lxi_search();
}
