.386
EXTRN number: byte

PUBLIC FIND_POWER_2 

code SEGMENT use16 para PUBLIC 'code' 
assume CS:code, DS:data, SS:stack


FIND_POWER_2 proc near 

    mov DX, data
    mov DS, DX 

    mov AH, 09h
    mov DX, offset msg_input_pow
    int 21h 

    mov dx, 0
    OR dl, number[0]
    sal dx, 4
    OR dl, number[1]
    sal dx, 4
    OR dl, number[2]
    sal dx, 4
    OR dl, number[3]

    mov bx, 0
    mov ax, dx
    BSF bx, ax
    mov ax, 0
    mov dx, 0

    mov dl, bl

    mov al, dl
    mov bl, 10
    div bl
    mov dl, al
    add dl, 30h
    mov dh, ah
    add dh, 30h
    mov ah, 02h
    int 21h

    mov dl, dh
    mov ah, 02h
    int 21h

    mov ah, 02h
    mov dl, 13
    int 21h
    mov dl, 10
    int 21h
    
    ret 
FIND_POWER_2 endp 
code ends 
 
data SEGMENT use16 para PUBLIC 'data' 
    msg_input_pow db "Output power(in 16 s/s): ", '$'
data ends 

stack SEGMENT use16 para STACK 'stack' 
    db 200h DUP (?) 
stack ends 

END
