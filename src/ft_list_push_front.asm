section	.text

global ft_list_push_front
ft_list_push_front:
	; Input: RDI = t_list **lst
	; Input: RSI = t_list *new
	;			[RSI + 0] = void *data
	;			[RSI + 8] = struct s_list *next;

	; ==========================================================================
	; Check for NULL
	; ==========================================================================
	test	rdi,	rdi
	je	.Return
	test	rsi,	rsi
	je	.Return

	; ==========================================================================
	; Add to front and adjust first address
	; ==========================================================================
	mov	rdx,	[rdi]
	mov	[rsi + 8],	rdx
	mov	[rdi],	rsi

.Return:
	ret
