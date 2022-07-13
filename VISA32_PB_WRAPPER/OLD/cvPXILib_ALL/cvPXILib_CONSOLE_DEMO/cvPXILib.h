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


///错误结构体
/**	函数运行错误的结构体，源自labview的错误簇（但不包含labview错误簇的错误源字符串）	*/
typedef	struct
{
	bool	status;	///<错误状态，1为错误，0为正常
	int	code;		///<错误编号
}lv_error;


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
}card_detail_info;


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
extern	"C"	CVPXILIB_API	int	MapPhysicalMemory_wrapper(unsigned int	p_address, unsigned int	size, void*	v_address, int*	map_handle);


/// 释放映射的物理内存的虚空间
/** 
 *	与MapPhysicalMemory_wrapper对应使用，用于释放空间。
 *	@param [in]	map_handle	映射handle，用于释放。
 *  @return 返回值说明\n
		1----成功\n
		0----失败
 */
extern	"C"	CVPXILIB_API	int	UnMapPhysicalMemory_wrapper(int	map_handle);


/// 寻找板卡资源
/** 
 *	通过板卡识别号获取板卡可支配的物理内存资源，当本函数运行前出现错误，本函数只传递错误。
 *	@param [in]		card_find	板卡识别号；
 *	@param [out]	res			板卡资源结构；
 *	@param [in]		error		错误结构入；
 *  @param [out]	error		错误结构出；
 *  @return 错误源描述，当无错误时返回NULL。
 */
extern	"C"	CVPXILIB_API	char*	find_resource(unsigned	int	card_find, card_res*	res, lv_error*	error);


/// helloworld
/**用于测试本DLL的存在，弹出一个消息窗口*/
extern	"C"	CVPXILIB_API	void	__stdcall	HelloWorldDLL();


/// CVIRTE库状态测试
/** 
 *	测试CVIRTE库是否正常安装及注册，不正常时会有消息窗口弹出提示并输出错误信息。当本函数运行前出现错误，本函数只传递错误。
 *	@param [in]		error		错误结构入；
 *  @param [out]	error		错误结构出；
 *  @return 错误源描述，当无错误时返回NULL。
 *  @note    	使用cvPXILib前请确保安装cvPXIRunTime。\n <b>PCI通用函数</b>
 *	@warning  	N/A
 *  @see    	plxapi_status()\n windriver_status()
 */
extern	"C"	CVPXILIB_API	char*	cvirte_status(lv_error*	error);


/// 8位IO读
/** 
 *	8位IO读取端口地址中的数据。
 *	@param [in]		address		IO地址；
 *  @return 所读取的数据为8位整数。
 */
extern	"C"	CVPXILIB_API	char	CVI_inp_wrapper(int	address);


/// 16位IO读
/** 
 *	16位IO读取端口地址中的数据。
 *	@param [in]		address		IO地址；
 *  @return 所读取的数据为16位整数。
 */
extern	"C"	CVPXILIB_API	short	CVI_inpw_wrapper(int	address);


/// 32位IO读
/** 
 *	32位IO读取端口地址中的数据。
 *	@param [in]		address		IO地址；
 *  @return 所读取的数据为32位整数。
 */
extern	"C"	CVPXILIB_API	long	CVI_inpd_wrapper(short	address);


/// 8位IO写
/** 
 *	用8位IO数据写端口地址。
 *	@param [in]		address		IO地址；
 *	@param [in]		data		8位整数数据
 *  @return 所写的数据（8位整数）。
 */
extern	"C"	CVPXILIB_API	char	CVI_outp_wrapper(int	address, char	data);


/// 16位IO写
/** 
 *	用16位IO数据写端口地址。
 *	@param [in]		address		IO地址；
 *	@param [in]		data		16位整数数据
 *  @return 所写的数据（16位整数）。
 */
extern	"C"	CVPXILIB_API	short	CVI_outpw_wrapper(short	address, short	data);


/// 32位IO写
/** 
 *	用32位IO数据写端口地址。
 *	@param [in]		address		IO地址；
 *	@param [in]		data		32位整数数据
 *  @return 所写的数据（32位整数）。
 */
extern	"C"	CVPXILIB_API	long	CVI_outpd_wrapper(short	address, long	data);


/// 8位Memory读
/** 
 *	使用8位Memory读的方式获取物理内存中的数据。
 *	@param [in]		address		Memory地址；
 *  @return 所读出的数据（8位整数）。
 */
