 //////////////////////////////////////////////////////////////////////////
 ///     Copyright (c) 2011, 北京康拓科技有限公司，
 ///     All rights reserved.
 ///
 /// @file			cvPXILib.h
 /// @brief			cvPXILib.dll函数导出头文件
 ///
 /// 	本dll实现访问PCI总线所需要的所有基本功能函数
 ///
 /// @version 	1.0.0.1	(当前)
 /// @author    系统二部	崔巍
 /// @date      2011.09.15
 ///
 ///	v1.0.0.1\n
 ///    修订说明：最初版本
 ////////////////////////////////////////////////////////////////////////// 

// The following ifdef block is the standard way of creating macros which make exporting 
// from a DLL simpler. All files within this DLL are compiled with the CVPXILIB_EXPORTS
// symbol defined on the command line. this symbol should not be defined on any project
// that uses this DLL. This way any other project whose source files include this file see 
// CVPXILIB_API functions as being imported from a DLL, wheras this DLL sees symbols
// defined with this macro as being exported.

///定义cvPXILib.dll的导入（出）函数头
/**这里使用cdecl的方式*/
#ifdef CVPXILIB_EXPORTS
#define CVPXILIB_API __declspec(dllexport)
#else
#define CVPXILIB_API __declspec(dllimport)
#endif


///板卡资源结构体类型
/** 板卡资源结构体用于描述一块板卡可支配的物理内存资源	*/
typedef struct
{
	unsigned	int	bar0;				///<bar0的首地址(映射为plx9054的寄存器)
	unsigned	int	bar2;				///<bar2的首地址(映射为双口ram)
	unsigned	int	bar3;				///<bar3的首地址(映射为fifo)
	unsigned	int	dma_buffer;			///<dma buffer(物理连续的内存)的首地址
	unsigned	int	dma_buffer_size;	///<申请到的可用buffer的大小
}card_res;


///定制逻辑的板卡信息详细结构体
/**片上逻辑生成的存储单元记录着板卡及逻辑的基本信息，只适用于使用plx9054芯片的按ram0分配规定编写逻辑的板卡*/
typedef	struct
{
	unsigned	int	project;///<项目编号
	unsigned	int	card;///<GX工程的板卡编号
	unsigned	int	varient;///<板卡变体号
	unsigned	int	chasis_slot;///<所在槽位号
	unsigned	int	designer;///<设计人员编号
	unsigned	int	fpga_version;///<板载程序版本，包括ISE版本及逻辑版本
	unsigned	int	chasis_type;///<机箱的类型号
	unsigned	int	bus_type;///<总线类型CPCI3U, PXI3U...
	unsigned	int	backup1;///<备用1
	unsigned	int	backup2;///<备用2
}card_detail_info;


/// 调试专用的控制结构体
/**包括mso7034b示波器以及xilinx的chipscope*/
typedef	struct
{
	unsigned	int	mso7034b;///<示波器的档位选择
	unsigned	int chipscope_signal_select;///<chipscope的档位选择
	unsigned	int	chipscope_clk_select;///<chipscope的时钟选择
	unsigned	int	backup1;///<备用1
	unsigned	int	backup2;///<备用2
}debug;


/// 板卡识别码的整数值
/**bus:xxx, device:xxx, function:xxx*/
typedef	struct
{
	unsigned	int	bus;///<bus
	unsigned	int	device;///<device
	unsigned	int	function;///<function
}card;


/// 映射物理内存到虚空间
/** 
 *	把一定大小的连续的物理内存映射到虚空间来进行访问，虚空间的内存也已经申请好。
 *  @param [in]		p_address	物理内存的地址；
 *  @param [in]		size 		物理内存的大小；
 *	@param [out]	v_address	空指针用于数据访问（对应空间大小同size）；
 *	@param [out]	map_handle	映射handle，用于释放。
 *  @return 返回值说明\n
		1----成功\n
		0----失败
 *  @note    注意的问题
 *	@warning  使用者负责物理内存地址及大小的有效性
 *  @see    	UnMapPhysicalMemory_wrapper()
 *
 */
extern	"C"	CVPXILIB_API	int	__stdcall	MapPhysicalMemory_wrapper(unsigned int	p_address, unsigned int	size, void*	v_address, int*	map_handle);


/// 释放映射的物理内存的虚空间
/** 
 *	与MapPhysicalMemory_wrapper对应使用，用于释放映射及虚空间。
 *	@param [in]	map_handle	映射handle，用于释放。
 *  @return 返回值说明\n
		1----成功\n
		0----失败
 */
