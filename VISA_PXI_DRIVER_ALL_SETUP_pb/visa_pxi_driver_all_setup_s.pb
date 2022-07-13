  IncludePath  "BIN"
  
  NewList mydriverlist.l()
  NewList Unique.l()

  Procedure BitSet(A,N)   ;Sets the N bit
     ProcedureReturn A | 1 << N
  EndProcedure
  
  Procedure BitClr(A,N) ; Clears the N bit
     ProcedureReturn BitSet(A ,N) ! BitSet(0,N)
  EndProcedure
  
  Procedure BitTst(A,N) ;Returns state of N bit
    If A & BitClr(A,N)=A : ProcedureReturn #False :  EndIf
    ProcedureReturn #True
  EndProcedure
  
  Procedure BitChg(A,N) ;Change state of N bit
    If A & BitClr(A,N)=A : ProcedureReturn A|1<<N: EndIf
    ProcedureReturn BitSet(A,N) ! BitSet(0,N)
  EndProcedure  

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

  Procedure delete_file()
    
    WSysName.s = GetTemporaryDirectory()
    
    name.s  = WSysName  + "VISA_PXI_DRIVER_GENERATOR.exe"
    result  = DeleteFile(name)
    
  EndProcedure 

  Procedure release_file()
    
    WSysName.s = GetTemporaryDirectory()
    
    file1_name.s  = WSysName  + "VISA_PXI_DRIVER_GENERATOR.exe"
    result.q = FileSize(file1_name)
    If  result > 0
      ;
    Else
      file1 = CreateFile(#PB_Any, file1_name)
      WriteData(file1, ?filestart2, ?fileend2 - ?filestart2)
      CloseFile(file1)
    EndIf   
    
  EndProcedure 
  
  
version.s = ReadRegKey(#HKEY_LOCAL_MACHINE, "SOFTWARE\National Instruments\NI-VISA for Windows 95/NT\CurrentVersion", "Version")
  
If  version <> "3.3.1"
  If  version = "Error Opening Key"
    MessageBox_(#Null, "请先安装ni-visa v3.3.1 runtime", "..cv..", #MB_OK | #MB_ICONINFORMATION)
    End
  Else
    MessageBox_(#Null, "当前ni-visa版本为v"	+	version	+	Chr(10) + "推荐使用 ni-visa v3.3.1", "..cv..", #MB_OK | #MB_ICONINFORMATION)
  EndIf  
Else
  ;
EndIf  

result  = OpenLibrary(0, "WinIo32.dll")
result  = CallFunction(0, "InitializeWinIo")
If  result  = 0
  MessageBox_(#Null, "-=cv=- 2012.7" + Chr(10) + "winio error!", "..cv..", #MB_OK | #MB_ICONERROR)
  End
EndIf

For x.l = 0 To $1fff
  
  base.q = x*$800
  base  | $80000000  
  bar0.q  = base  + $010
  
  result  = CallFunction(0, "SetPortVal", $CF8, bar0, 4)
  result  = CallFunction(0, "GetPortVal", $CFC, @bar0, 4)
  
  bar0    = bar0  & $ffffffff
  hardcode_address  = bar0  + $70
  hardcode  = 0
  result  = CallFunction(0, "GetPhysLong", hardcode_address, @hardcode)
  
  If  hardcode  = $905410b5
    result  = CallFunction(0, "SetPortVal", $CF8, base, 4)
    result  = CallFunction(0, "GetPortVal", $CFC, @base, 4)
    AddElement(mydriverlist())
    mydriverlist() = base
  EndIf
  
  eeprom_exist_address  = bar0  + $6C
  eeprom_exist  = 0
  result  = CallFunction(0, "GetPhysLong", eeprom_exist_address, @eeprom_exist)
      
  card_id = 0
  result  = CallFunction(0, "SetPortVal", $CF8, base, 4)
  result  = CallFunction(0, "GetPortVal", $CFC, @card_id, 4)   
      
  card_id = card_id & $ffffffff
  
  If  (BitTst(eeprom_exist, 28)  = #False) And  (card_id = $905410b5)
    AddElement(mydriverlist())
    mydriverlist() = $905410b5
  EndIf 

Next x 

result  = CallFunction(0, "ShutdownWinIo")
CloseLibrary(0)

SortList(mydriverlist(), #PB_Sort_Ascending)

ForEach mydriverlist()   
  uz.l = 1
  ForEach Unique()     
    If Unique() = mydriverlist()     
       uz = 0
       Break     
    EndIf     
  Next
  
  If uz = 1
    AddElement(Unique())
    Unique() = mydriverlist()
  EndIf   
Next

If  ListSize(Unique())  = 0
  MessageBox_(#Null, "-=cv=- 2012.3" + Chr(10) + "no ni-visa@plx9054 card found!", "..cv..", #MB_OK | #MB_ICONERROR)
  End
Else
  ;
EndIf


ForEach Unique()
  Unique() = Val("$"  + Left(Hex(Unique(), #PB_Long), 4))
Next



release_file()

simple.s = PeekS(?filestart1, ?fileend1  - ?filestart1, #PB_Ascii)  



ForEach Unique()
  simple_after.s = ReplaceString(simple, "8888", Hex(Unique(), #PB_Long))
  DeleteFile(GetPathPart(ProgramFilename())  + "111.ini")
  CreateFile(0, GetPathPart(ProgramFilename()) + "111.ini")
  WriteString(0, simple_after, #PB_Ascii)
  CloseFile(0)
  WSysName.s = GetTemporaryDirectory()
  
  name.s  = Chr(34) + WSysName + "VISA_PXI_DRIVER_GENERATOR.exe"  + Chr(34)
  parameter.s = GetPathPart(ProgramFilename()) + "111.ini"

  result = RunProgram(name, parameter, WSysName, #PB_Program_Wait)
  DeleteFile(GetPathPart(ProgramFilename()) + "111.ini")
Next

delete_file()

MessageBox_(#Null, "-=cv=- 2012.3" + Chr(10) + "all ni-visa@plx9054 card driver setup ok!", "..cv..", #MB_OK | #MB_ICONINFORMATION)

End

DataSection
    
  filestart1: 
    IncludeBinary "Simple.ini" 
  fileend1: 
    
  filestart2: 
    IncludeBinary "VISA_PXI_DRIVER_GENERATOR.exe" 
  fileend2:     
      
EndDataSection    


;
; PureBUILD Build = 45 [generated by PureBUILD Plugin]
; IDE Options = PureBasic 4.60 (Windows - x86)
; CursorPosition = 171
; FirstLine = 164
; Folding = --
; Markers = 81
; EnableXP
; UseIcon = all_setup_visa.ico
; Executable = Release\visa_pxi_driver_all_setup_cv_s.exe
; EnableCompileCount = 47
; EnableBuildCount = 43
; EnableExeConstant
; IncludeVersionInfo
; VersionField0 = 1,0,0,%BUILDCOUNT
; VersionField1 = 1,0,0,%BUILDCOUNT
; VersionField2 = cv
; VersionField3 = cv
; VersionField4 = 1,0,0,%BUILDCOUNT
; VersionField5 = 1,0,0,%BUILDCOUNT
; VersionField6 = cv
; VersionField7 = cv
; VersionField8 = cv
; VersionField18 = CCCC
; VersionField19 = cv
; VersionField20 = cuiwei
; VersionField21 = cccc
; VersionField22 = 2012
; VersionField23 = cuiwei