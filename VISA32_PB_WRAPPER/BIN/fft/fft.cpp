// fft.cpp : Defines the entry point for the DLL application.
//

#include "stdafx.h"
#include <stdio.h>
#include <math.h>

#define	CVLIB_API_OUT	__declspec(dllexport)

BOOL APIENTRY DllMain( HANDLE hModule, 
                       DWORD  ul_reason_for_call, 
                       LPVOID lpReserved
					 )
{
    return TRUE;
}

namespace	fft_dll
{
	extern	"C"	CVLIB_API_OUT	void	WINAPI	FFT(double x[],double y[],int n,int sign);
}

//此代码来源《数字信号处理C语言程序集》殷福亮、宋爱军，沈阳：辽宁科学技术出版社，1997.7
//数组x存储时域序列的实部，数组y存储时域序列的虚部
//n代表N点FFT，sign=1为FFT，sign=-1为IFFT
void	WINAPI	fft_dll::FFT(double x[],double y[],int n,int sign)
{
	int i,j,k,l,m,n1,n2;
	double c,c1,e,s,s1,t,tr,ti;
	//Calculate i = log2N
	for(j = 1,i = 1; i<16; i++)
	{
		m = i;
		j = 2*j;
		if(j == n)
			break;
	}
	//计算蝶形图的输入下标（码位倒读）
	n1 = n - 1;
	for(j=0,i=0; i<n1; i++)
	{
		if(i<j)          
		{
			tr = x[j];
			ti = y[j];
			x[j] = x[i];
			y[j] = y[i];
			x[i] = tr;
			y[i] = ti;                
		}
		k = n/2;
		while(k<(j+1))
		{
			j = j - k;
			k = k/2;             
		}
		j = j + k;
	}
	//计算每一级的输出，l为某一级，i为同一级的不同群，使用同一内存（即位运算）
	n1 = 1;
	for(l=1; l<=m; l++)
	{
		n1 = 2*n1;
		n2 = n1/2;
		e = 3.1415926/n2;
		c = 1.0;
		s = 0.0;
		c1 = cos(e);
		s1 = -sign*sin(e);
		for(j=0; j<n2; j++)
		{
			for(i=j; i<n; i+=n1)        
			{
				k = i + n2;
				tr = c*x[k] - s*y[k];
				ti = c*y[k] + s*x[k];
				x[k] = x[i] - tr;
				y[k] = y[i] - ti;
				x[i] = x[i] + tr;
				y[i] = y[i] + ti;       
			}
			t = c;
			c = c*c1 - s*s1;
			s = t*s1 + s*c1;
		}
	}
	//如果是求IFFT，再除以N
	if(sign == -1)
	{
		for(i=0; i<n; i++)
		{
			x[i] /= n;
			y[i] /= n;
		}
	}
}
