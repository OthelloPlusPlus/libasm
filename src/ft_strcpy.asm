section	.text

global ft_strcpy
ft_strcpy:
	; Input: RDI = (char *) dest
	; Input: RSI = (const char *) src
	; Return: RAX = pointer to dest

	; ==========================================================================
	; Validate input arguments, checking for NULL
	;	Added protection where strcpy() has undefined behavior
	; ==========================================================================
	xor	rax,	rax	; Set return value to NULL

	; Test for NULL arguments
	test	rdi,	rdi
	je	.Return
	test	rsi,	rsi
	je	.Return

	mov	rax,	rdi	; Set return value to dest (passed checks)

	; ==========================================================================
	; Copy bytes from RSI to RDI until 0 byte is found
	; ==========================================================================
.LoopCopy:
	mov	dl,	[rsi]	; Store 1 byte from RSI into DL (lower 8 bits from RDX)
	mov [rdi],	dl	; Store 1 byte from DL into RDI
	inc	rdi
	inc	rsi
	test	dl,	dl
	jne	.LoopCopy

.Return:
	ret
