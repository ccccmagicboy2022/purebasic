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

  Procedure delete_temp_file()
    
    WSysName.s = GetTemporaryDirectory()
    folder.s  = GetCurrentDirectory()
    
    name.s  = WSysName  + "inf_install.exe"
    result  = DeleteFile(name)
    
    name  = WSysName  + "inf_uninstall.exe"
    result  = DeleteFile(name)
    
  EndProcedure 

  Procedure release_temp_file()
    
    WSysName.s = GetTemporaryDirectory()
    folder.s  = GetCurrentDirectory()
    
    file1_name.s  = WSysName  + "inf_install.exe"
    result.q = FileSize(file1_name)
    If  result > 0
      ;
    Else
      file1 = CreateFile(#PB_Any, file1_name)
      WriteData(file1, ?filestart1, ?fileend1 - ?filestart1)
      CloseFile(file1)
    EndIf  
    ;---------------------------
    file1_name.s  = WSysName  + "inf_uninstall.exe"
    result.q = FileSize(file1_name)
    If  result > 0
      ;
    Else
      file1 = CreateFile(#PB_Any, file1_name)
      WriteData(file1, ?filestart2, ?fileend2 - ?filestart2)
      CloseFile(file1)
    EndIf  
    ;---------------------------  
    
  EndProcedure 
  
result  = OpenLibrary(0, "WinIo32.dll")
result  = CallFunction(0, "InitializeWinIo")
If  result  = 0
  MessageBox_(GetFocus_(), "-=cv=- 2012.7" + Chr(10) + "winio error!", "..cv..", #MB_SYSTEMMODAL|#MB_OK|#MB_ICONERROR)
  End
EndIf

For x.l = 0 To $1fff
  
  base.l = x*$800
  base  | $80000000
  
  card_id.l = 0
  result  = CallFunction(0, "SetPortVal", $CF8, base, 4)
  result  = CallFunction(0, "GetPortVal", $CFC, @card_id, 4)  
  sub_id.l  = 0
  result  = CallFunction(0, "SetPortVal", $CF8, base + $2C, 4)
  result  = CallFunction(0, "GetPortVal", $CFC, @sub_id, 4)
  
  
  If  $ffffffff = card_id Or  $ffffffff = sub_id
    ;
  Else
    If  "8086" = Right(Hex(card_id, #PB_Long), 4)
      ;
    Else
      bar0_offset.l  = base  + $10
      bar0.l  = 0
      
      result  = CallFunction(0, "SetPortVal", $CF8, bar0_offset, 4)
      result  = CallFunction(0, "GetPortVal", $CFC, @bar0, 4)
      
      hardcode_address.l  = bar0  + $70
      hardcode.l  = 0
      result  = CallFunction(0, "GetPhysLong", hardcode_address, @hardcode)
      
      If  $905410b5 = hardcode
        AddElement(mydriverlist_s())  
        mydriverlist_s()\mainid = card_id
        mydriverlist_s()\subid  = sub_id
      Else
        result  = MessageBox_(GetFocus_(), "card_id: 0x" + RSet(Hex(card_id, #PB_Long), 8, "0") + "; sub_id: 0x" + RSet(Hex(sub_id, #PB_Long), 8, "0") + ", use this card?", "-cv-", #MB_DEFBUTTON2|#MB_YESNO|#MB_SYSTEMMODAL|#MB_ICONQUESTION)
        Select  result
          Case  #IDYES
            AddElement(mydriverlist_s())  
            mydriverlist_s()\mainid = card_id
            mydriverlist_s()\subid  = sub_id    
          Case  #IDNO
            ;
          Default
            ;
        EndSelect
      EndIf
      
    EndIf
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
  MessageBox_(GetFocus_(), "-=cv=- 2012.3" + Chr(10) + "no ni-visa@plx9054 card found!", "..cv..", #MB_SYSTEMMODAL|#MB_OK|#MB_ICONERROR)
  End
Else
  ;
EndIf

release_temp_file()

result  = MessageBox_(GetFocus_(), "Yes to select simple driver, No to select interrupt driver!", "cv", #MB_YESNO|#MB_SYSTEMMODAL|#MB_DEFBUTTON2|#MB_ICONQUESTION)

Select  result
  Case  #IDYES
    simple.s = PeekS(?filestart5, ?fileend5  - ?filestart5, #PB_Ascii)
  Case  #IDNO
    simple = PeekS(?filestart4, ?fileend4  - ?filestart4, #PB_Ascii)
EndSelect

Define  name.s{1024}  = ""

ForEach unique_s()
  simple_after.s = ReplaceString(simple, "%main_did%", Left(Hex(unique_s()\mainid, #PB_Long), 4))
  simple_after2.s = ReplaceString(simple_after, "%sub_did%", Left(Hex(unique_s()\subid, #PB_Long), 4))
  simple_after3.s = ReplaceString(simple_after2, "%main_vid%", Right(Hex(unique_s()\mainid, #PB_Long), 4))
  simple_after4.s = ReplaceString(simple_after3, "%sub_vid%", Right(Hex(unique_s()\subid, #PB_Long), 4))
  simple_after5.s = ReplaceString(simple_after4, "%date%", FormatDate("%mm/%dd/%yyyy", Date()))
  DeleteFile(GetPathPart(ProgramFilename())  + "111.inf")
  CreateFile(0, GetPathPart(ProgramFilename()) + "111.inf")
  WriteString(0, simple_after5, #PB_Ascii)
  CloseFile(0)
  WSysName.s = GetTemporaryDirectory()
  
  result  = MessageBox_(#Null, "-=cv=- 2012.3" + Chr(10) + "find card: 0x" + Hex(unique_s()\mainid, #PB_Long) + Chr(10) + "Yes to Install Driver, No to Uninstall Driver", "..cv..", #MB_DEFBUTTON3|#MB_SYSTEMMODAL|#MB_YESNOCANCEL|#MB_ICONQUESTION)
  
  Select  result
    Case  #IDYES
      name  = Chr(34) + WSysName + "inf_install.exe"  + Chr(34)
    Case  #IDNO
      name  = Chr(34) + WSysName + "inf_uninstall.exe"  + Chr(34)
    Case  #IDCANCEL
      DeleteFile(GetPathPart(ProgramFilename()) + "111.inf")
      Continue
  EndSelect
    
  parameter.s = GetPathPart(ProgramFilename())
  result = RunProgram(name, parameter, WSysName, #PB_Program_Wait)
  DeleteFile(GetPathPart(ProgramFilename()) + "111.inf")
Next

delete_temp_file()

result  = MessageBox_(GetFocus_(), "-=cv=- 2012.3" + Chr(10) + "ni-visa32@plx9054 card driver scan finished!" + Chr(10) + "yes to open devmgmt. ", "..cv..", #MB_DEFBUTTON2|#MB_SYSTEMMODAL|#MB_YESNO|#MB_ICONQUESTION)
Select  result
  Case  #IDYES
    RunProgram("devmgmt.msc")
  Case  #IDNO
    ;
EndSelect

FreeList(mydriverlist_s())
FreeList(unique_s())

End



DataSection
    
  filestart1: 
    IncludeBinary "inf_install.exe" 
  fileend1: 
    
  filestart2: 
    IncludeBinary "inf_uninstall.exe" 
  fileend2:     
    
  filestart4: 
    IncludeBinary "pxi8888_interrupt_driver.inf" 
  fileend4:
    
  filestart5: 
    IncludeBinary "PXI8888_simple_driver.inf" 
  fileend5:    
      
EndDataSection    


;
; PureBUILD Build = 76 [generated by PureBUILD Plugin]
; IDE Options = PureBasic 5.00 (Windows - x86)
; CursorPosition = 194
; FirstLine = 130
; Folding = --
; EnableThread
; EnableXP
; EnableAdmin
; UseIcon = BIN\all_setup2.ico
; Executable = Release\VISA_PXI_DRIVER_ALL_SETUP_pb_v2.exe
; CompileSourceDirectory
; EnableCompileCount = 74
; EnableBuildCount = 36
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
; Watchlist = base