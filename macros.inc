.macro	PRINT, msg, len, fd
    movq    $1, %rax
    movq    \fd, %rdi
    leaq    \msg, %rsi
    movq    \len, %rdx
    syscall
.endm

.macro	EXIT code
	movq	\code, %rdi
	movq	$60, %rax
	syscall
.endm
