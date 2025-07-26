%ifndef MEMORY_COPY
%define MEMORY_COPY

; void memoryCopy(int* {rax}, int* {rbx}, int {rcx})
;   takes a pointer to memory in {rax} source and a pointer to memory in {rbx} destination and size of memory to copy in {rcx}
_memoryCopy:
    push rdx

_memoryCopyLoop:
    mov rdx, 0
    ; take element from rax
    mov dl, byte [rax]
    inc rax ; move pointer

    ; place ement at rbx
    mov byte [rbx], dl
    inc rbx ; move pointer
    ; dec rcx
    dec rcx
    jnz _memoryCopyLoop

    pop rdx
    ret


%macro memory_copy 3
    push rax
    push rbx
    push rcx

    mov rax, %1
    mov rbx, %2
    mov rcx, %3
    call _memoryCopy

    pop rcx
    pop rbx
    pop rax
%endmacro


%endif
