%ifndef DRAW_IMAGE
%define DRAW_IMAGE

%include "lib/grafics/color_copy.asm"
%include "lib/math/min.asm"
%include "lib/math/max.asm"
%include "lib/io/print_decimal.asm"
%include "lib/io/print_ascii_value.asm"
%include "lib/io/print_flush.asm"
%include "lib/sleep.asm"

; void drawImage(int* {r11}, int {rbx}, int{rcx})
_drawImage:

    push rax
    push rdx
    push r8
    push r9
    push r10

    mov r10, [screen_Buffer_address]
    
    ; height offset
    shl rcx, 2
    imul rcx, [fb_width]
    add r10, rcx

    ; width offset relative to camera
    ; offset - camera
    mov rax, rbx
    sub rax, [camera_coordinates]

    max rax, 0

    ; width offset
    shl rax, 2
    add r10, rax

    push rbx ; save width offset

    ; read header
    mov rcx, [r11-8]
    sub rcx, 1 ; remove flags

    ; get image header size
    mov dword ebx, [r11] ; rbx = image header size

    ; get width size (2503)
    mov dword edx, [r11+4] ; rdx = width of image

    ; get height size (800)
    mov dword r8d, [r11+8] ; r8 = height of image

    ; get start of pixel array
    add r11, rbx ; r11 = start of pixel array

    ; get size of pixel array
    sub rcx, rbx

    ; go to end if image.
    add r11, rcx
    cmp r12, TRUE
    ; je _drawImageFilped

    call _moveOneWidthPixels

_drawImageFilped:

    pop rbx ; get back width offset.

    ; rax = endborder
    mov rax, [fb_width] ; 1280 + 1000 = 2280
    add rax, [camera_coordinates]
    cmp rbx, rax ; offset > endborder then no draw
    jge _noDraw

    mov rcx, rdx
    ; writing_length = writing_length - max((offset + image_width - endborder), 0)
    mov r9, rbx
    add r9, rdx
    sub r9, rax
    max r9, 0

    sub rcx, rax

    ; relative offset
    mov rax, rbx
    sub rax, [camera_coordinates]

    cmp rax, 0
    jg _writingLengthSkip

    mov rax, [camera_coordinates]
    sub rax, rbx

    ; writing_length - relative offset
    sub rcx, rax

    ; draw in relation to the camera
    shl rax, 2
    add r11, rax

_writingLengthSkip:

    cmp rcx, 0 ; if writing_length is less 0, no draw
    jle _noDraw

    min rcx, [fb_width]
    mov rcx, rax

_drawImageLoop:
    color_copy r11, r10, rcx, r12 ; copy first width of image
    
    call _moveOneWidthPixels ; go back one image width
    mov rax, [fb_width] 
    shl rax, 2
    add r10, rax ; add one screen width, to goto next line
    
    dec r8
    jnz _drawImageLoop


_noDraw:
    
    pop r10
    pop r9
    pop r8
    pop rdx
    pop rax

    ret

%macro draw_image 4

    push r11
    push rbx
    push rcx

    mov r11, %1
    mov rbx, %2
    mov rcx, %3
    mov r12, %4
    call _drawImage

    pop rcx
    pop rbx
    pop r11

%endmacro


_moveOneWidthPixels:
    push rdx
    
    shl rdx, 2
    sub r11, rdx
    
    pop rdx
    
    ret

%endif