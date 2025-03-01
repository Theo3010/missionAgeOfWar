; input:
;   rax number to be printed
; output:
;   add number to print buffer

_printAsciiValue:
    push rcx

    mov rcx, PRINT_BUFFER
    add rcx, [PRINT_BUFFER_LENGTH]

    mov [rcx], rax

    mov rax, 1
    add [PRINT_BUFFER_LENGTH], rax
    
    pop rcx

    ret

%macro print_ascii_value 1
    push rax

    mov rax, %1
    call _printAsciiValue

    pop rax
%endmacro