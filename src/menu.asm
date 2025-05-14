%include "lib/io/string_length.asm"

_menuSelect:

    cmp byte [menuSelected], 0
    je _menuMainSelector 

    cmp byte [menuSelected], 1
    je _menuUnitSelector 

    ret

_menuMainSelector:
    ; if menuHover = 0
    mov al, [menuSelected]
    mov rbx, 1
    
    cmp byte [menuHover], 0
    ; open unit menu 
    cmove rax, rbx
    mov [menuSelected], al

    ; elif 1
    cmp byte [menuHover], 1
    ; open buy tower menu
    ; je _menuOpenBuyTower

    ; elif 2
    cmp byte [menuHover], 2
    ; open sell tower menu
    ; je _menuOpenSellTower

    ; elif 3
    cmp byte [menuHover], 3
    ; buy tower slot
    ; je _menuBuyTowerSlot

    ; elif 4
    cmp byte [menuHover], 4
    ; next age
    je _menuNextAge

    ret

_menuUnitSelector:

    cmp byte [menuHover], 0
    ; unit 1

    cmp byte [menuHover], 1
    ; unit 2

    cmp byte [menuHover], 2
    ; unit 3

    mov al, [menuSelected]
    mov rbx, 0
    
    cmp byte [menuHover], 3
    cmove rax, rbx 

    mov byte [menuSelected], al

    ret

_menuNextAge:

    mov rcx, [PlayerAge]
    mov rbx, rcx
    inc rcx
    
    mov eax, [nextAgeExpRequirement]
    cmp dword [PlayerExp], eax
    cmovge rbx, rcx
    mov qword [PlayerAge], rbx

    ; TODO: update next age exp requrement

    ret


_menuLeft:


    ; if menuHover <= 0
    cmp byte [menuHover], 0
    jle _menuLeftOverflow
    
    sub byte [menuHover], 1
    
    call _menuHudText
    
    ret

_menuLeftOverflow:
    ; if menuHover <= 0
    mov rax, 4
    mov rbx, 3
    cmp byte [menuSelected], 1
    cmove rax, rbx
    mov byte [menuHover], al

    call _menuHudText
    ret

_menuRight:

    call _menuHudText

    ; if menuHover <= 0
    mov rax, 4
    mov rbx, 3
    cmp byte [menuSelected], 1
    cmove rax, rbx
    cmp byte [menuHover], al
    jge _menuRightOverflow
    
    add byte [menuHover], 1

    call _menuHudText
    ret

_menuRightOverflow:
    mov byte [menuHover], 0

    call _menuHudText
    ret


_menuHudText:
    mov rbx, [HUDbuttonmsgPtr]
    string_length rbx
    save_registers
    inc rax
    add rbx, rax
    mov qword [HUDbuttonmsgPtr], rbx

    ret



_HUDmenutext:

.trainUnit:
    db "Train units menu", 0

.build:
    db "Build Turrets menu", 0

.sell:
    db "Sell a turret", 0

.buy:
    db " - Add a turret spot", 0

.evolve:
    db " Xp - Evolve to next age", 0

.club:
    db "15$ - Club man", 0

.sling:
    db "25$ - Slingshot man", 0

.dino:
    db "100$ - Dino rider", 0