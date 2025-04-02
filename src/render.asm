%include "lib/grafics/draw_rect.asm"

_render:
    ; void framebufferFill(int {rcx})
    framebuffer_fill 0x0 ; black

    ; void drawImage(int* {rax}, int {rbx}, int {rcx}, int {r11})
    draw_image r9, 0, 0, [camera_coordinates]
    
    ; void drawImage(int* {rax}, int {rbx}, int {rcx}, int {r11})
    draw_image r10, 0x4f4, 0x250, 0

    ; void drawImage(int* {rax}, int {rbx}, int {rcx}, int {r11})
    draw_image r11, 0x10, 0x1dd, 0

    ; void drawImage(int* {rax}, int {rbx}, int {rcx}, int {r11})
    draw_image r11, 0xf40, 0x1dd, 0

    draw_rect 0xff0, 0x100, 0xf00, 0xf00, 0xFF0000

    ; camera = 0 then base = 0x10
    ; camera = 64 then

    framebuffer_flush

    ret