;-------------------------------
; Print the value in DX as hex -
;-------------------------------

PrintHex:
  ; Manipulate chars at HEX_OUT to reflect DX
  mov   cx,dx
  and   cx,0xf000
  shr   cx,12
  call  ToChar
  mov   [HEX_OUT+2],cx

  mov   cx,dx
  and   cx,0x0f00
  shr   cx,8
  call  ToChar
  mov   [HEX_OUT+3],cx

  mov   cx,dx
  and   cx,0x00f0
  shr   cx,4
  call  ToChar
  mov   [HEX_OUT+4],cx

  mov   cx,dx
  and   cx,0x000f
  call  ToChar
  mov   [HEX_OUT+5],cx

  mov   bx,HEX_OUT
  call  PrintStr
  mov   byte [HEX_OUT+2],'0'
  mov   byte [HEX_OUT+3],'0'
  mov   byte [HEX_OUT+4],'0'
  mov   byte [HEX_OUT+5],'0'
  ret

ToChar:
  cmp   cx,0xa
  jl    Digits
  sub   cx,0xa
  add   cx,'a'
  ret

Digits:
  add   cx,'0'
  ret

HEX_OUT: db '0x0000',0
