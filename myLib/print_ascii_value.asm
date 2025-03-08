; set a default buffer size if not set.
%ifndef PRINT_BUFFER_SIZE
%define PRINT_BUFFER_SIZE 1024
%endif


; stop multiple defintion error
%ifndef PRINT_ASCII_VALUE
%define PRINT_ASCII_VALUE

%include "myLib/print_flush.asm"

; input:
;   rax number to be printed
; output:
;   add number to print buffer

_printAsciiValue:
    push rbx
    push rcx

    mov rcx, PRINT_BUFFER
    add rcx, [PRINT_BUFFER_LENGTH]

    mov [rcx], rax

    mov rax, 1
    add [PRINT_BUFFER_LENGTH], rax
    
    mov rax, PRINT_BUFFER_SIZE ; total size
    mov rbx, [PRINT_BUFFER_LENGTH] ; current length
    sub rax, rbx ; calculate space left
    cmp rax, 10 ; if within 10 chars left, flush
    jge _noFlush
    
    call _printFlush

_noFlush:
    pop rcx
    pop rbx

    ret

%macro print_ascii_value 1
    push rax

    mov rax, %1
    call _printAsciiValue

    pop rax
%endmacro

%endif
