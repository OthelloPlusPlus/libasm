extern ft_strlen
extern malloc
extern ft_strcpy

section .text

global ft_strdup
ft_strdup:
	; Input: RDI = (char *) pointer to source string
	; Return: RAX = pointer to duplicated string

	; ==========================================================================
	; Store RDI on the stack (RSP)
	;	Always asume other function calls change Scratch Registers
	; ==========================================================================
	push	rdi

	; ==========================================================================
	; Call ft_strlen to find string length
	; ==========================================================================
	call	ft_strlen

	; ==========================================================================
	; Call malloc to allocate memory
	; ==========================================================================
	mov	rdi, rax
	inc	rdi	; malloc for size + 1
	call	malloc wrt ..plt	; call errno with dynamic location (Procedure Linkage Table)
	pop	rsi ; Remove RDI from stack before error check and store it in RSI for ft_strcpy call
	test	rax, rax
	jz	.Error

	; ==========================================================================
	; Call ft_strcpy to copy bytes from src to duplicated string
	; ==========================================================================
	mov	rdi,	rax
	call	ft_strcpy
	ret

.Error:
	xor	rax,	rax
	ret
