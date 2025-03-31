%ifndef GET_SCREENINFO
%define GET_SCREENINFO


; int {rax} getScreenInfo(int* {rdx}, fd {rdi})
;   takes a pointer to memory and saves screeninfo at that memory.
;   returns the amount of bits per pixel
_getScreenInfo:
    push rbx
    push rsi

    mov rax, 16
    mov rsi, 0x4600
    syscall

    mov rbx, 0
    mov ebx, [framebufferInfo+0]
    imul ebx, [framebufferInfo+4]
    imul ebx, [framebufferInfo+24]
    shr ebx, 3
    mov rax, rbx

    pop rsi
    pop rbx

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