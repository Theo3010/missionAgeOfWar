%include "lib/io/string_length.asm"

_menuSelect:

    cmp byte [menuSelected], 0
    je _menuMainSelector 

    cmp byte [menuSelected], 1
    je _menuUnitSelector 

    cmp byte [menuSelected], 2
    je _menuTurretSelector 
    
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
    mov rbx, 2
    cmp byte [menuHover], 1
    ; open buy tower menu
    cmove rax, rbx
    mov [menuSelected], al

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

    call _menuHudText

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

    call _menuHudText

    ret


_menuTurretSelector:

    cmp byte [menuHover], 0
    ; turret 1

    cmp byte [menuHover], 1
    ; turret 2

    cmp byte [menuHover], 2
    ; turret 3

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
    cmp byte [menuSelected], 2
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
    cmp byte [menuSelected], 2
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
    mov rbx, _HUDmenutext

    ; main menu
    cmp byte [menuSelected], 0
    mov rax, _HUDmenutext
    cmove rbx, rax

    ; unit menu
    cmp byte [menuSelected], 1
    mov rax, _HUDmenutext.club
    cmove rbx, rax

    ; turrets menu
    cmp byte [menuSelected], 2
    mov rax, _HUDmenutext.rock
    cmove rbx, rax

    cmp rbx, _HUDmenutext
    je _backButtonSkip

    cmp byte [menuHover], 3
    jne _backButtonSkip

    mov rbx, _HUDmenutext.back
    mov qword [HUDbuttonmsgPtr], rbx

    ret

_backButtonSkip:

    mov rax, 30
    imul rax, [menuHover]

    add rbx, rax
    mov qword [HUDbuttonmsgPtr], rbx

    ret



_HUDmenutext:

; start menu
.trainUnit:
    db "Train units menu", 0
    times (30 - ($ - .trainUnit)) db 0

.build:
    db "Build Turrets menu", 0
    times (30 - ($ - .build)) db 0

.sell:
    db "Sell a turret", 0
    times (30 - ($ - .sell)) db 0

.buy:
    db " - Add a turret spot", 0
    times (30 - ($ - .buy)) db 0

.evolve:
    db " Xp - Evolve to next age", 0
    times (30 - ($ - .evolve)) db 0

; back button msg used in sub menus.
.back:
    db "Return to previous menu", 0
    times (30 - ($ - .back)) db 0

; world one units
.club:
    db "15$ - Club man", 0
    times (30 - ($ - .club)) db 0

.sling:
    db "25$ - Slingshot man", 0
    times (30 - ($ - .sling)) db 0

.dino:
    db "100$ - Dino rider", 0
    times (30 - ($ - .dino)) db 0

; word one turrents
.rock:
    db "100$ - Rock slingshot", 0
    times (30 - ($ - .rock)) db 0

.egg:
    db "200$ - Egg automatic", 0
    times (30 - ($ - .egg)) db 0

.primitive:
    db "500$ - Primitive Catapult", 0
    times (30 - ($ - .primitive)) db 0