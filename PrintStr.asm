;-----------------
; Print a string -
;-----------------

PrintStr:
  pusha
  mov   ah,0x0e

PrintStrLoop:
  mov   al,[bx]
  int   0x10
  add   bx,1
  cmp   al,0
  jne   PrintStrLoop
  popa
  ret
