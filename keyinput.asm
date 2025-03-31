_keyLisener:
    xor rax, rax
    mov [key], rax
    
    get_input key, 4

    cmp dword [key], 113 ; up arrow
    je _gameLoopDone

    cmp dword [key], 0x00435b1b  ; right
    je _turnRight

    cmp dword [key], 0x00445b1b  ; left
    je _turnLeft

    ret

_turnRight:

    cmp dword [screen_coordinates], 1223
    jge _skipTurn

    add dword [screen_coordinates], 50
    ret

_turnLeft:

    cmp dword [screen_coordinates], 0
    jle _skipTurn

    sub dword [screen_coordinates], 50

_skipTurn:
    ret
