%ifndef SET_TEXT
%define SET_TEXT

%include "lib/grafics/fonts.asm"
%include "lib/grafics/text_copy.asm"

; void setText(char* {rax}, int {rbx}, int {rcx}, int {r9}, int {r11})
;   pointer to text {rax} and // screen postion in {rbx}x{rcx}. Font size in {rdx} and font color (ARGB) in {r8}
_setText:

    push r10
    push r14
    push r15

    ; get screen pointer
    mov r15, [screen_Buffer_address]

    ; offset stuff
    shl rcx, 1 ; rcx * 4 (do to pixel convertion)
    imul rcx, [fb_width]
    add r15, rcx

    shl rbx, 2 ; rbx * 4 (do to pixel convertion)
    add r15, rbx

    ; copy screen buffer
    mov r14, r15 ; screen pointer

    ; default symbol or unknown symbol (symbol not in font)

_setTextLoop:
    mov rcx, _fonts.unknown
    ; get char
    movzx rbx, byte [rax]

    ; if 0 then end of text
    cmp rbx, 0
    je _setTextReturn
    
    ; if 10 then newline
    cmp rbx, 10
    je _newline
    
    ; if > 32 then unknown
    cmp rbx, 32
    jl _unknown
    
    ; if < 32 then unknown
    cmp rbx, 126
    jg _unknown
    
    ; else draw_char
_setTextDrawChar:

    ; get char offset
    sub rbx, 32

    ; get char pointer from FONTS.asm
    mov rcx, _fonts ; pointer to the start of font (SPACE)
    
    shl rbx, 3 ; rbx * 2^3 
    add rcx, rbx ; move pointer to char

_unknown:
    ; copy mem from FONT to SCREEN_BUFFER (row based 8)
    mov r10, 8 ; font width
    push r14 ; save screen pointer

    ; outer loop for font scaling (in y-axis)
_setTextDrawCharMemLoopOuter:
    mov r8, r9 ; copy of font size

    ; main loop
_setTextDrawCharMemLoop:
    text_copy rcx, r14, 8, r9, r11
    
    mov rbx, [fb_width]
    shl rbx, 2
    add r14, rbx ; go down one screen width

    dec r8
    jnz _setTextDrawCharMemLoop

    inc rcx ; go down line font width

    dec r10
    jnz _setTextDrawCharMemLoopOuter


    pop r14
    ; repeat
    mov r10, r9 ; font_size
    shl r10, 3 ; font_size * 8
    shl r10, 2 ; font_size * 8 * 4 (pixel convertion)
    add r14, r10 ; move 'cursor' one char length

    inc rax
    jmp _setTextLoop

_newline:

    mov r10, r9 ; font_size
    shl r10, 3 ; font_size * 8
    add r10, 2 ; add top botton padding
    shl r10, 2 ; font_size * 8 * 4 (pixel convertion)
    imul r10, [fb_width] ; font_size * 8 * 4 * width
    add r15, r10 ; move 'cursor' one char length
    mov r14, r15 ; screen pointer

    inc rax
    jmp _setTextLoop

_setTextReturn:

    pop r15
    pop r14
    pop r10

    ret


%macro set_text 5
    push rax
    push rbx
    push rcx
    push r9
    push r11

    mov rax, %1
    mov rbx, %2
    mov rcx, %3
    mov r9, %4
    mov r11, %5
    call _setText

    pop r11
    pop r9
    pop rcx
    pop rbx
    pop rax
%endmacro

%endif