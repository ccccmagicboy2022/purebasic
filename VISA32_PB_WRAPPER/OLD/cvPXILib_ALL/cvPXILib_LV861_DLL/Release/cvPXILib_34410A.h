#include "extcode.h"
#pragma pack(push)
#pragma pack(1)

#ifdef __cplusplus
extern "C" {
#endif

double __stdcall Read_2lines_res_ag34410a(char visa[]);
double __stdcall Read_dc_current_ag34410a(char visa[]);
double __stdcall Read_dc_volt_ag34410a(char visa[]);

long __cdecl LVDLLStatus(char *errStr, int errStrLen, void *module);

#ifdef __cplusplus
} // extern "C"
#endif

#pragma pack(pop)

