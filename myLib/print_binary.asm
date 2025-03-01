%include "myLib/print_ascii_value.asm"

_printBinary:
    push rbx
    push rdx
    push rdi

    mov rbx, 0 ; counter

    mov rdi, rax
    
    mov rax, 48
    call _printAsciiValue

    mov rax, 98
    call _printAsciiValue

    mov rax, rdi

_loopBinary:
    mov rdx, rax
    
    and rdx, 1

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