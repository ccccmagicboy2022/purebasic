#pragma once

extern	"C"	__declspec(dllimport) int	WINAPI	aero_apply(HWND hwnd, int left=-1, int top=-1, int right=-1, int bottom=-1);

extern	"C"	__declspec(dllimport) int	WINAPI	aero_init();

extern	"C"	__declspec(dllimport) int	WINAPI	aero_final();

extern	"C"	__declspec(dllimport) int	WINAPI	aero_remove(HWND hwnd);

extern	"C"	__declspec(dllimport) int	WINAPI	aero_test();
