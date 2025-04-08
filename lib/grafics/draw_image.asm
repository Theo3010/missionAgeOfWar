%ifndef DRAW_IMAGE
%define DRAW_IMAGE

%include "lib/grafics/color_copy.asm"
%include "lib/math/min.asm"
%include "lib/math/max.asm"
%include "lib/io/print_decimal.asm"
%include "lib/io/print_ascii_value.asm"
%include "lib/io/print_flush.asm"
%include "lib/sleep.asm"

; void drawImage(int* {rax}, int {rbx}, int {rcx})
;   pointer to load image {rax} and pixel coordinates where image should be draw in {rbx}x{rcx}
_drawImage:
    push r9
    push r10
    push r11
    push r14

    ; calculate pixel coordinates
    mov r10, [screen_Buffer_address]

    ; height coordinate
    shl rcx, 2
    imul rcx, [fb_width]
    add r10, rcx

    ; width offset
    shl rbx, 2
    add r10, rbx

    ; get total size of heap header
    mov rcx, [rax-8]
    sub rcx, 1 ; remove allocated flag

    push rbx ; save pos.x
    ; get data offset
    mov dword ebx, [rax]

    ; get width size (2503)
    mov dword edx, [rax+4]

    ; get height size (800)
    mov dword r8d, [rax+8]

    ; goto data begin
    add rax, rbx

    ; get size of data only
    sub rcx, rbx

    pop rbx ; load pos.x

    ; make a bottom up copy.
    add rax, rcx ; go to end of image
    
    mov r11, [camera_coordinates]
    shl r11, 2
    sub r11, rbx ; offset - pos.x
    
    push rax
    max r11, 0 ; r11 >= 0
    mov r11, rax
    pop rax
    
    add rax, r11 ; background offset

    shl rdx, 2

    mov r9, [fb_width]
    shl r9, 2

    sub rax, rdx ; go back one width

    mov r14, rax ; save rax

    ; check if image is out of screen.
    mov rcx, rdx ; rcx = image_width
    cmp r11, rcx
    jge _drawImageEnd

    sub rcx, r11 ; rcx = image width - image offset
    min rdx, rcx ; min (image_width, write_length)
    mov rcx, rax

    min r9, rcx ; min(screen_width, image_write_length)
    mov rcx, rax

    mov rax, r14 ; load rax

_drawImageLoop:
    color_copy rax, r10, rcx
    sub rax, rdx ; go back one width
    add r10, r9 ; add one screene width, to goto next line
    dec r8
    jnz _drawImageLoop

_drawImageEnd:

    pop r14
    pop r11
    pop r10
    pop r9

    ret

%macro draw_image 3
    push rax
    push rbx
    push rcx

    mov rax, %1
    mov rbx, %2
    mov rcx, %3
    call _drawImage

    pop rcx
    pop rbx
    pop rax
%endmacro

%endif



; unit.pos (x, y)
; camera.x

; drawimage unit.x, unit.y

; start at (unit.x, unit.y) of screen
; if unit.x = 40 and unit.y = 40, draw at frambuffer (40, 40)
; camera shift 10 to the left (camera.x = 10)
; if unit.x = 40 and unit.y = 40 and camera.x = 10, draw at framebuffer (30, 40)
; if (0, y) or (x, 0), then no draw.

; BUT lets draw an 40x40 image at (0, 0)
; then move 10 (-10, 0), therefore no draw
; but 30 of the 40 pixel is still visiable.

; so 40x40 starting in (0, height) would be (0 (unit.x), 40(unit.width), height)
; then move 10 would be (-10 (unit.x - [camera]), 30 (unit.width - [camera]), height)
; if (<0, <0, height) then no draw
; else -10 is current image offset and 30 is writing length.

; and 40x40 starting in (120, height) would be (120, 120+40, height)
; then move -10 would be (110, 150, height)

