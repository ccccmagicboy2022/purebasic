#include "extcode.h"
#pragma pack(push)
#pragma pack(1)

#ifdef __cplusplus
extern "C" {
#endif

int16_t __stdcall Visa_phy_mem_alloc(uint32_t size, uint32_t *offset);
int16_t __stdcall Visa_phy_mem_free(uint32_t offset);

long __cdecl LVDLLStatus(char *errStr, int errStrLen, void *module);

#ifdef __cplusplus
} // extern "C"
#endif

#pragma pack(pop)

