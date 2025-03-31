%ifndef GET_INPUT
%define GET_INPUT
; void _getInput(int* {rsi}, int {rdx});
;   gets input from terinal and save in {rsi}, reads {rdx} characters
_getInput:

    push rax
    push rdi

    push rcx
    push r11

    mov rax, 0
    mov rdi, 0
    syscall

    pop r11
    pop rcx

    pop rdi
    pop rax

    ret


%macro get_input 2
    push rsi
    push rdx

    mov rsi, %1
    mov rdx, %2
    call _getInput

    pop rdx
    pop rsi
%endmacro


%endif