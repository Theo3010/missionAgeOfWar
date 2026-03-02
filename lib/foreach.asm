%ifndef FOREACH
%define FOREACH

%include "lib/queue.asm"

; void foreach(void* {rax}, func {rbx})
;   take a pointer to an array of element size 8 and applies the func to each element
;   param: pointer to array and a function(void* {rax})
;   return: void

_foreach:

    push rcx
    push rdx
    push r8

    mov r8, rbx

    mov rcx, rax
    queue_length rcx
    mov rdx, rax ; length of queue
    mov rbx, 1 ; counter

_foreachLoop:
    queue_peek rcx, rbx ; get element
    call r8 ; call func(void* {rax}, int {rbx}, Queue {rcx}) | where {rax} is the element in queue and {rbx} is the index

    inc rbx
    cmp rbx, rdx
    jle _foreachLoop

    pop r8
    pop rdx
    pop rcx

    ret


%macro foreach 2
    push rax
    push rbx

    mov rax, %1
    mov rbx, %2
    call _foreach

    pop rbx
    pop rax

%endmacro

%endif