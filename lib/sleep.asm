%ifndef SLEEP
%define SLEEP

%include "lib/get_time.asm"

; void sleep(int {rax})
;   waits AT LEAST {rax} microsecounds
_sleep:
    ; clobbed
    push rbx
    push rdx

    ; save input
    push rax

    get_time time

    mov rax, [time]
    mov rdx, 1000000
    mul rdx
    add rax, [time+8]

    pop rbx
    add rbx, rax ; wait until rbx total microseconds reached

_loopSleep:

    get_time time

    mov rax, [time]
    mov rdx, 1000000
    mul rdx
    add rax, [time+8]

    cmp rbx, rax
    jge _loopSleep

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