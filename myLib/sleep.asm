%include "myLib/get_time.asm"

; input
;   rax - microseconds to sleep
_sleep:
    ; clobbed
    push rbx
    push rdx

    ; save input
    push rax

    get_time

    mov rax, [time]
    mov rdx, 1000000
    mul rdx
    add rax, [time+8]

    pop rbx
    add rbx, rax ; wait until rbx total microseconds reached

_loopSleep:

    get_time

    mov rax, [time]
    mov rdx, 1000000
    mul rdx
    add rax, [time+8]

    cmp rbx, rax
    jge _loopSleep

    pop rbx
    pop rdx

    ret


%macro sleep 1
    push rax

    mov rax, %1
    call _sleep

    pop rax
%endmacro