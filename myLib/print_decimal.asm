%ifndef PRINT_DECIMAL
%define PRINT_DECIMAL

%include "myLib/print_ascii_value.asm"

; input:
;   rax number to be printed
; output:
;   add number to print buffer

_printDecimal:
    push rax
    push rbx
    push rdx
    push r10

    mov rbx, 0 ; counter

_loopDigit:
    mov rdx, 0
    
    mov r10, 10
    div r10 ; div rax with 10 = 14 | 2

    add rdx, 48

    push rdx
    inc rbx
    
    cmp rax, 0
    je _loopAddBuffer

    jmp _loopDigit

_loopAddBuffer:
    pop rax ; get number of stack
    call _printAsciiValue

    dec rbx ; counter
    cmp rbx, 0
    jne _loopAddBuffer

    pop r10
    pop rdx
    pop rbx
    pop rax

    ret

%macro print_decimal 1
    push rax

    mov rax, %1
    call _printDecimal

    pop rax
%endmacro

%endif