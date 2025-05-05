%ifndef COLORCOPY
%define COLORCOPY

; void _colorCopy(int* {rax}, int* {rbx}, int {rcx}, boolean {r12})
;   takes a pointer to memory in {rax} source and a pointer to memory in {rbx} destination and the number of pixels {rcx}. fliped {r12}
_colorCopy:
    push rdx
    push r8

_colorCopyLoop:
    ; take element from rax
    mov edx, dword [rax]

    ; check alpha
    test edx, 0xFF000000
    je _colorCopySkip

    ; place ement at rbx
    mov dword [rbx], edx

_colorCopySkip:
    call _movePointer ; move pointers
    
    dec rcx
    jnz _colorCopyLoop

    pop r8
    pop rdx
    ret


_movePointer:
    add rbx, 4
    
    cmp r12, TRUE
    je _flipedMove
    
    add rax, 4

    ret

_flipedMove:
    sub rax, 4

    ret


%macro color_copy 4
    push rax
    push rbx
    push rcx

    mov rax, %1
    mov rbx, %2
    mov rcx, %3
    mov r12, %4
    call _colorCopy

    pop rcx
    pop rbx
    pop rax
%endmacro

%endif