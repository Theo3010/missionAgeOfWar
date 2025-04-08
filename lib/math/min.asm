%ifndef MIN
%define MIN

; int {rax} min(int {rax}, int {rbx})
;   return the lesser
_min:
    cmp rax, rbx
    jle _Minfirst

    mov rax, rbx
    ret

_Minfirst: 
    ret


%macro min 2
    push rbx

    mov rax, %1
    mov rbx, %2
    call _min

    pop rbx
%endmacro

%endif