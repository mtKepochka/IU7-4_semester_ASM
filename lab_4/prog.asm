;Задание МЗЯП: 
;Прямоугольная цифровая матрица
;Заменить значения в чётных строках последними
;цифрами суммы соответствующих элементов
;предыдущей и следующей строки.
;1 2 3
;4 5 6
;7 8 9
;
;1 2 3
;8 0 2
;7 8 9
STK SEGMENT PARA STACK 'STACK'
	db 200 dup(0)
STK ENDS

DSEG SEGMENT PARA 'DATA'
        MATRIX db 81 dup(0)
        SIZEH db 1
        SIZEW db 1
        CUREL dw 0h
        CURAX dw 0h
DSEG ENDS

DSEG2 SEGMENT PARA 'DATA'
        IntroWMSG     DB 13  
                     DB 'Input width: '                 
                     DB '$'                    
DSEG2 ENDS

DSEG3 SEGMENT PARA 'DATA'
        IntroHMSG     DB 13  
                     DB 'Input height: '              
                     DB '$'                     
DSEG3 ENDS

DSEG4 SEGMENT PARA 'DATA'
        OutputMSG     DB 13 
                     DB 'OUTPUT MATRIX: '           
                     DB '$'                   
DSEG4 ENDS

DSEG5 SEGMENT PARA 'DATA'
        InputMSG     DB 13 
                     DB 'INPUT MATRIX: '                
                     DB '$'                    
DSEG5 ENDS

CSEG SEGMENT PARA PUBLIC 'CODE'
	assume CS:CSEG, DS:DSEG, SS:STK
exit:
    mov ah, 4ch
    int 21h

main:
    mov ax, DSEG2
    mov ds, ax
    mov dx, OFFSET IntroWMSG
    mov ah, 09h
    int 21h

    mov ax, DSEG
    mov ds, ax
    mov ah, 01h
    int 21h

    mov SIZEW, al
    sub SIZEW, 30h

    mov ah, 2
	mov dl, 10
	int 21h

    mov ax, DSEG3
    mov ds, ax
    mov dx, OFFSET IntroHMSG
    mov ah, 09h
    int 21h

    mov ax, DSEG
    mov ds, ax
    mov ah, 01h
    int 21h

    mov SIZEH, al
    sub SIZEH, 30h


    mov ax, 1
    mul SIZEH
    mov cx, ax
    mov dx, 0
    
    clean:
        PUSH cx
        mov ch, 0
        mov cl, SIZEW
        clean1:
            mov ax, 0
            mov CUREL, dx
            mov CURAX, ax
            mov dx, [CUREL]
            mov ax, [CURAX]
            lea bx, MATRIX
            add bx, dx
            mov ah, 0
            mov BYTE PTR [bx], 0
            inc dx
            loop clean1
        POP cx
        loop clean

    mov ah, 2
	mov dl, 10
	int 21h
    mov dl, 13
    int 21h

    mov ax, DSEG5
    mov ds, ax
    mov dx, OFFSET InputMSG
    mov ah, 09h
    int 21h
    mov ah, 2
    mov dl, 10
    int 21h
    mov dl, 13
    int 21h

    mov ax, DSEG
    mov ds, ax

    mov ax, 1
    mul SIZEH
    mov cx, ax
    mov dx, 0

    read:
        PUSH cx
        mov ch, 0
        mov cl, SIZEW
        read1:

            mov ax, 0
            mov ah, 01h
            int 21h
            mov CUREL, dx
            mov CURAX, ax
            mov ah, 2
            mov dl, 20h
            int 21h
            mov dx, [CUREL]

            lea bx, MATRIX
            PUSH dx
            mov ax, dx
            mov dx, 9
            mul dx
            POP dx

            add bx, ax

            mov ah, 0
            mov al, SIZEW
            sub al, cl
            add bx, ax
            ;bx+(SIZEW - cl)


            mov ax, [CURAX]
            mov ah, 0
            mov BYTE PTR [bx], al
            sub BYTE PTR [bx], 30h
            
            loop read1
        PUSH dx
        mov ah, 2
        mov dl, 10
        int 21h
        mov dl, 13
        int 21h
        POP dx
        POP cx
        inc dx
        loop read

    mov ax, 1
    mul SIZEH
    mov dx, 2h
    div dl
    mov ah, 0
    mov cx, ax
    mov dx, 1
    mov bx, 0
    CMP cx, 0

    je exit

    calc:
        PUSH cx
        mov ch, 0
        mov cl, SIZEW
        mov bx, 0
        calc1:
            mov CUREL, dx
            mov ax, dx
            PUSH dx
            mov dx, 9
            mul dx
            POP dx
            add ax, bx
            mov dx, ax
            lea ax, MATRIX
            add ax, dx

            mov CURAX, bx

            mov bx, ax

            mov dx, 0
            sub al, 9
            PUSH bx
            mov bx, ax
            add dx, WORD PTR [bx]
            POP bx
            mov ax, bx
            add al, 9
            PUSH bx
            mov bx, ax
            add dx, WORD PTR [bx]
            POP bx

            mov ax, 0
            mov al, dl
            mov dl, 10
            div dl
            mov BYTE PTR [bx], ah
            mov dx, [CUREL]
            mov bx, [CURAX]
            inc bx
            loop calc1
        POP cx
        add dx, 2
        loop calc

    mov ax, DSEG4
    mov ds, ax
    mov dx, OFFSET OutputMSG
    mov ah, 09h
    int 21h
    mov ah, 2
    mov dl, 10
    int 21h
    mov dl, 13
    int 21h

    mov ax, DSEG
    mov ds, ax

    mov ax, 1
    mul SIZEH
    mov ah, 0
    mov cx, ax
    mov dx, 0
    mov bx, 0

    write:
        PUSH cx
        mov ch, 0
        mov cl, SIZEW
        mov bx, 0
        write1:
            mov CUREL, dx
            mov ax, dx
            PUSH dx
            mov dx, 9
            mul dx
            POP dx
            add ax, bx
            mov dx, ax
            lea ax, MATRIX
            add ax, dx

            mov CURAX, bx
            
            mov bx, ax
            mov ax, 0
            mov ah, 2
            mov dx, 0
            mov dl, byte ptr [bx]
            add dl, 30h
            int 21h
            mov dl, 20h
            int 21h
            mov dx, [CUREL]
            mov bx, [CURAX]
            inc bx
            loop write1
        PUSH dx
        mov dl, 10
        int 21h
        mov dl, 13
        int 21h
        POP dx
        POP cx
        inc dx
        loop write

    mov ah, 4ch
    int 21h

CSEG ENDS

END main