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
	subq	$44, %rsp
	#
	# Stack distribution:
	#
	# -8(%rbp):  Source code..............
	# -16(%rbp): Number line..............
	# -32(%rbp): No tokens stored.........
	# -36(%rbp): Last token type stored...
	# -44(%rbp): No loops opened..........
	#
	movq	%r8, -8(%rbp)
	movq	$1, -16(%rbp)
	movq	$0, -32(%rbp)
	movl	$0, -36(%rbp)
	movq	$0, -44(%rbp)

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
	incq	-8(%rbp)
	jmp	.mainloop

.accumulatoken:
	cmpl	-36(%rbp), %edi
	je	.incresefmlsz
	CHECK_4_SPACE
	GET_TOKEN_ADDR_2_SET__R8
	movl	$1, 24(%r8)
	movl	%edi, -36(%rbp)
	incq	-32(%rbp)
	jmp	.continue

.open_token:
	movq	-44(%rbp), %rax
	cmpq	LPSTACK_SIZE(%rip), %rax
	je	.maxnestedloops
	CHECK_4_SPACE
	GET_TOKEN_ADDR_2_SET__R8
	movq	-32(%rbp), %rax
	movl	%eax, 24(%r8)
	movq	-44(%rbp), %rax
	movq	$8, %rbx
	mulq	%rbx
	movq	%rax, %rbx
	leaq	LPSTACK(%rip), %rax
	addq	%rbx, %rax
	movq	%r8, (%rax)
	incq	-44(%rbp)
	incq	-32(%rbp)
	movl	$'[', -36(%rbp)
	jmp	.continue

.close_token:
	cmpq	$0, -44(%rbp)
	je	.brksunbalanced
	CHECK_4_SPACE
	GET_TOKEN_ADDR_2_SET__R8
	movq	-44(%rbp), %rax
	decq	%rax
	movq	$8, %rbx
	mulq	%rbx
	movq	%rax, %rbx
	leaq	LPSTACK(%rip), %rax
	addq	%rbx, %rax
	movq	(%rax), %r9
	movl	24(%r9), %eax
	movl	%eax, 24(%r8)
	movq	-32(%rbp), %rax
	movl	%eax, 24(%r9)
	decq	-44(%rbp)
	incq	-32(%rbp)
	movl	$']', -36(%rbp)
	jmp	.continue

.incresefmlsz:
	GET_TOKEN_ADDR_2_UPD__R8
	incl	24(%r8)
.continue:
	incq	-8(%rbp)
	jmp	.mainloop
.c_fini:
	cmpq	$0, -44(%rbp)
	jne	.brksunbalanced
        movq    -32(%rbp), %rdi
	call	interpreter
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
	EXIT	$1

.maxnestedloops:
	PRINT	MAXNESTEDLPS_MSG(%rip), MAXNESTEDLPS_LEN(%rip), $2
	EXIT	$0

.brksunbalanced:
	PRINT	UNBALANCED_MSG(%rip), UNBALANCED_LEN(%rip), $2
	EXIT	$0

.usage:
	PRINT	USAGE_MSG(%rip), USAGE_LEN(%rip), $1
	EXIT	$0
