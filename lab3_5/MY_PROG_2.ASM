PUBLIC output_HelloMessage
EXTRN X: byte

CSEG2 SEGMENT PARA PUBLIC 'CODE'
	assume CS:CSEG2
output_HelloMessage proc far
	
    mov ax, seg X
	mov es, ax
	mov bh, es:X

    mov ah, 01h
    int 21h

    xchg ah, al
	xchg ah, es:X
	xchg ah, al

    mov ah, 2
	mov dl, 13
	int 21h
	mov dl, 10
	int 21h

	retf
output_HelloMessage endp
CSEG2 ENDS
END