%ifndef PRINT_HEX
%define PRINT_HEX

%include "myLib/print_ascii_value.asm"

; input:
;   rax - number to be add to BUFFER
; output:
;   Adds number - in hex - to the BUFFER
_printHex:

    push rbx
    push rdi
    push rdx

    mov rbx, 0 ; counter

    mov rdi, rax
    mov rax, 48
    call _printAsciiValue

    mov rax, 120
    call _printAsciiValue

    mov rax, rdi

_loopHex:
    mov rdx, rax
    
    and rdx, 15

    add rdx, 48
    cmp rdx, 58
    jl _skip
    add rdx, 39
_skip:

    push rdx
    inc rbx

    shr rax, 4

    cmp rax, 0
    jne _loopHex

_loopAdd:
    pop rax
    call _printAsciiValue
    dec rbx

    cmp rbx, 0
    jne _loopAdd

    pop rdx
    pop rdi
    pop rbx

    ret


%macro print_hex 1
    push rax

    mov rax, %1
    call _printHex

    pop rax
%endmacro


%endif