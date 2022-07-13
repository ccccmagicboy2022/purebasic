;==========================================================================
; Generated with PureDLLHelper, Copyright ©2012 by Thomas <ts-soft> Schulz
;==========================================================================
XIncludeFile  "MemoryModule.pbi"

DataSection
  
  BASSMOD_s: 
    IncludeBinary "BASSMOD.dll"
  BASSMOD_e:  
    
  MUSIC1: IncludeBinary "PCO.MOD"  
    
EndDataSection

#BASS_MUSIC_LOOP = 4 ;loop music

Prototype  BASSMOD_ErrorGetCode()
Prototype  BASSMOD_Free()
Prototype  BASSMOD_GetCPU()
Prototype  BASSMOD_GetDeviceDescription(a)
Prototype  BASSMOD_GetVersion()
Prototype  BASSMOD_GetVolume()
Prototype  BASSMOD_Init(a, b, c)
Prototype  BASSMOD_MusicFree()
Prototype  BASSMOD_MusicGetLength(a)
Prototype  BASSMOD_MusicGetName()
Prototype  BASSMOD_MusicGetPosition()
Prototype  BASSMOD_MusicIsActive()
Prototype  BASSMOD_MusicLoad(a, b, c, d, e)
Prototype  BASSMOD_MusicPause()
Prototype  BASSMOD_MusicPlay()
Prototype  BASSMOD_MusicPlayEx(a, b, c)
Prototype  BASSMOD_MusicRemoveSync(a)
Prototype  BASSMOD_MusicSetAmplify(a)
Prototype  BASSMOD_MusicSetPanSep(a)
Prototype  BASSMOD_MusicSetPosition(a)
Prototype  BASSMOD_MusicSetPositionScaler(a)
Prototype  BASSMOD_MusicSetSync(a, b, c, d)
Prototype  BASSMOD_MusicStop()
Prototype  BASSMOD_SetVolume(a)

Global BASSMOD_ErrorGetCode.BASSMOD_ErrorGetCode
Global BASSMOD_Free.BASSMOD_Free
Global BASSMOD_GetCPU.BASSMOD_GetCPU
Global BASSMOD_GetDeviceDescription.BASSMOD_GetDeviceDescription
Global BASSMOD_GetVersion.BASSMOD_GetVersion
Global BASSMOD_GetVolume.BASSMOD_GetVolume
Global BASSMOD_Init.BASSMOD_Init
Global BASSMOD_MusicFree.BASSMOD_MusicFree
Global BASSMOD_MusicGetLength.BASSMOD_MusicGetLength
Global BASSMOD_MusicGetName.BASSMOD_MusicGetName
Global BASSMOD_MusicGetPosition.BASSMOD_MusicGetPosition
Global BASSMOD_MusicIsActive.BASSMOD_MusicIsActive
Global BASSMOD_MusicLoad.BASSMOD_MusicLoad
Global BASSMOD_MusicPause.BASSMOD_MusicPause
Global BASSMOD_MusicPlay.BASSMOD_MusicPlay
Global BASSMOD_MusicPlayEx.BASSMOD_MusicPlayEx
Global BASSMOD_MusicRemoveSync.BASSMOD_MusicRemoveSync
Global BASSMOD_MusicSetAmplify.BASSMOD_MusicSetAmplify
Global BASSMOD_MusicSetPanSep.BASSMOD_MusicSetPanSep
Global BASSMOD_MusicSetPosition.BASSMOD_MusicSetPosition
Global BASSMOD_MusicSetPositionScaler.BASSMOD_MusicSetPositionScaler
Global BASSMOD_MusicSetSync.BASSMOD_MusicSetSync
Global BASSMOD_MusicStop.BASSMOD_MusicStop
Global BASSMOD_SetVolume.BASSMOD_SetVolume

Procedure.i BASSMOD_LoadDLL()
  Protected hDLL.i

  hDLL = MemoryLoadLibrary(?BASSMOD_s)
  If hDLL <> 0
    BASSMOD_ErrorGetCode = MemoryGetProcAddress(hDLL, "BASSMOD_ErrorGetCode")
    BASSMOD_Free = MemoryGetProcAddress(hDLL, "BASSMOD_Free")
    BASSMOD_GetCPU = MemoryGetProcAddress(hDLL, "BASSMOD_GetCPU")
    BASSMOD_GetDeviceDescription = MemoryGetProcAddress(hDLL, "BASSMOD_GetDeviceDescription")
    BASSMOD_GetVersion = MemoryGetProcAddress(hDLL, "BASSMOD_GetVersion")
    BASSMOD_GetVolume = MemoryGetProcAddress(hDLL, "BASSMOD_GetVolume")
    BASSMOD_Init = MemoryGetProcAddress(hDLL, "BASSMOD_Init")
    BASSMOD_MusicFree = MemoryGetProcAddress(hDLL, "BASSMOD_MusicFree")
    BASSMOD_MusicGetLength = MemoryGetProcAddress(hDLL, "BASSMOD_MusicGetLength")
    BASSMOD_MusicGetName = MemoryGetProcAddress(hDLL, "BASSMOD_MusicGetName")
    BASSMOD_MusicGetPosition = MemoryGetProcAddress(hDLL, "BASSMOD_MusicGetPosition")
    BASSMOD_MusicIsActive = MemoryGetProcAddress(hDLL, "BASSMOD_MusicIsActive")
    BASSMOD_MusicLoad = MemoryGetProcAddress(hDLL, "BASSMOD_MusicLoad")
    BASSMOD_MusicPause = MemoryGetProcAddress(hDLL, "BASSMOD_MusicPause")
    BASSMOD_MusicPlay = MemoryGetProcAddress(hDLL, "BASSMOD_MusicPlay")
    BASSMOD_MusicPlayEx = MemoryGetProcAddress(hDLL, "BASSMOD_MusicPlayEx")
    BASSMOD_MusicRemoveSync = MemoryGetProcAddress(hDLL, "BASSMOD_MusicRemoveSync")
    BASSMOD_MusicSetAmplify = MemoryGetProcAddress(hDLL, "BASSMOD_MusicSetAmplify")
    BASSMOD_MusicSetPanSep = MemoryGetProcAddress(hDLL, "BASSMOD_MusicSetPanSep")
    BASSMOD_MusicSetPosition = MemoryGetProcAddress(hDLL, "BASSMOD_MusicSetPosition")
    BASSMOD_MusicSetPositionScaler = MemoryGetProcAddress(hDLL, "BASSMOD_MusicSetPositionScaler")
    BASSMOD_MusicSetSync = MemoryGetProcAddress(hDLL, "BASSMOD_MusicSetSync")
    BASSMOD_MusicStop = MemoryGetProcAddress(hDLL, "BASSMOD_MusicStop")
    BASSMOD_SetVolume = MemoryGetProcAddress(hDLL, "BASSMOD_SetVolume")

    ProcedureReturn hDLL
  EndIf

  ProcedureReturn #False
EndProcedure


; IDE Options = PureBasic 4.60 (Windows - x86)
; CursorPosition = 70
; FirstLine = 65
; Folding = -
; EnableXP