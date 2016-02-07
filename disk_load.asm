; Load DH sectors to ES:BX from drive DL

disk_load:
  push  dx                  ; Store DX on the stack for safe keeping
  mov   ah,0x02             ; BIOS read sector function
  mov   al,dh               ; Read DH sectors
  mov   ch,0x00             ; Cylinder = 0
  mov   dh,0x00             ; Head = 0
  mov   cl,0x02             ; Start sector = 2
  int   0x13                ; BIOS interrupt to read disk

  jc    disk_error          ; Jump if carry flag (CF) of the special flags register is on

  pop   dx                  ; Get DX from the stack
  cmp   dh,al               ; DH = expected sectors read, AL = actual sectors read
  jne   disk_error          ; Not equal is bad
  ret

disk_error:
  mov   bx,DISK_ERROR_MSG
  call  print_string
  
  jmp   $                   ; Looper

; Variables
DISK_ERROR_MSG db 'Disk read error!',0
