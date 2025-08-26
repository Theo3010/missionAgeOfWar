%ifndef FILTER
%define FILTER


; void filterBrightness(int value {rbx}, int offset {rcx}, int width {rdx}, int height {rsi}, int flags {r11})
; brighten / darkens an area of the screen (framebuffer).
;   flags:
;     0 - brighten
;     1 - darken
_filterBrightness:

    push rdi
    push r8
    push r9
    push r10
    push r12

    ; if width or height is 0, return
    cmp rdx, 0
    je _filterBrightnessReturn
    cmp rsi, 0
    je _filterBrightnessReturn

    ; load framebuffer pointer
    mov r12, [screen_Buffer_address]

    ; add offset to framebuffer pointer
    shl rcx, 2 ; rcx * 4 pixel convertion
    add r12, rcx ; r12 = framebuffer + offset

    mov rdi, rdx ; rdi = width

_filterLoop:
    ; get pixel color
    mov ecx, dword [r12] ; load pixel color
    
    ; split color into RGB components
    mov r8d, ecx ; copy color to r8
    and r8d, 0xFF ; get blue component

    mov r9d, ecx ; copy color to r9
    shr r9d, 8 ; shift right to get green component
    and r9d, 0xFF ; get green component

    mov r10d, ecx ; copy color to r10
    shr r10d, 16 ; shift right to get red component
    and r10d, 0xFF ; get red component
    
    ; apply brightness filter
    cmp r11, 0 ; check if brighten or darken
    je _brighten
    
    ; darken
    sub r8, rbx ; subtract brightness value from blue component
    max r8, 0 ; value >= 0
    mov r8, rax
   
    sub r9, rbx ; subtract brightness value from green component
    max r9, 0 ; value >= 0
    mov r9, rax
    
    sub r10, rbx ; subtract brightness value from red component
    max r10, 0 ; value >= 0
    mov r10, rax
    
    jmp _storeColor

_brighten:
    ; brighten
    add r8, rbx ; add brightness value from blue component
    min r8, 0xff ; value >= 0
    mov r8, rax
   
    add r9, rbx ; add brightness value from green component
    min r9, 0xff ; value >= 0
    mov r9, rax
    
    add r10, rbx ; add brightness value from red component
    min r10, 0xff ; value >= 0
    mov r10, rax

_storeColor:
    ; combine RGB components back into color

    mov ecx, r10d ; move blue component to rdx
    shl ecx, 8 ; shift red component to the left

    or ecx, r9d ; combine green component with blue
    shl ecx, 8 ; shift green component to the left

    or ecx, r8d ; combine red component with green and blue
    
    save_registers

    ; store new pixel color
    mov dword [r12], ecx ; store new color back to framebuffer
    
    add r12, 4 ; move to next pixel

    dec rdi ; width left
    jnz _filterLoop ; if no pixels left, end

    ; \r move back to start of line
    push rdx
    shl rdx, 2 ; rdx * 4 pixel conversion
    sub r12, rdx ; r12 = r12 - width

    ; \n to go to next line
    mov rdx, [fb_width] ; load screen width
    shl rdx, 2 ; rdx * 4 pixel conversion
    add r12, rdx ; r12 = r12 + screen_width

    pop rdx
    mov rdi, rdx ; restore width

    dec rsi ; height left
    jnz _filterLoop ; if no lines left, end

_filterBrightnessReturn:

    pop r12
    pop r10
    pop r9
    pop r8
    pop rdi

    ret


%macro brightness 5
    push rbx
    push rcx
    push rdx
    push rsi
    push r11

    mov rbx, %1 ; brightness value
    mov rcx, %2 ; offset
    mov rdx, %3 ; width
    mov rsi, %4 ; height
    mov r11, %4 ; flags

    call _filterBrightness

    pop r11
    pop rsi
    pop rdx
    pop rcx
    pop rbx

%endmacro

%endif