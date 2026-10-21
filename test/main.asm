; load a value from data memory, add 3, halt
start:  
        mov ds, hi(value)     ; DS = 2  (0x28 >> 4)
        mov ss, 0xf

        mov bp, 0xf
        mov sp, 0x3
        sub sp, 0x2

        mov a, 2
        mov [bp - 1], a
        mov b, [bp - 1]
        mov a, [value]        ; A = mem[DS*16 + 8]
        add a, b
        halt

org 0x28
value:  db 9
