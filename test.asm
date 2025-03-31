%include "myLib/get_input.asm"
%include "myLib/exit.asm"

section .bss
    key resb 4

section .text
    global _start


_keyLisener:
    xor rax, rax
    mov [key], rax
    
    get_input key, 4

    ret
;     cmp dword [key], 113 ; up arrow
;     je _gameLoopDone

;     cmp dword [key], 0x00435b1b  ; right
;     je _turnRight

;     cmp dword [key], 0x00445b1b  ; left
;     je _turnLeft

;     ret

; _turnRight:
;     mov rax, 50
;     add [screen_coordinates], rax
;     ret

; _turnLeft:
;     mov rax, 50
;     sub [screen_coordinates], rax
;     ret

_start:

    call _keyLisener

    exit