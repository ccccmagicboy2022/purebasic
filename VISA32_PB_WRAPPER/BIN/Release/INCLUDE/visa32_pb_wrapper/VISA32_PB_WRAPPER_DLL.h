///VISA32_PB_WRAPPER.dll导出函数的声明
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
 * DLL functions from VISA32_PB_WRAPPER.dll
 */

#if !defined(_VISA32_PB_WRAPPER_DLL_H)
#define _VISA32_PB_WRAPPER_DLL_H

///从VISA32_PB_WRAPPER.dll导出的全部为使用PB封装的stdcall函数
/** 
 *	将这些导出函数统一封装到命名空间VISA32_PB_WRAPPER_DLL
 */	
namespace	VISA32_PB_WRAPPER_DLL
{
	///定义为DLL导出函数
	#define CVLIB_API_IN __declspec(dllimport)
	///AG34410A_controlpanel，万用表AG34410A的控制面板
	/** 
	 *	可以控制仪表做简单的采集功能，如电压、电流采集，同时可以设置常用的量程，可以手动或连续采集，
	 *	并可记录，界面显示要醒目。	
	 *	@param		[in]	param1	char*类型，指向资源字符串
     * 	@retval		true	成功
     * 	@retval		false	失败
     * 	@retval		其他	未知错误	 
	 *	@pre		VISA32_PB_WRAPPER_DLL::visa_check_setup()
	 *	@pre		VISA32_PB_WRAPPER_DLL::load_wrapper_dll()
	 *	@todo		<b>基本功能尚未实现@[19]</b>
	 *	@since		2012.12.17
	 */
	extern	"C"	CVLIB_API_IN	DWORD	WINAPI	AG34410A_controlpanel(const	LPCVOID	param1);
	///MSO7034B_controlpanel，示波器MSO7034B的控制面板
	/** 
	 *	可以从示波器抓取彩色或者灰度截图，设置通道的标签、使能、触发等。	 
	 *	@param		[in]	param1	char*类型，指向资源字符串
     * 	@retval		true	成功
     * 	@retval		false	失败
     * 	@retval		其他	未知错误	 
	 *	@pre		VISA32_PB_WRAPPER_DLL::visa_check_setup()
	 *	@pre		VISA32_PB_WRAPPER_DLL::load_wrapper_dll()
	 *	@todo		基本功能已经实现，需要进一步完善@[20]
	 *	@since		2012.12.17
	 */
	extern	"C"	CVLIB_API_IN	DWORD	WINAPI	MSO7034B_controlpanel(const	LPCVOID	param1);
	///UART_controlpanel，通用串口控制面板
	/** 
	 *	可以设置通迅的波特率、数据位、校验位、停止位等参数。
	 *	@param		[in]	param1	char*类型，指向资源字符串
     * 	@retval		true	成功
     * 	@retval		false	失败
     * 	@retval		其他	未知错误	 
	 *	@pre		VISA32_PB_WRAPPER_DLL::visa_check_setup()
	 *	@pre		VISA32_PB_WRAPPER_DLL::load_wrapper_dll()
	 *	@todo		<b>基本功能尚未实现@[21]</b> 
	 *	@since		2012.12.17
	 */	
	extern	"C"	CVLIB_API_IN	DWORD	WINAPI	UART_controlpanel(const	LPCVOID	param1);
	///burn_cv_style_eeprom_for_this_plx9054给使用plx9054芯片的PCI/PXI板烧写配套逻辑默认的EEPROM内容
	/** 
	 *	@param		[in]	param1	已打开的资源visa_res
	 *	@param		[in]	param2	新的DID/VID的值
     * 	@retval		true	成功
     * 	@retval		false	失败
	 *	@pre		VISA32_PB_WRAPPER_DLL::visa_check_setup()
	 *	@pre		VISA32_PB_WRAPPER_DLL::load_wrapper_dll()
	 *	@pre		VISA32_PB_WRAPPER_DLL::is_plx9054_exist()
	 *	@pre		VISA32_PB_WRAPPER_DLL::is_plx9054_eeprom_exist()
	 *	@pre		VISA32_PB_WRAPPER_DLL::check_plx9054_eeprom_is_cv_style()
	 *	@see		VISA32_PB_WRAPPER_DLL::plx9054_eeprom_user_data_viewer()
	 *	@see		VISA32_PB_WRAPPER_DLL::plx9054_eeprom_access()	 
	 *	@since		2012.12.17
	 */		
	extern	"C"	CVLIB_API_IN	bool	WINAPI	burn_cv_style_eeprom_for_this_plx9054(const	DWORD	param1, const	DWORD	param2);
	///check_plx9054_eeprom_is_cv_style检查板上的EEPROM内容是否是符合标准的
	/** 
	 *	@param		[in]	param1	已打开的资源visa_res
     * 	@retval		true	成功
     * 	@retval		false	失败
	 *	@pre		VISA32_PB_WRAPPER_DLL::visa_check_setup()
	 *	@pre		VISA32_PB_WRAPPER_DLL::load_wrapper_dll()
	 *	@pre		VISA32_PB_WRAPPER_DLL::is_plx9054_exist()
	 *	@pre		VISA32_PB_WRAPPER_DLL::is_plx9054_eeprom_exist()
	 *	@see		VISA32_PB_WRAPPER_DLL::burn_cv_style_eeprom_for_this_plx9054()	 
	 *	@see		VISA32_PB_WRAPPER_DLL::plx9054_eeprom_user_data_viewer()
	 *	@see		VISA32_PB_WRAPPER_DLL::plx9054_eeprom_access()
	 *	@since		2012.12.17
	 */			
	extern	"C"	CVLIB_API_IN	bool	WINAPI	check_plx9054_eeprom_is_cv_style(const	DWORD	param1);
	///about lib的窗体
	/** 
	 *	@since		2012.12.15
	 */		
	extern	"C"	CVLIB_API_IN	WINAPI	about_cv();
	///beeper 高音线程
	/** 
	 *	@param		[in]	param1	持续时间，单位为ms
	 *	@see		VISA32_PB_WRAPPER_DLL::beeper_wrapper2()
	 *	@since		2012.12.15
	 */		
	extern	"C"	CVLIB_API_IN	WINAPI	beeper_wrapper1(const	DWORD	param1);
	///beeper 低音线程
	/** 
	 *	@param		[in]	param1	持续时间，单位为ms
	 *	@see		VISA32_PB_WRAPPER_DLL::beeper_wrapper1()	 
	 *	@since		2012.12.15
	 */
	extern	"C"	CVLIB_API_IN	WINAPI	beeper_wrapper2(const	DWORD	param1);
	///close lib关闭库的使用
	/** 
	 *	@see		VISA32_PB_WRAPPER_DLL::load_wrapper_dll()		
	 *	@since		2012.12.14
	 */	
	extern	"C"	CVLIB_API_IN	WINAPI	close_wrapper_dll();
	///dec整数输入窗体
	/** 
	 *	@param		[in]	param1	DWORD整数的指针	
	 *	@param		[out]	param1	DWORD整数的指针
     * 	@retval		true	成功
     * 	@retval		false	失败
	 *	@see		VISA32_PB_WRAPPER_DLL::string_input()	
	 *	@see		VISA32_PB_WRAPPER_DLL::float_input()	 
	 *	@see		VISA32_PB_WRAPPER_DLL::hex_input()	 	 	 
	 *	@since		2012.12.15
	 */	
	extern	"C"	CVLIB_API_IN	bool	WINAPI	dec_input(DWORD*	const	param1);	
	///DWORD改变字节序
	/** 
	 *	@param		[in]	param1	调整前的DWORD整数	
     * 	@return		DWORD	调整后的DWORD整数
	 *	@since		2012.12.15
	 */	
	extern	"C"	CVLIB_API_IN	DWORD	WINAPI	dword_change_endian(const	DWORD	param1);
	///DWORD改变bit序
	/** 
	 *	@param		[in]	param1	调整前的DWORD整数	
     * 	@return		DWORD	调整后的DWORD整数
	 *	@since		2013.2.4
	 */	
	extern	"C"	CVLIB_API_IN	DWORD	WINAPI	dword_reverse_bits(const	DWORD	param1);
	///fft运算
	/** 
	 *	快速傅利叶变换的运算实现
	 *	@param		[in][out]	x[]		数组x存储时域序列的实部
	 *	@param		[in][out]	y[]		数组y存储时域序列的虚部
	 *	@param		[in]		param1	代表N点FFT
	 *	@param		[in]		param2	=1为FFT，=-1为IFFT
	 *	@since		2012.12.17
	 */	
	extern	"C"	CVLIB_API_IN	WINAPI	do_FFT(double	x[], double	y[], const	int	param1, const	int	param2);
	///float and hex convert
	/** 
	 *	float型与DWORD型整数之间的转换窗体	
	 *	@since		2012.12.17
	 */		
	extern	"C"	CVLIB_API_IN	WINAPI	float_hex_convert();
	///float输入，可以设置四舍五入小数点的位数的一个窗体
	/** 
	 *	@param		[in]	param1	float数的指针	
	 *	@param		[out]	param1	float数的指针
	 *	@param		[in]	param2	DWORD整数用于指定四舍五入小数点的位数	
	 *	@see		VISA32_PB_WRAPPER_DLL::string_input()	
	 *	@see		VISA32_PB_WRAPPER_DLL::hex_input()	 
	 *	@see		VISA32_PB_WRAPPER_DLL::dec_input()	 	 	 
     * 	@retval		true	成功
     * 	@retval		false	失败
	 *	@since		2012.12.15
	 */	
	extern	"C"	CVLIB_API_IN	bool	WINAPI	float_input(float*	const	param1, const	DWORD	param2);
	///get plx9054 fpga logic version获取FPGA逻辑的设计版本号，这是由逻辑写入到MBOX7寄存器的。
	/** 
	 *	@param		[in]	param1	已打开的资源visa_res
     * 	@return		DWORD	记录版本号的整数
	 *	@pre		VISA32_PB_WRAPPER_DLL::visa_check_setup()
	 *	@pre		VISA32_PB_WRAPPER_DLL::load_wrapper_dll()
	 *	@since		2012.12.17
	 */	
	extern	"C"	CVLIB_API_IN	DWORD	WINAPI	get_plx9054_fpga_logic_version(const	DWORD	param1);	
	///get visa server ip获取进行在网内的windows版本ni-visa server的IP地址的一个窗体。
	/** 
	 *	@param		[in]	param1	记录ip地址整数的指针
	 *	@param		[out]	param1	记录ip地址整数的指针	 
     * 	@retval		true	成功
     * 	@retval		false	失败
	 *	@pre		VISA32_PB_WRAPPER_DLL::load_wrapper_dll()	 
	 *	@since		2012.12.15
	 */		
	extern	"C"	CVLIB_API_IN	bool	WINAPI	get_visa_server_ip(DWORD*	const	param1);
	///hex输入窗体, 支持8 16 32位的整数
	/** 
	 *	@param		[in]	param1	记录DWORD整数的指针
	 *	@param		[out]	param1	记录DWORD整数的指针	 
	 *	@param		[in]	param2	位宽，可以为8, 16或者32
	 *	@see		VISA32_PB_WRAPPER_DLL::string_input()	
	 *	@see		VISA32_PB_WRAPPER_DLL::float_input()	 
	 *	@see		VISA32_PB_WRAPPER_DLL::dec_input()	 	 
     * 	@retval		true	成功
     * 	@retval		false	失败
	 *	@since		2012.12.15
	 */	
	extern	"C"	CVLIB_API_IN	bool	WINAPI	hex_input(DWORD*	const	param1, const	DWORD	param2);
	///is plx9054 eeprom exist查看是否存在PLX9054的EEPROM。
	/** 
	 *	@param		[in]	param1	char*类型，指向资源字符串
     * 	@retval		true	成功
     * 	@retval		false	失败
	 *	@pre		VISA32_PB_WRAPPER_DLL::visa_check_setup()
	 *	@pre		VISA32_PB_WRAPPER_DLL::load_wrapper_dll()
	 *	@pre		VISA32_PB_WRAPPER_DLL::is_plx9054_exist()
	 *	@since		2012.12.17
	 */			
	extern	"C"	CVLIB_API_IN	bool	WINAPI	is_plx9054_eeprom_exist(const	LPCVOID	param1);
	///is plx9054 exist查看是否存在PLX9054桥芯片
	/** 
	 *	@param		[in]	param1	char*类型，指向资源字符串
     * 	@retval		true	成功
     * 	@retval		false	失败
	 *	@pre		VISA32_PB_WRAPPER_DLL::visa_check_setup()
	 *	@pre		VISA32_PB_WRAPPER_DLL::load_wrapper_dll()
	 *	@since		2012.12.17
	 */	
	extern	"C"	CVLIB_API_IN	bool	WINAPI	is_plx9054_exist(const	LPCVOID	param1);
	///least_squares最小二乘法运算
	/** 
	 *	@param		[in]	param1	数据个数
	 *	@param		[in]	x[]		包括param1个double数据的x数组
	 *	@param		[in]	y[]		包括param1个double数据的y数组
	 *	@param		[in]	param2	阶数
	 *	@param		[out]	a[]		得出的系数数组	
	 *	@since		2012.12.18
	 */		
	extern	"C"	CVLIB_API_IN	WINAPI	least_squares(const	DWORD	param1, const	double	x[], const	double	y[], const	DWORD	param2, double	a[]);
	///load lib加载库
	/** 
	 *	@see		VISA32_PB_WRAPPER_DLL::close_wrapper_dll()
	 *	@since		2012.12.14
	 */		
	extern	"C"	CVLIB_API_IN	WINAPI	load_wrapper_dll();	
	///memory_bit_clear对指定地址的DWORD数据清某位为0
	/** 
	 *	@param		[in]	param1	已打开的资源visa_res
	 *	@param		[in]	param2	要操作bar0~bar5中的一个
	 *	@param		[in]	param3	要操作的偏移地址
	 *	@param		[in]	param4	要操作的0~31bit中的一个
	 *	@see		VISA32_PB_WRAPPER_DLL::memory_bit_test()
	 *	@see		VISA32_PB_WRAPPER_DLL::memory_bit_set()
	 *	@pre		VISA32_PB_WRAPPER_DLL::visa_check_setup()
	 *	@warning	这里的偏移地址都是DWORD边界的地址，如0x0, 0x4, 0x8, 0xC等
	 *	@warning	param4只能在0~31中取值，其它时无效
	 *	@since		2012.12.18
	 */		
	extern	"C"	CVLIB_API_IN	WINAPI	memory_bit_clear(const	DWORD	param1, const	DWORD	param2, const	DWORD	param3, const	DWORD	param4);
	///memory_bit_set对指定地址的DWORD数据置某位为1
	/** 
	 *	@param		[in]	param1	已打开的资源visa_res
	 *	@param		[in]	param2	要操作bar0~bar5中的一个
	 *	@param		[in]	param3	要操作的偏移地址
	 *	@param		[in]	param4	要操作的0~31bit中的一个
	 *	@see		VISA32_PB_WRAPPER_DLL::memory_bit_test()
	 *	@see		VISA32_PB_WRAPPER_DLL::memory_bit_clear()
	 *	@pre		VISA32_PB_WRAPPER_DLL::visa_check_setup()	 
	 *	@warning	这里的偏移地址都是DWORD边界的地址，如0x0, 0x4, 0x8, 0xC等
	 *	@warning	param4只能在0~31中取值，其它时无效
	 *	@since		2012.12.18
	 */		
	extern	"C"	CVLIB_API_IN	WINAPI	memory_bit_set(const	DWORD	param1, const	DWORD	param2, const	DWORD	param3, const	DWORD	param4);	
	///memory_bit_test读取指定地址的DOWRD数据中的某一位的值
	/** 
	 *	@param		[in]	param1	已打开的资源visa_res
	 *	@param		[in]	param2	要操作bar0~bar5中的一个
	 *	@param		[in]	param3	要操作的偏移地址
	 *	@param		[in]	param4	要操作的0~31bit中的一个
	 *	@return		bool读取的值 
	 *	@see		VISA32_PB_WRAPPER_DLL::memory_bit_set()
	 *	@see		VISA32_PB_WRAPPER_DLL::memory_bit_clear()
	 *	@pre		VISA32_PB_WRAPPER_DLL::visa_check_setup()	 
	 *	@warning	这里的偏移地址都是DWORD边界的地址，如0x0, 0x4, 0x8, 0xC等
	 *	@warning	param4只能在0~31中取值，其它时无效
	 *	@since		2012.12.18
	 */		
	extern	"C"	CVLIB_API_IN	bool	WINAPI	memory_bit_test(const	DWORD	param1, const	DWORD	param2, const	DWORD	param3, const	DWORD	param4);	
	///pnp列表窗体，列出PNP的USB设备及PCI设备
	/** 
	 *	@since		2012.12.15
	 */		
	extern	"C"	CVLIB_API_IN	WINAPI	pci_usb_pnp_list();
	///plx9054_dma_controlpanel 控制PLX9054的相关寄存器的向导窗体，可以配置参数并操作DMA的执行
	/** 
	 *	@param		[in]	param1	指向card_info类的指针
     * 	@retval		true	成功
     * 	@retval		false	失败
     * 	@retval		其他	未知错误	 
	 *	@pre		VISA32_PB_WRAPPER_DLL::visa_check_setup()
	 *	@pre		VISA32_PB_WRAPPER_DLL::load_wrapper_dll()
	 *  @see    	card_info	 
	 *  @see    	VISA32_PB_WRAPPER_DLL::plx9054_dma_spy()
	 *	@since		2012.12.18
	 */
	extern	"C"	CVLIB_API_IN	DWORD	WINAPI	plx9054_dma_controlpanel(const	LPCVOID	param1);
	///plx9054_dma_spy对所有DMA相关寄存器进行访问的窗体
	/** 
	 *	@param		[in]	param1	指向card_info类的指针
     * 	@retval		true	成功
     * 	@retval		false	失败
     * 	@retval		其他	未知错误	 
	 *	@pre		VISA32_PB_WRAPPER_DLL::visa_check_setup()
	 *	@pre		VISA32_PB_WRAPPER_DLL::load_wrapper_dll()
	 *  @see    	card_info
	 *  @see    	VISA32_PB_WRAPPER_DLL::plx9054_dma_controlpanel()
	 *	@since		2012.12.18
	 */	
	extern	"C"	CVLIB_API_IN	DWORD	WINAPI	plx9054_dma_spy(const	LPCVOID	param1);
	///plx9054_doorbell_interrupt_spy对门铃中断的监视的窗体
	/** 
	 *	@param		[in]	param1	指向card_info类的指针
     * 	@retval		true	成功
     * 	@retval		false	失败
     * 	@retval		其他	未知错误	 
	 *	@pre		VISA32_PB_WRAPPER_DLL::visa_check_setup()
	 *	@pre		VISA32_PB_WRAPPER_DLL::load_wrapper_dll()	 
	 *  @see    	card_info	 
	 *  @see    	VISA32_PB_WRAPPER_DLL::plx9054_interrupt_spy()
	 *	@since		2012.12.18
	 */	
	extern	"C"	CVLIB_API_IN	DWORD	WINAPI	plx9054_doorbell_interrupt_spy(const	LPCVOID	param1);
	///plx9054_eeprom_access访问板卡EEPROM的窗体，可以加载以及保存等（包括PLX9054使用区域及用户数据区域）
	/** 
	 *	@param		[in]	param1	指向card_info类的指针
     * 	@retval		true	成功
     * 	@retval		false	失败
     * 	@retval		其他	未知错误	 
	 *	@pre		VISA32_PB_WRAPPER_DLL::visa_check_setup()
	 *	@pre		VISA32_PB_WRAPPER_DLL::load_wrapper_dll()
	 *	@pre		VISA32_PB_WRAPPER_DLL::is_plx9054_exist()
	 *	@pre		VISA32_PB_WRAPPER_DLL::is_plx9054_eeprom_exist()	 
	 *  @see    	card_info
	 *	@see		VISA32_PB_WRAPPER_DLL::burn_cv_style_eeprom_for_this_plx9054()
	 *	@see		VISA32_PB_WRAPPER_DLL::check_plx9054_eeprom_is_cv_style()
	 *	@see		VISA32_PB_WRAPPER_DLL::plx9054_eeprom_user_data_viewer()
	 *	@todo		<b>基本功能尚未实现@[14]</b>	 
	 *	@since		2012.12.18
	 */		
	extern	"C"	CVLIB_API_IN	DWORD	WINAPI	plx9054_eeprom_access(const	LPCVOID	param1);
	///plx9054_eeprom_user_data_viewer板上EEPROM的用户区的访问窗体
	/** 
	 *	@param		[in]	param1	指向card_info类的指针
     * 	@retval		true	成功
     * 	@retval		false	失败
     * 	@retval		其他	未知错误	 
	 *	@pre		VISA32_PB_WRAPPER_DLL::visa_check_setup()
	 *	@pre		VISA32_PB_WRAPPER_DLL::load_wrapper_dll()
	 *	@pre		VISA32_PB_WRAPPER_DLL::is_plx9054_exist()
	 *	@pre		VISA32_PB_WRAPPER_DLL::is_plx9054_eeprom_exist()	 
	 *  @see    	card_info
	 *	@see		VISA32_PB_WRAPPER_DLL::burn_cv_style_eeprom_for_this_plx9054()
	 *	@see		VISA32_PB_WRAPPER_DLL::check_plx9054_eeprom_is_cv_style()
	 *	@see		VISA32_PB_WRAPPER_DLL::plx9054_eeprom_access()
	 *	@todo		基本功能已经实现，需要进一步完善@[15]
	 *	@since		2012.12.18
	 */		
	extern	"C"	CVLIB_API_IN	DWORD	WINAPI	plx9054_eeprom_user_data_viewer(const	LPCVOID	param1);
	///plx9054_interrupt_spy可以设置中断使能，以及监视中断的窗体
	/** 
	 *	@param		[in]	param1	指向card_info类的指针
     * 	@retval		true	成功
     * 	@retval		false	失败
     * 	@retval		其他	未知错误	 
	 *	@pre		VISA32_PB_WRAPPER_DLL::visa_check_setup()
	 *	@pre		VISA32_PB_WRAPPER_DLL::load_wrapper_dll()	 
	 *  @see    	card_info	 
	 *  @see    	VISA32_PB_WRAPPER_DLL::plx9054_doorbell_interrupt_spy()
	 *	@since		2012.12.18
	 */		
	extern	"C"	CVLIB_API_IN	DWORD	WINAPI	plx9054_interrupt_spy(const	LPCVOID	param1);	
	///plx9054_read_eeprom_32从EEPROM指定偏移地址读取一个DWORD数据
	/** 
	 *	@param		[in]	param1	已打开的资源visa_res
	 *	@param		[in]	param2	EEPROM的偏移地址
	 *	@param		[out]	param3	读出DWORD数据的指针	 
	 *	@pre		VISA32_PB_WRAPPER_DLL::visa_check_setup()
	 *	@pre		VISA32_PB_WRAPPER_DLL::load_wrapper_dll()
	 *	@pre		VISA32_PB_WRAPPER_DLL::is_plx9054_exist()
	 *	@pre		VISA32_PB_WRAPPER_DLL::is_plx9054_eeprom_exist()
	 *	@pre		VISA32_PB_WRAPPER_DLL::check_plx9054_eeprom_is_cv_style()
	 *	@see		VISA32_PB_WRAPPER_DLL::plx9054_eeprom_user_data_viewer()
	 *	@see		VISA32_PB_WRAPPER_DLL::plx9054_eeprom_access()
	 *	@see		VISA32_PB_WRAPPER_DLL::burn_cv_style_eeprom_for_this_plx9054()
	 *	@see		VISA32_PB_WRAPPER_DLL::plx9054_write_eeprom_32()
	 *	@since		2012.12.18
	 */		
	extern	"C"	CVLIB_API_IN	WINAPI	plx9054_read_eeprom_32(const	DWORD	param1, const	DWORD	param2, DWORD*	const	param3);
	///plx9054_write_eeprom_32向EEPROM指定偏移地址写入一个DWORD数据
	/** 
	 *	@param		[in]	param1	已打开的资源visa_res
	 *	@param		[in]	param2	EEPROM的偏移地址
	 *	@param		[in]	param3	要写入的DWORD数据	 
	 *	@pre		VISA32_PB_WRAPPER_DLL::visa_check_setup()
	 *	@pre		VISA32_PB_WRAPPER_DLL::load_wrapper_dll()
	 *	@pre		VISA32_PB_WRAPPER_DLL::is_plx9054_exist()
	 *	@pre		VISA32_PB_WRAPPER_DLL::is_plx9054_eeprom_exist()
	 *	@pre		VISA32_PB_WRAPPER_DLL::check_plx9054_eeprom_is_cv_style()
	 *	@see		VISA32_PB_WRAPPER_DLL::plx9054_eeprom_user_data_viewer()
	 *	@see		VISA32_PB_WRAPPER_DLL::plx9054_eeprom_access()
	 *	@see		VISA32_PB_WRAPPER_DLL::burn_cv_style_eeprom_for_this_plx9054()
	 *	@see		VISA32_PB_WRAPPER_DLL::plx9054_read_eeprom_32()
	 *	@since		2012.12.18
	 */		
	extern	"C"	CVLIB_API_IN	WINAPI	plx9054_write_eeprom_32(const	DWORD	param1, const	DWORD	param2, const	DWORD	param3);
	///plx9054_reset_card复位PLX9054板子，使Local总线产生复位脉冲
	/** 
	 *	@param		[in]	param1	已打开的资源visa_res
	 *	@pre		VISA32_PB_WRAPPER_DLL::visa_check_setup()
	 *	@pre		VISA32_PB_WRAPPER_DLL::load_wrapper_dll()
	 *	@see		VISA32_PB_WRAPPER_DLL::plx9054_reset_card_gui()
	 *	@since		2012.12.18
	 */		
	extern	"C"	CVLIB_API_IN	bool	WINAPI	plx9054_reset_card(const	DWORD	param1);
	///plx9054_reset_card_gui复位PLX9054板子的窗体
	/** 
	 *	@param		[in]	param1	param1	指向card_info类的指针
	 *	@pre		VISA32_PB_WRAPPER_DLL::visa_check_setup()
	 *	@pre		VISA32_PB_WRAPPER_DLL::load_wrapper_dll()
	 *	@see		VISA32_PB_WRAPPER_DLL::plx9054_reset_card()
	 *  @see    	card_info	 
	 *	@since		2012.12.18
	 */			
	extern	"C"	CVLIB_API_IN	DWORD	WINAPI	plx9054_reset_card_gui(const	LPCVOID	param1);
	///visa按bit访问PCI内存的窗体，支持8, 16, 32位的访问方式
	/** 
	 *	@param		[in]	param1	指向card_info类的指针
     * 	@retval		true	成功
     * 	@retval		false	失败
     * 	@retval		其他	未知错误	 
	 *	@pre		VISA32_PB_WRAPPER_DLL::visa_check_setup()
	 *	@pre		VISA32_PB_WRAPPER_DLL::load_wrapper_dll()	 
	 *  @see    	card_info	 
	 *  @see    	VISA32_PB_WRAPPER_DLL::pxi_block_access()
	 *  @see    	VISA32_PB_WRAPPER_DLL::pxi_register_access()
	 *	@since		2012.12.16
	 */		
	extern	"C"	CVLIB_API_IN	DWORD	WINAPI	pxi_bit_access(const	LPCVOID	param1);
	///visa按block访问PCI内存的窗体，支持8, 16, 32位的访问方式
	/** 
	 *	@param		[in]	param1	指向card_info类的指针
     * 	@retval		true	成功
     * 	@retval		false	失败
     * 	@retval		其他	未知错误	 
	 *	@pre		VISA32_PB_WRAPPER_DLL::visa_check_setup()
	 *	@pre		VISA32_PB_WRAPPER_DLL::load_wrapper_dll()	 
	 *  @see    	card_info	 
	 *  @see    	VISA32_PB_WRAPPER_DLL::pxi_bit_access()
	 *  @see    	VISA32_PB_WRAPPER_DLL::pxi_register_access()
	 *	@since		2012.12.16
	 */		
	extern	"C"	CVLIB_API_IN	DWORD	WINAPI	pxi_block_access(const	LPCVOID	param1);
	///visa寄存器访问PCI内存的窗体，支持8, 16, 32位的访问方式
	/** 
	 *	@param		[in]	param1	指向card_info类的指针
     * 	@retval		true	成功
     * 	@retval		false	失败
     * 	@retval		其他	未知错误	 
	 *	@pre		VISA32_PB_WRAPPER_DLL::visa_check_setup()
	 *	@pre		VISA32_PB_WRAPPER_DLL::load_wrapper_dll()	 
	 *  @see    	card_info	 
	 *  @see    	VISA32_PB_WRAPPER_DLL::pxi_bit_access()
	 *  @see    	VISA32_PB_WRAPPER_DLL::pxi_block_access()
	 *	@since		2012.12.16
	 */			
	extern	"C"	CVLIB_API_IN	DWORD	WINAPI	pxi_register_access(const	LPCVOID	param1);
	///select bar 0~5，选择PCI内存的基地址区bar0~bar5，其中11==bar0，其它类推
	/** 
	 *	@param		[in]	param1	代表bar的DWORD的指针
	 *	@param		[out]	param1	代表bar的DWORD的指针
     * 	@retval		true	成功
     * 	@retval		false	失败
	 *	@since		2012.12.14
	 */		
	extern	"C"	CVLIB_API_IN	bool	WINAPI	select_bar(DWORD*	const	param1);
	///select ram0_0~ram0~31，选择配合逻辑设计的ram0_x，其中每个ram0的大小为1kbyte.
	/** 
	 *	@param		[in]	param1	代表ram0_x的DWORD的指针
	 *	@param		[out]	param1	代表ram0_x的DWORD的指针
     * 	@retval		true	成功
     * 	@retval		false	失败
	 *	@since		2012.12.14
	 */			
	extern	"C"	CVLIB_API_IN	bool	WINAPI	select_ram0(DWORD*	const	param1);
	///select visa resource选择本机或者服务器visa资源的窗体（包括所有可见的资源）
	/** 
	 *	@param		[out]	param1	字符指针用于返回资源字符串
	 *	@param		[in]	param2	0=INSTR型号；非0=所有型号
     * 	@retval		true	成功
     * 	@retval		false	失败	 
	 *	@see		VISA32_PB_WRAPPER_DLL::select_visa_gpib_device()	
	 *	@see		VISA32_PB_WRAPPER_DLL::select_visa_pci_pxi_card()	 
	 *	@see		VISA32_PB_WRAPPER_DLL::select_visa_serialport()	 	 	 
	 *	@see		VISA32_PB_WRAPPER_DLL::select_visa_usb_device()	 	 	 
	 *	@pre		VISA32_PB_WRAPPER_DLL::visa_check_setup()
	 *	@pre		VISA32_PB_WRAPPER_DLL::load_wrapper_dll()	 
	 *	@since		2012.12.14
	 */		
	extern	"C"	CVLIB_API_IN	bool	WINAPI	select_visa_device(char*	const	param1, const	DWORD	param2=0);
	///select visa gpib resource选择本机或者服务器visa资源的窗体（只包括GPIB的资源）
	/** 
	 *	@param		[out]	param1	字符指针用于返回资源字符串
     * 	@retval		true	成功
     * 	@retval		false	失败	 
	 *	@see		VISA32_PB_WRAPPER_DLL::select_visa_device()	
	 *	@see		VISA32_PB_WRAPPER_DLL::select_visa_pci_pxi_card()	 
	 *	@see		VISA32_PB_WRAPPER_DLL::select_visa_serialport()	 	 	 
	 *	@see		VISA32_PB_WRAPPER_DLL::select_visa_usb_device()	 	 	 
	 *	@pre		VISA32_PB_WRAPPER_DLL::visa_check_setup()
	 *	@pre		VISA32_PB_WRAPPER_DLL::load_wrapper_dll()	 
	 *	@since		2012.12.14
	 */		
	extern	"C"	CVLIB_API_IN	bool	WINAPI	select_visa_gpib_device(char*	const	param1);
	///select visa serialport resource选择本机或者服务器visa资源的窗体（只包括串口的资源）
	/** 
	 *	@param		[out]	param1	字符指针用于返回资源字符串
     * 	@retval		true	成功
     * 	@retval		false	失败	 
	 *	@see		VISA32_PB_WRAPPER_DLL::select_visa_device()	
	 *	@see		VISA32_PB_WRAPPER_DLL::select_visa_pci_pxi_card()	 
	 *	@see		VISA32_PB_WRAPPER_DLL::select_visa_gpib_device()	 	 	 
	 *	@see		VISA32_PB_WRAPPER_DLL::select_visa_usb_device()	 	 	 
	 *	@pre		VISA32_PB_WRAPPER_DLL::visa_check_setup()
	 *	@pre		VISA32_PB_WRAPPER_DLL::load_wrapper_dll()	 
	 *	@since		2012.12.14
	 */		
	extern	"C"	CVLIB_API_IN	bool	WINAPI	select_visa_serialport(char*	const	param1);	
	
