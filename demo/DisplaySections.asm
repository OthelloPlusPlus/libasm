; ==============================================================================
; Sizes (NASM directives vs typical C types on x86-64)
; ==============================================================================
; Directive		Size		Typical C type
; ------------------------------------------------------------------------------
; [...]b		1 Byte		char	int8_t		bool (no seperate bits)
; [...]w		2 Bytes		short	int16_t
; [...]d		4 Bytes		int		int32_t		float
; [...]q		8 Bytes		long 	int64_t		double		void*
; ==============================================================================


; ==============================================================================
; section .rodata
;	Read Only Data
;		Constant data and string literals
;
;	void function()
;	{
;		const int	i = 0;
;		const int	table[] = { 1, 2, 3, 4 };
;		printf("literal string");
;	}
; ==============================================================================
section	.rodata
	i:		dd	0
	table:	dd	1, 2, 3, 4
	str0:	db	"literal string", 0
	strlen:	equ $ - str0

; ==============================================================================
; section .data
;	Data
;		Initialized Read/Write Data
;
;	int x = 0;
;	void function()
;	{
;		int		y = 1;
;		char	array[4] = "abc\0"
;		char	emptyarr[5] = { 0 };
;	}
; ==============================================================================
section	.data
	global x
	x:			dd	0
	y:			dd	1
	array:		db	'a', 'b', 'c', 0
	emptyarr:	times 5 db 0

; ==============================================================================
; section .bss
;	Block Started by Symbol
;		Uninitialized Read/Write Data
;
;	void function()
;	{
;		int		z;
;		char	buffer[4097];
;		void 	*ptr;
;	}
; ==============================================================================
section	.bss
	z:		resd	1
	buffer:	resb	4097
	ptr:	resq	1

; ==============================================================================
; section .text
;	text
;		Executable instructions (i.e. functions)
;
; ==============================================================================
section	.text

; Entrypoint to start running instructions
;	Pure asm:	use this
;	using libC:	libC provides this, skip and use main: in stead
global _start
_start:
	call	main

; Function libC looks for to call once its done with _start:
;	Pure asm:	skip and use _start:
;	using libC:	use this
global main
main:
	call	CallFunction
	enter	EnterFunction

.CallFunction:
	push	rdi	; Allocate 8 bytes on the stack and populate them with RDI
	push	rsi	; Allocate 8 bytes on the stack and populate them with RSI
	push	rdx	; Allocate 8 bytes on the stack and populate them with RDX
	pop		rdi	; Stores top of stack to RDI (RDX => stack => RDI), then unallocates 8 bytes from the stack
	sub		rsp,	16	; Unallocates 16 bytes form the stack
	ret

EnterFunction:
	enter	16,	0	; Allocates 16 bytes on the stack
	leave			; Restores stack
	ret