extern	"C"	CVPXILIB_API	int	__stdcall	UnMapPhysicalMemory_wrapper(int	map_handle);


/// 寻找板卡资源
/** 
 *	通过板卡识别号获取板卡可支配的物理内存资源。
 *	@param [in]		card_find	板卡识别号；
 *	@param [out]	res			板卡资源结构；
 *  @return		true/false 对应 正常/异常
 *  @note    	使用cvPXILib前请确保安装cvPXIRunTime。\n <b>PCI通用函数</b>
 *	@warning  	当本函数运行前出现了错误，本函数只传递错误不运行功能。
 *  @see    	N/A
 */
extern	"C"	CVPXILIB_API	bool	__stdcall	find_resource(unsigned	int	card_find, card_res*	res);


/// helloworld
/**用于测试本DLL的存在，弹出一个消息窗口*/
extern	"C"	CVPXILIB_API	void	__stdcall	HelloWorldDLL();


/// CVIRTE库状态测试
/** 
 *	测试CVIRTE库是否正常安装及注册，不正常时会有消息窗口弹出提示并输出错误信息。当本函数运行前出现错误，本函数只传递错误。
 *	@param [in]		error		错误结构入；
 *  @param [out]	error		错误结构出；
 *  @return 0/1分别表示未加载/已加载
 *  @note    	使用cvPXILib前请确保安装cvPXIRunTime。\n <b>PCI通用函数</b>
 *	@warning  	N/A
 *  @see    	plxapi_status()\n windriver_status()
 */
extern	"C"	CVPXILIB_API	bool	__stdcall	cvirte_status(void);


/// 8位IO读
/** 
 *	8位IO读取端口地址中的数据。
 *	@param [in]		address		IO地址；
 *  @return 所读取的数据为8位整数。
 *  @note    	<b>PCI通用函数</b>
 *	@warning  	使用者负责IO地址的有效性。
 *  @see    	CVI_inpw_wrapper()\n CVI_inpd_wrapper()
 */
extern	"C"	CVPXILIB_API	char	__stdcall	CVI_inp_wrapper(int	address);


/// 16位IO读
/** 
 *	16位IO读取端口地址中的数据。
 *	@param [in]		address		IO地址；
 *  @return 所读取的数据为16位整数。
 *  @note    	<b>PCI通用函数</b>
 *	@warning  	使用者负责IO地址的有效性。
 *  @see    	CVI_inp_wrapper()\n CVI_inpd_wrapper()
 */
extern	"C"	CVPXILIB_API	short	__stdcall	CVI_inpw_wrapper(int	address);


/// 32位IO读
/** 
 *	32位IO读取端口地址中的数据。
 *	@param [in]		address		IO地址；
 *  @return 所读取的数据为32位整数。
 *  @note    	<b>PCI通用函数</b>
 *	@warning  	使用者负责IO地址的有效性。
 *  @see    	CVI_inp_wrapper()\n CVI_inpw_wrapper()
 */
extern	"C"	CVPXILIB_API	long	__stdcall	CVI_inpd_wrapper(short	address);


/// 8位IO写
/** 
 *	用8位IO数据写端口地址。
 *	@param [in]		address		IO地址；
 *	@param [in]		data		8位整数数据
 *  @return 所写的数据（8位整数）。
 *  @note    	<b>PCI通用函数</b>
 *	@warning  	使用者负责IO地址的有效性。
 *  @see    	CVI_outpw_wrapper()\n CVI_outpd_wrapper()
 */
extern	"C"	CVPXILIB_API	char	__stdcall	CVI_outp_wrapper(int	address, char	data);


/// 16位IO写
/** 
 *	用16位IO数据写端口地址。
 *	@param [in]		address		IO地址；
 *	@param [in]		data		16位整数数据
 *  @return 所写的数据（16位整数）。
 *  @note    	<b>PCI通用函数</b>
 *	@warning  	使用者负责IO地址的有效性。
 *  @see    	CVI_outp_wrapper()\n CVI_outpd_wrapper()
 */
extern	"C"	CVPXILIB_API	short	__stdcall	CVI_outpw_wrapper(short	address, short	data);


/// 32位IO写
/** 
 *	用32位IO数据写端口地址。
 *	@param [in]		address		IO地址；
 *	@param [in]		data		32位整数数据
 *  @return 所写的数据（32位整数）。
 *  @note    	<b>PCI通用函数</b>
 *	@warning  	使用者负责IO地址的有效性。
 *  @see    	CVI_outp_wrapper()\n CVI_outpw_wrapper()
 */
extern	"C"	CVPXILIB_API	long	__stdcall	CVI_outpd_wrapper(short	address, long	data);


