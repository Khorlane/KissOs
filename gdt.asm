;------------------------------------
; The GDT - Global Descriptor Table -
;------------------------------------

; Mark the start of the GDT
gdt_start:

; The required null descriptor
gdt_null:
  dd    0x0                     ; 4 bytes of zeros
  dd    0x0                     ; 4 more bytes of zeros for a total of 8 bytes

; The code descriptor
gdt_code:
  dw    0xffff                  ; Segment Limit part 1
  dw    0x0                     ; Base Address part 1
  db    0x0                     ; Base Address part 2
  db    10011010b               ; 1st Flags 1001, Type Flags 1010
  db    11001111b               ; 2nd Flags 1100, Segment Limit part 2 1111
  db    0x0                     ; Base Address part 3

; The data descriptor
gdt_data:
  dw    0xffff                  ; Segment Limit part 1
  dw    0x0                     ; Base Address part 1
  db    0x0                     ; Base Address part 2
  db    10010010b               ; 1st Flags 1001, Type Flags 0010
  db    11001111b               ; 2nd Flags 1100, Segment Limit part 2 1111
  db    0x0                     ; Base Address part 3

; Mark the end of the GDT
gdt_end:

;---------------------
; The GDT descriptor -
;---------------------
gdt_descriptor:
  dw    gdt_end - gdt_start - 1 ; Size of the GDT
  dd    gdt_start               ; Address of the GDT

;------------------------------------------------
; Handy Constants for Setting Segment Registers -
;------------------------------------------------
CODE_SEG equ gdt_code - gdt_start
DATA_SEG equ gdt_data - gdt_start
