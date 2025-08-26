%ifndef IOCTL
%define IOCTL


; void ioctl(int fd, unsigned long request, ...);
;   fd: file descriptor
;   request: request code
;   ...: additional arguments depending on request code

_ioctl:
    push rax

    mov rax, 16 ; syscall number for ioctl
    syscall

    pop rax
    ret


%macro ioctl 3

    push rdi
    push rsi
    push rdx

    mov rdi, %1 ; file descriptor
    mov rsi, %2 ; request code
    mov rdx, %3 ; additional argument (if any)
    call _ioctl

    pop rdx
    pop rsi
    pop rdi

%endmacro

%endif