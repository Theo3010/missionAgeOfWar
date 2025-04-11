%ifndef SAVE_REGISTERS
%define SAVE_REGISTERS

_saveRegisters:

    mov [registers+0], rax
    mov [registers+8], rbx
    mov [registers+16], rcx
    mov [registers+24], rdx
    mov [registers+32], rsi
    mov [registers+40], rdi
    mov [registers+48], rsp
    mov [registers+56], r8
    mov [registers+64], r9
    mov [registers+72], r10
    mov [registers+80], r11
    mov [registers+88], r12
    mov [registers+96], r13
    mov [registers+104], r14
    mov [registers+112], r15
    ret

%macro save_registers 0
    call _saveRegisters
%endmacro

%endif