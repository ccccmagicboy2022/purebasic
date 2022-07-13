// cvPXILib.cpp : Defines the entry point for the DLL application.
//
#include	"stdafx.h"
//----------------------------------------------------------------
#pragma comment(lib, ".\\base_dll\\cviVXDWrapper\\cviVXDWrapper.lib")//cvi
#pragma comment(lib, ".\\base_dll\\PlxApi631\\PlxApi631.lib")//plx
#pragma comment(lib, ".\\base_dll\\wdapi1020\\wdapi1020.lib")//windriver
#pragma comment(lib, ".\\base_dll\\visa32\\visa32.lib")//ni-visa
#pragma comment(lib, ".\\base_dll\\pivxi11\\pivxi11.lib")//vxi11
#pragma	comment(lib, ".\\base_dll\\SkinH\\SkinH.lib")//skinsharp
// #pragma comment(lib, ".\\base_dll\\BoxedAppSDK\\BoxedAppSDK.lib")//boxed_app_sdk
#pragma	comment(lib, "winmm.lib")//多媒体定时器库
#pragma	comment(lib, "KERNEL32.lib")
// #pragma comment(lib,".\\base_dll\\labview.lib")
// #pragma comment(lib,".\\base_dll\\labviewv.lib")
//----------------------------------------------------------------
// #include	"include/BoxedAppSDK.h"
#include	"resource.h"
#include	"import.h"
#include	"Include/Plx.h"
#include	"Include/PlxApi.h"
#include	"Include/PlxInit.h"
#include	"Include/PciRegs.h"
// #include	"Include/extcode.h"		//<labview的头文件
// #include	"Include/hosttype.h"	//<labview的头文件
// #include	"Include/fundtypes.h"	//<labview的头文件
#include	"cvPXILib.h"
#include	<string>
#include	"Include/visa.h"
#include	<stdio.h>
#include	"Include/pivxi11.h"
//----------------------------------------------------------------
#define setbit(x,y) x|=(1<<y) 	//将X的第Y位置1
#define clrbit(x,y) x&=~(1<<y)	//将X的第Y位清0
#define getbit(x,y) x&(1<<y)	//将x的第Y位读出

#define CONFIG_ADDRESS 0xCF8
#define CONFIG_DATA 0xCFC

typedef void (WINAPI *P_Function)(char*, char*);

#pragma data_seg(".Shared")	//建立数据共享段
char theBuffer1[1024]	= "";
char theBuffer2[2048]	= "";
char theBuffer3[4096]	= "";
#pragma data_seg()
//----------------------------------------------------------------
BOOL APIENTRY DllMain( HANDLE hModule,
                       DWORD  ul_reason_for_call,
                       LPVOID lpReserved
                     )
{
    switch (ul_reason_for_call) {
    case DLL_PROCESS_ATTACH:				//这里需要增加一些内容
        cvirte_status();
        plxapi_status();
        windriver_status();
        //这里使能注册检测机制什么的check reg
    case DLL_THREAD_ATTACH:					//这里需要增加一些内容
    case DLL_THREAD_DETACH:
    case DLL_PROCESS_DETACH:
        break;
    }
    return TRUE;
}

//--------------------------------------------------


int	__stdcall	MapPhysicalMemory_wrapper(unsigned int	p_address, unsigned int	size, void*	v_address, int*	map_handle)
{
    return	MapPhysicalMemory(p_address, size, v_address, map_handle);
}


int	__stdcall	UnMapPhysicalMemory_wrapper(int	map_handle)
{
    return	UnMapPhysicalMemory(map_handle);
}


