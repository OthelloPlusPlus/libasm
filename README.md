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

## Intro
In order to understand assembly, three fundamental aspects must be explained:
- **Instructions** – the actual operations executed by the CPU  
- **Registers** – the CPU’s working storage  
- **Labels** – symbolic names for memory addresses

None of these concepts make complete sense without the others, yet only one at a time can be introduced.  
Therefore, each example will be written as if the other two aspects have already been explained.

## Instructions
Instructions are given to the processor by the use of **mnemonics**. These keywords are translated into **Opcode**, which are numeric instructions which can be send to the processor. The available **mnemonics**, the **Opcode** they relate to, and the expected syntax _varies per architecture_, but are reasonably consistent for a given manufacturer.

The basic syntax for an instruction is a **mnemonic** followed by an **operand** or a label. Some instructions set Status Flag, which specific instructions can respond to. 

```assembly
; Instruction
<mnemonic> <operand>, <operand>

; Example
add	rdi,	rax
```

While there are typicaly numerous **instructions** available, and you can expect the manufacturer to provide documentation for them, only a hew handfulls are typically used.

**Data Movement**

Transferring data can be done between two operands, one of which must be a register operand, the other can be either a register operand and a memory operand.

| Mnemonic | Syntax | Status Flag | Description | Use case |
| :------- | :----- | :---------: | :---------- | :------- |
| mov      | `mov <dst>, <src>` | ❌ | Overwrites dst with src | Data transfer |
| movzx    | `movzx <dst>, <src>` | ❌ | Overwrites dst with src, <br>setting remaining bits to 0. | Data transfer from small register to larger register |
| movsx    | `movsx <dst>, <src>` | ❌ | Overwrites dst with src, <br>setting remaining bits to 0 (positive) or 1 (negative) | Data transfer from small register to larger register, <br> for signed values |
| xchg     | `xchg <reg1>, <reg2>` | ❌ | Swaps data between two operands | Swapping data |
| lea      | `lea <dst>, [<mem>]` | ❌ | Copy selected memory address in register | Pointers |
| push     | `push <register>` | ❌ | Decrements stackpointer `rsp`. <br>Then copies register's data to it | Storing data |
| pop      | `pop <register>` | ❌ | Copies stack top data to register. <br>Then increments stack pointer `rsp` | Retrieving data |

**Arithmetic**

| Mnemonic | Syntax | Status Flag | Description | Use case |
| :------- | :----- | :---------: | :---------- | :------- |
| inc | `inc <register>` | ✅ | Increases registers value by 1 | Counter |
| dec | `dec <register>` | ✅ | Decreases registers value by 1 | Counter |
| add | `add <dst>, <src>` | ✅ | Adds value of src to dst | Integer addition |
| sub | `sub <dst>, <src>` | ✅ | Subtracts the value of src from dst | Integer subtraction |
| mul | `mul <src>` | ✅ | Multiplies the value stored in `rax` by src storing it in `rdx:rax` | Integer multiplication |
| imul | `imul <src>`<br>(other syntaxes available) | ✅ | Multiplies the value stored in `rax` by src storing it in `rdx:rax` | Signed Integer multiplication |
| div | `div <src>` | ❌ | Divides the value stored in `rax` by src<br>The remainder is stored in `rdx` | Integer division |
| idiv | `idiv <src>` | ❌ | Divides the value stored in `rax` by src<br>The remainder is stored in `rdx` | Signed Integer division |

**Bitwise operations**

Comparing bits and storing the results have 3 basic comparisons: `and`, `or`, `xor`. Setting all bits in the destination operand to either true or false depending on the comparison. A simple inversion operation `not` can also be executed swapping true and false. The final 3 comparisons `nand`, `nor`, `xor` (which might not exist for the architecture) combine the basic operations and the inversion into a single instruction. Creating all meaningful possible comparison results.

| Mnemonic | Syntax | Status Flag | Description | Use case |
| :------- | :----- | :---------: | :---------- | :------- |
| and | `and <dst>, <src>` | ✅ | Sets true of both bits are true | Masking bits |
| or | `or <dst>, <src>` | ✅ | Sets true of either bit is true | Bit flags |
| xor | `xor <dst>, <src>` | ✅ | Sets true of only one bit is true | Toggling bits |
| not | `not <dst>` | ❌ | Sets true if false | Inverting bits |
| shl | `shl <dst>, <imm>` | ✅ | Shift bits left | 2^imm |
| shr | `shr <dst>, <imm>` | ✅ | Shift bits right | 0.5^imm |
| sar | `sar <dst>, <imm>` | ✅ | Shift bits right<br>Preserving signed bit | 0.5^imm |

