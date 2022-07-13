// CVPXIRUNTIMESN.cpp : Defines the entry point for the DLL application.
//
#include <string>
#include "stdafx.h"
#include "CVPXIRUNTIMESN.h"
#include "import.h"
#include <iostream>


#pragma comment(lib, "CPUID_Util.lib")//cpuid
#pragma	comment(lib, "GetDiskSerial.lib")//”≤≈Ãid
#pragma	comment(lib, "md5_cv.lib")//md5_cv

BOOL APIENTRY DllMain( HANDLE hModule, 
                       DWORD  ul_reason_for_call, 
                       LPVOID lpReserved
					 )
{
    switch (ul_reason_for_call)
	{
		case DLL_PROCESS_ATTACH:
		case DLL_THREAD_ATTACH:
		case DLL_THREAD_DETACH:
		case DLL_PROCESS_DETACH:
			break;
    }
    return TRUE;
}

int __stdcall	GetSN(char*	user_name, char*	sn)
{
	char*	SerialNumber;
	char*	cpuid;
	char*	md5;
	int	i	=	0;

	SerialNumber	=	(char *)malloc(sizeof(char) * 1000);
	cpuid	=	(char *)malloc(sizeof(char) * 1000);
	md5	=	(char *)malloc(sizeof(char) * 1000);
	
	SerialNumber	=	GetSerialNumber(0);//”≤≈Ãsn
	GetCPUID(cpuid);			//cpuid
	
	strcpy(sn, user_name);
	strcat(sn, SerialNumber);
	strcat(sn, cpuid);
	sn	=	strrev(sn);//∑¥œÚ
	sn	=	strupr(sn);//¥Û–¥	
	md5_cv(sn, md5);
	strcpy(sn, md5);
	
	free(SerialNumber);
	free(cpuid);
	free(md5);
	
	return	12;
}

