
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
//#pragma comment(linker, "/ignore:4089") 
#pragma comment(linker, "/opt:noref")
#pragma	comment(lib, ".\\VISA32_PB_WRAPPER.lib")	//visa32_cv_wrapper
//-----------------------------------------------------------------------
#include	"visa/visa.h"										//visa32 header file
#include	"VISA32_PB_WRAPPER/visa32_base.h"
#include	"VISA32_PB_WRAPPER/card_info.h"
#include	"VISA32_PB_WRAPPER/visa32_device.h"
#include	"VISA32_PB_WRAPPER/VISA32_CALLBACK.h"				//VISA32_CALLBACK回调函数的头文
#include	"VISA32_PB_WRAPPER/VISA32_PB_WRAPPER_DLL.h"			//VISA32_PB_WRAPPER DLL header file
#include	"VISA32_PB_WRAPPER/VISA32_PB_WRAPPER_KIT.h"			//VISA32_PB_WRAPPER KIT header file

typedef HWND (WINAPI *PROCGETCONSOLEWINDOW)();

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
	PROCGETCONSOLEWINDOW GetConsoleWindow;
	HMODULE hKernel32 = ::GetModuleHandle("kernel32");
	GetConsoleWindow = (PROCGETCONSOLEWINDOW)GetProcAddress(hKernel32,"GetConsoleWindow");
	HWND cmd=GetConsoleWindow();
	::SetWindowPos(cmd, HWND_TOPMOST, 0, 0, 0, 0, SWP_NOMOVE|SWP_NOSIZE);

	::system("title visa_pxi_tree v1.0");
	::system("mode con: cols=40 lines=10");
	::ShowWindow(cmd, SW_HIDE);
	VISA32_PB_WRAPPER_DLL::visa_pxi_tree();
}

app_frame	app;

int main(int argc, char* argv[])
{
	return 0;
}
















