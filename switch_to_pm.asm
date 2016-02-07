[bits 16]
;---------------------------
; Switch to Protected Mode -
;---------------------------

switch_to_pm:
  cli                           ; Turn of interrupts while we get into pm
  lgdt  [gdt_descriptor]        ; Load Global Descriptor Table

  mov   eax,cr0                 ; Flip the first bit of CR0 to 1
  or    eax,0x1                 ; without messing up the rest of
  mov   cr0,eax                 ; the bits in CR0

  jmp   CODE_SEG:init_pm        ; Make a far jump to force clear the cpu pipeline

[bits 32]

init_pm:
  mov   eax,DATA_SEG             ; Set the segment registers per info in GDT
  mov   ds,ax
  mov   ss,ax
  mov   es,ax
  mov   fs,ax
  mov   gs,ax

  mov   ebp,0x90000             ; Set stack to be at the top of free memory
  mov   esp,ebp

  call  BEGIN_PM                ; Call some well-know label as we are now in 32-bit protected mode!
