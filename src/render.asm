%include "lib/grafics/draw_rect.asm"
%include "lib/grafics/set_text.asm"
%include "lib/mem/heap_free.asm"

%include "lib/to_string.asm"

_render:
    ; void framebufferFill(int {rcx})
    framebuffer_fill 0x0 ; black

    ; background
    draw_image [backgroundPointer], 0, 0, 0b0 ; image, widthOffset, heightOffset, fliped

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
    draw_image [basePtr1], 0x10, 0x1dd, 0b0
    ; base 2
    draw_image [basePtr1], 0x8a0, 0x1dd, 0b1

    ret

_drawTroops:

    draw_image r10, 0x170, 0x250, 0

    ret


_drawHUD:
    
    ; background HUD
    draw_image [HUDPtr], 840, 0x0, 0b10

    ; resources HUD
    draw_image [HUDresourcesPtr], 0, 0, 0b10

    mov qword [PlayerGold], 12
    to_string [PlayerGold]
    set_text rax, 30, 16, 8, 0x00FFFF00

    set_text .expMsg, 10, 50, 2, 0x0

    to_string [PlayerExp]
    set_text rax, 75, 45, 3, 0x00FF0000
    
    ; mainMenu
    draw_image [mainMenuPtr], 900, 40, 0b10

    set_text .MainMenuMsg, 900, 10, 3, 0x00FFFF00

    ; special abilty
    
    set_text .specialAbiltyMsg, 1055, 133, 2, 0x00FFFF00

    draw_image [specialAblityPtr], 1185, 125, 0b10 ;


    ret


.expMsg:
    db "Exp: ", 0

.MainMenuMsg:
    db "Menu", 0

.specialAbiltyMsg:
    db "Special: ", 0
