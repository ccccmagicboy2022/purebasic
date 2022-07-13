Procedure Pref_WriteString(Abschnitt.s,Schluessel.s,Wert.s,Datei.s) 
  Debug Abschnitt
  Debug Schluessel
  Debug Wert
  Debug Datei
  Debug "---"
  WritePrivateProfileString_ (Abschnitt, Schluessel, Wert,Datei) 
EndProcedure 

Procedure.s Pref_ReadString(Abschnitt.s,Schluessel.s,Datei.s) 
     value.s = Space(255) 
     Result.l = GetPrivateProfileString_ (Abschnitt, Schluessel, "", value, Len(value), Datei) 
     value = Left(value, Result) 
     ProcedureReturn value 
EndProcedure 
   
; IDE Options = PureBasic 5.00 (Windows - x86)
; CursorPosition = 15
; Folding = -
; EnableXP