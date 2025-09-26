section .rodata
	ThreeBitMask dq	0b111
	LowMask dq	0x0101010101010101
	HighMask dq	0x8080808080808080

section	.text

global ft_strlen
ft_strlen:
	; Input: RDI = (const char *) Pointer to string
	; Return: RAX = Number of bytes in string

	xor	rax,	rax; 0
	push	rbx
	push	rcx

	; ==========================================================================
	; Optimized version - Byte allignment
	;	Check for 0-terminator byte untill address is alligned to 8byte-count
	; ==========================================================================
.LoopByteUntilAligned:
	lea	rbx,	[rdi+rax]			; Load Effective Address
	test rbx,	[rel ThreeBitMask]	; Checks last 3 bits
	jz	.Loop8Bytes
	cmp	byte	[rdi+rax],	0
	je	.Done
	inc	rax
	jmp	.LoopByteUntilAligned

	; ==========================================================================
	; Optimized version - 8byte check
	;	Check for 0-terminator byte in 8 bytes simultanenously
	; 	Using bit operations (explained below), which are faster than memory locating. 
	;	If 0-terminator is found: Jump to 'basic' ft_strlen to identify exact location.
	; ==========================================================================
.Loop8Bytes:
	mov	rbx,	[rdi+rax]		; Copies 8 bytes to register
	mov rcx,	rbx				; Creates a helper register
	sub	rbx,	[rel LowMask]	; Substracts 1 from each Byte. Setting 0x00 to 0xFF
	not	rcx						; Inverts all bits
	and	rbx,	rcx				; Sets high bit to 1 if original was 0x00, 1 for all other cases
	and rbx,	[rel HighMask]	; Clears all non-high bits to 0. Only if the original was 0x00, the byte is non-0x00
	jnz	.LoopByte				; Jumps if rbx is non-0x00
	add	rax,	8
	jmp	.Loop8Bytes

	; ==========================================================================
	; Basic version
	;	Check for 0-terminator byte one byte at a time.
	;	Can function independently from optimization labels
	; ==========================================================================
.LoopByte:
	cmp	byte	[rdi+rax],	0
	je	.Done
	inc rax
	jmp	.LoopByte

.Done:
	pop	rcx
	pop rbx
	ret

; ==============================================================================
; Bitwise 0-terminator check
;	Bit operations are faster than locating memory, 
;		thus checking 8 bytes at a time using bit operations is faster than 8 seperate memory locations
;	Operation Explanation:
;	- The 8 bytes from RDI are copied into both RBX and RCX
;	- RBX is decremented by 1. RCX is inverted.
;	- Only a 0 byte will countain a 1 bit on its highest bit for both RBX and RCX
; ==============================================================================
;        L        o        r        e        m        \0       \1       \64
; rdi    01001100 01101111 01110010 01100101 01101101 00000000 00000001 01000000

; mov rbx, [rdi+rax]
; mov rcx, rbx
; rbx    01001100 01101111 01110010 01100101 01101101 00000000 00000001 01000000
; rcx    01001100 01101111 01110010 01100101 01101101 00000000 00000001 01000000

; sub rbx, 0x0101010101010101
;        00000001 00000001 00000001 00000001 00000001 00000001 00000001 00000001
; rbx    01001011 01101110 01110001 01100100 01101100 11111111 00000000 00111111 

; not rcx
; rcx    10110011 10010000 10001101 10011010 10010010 11111111 11111110 10111111

; and rcx, rbx
; rcx    00000011 00000000 00000001 00000000 00000000 11111111 00000000 00111111

; and rcx, 0x8080808080808080
;        10000000 10000000 10000000 10000000 10000000 10000000 10000000 10000000
; rcx    00000000 00000000 00000000 00000000 00000000 11111111 00000000 00000000
