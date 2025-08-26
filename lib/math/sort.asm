%ifndef SORT
%define SORT

%include "lib/nextzero.asm"

; void* {rax} sort(void* {rdi})
; sorts the heap memory in ascending order and return the new pointer
_sort:

    push rbx
    push rcx
    push rdx
    push rsi
    push r8
    push r9

    mov rax, rdi
    sub rax, 8
    mov rbx, qword [rax] ; header
    and rbx, 0xfffffffffffffff8 ; remove flags

    ; allocate new memory
    heap_allocate rbx
    mov r8, rax ; new base memory pointer
    mov r9, rax ; memory pointer for current element

    ; base pointer
    mov rsi, rdi

    ; lowest candiate
    mov rdx, rdi

_sortLoop:

    mov bh, byte [rdi] ; current element byte 1
    mov bl, byte [rdi + 1] ; current element byte 2

    mov ch, byte [rdx] ; lowest candiate byte 1
    mov cl, byte [rdx + 1] ; lowest candiate byte 2

    ; cmp lowest candiate with current
    cmp bx, cx
    jge _sortLoopNext

    mov rdx, rdi ; set lowest to current

_sortLoopNext:

    ; get next element
    next_zero rdi
    mov rdi, rax
    cmp rdi, -1 ; end of list
    je _sortLoopCopy

    jmp _sortLoop


_sortLoopCopy:


    ; if the lowest candiate is 0x4040 the sorting is done
    cmp word [rdx], 0x4040
    je _sortDone

    ; get the length of the string
    string_length rdx
    mov rcx, rax
    ; move the lowest candiate to the new memory
    memory_copy rdx, r9, rcx
    mov byte [r9 + rcx], 0 ; 0-terminated string.
    add r9, rcx
    add r9, 1 ; for the 0 char

    ; set the lowest candiate to 0x4040 (first non-digit ascii value '@')
    mov word [rdx], 0x4040

    ; go back to the start of list
    mov rdi, rsi
    jmp _sortLoop


_sortDone:

    heap_free rsi ; free old pointer

    mov rax, r8 ; return the new memory pointer

    pop r9
    pop r8
    pop rsi
    pop rdx
    pop rcx
    pop rbx

    ret

%macro sort 1
    push rdi

    mov rdi, %1
    call _sort

    pop rdi
%endmacro

%endif