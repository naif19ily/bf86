.section .text

.include "macros.inc"

.globl	interpreter

interpreter:
	leaq	TOKEN_STREAM(%rip), %r8
	leaq	MEMORY(%rip), %r9
.loop:
	xorq	%rcx, %rcx
	movq	(%r8), %rax
	cmpq	$0, %rax
	je	.c_fini
	movzbl	(%rax), %eax
	cmpb	$'+', %al
	je	.inst_inc
	cmpb	$'-', %al
	je	.inst_inc
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
	movl	24(%r8), %eax
	addb	%al, (%r9)
	jmp	.continue

.inst_dec:
	movl	24(%r8), %eax
	subb	%al, (%r9)
	jmp	.continue

.inst_nxt:
	incq	%r9
	jmp	.continue

.inst_prv:
	decq	%r9
	jmp	.continue

.inst_out:
	movq	$1, %rax
	movq	$1, %rdi
	movq	%r9, %rsi
	movq	$1, %rdx
	syscall
	jmp	.continue

.inst_inp:
	movq	$0, %rax
	movq	$0, %rdi
	movq	%r9, %rsi
	movq	$1, %rdx
	syscall
	jmp	.continue

.inst_opn:
	movzbl	(%r9), %eax
	cmpb	$0, %al
	jne	.continue
	movl	24(%r8), %eax
	cltq
	movq	TOKEN_SIZE(%rip), %rbx
	mulq	%rbx
	leaq	TOKEN_STREAM(%rip), %r8
	addq	%rax, %r8
	jmp	.continue

.inst_cls:
	movzbl	(%r9), %eax
	cmpb	$0, %al
	je	.continue
	movl	24(%r8), %eax
	cltq
	movq	TOKEN_SIZE(%rip), %rbx
	mulq	%rbx
	leaq	TOKEN_STREAM(%rip), %r8
	addq	%rax, %r8
	jmp	.continue

.continue:
	movq	TOKEN_SIZE(%rip), %rax
	addq	%rax, %r8
	jmp	.loop

.c_fini:
	ret
