;**
;* Version 0.0.2 _
;* Copyright (c) 2004-20010 by Joachim Bauch / mail@joachim-bauch.de _
;* http://www.joachim-bauch.de _
;* _
;* The contents of this file are subject To the Mozilla Public License Version 1.1 _
;* (the "License"); you may not use this file except in ompliance with the License. _
;* You may obtain a copy of the License at http://www.mozilla.org/MPL/
;* _
;* Software distributed under the License is distributed on an "AS IS" basis, _
;* WITHOUT WARRANTY OF ANY KIND, either express Or implied. _
;* See the License For the specific anguage governing rights And limitations under the License.


; compiled with PellesC
; import and example by Thomas (ts-soft) Schulz

Import "oldnames.lib" : EndImport

CompilerIf #PB_Compiler_Processor = #PB_Processor_x64
  #MemoryModule_Lib$ = "MemoryModule64.lib"
CompilerElse
  #MemoryModule_Lib$ = "MemoryModule.lib" 
CompilerEndIf

Import #MemoryModule_Lib$
  MemoryLoadLibrary(MemoryPointer)
  MemoryGetProcAddress(hModule, FunctionName.p-ascii)
  MemoryFreeLibrary(hModule)
EndImport

