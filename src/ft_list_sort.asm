section	.text

; void	ft_list_sort(t_list **begin_list, int (*cmp)());
global ft_list_sort
ft_list_sort:
	; Input: RDI =	t_list**		pointer to the beginning of the list
	; Input: RSI =	int (*cmp)()	function which returns value to sort on

	; ==========================================================================
	; Check for NULL
	; ==========================================================================
	test	rdi,	rdi
	je	.Return
	test	rsi,	rsi
	je	.Return


	; ==========================================================================
	; Store crucial pointers to the stack
	;	Otherwise passed function may alter them
	; ==========================================================================
	push	rbp	; Puts base pointer on the stack
	mov	rbp,	rsp	; Saves current pointer of rsp (containing old rbp) to rbp

	push		rdi					; [rsp + 24]	Begin list
	mov			rdi,	[rdi]
	push		rdi					; [rsp + 16]	Current Node
	push qword	[rdi + 8]	; [rsp + 8]	Next Node
	push		rsi					; [rsp]	Function pointer


	; ==========================================================================
	; Loop through the list until NULL
	; ==========================================================================
.BigLoop:
	mov	rdi,	[rsp + 16]
	test	rdi,	rdi
	je	.ReturnStack
	; ==========================================================================
	; Loop through the list starting from BigLoop->next
	;	Compare BigLoop and SmallLoop's node's using passed function
	;	Swap node->data's if SmallLoop->data < BigLoop->data
	; ==========================================================================
.SmallLoop:
	mov	rsi,	[rsp + 8]	; RSI should be t_list *node
	test	rsi,	rsi
	je	.EndSmallLoop
	; Actual Compare
	mov	rdi,	[rsp + 16]	; RDI should be t_list *node
	call	[rsp]
	movsx rax, eax	; convert int into full compare
	cmp	rax, 0
	jl     .RepeatSmallLoop  ; skip swap if <= 0
	; Actual Swap
	mov	rdi,	[rsp + 16]	; RDI: t_list*
	mov	rdx,	[rdi]		; RDX: void *data
	mov	rsi,	[rsp + 8]	; RSI: t_list*
	mov	rcx,	[rsi]		; RCX: void *data
	mov	[rdi],	rcx			; RDI->data = RCX
	mov	[rsi],	rdx			; RSI->data = RDX
.RepeatSmallLoop:
	mov	rsi,	[rsp + 8]
	mov	rsi,	[rsi + 8]
	mov	[rsp + 8],	rsi
	jmp	.SmallLoop
.EndSmallLoop:
	mov	rdi,	[rsp + 16]
	mov rdi,	[rdi + 8]
	mov	[rsp + 16],	rdi
	mov	[rsp + 8],	rdi	; need to be next node, not current
	jmp	.BigLoop

	; ==========================================================================
	; Restore stack before returning
	; ==========================================================================
.ReturnStack:
	mov	rsp,	rbp	; Set RSP to locatio RBP was stored 
	pop	rbp	; Returns both RBP and RSP to original value

.Return:
	ret
