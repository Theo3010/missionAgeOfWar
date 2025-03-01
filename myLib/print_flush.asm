; output:
;   writes the PRINT BUFFER to the terminal
_printFlush:
    push rax
    push rcx
    push rdx
    push rdi
    push rsi

    ; print msg
    mov rax, 1
    mov rdi, 1
    mov rsi, PRINT_BUFFER
    mov rdx, [PRINT_BUFFER_LENGTH]
    syscall

    mov rax, 0
    mov [PRINT_BUFFER_LENGTH], rax

    pop rsi
    pop rdi
    pop rdx
    pop rcx
    pop rax

    ret

%macro print_flush 0
    call _printFlush
%endmacro