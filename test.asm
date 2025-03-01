%define PRINT_BUFFER_SIZE 1024

%include "myLib/print_flush.asm"
%include "myLib/print.asm"
%include "myLib/print_decimal.asm"
%include "myLib/print_hex.asm"
%include "myLib/print_binary.asm"
%include "myLib/print_ascii_value.asm"

%include "myLib/file_open.asm"
%include "myLib/file_close.asm"
%include "myLib/file_read.asm"


section .data
    msg1 db "This is using print buffer ", 0
    msg2 db "Hello, ", 10, 0
    num db "142", 10, 0
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
    mov rdi, 0 ; exit code
    syscall


_start:

    print_flush

    call exit

