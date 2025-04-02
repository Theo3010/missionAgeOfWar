%ifndef DRAW_IMAGE
%define DRAW_IMAGE

%include "lib/grafics/color_copy.asm"
%include "lib/math/min.asm"

; void drawImage(int* {rax}, int {rbx}, int {rcx}, int {r11})
;   pointer to load image {rax} and pixel coordinates where image should be draw in {rbx}x{rcx}. Image offset in {r11}
_drawImage:

    push r9
    push r10

    ; calculate pixel coordinates
    mov r10, [screen_Buffer_address]

    ; height coordinate
    shl rcx, 2
    imul rcx, [fb_width]
    add r10, rcx

    ; width offset
    ; shl rbx, 2
    add r10, rbx

    ; get total size of heap header
    mov rcx, [rax-8]
    sub rcx, 1 ; remove allocated flag

    ; get data offset
    mov dword ebx, [rax]

    ; get width size (2503)
    mov dword edx, [rax+4]


    ; get height size (800)
    mov dword r8d, [rax+8]

    ; exit
    ; goto data begin
    add rax, rbx

    ; get size of data only
    sub rcx, rbx

    ; make a bottom up copy.
    add rax, rcx ; go to end of image
    cmp r11, 0
    je _drawImageSkip
    shl r11, 2
    add rax, r11 ; background offset

_drawImageSkip:
    shl rdx, 2

    mov r9, [fb_width]
    shl r9, 2

    sub rax, rdx ; go back one width

    push rax
    min r9, rdx
    mov rcx, rax
    pop rax

_drawImageLoop:
    color_copy rax, r10, rcx
    sub rax, rdx ; go back one width
    add r10, r9 ; add one screene width, to goto next line
    dec r8
    jnz _drawImageLoop

    pop r10
    pop r9

    ret

%macro draw_image 4
    push rax
    push rbx
    push rcx
    push r11

    mov rax, %1
    mov rbx, %2
    mov rcx, %3
    mov r11, %4
    call _drawImage

    pop r11
    pop rcx
    pop rbx
    pop rax
%endmacro

%endif