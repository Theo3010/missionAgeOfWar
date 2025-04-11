%include "lib/grafics/draw_rect.asm"

_render:
    ; void framebufferFill(int {rcx})
    framebuffer_fill 0x0 ; black

    ; void drawImage(int* {rax}, int {rbx}, int {rcx})
    draw_image r9, 0, 0
    
    ; void drawImage(int* {rax}, int {rbx}, int {rcx})
    draw_image r10, 0x145, 0x250

    ; void drawImage(int* {rax}, int {rbx}, int {rcx})
    draw_image r11, 0x10, 0x1dd

    ; void drawImage(int* {rax}, int {rbx}, int {rcx})
    draw_image r11, 0x8a0, 0x1dd

    ; mov r13, [camera_coordinates]
    ; save_registers

    mov rbx, 120
    sub rbx, [camera_coordinates]
    cmp rbx, 0
    jle _skipRect
    draw_rect 230, rbx, 30, 250
_skipRect:

    framebuffer_flush

    ret