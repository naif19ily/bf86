#  _   ___ ___ ___ 
# | |_|  _| . |  _|
# | . |  _| . | . |
# |___|_| |___|___|

.section .text

.include "macros.inc"


.macro PRINT_DEBUG_INFO
	movl	24(%r14), %eax
	cltq
        pushq	%rax
	movq	(%r14), %rax
	movzbl	(%rax), %eax
	cltq
	pushq	%rax
	leaq	.debugp(%rip), %rdi
	movq	$1, %rsi
	call	fpx86
	popq	%rax
	popq	%rax
.endm

.globl interpreter

interpreter:
	pushq	%rbp
	movq	%rsp, %rbp
	subq	$20, %rsp
	movq	%rdi, -8(%rbp)
	movq	$0, -16(%rbp)
	movl	$0, -20(%rbp)
	leaq	MEMORY(%rip), %r15
.loop:
	movq	-16(%rbp), %rax
	cmpq	-8(%rbp), %rax
	je	.c_fini
	movq	-16(%rbp), %rax
	movq	TOKEN_SIZE(%rip), %rbx
	mulq	%rbx
	leaq	TOKEN_STREAM(%rip), %r14
	addq	%rax, %r14
	movl	$0, -20(%rbp)
	movq	(%r14), %rax
	movzbl	(%rax), %eax
	cmpb	$'+', %al
	je	.perform_inc
	cmpb	$'-', %al
	je	.perform_dec
	cmpb	$'>', %al
	je	.perform_nxt
	cmpb	$'<', %al
	je	.perform_prv
	cmpb	$'.', %al
	je	.perform_out
	cmpb	$',', %al
	je	.perform_inp
	cmpb	$'[', %al
	je	.perform_loop_init
	cmpb	$']', %al
	je	.perform_loop_close
	jmp	.nextoken
.perform_inc:
	movl	24(%r14), %ecx
	addb	%cl, (%r15)
	jmp	.nextoken

.perform_dec:
	movl	24(%r14), %ecx
	subb	%cl, (%r15)
	jmp	.nextoken

.perform_nxt:
	xorq	%rax, %rax
	movl	24(%r14), %eax
	cltq
	addq	%rax, %r15
	jmp	.nextoken
.perform_prv:
	xorq	%rax, %rax
	movl	24(%r14), %eax
	cltq
	subq	%rax, %r15
	jmp	.nextoken

.perform_out:
	movl	-20(%rbp), %eax
	movl	24(%r14), %ebx
	cmpl	%ebx, %eax
	je	.nextoken
	movq	$1, %rax
	movq	$1, %rdi
	movq	%r15, %rsi
	movq	$1, %rdx
	syscall
	incl	-20(%rbp)
	jmp	.perform_out

.perform_inp:
	movl	-20(%rbp), %eax
	movl	24(%r14), %ebx
	cmpl	%ebx, %eax
	je	.nextoken
	movq	$0, %rax
	movq	$1, %rdi
	movq	%r15, %rsi
	movq	$1, %rdx
	syscall
	incl	-20(%rbp)
	jmp	.perform_out

.perform_loop_init:
	xorq	%rcx, %rcx
	movb	(%r15), %cl
	cmpb	$0, %cl
	jne	.nextoken
	xorq	%rax, %rax
	movl	24(%r14), %eax
	cltq
	movq	%rax, -16(%rbp)
	jmp	.nextoken

.perform_loop_close:
	xorq	%rcx, %rcx
	movb	(%r15), %cl
	cmpb	$0, %cl
	je	.nextoken
	xorq	%rax, %rax
	movl	24(%r14), %eax
	cltq
	movq	%rax, -16(%rbp)
	jmp	.nextoken

.nextoken:
	incq	-16(%rbp)
	jmp	.loop

.c_fini:
	leave
	ret
