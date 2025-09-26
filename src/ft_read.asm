section	.text

global ft_read
ft_read:
	; Input: RDI = (unsigned int) File Descriptor
	; Input: RSI = (const char *) Pointer to buffer
	; Input: RDX = (size_t) Length
	; Return: RAX = number of bytes read, or -1 on error

	; ==========================================================================
	; Syscall to read
	;	RDI, RSI, and RDX are already propperly set by function call
	; ==========================================================================
	mov	rax,	0
	syscall

	; ==========================================================================
	; Checking error
	; ==========================================================================
	cmp	rax, 0
	jge	.Return

	; Store value of RAX
	mov	r9,	rax
	neg	r9

	extern	__errno_location			; Retrieve address of errno
	call	__errno_location wrt ..plt	; call errno with dynamic location (Procedure Linkage Table)
	mov	[rax], r9						; Set errno

	mov	rax,	-1	; Set return value to error

.Return:
	ret
