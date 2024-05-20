bits 64

section .text
global __asm__strncpy
__asm__strncpy:
    ; rdi - char *dst
	; rsi - char *src
	; rdx - int len
    inc rdx
	cmp rdi, rsi
	jl less_condition

great_condition:
	mov rcx, 0
	
	add rsi, rdx
	add rdi, rdx

	inc rdx
	mov rcx, rdx
	std
	rep movsb

	jmp exit

less_condition:
	mov rcx, 0
	mov rcx, rdx
    rep movsb

exit:
	ret