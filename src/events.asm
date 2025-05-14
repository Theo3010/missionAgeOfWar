%include "src/cleanup.asm"
%include "src/menu.asm"
%include "lib/io/get_input.asm"

_keyLisener:
    xor rax, rax
    mov [key], rax
    
    get_input key, 4

    cmp dword [key], 27 ; esc -> quit
    je _cleanAndExit

    cmp dword [key], 113 ; q -> menu left
    je _menuLeft

    cmp dword [key], 101 ; e -> menu right
    je _menuRight

    cmp dword [key], 32 ; space -> menu select
    je _menuSelect

    cmp dword [key], 0x00435b1b  ; right
    je _turnRight

    cmp dword [key], 0x00445b1b  ; left
    je _turnLeft

    cmp dword [key], 100 ; d -> debug
    je _keyDebugMode

    ret

_turnRight:

    cmp dword [camera_coordinates], 0x487
    jge _skipTurn

    add dword [camera_coordinates], 0x20

    ret

_turnLeft:

    cmp dword [camera_coordinates], 0x20
    jle _skipTurn

    sub dword [camera_coordinates], 0x20

_skipTurn:
    ret

_keyDebugMode:

    xor byte [debugMode], 1

    ret