bool	__stdcall	find_resource(unsigned	int	card_find, card_res*	res)
{
    PLX_STATUS	rc;
    PLX_DEVICE_KEY	DeviceKey;
    PLX_DEVICE_OBJECT	Device;
    PLX_PHYSICAL_MEM	BufferInfo;
    bool	result;

    res->bar0	=	PCR_Read(card_find, CFG_BAR0);	//>读bar0首地址
    res->bar2	=	PCR_Read(card_find, CFG_BAR2);	//>读bar2首地址
    res->bar3	=	PCR_Read(card_find, CFG_BAR3);	//>读bar3首地址

    memset(&DeviceKey, PCI_FIELD_IGNORE, sizeof(PLX_DEVICE_KEY));

    rc =
        PlxPci_DeviceOpen(
            &DeviceKey,
            &Device
        );

    rc =
        PlxPci_CommonBufferProperties(
            &Device,
            &BufferInfo
        );

    rc	=	PlxPci_DeviceClose(&Device);

    res->dma_buffer	=	(unsigned int)BufferInfo.PhysicalAddr;
    res->dma_buffer_size	=	BufferInfo.Size;

    if	(res->dma_buffer_size<0x400000) {	//buffer大小小于4MByte
        MessageBox( NULL, TEXT("dma_buffer_size is less than 4MByte!\nplease check it!"), TEXT("cvPXILib"), MB_ICONEXCLAMATION);
        result	=	false;
    } else {
        result	=	true;
    }
	
    return result;
}


void	__stdcall	HelloWorldDLL()
{
    MessageBox( NULL, TEXT("Hello World!"),
                TEXT("In cvPXILib.DLL"), MB_OK);//>测试dll用的
	OutputDebugString("崔巍2011制作！\n");
	
}


bool	__stdcall	cvirte_status()
{
    bool	result;

    if	(CVILowLevelSupportDriverLoaded()) {
        result	=	true;
    } else {
        MessageBox( NULL, TEXT("cvi run-time error!\nplease reload it!"), TEXT("cvPXILib"), MB_ICONEXCLAMATION);
        result	=	false;
    }

    return	result;
}


int	__stdcall	bit_clear(unsigned	int	address, char	bit)
{
    unsigned	int	data;

    if	(bit	>	31) {
        MessageBox( NULL, TEXT("bit must at range 0~31. "), TEXT("cvPXILib"), MB_ICONEXCLAMATION);
        return	0;
    } else {
        data	=	ReadPhyMem32(address);
        clrbit(data, bit);
        WritePhyMem32(address, data);
        return	1;
    }
}


int	__stdcall	bit_set(unsigned	int	address, char	bit)
{
    unsigned	int	data;

    if	(bit	>	31) {
        MessageBox( NULL, TEXT("bit must at range 0~31. "), TEXT("cvPXILib"), MB_ICONEXCLAMATION);
        return	0;
    } else {
        data	=	ReadPhyMem32(address);
        setbit(data, bit);
        WritePhyMem32(address, data);
        return	1;
    }
}


void	__stdcall	CardInfo(unsigned	int	card_find, char*	card_identifier, card*	card_ident)
{
    /* bit 31=1        (bit is always set for a PCI access)
    bits30:24=0 (reserved)
    bit 23:16=bus number (0-255)
    bits15:11=device # (0-31)
    bits10:8=function # (0-7)
    bits7:0=register number (0-255) */

    unsigned	int	bus;
    unsigned	int	device;
    unsigned	int	function;
    char*	temp;

    temp	=	(char *)malloc(sizeof(char) * 100);

    bus	=	(card_find&0x00ff0000)/0x10000;
    device	=	(card_find&0x0000f800)/0x800;
    function	=	(card_find&0x700)/0x100;

    strcpy(card_identifier, "bus:");
    itoa(bus, temp,   10);
    strcat(temp, " dev:");
    strcat(card_identifier, temp);
    itoa(device, temp,   10);
    strcat(temp, " fun:");
    strcat(card_identifier, temp);
    itoa(function, temp,   10);
    strcat(card_identifier, temp);
    free(temp);

    card_ident->bus	=	bus;
    card_ident->device	=	device;
    card_ident->function	=	function;
}


long	__stdcall	ReadPhyMem32(long	address)
{
    long	data;
    ReadFromPhysicalMemoryEx(address, &data, 4, 4);
    return	data;
}


short	__stdcall	ReadPhyMem16(long	address)
{
    short	data;
    ReadFromPhysicalMemoryEx(address, &data, 2, 2);
    return	data;
}


