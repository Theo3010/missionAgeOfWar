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
    
    ; player health
    draw_rect 0x23, 188, 28, 253, 0x0, 0
    
    mov rcx, [PlayerHealth]
    shr rcx, 1 
    mov rdx, 1
    cmp rcx, 0
    cmovle rcx, rdx 
    mov rax, 250
    sub rax, rcx ; 250 - current health
    add rax, 190
    
    draw_rect 0x25, rax, 25, rcx, 0x00FF0000, 0 

    to_string [PlayerHealth]
    set_text rax, 0x45, 205, 2, 0x00FF0000
    
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

    to_string [PlayerGold]
    set_text rax, 30, 16, 3, 0x00FFFF00

    set_text _renderConst.expMsg, 10, 50, 2, 0x0

    to_string [PlayerExp]
    set_text rax, 75, 45, 3, 0x00FF0000
    
    ; mainMenu

    cmp byte [menuSelected], 1
    je _unitsMenu

    draw_image [mainMenuPtr], 900, 40, 0b10

    jmp _unitsMenuSkip

_unitsMenu:
    draw_image [backMenuButtonPtr], 1185, 40, 0b10

    draw_image [AgeUnitsPtr], 900, 40, 0b10

_unitsMenuSkip:
    mov rbx, [menuHover] 
    cmp rbx, 3
    jne _menuNotSkipThree

    mov rax, rbx
    inc rax

    cmp byte [menuSelected], 1
    cmove rbx, rax

    cmp byte [menuSelected], 2
    cmove rbx, rax

_menuNotSkipThree:
    mov rax, 895
    imul rbx, 73
    add rax, rbx

    draw_image [buttonHoverPtr], rax, 36, 0b10

    set_text _renderConst.MainMenuMsg, 900, 10, 3, 0x00FFFF00

    set_text [HUDbuttonmsgPtr], 215, 65, 2, 0x00FFFF00

    ; units queue
    draw_rect 210, 15, 460, 10, 0x0, 1

    draw_rect 690, 10, 20, 20, 0xc4c4c4, 0 
    draw_rect 690, 10, 20, 20, 0x0, 1 
    draw_rect 720, 10, 20, 20, 0x0, 1 
    draw_rect 750, 10, 20, 20, 0x0, 1 
    draw_rect 780, 10, 20, 20, 0x0, 1 
    draw_rect 810, 10, 20, 20, 0x0, 1 


    ; special abilty
    set_text _renderConst.specialAbiltyMsg, 1055, 133, 2, 0x00FFFF00

    draw_image [specialAblityPtr], 1185, 125, 0b10 ;


    ret


_renderConst:

.expMsg:
    db "Exp: ", 0

.MainMenuMsg:
    db "Menu", 0

.specialAbiltyMsg:
    db "Special: ", 0
