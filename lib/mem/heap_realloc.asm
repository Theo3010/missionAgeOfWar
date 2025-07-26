%ifndef HEAP_REALLOC
%define HEAP_REALLOC

%include "lib/mem/heap_allocate.asm"
%include "lib/mem/heap_free.asm"
%include "lib/mem/memory_copy.asm"
%include "lib/math/min.asm"

; int* {rax} heapRealloc(int* {rax}, int {rbx})
;   Takes a pointer to memory as input in {rax} and the new total size of memory in {rbx}
;   returns pointer to memory
_heapRealloc:

    push rcx
    push rdx
    push r8

    mov rcx, rax ; save the old pointer

    ; allocate rbx memory
    heap_allocate rbx
    mov r8, rbx ; save size of new memory

    ; copy elements from old pointer to new
    ; get size of old memory
    sub rcx, 8 ; move to header
    mov rdx, [rcx] ; read header
    ; remove flags
    mov rbx, rdx
    and rbx, 7
    sub rdx, rbx
    
    add rcx, 8 ; return from header.

    mov rbx, rax

    ; rdx can max be the size of the new memory
    min rdx, r8 ; ensure we don't copy more than the new size
    mov rdx, rax

    memory_copy rcx, rbx, rdx ; copy memory from rcx to rax with length of rdx.
    
    ; free old memory
    heap_free rcx
    
    ; return pointer to new memory
    mov rax, rbx

    pop r8
    pop rdx
    pop rcx

    ret



%macro heap_realloc 2
    push rbx

    mov rax, %1
    mov rbx, %2
    call _heapRealloc

    pop rbx
%endmacro

%endif