char	__stdcall	ReadPhyMem8(long	address)
{
    char	data;
    ReadFromPhysicalMemoryEx(address, &data, 1, 1);
    return	data;
}


void	__stdcall	WritePhyMem32(long	address, long	data)
{
    WriteToPhysicalMemoryEx(address, &data, 4, 4);
}


void	__stdcall	WritePhyMem16(long	address, short	data)
{
    WriteToPhysicalMemoryEx(address, &data, 2, 2);
}


void	__stdcall	WritePhyMem8(long	address, char	data)
{
    WriteToPhysicalMemoryEx(address, &data, 1, 1);
}


void	__stdcall	CardInfoEx(card_res*	res, card_detail_info* card_info)
{
    card_info->project		=	(unsigned	int)ReadPhyMem32(res->bar2	+	0x4);
    card_info->card			=	(unsigned	int)ReadPhyMem32(res->bar2	+	0x8);
    card_info->varient		=	(unsigned	int)ReadPhyMem32(res->bar2	+	0xC);
    card_info->chasis_slot	=	(unsigned	int)ReadPhyMem32(res->bar2	+	0x10);
    card_info->designer		=	(unsigned	int)ReadPhyMem32(res->bar2	+	0x14);
    card_info->fpga_version	=	(unsigned	int)ReadPhyMem32(res->bar2	+	0x18);
    card_info->chasis_type	=	(unsigned	int)ReadPhyMem32(res->bar2	+	0x1C);
    card_info->bus_type		=	(unsigned	int)ReadPhyMem32(res->bar2	+	0xC0);
}


char	__stdcall	CVI_inp_wrapper(int	address)
{
    return	CVI_inp(address);
}


short	__stdcall	CVI_inpw_wrapper(int	address)
{
    return	CVI_inpw(address);
}


long	__stdcall	CVI_inpd_wrapper(short	address)
{
    return	CVI_inpd(address);
}


char	__stdcall	CVI_outp_wrapper(int	address, char	data)
{
    return	CVI_outp(address, data);
}


short	__stdcall	CVI_outpw_wrapper(short	address, short	data)
{
    return	CVI_outpw(address, data);
}


long	__stdcall	CVI_outpd_wrapper(short	address, long	data)
{
    return	CVI_outpd(address, data);
}


void	__stdcall	DebugControl(card_res* res, debug*	param)
{
    WritePhyMem32(res->bar3	+	0x7C, param->mso7034b);///fifo1_31用于调试
    WritePhyMem32(res->bar3	+	0x7C, param->chipscope_signal_select);
    WritePhyMem32(res->bar3	+	0x7C, param->chipscope_clk_select);
}


long	__stdcall	PCR_Read(unsigned	int	card_find, char offset)
{
    CVI_outpd(CONFIG_ADDRESS, (card_find	+	offset));
    return	CVI_inpd(CONFIG_DATA);
}


void	__stdcall	PCR_Write(unsigned	int	card_find, char offset, long	data)
{
    PLX_STATUS rc;
    card*	card_inden;
    char*	temp;

    card_inden	=	(card*)malloc(sizeof(card));
    temp	=	(char *)malloc(sizeof(char) * 100);

    CardInfo(card_find, temp, card_inden);

    rc	=PlxPci_PciRegisterWrite_BypassOS(
            (char)card_inden->bus,
            (char)card_inden->device,
            (char)card_inden->function,
            (short)offset,
            data
        );
    free(card_inden);
    free(temp);
}


unsigned	int	__stdcall	ReadEeprom(unsigned	int 	card_find, short	offset)
{
    PCR_Write(card_find, 0x4C, offset<<16);
    while (1) {
        if	((PCR_Read(card_find, 0x4C)&0x80000000)	==	0x80000000)
            break;
    }
    return	PCR_Read(card_find, 0x50);
}


