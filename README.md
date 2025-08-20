# libasm
Basc Assembly library

## Compiler
Nasm
https://www.nasm.us/xdoc/2.16.03/html/nasmdoc0.html

<table>
  <thead>
    <tr>
	  <th>Syntax</th>
	  <th>Compiler</th>
	  <th>Fle Extention</th>
	</tr>
  </thead>
  <tbody>
    <tr>
      <td>Intel</td>
      <td>NASM</td>
      <td>.asm</td>
    </tr>
    <tr>
      <td>AT&T</td>
      <td>GAS</td>
      <td>.s</td>
    </tr>
  </tbody>
</table>

## language

### Sections
<table>
  <thead>
    <tr><th colspan=2>Sections</th></tr>
  </thead>
  <tbody>
    <tr>
      <td>.data</td>
      <td>Initializes constants or variables with a set value.</td>
    </tr>
    <tr>
      <td>.bss</td>
      <td>Reserves space for variables with no initialized value.</td>
    </tr>
    <tr>
      <td>.text</td>
      <td>Executable code and function definition</td>
    </tr>
    <tr><td colspan=2>https://docs.oracle.com/cd/E19455-01/806-3773/elf-3/index.html</td></tr>
  </tbody>
</table>

https://www.tutorialspoint.com/assembly_programming/assembly_basic_syntax.htm

https://www.cs.yale.edu/flint/cs421/papers/x86-asm/asm.html

## Instructions
Data Transfer Instructions (mov, push, pop, xchg, lea, etc.)

Binary Arithmetic Instructions (add, sub, imul, idiv, inc, dec, etc.)

Decimal Arithmetic Instructions (older BCD ops, rarely used today)

Logical Instructions (and, or, xor, not, shl, shr, etc.)

Shift and Rotate Instructions (shl, shr, rol, ror, etc.)

Bit and Byte Instructions (bt, bts, setcc, test, etc.)

Control Transfer Instructions (jmp, call, ret, conditional jumps, loop, etc.)

String Instructions (movs, cmps, scas, stos, lods, with rep prefixes)

Input/Output Instructions (in, out)

Flag Control Instructions (stc, clc, cmc, lahf, sahf, pushf, popf, etc.)

Segment Register Instructions (lds, les, lfs, lgs, lss)

Miscellaneous Instructions (nop, lea, xlat, etc.)

System Instructions (syscall, sysret, hlt, cpuid, wrmsr, etc.)

Floating-Point Instructions (x87 stack-based FPU ops)

SIMD Instructions (MMX, SSE, AVX, AVX-512 categories, each subdivided further)

## Registers
Registers are sections of the CPU where information can be stored. On a x86_64 system each register can store 64-bits worth of data. They can be used to directly store information, or as an intermediate step required to transfer data between variables.
While in theory all registers can be used to hold any data, there is good practise in place to maintain stability and reliability, preventing unexpected behavior. To this end registers are defined in two type: Caller Saved registers (Scratch) and Callee Saved registers (Preserved), and each register has an intended purpose.

| Register | General usage | Callee/Caller Saved |
| :------: | :------------ | :------------------ |
| rax | SysCall ID / Return value | Scratch |
| rbx |  | Preserved |
| rcx | ARG03 | Scratch |
| rdx | ARG02 | Scratch |
| rsp | Stack Pointer / ARG06+ | Preserved | 
| rbp | Base Pointer | Preserved |
| rdi | ARG00 | Scratch | ARG00 |
| rsi | ARG01 | Scratch | ARG01 |
| r8 | ARG04 | Scratch |
| r9 | ARG05 | Scratch |
| r10 |  | Scratch |
| r11 |  | Scratch |
| r12 |  | Preserved |
| r13 |  | Preserved |
| r14 |  | Preserved |
| r15 |  | Preserved |

Any information stored in a Scratch register is allowed to be altered by any function. While a function could store temporary information in a Scratch register, when calling other functions it may never asume they remain unaltered. Thus, when calling other functions it should store its information in other locations.

When a function alters a Preserved register, it must restore the register before returning to another function. Each function may expect the Preserved register between calls of sub-functions. 
A notable Preserved register is `rsp` (using `rbp` to maintain and store temporary states), which is used to store larger chunks of information. `rsp` is often referred to as 'the stack'.

### Calling Convention
When making function calls there is a convention as to which registers are used. While in a custom function this has little effects. When calling library functions however, it defines the order by with arguments are sent. The actual registers vary by processor, and thus the calling convention must be adjusted to the appropriate processor. For the current x86_64 system the calling convention in order of arguments passed is `RDI` => `RSI` => `RDX` => `RCX` => `R8` => `R9` => The Stack. For the return value `RAX` is used.

**Local Function Call**
```assembly
_start:
	; Passing upto 6 arguments to a function by registers
	mov	rdi,	arg00
	mov	rsi,	arg01
	mov	rdx,	arg02
	mov	rcx,	arg03
	mov	r8,		arg04
	mov	r9,		arg05

	; Passing numerous arguments to a function by stack
	; Calling Library functions, such as malloc and printf require stack alignment
	;	The stack then needs to be aligned if it will receive an odd amount of arguments
	;	Otherwise this step can be skipped (and the cleaning up needs to be adjusted accordingly)
	sub	rsp,	8
	push arg08
	push arg07
	push arg06

	; Actual function call
	call function

	; Clean up stack if more than six arguments were passed
	;	Reposition stack by 8 bytes per argument, 
	;	and another 8 if there were an odd number of arguments
	;		3 * 8 + 8 = 32
	add	rsp,	32

	; Setting rax to 60 for exit
	mov	rax,	60
	; Setting exit value to 0
	mov rdi,	0
	; Making a syscall ( => exit(0) )
	syscall

function:
	; Reserve space on the stack to hold the arguments
	;	Depending on the arguments, 8 bytes per argument
	;		Recommended for complex functions and functions that call sub-functions
	;		Can be skipped for simple functions
	;	push rbp; mov rbp,rsp; sub rsp,N
	enter	64,	0

	; Transferring values from Register to locally reserved stack space
	;	Recommended for complex functions and functions that call sub-functions
	;	Can be skipped for simple functions; Then directly use register
	mov [rbp-8],  rdi
	mov [rbp-16], rsi
	mov [rbp-24], rdx
	mov [rbp-32], rcx
	mov [rbp-40], r8
	mov [rbp-48], r9
	; Further arguments are already on the stack and must be retrieved thusly
	;	This requires an intermediate step, using a registry
	;		[rbp+0]: saved RBP (from enter/leave)
	;		[rbp+8]: return address
	mov	rax,		[rbp+16]
	mov	[rbp-56],	rax
	mov	rax,		[rbp+24]
	mov	[rbp-64],	rax
	mov	rax,		[rbp+32]
	mov	[rbp-72],	rax

	; Function Body
	;	This can include any use case

	; Clean up stack
	leave

	; Return to calling function
	ret
```

**Library Function Call**
```assembly
```

https://www.cs.uaf.edu/2017/fall/cs301/lecture/09_11_registers.html

| eax | type f system call |
| ebx - edx | system call arguments |


| rsp | stack (reserved stack pointer?) | 

| rdi |	1th Function Argument |
| rsi |	2th Function Argument |
| rdx |	3th Function Argument |
| rcx |	4th Function Argument |
| r8 |	5th Function Argument |
| r9 |	6th Function Argument |

| rax | return value |

## Syscall
https://syscall.sh/

## Comparisons


## Conditional jumps
https://www.philadelphia.edu.jo/academics/qhamarsheh/uploads/Lecture%2018%20Conditional%20Jumps%20Instructions.pdf