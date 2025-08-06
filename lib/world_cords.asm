%ifndef WORDCORDS
%define WORDCORDS

%include "lib/math/max.asm"

; int {rax, rbx} wordcords(int offset {rbx}, int width {rcx});
_wordCords:
    push r9

    ; rax = endborder
    mov rax, [fb_width] ; screen width
    add rax, [camera_coordinates] ; endborder = screen width + camera offset
    cmp rbx, rax ; offset > endborder then no draw
    jge _wordCordsNoDraw

    ; writing_length (right side correction) = width - max((offset + width - endborder), 0)
    mov r9, rbx ; offset
    add r9, rcx ; width
    sub r9, rax ; endborder
    max r9, 0 ; >= 0

    sub rcx, rax ; rcx = width - max(offset + width - endborder, 0) | new width


    ; writing_length (left side correction) = width - max((startborder - offset + width), 0)
    mov rax, [camera_coordinates] ; startborder
    mov r9, rax ; offset
    add r9, rcx ; offset + width
    sub rax, r9 ; startborder - (offset + width)
    max rax, 0 ; >= 0

    sub rcx, rax ; rcx = width - max(startborder - offset + width, 0) | new width

    cmp rcx, 0
    jle _wordCordsNoDraw

    sub rbx, [camera_coordinates] ; width camera offset
    max rbx, 0
    mov rbx, rax

    mov rax, rbx ; rax = offset
    mov rbx, rcx ; rbx = width

    pop r9
    ret

_wordCordsNoDraw:
    xor rax, rax ; return 0 if no draw

    pop r9
    ret


%macro word_cords 2
    push rcx

    mov rbx, %1 ; offset
    mov rcx, %2 ; width
    call _wordCords

    pop rcx
%endmacro

%endif