void	__stdcall	WriteEeprom(unsigned	int	card_find, short	offset, unsigned	int	data)
{
    long	protect;

    protect	=	PCR_Read(card_find, CFG_BAR0)	+	0x0E;

    WritePhyMem8(protect, 0x0);//取消eeprom写保护
    Sleep(5);

    PCR_Write(card_find, 0x50, data);//载入要写入的数据
    PCR_Write(card_find, 0x4C, (0x80000000	+	(offset<<16)));

    // while(1)
    // {
    // if	((PCR_Read(card_find, 0x4C)&0x80000000)	==	0x0)
    // break;
    // }

    Sleep(5);
    WritePhyMem8(protect, 0x30);//eeprom写保护，恢复默认的保护
}


void	__stdcall	ResetCard(unsigned	int	card_find)
{
    unsigned	int	bar0;
    char*	card_identifier;
    card*	card_ident;

    card_ident	=	(card*)malloc(sizeof(card));
    card_identifier	=	(char *)malloc(sizeof(char) * 100);

    CardInfo(card_find, card_identifier, card_ident);

    bar0	=	PCR_Read(card_find, CFG_BAR0);
    bit_set(bar0	+	0x6C, 30);
    Sleep(10);
    bit_clear(bar0	+	0x6C, 30);
    Sleep(10);
    bit_set(bar0	+	0x6C, 29);
    Sleep(10);
    bit_clear(bar0	+	0x6C, 29);
    Sleep(10);
    strcat(card_identifier, "\nCARD RESET OK!");
    MessageBox( NULL, TEXT(card_identifier), TEXT("cvPXILib"), MB_ICONINFORMATION);
    free(card_ident);
    free(card_identifier);
}


bool	__stdcall	IsPlx9054(unsigned	int	card_find)
{
    unsigned	int	bar0;
    bool	result;

    bar0	=	PCR_Read(card_find, CFG_BAR0);

    if	(ReadPhyMem32(bar0	+	0x70)	==	0x905410B5) {
        MessageBox( NULL, TEXT("经查，确实使用了PLX9054桥芯片！"), TEXT("cvPXILib"), MB_ICONINFORMATION);
        result	=	true;
    } else {
        MessageBox( NULL, TEXT("没有使用PLX9054芯片！\n或者由于FPGA导致读取PLX9054寄存器出错！"), TEXT("cvPXILib"), MB_ICONEXCLAMATION);
        result	=	false;
    }

    return	result;
}


bool	__stdcall	IsEepromPresent(unsigned	int	card_find)
{
    unsigned	int	bar0;

    bar0	=	PCR_Read(card_find, CFG_BAR0);

    return	read_bit(bar0	+	0x6C, 28);
}


bool	__stdcall	read_bit(unsigned	int	address, char	bit)
{
    long	data;
    bool	result;
    data	=	ReadPhyMem32(address);
    
    if	(getbit(data, bit))
        result	=	true;
    else
        result	=	false;
    return	result;
}

bool	__stdcall	plxapi_status()
{
    U8	VerMajor;
    U8	VerMinor;
    U8	VerRev;
    bool	result;

    PlxPci_ApiVersion(
        &VerMajor,
        &VerMinor,
        &VerRev
    );

    if	((VerMajor	==	6)&&(VerMinor	==	3)&&(VerRev	==	1)) {
        result	=	true;
    } else {
        MessageBox( NULL, TEXT("plxapi version error!\n please check it!"), TEXT("cvPXILib.dll"), MB_ICONINFORMATION);
        result	=	false;
    }

    return	result;
}











bool	__stdcall	windriver_status()
{
    return	true;
}


void	__stdcall	PhyMemAlloc()
{

}


void	__stdcall	PhyMemFree()
{

}


bool	__stdcall	IsEepromBlank(unsigned	int	card_find)
{
    return	true;
}


void	__stdcall	LoadDefaultEeprom(unsigned	int	card_find)
{

}


void	__stdcall	EraseEeprom(unsigned	int	card_find)
{

}


