
%ifndef HEAP_FREE
%define HEAP_FREE


; void heapFree(int* {rax})
;   frees memory alloced at {rax}
_heapFree:
    push rbx
    push rcx
    push rdx

    ; get header
    sub rax, 8
    mov r10, rax ; base header pointer save
    ; get size
    mov rbx, [rax]
    mov rdx, -1
    shl rdx, 3
    and rbx, rdx
    
    ; check header before
    
    sub rax, 8 ; footer of the one behind

    ; check out of bounce
    cmp rax, HEAP
    jl _nextMemoryCheck

    mov rdx, [rax] ; get the size of the one behind

    mov rcx, rdx
    and rcx, 7
    cmp rcx, 0
    jne _nextMemoryCheck

    sub rax, rdx 
    sub rax, 8 ; get header
    mov r10, rax

    add rbx, rdx ; add size of the one behind
    add rbx, 16

_nextMemoryCheck:
    ; check header after
        ; check for out of bounce
    mov rax, r10 ; load base header pointer
    add rax, rbx
    add rax, 16
    mov rdx, [rax]
    mov rcx, rdx
    and rcx, 7
    cmp rcx, 0
    jne _skipMemoryAdd
        ; add space if free
    add rbx, rdx ; add space

    add rbx, 16


_skipMemoryAdd:
    mov rax, r10 ; load base header pointer
    ; set header and footer
    mov [rax], rbx
    add rax, rbx
    add rax, 8
    mov [rax], rbx


    pop rdx
    pop rcx
    pop rbx
    ret

%macro heap_free 1
    push rax

    mov rax, %1
    call _heapFree
    
    pop rax
%endmacro

%endif