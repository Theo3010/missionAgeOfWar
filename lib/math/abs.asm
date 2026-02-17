%ifndef ABS
%define ABS

; int {rax} abs(int {rax})
;   take a value and return the absolute value.
_abs:
    push rbx
    
    mov rbx, rax
    neg rax
    cmovl rax, rbx

    pop rbx
    ret

%macro abs 1
    mov rax, %1
    call _abs
%endmacro

%endif