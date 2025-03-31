%ifndef PRINTBINARY
%define PRINTBINARY

%include "lib/io/print_ascii_value.asm"

; void printBinary(int {rax})
;   prints the number in binary to the PRINT BUFFER
_printBinary:
    push rbx
    push rdx
    push rdi

    mov rbx, 0 ; counter

    mov rdi, rax
    
    ; to show number in binary (0b{number})
    mov rax, 48 ; 0
    call _printAsciiValue

    mov rax, 98 ; b
    call _printAsciiValue

    mov rax, rdi

_loopBinary:
    mov rdx, rax
    
    and rdx, 1 ; get first binary digit

    add rdx, 48

    push rdx
    inc rbx

    shr rax, 1

    cmp rax, 0
    jne _loopBinary

_loopBinaryAdd:
    pop rax
    call _printAsciiValue
    dec rbx

    cmp rbx, 0
    jne _loopBinaryAdd

    pop rdi
    pop rdx
    pop rbx

    ret


%macro print_binary 1

    push rax

    mov rax, %1
    call _printBinary

    pop rax

%endmacro


%endif