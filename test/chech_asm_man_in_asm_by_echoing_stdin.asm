section .rodata
	; instruction: "Please type into stdin:\n" (not a variable)
	intro		db	"Please type into stdin ('exit' or ctrl+D to end):", 0xa, 0
	introLen	equ $ - intro

	outro		db	"Done reading from stdin.", 0xa, 0
	outroLen	equ $ - outro

	exitString	db	"exit", 0xa, 0

section	.bss
	; char str[4097]
	buffer	resb	4097

section .text

global chech_asm_man_in_asm_by_echoing_stdin
chech_asm_man_in_asm_by_echoing_stdin:

	sub	rsp, 8
	push	rbx	; making RBX avaliable for later usage

	call .WriteIntro

.ReadLoop:
	lea	rbx,	[rel buffer]

	extern	ft_read
	mov	rdi,	0
	mov	rsi,	rbx
	mov	rdx,	4096
	call	ft_read
	test	rax,	rax
	jng	.Return	; if RAX <= 0
	mov byte	[rbx + rax],	0

	extern ft_strcmp
	lea	rdi,	[rel exitString]
	mov	rsi,	rbx
	call ft_strcmp
	je	.Return

	extern	ft_strdup
	mov	rdi,	rbx
	call	ft_strdup
	test	rax,	rax
	je	.Return	; If RAX == 0
	mov	rbx,	rax

	extern	ft_strlen
	mov	rdi,	rbx
	call	ft_strlen

	; extern	ft_write
	mov	rdi,	1
	mov	rsi,	rbx
	mov	rdx,	rax
	call	ft_write
	push	rax	; Store rax on stack for check later to ensure free

	extern	free
	mov	rdi,	rbx
	call	free wrt ..plt

	pop	rax
	test	rax,	rax
	jng	.Return	; If RAX (write) <= 0

	jmp	.ReadLoop

.Return:
	add	rsp,	8
	pop rbx ; Restore RBX
	call .WriteOutro
	ret

.WriteIntro:
	extern	ft_write
	mov	rdi,	1
	lea	rsi,	[rel intro]
	mov	rdx,	introLen
	call	ft_write
	ret

.WriteOutro:
	mov	rdi,	1
	lea	rsi,	[rel outro]
	mov	rdx,	outroLen
	call	ft_write
	ret
