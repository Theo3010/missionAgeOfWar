%define PRINT_BUFFER_SIZE 4096


%include "myLib/print_flush.asm"
%include "myLib/print.asm"
%include "myLib/print_decimal.asm"
%include "myLib/print_hex.asm"
%include "myLib/print_ascii_value.asm"
%include "myLib/file_open.asm"
%include "myLib/file_close.asm"
%include "myLib/file_read.asm"


section .data
    msg1 db "This is using print buffer", 10, 0
    msg2 db "Hello, ", 10, 0
    filename db "test.txt", 0
    PRINT_BUFFER_LENGTH dq 0

section .bss
    input resb 16
    digitPointer resb 8

    PRINT_BUFFER resb PRINT_BUFFER_SIZE

section .text
    global _start


exit:

    mov rax, 60 ; sys_exit
    mov rdi, 0 ; exit code zero = god alt death
    syscall


_start:

    ; 2
    ; 1000 1110 = 142
    ; 0000 1111 | and
    ; 0000 1110 = 14
    ; 0000 1000 = 8
    ; 0000 1111 | and
    ; 0000 1000 = 8

    print_hex 142

    print_ascii_value 10

    print_flush

    call exit

