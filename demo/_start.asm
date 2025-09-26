section	.text

global _start
_start:
	; Adding LibC manually to avoid gcc but still have functions as printf
	mov rdi, rsp
	lea rsi, [rsp+8]
	xor rdx, rdx
	extern	main
	mov rcx, main
	xor r8, r8
	xor r9, r9
	extern __libc_start_main
	call __libc_start_main
