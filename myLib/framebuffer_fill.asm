%ifndef FRAMEBUFFER_FILL
%define FRAMEBUFFER_FILL

; void framebufferFill(int {rcx})
;   fill screen with color in rax 
_framebufferFill:
    push rax
    push rbx


    ; get x-resolution
    mov rax, [fb_width] ; width 
    ; get y-resoltion
    mov rbx, [fb_height] ; height
    ; mul
    mul rbx ; rax = width * height
    dec rax

    mov rbx, [screen_Buffer_address] 
_framebufferFillLoop:
    mov [rbx], rcx ; set color
    add rbx, 4 ; next pixel
    dec rax ; pixel left
    jnz _framebufferFillLoop

    pop rbx
    pop rax

    ret

%macro framebuffer_fill 1
    push rcx

    mov rcx, %1
    call _framebufferFill

    pop rcx
%endmacro

%endif