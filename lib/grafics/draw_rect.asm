%ifndef DRAWRECT
%define DRAWRECT

; void drawRect(int {rax}, int{rdx}, int {rbx}, int {rcx})
;   draws a rect with offset {rax}x{rdx}, size {rbx}x{rcx}, color in r11 and falgs in {r12}
_drawRect:

    push r8
    push r9
    push r10

    
    push rdx ; mul cloober rdx
    shl rax, 2 ; pixel conversion
    mul qword [fb_width]
    pop rdx
    
    test r12, 0b10
    je _drawRectCameraSkip
    ; convert to camera relative cordiantes
    
    mov r8, rax ; save height offset

    mov r10, rdx
    sub rdx, [camera_coordinates] ; width camera offset
    max rdx, 0
    mov rdx, rax

    ; rax = endborder
    mov rax, [fb_width] ; 1280 + 1000 = 2280
    add rax, [camera_coordinates]
    cmp rdx, rax ; offset > endborder then no draw
    jge _drawRectNoDraw

    ; writing_length (right side correction) = writing_length - max((offset + image_width - endborder), 0)
    mov r9, r10
    add r9, rbx
    sub r9, rax
    max r9, 0

    sub rbx, rax

    ; writing_length (left side correction)
    mov rax, [camera_coordinates]
    sub rax, r10

    mov r9, 0
    cmp rdx, 0 ; if width offset is > 0, then no change
    cmovg rax, r9

    sub rbx, rax

    cmp rbx, 0
    jle _drawRectNoDraw

_drawRectCameraSkip:

    mov rax, r8
    
    shl rdx, 2 ; pixel conversion
    add rax, rdx

    add rax, [screen_Buffer_address]
    
    mov r8, rbx ; copy of row
    mov r9, 0 ; counter
    mov r10, rcx ; height invariant
    sub r10, 1

_drawRectLoop:
    test r12, 0b01
    je _drawRectBase

    cmp r9, 0
    je _drawRectBase

    cmp r9, r10
    jge _drawRectBase

    jmp _drawRectSide

_drawRectBase:
    mov dword [rax], r11d
    add rax, 4
    dec rbx
    jnz _drawRectLoop

    ; \r
    mov rbx, r8
    shl rbx, 2
    sub rax, rbx ; 

    jmp _drawRectSkip

_drawRectSide:

    mov dword [rax], r11d
    mov rbx, r8
    shl rbx, 2
    add rax, rbx
    mov dword [rax], r11d
    
    ; \r
    mov rbx, r8
    shl rbx, 2
    sub rax, rbx 

_drawRectSkip:
    inc r9

    ; \n
    mov rbx, [fb_width]
    shl rbx, 2
    add rax, rbx

    ; reset row count
    mov rbx, r8

    dec rcx
    jnz _drawRectLoop

_drawRectNoDraw:

    pop r10
    pop r9
    pop r8

    ret

%macro draw_rect 6

    push rax
    push rbx
    push rcx
    push rdx
    push r11
    push r12

    mov rdx, %1
    mov rax, %2
    mov rbx, %3
    mov rcx, %4
    mov r11, %5
    mov r12, %6
    call _drawRect

    pop r12
    pop r11
    pop rdx
    pop rcx
    pop rbx
    pop rax
%endmacro

%endif