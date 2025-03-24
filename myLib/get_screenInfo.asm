%ifndef GET_SCREENINFO
%define GET_SCREENINFO


; void getScreenInfo(int* {rdx}, fd {rdi})
;   takes a pointer to memory and saves screeninfo at that memory.
_getScreenInfo:
    push rax
    push rsi

    mov rax, 16
    mov rsi, 0x4600
    syscall

    pop rsi
    pop rax

    ret

%macro get_screenInfo 2
    push rdi
    push rdx

    mov rdx, %1
    mov rdi, %2
    call _getScreenInfo

    pop rdx
    pop rdi
%endmacro

%endif