; Ensure that we jump to kernel.c main function, not the beginning of our code
; which is most like where we want to start!

[bits 32]                       ; We are in 32 bit mode when we get here, so keep 32-bit mode
[extern main]                   ; main() is external, linker will resolve the address
call  main                      ; Invoke main() in our C kernel
jmp   $                         ; We should never get here
