.386
PUBLIC INPUT 
PUBLIC number

code SEGMENT use16 para PUBLIC 'code' 
assume CS:code, DS:data
INPUT proc near 

    mov DX, data
    mov DS, DX 

    mov AH, 09h
    mov DX, offset msg_input 
    int 21h 
 
    mov AH, 01h
    int 21h 
    mov number[0], al
    cmp number[0], 'A'
    je sub_37h_0
    jg sub_37h_0
    jmp sub_30h_0
back_0:
    int 21h 
    mov number[1], al
    cmp number[1], 'A'
    je sub_37h_1
    jg sub_37h_1
    jmp sub_30h_1
back_1:
    mov AH, 01h
    int 21h 
    mov number[2], al
    cmp number[2], 'A'
    je sub_37h_2
    jg sub_37h_2
    jmp sub_30h_2
back_2:
    int 21h 
    mov number[3], al
    cmp number[3], 'A'
    je sub_37h_3
    jg sub_37h_3
    jmp sub_30h_3
back_3:
    mov ah, 02h
    mov dl, 13
    int 21h
    mov dl, 10
    int 21h
    ret 
    sub_37h_0:
        sub number[0], 37h
        jmp back_0
    sub_30h_0:
        sub number[0], 30h
        jmp back_0
    sub_37h_1:
        sub number[1], 37h
        jmp back_1
    sub_30h_1:
        sub number[1], 30h
        jmp back_1
    sub_37h_2:
        sub number[2], 37h
        jmp back_2
    sub_30h_2:
        sub number[2], 30h
        jmp back_2
    sub_37h_3:
        sub number[3], 37h
        jmp back_3
    sub_30h_3:
        sub number[3], 30h
        jmp back_3
INPUT endp 
code ends 
 
data SEGMENT use16 para PUBLIC 'data' 
    msg_input db "Input number (unsigned at 16 s/s): ", '$' 
    number db 4 DUP(0) 
data ends 
  
END
