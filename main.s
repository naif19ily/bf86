.section .text

.include "macros.inc"

.globl _start

_start:
	popq	%rax
	cmpq	$2, %rax
	jne	.usage
	popq	%rax
	popq	%r8
	pushq	%rbp
	movq	%rsp, %rbp
	subq	$40, %rsp
	#
	# Stack distribution:
	#
	# -8(%rbp):  Source code..............
	# -16(%rbp): Number line..............
	# -24(%rbp): Offset line..............
	# -32(%rbp): No tokens stored.........
	# -36(%rbp): Last token type stored...
	#
	movq	%r8, -8(%rbp)
	movq	$1, -16(%rbp)
	movq	$0, -24(%rbp)
	movq	$1, -32(%rbp)
	movl	$0, -36(%rbp)

.mainloop:
	movq	-8(%rbp), %rax
	movzbl	(%rax), %edi
	cmpb	$0, %dil
	je	.c_fini
	cmpb	$'+', %dil
	je	.accumulatoken
	cmpb	$'-', %dil
	je	.accumulatoken
	cmpb	$'<', %dil
	je	.accumulatoken
	cmpb	$'>', %dil
	je	.accumulatoken
	cmpb	$',', %dil
	je	.accumulatoken
	cmpb	$'.', %dil
	je	.accumulatoken
	cmpb	$'[', %dil
	je	.open_token
	cmpb	$']', %dil
	je	.close_token
	cmpb	$'\n', %dil
	je	.handlenewline
	jmp	.continue

# Whenever a new line is found the procedure method is different
# since we need to update the numberline, set the offset to zero
# and go for the next character, it differs from '.continue'
.handlenewline:
	incq	-16(%rbp)
	movq	$0, -24(%rbp)
	incq	-8(%rbp)
	jmp	.mainloop

.accumulatoken:
	cmpl	-36(%rbp), %edi
	je	.incresefmlsz
	CHECK_4_SPACE
	GET_TOKEN_ADDR_2_SET__R8
	# At this point the current token is stored into r8
	# and the program is rady to set the token info
	movq	-8(%rbp), %rax
	movq	%rax, (%r8)
	movq	-16(%rbp), %rax
	movq	%rax, 8(%r8)
	movq	-24(%rbp), %rax
	movq	%rax, 16(%r8)
	movl	$1, 24(%r8)
	movl	%edi, -36(%rbp)
	incq	-32(%rbp)
	jmp	.continue

.open_token:
.close_token:

.incresefmlsz:
	GET_TOKEN_ADDR_2_UPD__R8
	incl	24(%r8)
.continue:
	incq	-20(%rbp)
	incq	-8(%rbp)
	jmp	.mainloop
.c_fini:
	EXIT	$0

#  ________________________________
# < error hamdling system (system) >
#  --------------------------------
#         \   ^__^
#          \  (..)\_______
#             (__)\       )\/\
#                 ||----w |
#                 ||     ||

.ranoutoftokens:
	PRINT	RANOUTTAT_MSG(%rip), RANOUTTAT_LEN(%rip), $2
	# TODO: call printf from here
	EXIT	$0


.usage:
	PRINT	USAGE_MSG(%rip), USAGE_LEN(%rip), $1
	EXIT	$0

#  ___________________
# < helper functions! >
#  -------------------
#         \   ^__^
#          \  (..)\_______
#             (__)\       )\/\
#                 ||----w |
#                 ||     ||