<table>
	<thead>
		<tr>
			<th></th>
			<th>Input</th>
			<th></th>
		</tr>
		<tr>
			<th><code>&lt;dst&gt;</code></th>
			<td>11001100</td>
			<td></td>
		</tr>
		<tr>
			<th><code>&lt;src&gt;</code></th>
			<td>11110000</td>
			<td></td>
		</tr>
		<tr>
			<th>Instruction</th>
			<th>Output</th>
			<th><code>not &lt;dst&gt;</code></th>
		</tr>
	</thead>
	<tbody>
		<tr>
			<td><code>not &lt;dst&gt;</code></td>
			<td>00110011</td>
			<td></td>
		</tr>
		<tr><td colspan=3></td></tr>
		<tr>
			<td><code>and &lt;dst&gt;, &lt;src&gt;</code></td>
			<td>11000000</td>
			<td>00111111 (nand)</td>
		</tr>
		<tr>
			<td><code>or &lt;dst&gt;, &lt;src&gt;</code></td>
			<td>11111100</td>
			<td>00000011 (nor)</td>
		</tr>
		<tr>
			<td><code>xor &lt;dst&gt;, &lt;src&gt;</code></td>
			<td>00111100</td>
			<td>11000011 (nxor)</td>
		</tr>
		<tr>
			<td><code>xor &lt;dst&gt;, &lt;dst&gt;</code></td>
			<td>00000000</td>
			<td>11111111 (nxor)</td>
		</tr>
		<tr><td colspan=3></td></tr>
		<tr>
			<td><code>shl &lt;dst&gt;, 3;</code></td>
			<td>01100000</td>
			<td></td>
		</tr>
		<tr>
			<td><code>shr &lt;dst&gt;, 3;</code></td>
			<td>00011001</td>
			<td></td>
		</tr>
		<tr>
			<td><code>sar &lt;dst&gt;, 3;</code></td>
			<td>11111001</td>
			<td></td>
		</tr>
	</tbody>
</table>

**Control Flow**

| Mnemonic | Syntax | Status Flag | Jump condition | Description | Use case |
| :------- | :----- | :---------: | :------------: | :---------- | :------- |
| call     | `call <label>` | ❌ | Always | Stores current address in stack. Moves to label. | 'Function' calling |
| ret      | `ret` | ❌ | Always | Returns to address stored in stack by `call` | Return from 'function' |
| jmp      | `jmp <label>` | ❌ | Always | Jump to label | while loop |

Conditional jumps using cmp
| Mnemonic | Syntax | Status Flag | Jump condition | Description | Use case |
| :------- | :----- | :---------: | :------------: | :---------- | :------- |
| cmp      | `cmp <src1>, <src2>` | ✅ |  | Executes `sub` without storing result<br>Updates flags OF SF ZF AF PF CF<br>FLAGS 00001000 11010101 | conditions<br>< <= > >= == != |
| je/jz    | `je <label>`  | ❌ | `ZF=1` | If equal |  if (x == y) |
| jne/jnz  | `jne <label>` | ❌ | `ZF=0` | If not equal | if (x != y) |
| jg       | `jg <label>`  | ❌ | `ZF=0 && OF=SF` | If greater than | if (x > y) |
| jge      | `jge <label>` | ❌ | `OF=SF` | If equal or greater than | if (x >= y) |
| jl       | `jl <label>`  | ❌ | `ZF=0 && OF!=SF` | If less than | if (x < y) |
| jle      | `jle <label>` | ❌ | `OF!=SF` | If equal or less than | if (x <= y) |
| ja       | `ja <label>`  | ❌ | `ZF=0 && CF=0 ` | If greater than | if (x > y), unsigned |
| jae      | `ja <label>`  | ❌ | `CF=0` | If equal or greater than | if (x >= y), unsigned |
| jb       | `ja <label>`  | ❌ | `CF=1` | If less than | if (x < y), unsigned |
| jbe      | `ja <label>`  | ❌ | `ZF=1 \|\| CF=1 ` | If equal or less than | if (x <= y), unsigned |

Conditional jumps using test
| Mnemonic | Syntax | Status Flag | Jump condition | Description | Use case |
| :------- | :----- | :---------: | :------------: | :---------- | :------- |
| test     | `test <src1>, <src2>` | ✅ |  | Executes `and` without storing result<br>Updates flags SF ZF PF<br>FLAGS 00000000 11000100 | Testing bits<br>Boolean checks |
| je/jz    | `je <label>`  | ❌ | `ZF=1` | If equal |  if (x == y) |
| jne/jnz  | `jne <label>` | ❌ | `ZF=0` | If not equal | if (x != y) |
| js       | `js <label>`  | ❌ | `SF=1` | If less than  | if (x < y) |
| jns      | `jns <label>` | ❌ | `SF=0` | If greater or equal | if (x >= y) |

**Stack manipulation**

| Mnemonic | Syntax | Status Flag | Description | Use case |
| :------- | :----- | :---------: | :---------- | :------- |
| enter | `enter, <imm1>, <imm2>` | ✅❌ |  |  |
| leave | `leave` | ✅❌ |  |  |


AI, ID, VIP, VIF, AC, VM, RF | MD, NT, IOPL, OF, DF, IF, TF, SF, ZF, AF, PF, CF
https://en.wikipedia.org/wiki/FLAGS_register#FLAGS

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

## Labels (functions et al.)

## Operands
Three types of operands, each able to contain data:
- Register operands - data stored in the processor.
- Memory operands - data stored in memory.
- Immediate operands - 'hardcoded' data in the running process.
- I/O operands - access to ports, special cases.

### Registers
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
