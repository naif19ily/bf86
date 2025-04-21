.section .rodata
	#  _________________
	# < messages errors >
	#  -----------------
	#         \   ^__^
	#          \  (..)\_______
	#             (__)\       )\/\
	#                 ||----w |
	#                 ||     ||

	USAGE_MSG: .string "\n  bf-int::usage: $ bfint [code]\n\n"
	USAGE_LEN: .quad 34
	.globl USAGE_MSG
	.globl USAGE_LEN

	RANOUTTAT_MSG: .string "\n  bf-int::error: ran out of tokens (30K)\n\n"
	RANOUTTAT_LEN: .quad 43
	.globl  RANOUTTAT_MSG
	.globl  RANOUTTAT_LEN

	MAXNESTEDLPS_MSG: .string "\n  bf-int::error: max nested loops reached (256)\n"
	MAXNESTEDLPS_LEN: .quad 50
	.globl  MAXNESTEDLPS_MSG
	.globl  MAXNESTEDLPS_LEN

	UNBALANCED_MSG: .string "\n bf-int::error: unbalanced brackets\n\n"
	UNBALANCED_LEN: .quad 38
	.globl UNBALANCED_MSG
	.globl UNBALANCED_LEN

	#  __________________________
	# < interpreter itself stuff >
	#  --------------------------
	#         \   ^__^
	#          \  (..)\_______
	#             (__)\       )\/\
	#                 ||----w |
	#                 ||     ||
	TOKEN_STREAM_SIZE: .quad 1024
	.globl TOKEN_STREAM_SIZE

	TOKEN_SIZE: .quad 28
	.globl TOKEN_SIZE

	LPSTACK_SIZE: .quad 256
	.globl LPSTACK_SIZE


	inc: .string "inc\n"
	dec: .string "dec\n"
	prv: .string "prv\n"
	nxt: .string "nxt\n"
	out: .string "out\n"
	inp: .string "inp\n"
	lp1: .string "lp1\n"
	lp2: .string "lp2\n"

	.globl inc
	.globl dec
	.globl prv
	.globl nxt
	.globl out
	.globl inp
	.globl lp1
	.globl lp2

.section .bss
	# Token structure:
	#
	#   char *definition;		8B
	#   int  noline;		8B
	#   int  offset;		8B
	#   int  fmlysz;		4B
	#
        #				28B Total
	TOKEN_STREAM: .zero 1024 * 28
	.globl TOKEN_STREAM

	# Store pointers to the opening brackets ('[') in order
	# to make sure the program is well balanced.
	LPSTACK: .zero 256 * 8
	.globl LPSTACK

	MEMORY: .zero	30000
	.globl MEMORY