/// 8位Memory读
/** 
 *	使用8位Memory读的方式获取物理内存中的数据。
 *	@param [in]		address		Memory地址；
 *  @return 所读出的数据（8位整数）。
 *  @note    	<b>PCI通用函数</b>
 *	@warning  	使用者负责物理内存地址的有效性。
 *  @see    	ReadPhyMem16()\n ReadPhyMem32()
 */
extern	"C"	CVPXILIB_API	char	__stdcall	ReadPhyMem8(long	address);


/// 16位Memory读
/** 
 *	使用16位Memory读的方式获取物理内存中的数据。
 *	@param [in]		address		Memory地址；
 *  @return 所读出的数据（16位整数）。
 *  @note    	要使用16位的memory地址，如以0x0, 0x2, 0x4, 0x8...结尾的地址。\n <b>PCI通用函数</b>
 *	@warning  	使用者负责物理内存地址的有效性。
 *  @see    	ReadPhyMem8()\n ReadPhyMem32()
 */
extern	"C"	CVPXILIB_API	short	__stdcall	ReadPhyMem16(long	address);


/// 32位Memory读
/** 
 *	使用32位Memory读的方式获取物理内存中的数据。
 *	@param [in]		address		Memory地址；
 *  @return 所读出的数据（32位整数）。
 *  @note    	要使用32位的memory地址，如以0x0, 0x4, 0x8, 0xc结尾的地址。\n <b>PCI通用函数</b>
 *	@warning  	使用者负责物理内存地址的有效性。
 *  @see    	ReadPhyMem8()\n ReadPhyMem16()
 */
extern	"C"	CVPXILIB_API	long	__stdcall	ReadPhyMem32(long	address);


/// 8位Memory写
/** 
 *	使用8位Memory写的方式将数据写入指定的物理内存地址中。
 *	@param [in]		address		Memory地址；
 *	@param [in]		data		8位整数；
 *  @return 无
 *  @note    	<b>PCI通用函数</b>
 *	@warning  	使用者负责物理内存地址的有效性。
 *  @see    	WritePhyMem16()\n WritePhyMem32()
 */
extern	"C"	CVPXILIB_API	void	__stdcall	WritePhyMem8(long	address, char	data);


/// 16位Memory写
/** 
 *	使用16位Memory写的方式将数据写入指定的物理内存地址中。
 *	@param [in]		address		Memory地址；
 *	@param [in]		data		16位整数；
 *  @return 无
 *  @note    	要使用16位的memory地址，如以0x0, 0x2, 0x4, 0x8...结尾的地址。<b>PCI通用函数</b>
 *	@warning  	使用者负责物理内存地址的有效性。
 *  @see    	WritePhyMem8()\n WritePhyMem32()
 */
extern	"C"	CVPXILIB_API	void	__stdcall	WritePhyMem16(long	address, short	data);


/// 32位Memory写
/** 
 *	使用32位Memory写的方式将数据写入指定的物理内存地址中。
 *	@param [in]		address		Memory地址；
 *	@param [in]		data		32位整数；
 *  @return 无
 *  @note    	要使用32位的memory地址，如以0x0, 0x4, 0x8, 0xc结尾的地址。\n <b>PCI通用函数</b>
 *	@warning  	使用者负责物理内存地址的有效性。
 *  @see    	WritePhyMem8()\n WritePhyMem16()
 */
extern	"C"	CVPXILIB_API	void	__stdcall	WritePhyMem32(long	address, long	data);


/// 复位板卡逻辑
/** 
 *	根据板卡识别号使使用PLX9054桥芯片的板子产生复位脉冲并复位9054内部寄存器。
 *	@param [in]		card_find		板卡识别号；
 *  @return N/A
 *  @note    	<b>PLX9054专用函数</b>
 *	@warning  	使用者负责板卡识别号的有效性。
 *  @see    	N/A
 */
extern	"C"	CVPXILIB_API	void	__stdcall	ResetCard(unsigned	int	card_find);


/// 判断板子是否使用plx9054桥芯片
/** 
 *	根据板卡识别号判断板卡是否使用PLX9054桥芯片。
 *	@param [in]		card_find		板卡识别号；
 *  @return 	true/false
 *  @note    	<b>PLX9054专用函数</b>
 *	@warning  	使用者负责板卡识别号的有效性。
 *  @see    	N/A
 */
extern	"C"	CVPXILIB_API	bool	__stdcall	IsPlx9054(unsigned	int	card_find);


