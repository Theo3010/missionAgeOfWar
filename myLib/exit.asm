%ifndef EXIT
%define EXIT

_exit:
    mov rax, 60 ; sys_exit
    mov rdi, 0 ; exit code. zero = succes
    syscall


%macro exit 0
    jmp _exit
%endmacro

%endif