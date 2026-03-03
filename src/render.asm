%include "lib/grafics/draw_rect.asm"
%include "lib/grafics/set_text.asm"
%include "lib/grafics/filter.asm"
%include "lib/mem/heap_free.asm"

%include "lib/to_string.asm"
%include "lib/world_cords.asm"

%include "lib/foreach.asm"

_render:
    push r10

    ; void framebufferFill(int {rcx})
    framebuffer_fill 0x0 ; black

    ; load images pointer
    mov r10, [imagesPointer] ; get pointer to images

    ; background
    draw_image [r10 + 8 * 0], 0, 0, 0b0 ; image, widthOffset, heightOffset, fliped

    ; draw base
    call _drawBase

    ; draw trops
    call _drawTroops

    ; draw menu
    call _drawHUD

    framebuffer_flush

    pop r10

    ret

_drawBase:

    ; base 1
    draw_image [r10 + 8 * 1], 0x10, 0x1dd, 0b0
    
    ; player health
    draw_rect 0x4e, 188, 28, 253, 0x0, 0b10 ; player health background
    
    mov rcx, [PlayerHealth]
    shr rcx, 1 
    mov rdx, 1
    cmp rcx, 0
    cmovle rcx, rdx 
    mov rax, 250
    sub rax, rcx ; 250 - current health
    add rax, 190
    
    draw_rect 0x50, rax, 25, rcx, 0x00FF0000, 0b10 ; player health bar
    
    to_string [PlayerHealth] ; uses the string buffer (a tempary place for strings), NOT the heap (no need for free.)
    set_text rax, 0x75, 205, 2, 0x00FF0000, 0b1 ; 

    mov rbx, [PlayerTurretSlotAmount]

_drawBasePlayerTurretLoop:

    cmp rbx, 0
    je _drawBasePlayerTurretLoopEnd

    mov rcx, 0x60
    imul rcx, rbx
    sub rcx, 0x22e
    neg rcx

    ; draw turret slots
    draw_image [r10 + 8 * 13], 0x85, rcx, 0b0

    dec rbx
    jmp _drawBasePlayerTurretLoop


_drawBasePlayerTurretLoopEnd:
    
    ; base 2
    draw_image [r10 + 8 * 1], 0x8a0, 0x1dd, 0b1
    draw_rect 0x8ee, 188, 28, 253, 0x0, 0b10 ; player health background

    mov rax, [EnemyBase]
    xor rdi, rdi
    mov edi, dword [rax+14] ; base health

    mov rcx, rdi
    shr rcx, 1 
    cmp rcx, 5
    jle _renderEnemyBaseNoDraw
    mov rax, 250
    sub rax, rcx ; 250 - current health
    add rax, 190

    draw_rect 0x8f0, rax, 25, rcx, 0x00FF0000, 0b10 ; enemy health bar
    
_renderEnemyBaseNoDraw:
    sub rdi, 10
    to_string rdi ; uses the string buffer (a tempary place for strings), NOT the heap (no need for free.)
    set_text rax, 0x8be, 205, 2, 0x00FF0000, 0b1

    ret

_drawTroopsLoop:
    push rax
    push rbx
    push rcx
    push rdx
    push r10

    movzx rcx, word [rax+8]

    xor rdx, rdx ; zero out register
    xor rbx, rbx ; zero out register

    mov rax, [rax] ; get unit data pointer
    mov bl, byte [rax] ; get unit type
    mov dl, byte [rax+15] ; get height offset
    shl bl, 3 ; multiply by 8 (size of each image pointer)

    mov rax, r10
    add al, bl
    neg rdx
    add rdx, 0x270


    draw_image [rax], rcx, rdx, 0

    pop r10
    pop rdx
    pop rcx
    pop rbx
    pop rax

    ret

_drawTroops:

    queue_peek [unitsSpawnedPtr], 1

    cmp rax, -1
    je _drawTroopsReturn ; if NULL, return


    foreach [unitsSpawnedPtr], _drawTroopsLoop

_drawTroopsReturn:

    ret


