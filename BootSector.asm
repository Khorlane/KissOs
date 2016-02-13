;---------------------------------------------------------------
; A boot sector that boots a C kernel in 32-bit protected mode -
;---------------------------------------------------------------

[org 0x7c00]
KERNEL_OFFSET equ 0x1000        ; Memory offset where disk load will put our kernel

  mov   [BOOT_DRIVE],dl         ; Grab dl set by the bios for safe keeping

  mov   bp,0x9000               ; Set up the stack
  mov   sp,bp
  
  mov   bx,MSG_REAL_MODE        ; Starting out in 16-bit real mode
  call  PrintStr

  call  LoadKernel              ; Yep, loads the kernel

  call  SwitchToProtMode        ; Call expects a return, but not this time!
  
  jmp $                         ; We never get here, SwitchToProtMode comes back to BeginProtMode below

%include "PrintStr.asm"
%include "DiskLoad.asm"
%include "GlobDescTbl.asm"
%include "PrintStrProtMode.asm"
%include "SwitchToProtMode.asm"

[bits 16]

LoadKernel:
  mov   bx,MSG_LOAD_KERNEL      ; Announce Kernel loading
  call  PrintStr

  mov   bx,KERNEL_OFFSET        ; Set bx to address where we want the kernel loaded
  mov   dh,BOOT_SECT_COUNT      ; Set the number of sectors to be read
  mov   dl,[BOOT_DRIVE]         ; Set the boot drive
  call  DiskLoad                ; Load it
  
  ret                           ; Kernel is loaded

[bits 32]

BeginProtMode:                  ; The SwitchToProtMode routine lands us here
  mov   ebx,MSG_PROT_MODE       ; Use our 32-bit print routine
  call  PrintStrProtMode        ; to announce that we are in 32-bit protected mode!

  call  KERNEL_OFFSET           ; Jump to address of our loaded kernel code, which is KernelEntry

  jmp   $                       ; KernelEntry has a hang at the end, so we should never get here

; Global variables
BOOT_DRIVE      db  0           ; BIOS put boot drive in dl, we save it here
BOOT_SECT_COUNT equ 3           ; Number of sectors we want DiskLoad to load

; Messages
MSG_REAL_MODE   db  'Started in 16-bit Real Mode',0
MSG_LOAD_KERNEL db  'Loading kernel into memory',0
MSG_PROT_MODE   db  'Successfully landed in 32-bit Protected Mode',0

; Pad and add some magic
  times 510-($-$$) db 0
  dw 0xaa55
