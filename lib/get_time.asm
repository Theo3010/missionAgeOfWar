
%ifndef GET_TIME
%define GET_TIME

; void getTime(int* {rdi})
;   get the time from system and places it in {time}
_getTime:
    push rax
    push rsi
    ; sys clobbered
    push rcx
    push r11

    mov rax, 96          ; Syscall number for gettimeofday
    xor rsi, rsi         ; NULL timezone argument
    syscall   

    pop r11
    pop rcx

    pop rsi
    pop rax


    ret


%macro get_time 1
    push rdi

    mov rdi, %1
    call _getTime

    pop rdi
%endmacro

%endif