extern	"C"	CVPXILIB_API	U8	__stdcall	visa_find_rsrc(char	*	find_items)
{
	char instrDescriptor[VI_FIND_BUFLEN];
	ViUInt32 numInstrs;
	ViFindList findList;
	ViSession defaultRM;
	ViStatus status;
	char	vxi11_temp[100]	=	"";
	char	vxi11_temp2[100]	=	"";
	U32	visa_count;
	
	DiscoveryParams params;
	DiscoveryResponse response[10];
	long count, found;
	
	status = viOpenDefaultRM (&defaultRM);
	if (status < VI_SUCCESS)
	{
        MessageBox( NULL, TEXT("Could not open a session to the VISA Resource Manager!"), TEXT("cvPXILib.dll"), MB_ICONINFORMATION);
	}
	status = viFindRsrc (defaultRM, "?*INSTR", &findList, &numInstrs, instrDescriptor);
	if (status < VI_SUCCESS)
	{
        MessageBox( NULL, TEXT("An error occurred while finding resources."), TEXT("cvPXILib.dll"), MB_ICONINFORMATION);
		viClose (defaultRM);
	}
	else
	{		
		strcpy(find_items, instrDescriptor);

		visa_count	=	numInstrs;
		while (--numInstrs)
		{
			/* stay in this loop until we find all instruments */
			status = viFindNext (findList, instrDescriptor);  /* find next desriptor */
			if (status < VI_SUCCESS) 
			{   /* did we find the next resource? */
				MessageBox( NULL, TEXT("An error occurred while finding resources."), TEXT("cvPXILib.dll"), MB_ICONINFORMATION);
				viClose (defaultRM);
				break;
			}
		strcat(find_items, " ");
		strcat(find_items, instrDescriptor);
		}
		strcat(find_items, " ");
		
		status = viClose(findList);	
	}

	status = viClose (defaultRM);
	
	//setting parameters for discovery functions
	//see more info at definition of DiscoveryParams structure
	params.LockDevice = false;
	params.LockTimeout = 1000;
	params.CommunicationTimeout = 2000;
	params.RetryTimeout = 2000;
	
	pivxi11_DiscoveryNetwork(NULL,params, &count);
	if(count>0) {
		for(int i=0; i<count; i++) {
			//DiscoveryGetData function provides means of accessing information 
			//index is zero based index of instrument found on network
			itoa (i,vxi11_temp2,10);
			pivxi11_DiscoveryGetData(i, response, 10, &found);
			strcpy(vxi11_temp, "TCPIP");
			strcat(vxi11_temp, vxi11_temp2);
			strcat(vxi11_temp, "::");
			strcat(vxi11_temp, response[i].Hostname);
			strcat(vxi11_temp, "::");
			strcat(vxi11_temp, response[i].InstrumentId);
			strcat(vxi11_temp, "::INSTR ");
			strcat(find_items, vxi11_temp);
		}
	}
	return	visa_count	+	count;	
}


extern	"C"	CVPXILIB_API	U8	__stdcall SetBuffer1(char * IntoDLL)//1024字节大小
{
	memcpy(theBuffer1, IntoDLL, 1024);
	return 1;
}


extern	"C"	CVPXILIB_API	U8	__stdcall GetBuffer1(char * FromDLL)//1024字节大小
{
	memcpy(FromDLL, theBuffer1, 1024);
	return 1;
}


extern	"C"	CVPXILIB_API	U8	__stdcall SetBuffer2(char * IntoDLL)//2048字节大小
{
	memcpy(theBuffer2, IntoDLL, 2048);
	return 0;
}


extern	"C"	CVPXILIB_API	U8	__stdcall GetBuffer2(char * FromDLL)//2048字节大小
{
	memcpy(FromDLL, theBuffer2, 2048);
	return 0;
}


extern	"C"	CVPXILIB_API	U8	__stdcall SetBuffer3(char * IntoDLL)//4096字节大小
{
	memcpy(theBuffer3, IntoDLL, 4096);
	return 0;
}


extern	"C"	CVPXILIB_API	U8	__stdcall GetBuffer3(char * FromDLL)//4096字节大小
{
	memcpy(FromDLL, theBuffer3, 4096);
	return 0;
}

