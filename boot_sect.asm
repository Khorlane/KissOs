;
; A boot sector boots a C kernel in 32-bit protected mode.
;

[org 0x7c00]
KERNEL_OFFSET equ 0x1000        ; Memory offset where disk load will put our kernel

  mov   [BOOT_DRIVE],dl         ; Grab dl set by the bios for safe keeping

  mov   bp,0x9000               ; Set up the stack
  mov   sp,bp
  
  mov   bx,MSG_REAL_MODE        ; Starting out in 16-bit real mode
  call  print_string

  call  load_kernel             ; Yep, loads the kernel

  call  switch_to_pm            ; Call expects a return, but not this time!
  
  jmp $                         ; We never get here

%include "print_string.asm"
%include "disk_load.asm"
%include "gdt.asm"
%include "print_string_pm.asm"
%include "switch_to_pm.asm"

[bits 16]

load_kernel:
  mov   bx,MSG_LOAD_KERNEL
  call  print_string

  mov   bx,KERNEL_OFFSET
  mov   dh,BOOT_SECT_COUNT
  mov   dl,[BOOT_DRIVE]
  call  disk_load
  
  ret

[bits 32]

; The switch_to_pm routine lands us here
BEGIN_PM:
  mov   ebx,MSG_PROT_MODE       ; Use our 32-bit print routine
  call  print_string_pm         ; to announce that we are in 32-bit protected mode!

  call  KERNEL_OFFSET           ; Jump to address of our loaded kernel code

  jmp   $                       ; We hang here when the kernel returns

; Global variables

BOOT_DRIVE      db  0
BOOT_SECT_COUNT equ 2
MSG_REAL_MODE   db  'Started in 16-bit Real Mode',0
MSG_PROT_MODE   db  'Successfully landed in 32-bit Protected Mode',0
MSG_LOAD_KERNEL db  'Loading kernel into memory',0

;
; Pad and add some magic
;
  times 510-($-$$) db 0
  dw 0xaa55
