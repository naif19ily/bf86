#                __
#               / _)
#      _.----._/ /      dc0x13
#     /         /       part of `bf864` project.
#  __/ (  | (  |        Mar 10 2025
# /__.-'|_|--|_|

.macro        PRINT_, a, b, c
        movl        \a, %edi
        movl        \b, %edx
        leaq        \c, %rsi
        movl        $1, %eax
        syscall
.endm

.macro        EXIT_, a
        movl        \a, %edi
        movl        $60, %eax
        syscall
.endm
