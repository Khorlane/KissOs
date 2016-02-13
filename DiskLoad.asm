;-----------------------------------------
; Load DH sectors to ES:BX from drive DL -
;-----------------------------------------

; DH controls the number of sectors to be read
; DL is the drive to be read

DiskLoad:
  push  dx                      ; Store DX on the stack for safe keeping
  mov   ah,0x02                 ; BIOS read sector function
  mov   al,dh                   ; Read DH sectors
  mov   ch,0x00                 ; Cylinder = 0
  mov   dh,0x00                 ; Head = 0
  mov   cl,0x02                 ; Start sector = 2
  int   0x13                    ; BIOS interrupt to read disk

  jc    DiskError               ; Jump if carry flag (CF) of the special flags register is on

  pop   dx                      ; Get DX from the stack
  cmp   dh,al                   ; DH = expected sectors read, AL = actual sectors read
  jne   DiskError               ; Not equal is bad
  ret

DiskError:
  mov   bx,DISK_ERROR_MSG
  call  PrintStr
  
  jmp   $                       ; Looper

; Variables
DISK_ERROR_MSG db 'Disk read error!',0
