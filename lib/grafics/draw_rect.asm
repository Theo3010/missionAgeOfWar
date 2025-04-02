%ifndef DRAWRECT
%define DRAWRECT

; void drawRect(int {rax}, int {rbx}, int {rcx}, int {rdx}, {r8})
;   draws a rect with offset {rax}x{rbx} size in {rcx}x{rdx}, with color {r8}
_drawRect:

    push r9
    push r10

    mov r9, [screen_Buffer_address]
    
    push rdx

    ; shl rbx, 2
    ; imul rbx, [fb_width]
    add r9, rbx

    pop rdx

    add r9, rax ; add offset

_drawRectLoopCol:
    mov r10, rcx
_drawRectLoopRow:
    mov dword [r9], r8d ; write color
    inc r9
    dec r10 ; dec width
    jnz _drawRectLoopRow
    
    sub r9, rcx ; goto start of square \r
    add r9, [fb_width] ; goto next screen row. \n

    dec rdx ; dec height
    jnz _drawRectLoopCol

    pop r10
    pop r9

    ret

%macro draw_rect 5
    push rax
    push rbx
    push rcx
    push rdx
    push r8

    mov rax, %1
    mov rbx, %2
    mov rcx, %3
    mov rdx, %4
    mov r8, %5
    call _drawRect

    pop r8
    pop rdx
    pop rcx
    pop rbx
    pop rax

%endmacro

%endif