/// 获取板卡识别码
/** 
 *	根据板卡识别号生成对应的板卡识别码。
 *	@param [in]		card_find		板卡识别号；
 *	@param [out]	card_identifier	板卡识别码字符串；
 *	@param [out]	card_ident		板卡识别码整数
 *  @return N/A
 *  @note    	<b>PCI通用函数</b>
 *	@warning  	使用者负责板卡识别号的有效性。
 *  @see    	N/A
 */
extern	"C"	CVPXILIB_API	void	__stdcall	CardInfo(unsigned	int	card_find, char*	card_identifier, card*	card_ident);


/// 获取板卡及逻辑具体设计信息
/** 
 *	根据板卡资源输出板卡的具体设计信息，信息格式以规定为准，32位操作读取。
 *	@param [in]		res		板卡资源结构体；
 *	@param [out]	card_info	板卡设计信息；
 *  @return N/A
 *  @note    	<b>使用PCI桥PLX9054的专用函数</b>
 *	@warning  	使用者负责板卡资源的有效性。
 *  @see    	N/A
 */
extern	"C"	CVPXILIB_API	void	__stdcall	CardInfoEx(card_res*	res, card_detail_info* card_info);


/// 清位(使用32位memory操作)
/** 
 *	对指定地址的指定位清0，这里的地址为0x0, 0x4, 0x8, 0xc结尾。
 *	@param [in]		address		Memory地址；
 *	@param [in]		bit			哪一位（0~31取值）；
 *  @return 1=success, 0=fail。
 *  @note    	要使用32位的memory地址，如以0x0, 0x4, 0x8, 0xc结尾的地址。\n <b>PCI通用函数</b>
 *	@warning  	使用者负责物理内存地址的有效性。
 *  @see    	bit_set() \n read_bit()
 */
extern	"C"	CVPXILIB_API	int	__stdcall	bit_clear(unsigned	int	address, char	bit);


/// 置位(使用32位memory操作)
/** 
 *	对指定地址的指定位置1，这里的地址为0x0, 0x4, 0x8, 0xc结尾。
 *	@param [in]		address		Memory地址；
 *	@param [in]		bit			哪一位（0~31取值）；
 *  @return 1=success, 0=fail。
 *  @note    	要使用32位的memory地址，如以0x0, 0x4, 0x8, 0xc结尾的地址。\n <b>PCI通用函数</b>
 *	@warning  	使用者负责物理内存地址的有效性。
 *  @see    	bit_clear() \n read_bit()
 */
extern	"C"	CVPXILIB_API	int	__stdcall	bit_set(unsigned	int	address, char	bit);


///读取物理内存某地址中某一位的值
/** 
 *	读取指定地址的指定位的布尔值，这里的地址为0x0, 0x4, 0x8, 0xc结尾。
 *	@param [in]		address		Memory地址；
 *	@param [in]		bit			哪一位（0~31取值）；
 *  @return 读出的布尔值
 *  @note    	要使用32位的memory地址，如以0x0, 0x4, 0x8, 0xc结尾的地址。\n <b>PCI通用函数</b>
 *	@warning  	使用者负责物理内存地址的有效性。
 *  @see    	bit_clear() \n bit_set()
 */
extern	"C"	CVPXILIB_API	bool	__stdcall	read_bit(unsigned	int	address, char	bit);


///判断eeprom是否存在
/**判断eeprom是否存在
 *	@param [in]		card_find		板卡标识号；
 *  @return true/false 对应 存在/不存在
 *  @note    	<b>PLX9054专用函数</b>
 *	@warning  	N/A
 *  @see    	WriteEeprom() \n ReadEeprom() \n IsEepromBlank() \n LoadDefaultEeprom() \n EraseEeprom()
 */
extern	"C"	CVPXILIB_API	bool	__stdcall	IsEepromPresent(unsigned	int	card_find);


/// 读取指定偏移量的EEPROM的值
/**地址偏移范围：0~1ff(最大4kbit, 93LC66B)<b>(32bit操作)</b>
 *	@param [in]		card_find		板卡标识号；
 *	@param [in]		offset	偏移值；
 *  @return 所读出的32位整数值
 *  @note    	<b>PLX9054专用函数</b>
 *	@warning  	请使用32bit地址操作，如以0x0, 0x4, 0x8, 0xC收尾的数
 *  @see    	WriteEeprom()
 */
extern	"C"	CVPXILIB_API	unsigned	int	__stdcall	ReadEeprom(unsigned	int 	card_find, short	offset);


