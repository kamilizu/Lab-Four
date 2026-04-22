    .section .note.GNU-stack,"",@progbits   # mark stack as non-executable
    .section .text
    .globl  sum_array

# sum_array — sums an array of 32-bit integers
#
# Calling convention (System V AMD64 ABI):
#   %rdi  = pointer to int array (arr)
#   %rsi  = number of elements   (n)
#   %eax  = return value         (sum, 32-bit, sign-extended to %rax)
#
# Algorithm: iterate i = 0..n-1, accumulate arr[i] into %eax
#
sum_array:
    xorl    %eax, %eax          # sum = 0  (also clears upper 32 bits of %rax)
    testq   %rsi, %rsi          # if n == 0, return immediately
    jle     .done

    xorq    %rcx, %rcx          # i = 0

.loop:
    cmpq    %rsi, %rcx          # while i < n
    jge     .done

    movl    (%rdi, %rcx, 4), %edx   # edx = arr[i]  (each int is 4 bytes)
    addl    %edx, %eax              # sum += arr[i]

    incq    %rcx                    # i++
    jmp     .loop

.done:
    ret                         # return sum in %eax (%rax)
