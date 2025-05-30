%ifndef DRAWRECT
%define DRAWRECT

; void drawRect(int {rax}, int{rdx}, int {rbx}, int {rcx})
;   draws a rect with offset {rax}x{rdx}, size {rbx}x{rcx}, color in r11 and falgs in {r12}
_drawRect:

    push r8
    push r9
    push r10

    push rdx ; mul cloober rdx
    shl rax, 2
    mul qword [fb_width]
    pop rdx

    shl rdx, 2
    add rax, rdx

    add rax, [screen_Buffer_address]

    mov r8, rbx ; copy of row
    mov r9, 0 ; counter
    mov r10, rcx ; height invariant
    sub r10, 1

_drawRectLoop:
    cmp r12, 1
    jne _drawRectBase

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

    mov rdx, %1
    mov rax, %2
    mov rbx, %3
    mov rcx, %4
    mov r11, %5
    mov r12, %6
    call _drawRect

    pop r11
    pop rdx
    pop rcx
    pop rbx
    pop rax
%endmacro

%endif