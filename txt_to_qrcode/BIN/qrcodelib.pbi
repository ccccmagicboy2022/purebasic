
  DataSection
    dll2_start:
    IncludeBinary "qrcodelib.dll"
    dll2_end:
  EndDataSection

  Structure QRCode
    Version.l
    Width.l
    pSymbolData.l
  EndStructure
  
  Enumeration
    #QR_ECLEVEL_L = 0 ; lowest
    #QR_ECLEVEL_M
    #QR_ECLEVEL_Q
    #QR_ECLEVEL_H     ; highest
  EndEnumeration

  PrototypeC QRcode_encodeString8bit(Text.p-ascii, b, c)
  PrototypeC QRcode_free(*Qrcode.QRCode)
  
  Global QRcode_encodeString8bit.QRcode_encodeString8bit
  Global QRcode_free.QRcode_free

  Procedure.i qrcodelib_LoadDLL()
    Protected hDLL.i
    
    WSysName.s = Space(255)
    GetSystemDirectory_(WSysName, @Null)
    WSysName  = WSysName  + "\"
      
    file1_name.s  = WSysName + "qrcodelib.dll"
    result.q = FileSize(file1_name)
    If  result > 0
      ;
    Else
      If  result = -1
        file1 = CreateFile(#PB_Any, file1_name)
        WriteData(file1, ?dll2_start, ?dll2_end - ?dll2_start)
        CloseFile(file1)
      EndIf
    EndIf     
    
    hDLL = OpenLibrary(#PB_Any, "qrcodelib.dll")
    If hDLL <> 0
      QRcode_encodeString8bit = GetFunction(hDLL, "QRcode_encodeString8bit")
      QRcode_free = GetFunction(hDLL, "QRcode_free")
  
      ProcedureReturn hDLL
    EndIf
  
    ProcedureReturn #False
  EndProcedure

  Procedure CreateQRCode(content.s, ImgID = #PB_Any, EC_Level = #QR_ECLEVEL_L, Size=4)
  
    dll1  = qrcodelib_LoadDLL()
    
    Protected *Qrcode.QRCode, QRImg
    
    *Qrcode = QRcode_encodeString8bit(content, 0, EC_Level)
    
    With *Qrcode
      If *Qrcode = 0 Or \Width = 0
        ProcedureReturn #Null
      Else
        *mem = \pSymbolData
        w    = \Width
      EndIf
    EndWith
    
    QRImg  = CreateImage(ImgID, w, w)
    
    If QRImg
      If ImgID = #PB_Any
        ImgID = QRImg
      EndIf
    EndIf
    
    If StartDrawing(ImageOutput(ImgID))
        ; White Background
        Box (0, 0, ImageWidth(ImgID), ImageHeight(ImgID), #White)  
        
        ; Draw Black Dots
        For y = 0 To w - 1
          For x = 0 To w - 1
            b = PeekB(*mem) & $FF
            If b & 1
              Plot( x, y, #Black)
            EndIf
            *mem + 1
          Next
        Next
        
      StopDrawing()
      
      w * Size
      ResizeImage( ImgID, w, w, #PB_Image_Raw)
    EndIf
    
    QRcode_free(*Qrcode)
    
    CloseLibrary(dll1)    
    
    ProcedureReturn ImgID
  EndProcedure

; IDE Options = PureBasic 4.60 (Windows - x86)
; CursorPosition = 33
; Folding = -
; EnableXP