
%ifndef GET_TIME
%define GET_TIME

_getTime:
    mov rax, 96          ; Syscall number for gettimeofday
    mov rdi, time       ; Pointer to the struct timeval
    xor rsi, rsi         ; NULL timezone argument
    syscall   

    ret


%macro get_time 0
    call _getTime
%endmacro

%endif