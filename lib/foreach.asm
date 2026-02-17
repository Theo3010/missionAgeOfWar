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

    mov rcx, rax
    queue_length rcx
    mov rdx, rax ; length of queue

_foreachLoop:
    queue_pop rcx ; get element
    mov r8, rax
    queue_add rcx, r8 ; add back the element
    call rbx ; call func

    dec rdx
    jnz _foreachLoop

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