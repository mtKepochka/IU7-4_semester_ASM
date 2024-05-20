;ввод 16-разрядного числа;(беззнаковое в 16 c/c)
;вывод его в знаковом либо беззнаковом представлении 
;в системе счисления по варианту(беззнаковое в 2 с/с)
;вывести усечённое до 8 разрядов значение 
;(аналогично приведению типа int к char в языке C)
;в знаковом либо беззнаковом представлении
;в системе счисления по варианту(знаковое в 8 с/с)
;задание на применение команд побитовой обработки: 
;степень двойки, которой кратно введённое число

;Взаимодействие с пользователем должно строиться на 
;основе меню. Программа должна содержать не менее 
;пяти модулей. Главный модуль должен обеспечивать 
;вывод меню, а также содержать массив указателей 
;на подпрограммы, выполняющие действия, 
;соответствующие пунктам меню. Обработчики 
;действий должны быть оформлены в виде подпрограмм, 
;находящихся каждая в отдельном модуле. Вызов 
;необходимой функции требуется осуществлять 
;с помощью адресации по массиву индексом выбранного 
;пункта меню.

.386 

EXTRN INPUT: near
EXTRN UNSIGNED_2: near
EXTRN FIND_POWER_2: near
EXTRN TRUNCATED_8: near

code SEGMENT use16 para PUBLIC 'code' 
assume CS:code, DS:data, SS:stack 
START: 
    mov DX, data 
    mov DS, DX 

    mov array_pointers[0], INPUT
    mov array_pointers[2], UNSIGNED_2
    mov array_pointers[4], TRUNCATED_8
    mov array_pointers[6], FIND_POWER_2
    mov array_pointers[8], QUIT

    MENU: 
        mov AH, 09h
        mov DX, offset menu_text 
        int 21h 

        mov AH, 01h 
        int 21h 

        sub AL, 30h
        sub AL, 1h
        mov dl, 2h
        mul dl

        mov bx, 0
        mov bl, al
        mov ah, 02h
        mov dl, 10
        int 21h
        mov dl, 13
        int 21h
        call array_pointers[bx]
        jmp MENU
    QUIT: 
        mov AX, 4c00h 
        int 21h
code ends 

data SEGMENT use16 para PUBLIC 'data' 
    menu_text db "1 - input of a 16-bit number (unsigned at 16 s/s)", 0Dh, 0Ah, 
            "2 - output an unsigned number (at 2 s/s)", 0Dh, 0Ah, 
            "3 - output value truncated to 8-bit number (signed at 8 s/s)", 0Dh, 0Ah, 
            "4 - find the power of 2 that is a multiple of the number", 0Dh, 0Ah, 
            "5 - quit", 0Dh, 0Ah, '$'
    array_pointers dw 5 dup(0)
data ends 

stack SEGMENT use16 para STACK 'stack' 
    db 200h DUP (?) 
stack ends 

END START
