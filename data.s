.section .rodata
	USAGE_MSG: .string "\n  bf-int::usage: $ bfint [code]\n\n"
	USAGE_LEN: .quad 34

	.globl USAGE_MSG
	.globl USAGE_LEN

	MEMORY_SIZE: .quad 30000
	.globl MEMORY_SIZE

.section .bss
	.MEMORY: .zero 30000 * n
