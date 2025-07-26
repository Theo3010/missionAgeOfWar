%ifndef PRINT_MEMORY
%define PRINT_MEMORY

%include "lib/io/print_hex.asm"
%include "lib/io/print_ascii_value.asm"

; void printMemory(void* {rax}, int {rbx}, int {rcx})
;   print the content at void* {rax} and the assostive address.
;   int {rbx} is the rows of memory
;   int {rcx} is the colums of memory
_printMemory:
    push rdx
    push r8

    mov rdx, rbx ; rows
    mov r8, rdx ; rows

_printMemoryLoopRow:
    print_hex rax ; address of memory
    print_ascii_value 58 ; :
    print_ascii_value 32 ; space
_printMemoryLoopCol:
    movzx rbx, byte [rax] ; get first byte
    print_hex rbx ; print memory
    print_ascii_value 32 ; space
    inc rax ; inc pointer
    dec rdx ; dec row
    jnz _printMemoryLoopCol
    mov rdx, r8 ; reset row count
    print_ascii_value 10 ; new line
    dec rcx ; dec column
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