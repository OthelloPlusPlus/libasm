# libasm
A static library `libasm.a` containing several basic [assembly functions](inc/libasm.h#L18) designed for an [x86_64](https://en.wikipedia.org/wiki/X86-64) bit architecture.

# Functions

# Assembly
Assembly is a low level language close to the machine language. It primairily involes around giving instructions to the processor's registers and accessing memory.

Unlike higher level languages the syntax involves giving direct commands to the processor. The exact architecture of this processor can vary by brand and bit. Thus the exact syntax and assembly compiler varies per system. 

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
      <td><a href="https://www.nasm.us/xdoc/2.16.03/html/nasmdoc0.html" target="_blank">NASM</a></td>
      <td>.asm</td>
    </tr>
    <tr>
      <td>AT&T</td>
      <td>GAS</td>
      <td>.s</td>
    </tr>
  </tbody>
</table>

Modern compilers, such as gcc, convert higher languages into a compatible assembly syntax before making and linking object files. This project however is only compatible for [x86_64](https://en.wikipedia.org/wiki/X86-64) architecture and is compiled using [nasm](Makefile#L74) and [stored in an archive](Makefile#L67). When executing functions without the use of of a more modern compiler the files must be manually linked together, this is done via [ld](Makefile#L90).

## Basic Structure
The syntax for the assembly language is divided into five aspects.
- **Sections** - Different regions of a file, which specify how the syntax should be interpreted and where data should be stored.
- **Instructions** - Instructions for operations to be by the processor.
- **Registers** - The CPU's working storage.
- **Memory** - Storage outside of the CPU. Including the stack.
- **Labels** - Symbolic names for memory addresses.

These aspects of assembly are so interdependant, that explaining one must asume the other aspects are understood.

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

### Instructions
Instructions are given to the processor by the use of **mnemonics**. These keywords are translated into **Opcode**, which are numeric instructions which can be send to the processor. The available **mnemonics**, the **Opcode** they relate to, and the expected syntax _varies per architecture_, but are reasonably consistent for a given manufacturer.

The basic syntax for an instruction is a **mnemonic** followed by an **operand** or a label. Some instructions set Status Flag, which specific instructions can respond to. 

```assembly
; Instruction
<mnemonic> <operand>, <operand>

; Example
add	rdi,	rax
```

While there are typicaly _numerous_ **instructions** available, and you can expect the manufacturer to provide documentation for them, only a hew handfulls are typically used.

**Setting register values**
```assembly
section	.text
CopyValue:
	; Set RAX to 23
	mov	rax,	23
	; Copy value from RAX to RDI
	;	RDI = RAX
	mov	rdi,	rax
	; Copy content from RAX to RDI
	;	RDI = *RAX
	mov	rdi,	[rax]
	; Copy specific content from RAX to RDI
	;	RDI = RAX->data
	mov	RDI,	[rax + 8]
```

```assembly
section	.text
SwapValues:
	; Swap the values for RDI and RAX
	xchg	rdi,	rax
```

```assembly
section	.text
Dereference:
	; Get the address for the litteral string
	lea	RDI,	[rel string]
```
**Manipulating register values**
```assembly
section	.text
IncreaseAndDecrease:
	; Set RCX to 0
	xor	rcx,	rcx
	; ++RCX
	inc	rcx
	; --RCX
	dec	rcx
```
```assembly
section	.text
AddAndSubtract:
	; RSP += 8
	add	rsp,	8
	; RSP -= 8
	sub	rsp,	8
```
```assembly
section	.text
MultiplyAndDivide:
	mov	rdx,	3
	; RDX *= 2
	imul	rdx,	2
	; RDX = RDX * RDI
	imul	rdx,	rdi
	; RDX /= RAX
	idiv	rdx,	rax
```

**Stack manipulation**
```assembly
section	.text
Function:
	; Store base pointer in stack
	push	rbp
	; Store new stack base in base pointer
	mov		rsp,	rbp

	; Copy RDI and RSI into stack RSP
	push	rdi
	push	rsi

	; Read from stack
	mov	rdi,	[rsp + 8]
	mov	rsi,	[rsp]

	; Reserve space on stack
	sub	rsp,	8

	; Free space from stack
	add	rsp,	8

	; Retrieve and remove data from stack
	pop	rcx	; was RSI
	pop	rdx	; was RDI

	; Restore stack
	mov	rbp,	rsp
	pop	rbp

	; return function
	ret
```

**Testing and Jumping**
```assembly

```




























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


### Registers
Registers are sections of the CPU where information can be stored. On a x86_64 system each register can store 64-bits worth of data. They can be used to directly store information, or as an intermediate step required to transfer data between variables.
While in theory all registers can be used to hold any data, there is good practise in place to maintain stability and reliability, preventing unexpected behavior. To this end registers are defined in two type: Caller Saved registers (Scratch) and Callee Saved registers (Preserved), and each register has an intended purpose.

<table border="1" >
	<colgroup>
		<col>
		<col>
		<col>
		<col span="8" style="width: 23px;">
		<col style="width: 480px;">
	</colgroup>
	<thead>
		<tr><th colspan=12 style="text-align: center">Intel X86 Architecture</th></tr>
		<tr>
			<th>Name</th>
			<th>Caller/Callee saved</th>
			<th>Calling convetion</th>
			<th colspan=8>Bytes</th>
			<th>Notes</th>
		</tr>
	</thead>
	<tbody>
		<!-- RAX Accumulator -->
		<tr>
			<td rowspan=4>Accumulator</td>
			<td rowspan=4>🔥 Scratch</td>
			<td rowspan=4>Return value<br>syscall ID</td>
			<td colspan=8>RAX</td>
		</tr>
		<tr>
			<td colspan=4></td>
			<td colspan=4>EAX</td>
		</tr>
		<tr>
			<td colspan=6></td>
			<td colspan=2>AX</td>
		</tr>
		<tr>
			<td colspan=6></td>
			<td colspan=1>AH</td>
			<td colspan=1>AL</td>
		</tr>
		<!-- RBX Base -->
		<tr>
			<td rowspan=4>Base</td>
			<td rowspan=4>🛡️ Preserved</td>
			<td rowspan=4></td>
			<td colspan=8>RBX</td>
		</tr>
		<tr>
			<td colspan=4></td>
			<td colspan=4>EBX</td>
		</tr>
		<tr>
			<td colspan=6></td>
			<td colspan=2>BX</td>
		</tr>
		<tr>
			<td colspan=6></td>
			<td colspan=1>BH</td>
			<td colspan=1>BL</td>
		</tr>
		<!-- RCX Counter -->
		<tr>
			<td rowspan=4>Counter</td>
			<td rowspan=4>🔥 Scratch</td>
			<td rowspan=4>ARG03</td>
			<td colspan=8>RCX</td>
		</tr>
		<tr>
			<td colspan=4></td>
			<td colspan=4>ECX</td>
		</tr>
		<tr>
			<td colspan=6></td>
			<td colspan=2>CX</td>
		</tr>
		<tr>
			<td colspan=6></td>
			<td colspan=1>CH</td>
			<td colspan=1>CL</td>
		</tr>
		<!-- RDX Data -->
		<tr>
			<td rowspan=4>Data</td>
			<td rowspan=4>🔥 Scratch</td>
			<td rowspan=4>ARG02</td>
			<td colspan=8>RDX</td>
		</tr>
		<tr>
			<td colspan=4></td>
			<td colspan=4>EDX</td>
		</tr>
		<tr>
			<td colspan=6></td>
			<td colspan=2>DX</td>
		</tr>
		<tr>
			<td colspan=6></td>
			<td colspan=1>DH</td>
			<td colspan=1>DL</td>
		</tr>
		<!-- RSI Source -->
		<tr>
			<td rowspan=4>Source</td>
			<td rowspan=4>🔥 Scratch</td>
			<td rowspan=4>ARG01</td>
			<td colspan=8>RSI</td>
		</tr>
		<tr>
			<td colspan=4></td>
			<td colspan=4>ESI</td>
		</tr>
		<tr>
			<td colspan=6></td>
			<td colspan=2>SI</td>
		</tr>
		<tr>
			<td colspan=7></td>
			<td colspan=1>SIL</td>
		</tr>
		<!-- RDI Destination -->
		<tr>
			<td rowspan=4>Destination</td>
			<td rowspan=4>🔥 Scratch</td>
			<td rowspan=4>ARG00</td>
			<td colspan=8>RDI</td>
		</tr>
		<tr>
			<td colspan=4></td>
			<td colspan=4>EDI</td>
		</tr>
		<tr>
			<td colspan=6></td>
			<td colspan=2>DI</td>
		</tr>
		<tr>
			<td colspan=7></td>
			<td colspan=1>DIL</td>
		</tr>
		<!-- RSP Stack Pointer -->
		<tr>
			<td rowspan=4>Stack Pointer</td>
			<td rowspan=4>🛡️ Preserved</td>
			<td rowspan=4>ARG06+</td>
			<td colspan=8>RSP</td>
			<td rowspan=4><b>The stack</b><br><br>Should be altered using sub/add, maintaining 16 byte alignment.<br>Can also be altered with push/pop, each alters it by 8 bytes.<br>⚠️ Misalignement can cause segmentation faults.</td>
		</tr>
		<tr>
			<td colspan=4></td>
			<td colspan=4>ESP</td>
		</tr>
		<tr>
			<td colspan=6></td>
			<td colspan=2>SP</td>
		</tr>
		<tr>
			<td colspan=7></td>
			<td colspan=1>SPL</td>
		</tr>
		<!-- RBP Stack Base Pointer -->
		<tr>
			<td rowspan=4>Stack Base Pointer</td>
			<td rowspan=4>🛡️ Preserved</td>
			<td rowspan=4></td>
			<td colspan=8>RBP</td>
			<td rowspan=4>RBP is used to maintain the stack between a function start and end.<br>At the beginning of the funciton its value should be stored on the stack (push) and then the new value of the stack should be stored on RBP (mov).<br><pre>push RBP<br>mov RBP, RSP</pre>When a function completes these steps can be reversed, restoring the stack.<pre>mov RSP, RBP<br>pop RBP</pre>
		</tr>
		<tr>
			<td colspan=4></td>
			<td colspan=4>EBP</td>
		</tr>
		<tr>
			<td colspan=6></td>
			<td colspan=2>BP</td>
		</tr>
		<tr>
			<td colspan=7></td>
			<td colspan=1>BPL</td>
		</tr>
		<!-- R8 -->
		<tr>
			<td rowspan=32>General Purpose</td>
			<td rowspan=4>🔥 Scratch</td>
			<td rowspan=4>ARG04</td>
			<td colspan=8>R8</td>
		</tr>
		<tr>
			<td colspan=4></td>
			<td colspan=4>R8D</td>
		</tr>
		<tr>
			<td colspan=6></td>
			<td colspan=2>R8W</td>
		</tr>
		<tr>
			<td colspan=7></td>
			<td colspan=1>R8B</td>
		</tr>
		<!-- R9 -->
		<tr>
			<!-- <td rowspan=4></td> -->
			<td rowspan=4>🔥 Scratch</td>
			<td rowspan=4>ARG05</td>
			<td colspan=8>R9</td>
		</tr>
		<tr>
			<td colspan=4></td>
			<td colspan=4>R9D</td>
		</tr>
		<tr>
			<td colspan=6></td>
			<td colspan=2>R9W</td>
		</tr>
		<tr>
			<td colspan=7></td>
			<td colspan=1>R9B</td>
		</tr>
		<!-- R10 -->
		<tr>
			<!-- <td rowspan=4></td> -->
			<td rowspan=4>🔥 Scratch</td>
			<td rowspan=4></td>
			<td colspan=8>R10</td>
		</tr>
		<tr>
			<td colspan=4></td>
			<td colspan=4>R10D</td>
		</tr>
		<tr>
			<td colspan=6></td>
			<td colspan=2>R10W</td>
		</tr>
		<tr>
			<td colspan=7></td>
			<td colspan=1>R10B</td>
		</tr>
		<!-- R11 -->
		<tr>
			<!-- <td rowspan=4></td> -->
			<td rowspan=4>🔥 Scratch</td>
			<td rowspan=4></td>
			<td colspan=8>R11</td>
		</tr>
		<tr>
			<td colspan=4></td>
			<td colspan=4>R11D</td>
		</tr>
		<tr>
			<td colspan=6></td>
			<td colspan=2>R11W</td>
		</tr>
		<tr>
			<td colspan=7></td>
			<td colspan=1>R11B</td>
		</tr>
		<!-- R12 -->
		<tr>
			<!-- <td rowspan=4></td> -->
			<td rowspan=4>🛡️ Preserved</td>
			<td rowspan=4></td>
			<td colspan=8>R12</td>
		</tr>
		<tr>
			<td colspan=4></td>
			<td colspan=4>R12D</td>
		</tr>
		<tr>
			<td colspan=6></td>
			<td colspan=2>R12W</td>
		</tr>
		<tr>
			<td colspan=7></td>
			<td colspan=1>R12B</td>
		</tr>
		<!-- R13 -->
		<tr>
			<!-- <td rowspan=4></td> -->
			<td rowspan=4>🛡️ Preserved</td>
			<td rowspan=4></td>
			<td colspan=8>R13</td>
		</tr>
		<tr>
			<td colspan=4></td>
			<td colspan=4>R13D</td>
		</tr>
		<tr>
			<td colspan=6></td>
			<td colspan=2>R13W</td>
		</tr>
		<tr>
			<td colspan=7></td>
			<td colspan=1>R13B</td>
		</tr>
		<!-- R14 -->
		<tr>
			<!-- <td rowspan=4></td> -->
			<td rowspan=4>🛡️ Preserved</td>
			<td rowspan=4></td>
			<td colspan=8>R14</td>
		</tr>
		<tr>
			<td colspan=4></td>
			<td colspan=4>R14D</td>
		</tr>
		<tr>
			<td colspan=6></td>
			<td colspan=2>R14W</td>
		</tr>
		<tr>
			<td colspan=7></td>
			<td colspan=1>R14B</td>
		</tr>
		<!-- R15 -->
		<tr>
			<!-- <td rowspan=4></td> -->
			<td rowspan=4>🛡️ Preserved</td>
			<td rowspan=4></td>
			<td colspan=8>R15</td>
		</tr>
		<tr>
			<td colspan=4></td>
			<td colspan=4>R15D</td>
		</tr>
		<tr>
			<td colspan=6></td>
			<td colspan=2>R15W</td>
		</tr>
		<tr>
			<td colspan=7></td>
			<td colspan=1>R15B</td>
		</tr>
	</tbody>
</table>

Any information stored in a Scratch register is allowed to be altered by any function. While a function could store temporary information in a Scratch register, when calling other functions it may never asume they remain unaltered. Thus, when calling other functions it should store its information in other locations.

When a function alters a Preserved register, it must restore the register before returning to another function. Each function may expect the Preserved register between calls of sub-functions. 
A notable Preserved register is `rsp` (using `rbp` to maintain and store temporary states), which is used to store larger chunks of information. `rsp` is often referred to as 'the stack'.

### Memory


### Labels
Labels in assembly are symbolic names for memory addresses. They are used to define locations in the code base to move around between. Accessing labels can be done in 3 ways:
- **Process Flow** - Labels are passed over by the instruction flow.
- **Jumps** - Continue process at the specified jump. Jump statements can be conditional and can be reconised by their `j**` syntax.
- **Calls** - Using `call` to access a label stores the previous address on the stack. Then using `ret` returns the process to the old address. Effectively turning the label into a **function**.

```assembly
section .text
Label:
	extern	Function
	call	Function
```
```assembly
section .text
; Function asscessible from other files
global	Function
Function:
	push	rbp
	mov		rbp,	rsp
	; do things
	mov		rsp,	rbp
	pop		rbp
	ret
```
```assembly
section .text
;  While loop
	xor	rcx,	rcx
Loop:
	inc	rcx
	cmp	rcx,	10
	jl	Loop
```
```assembly
section .text
; if statement
If:
	cmp	rdi,	rsi
	jne False
True:
	; Do something
	jmp	EndIf
False:
	; Do something else
EndIf:
```

## Operands
Three types of operands, each able to contain data:
- Register operands - data stored in the processor.
- Memory operands - data stored in memory.
- Immediate operands - 'hardcoded' data in the running process.
- I/O operands - access to ports, special cases.

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

https://www.cs.uaf.edu/2017/fall/cs301/lecture/09_11_registers.html

## Syscall
https://syscall.sh/

## Comparisons


## Conditional jumps
https://www.philadelphia.edu.jo/academics/qhamarsheh/uploads/Lecture%2018%20Conditional%20Jumps%20Instructions.pdf

# Sources
https://www.nasm.us/xdoc/2.16.03/html/nasmdoc0.html

https://syscall.sh/
