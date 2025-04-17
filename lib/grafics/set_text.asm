%ifndef SET_TEXT
%define SET_TEXT

%include "lib/grafics/fonts.asm"
%include "lib/mem/memory_copy.asm"

; font size and font color

; void setText(char* {rax}, int {rbx}, int {rcx}, int {rdx}, int {r8})
;   pointer to text {rax} and // screen postion in {rbx}x{rcx}. Font size in {rdx} and font color (ARGB) in {r8}
_setText:

    push rbx
    push rcx
    push r10
    push r15

    ; get screen pointer
    mov r15, [screen_Buffer_address]

_setTextLoop:
    ; get char
    mov byte bl, [rax]
    ; if 0 then end of text
    cmp bl, 0
    je _setTextReturn
    ; if 10 then newline
    cmp bl, 10
    je _newline
    ; if > 32 then unknown
    cmp bl, 32
    jl _unknown
    ; if < 32 then unknown
    cmp bl, 32
    jg _unknown
    ; else draw_char
_setTextDrawChar:
    
    ; get char offset
    sub bl, 32

    ; get char pointer from FONTS.asm
    mov rcx, _fonts ; pointer to the start of font (SPACE)
    
    add rcx, rbx ; move pointer to char

_unknown:
    mov rcx, _fonts.unknown

    ; copy mem from FONT to SCREEN_BUFFER (row based 8)
    mov r10, 8

_setTextDrawCharMemLoop:
    memory_copy rcx, r15, 8
    
    add rcx, 8 ; go down line font width
    add r15, [fb_width] ; go down one screen width

    dec r10
    jnz _setTextDrawCharMemLoop


    ; repeat
    inc r10
    jmp _setTextLoop

_newline: ; TODO
_setTextReturn:

    pop r15
    pop r10
    pop rcx
    pop rbx

    ret


%macro set_text 1
    push rax

    mov rax, %1
    call _setText

    pop rax
%endmacro

%endif