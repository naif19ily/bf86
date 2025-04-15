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
	subq	$8, %rsp
	movq	%r8, -8(%rbp)
.mainloop:
	movzbl	-8(%rbp), %eax
	cmpb	$0, %al
	je	.c_fini


	incq	-8(%rbp)
	jmp	.mainloop
.c_fini:
	EXIT	$0

.usage:
	PRINT	USAGE_MSG(%rip), USAGE_LEN(%rip), $1
	EXIT	$0
