;==========================================================================
; Generated with PureDLLHelper, Copyright ©2012 by Thomas <ts-soft> Schulz
;==========================================================================

PrototypeC pivxi11_DiscoveryGetCount()
PrototypeC pivxi11_DiscoveryGetData()
PrototypeC pivxi11_DiscoveryInstrument()
PrototypeC pivxi11_DiscoveryNetwork()
PrototypeC pivxi11_GetLastError()

Global pivxi11_DiscoveryGetCount.pivxi11_DiscoveryGetCount
Global pivxi11_DiscoveryGetData.pivxi11_DiscoveryGetData
Global pivxi11_DiscoveryInstrument.pivxi11_DiscoveryInstrument
Global pivxi11_DiscoveryNetwork.pivxi11_DiscoveryNetwork
Global pivxi11_GetLastError.pivxi11_GetLastError

Procedure.i pivxi11_LoadDLL()
  Protected hDLL.i

  hDLL = OpenLibrary(#PB_Any, "pivxi11.dll")
  If hDLL <> 0
    pivxi11_DiscoveryGetCount = GetFunction(hDLL, "pivxi11_DiscoveryGetCount")
    pivxi11_DiscoveryGetData = GetFunction(hDLL, "pivxi11_DiscoveryGetData")
    pivxi11_DiscoveryInstrument = GetFunction(hDLL, "pivxi11_DiscoveryInstrument")
    pivxi11_DiscoveryNetwork = GetFunction(hDLL, "pivxi11_DiscoveryNetwork")
    pivxi11_GetLastError = GetFunction(hDLL, "pivxi11_GetLastError")

    ProcedureReturn hDLL
  EndIf

  ProcedureReturn #False
EndProcedure

