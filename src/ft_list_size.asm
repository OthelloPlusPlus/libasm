section	.text

global ft_list_size
ft_list_size:
	; Input: RDI = t_list *
	;			[RDI + 0] = void *data
	;			[RDI + 8] = struct s_list *next;
	; Return: RAX = List size

	xor	rax,	rax

	; ==========================================================================
	; Loop through list and inc return value
	; ==========================================================================
.CheckLoop:
	test	rdi, rdi
	je	.Return	; If current node is null
	inc	rax
	mov	rdi,	[rdi + 8]	; Move to next node
	jmp	.CheckLoop

.Return:
	ret