/// 在指定的EEPROM偏移量写入新值
/**地址偏移范围：0~1ff(最大4kbit, 93LC66B)<b>(32bit操作)</b>
 *	@param [in]		card_find		板卡标识号；
 *	@param [in]		offset	寄存器偏移值；
 *	@param [in]		data	数据值
 *  @return N/A
 *  @note    	<b>PLX9054专用函数</b>
 *	@warning  	使用不当会引起板卡工作异常 \n 请使用32bit地址操作，如以0x0, 0x4, 0x8, 0xC收尾的数
 *  @see    	ReadEeprom()
 */
extern	"C"	CVPXILIB_API	void	__stdcall	WriteEeprom(unsigned	int	card_find, short	offset, unsigned	int	data);


/// MSO7034B以及xilinx chipscope的控制
/** 
 *	调试用的控制示波器以及chipsope的函数（32位操作）
 *	@param [in]		res		资源结构体；
 *	@param [in]		param	控制值。
 *  @return N/A
 *  @note    	<b>cv专用函数</b>
 *	@warning  	N/A
 *  @see    	N/A
 */
extern	"C"	CVPXILIB_API	void	__stdcall	DebugControl(card_res* res, debug*	param);


/// 读取指定偏移量的PCI configuration register值
/**地址偏移范围：0~ff，32位操作
 *	@param [in]		card_find		板卡标识号；
 *	@param [in]		offset	寄存器偏移值；
 *  @return 所读出的32位整数值
 *  @note    	<b>PCI通用函数</b>
 *	@warning  	请使用32bit地址操作，如以0x0, 0x4, 0x8, 0xC收尾的数
 *  @see    	PCR_Write()
 */
extern	"C"	CVPXILIB_API	long	__stdcall	PCR_Read(unsigned	int	card_find, char offset);


/// 在指定偏移量写入PCI configuration register的值
/**地址偏移范围：0~ff，32位操作
 *	@param [in]		card_find		板卡标识号；
 *	@param [in]		offset	寄存器偏移值；
 *	@param [in]		data	数据值
 *  @return N/A
 *  @note    	<b>PCI通用函数</b>
 *	@warning  	使用不当会直接死机！\n 请使用32bit地址操作，如以0x0, 0x4, 0x8, 0xC收尾的数
 *  @see    	PCR_Read()
 */
extern	"C"	CVPXILIB_API	void	__stdcall	PCR_Write(unsigned	int	card_find, char offset, long	data);

/// 判断plxapi.dll的版本是否为v6.31
/**cvPXILib.dll使用v6.31的plxapi，这个函数还有修改增加功能的空间
 *  @return result	true表plxapi为v6.31，false表plxapi版本为非v6.31
 *  @note    	<b>PCI通用函数</b>
 *  @see    	cvirte_status()	\n	windriver_status()
 */
extern	"C"	CVPXILIB_API	bool	__stdcall	plxapi_status(void);
















/// 申请连续的物理内存
/***/
extern	"C"	CVPXILIB_API	void	__stdcall	PhyMemAlloc(void);


/// 释放连续的物理内存
/***/
extern	"C"	CVPXILIB_API	void	__stdcall	PhyMemFree(void);


/// windriver的库函数是否正常，并注册它
/***/
extern	"C"	CVPXILIB_API	bool	__stdcall	windriver_status(void);


///判断eeprom是否为空
/**针对93LC66B型号的EEPROM*/
extern	"C"	CVPXILIB_API	bool	__stdcall	IsEepromBlank(unsigned	int	card_find);


///加载默认的通用EEPROM内容
/**针对93LC66B型号的EEPROM加载完成后重启电脑*/
extern	"C"	CVPXILIB_API	void	__stdcall	LoadDefaultEeprom(unsigned	int	card_find);


///擦除eeprom内容
/**针对93LC66B型号的EEPROM*/
extern	"C"	CVPXILIB_API	void	__stdcall	EraseEeprom(unsigned	int	card_find);


extern	"C"	CVPXILIB_API	U8	__stdcall	visa_find_rsrc(char	*	find_items);


extern	"C"	CVPXILIB_API	U8	__stdcall SetBuffer1(char * IntoDLL);
extern	"C"	CVPXILIB_API	U8	__stdcall GetBuffer1(char * FromDLL);
extern	"C"	CVPXILIB_API	U8	__stdcall SetBuffer2(char * IntoDLL);
extern	"C"	CVPXILIB_API	U8	__stdcall GetBuffer2(char * FromDLL);
extern	"C"	CVPXILIB_API	U8	__stdcall SetBuffer3(char * IntoDLL);
extern	"C"	CVPXILIB_API	U8	__stdcall GetBuffer3(char * FromDLL);














