.section .text

.include "macros.inc"

.globl	interpreter

interpreter:
	leaq	TOKEN_STREAM(%rip), %r8
	leaq	MEMORY(%rip), %r15
.loop:
	movq	(%r8), %rax
	cmpq	$0, %rax
	je	.c_fini
	movzbl	(%rax), %edi
	cmpb	$'+', %dil
	je	.int_inc
	cmpb	$'-', %dil
	je	.int_dec
	cmpb	$'<', %dil
	je	.int_prv
	cmpb	$'>', %dil
	je	.int_nxt
	cmpb	$'.', %dil
	je	.int_out
	cmpb	$',', %dil
	je	.int_inp
	cmpb	$'[', %dil
	je	.loop_op
	cmpb	$']', %dil
	je	.loop_nd
	jmp	.continue


.int_inc:
	xorq	%rcx, %rcx
	movl	24(%r8), %ecx
	addb	%cl, (%r15)
	jmp	.continue

.int_dec:
	xorq	%rcx, %rcx
	movl	24(%r8), %ecx
	subb	%cl, (%r15)
	jmp	.continue

.int_prv:
	xorq	%rax, %rax
	movl	24(%r8), %eax
	cltq
	subq	%rax, %r15
	jmp	.continue

.int_nxt:
	xorq	%rax, %rax
	movl	24(%r8), %eax
	cltq
	addq	%rax, %r15
	jmp	.continue

.int_out:
	cmpl	$0, 24(%r8)
	je	.continue
	movq	$1, %rax
	movq	$1, %rdi
	movq	%r15, %rsi
	movq	$1, %rdx
	syscall
	decl	24(%r8)
	jmp	.int_out

.int_inp:
	cmpl	$0, 24(%r8)
	je	.continue
	movq	$0, %rax
	movq	$1, %rdi
	movq	%r15, %rsi
	movq	$1, %rdx
	syscall
	decl	24(%r8)
	jmp	.int_inp

.loop_op:
	cmpb	$0, (%r15)
	jne	.continue
	movl	24(%r8), %eax
	cltq
	movq	TOKEN_SIZE(%rip), %rbx
        mulq    %rbx
        movq    %rax, %rbx
        leaq    TOKEN_STREAM(%rip), %rax
        addq    %rbx, %rax
        movq    %rax, %r8
        jmp     .continue

.loop_nd:
        cmpb    $0, (%r15)
        je      .continue
        movl    24(%r8), %eax
        cltq
        movq    TOKEN_SIZE(%rip), %rbx
        mulq    %rbx
        movq    %rax, %rbx
        leaq    TOKEN_STREAM(%rip), %rax
        addq    %rbx, %rax
        movq    %rax, %r8
        jmp     .continue

.continue:
	addq	TOKEN_SIZE(%rip), %r8
	jmp	.loop

.c_fini:
	ret
