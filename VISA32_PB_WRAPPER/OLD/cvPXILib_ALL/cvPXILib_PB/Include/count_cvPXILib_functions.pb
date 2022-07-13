;-----------------------------------------------------------------------------------------------
ProcedureDLL.q  count_cvPXILib_functions()
  
  Enumeration
    #DLL1
    #DLL2
    #DLL3
    #DLL4
    #DLL5
  EndEnumeration  
  
  OpenLibrary(#DLL1, "cvPXILib.dll")
  OpenLibrary(#DLL2, "cvPXILib_PB.dll")
  OpenLibrary(#DLL3, "cvPXILib_34410A.dll")
  OpenLibrary(#DLL4, "cvPXILib_MSO7034B.dll")
  OpenLibrary(#DLL4, "cvPXILib_visa32.dll")
  
  Result.q = CountLibraryFunctions(#DLL1)
  Result  = Result  + CountLibraryFunctions(#DLL2)
  Result  = Result  + CountLibraryFunctions(#DLL3)  
  Result  = Result  + CountLibraryFunctions(#DLL4)  
  Result  = Result  + CountLibraryFunctions(#DLL5) 
  
  CloseLibrary(#DLL1)
  CloseLibrary(#DLL2)
  CloseLibrary(#DLL3)
  CloseLibrary(#DLL4)
  CloseLibrary(#DLL5)

  ProcedureReturn Result  
  
EndProcedure
; IDE Options = PureBasic 4.50 (Windows - x86)
; CursorPosition = 27
; Folding = -
; EnableXP