extern	"C"	CVPXILIB_API	char	ReadPhyMem8(long	address);


/// 16位Memory读
/** 
 *	使用16位Memory读的方式获取物理内存中的数据。
 *	@param [in]		address		Memory地址；
 *  @return 所读出的数据（16位整数）。
 */
extern	"C"	CVPXILIB_API	short	ReadPhyMem16(long	address);


/// 32位Memory读
/** 
 *	使用32位Memory读的方式获取物理内存中的数据。
 *	@param [in]		address		Memory地址；
 *  @return 所读出的数据（32位整数）。
 *  @note    	要使用32位的memory地址，如以0x0, 0x4, 0x8, 0xc结尾的地址。\n <b>PCI通用函数</b>
 *	@warning  	使用者负责物理内存地址的有效性。
 *  @see    	ReadPhyMem8()\n ReadPhyMem16()
 */
extern	"C"	CVPXILIB_API	long	ReadPhyMem32(long	address);


/// 8位Memory写
/** 
 *	使用8位Memory写的方式将数据写入指定的物理内存地址中。
 *	@param [in]		address		Memory地址；
 *	@param [in]		data		8位整数；
 *  @return 无
 */
extern	"C"	CVPXILIB_API	void	WritePhyMem8(long	address, char	data);


/// 16位Memory写
/** 
 *	使用16位Memory写的方式将数据写入指定的物理内存地址中。
 *	@param [in]		address		Memory地址；
 *	@param [in]		data		16位整数；
 *  @return 无
 */
extern	"C"	CVPXILIB_API	void	WritePhyMem16(long	address, short	data);


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
extern	"C"	CVPXILIB_API	void	WritePhyMem32(long	address, long	data);


extern	"C"	CVPXILIB_API	char*	plxapi_status(lv_error*	error);
extern	"C"	CVPXILIB_API	char*	windriver_status(lv_error*	error);
extern	"C"	CVPXILIB_API	void	ResetCard(card_res	res);
extern	"C"	CVPXILIB_API	char*	IsPlx9054(card_res	res, lv_error*	error);


/// 获取板卡识别码
/** 
 *	根据板卡识别号生成对应的板卡识别码。
 *	@param [in]		card_find		板卡识别号；
 *	@param [out]	card_identifier	板卡识别码；
 *  @return N/A
 *  @note    	<b>PCI通用函数</b>
 *	@warning  	使用者负责板卡识别号的有效性。
 *  @see    	N/A
 */
extern	"C"	CVPXILIB_API	void	CardInfo(unsigned	int	card_find, char*	card_identifier);


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
extern	"C"	CVPXILIB_API	void	CardInfoEx(card_res*	res, card_detail_info* card_info);


/// 清位(使用32位memory操作)
/** 
 *	对指定地址的指定位清0，这里的地址为0x0, 0x4, 0x8, 0xc结尾。
 *	@param [in]		address		Memory地址；
 *	@param [in]		bit			哪一位（0~31取值）；
 *  @return 1=success, 0=fail。
 *  @note    	要使用32位的memory地址，如以0x0, 0x4, 0x8, 0xc结尾的地址。\n <b>PCI通用函数</b>
 *	@warning  	使用者负责物理内存地址的有效性。
 *  @see    	bit_set()
 */
extern	"C"	CVPXILIB_API	int	bit_clear(unsigned	int	address, unsigned	int	bit);


/// 置位(使用32位memory操作)
/** 
 *	对指定地址的指定位置1，这里的地址为0x0, 0x4, 0x8, 0xc结尾。
 *	@param [in]		address		Memory地址；
 *	@param [in]		bit			哪一位（0~31取值）；
 *  @return 1=success, 0=fail。
 *  @note    	要使用32位的memory地址，如以0x0, 0x4, 0x8, 0xc结尾的地址。\n <b>PCI通用函数</b>
 *	@warning  	使用者负责物理内存地址的有效性。
 *  @see    	bit_clear()
 */
extern	"C"	CVPXILIB_API	int	bit_set(unsigned	int	address, unsigned	int	bit);


extern	"C"	CVPXILIB_API	void	__stdcall	GetBuffer1(char*	aaa);


extern	"C"	CVPXILIB_API	void	__stdcall	check_sn(void);
