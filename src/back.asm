%define PRINT_BUFFER_SIZE 1024

%include "lib/files/file_open.asm"
%include "lib/files/file_close.asm"
%include "lib/files/file_read.asm"

%include "lib/exit.asm"


section .data
    filename db "Termois.txt", 0

section .bss
    oldTermois resb 48

section .text
    global _start


_start:

    file_open filename, 0, 0644o

    file_read rax, oldTermois, 48

    mov rax, 16
	mov rdi, 0
	mov rsi, 0x5402
	mov rdx, oldTermois
	syscall

    file_close rax

    exit