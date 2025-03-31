_drawMain:
    ; get_time

    ; void framebufferFill(int {rcx})
    framebuffer_fill 0x0 ; black

    ; void drawImage(int* {rax}, int {rbx}, int {rcx}, int {r11})
    draw_image r9, 0, 0, [screen_coordinates]
    
    ; void drawImage(int* {rax}, int {rbx}, int {rcx}, int {r11})
    draw_image r10, 0x40, 0x250, 0

    framebuffer_flush

    ret