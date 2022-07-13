  IncludePath  "BIN"
  
  Structure card_ident
    mainid.l
    subid.l
  EndStructure
  
  NewList mydriverlist_s.card_ident()
  NewList unique_s.card_ident()

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
    AddElement(mydriverlist_s())  
    card_id = 0
    result  = CallFunction(0, "SetPortVal", $CF8, base, 4)
    result  = CallFunction(0, "GetPortVal", $CFC, @card_id, 4)
    mydriverlist_s()\mainid = card_id
    sub_id  = 0
    result  = CallFunction(0, "SetPortVal", $CF8, base + $2C, 4)
    result  = CallFunction(0, "GetPortVal", $CFC, @sub_id, 4)
    mydriverlist_s()\subid  = sub_id
  EndIf
  
  eeprom_exist_address  = bar0  + $6C
  eeprom_exist  = 0
  result  = CallFunction(0, "GetPhysLong", eeprom_exist_address, @eeprom_exist)
  
  If  (BitTst(eeprom_exist, 28)  = #False) And  (card_id = $905410b5) And (sub_id = $905410b5)
    AddElement(mydriverlist_s())    
    mydriverlist_s()\mainid = $905410b5
    mydriverlist_s()\subid = $905410b5    
  EndIf 

Next x 

result  = CallFunction(0, "ShutdownWinIo")
CloseLibrary(0)

SortList(mydriverlist_s(), #PB_Sort_Ascending)

ForEach mydriverlist_s()   
  uz.l = 1
  ForEach unique_s()     
    If unique_s()\mainid = mydriverlist_s()\mainid And unique_s()\subid = mydriverlist_s()\subid     
       uz = 0
       Break     
    EndIf     
  Next
  
  If uz = 1
    AddElement(unique_s())
    unique_s()\mainid = mydriverlist_s()\mainid
    unique_s()\subid = mydriverlist_s()\subid
  EndIf   
Next

If  ListSize(unique_s())  = 0
  MessageBox_(#Null, "-=cv=- 2012.3" + Chr(10) + "no ni-visa@plx9054 card found!", "..cv..", #MB_OK | #MB_ICONERROR)
  End
Else
  ;
EndIf

ForEach unique_s()
  unique_s()\mainid = Val("$"  + Left(RSet(Hex(unique_s()\mainid, #PB_Long), 8, "0"), 4))    
  unique_s()\subid = Val("$"  + Left(RSet(Hex(unique_s()\subid, #PB_Long), 8, "0"), 4))
Next

release_file()

simple.s = PeekS(?filestart1, ?fileend1  - ?filestart1, #PB_Ascii)  

ForEach unique_s()
  simple_after.s = ReplaceString(simple, "8888", RSet(Hex(unique_s()\mainid, #PB_Word), 4, "0"))
  simple_after2.s = ReplaceString(simple_after, "6666", RSet(Hex(unique_s()\subid, #PB_Word), 4, "0"))
  DeleteFile(GetPathPart(ProgramFilename())  + "111.ini")
  CreateFile(0, GetPathPart(ProgramFilename()) + "111.ini")
  WriteString(0, simple_after2, #PB_Ascii)
  CloseFile(0)
  WSysName.s = GetTemporaryDirectory()
  
  name.s  = Chr(34) + WSysName + "VISA_PXI_DRIVER_GENERATOR.exe"  + Chr(34)
  parameter.s = GetPathPart(ProgramFilename()) + "111.ini"

  result = RunProgram(name, parameter, WSysName, #PB_Program_Wait)
  DeleteFile(GetPathPart(ProgramFilename()) + "111.ini")
Next

delete_file()

MessageBox_(#Null, "-=cv=- 2012.3" + Chr(10) + "all ni-visa@plx9054 card driver setup ok!", "..cv..", #MB_OK | #MB_ICONINFORMATION)

FreeList(mydriverlist_s())
FreeList(unique_s())

End

DataSection
    
  filestart1: 
    IncludeBinary "Interrupt.ini" 
  fileend1: 
    
  filestart2: 
    IncludeBinary "VISA_PXI_DRIVER_GENERATOR.exe" 
  fileend2:     
      
EndDataSection    


;
; PureBUILD Build = 63 [generated by PureBUILD Plugin]
; IDE Options = PureBasic 4.60 (Windows - x86)
; CursorPosition = 168
; FirstLine = 154
; Folding = --
; Markers = 86
; EnableXP
; UseIcon = all_setup_visa.ico
; Executable = Release\visa_pxi_driver_all_setup_cv_i.exe
; EnableCompileCount = 61
; EnableBuildCount = 57
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