;------------------------------------------------------------------
Structure gauge 
  imagegad.l 
  imageid.l 
  width.l 
  height.l 
  imagehwnd.l 
  precision.l 
  ticks.l 
EndStructure 
;------------------------------------------------------------------
Global NewList led.gauge()
;------------------------------------------------------------------
Procedure LEDgadget(number,x,y,width,height,display) 
  AddElement(led()) 
  SelectElement(led(),number) 
  led()\width=width 
  led()\height=height 
  led()\imageid=CreateImage(#PB_Any,led()\width,led()\height) 
  StartDrawing(ImageOutput(led()\imageid)) 
  Box(0,0,led()\width,led()\height,#Black) 
  ledheight=led()\height-20 
  boxwidth=(led()\width-10-1)/2 
  secondx= 6+boxwidth 
  tickcount=0 
  For a=0 To led()\height-20 Step 4 
    tickcount=tickcount+1 
    Box(5,a,boxwidth,3,$7F00) 
    Box(secondx,a,boxwidth,3,$7F00) 
  Next  
  led()\ticks=tickcount 
  BackColor(RGB(0,0,0))
  FrontColor(RGB(0, $FF, 0))
  DrawText((led()\width/2)-10, led()\height-15, "0%") 
  StopDrawing() 
  led()\imagegad=ImageGadget(#PB_Any,x,y,width,height,ImageID(led()\imageid),#PB_Image_Border) 
  ProcedureReturn led()\imagegad 
EndProcedure 
;------------------------------------------------------------------
Procedure setLEDstate(led,percent) 
  SelectElement(led(),led) 
  tickcount=led()\ticks 
  perc.f=100/led()\ticks 
  percents.f=(percent/100) 
  finalpercent.f=percents*tickcount 
  stringpercent.s=StrF(finalpercent) 
  Result.f = Round(finalpercent, 1) 
  finalresult=led()\ticks-Result 
  ledheight=led()\height-20 
  boxwidth=(led()\width-10-1)/2 
  secondx=6+boxwidth 
  
  StartDrawing(ImageOutput(led()\imageid))
  tickcount=0 
  For a=0 To led()\height-20 Step 4 
    tickcount=tickcount+1 
    If tickcount>=finalresult 
      Box(5,a,boxwidth,3,$FF00) 
      Box(secondx,a,boxwidth,3,$FF00) 
    Else 
      Box(5,a,boxwidth,3,$7F00) 
      Box(secondx,a,boxwidth,3,$7F00) 
    EndIf 
  Next 
  Box(0,led()\height-15,led()\width,15,#Black) 
  BackColor(RGB(0,0,0))
  FrontColor(RGB(0, $FF, 0)) 
  DrawText((led()\width/2)-10, led()\height-15, Str(percent)+"%") 
  StopDrawing() 
  SetGadgetState(led()\imagegad,ImageID(led()\imageid)) 
EndProcedure 
;----------------------------------------------------------------------
ProcedureDLL  get_fifo_status_pb()
  
#WindowWidth  = 390 
#WindowHeight = 350 

If OpenWindow(0, 100, 200, #WindowWidth, #WindowHeight, "in cvPXILib_PB.dll::get_fifo0_status_pb()", #PB_Window_MinimizeGadget|#PB_Window_SystemMenu|#PB_Window_ScreenCentered)
  led=LEDgadget(0,50,50,40,100,0)  
  Repeat 
    setLEDstate(0,Random(100)) 
    EventID = WaitWindowEvent() 
    
    If EventID = #PB_Event_Gadget 
      
      Select EventGadget() 
        Case led 
          
      EndSelect 
      
    EndIf 
    
  Until EventID = #PB_Event_CloseWindow 
  
EndIf 

CloseWindow(0)

EndProcedure
; IDE Options = PureBasic 4.50 (Windows - x86)
; CursorPosition = 10
; Folding = -
; EnableXP