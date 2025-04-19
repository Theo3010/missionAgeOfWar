%include "lib/grafics/draw_rect.asm"
%include "lib/grafics/set_text.asm"

_render:
    ; void framebufferFill(int {rcx})
    framebuffer_fill 0x0 ; black

    ; background
    draw_image [backgroundPointer], 0, 0, FALSE ; image, widthOffset, heightOffset, fliped

    ; draw base
    call _drawBase

    ; draw trops
    call _drawTroops

    ; draw menu
    call _drawHUD

    framebuffer_flush

    ret


_drawBase:

    ; base 1
    draw_image r11, 0x10, 0x1dd, FALSE
    ; base 2
    draw_image r11, 0x8a0, 0x1dd, TRUE

    ret

_drawTroops:

    draw_image r10, 0x170, 0x250, FALSE

    ret


_drawHUD:
    
    ; draw_image r12, 800, 0x50, FALSE

    ret

