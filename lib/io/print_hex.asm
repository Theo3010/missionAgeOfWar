%ifndef PRINT_HEX
%define PRINT_HEX

%include "lib/io/print_ascii_value.asm"

; void printHex(int {rax})
;   prints the number in hexdecimal to the PRINT BUFFER
_printHex:
    push rbx
    push rdi
    push rdx

    mov rbx, 0 ; counter

    ; show that the number is in hex (0x{number})
    mov rdi, rax ; save number
    mov rax, 48 ; 0
    call _printAsciiValue

    mov rax, 120 ; x
    call _printAsciiValue

    mov rax, rdi

_loopHex:
    mov rdx, rax
    
    and rdx, 15 ; get the first hexdecimal digit

    add rdx, 48
    cmp rdx, 58 ; 0-9
    jl _skip
    add rdx, 39 ; a-f
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