// cable_tester_simulator_kt.cpp : Defines the entry point for the console application.
//
#define	setbit(x,y) x|=(1<<y) 	//将X的第Y位置1
#define	clrbit(x,y) x&=~(1<<y)	//将X的第Y位清0
#define	getbit(x,y) x&(1<<y)	//将x的第Y位读出

#include	<string>		//增加对c++中string类的支持
#include	<iostream>		//增加std中I/O流的支持
#include	<sstream>		//增加std中string流的支持
#include	<bitset>		//增加std中bitset类的支持
#include	<Windows.h>		//增加winapi支持
//-----------------------------------------------------------------------
#pragma comment(lib, ".\\visa32.lib")				//visa32
#pragma	comment(lib, ".\\VISA32_PB_WRAPPER.lib")	//visa32_cv_wrapper
#pragma comment(lib, "bufferoverflowU.lib")
//-----------------------------------------------------------------------
#include	"visa/visa.h"										//visa32 header file
#include	"VISA32_PB_WRAPPER/card_info.h"
#include	"VISA32_PB_WRAPPER/visa32_device.h"					//visa32_device class
#include	"VISA32_PB_WRAPPER/VISA32_PB_WRAPPER_DLL.h"			//VISA32_PB_WRAPPER DLL header file
#include	"VISA32_PB_WRAPPER/VISA32_PB_WRAPPER_KIT.h"			//VISA32_PB_WRAPPER KIT header file
#include	"VISA32_PB_WRAPPER/visa32_base.h"					//visa32_base class
#include	"VISA32_PB_WRAPPER/cable_tester_simulator.h"		//cable_tester_simulator class

typedef HWND (WINAPI *PROCGETCONSOLEWINDOW)();
PROCGETCONSOLEWINDOW GetConsoleWindow;

class app_frame
{
public:
	app_frame();
protected:
private:
	visa32_base	visa32;
};
app_frame::app_frame()
{
	cable_tester_simulator	device1;
	bool	result	=	false;
	unsigned	char	res_name[1024]	=	"";

	HMODULE hKernel32 = ::GetModuleHandle("kernel32");
	GetConsoleWindow = (PROCGETCONSOLEWINDOW)GetProcAddress(hKernel32,"GetConsoleWindow");
	HWND cmd=GetConsoleWindow();
	SetWindowPos(cmd, HWND_TOPMOST, 0, 0, 0, 0, SWP_NOMOVE|SWP_NOSIZE);

	::system("title 电缆测试仪模拟器 v1.0");
	::system("mode con: cols=40 lines=10");	
	result	=	device1.select_visa_serialport();
	if(result)
	{
		result	=	device1.init();
		if (result)
		{
			viGetAttribute(device1.get_device_res(), VI_ATTR_INTF_INST_NAME, res_name);
			std::cout<<res_name<<std::endl<<"callback is working..."<<std::endl;
			system("pause");
			device1.release();
		}
	}
}

app_frame	app;

int main(int argc, char* argv[])
{
	return 0;
}
