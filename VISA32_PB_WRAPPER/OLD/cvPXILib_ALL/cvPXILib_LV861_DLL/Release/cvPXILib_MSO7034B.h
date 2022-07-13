#include "extcode.h"
#pragma pack(push)
#pragma pack(1)

#ifdef __cplusplus
extern "C" {
#endif

void __stdcall save_screenshot_to_bmp_7034b(char visa[], char path[]);
void __cdecl Save_screenshot_to_jpg_7034b(char visa[], char path[]);
void __cdecl Auto_scale_7034b(char visa[], char source[]);

long __cdecl LVDLLStatus(char *errStr, int errStrLen, void *module);

#ifdef __cplusplus
} // extern "C"
#endif

#pragma pack(pop)

