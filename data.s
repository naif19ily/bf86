.section .rodata
	USAGE_MSG: .string "\n  bf-int::usage: $ bfint [code]\n\n"
	USAGE_LEN: .quad 34

	.globl USAGE_MSG
	.globl USAGE_LEN

        RANOUTTAT_MSG: .string "\n  bf-int::error: ran out of tokens\n"
        RANOUTTAT_LEN: .quad 36

        .globl  RANOUTTAT_MSG
        .globl  RANOUTTAT_LEN

	MEMORY_SIZE: .quad 30000
	.globl MEMORY_SIZE

	TOKEN_SIZE: .quad 28
	.globl TOKEN_SIZE


# Token structure:
#
#   char *definition;		8B
#   int  noline;		8B
#   int  offset;		8B
#   int  fmlysz;		4B
#
#				20B Total

.section .bss
	MEMORY: .zero 30000 * 28
	.globl MEMORY
