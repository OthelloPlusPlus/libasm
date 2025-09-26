section	.text
global	main
main:
	extern	DemonstrateCallingConvention
	call	DemonstrateCallingConvention

	jmp .exit

.exit:
	mov	rdi,	0	; set return value
	mov	rax,	60
	syscall
