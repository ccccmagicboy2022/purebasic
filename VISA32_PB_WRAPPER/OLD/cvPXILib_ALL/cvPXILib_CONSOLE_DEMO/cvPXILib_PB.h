 //////////////////////////////////////////////////////////////////////////
 ///     Copyright (c) 2011，北京康拓科技有限公司，All rights reserved。
 ///
 /// @file			cvPXILib_PB.h
 /// @brief			cvPXILib_PB.dll函数导出头文件
 ///
 /// 	本dll实现一些菜单功能的函数
 ///
 /// @version 	1.0.0.1	(当前)
 /// @author    系统二部	崔巍
 /// @date      2011.09.21
 ///
 ///	v1.0.0.1\n
 ///    修订说明：最初版本
 //////////////////////////////////////////////////////////////////////////
 
 
 
 /// 选择板卡
/**请在弹出的对话框中选择要操作的板卡
 *  @return 选择的板卡标识号
 *  @note    	<b>PCI通用函数</b>
 *	@warning  	N/A
 *  @see    	N/A
 */
 extern	"C"	CVPXILIB_API	long	__stdcall	select_card_pb(void);
 
 