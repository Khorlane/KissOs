;-----------------------------------------
; Ensure that we jump to Kernel.c main() -
;-----------------------------------------

[bits 32]                       ; We are in 32 bit mode when we get here, so keep 32-bit mode
[extern main]                   ; main() is external, linker will resolve the address
call  main                      ; Invoke main() in our C kernel
jmp   $                         ; We come back here, if main()ever returns
