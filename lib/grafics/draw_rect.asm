%ifndef DRAWRECT
%define DRAWRECT

; void drawRect(int {rax}, int{rdx}, int {rbx}, int {rcx})
;   draws a rect with offset {rax}x{rbx} and size {rbx}x{rcx}
_drawRect:

    push rbx

    shl rax, 2
    push rdx ; mul cloober rdx
    mul qword [fb_width]
    pop rdx

    shl rdx, 2
    add rax, rdx

    mov rbx, rax
    mov rax, [screen_Buffer_address]
    add rax, rbx

    pop rbx

    mov r8, rbx ; copy of row

_drawRectLoop:
    mov dword [rax], 0xFF0000
    add rax, 4
    dec rbx
    jnz _drawRectLoop
    
    ; \r
    mov rbx, r8
    shl rbx, 2
    sub rax, rbx ; 

    ; \n
    mov rbx, [fb_width]
    shl rbx, 2
    add rax, rbx

    ; reset row count
    mov rbx, r8

    dec rcx
    jnz _drawRectLoop

    ret

%macro draw_rect 4

    mov rax, %1
    mov rdx, %2
    mov rbx, %3
    mov rcx, %4
    call _drawRect
%endmacro

%endif