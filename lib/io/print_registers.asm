%ifndef PRINT_REGISTERS
%define PRINT_REGISTERS

_printRegisters:

    push rax
    push rbx
    push rcx
    push rdx

    mov rbx, 0 ; count

_printRegistersLoop:
    mov rax, 6
    mul rbx
    mov rcx, .registers
    add rcx, rax 
    print rcx
    
    mov rax, 8
    mul rbx
    print_hex [registers+rax]
    print_ascii_value 10

    inc rbx
    cmp rbx, 15
    jne _printRegistersLoop

    pop rdx
    pop rcx
    pop rbx
    pop rax

    ret


.registers:
    db "rax: ", 0
    db "rbx: ", 0
    db "rcx: ", 0
    db "rdx: ", 0
    db "rsi: ", 0
    db "rdi: ", 0
    db "rsp: ", 0
    db "r8 : ", 0
    db "r9 : ", 0
    db "r10: ", 0
    db "r11: ", 0
    db "r12: ", 0
    db "r13: ", 0
    db "r14: ", 0
    db "r15: ", 0


%macro print_registers 0
    call _printRegisters
%endmacro

%endif