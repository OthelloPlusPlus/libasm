section	.data
	string1	db	"arg00", 0
	string2	db	"arg01", 0
	string3	db	"arg02", 0
	string4	db	"arg03", 0
	string5	db	"arg04", 0
	string6	db	"arg05", 0
	string7	db	"arg06", 0
	string8	db	"arg07", 0
	string9	db	"arg08", 0

section .bss
	returnval	resq	1

section	.text

global	DemonstrateCallingConvention
DemonstrateCallingConvention:
	mov	rdi,	string1
	mov	rsi,	string2
	mov	rdx,	string3
	mov	rcx,	string4
	mov	r8,	string5
	mov	r9,	string6
	sub	rsp,	8	; Lower addess by 8 bytes if odd amount of stack arguments
		push string9
		push string8
		push string7
	extern print_calling_convention
	call print_calling_convention
	add	rsp,	32 ; Raise address by 8 bytes per stack argument, and another 8 if odd amount of arguments

	; Write return value
	mov	[returnval],	rax
	mov	rax,	1
	mov	rdi,	1
	lea	rsi,	[returnval]
	mov	rdx,	1
	syscall

	ret
