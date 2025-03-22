%ifndef GET_SCREENINFO
%define GET_SCREENINFO


; void getScreenInfo(int* {rax})
;   takes a pointer to memory and saves screeninfo at that memory.
_getScreenInfo:
    push rax
    push rdi
    push rsi
    push rdx

    file_open fbfileName, 2, 0644o

    mov rdi, rax
    mov rsi, 0x4600
    mov rdx, r10
    mov rax, 16
    syscall

    pop rdx
    pop rsi
    pop rdi
    pop rax

    ret

%macro get_screenInfo 1
    push r10

    mov r10, %1
    call _getScreenInfo

    pop r10
%endmacro

%endif