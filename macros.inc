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

.macro  CHECK_4_SPACE
    movq    -32(%rbp), %rax
    cmpq    MEMORY_SIZE(%rip), %rax
    je      .ranoutoftokens
.endm

.macro  GET_TOKEN_ADDR_2_SET__R8
    movq    -32(%rbp), %rax
    movq    TOKEN_SIZE(%rip), %rbx
    mulq    %rbx
    movq    %rax, %rbx
    leaq    MEMORY(%rip), %rax
    addq    %rbx, %rax
    movq    %rax, %r8
.endm

.macro  GET_TOKEN_ADDR_2_UPD__R8
    movq    -32(%rbp), %rax
    decq    %rax
    movq    TOKEN_SIZE(%rip), %rbx
    mulq    %rbx
    movq    %rax, %rbx
    leaq    MEMORY(%rip), %rax
    addq    %rbx, %rax
    movq    %rax, %r8
.endm
