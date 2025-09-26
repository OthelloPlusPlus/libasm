section	.rodata
	base10:	db	"1234567890", 0
	base10len:	equ $ - base10

section .data
charbuf:  db 0      ; 1-byte container
	NegativeMultiplier:	db	1

section	.text

extern	__errno_location

global	ft_atoi
ft_atoi:
	; Input: RDI =	const char	*nptr
	; Output: RAX =	int

	mov	rsi,	[rel base10]
	call	ft_atoi_base
	ret

global	ft_atoi_base
ft_atoi_base:
	; Input: RDI =	const char	*nptr
	; Input: RSI =	const char	*base
	; Output: RAX =	int
	
	; Local:	RDX = base length/counter
	; Local:	RCX = nptr counter
	; Local:	R8 = Byte for comparison
	; Local:	R9 = Byte for comparison
	; Local:	R10 = Base index
	; Local:	R11 = Negative flag

	; ==========================================================================
	; Check for NULL
	; ==========================================================================
	test	rdi,	rdi
	je	.ReturnInvalid
	test	rsi,	rsi
	je	.ReturnInvalid

	; ==========================================================================
	; Validate Base
	;	Check for duplicates
	;	Check for size of at least 2 characters
	; ==========================================================================
	xor	rdx,	rdx
.LoopBase1:
	movzx	r8,	byte [rsi + rdx]
	test	r8,	r8
	je	.CheckBaseSize
	mov	rcx,	rdx
.LoopBaseSmall:
	inc	rcx
	movzx	r9,	byte [rsi + rcx]
	test	r9,	r9
	je	.LoopBase2
	cmp	r8,	r9
	je	.ReturnInvalid
	jmp	.LoopBaseSmall
.LoopBase2:
	inc	rdx
	jmp	.LoopBase1
.CheckBaseSize:
	cmp	rdx,	2
	jl	.ReturnInvalid

	; ==========================================================================
	; Validate and Prepare alpha string
	;	Loop passed spaces
	;	Check for + and -
	; ==========================================================================
.PrepareAlpha:
	xor	rcx,	rcx
	dec	rcx
.LoopThroughSpace:
	inc	rcx
	movzx	r8,	byte [rdi + rcx]
	; call .CallPrintF
	cmp	r8,	' '
	je	.LoopThroughSpace
	cmp	r8,	0x9	; '\t' (horizontal tab)
	je	.LoopThroughSpace
	cmp	r8,	0xa	; '\n' (new line)
	je	.LoopThroughSpace
	cmp	r8,	0xb	; '\v' (vertical tab)
	je	.LoopThroughSpace
	cmp	r8,	0xc	; '\f' (form feed)
	je	.LoopThroughSpace
	cmp	r8,	0xd	; '\r' (carriage ret)
	je	.LoopThroughSpace
; .CheckForNegative:
	mov	r11,	1
	cmp	r8,	'-'
	jne	.SkipMakeRAXNegative
	neg	r11
.SkipMakeRAXNegative:
	dec	rcx
.LoopThroughPlusAndMinus:
	inc	rcx
	movzx	r8,	byte [rdi + rcx]
	cmp	r8,	'-'
	je	.LoopThroughPlusAndMinus
	cmp	r8,	'+'
	je	.LoopThroughPlusAndMinus

	; ==========================================================================
	; Loop through alpha converting characters and adding them to return value
	; ==========================================================================
.CalculateInteger:
	xor	rax,	rax
.LoopThroughAlpha:
	movzx	r8,	byte [rdi + rcx]
	test	r8,	r8
	je	.Return

	imul	eax,	edx
	jo	.ReturnOverflow
	call	.FindBaseIndex
	cmp	r10,	-1
	je	.ReturnInvalid
	imul	r10,	r11
	add	eax,	r10d
	jo	.ReturnOverflow

	inc	rcx
	jmp	.LoopThroughAlpha

; ==============================================================================
; Returns
;	Set errno if overflow
; ==============================================================================
%define EINVAL 22
%define ERANGE 34
%define INT_MAX	0x7FFFFFFF
%define INT_MIN	0x80000000
.ReturnInvalid:
	call	__errno_location wrt ..plt
	mov	dword [rax], EINVAL
	jmp	.ReturnError

.ReturnOverflow:
	call	__errno_location wrt ..plt
	mov	dword [rax], ERANGE
	cmp	r11,	-1
	je	.ReturnUnderflow
	mov rax,  INT_MAX
	ret
.ReturnUnderflow:
	mov rax,  INT_MIN
	ret

.ReturnError:
	xor	rax,	rax

.Return:
	ret

; ==========================================================================
; Find index for matching base character
;	helper function
; ==========================================================================
.FindBaseIndex:
	xor	r10,	r10
.LoopThroughBase:
	movzx	r9,	byte [rsi + r10]
	test	r9,	r9
	je	.ReturnBaseFalse
	cmp	r8,	r9
	je	.ReturnBaseIndex
	inc	r10
	jmp	.LoopThroughBase
.ReturnBaseFalse:
	mov	r10,	-1
.ReturnBaseIndex:
	ret
