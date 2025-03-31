
%ifndef GET_TIME
%define GET_TIME

_getTime:
    push rax
    push rdi
    push rsi
    ; sys clobbered
    push rcx
    push r11

    mov rax, 96          ; Syscall number for gettimeofday
    mov rdi, time       ; Pointer to the struct timeval
    xor rsi, rsi         ; NULL timezone argument
    syscall   

    pop r11
    pop rcx

    pop rsi
    pop rdi
    pop rax


    ret


%macro get_time 0
    call _getTime
%endmacro

%endif