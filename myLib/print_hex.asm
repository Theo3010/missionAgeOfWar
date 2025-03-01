; input:
;   rax - number to be add to BUFFER
; output:
;   Adds number - in hex - to the BUFFER
_printHex:
    mov rax, 142
    mov rbx, 0 ; counter
    mov rcx, PRINT_BUFFER
    add rcx, [PRINT_BUFFER_LENGTH]

    mov rdi, 48
    mov [rcx], rdi ; 0
    inc rcx

    mov rdi, 120
    mov [rcx], rdi ;x => 0x...
    inc rcx

    mov rdi, 2
    add [PRINT_BUFFER_LENGTH], rdi

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
    mov [rcx], rax

    mov rdi, 1
    add [PRINT_BUFFER_LENGTH], rdi
   
    inc rcx
    dec rbx

    cmp rbx, 0
    jne _loopAdd

    ret


%macro print_hex 1
    push rax

    mov rax, %1
    call _printHex

    pop rax
%endmacro