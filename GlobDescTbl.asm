;------------------------------------
; The GDT - Global Descriptor Table -
;------------------------------------

; Mark the start of the GDT
GlobDescTblStart:

; The required null descriptor
GlobDescTblNull:
  dd    0x0                     ; 4 bytes of zeros
  dd    0x0                     ; 4 more bytes of zeros for a total of 8 bytes

; The code descriptor
GlobDescTblCode:
  dw    0xffff                  ; Segment Limit part 1
  dw    0x0                     ; Base Address part 1
  db    0x0                     ; Base Address part 2
  db    10011010b               ; 1st Flags 1001, Type Flags 1010
  db    11001111b               ; 2nd Flags 1100, Segment Limit part 2 1111
  db    0x0                     ; Base Address part 3

; The data descriptor
GlobDescTblData:
  dw    0xffff                  ; Segment Limit part 1
  dw    0x0                     ; Base Address part 1
  db    0x0                     ; Base Address part 2
  db    10010010b               ; 1st Flags 1001, Type Flags 0010
  db    11001111b               ; 2nd Flags 1100, Segment Limit part 2 1111
  db    0x0                     ; Base Address part 3

; Mark the end of the GDT
GlobDescTblEnd:

;---------------------
; The GDT descriptor -
;---------------------

GlobDescTblDescriptor:
  dw    GlobDescTblEnd - GlobDescTblStart - 1 ; Size of the GDT
  dd    GlobDescTblStart                      ; Address of the GDT

;------------------------------------------------
; Handy Constants for Setting Segment Registers -
;------------------------------------------------

CODE_SEG equ GlobDescTblCode - GlobDescTblStart
DATA_SEG equ GlobDescTblData - GlobDescTblStart
