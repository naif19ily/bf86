.section .text

.include "macros.inc"

.globl	interpreter

interpreter:
	leaq	TOKEN_STREAM(%rip), %r8
	leaq	MEMORY(%rip), %r9
.loop:
	movq	(%r8), %rax
	cmpq	$0, %rax
	je	.c_fini
	xorq	%rcx, %rcx
	movzbl	(%rax), %eax
	cmpb	$'+', %al
	je	.inst_inc
	cmpb	$'-', %al
	je	.inst_dec
	cmpb	$'>', %al
	je	.inst_nxt
	cmpb	$'<', %al
	je	.inst_prv
	cmpb	$'.', %al
	je	.inst_out
	cmpb	$',', %al
	je	.inst_inp
	cmpb	$'[', %al
	je	.inst_opn
	cmpb	$']', %al
	je	.inst_cls
	jmp	.continue

.inst_inc:
	movl	24(%r8), %ecx
	addb	%cl, (%r9)
	jmp	.continue

.inst_dec:
	movl	24(%r8), %ecx
	subb	%cl, (%r9)
	jmp	.continue

.inst_nxt:
	movl	24(%r8), %eax
	cltq
	addq	%rax, %r9
	jmp	.continue

.inst_prv:
	movl	24(%r8), %eax
	cltq
	subq	%rax, %r9
	jmp	.continue

.inst_out:
	movl	24(%r8), %eax
	cmpl	$0, %eax
	je	.continue
	movq	$1, %rax
	movq	$1, %rdi
	movq	%r9, %rsi
	movq	$1, %rdx
	syscall
	decl	24(%r8)
	jmp	.inst_out

.inst_inp:
	movl	24(%r8), %eax
	cmpl	$0, %eax
	je	.continue
	movq	$0, %rax
	movq	$0, %rdi
	movq	%r9, %rsi
	movq	$1, %rdx
	syscall
	decl	24(%r8)
	jmp	.inst_out

.inst_opn:
	movzbl	(%r9), %eax
	cmpb	$0, %al
	jne	.continue
	movl	24(%r8), %eax
	cltq
	movq	TOKEN_SIZE(%rip), %rbx
	mulq	%rbx
	movq	%rax, %rbx
	leaq	TOKEN_STREAM(%rip), %rax
	addq	%rbx, %rax
	movq	%rax, %r8
	jmp	.loop

.inst_cls:
	movzbl	(%r9), %eax
	cmpb	$0, %al
	je	.continue
	movl	24(%r8), %eax
	cltq
	movq	TOKEN_SIZE(%rip), %rbx
	mulq	%rbx
	movq	%rax, %rbx
	leaq	TOKEN_STREAM(%rip), %rax
	addq	%rbx, %rax
	movq	%rax, %r8
	jmp	.loop

.continue:
	movq	TOKEN_SIZE(%rip), %rax
	addq	%rax, %r8
	jmp	.loop

.c_fini:
	ret
