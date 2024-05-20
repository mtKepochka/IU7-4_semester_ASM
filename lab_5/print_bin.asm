.386
EXTRN number: byte

PUBLIC UNSIGNED_2 

code SEGMENT use16 para PUBLIC 'code' 
assume CS:code, DS:data, SS:stack


print_bin_digit proc near
    
    ; al -> digit
    ;mov di, 3

    ;print_dig_loop:

    ;    dec di
    ;    cmp di, -1
    ;jne print_dig_loop
    cmp dl, 0
    jne make_num
    back_make:
        cmp dl, 0
    ret
    make_num:
        push ax
        mov ax, 0
        mov al, dl
        div al
        mov dl, al
        pop ax
        jmp back_make
print_bin_digit endp


UNSIGNED_2 proc near 

    mov DX, data
    mov DS, DX 

    mov AH, 09h
    mov DX, offset msg_input_bin 
    int 21h 
 
    mov bl, 8
    mov ah, 02h
    mov dl, number[0]
    and dl, bl
    call print_bin_digit
    add dl, 30h
    int 21h
    mov ah, 0
    mov al, bl
    mov dx, 2
    div dl
    mov bl, al

    mov cx, 3
    print_bin:
        mov ah, 02h
        mov dl, number[0]
        and dl, bl
        call print_bin_digit
        add dl, 30h
        int 21h
        mov ah, 0
        mov al, bl
        mov dx, 2
        div dl
        mov bl, al
        loop print_bin

    mov bl, 8
    mov ah, 02h
    mov dl, number[1]
    and dl, bl
    call print_bin_digit
    add dl, 30h
    int 21h
    mov ah, 0
    mov al, bl
    mov dx, 2
    div dl
    mov bl, al

    mov cx, 3
    print_bin_2:
        mov ah, 02h
        mov dl, number[1]
        and dl, bl
        call print_bin_digit
        add dl, 30h
        int 21h
        mov ah, 0
        mov al, bl
        mov dx, 2
        div dl
        mov bl, al
        loop print_bin_2

    mov bl, 8
    mov ah, 02h
    mov dl, number[2]
    and dl, bl
    call print_bin_digit
    add dl, 30h
    int 21h
    mov ah, 0
    mov al, bl
    mov dx, 2
    div dl
    mov bl, al

    mov cx, 3
    print_bin_3:
        mov ah, 02h
        mov dl, number[2]
        and dl, bl
        call print_bin_digit
        add dl, 30h
        int 21h
        mov ah, 0
        mov al, bl
        mov dx, 2
        div dl
        mov bl, al
        loop print_bin_3
    
    mov bl, 8
    mov ah, 02h
    mov dl, number[3]
    and dl, bl
    call print_bin_digit
    add dl, 30h
    int 21h
    mov ah, 0
    mov al, bl
    mov dx, 2
    div dl
    mov bl, al

    mov cx, 3
    print_bin_4:
        mov ah, 02h
        mov dl, number[3]
        and dl, bl
        call print_bin_digit
        add dl, 30h
        int 21h
        mov ah, 0
        mov al, bl
        mov dx, 2
        div dl
        mov bl, al
        loop print_bin_4

    mov ah, 02h
    mov dl, 13
    int 21h
    mov dl, 10
    int 21h

    ret 
UNSIGNED_2 endp 
code ends 
 
data SEGMENT use16 para PUBLIC 'data' 
    msg_input_bin db "Output number (unsigned at 2 s/s): ", '$'
    ;dig_buf db 4 dup(0), '$'
data ends 

stack SEGMENT use16 para STACK 'stack' 
    db 200h DUP (?) 
stack ends 

END
