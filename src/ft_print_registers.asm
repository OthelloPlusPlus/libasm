%define ESC  0x1B

%define C_UNDERSCR	ESC, '[4m'
%define C_LAZURE	ESC, '[38;2;128;192;255m'
%define C_AZURE		ESC, '[38;2;0;128;255m'
%define C_LORANGE	ESC, '[38;2;255;192;128m'
%define C_RESET		ESC, '[0m'

section	.rodata
	string: db	C_LAZURE, 'rsi:%-11i ', 'rdx:%-11i rcx:%-11i r8:%-12i r9:%-12i',	0xa,\
				'rdi:%-11i ', C_AZURE, 'rax:%-11i ', C_LORANGE, 'rbx:%-11i ', C_LAZURE, 'r10:%-11i r11:%-11i',	0xa,\
				C_UNDERSCR, C_LORANGE, 'r12:%-11i r13:%-11i r14:%-11i r15:%-11i', C_RESET,	0xa,	0

section	.text

global	ft_print_registers
ft_print_registers:
	; ==========================================================================
	; Store all registers to the stack
	;	with the exception of the stack itself (RSP/RBP)
	; ==========================================================================
	push	rsi
	push	rdx
	push	rcx
	push	r8
	push	r9
	push	r15
	push	r14
	push	r13
	push	r12
	push	r11
	push	r10
	push	rbx
	push	rax
	push	rdi

	; ==========================================================================
	; Print all current register values
	;	RDI is treated as a stack variable so it is avaliable to pass the string
	; ==========================================================================
	lea	rdi,	[rel string]
	extern printf
	call printf wrt ..plt

	; ==========================================================================
	; Restore all registers and the stack
	; ==========================================================================
	pop	rdi
	pop	rax
	pop	rbx
	pop	r10
	pop	r11
	pop	r12
	pop	r13
	pop	r14
	pop	r15
	pop	r9
	pop	r8
	pop	rcx
	pop	rdx
	pop	rsi

	ret
