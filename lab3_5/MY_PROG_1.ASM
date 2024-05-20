;МЗЯП:
;Написать программу из двух модулей. Точку входа разместить в первом, 
;затем передать управление с помощью дальнего перехода во второй, 
;где ввести символ в строку, объявленную в первом модуле, и вернуть туда управление. 
;В первом вывести 4-й символ введённой строки.
PUBLIC X
EXTRN output_HelloMessage: far

STK SEGMENT PARA STACK 'STACK'
	db 200 dup(0)
STK ENDS

DSEG SEGMENT WORD 'DATA'
        HelloMessage DB 13                      ;курсор поместить в нач. строки
                     DB 10                      ;перевести курсор на нов. строку
                     DB 'ABC F'                  ;текст сообщения
                     DB '$'                     ;ограничитель для функции DOS
        org 05h
        X db 0
DSEG ENDS

DSEG2 SEGMENT WORD 'DATA'
        IntroMSG     DB 13  ;курсор поместить в нач. строки
                     DB 'Input char: '                  ;текст сообщения
                     DB '$'                     ;ограничитель для функции DOS
DSEG2 ENDS

DSEG3 SEGMENT WORD 'DATA'
        OutroMSG     DB 13  ;курсор поместить в нач. строки
                     DB 'Inputed char: '                  ;текст сообщения
                     DB '$'                     ;ограничитель для функции DOS
DSEG3 ENDS

DSEG4 SEGMENT WORD 'DATA'
        StringMSG     DB 13  ;курсор поместить в нач. строки
                     DB 'Changed string: '                  ;текст сообщения
                     DB '$'                     ;ограничитель для функции DOS
DSEG4 ENDS

CSEG SEGMENT PARA PUBLIC 'CODE'
	assume CS:CSEG, DS:DSEG, SS:STK
main:
    mov ax, DSEG2
    mov ds, ax
    mov dx, OFFSET IntroMSG
    mov ah, 09h
    int 21h


	call output_HelloMessage

    mov ax, DSEG3
    mov ds, ax
    mov dx, OFFSET OutroMSG
    mov ah, 09h
    int 21h

    mov ax, DSEG
    mov ds, ax
    mov dl, X

    mov ah, 2
	int 21h
	mov dl, 13
	int 21h
	mov dl, 10
	int 21h

    mov ax, DSEG4
    mov ds, ax
    mov dx, OFFSET StringMSG
    mov ah, 09h
    int 21h
    
    mov ax, DSEG
    mov ds, ax
    mov dx, OFFSET HelloMessage
    mov ah, 09h
    int 21h

	mov ax, 4c00h
	int 21h
CSEG ENDS

END main