%ifndef CLOCK_TICK
%define CLOCK_TICK

%include "lib/get_time.asm"

; bool {rax} clockTick(int {rbx})
;   takes fps {rbx}
;   returns true (non-zero) if next frame can begin else false (0)
_clockTick:
    push rdx

    ; 1/{rbx}
    mov rax, 1000000
    xor rdx, rdx ; used by div
    div rbx ; rax = 1 / rbx
    mov rbx, rax

    ; load time
    mov rax, [clock_time] ; secounds
    mov rdx, 1000000
    mul rdx
    add rax, [clock_time+8] ; microsecounds

    ; add offset
    add rbx, rax

    get_time time
    
    ; load new time
    mov rax, [time] ; secounds
    mov rdx, 1000000
    mul rdx
    add rax, [time+8] ; microsecounds

    ; if time passed
    cmp rax, rbx
    jl _timeNotPassed

    get_time clock_time
    
    mov rax, 1 ; return true
    jmp _clockTickReturn

    ; else
_timeNotPassed:
    xor rax, rax ; return false
    jmp _clockTickReturn

_clockTickReturn:
    pop rdx
    ret


%macro clock_tick 1
    push rbx

    mov rbx, %1
    call _clockTick

    pop rbx
%endmacro

%endif