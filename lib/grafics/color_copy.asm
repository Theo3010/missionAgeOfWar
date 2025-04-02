%ifndef COLORCOPY
%define COLORCOPY

; void _colorCopy(int* {rax}, int* {rbx}, int {rcx})
;   takes a pointer to memory in {rax} source and a pointer to memory in {rbx} destination and size of memory to copy in {rcx}
_colorCopy:
    push rdx
    push r8

_colorCopyLoop:
    ; take element from rax
    mov edx, dword [rax]
    add rax, 4 ; move pointer

    ; check alpha
    mov r8, rdx    
    and r8, 0xFF
    cmp r8, 0
    je _colorCopySkip

    ; place ement at rbx
    mov dword [rbx], edx
_colorCopySkip:
    add rbx, 4 ; move pointer
    
    ; dec rcx
    sub rcx, 4
    jnz _colorCopyLoop

    pop r8
    pop rdx
    ret

%macro color_copy 3
    push rax
    push rbx
    push rcx

    mov rax, %1
    mov rbx, %2
    mov rcx, %3
    call _colorCopy

    pop rcx
    pop rbx
    pop rax
%endmacro

%endif