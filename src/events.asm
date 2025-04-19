%include "src/cleanup.asm"
%include "lib/io/get_input.asm"

_keyLisener:
    xor rax, rax
    mov [key], rax
    
    get_input key, 4

    cmp dword [key], 113 ; q -> quit
    je _cleanAndExit

    cmp dword [key], 0x00435b1b  ; right
    je _turnRight

    cmp dword [key], 0x00445b1b  ; left
    je _turnLeft

    cmp dword [key], 100 ; d -> debug
    je _keyDebugMode

    ret

_turnRight:

    cmp dword [camera_coordinates], 1223
    jge _skipTurn

    add dword [camera_coordinates], 0x20

    ret

_turnLeft:

    cmp dword [camera_coordinates], 0
    jle _skipTurn

    sub dword [camera_coordinates], 0x20

_skipTurn:
    ret

_keyDebugMode:

    xor byte [debugMode], 1

    ret
