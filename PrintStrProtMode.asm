;------------------------------------
; Print a string using video memory -
;------------------------------------

; ebx = passed address of string
; edx = address of video memory

[bits 32]

; Constants
VIDEO_MEMORY    equ 0xb8000
GREY_ON_BLACK   equ 0x07

PrintStrProtMode:
  pusha
  mov   edx,VIDEO_MEMORY        ; Set edx to the start of video memory

PrintStrProtModeLoop:
  mov   al,[ebx]                ; Store char at ebx in al
  mov   ah,GREY_ON_BLACK        ; Store attributes in ah
  cmp   al,0                    ; End of string?
  je    PrintStrProtModeDone
  mov   [edx],ax                ; Put character and attributes into video memory
  add   ebx,1                   ; Bump ebx to next character in the string
  add   edx,2                   ; Bump video memory address to next char/attr
  jmp   PrintStrProtModeLoop

PrintStrProtModeDone:
  popa
  ret
