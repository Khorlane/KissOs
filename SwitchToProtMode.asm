[bits 16]

;---------------------------
; Switch to Protected Mode -
;---------------------------

SwitchToProtMode:
  cli                           ; Turn of interrupts while we get into pm
  lgdt  [GlobDescTblDescriptor] ; Load Global Descriptor Table

  mov   eax,cr0                 ; Flip the first bit of CR0 to 1
  or    eax,0x1                 ; without messing up the rest of
  mov   cr0,eax                 ; the bits in CR0

  jmp   CODE_SEG:InitProtMode   ; Make a far jump to force clear the cpu pipeline

[bits 32]

InitProtMode:
  mov   eax,DATA_SEG             ; Set the segment registers per info in GDT
  mov   ds,ax
  mov   ss,ax
  mov   es,ax
  mov   fs,ax
  mov   gs,ax

  mov   ebp,0x90000             ; Set stack to be at the top of free memory
  mov   esp,ebp

  call  BeginProtMode           ; Call our 32-bit protected mode code back in BootSect.asm
