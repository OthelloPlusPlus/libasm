section	.text

extern	free

;void	ft_list_remove_if(t_list **begin_list, void *data_ref, int (*cmp)());
global ft_list_remove_if
ft_list_remove_if:
	; Input: RDI = t_list **lst
	; Input: RSI = void *data_ref
	; Input: RDX = int (*cmp)()		function pointer

	; ==========================================================================
	; Check for NULL
	; ==========================================================================
	test	rdi,	rdi
	je	.Return
	test	rsi,	rsi
	je	.Return
	test	rdx,	rdx
	je	.Return

	; ==========================================================================
	; Set pointers to stack.
	;	Protects against losing pointers when passed function is called
	; ==========================================================================
.SetStack:
	push	rbp
	mov	rbp,	rsp

	sub	rsp,	8	; keep stack aligned to %16
	push		rdi	; [rsp + 32]	begin list
	push		0	; [rsp + 24]	prev node
	push qword	[rdi]	; [rsp + 16]	current node
	push		rsi	; [rsp + 8]		Compare void* data
	push		rdx	; [rsp]			remove_check(t_list *list, void *data)

	; ==========================================================================
	; Loop through the list and call passed function
	;	Remove a node if function does not return 0
	; ==========================================================================
.LoopList:
	mov	rdi,	[rsp + 16]
	test	rdi,	rdi
	je	.ReturnStack

	mov	rsi,	[rsp + 8]
	call	[rsp]
	test	rax,	rax
	jne	.RemoveNodeFromList

	mov	rdi,	[rsp + 16]
	mov	[rsp + 24],	rdi
	mov	rdi,	[rdi + 8]
	mov	[rsp + 16],	rdi
	jmp	.LoopList

	; ==========================================================================
	; Remove a node
	;	Jumps are dependent on whether there is a previous node
	; ==========================================================================
.RemoveNodeFromList:
	mov	rdi,	[rsp + 16]
.RemoveData:
	mov	rdi,	[rdi + 16]
	test	rdi,	rdi
	je	.ExtractCurrentNode
	call	free wrt ..plt	; free(node->next);
.ExtractCurrentNode:
	mov	rsi,	[rsp + 24]	; prev
	test	rsi,	rsi
	je	.SetNewFirstNode
	mov	rdi,	[rsp + 16]	; current
	mov	rdx,	[rdi + 8]	; current->next
	mov	[rsi + 8],	rdx	; prev->next = current->next
	mov	[rsp + 16],	rdx	; current = current->next
	jmp	.FreeNode
.SetNewFirstNode:
	mov	rdi,	[rsp + 16]
	mov	rsi,	[rsp + 32]
	mov	rdx,	[rdi + 8]
	mov	[rsi],	rdx	; *first = node->next
	mov	[rsp + 16],	rdx	; Current = node->next
.FreeNode:
	call	free wrt ..plt ; free(node);
	jmp .LoopList

	; ==========================================================================
	; Restore stack before returning
	; ==========================================================================
.ReturnStack:
	mov	rsp,	rbp
	pop	rbp

.Return:
	ret
