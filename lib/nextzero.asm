%ifndef NEXTZERO
%define NEXTZERO


; void* {rax} nextZero(void* [rdi])
; moves pointer to the next zero in the heap
; if current pointer is zero, it returns -1
_nextZero:
    push rbx

_nextZeroLoop:
    mov al, byte [rdi] ; read header
    inc rdi ; move pointer to next byte

    cmp al, 0 ; check if it is zero
    jne _nextZeroLoop

    mov rbx, -1
    mov al, byte [rdi] ; read next byte
    cmp al, 0xff ; 0xff is end of list char.
    ; if it is end of list, return pointer
    cmovne rax, rdi
    ; else, return -1
    cmove rax, rbx

    pop rbx
    ret


%macro next_zero 1
    push rdi
    
    mov rdi, %1
    call _nextZero
    
    pop rdi
%endmacro


%endif