_drawHUD:
    
    ; background HUD
    draw_image [r10 + 8 * 2], 840, 0x0, 0b10

    ; resources HUD
    draw_image [r10 + 8 * 3], 0, 0, 0b10

    to_string [PlayerGold]
    set_text rax, 30, 16, 3, 0x00FFFF00, 0

    set_text _renderConst.expMsg, 10, 50, 2, 0x0, 0

    to_string [PlayerExp]
    set_text rax, 75, 45, 3, 0x00FF0000, 0
    
    ; mainMenu

    cmp byte [menuSelected], 1
    je _unitsMenu

    cmp byte [menuSelected], 2
    je _turretsMenu

    draw_image [r10 + 8 * 4], 900, 40, 0b10

    jmp _subMenuSkip

_unitsMenu:
    draw_image [r10 + 8 * 9], 1185, 40, 0b10

    draw_image [r10 + 8 * 6], 900, 40, 0b10

    jmp _subMenuSkip

_turretsMenu:
    draw_image [r10 + 8 * 9], 1185, 40, 0b10

    draw_image [r10 + 8 * 5], 900, 40, 0b10

_subMenuSkip:
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

    draw_image [r10 + 8 * 8], rax, 36, 0b10


    ; menu text
    set_text _renderConst.MainMenuMsg, 900, 10, 3, 0x00FFFF00, 0

    mov rax, [HUDbuttonmsgPtr] ; base text
    mov rbx, 0

    ; check if menuselected is 1
    cmp byte [menuSelected], 0
    jne _renderMenuTextConcatSkip
    ; check if menuhover is 2, 3

    cmp byte [menuHover], 3
    cmove rbx, [PlayerTurretSlotAmount]
    cmove ebx, dword [_turrets.TurretSlotCost+rbx*4]

    cmp byte [menuHover], 4
    cmove rbx, [PlayerAge]
    cmove ebx, dword [_ageData.expRequirement+rbx*4]

    cmp rbx, 0
    je _renderMenuTextConcatSkip
    
    push rax
    to_string rbx
    mov rbx, rax
    pop rax
    
    string_concat rbx, rax
    heap_free rax

_renderMenuTextConcatSkip:

    set_text rax, 215, 65, 2, 0x00FFFF00, 0

    ; units queue

    draw_rect 210, 15, 460, 10, 0x0, 0b1 ; bar
   
    draw_rect 690, 10, 20, 20, 0x0, 0b1 ; square
    draw_rect 720, 10, 20, 20, 0x0, 0b1 ; square 
    draw_rect 750, 10, 20, 20, 0x0, 0b1 ; square
    draw_rect 780, 10, 20, 20, 0x0, 0b1 ; square
    draw_rect 810, 10, 20, 20, 0x0, 0b1 ; square

    ; draw filled squares per unit in queue
    queue_length [unitQueue]

    mov rbx, 0 ; counters
_renderQueueLoop:

    cmp rbx, rax ; check if all units are drawn
    jge _renderQueueLoopEnd

    mov rdx, rbx
    imul rdx, 30 ; 30 pixels per unit
    add rdx, 691 ; x position of first square
    draw_rect rdx, 11, 19, 18, 0xc4c4c4, 0b0 ; square


    inc rbx
    jmp _renderQueueLoop

_renderQueueLoopEnd:

    queue_peek [unitQueue], 1
    cmp rax, -1
    je _renderQueueSpawnBarSkip
    cmp byte [unitSpawingTimer], 0
    je _renderQueueSpawnBarSkip

    mov rax, [rax]
    xor rcx, rcx
    mov cl, byte [rax+14]
    mov rax, 460
    xor rdx, rdx
    div rcx ; 460 / spawn time

    mov rbx, [unitSpawingTimer]
    inc rcx
    sub rcx, rbx ; total - current time
    mov rbx, rcx
    imul rbx, rax
    inc rbx
    draw_rect 210, 15, rbx, 10, 0x00FF0000, 0b0

_renderQueueSpawnBarSkip:

    ; special abilty
    set_text _renderConst.specialAbiltyMsg, 1055, 133, 2, 0x00FFFF00, 0

    draw_image [r10 + 8 * 10], 1185, 125, 0b10 ;

    mov rdx, [specialAbiltyCooldown]
    brightness 50, 0x275a1, rdx, 41, 1


    ret


_renderConst:

.expMsg:
    db "Exp: ", 0

.MainMenuMsg:
    db "Menu", 0

.specialAbiltyMsg:
    db "Special: ", 0
