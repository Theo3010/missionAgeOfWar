%ifndef MEMORY_COPY
%define MEMORY_COPY

; void memoryCopy(int* {rax}, int* {rbx}, int {rcx})
;   takes a pointer to memory in {rax} source and a pointer to memory in {rbx} destination and size of memory to copy in {rcx}
_memoryCopy:

    mov rdx, 0
    ; take element from rax
    mov dl, byte [rax]
    inc rax ; move pointer

    ; place ement at rbx
    mov byte [rbx], dl
    inc rbx ; move pointer
    ; dec rcx
    dec rcx
    jnz _memoryCopy

    ret


; TODO: this can be optimized, no need for 6 registers
%macro memory_copy 3
    push rax
    push rbx
    push rcx

    mov r8, %1
    mov r9, %2
    mov r10, %3

    mov rax, r8
    mov rbx, r9
    mov rcx, r10
    call _memoryCopy

    pop rcx
    pop rbx
    pop rax
%endmacro


%endif
