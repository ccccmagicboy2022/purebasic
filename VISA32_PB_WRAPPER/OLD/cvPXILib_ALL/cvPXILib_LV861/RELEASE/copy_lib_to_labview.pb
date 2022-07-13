;read a key from the registry
Procedure.s ReadRegKey(OpenKey.l, SubKey.s, ValueName.s)
    hKey.l = 0
    KeyValue.s = Space(255)
    Datasize.l = 255
    If RegOpenKeyEx_(OpenKey, SubKey, 0, #KEY_READ, @hKey)
        KeyValue = "Error Opening Key"
    Else
        If RegQueryValueEx_(hKey, ValueName, 0, 0, @KeyValue, @Datasize)
            KeyValue = "Error Reading Key"
        Else 
            KeyValue = Left(KeyValue, Datasize - 1)
        EndIf
        RegCloseKey_(hKey)
    EndIf
    ProcedureReturn KeyValue
EndProcedure

;write a key to the registry
Procedure.l WriteRegKey(OpenKey.l, SubKey.s, KeySet.s, KeyValue.s)
    hKey.l = 0 
    If RegCreateKey_(OpenKey, SubKey, @hKey) = 0
        Result = 1
        Datasize.l = Len(KeyValue)
        If RegSetValueEx_(hKey, KeySet, 0, #REG_SZ, @KeyValue, Datasize) = 0
            Result = 2
        EndIf
        RegCloseKey_(hKey)
    EndIf
    ProcedureReturn Result
EndProcedure

Procedure DeleteRegKey(OpenKey.l, SubKey.s)
  RegDeleteKey_(OpenKey, SubKey)
EndProcedure

source.s = GetCurrentDirectory() + "cvPXILib_LV861\"
destination.s  = ReadRegKey(#HKEY_LOCAL_MACHINE, "SOFTWARE\National Instruments\LabVIEW\CurrentVersion", "Path")
If  (destination  = "Error Opening Key")
  MessageRequester("cv", "no labview found!", #PB_MessageRequester_Ok)
Else
  destination  = destination  + "user.lib\cvPXILib_LV861\"
  If(CopyDirectory(source, destination, "", #PB_FileSystem_Recursive))
    DeleteDirectory(source, "", #PB_FileSystem_Recursive)
    MessageRequester("cv", "lib copied!", #PB_MessageRequester_Ok)
  Else
    MessageRequester("cv", "lib not ´æÔÚ!", #PB_MessageRequester_Ok)
  EndIf
EndIf

 






; IDE Options = PureBasic 4.50 (Windows - x86)
; CursorPosition = 46
; FirstLine = 24
; Folding = -
; EnableXP
; UseIcon = ..\icon\Labview_v861.ico