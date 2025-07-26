%ifndef STRINGCONCAT
%define STRINGCONCAT

%include "lib/io/string_length.asm"
%include "lib/mem/heap_allocate.asm"
%include "lib/mem/memory_copy.asm"

; char* rax string_concat(char* {rbx}, char* {rcx})
_stringConcat:
    push rdx
    push r8
    push r9
    push r10

    string_length rbx ; find length of word 1
    mov rdx, rax
    string_length rcx ; find length of word 2
    mov r9, rax

    ; total_length
    mov r8, rdx
    add r8, r9 ; total_legnth
    heap_allocate r8
    mov r10, rax ; new ptr

    memory_copy rbx, r10, rdx
    add r10, rdx
    memory_copy rcx, r10, r9

    sub r10, rdx ; go back to start of string
    mov rax, r10 ; return ptr to new string

    pop r10
    pop r9
    pop r8
    pop rdx

    ret

%macro string_concat 2
    push rbx
    push rcx
    
    mov rbx, %1
    mov rcx, %2
    call _stringConcat


    pop rcx
    pop rbx
%endmacro

%endif