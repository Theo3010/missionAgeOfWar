%ifndef MIN
%define MIN

; int {rax} min(int {rax}, int {rbx})
;   return the lesser
_min:
    cmp rax, rbx
    jle _first

    mov rax, rbx
    ret

_first: 
    ret


%macro min 2
    push rbx

    mov rax, %1
    mov rbx, %2
    call _min

    pop rbx
%endmacro

%endif