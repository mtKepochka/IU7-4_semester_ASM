.386
EXTRN number: byte

PUBLIC TRUNCATED_8 

code SEGMENT use16 para PUBLIC 'code' 
assume CS:code, DS:data, SS:stack

TRUNCATED_8 proc near 

    mov DX, data
    mov DS, DX 

    mov AH, 09h
    mov DX, offset msg_input_trunc 
    int 21h 

    mov dx, 0
    OR dl, number[2]
    sal dx, 4
    OR dl, number[3]

    sal dx, 9
    jb print_
back_tr:
    shr dx, 9

    and dl, 11000000b
    shr dx, 6

    mov ah, 02h
    add dl, 30h
    int 21h

    mov dx, 0
    OR dl, number[2]
    sal dx, 4
    OR dl, number[3]
    and dl, 01111111b

    and dl, 00111000b
    shr dx, 3
    mov ah, 02h
    add dl, 30h
    int 21h

    mov dx, 0
    OR dl, number[2]
    sal dx, 4
    OR dl, number[3]
    and dl, 01111111b

    and dl, 00000111b
    mov ah, 02h
    add dl, 30h
    int 21h

    mov ah, 02h
    mov dl, 13
    int 21h
    mov dl, 10
    int 21h

    ret 
    print_:
        mov ah, 02h
        mov dl, '-'
        int 21h
        jmp back_tr
TRUNCATED_8 endp 
code ends 
 
data SEGMENT use16 para PUBLIC 'data' 
    msg_input_trunc db "Output number (signed at 8 s/s): ", '$'
data ends 

stack SEGMENT use16 para STACK 'stack' 
    db 200h DUP (?) 
stack ends 

END
