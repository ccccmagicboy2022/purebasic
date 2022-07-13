
#include "include/BoxedAppSDK.h"
#include <string>
#include <shellapi.h>
#include "resource.h"

#pragma comment(lib,"BoxedAppSDK.lib")//boxed_app_sdk

typedef void (WINAPI *P_Function)(char*, char*);

int main(int argc, char* argv[])
{
	char user_name[200]	=	{0};
	char sn[200]	=	{0};
	char system_name[200]	=	{0};
	HRSRC hResInfo;
	HGLOBAL hResData;
	LPVOID lpData;
	DWORD dwSize;
	HANDLE hFile;
	DWORD temp;
	HMODULE hModule;

	hModule = GetModuleHandle(NULL);

// Create virtual BoxedAppSDK.dll
    // hResInfo = FindResource(hModule, MAKEINTRESOURCE(IDR_BOXEDSDK), TEXT("BIN"));
    // hResData = LoadResource(hModule, hResInfo);
    // lpData = LockResource(hResData);
    // dwSize = SizeofResource(hModule, hResInfo);
	
	// GetSystemDirectory(system_name, 260);
	
	// strcat(system_name, "\\BoxedAppSDK.dll");
	
	// hFile = CreateFile(TEXT(system_name), GENERIC_WRITE, FILE_SHARE_WRITE, NULL, CREATE_ALWAYS, FILE_ATTRIBUTE_NORMAL, NULL);
	// WriteFile(hFile, lpData, dwSize, &temp, NULL);
	// CloseHandle(hFile);

	BoxedAppSDK_Init();

// Create virtual CPUID_Util.dll
    hResInfo = FindResource(hModule, MAKEINTRESOURCE(IDR_CPUID), TEXT("BIN"));
    hResData = LoadResource(hModule, hResInfo);
    lpData = LockResource(hResData);
    dwSize = SizeofResource(hModule, hResInfo);

	hFile = BoxedAppSDK_CreateVirtualFile(TEXT("CPUID_Util.dll"), GENERIC_WRITE, FILE_SHARE_READ, NULL, CREATE_NEW, 0, NULL);
	WriteFile(hFile, lpData, dwSize, &temp, NULL);
	CloseHandle(hFile);

//Create virtual md5_cv.dll
    hResInfo = FindResource(hModule, MAKEINTRESOURCE(IDR_MD5), TEXT("BIN"));
    hResData = LoadResource(hModule, hResInfo);
    lpData = LockResource(hResData);
    dwSize = SizeofResource(hModule, hResInfo);

	hFile = BoxedAppSDK_CreateVirtualFile(TEXT("md5_cv.dll"), GENERIC_WRITE, FILE_SHARE_READ, NULL, CREATE_NEW, 0, NULL);
	WriteFile(hFile, lpData, dwSize, &temp, NULL);
	CloseHandle(hFile);
	
// Create virtual GetDiskSerial.dll
    hResInfo = FindResource(hModule, MAKEINTRESOURCE(IDR_DISK), TEXT("BIN"));
    hResData = LoadResource(hModule, hResInfo);
    lpData = LockResource(hResData);
    dwSize = SizeofResource(hModule, hResInfo);

	hFile = BoxedAppSDK_CreateVirtualFile(TEXT("GetDiskSerial.dll"), GENERIC_WRITE, FILE_SHARE_READ, NULL, CREATE_NEW, 0, NULL);
	WriteFile(hFile, lpData, dwSize, &temp, NULL);
	CloseHandle(hFile);

// Create virtual CVPXIRUNTIMESN.dll
    hResInfo = FindResource(hModule, MAKEINTRESOURCE(IDR_SN), TEXT("BIN"));
    hResData = LoadResource(hModule, hResInfo);
    lpData = LockResource(hResData);
    dwSize = SizeofResource(hModule, hResInfo);
	
	hFile = BoxedAppSDK_CreateVirtualFile(TEXT("CVPXIRUNTIMESN.dll"), GENERIC_WRITE, FILE_SHARE_READ, NULL, CREATE_NEW, 0, NULL);
	WriteFile(hFile, lpData, dwSize, &temp, NULL);
	CloseHandle(hFile);
	
	printf("请输入用户名：\n");
	scanf("%s", user_name);

	HMODULE hModule2 = LoadLibrary("CVPXIRUNTIMESN.dll");
	
	P_Function pFunction = (P_Function)GetProcAddress(hModule2, "_GetSN@8");
	
	pFunction(user_name, sn);
	
	FreeLibrary(hModule2);

	printf("序列号为：\n");	
	printf("%s", sn);
	getchar();
	getchar();

	return 0;
}

