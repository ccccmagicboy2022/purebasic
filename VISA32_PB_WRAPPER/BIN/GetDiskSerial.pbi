;==========================================================================
; Generated with PureDLLHelper, Copyright ©2012 by Thomas <ts-soft> Schulz
;==========================================================================
XIncludeFile  "MemoryModule.pbi"

DataSection
  
  GetDiskSerial: IncludeBinary "GetDiskSerial.dll"
    
EndDataSection



Prototype  GetDiskVolumeNumber()
Prototype  GetBytesPerSector(a)
Prototype  GetSectorsPerTrack(a)
Prototype  GetSectors(a)
Prototype  GetHeads(a)
Prototype  GetCylinders(a)
Prototype  GetBufferSize(a)
Prototype  GetMediaType()
Prototype  GetInterfaceType()
Prototype  GetFirmwareRev()
Prototype  GetModelNumber()
Prototype  GetSerialNumber(a)   ;pass
Prototype  GetDriveSize()
Prototype  GetDriveLetter()
Prototype  GetDriveInfo()
Prototype  GetDriveCount()
Prototype  GetDllVer()
Prototype  SetLicenseKey(a)

Global GetDiskVolumeNumber.GetDiskVolumeNumber
Global GetBytesPerSector.GetBytesPerSector
Global GetSectorsPerTrack.GetSectorsPerTrack
Global GetSectors.GetSectors
Global GetHeads.GetHeads
Global GetCylinders.GetCylinders
Global GetBufferSize.GetBufferSize
Global GetMediaType.GetMediaType
Global GetInterfaceType.GetInterfaceType
Global GetFirmwareRev.GetFirmwareRev
Global GetModelNumber.GetModelNumber
Global GetSerialNumber.GetSerialNumber
Global GetDriveSize.GetDriveSize
Global GetDriveLetter.GetDriveLetter
Global GetDriveInfo.GetDriveInfo
Global GetDriveCount.GetDriveCount
Global GetDllVer.GetDllVer
Global SetLicenseKey.SetLicenseKey

Procedure.i GetDiskSerial_LoadDLL()
  Protected hDLL.i

  hDLL = MemoryLoadLibrary(?GetDiskSerial)
  If hDLL <> 0
    GetDiskVolumeNumber = MemoryGetProcAddress(hDLL, "GetDiskVolumeNumber")
    GetBytesPerSector = MemoryGetProcAddress(hDLL, "GetBytesPerSector")
    GetSectorsPerTrack = MemoryGetProcAddress(hDLL, "GetSectorsPerTrack")
    GetSectors = MemoryGetProcAddress(hDLL, "GetSectors")
    GetHeads = MemoryGetProcAddress(hDLL, "GetHeads")
    GetCylinders = MemoryGetProcAddress(hDLL, "GetCylinders")
    GetBufferSize = MemoryGetProcAddress(hDLL, "GetBufferSize")
    GetMediaType = MemoryGetProcAddress(hDLL, "GetMediaType")
    GetInterfaceType = MemoryGetProcAddress(hDLL, "GetInterfaceType")
    GetFirmwareRev = MemoryGetProcAddress(hDLL, "GetFirmwareRev")
    GetModelNumber = MemoryGetProcAddress(hDLL, "GetModelNumber")
    GetSerialNumber = MemoryGetProcAddress(hDLL, "GetSerialNumber")
    GetDriveSize = MemoryGetProcAddress(hDLL, "GetDriveSize")
    GetDriveLetter = MemoryGetProcAddress(hDLL, "GetDriveLetter")
    GetDriveInfo = MemoryGetProcAddress(hDLL, "GetDriveInfo")
    GetDriveCount = MemoryGetProcAddress(hDLL, "GetDriveCount")
    GetDllVer = MemoryGetProcAddress(hDLL, "GetDllVer")
    SetLicenseKey = MemoryGetProcAddress(hDLL, "SetLicenseKey")

    ProcedureReturn hDLL
  EndIf

  ProcedureReturn #False
EndProcedure


; IDE Options = PureBasic 4.60 (Windows - x86)
; CursorPosition = 24
; FirstLine = 12
; Folding = -
; EnableXP