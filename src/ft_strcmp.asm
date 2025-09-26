section	.text

global ft_strcmp
ft_strcmp:
	; Input: RDI = (const char *) s1
	; Input: RSI = (const char *) s2
	; Return: RAX = ASCII difference, or INT64_MIN if NULL is passed

	; ==========================================================================
	; Argument Validation
	; ==========================================================================
	cmp	rdi,	rsi
	je	.ReturnIdenticalPointers
	test	rdi,	rdi
	je	.ReturnError
	test	rsi,	rsi
	je	.ReturnError

	; ==========================================================================
	; Loop through RDI and RSI until bytes differ or end of string
	; ==========================================================================
.LoopCompare:
	mov	al, [rdi]
	cmp al, [rsi]
	jne	.ReturnDifference
	test al, al
	je	.ReturnDifference
	inc	rdi
	inc	rsi
	jmp	.LoopCompare

	; ==========================================================================
	; Return
	;	Difference:			s1[i] - s2[i]
	;	Identical Pointers:	0
	;	Error: 				INT64_MIN (instead of the typical -1, which is a valid return value in strcmp)
	; ==========================================================================
.ReturnDifference:
	movsx	rax,	al	; Extend AL into RAX
	movsx	rdx,	byte[rsi]	; Extract and extend RSI into RDX
	sub	rax,	rdx
	ret

.ReturnIdenticalPointers:
	xor	rax,	rax
	ret

.ReturnError:
	mov rax, 0x8000000000000000
	ret
