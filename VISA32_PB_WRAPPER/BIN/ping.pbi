Procedure.l TestInetConnection(ip_num.l)
  ip_address.s{1024}  = ""
  ip_address  = IPString(ip_num)
  SendData$ = "Test"
  ReplyBuffer$ = Space(SizeOf(ICMP_ECHO_REPLY) + Len(SendData$) + SizeOf(character))
  hIcmpFile = IcmpCreateFile_()
  dwRetVal = IcmpSendEcho_(hIcmpFile, inet_addr_(@ip_address), @SendData$, Len(SendData$), #Null, @ReplyBuffer$, Len(ReplyBuffer$) + SizeOf(ICMP_ECHO_REPLY), 1000)

  If dwRetVal
    ProcedureReturn 1
  Else
    ProcedureReturn 0
  EndIf
 
EndProcedure

Procedure.l MakeIPAddress_from_string(*input)
  ip_address.s{1024}  = ""
  ip_address  = PeekS(*input, -1, #PB_Ascii)
  ip_num = MakeIPAddress(Val(StringField(ip_address, 1, ".")), Val(StringField(ip_address, 2, ".")), Val(StringField(ip_address, 3, ".")), Val(StringField(ip_address, 4, ".")))
  ProcedureReturn ip_num
EndProcedure


; IDE Options = PureBasic 5.00 (Windows - x86)
; CursorPosition = 6
; Folding = -
; EnableXP