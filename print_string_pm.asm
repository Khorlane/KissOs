[bits 32]
;
; Print a string using video memory
;
; ebx = passed address of string
; edx = address of video memory
;

; Constants
VIDEO_MEMORY    equ 0xb8000
WHITE_ON_BLACK  equ 0x0f

print_string_pm:
  pusha
  mov   edx,VIDEO_MEMORY    ; Set edx to the start of video memory

print_string_pm_loop:
  mov   al,[ebx]            ; Store char at ebx in al
  mov   ah,WHITE_ON_BLACK   ; Store attributes in ah
  cmp   al,0                ; End of string?
  je    print_string_pm_done
  mov   [edx],ax            ; Put character and attributes into video memory
  add   ebx,1               ; Bump ebx to next character in the string
  add   edx,2               ; Bump video memory address to next char/attr
  jmp   print_string_pm_loop

print_string_pm_done:
  popa
  ret
