%ifndef PRINT_MEMORY
%define PRINT_MEMORY

%include "myLib/print_hex.asm"
%include "myLib/print_ascii_value.asm"

; void printMemory(int* {rax}, int {rbx}, int {rcx})
;   print the content at int* {rax} and the assostive address.
;   int {rbx} is the rows of memory
;   int {rcx} is the colums of memory
_printMemory:
    push rdx
    push r8

    mov rdx, rbx
    mov r8, rdx

_printMemoryLoopRow:
    print_hex rax
    print_ascii_value 58
    print_ascii_value 32
_printMemoryLoopCol:
    movzx rbx, byte [rax]
    print_hex rbx
    print_ascii_value 32
    inc rax
    dec rdx
    jnz _printMemoryLoopCol
    mov rdx, r8
    print_ascii_value 10
    dec rcx
    jnz _printMemoryLoopRow

    pop r8
    pop rdx

    ret

%macro print_memory 3
    push rax
    push rbx
    push rcx

    mov rax, %1
    mov rbx, %2
    mov rcx, %3
    call _printMemory

    pop rcx
    pop rbx
    pop rax
%endmacro

%endif