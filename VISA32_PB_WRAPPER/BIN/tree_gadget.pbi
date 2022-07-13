Procedure TreeViewExpandAll(Gadget.l) 
    hwndTV.l = GadgetID(Gadget)  
    hRoot.l = SendMessage_(hwndTV, #TVM_GETNEXTITEM, #TVGN_ROOT, 0)  
    hItem.l = hRoot  
    Repeat 
        SendMessage_(hwndTV, #TVM_EXPAND, #TVE_EXPAND, hItem) 
        hItem = SendMessage_(hwndTV, #TVM_GETNEXTITEM, #TVGN_NEXTVISIBLE , hItem)  
    Until hItem = #Null  
    SendMessage_(hwndTV, #TVM_ENSUREVISIBLE, 0, hRoot) 
EndProcedure
  
Procedure TreeViewCollapseAll(Gadget.l) 
    hwndTV.l = GadgetID(Gadget)  
    hRoot.l = SendMessage_(hwndTV, #TVM_GETNEXTITEM, #TVGN_ROOT, 0)  
    hItem.l = hRoot  
    Repeat 
        SendMessage_(hwndTV, #TVM_EXPAND, #TVE_COLLAPSE, hItem) 
        hItem = SendMessage_(hwndTV, #TVM_GETNEXTITEM, #TVGN_NEXTVISIBLE , hItem)  
    Until hItem = #Null  
    SendMessage_(hwndTV, #TVM_ENSUREVISIBLE, 0, hRoot) 
EndProcedure  
; IDE Options = PureBasic 4.60 (Windows - x86)
; CursorPosition = 20
; Folding = -
; EnableXP