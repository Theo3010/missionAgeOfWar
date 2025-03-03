

_getInput:

    push rdi

    mov rax, 0
    mov rdi, 0
    syscall

    pop rdi

    ret


%macro get_input 2

    push rax
    push rsi

    mov rsi, %1
    mov rdx, %2
    call _getInput

    push rsi
    push rax

%endmacro