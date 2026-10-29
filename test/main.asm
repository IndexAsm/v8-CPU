; load a value from data memory, add 3, halt
start:  
        mov ds, hi(value)     ; DS = 2  (0x28 >> 4)
        mov ss, 0xf

        mov bp, 0xf
        mov sp, 0x3
        sub sp, 0x2

        

        mov a, 2
        mov b, 2
        cmpab
        jne index1;
        je index2

        halt
        

org 0x60
index1:
        mov a, 0xf
        halt
index2:
        mov b, 0xf
        halt


org 0xa0
value:  db 9