	///select visa pci/pxi resource选择本机或者服务器visa资源的窗体（只包括PCI/PXI的资源，可以指定型号）
	/** 
	 *	@param		[out]	param1	字符指针用于返回资源字符串
	 *	@param		[in]	param2	vid，如0x10b5，不写为0代表所有
	 *	@param		[in]	param3	did，如0x6888，不写为0
     * 	@retval		true	成功
     * 	@retval		false	失败	 
	 *	@see		VISA32_PB_WRAPPER_DLL::select_visa_device()	
	 *	@see		VISA32_PB_WRAPPER_DLL::select_visa_serialport()	 
	 *	@see		VISA32_PB_WRAPPER_DLL::select_visa_gpib_device()	 	 	 
	 *	@see		VISA32_PB_WRAPPER_DLL::select_visa_usb_device()	 	 	 
	 *	@pre		VISA32_PB_WRAPPER_DLL::visa_check_setup()
	 *	@pre		VISA32_PB_WRAPPER_DLL::load_wrapper_dll()	 
	 *	@since		2012.12.14
	 */		
	extern	"C"	CVLIB_API_IN	bool	WINAPI	select_visa_pci_pxi_card(char*	const	param1, const	short	param2=0, const	short	param3=0);
	///select visa usb resource选择本机或者服务器visa资源的窗体（只包括USB的资源，可以指定型号）
	/** 
	 *	@param		[out]	param1	字符指针用于返回资源字符串
	 *	@param		[in]	param2	vid，如0x1122，不写为0代表所有
	 *	@param		[in]	param3	did，如0x3344，不写为0
     * 	@retval		true	成功
     * 	@retval		false	失败	 
	 *	@see		VISA32_PB_WRAPPER_DLL::select_visa_device()	
	 *	@see		VISA32_PB_WRAPPER_DLL::select_visa_serialport()	 
	 *	@see		VISA32_PB_WRAPPER_DLL::select_visa_gpib_device()	 	 	 
	 *	@see		VISA32_PB_WRAPPER_DLL::select_visa_pci_pxi_card()	 	 	 
	 *	@pre		VISA32_PB_WRAPPER_DLL::visa_check_setup()
	 *	@pre		VISA32_PB_WRAPPER_DLL::load_wrapper_dll()	 
	 *	@since		2012.12.14
	 */		
	extern	"C"	CVLIB_API_IN	bool	WINAPI	select_visa_usb_device(char*	const	param1, const	short	param2=0, const	short	param3=0);
	///select_visa_bus选择不同总线的visa资源的引导窗体
	/** 
	 *	@param		[out]	param1	字符指针用于返回资源字符串
	 *	@param		[in]	param2	选择项目的使能mask
     * 	@retval		true	成功
     * 	@retval		false	失败	 
	 *	@see		VISA32_PB_WRAPPER_DLL::select_visa_device()	
	 *	@see		VISA32_PB_WRAPPER_DLL::select_visa_serialport()	 
	 *	@see		VISA32_PB_WRAPPER_DLL::select_visa_gpib_device()	 	 	 
	 *	@see		VISA32_PB_WRAPPER_DLL::select_visa_pci_pxi_card()	 	 	 
	 *	@see		VISA32_PB_WRAPPER_DLL::select_visa_usb_device()	 	 	 
	 *	@pre		VISA32_PB_WRAPPER_DLL::visa_check_setup()
	 *	@pre		VISA32_PB_WRAPPER_DLL::load_wrapper_dll() 
	 *	@since		2013.1.4
	 */		
	extern	"C"	CVLIB_API_IN	bool	WINAPI	select_visa_bus(char*	const	param1, const	param2	=	0xffffffff);
	///splash_launcher logo显示的闪屏
	/** 
	 *	@param		[in]	param1	指向字符串
	 *	@since		2012.12.15
	 */	
	extern	"C"	CVLIB_API_IN	WINAPI	splash_launcher(const	char*	const	param1);
	///string输入的窗体，可以输入的最大长度取决于读入的字符串的长度
	/** 
	 *	@param		[in]	param1	字符指针
	 *	@param		[out]	param1	字符指针
	 *	@see		VISA32_PB_WRAPPER_DLL::float_input()	
	 *	@see		VISA32_PB_WRAPPER_DLL::hex_input()	 
	 *	@see		VISA32_PB_WRAPPER_DLL::dec_input()	 	 	 
     * 	@retval		true	成功
     * 	@retval		false	失败
	 *	@since		2012.12.12
	 */		
	extern	"C"	CVLIB_API_IN	bool	WINAPI	string_input(char*	const	param1);	
	///visa32_error_handler错误处理的回调函数，配合ni-visa的事件注册函数
	/** 
	 *	@since		2012.12.18
	 */		
	extern	"C"	CVLIB_API_IN	long	WINAPI	visa32_error_handler(DWORD, DWORD, DWORD, LPVOID);
	///check visa lib setup查看是否安装了ni-visa，推荐使用v3.3.1
	/** 
	 *	@since		2012.12.15
     * 	@retval		true	已安装
     * 	@retval		false	未安装 
	 */		
	extern	"C"	CVLIB_API_IN	bool	WINAPI	visa_check_setup();
	///visa server remote远程关机重启动控制器的窗体
	/** 
	 *	@param		[in]	param1	指向pc_info类的指针
     * 	@retval		true	成功
     * 	@retval		false	失败
     * 	@retval		其他	未知错误	 
	 *	@pre		VISA32_PB_WRAPPER_DLL::visa_check_setup()
	 *	@pre		VISA32_PB_WRAPPER_DLL::load_wrapper_dll()
	 *  @see    	pc_info
	 *	@note		用户保证IP地址为有效的visa_server
	 *	@since		2012.12.15
	 */		
	extern	"C"	CVLIB_API_IN	DWORD	WINAPI	visa_server_remote(const	LPCVOID	param1);
	///visa_interactive_io类似agilent io提供的一个小工具的窗体，用于调试VISA32信息型设备
	/** 	
	 *	@param		[in]	param1	DWORD类型，资源session id
     * 	@retval		true	成功
     * 	@retval		false	失败
     * 	@retval		其他	未知错误	 
	 *	@todo		基本功能已经实现，需要进一步完善@[28]
	 *	@since		2013.1.7
	 */
	extern	"C"	CVLIB_API_IN	DWORD	WINAPI	visa_interactive_io(const	DWORD	param1);
	///修改VISA32别名的工具窗体
	/** 
	 *	@since		2013.1.12
	 */		
	extern	"C"	CVLIB_API_IN	DWORD	WINAPI	visa_alias_editor();
	///修改VISA32远程系统的工具窗体
	/** 
	 *	@since		2013.2.23
	 */		
	extern	"C"	CVLIB_API_IN	DWORD	WINAPI	visa_remote_system_editor();	
	///查看用户是否已注册本DLL
	/** 
	 *	@retval	true	已成功注册
	 *	@retval	false	未注册
	 */		
	extern	"C"	CVLIB_API_IN	bool	WINAPI	check_reg_sn();
	///为库窗体选择皮肤
	/** 
	 *	@since		2013.1.25
	 */		
	extern	"C"	CVLIB_API_IN	WINAPI	select_lib_skin();
	///dram压力测试
	/** 
	 *	@param		[in]	card_res	已打开的session
	 *	@param		[in]	mem_bar		基地址
	 *	@param		[in]	mem_address_begin 起始地址
	 *	@param		[in]	mem_byte_size 多少个字节的数据量
	 *	@param		[in]	access_mode	支持8, 16, 32三种
	 *	@param		[in]	access_times	 
	 *	@return	返回的总的错误字节数
	 */		
	extern	"C"	CVLIB_API_IN	DWORD	WINAPI	dram_stress_testing(const	DWORD	card_res, const	DWORD	mem_bar, const	DWORD	mem_address_begin, const	DWORD	mem_byte_size,	const	DWORD	access_mode,	const	DWORD	access_times);
	///选择使用支持LXI的VISA32设备
	/** 
	 *	@param		[out]	param1	字符指针用于返回资源字符串
     * 	@retval		true	成功
     * 	@retval		false	失败	 
	 *	@pre		VISA32_PB_WRAPPER_DLL::visa_check_setup()
	 *	@pre		VISA32_PB_WRAPPER_DLL::load_wrapper_dll()	
	 *	@todo		基本功能已经实现，需要进一步完善@[28]	 
	 *	@since		2013.2.11
	 */		
	extern	"C"	CVLIB_API_IN	bool	WINAPI	select_visa_lxi_device(char*	const	param1);
	///visa pxi/pci tree
	/** 
	 *	@since		2013.3.27
	 *	@todo		基本功能已经实现，需要进一步完善@[5]	 
	 */		
	extern	"C"	CVLIB_API_IN	bool	WINAPI	visa_pxi_tree();
	///progress_win_thread一个超时等待窗口
	/** 
	 *	@param		[in]	timelong	窗口的生命时间
	 *	@return		返回PB的ThreadID
	 */		
	extern	"C"	CVLIB_API_IN	DWORD	WINAPI	progress_win_thread(const	DWORD	timelong);
	extern	"C"	CVLIB_API_IN	DWORD	WINAPI	run_regbit();
	extern	"C"	CVLIB_API_IN	DWORD	WINAPI	run_lxi_search();
}

#endif  //_VISA32_PB_WRAPPER_DLL_H
