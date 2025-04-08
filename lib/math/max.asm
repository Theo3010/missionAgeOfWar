%ifndef MAX
%define MAX

; int {rax} max(int {rax}, int {rbx})
;   return the greater
_max:
    cmp rax, rbx
    jge _Maxfirst

    mov rax, rbx
    ret

_Maxfirst: 
    ret


%macro max 2
    push rbx

    mov rax, %1
    mov rbx, %2
    call _max

    pop rbx
%endmacro

%endif