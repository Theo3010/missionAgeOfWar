%ifndef SLEEP
%define SLEEP

%include "lib/get_time.asm"

; void sleep(int {rax})
;   waits AT LEAST {rax} microsecounds
_sleep:
    push rbx
    push rdx

    push rcx
    push r11
    
    ; Convert microseconds to timespec
    mov rbx, 1000000
    xor rdx, rdx
    div rbx                         ; rax = seconds, rdx = μs remainder
    
    mov [time], rax       ; store seconds
    mov rax, rdx                    ; get remainder
    mov rbx, 1000
    mul rbx                         ; convert to nanoseconds
    mov [time + 8], rax   ; store nanoseconds
    
    ; Call nanosleep
    mov rax, 35                     ; SYS_nanosleep  
    mov rdi, time
    mov rsi, 0
    syscall

    pop r11
    pop rcx
    
    pop rdx
    pop rbx
    ret


%macro sleep 1
    push rax

    mov rax, %1
    call _sleep

    pop rax
%endmacro

%endif