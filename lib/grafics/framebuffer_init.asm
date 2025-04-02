%ifndef FRAMEBUFFER_INIT
%define FRAMEBUFFER_INIT

%include "lib/mem/heap_allocate.asm"
%include "lib/mem/heap_free.asm"
%include "lib/files/file_open.asm"

; void framebufferInit(void)
;   does stuff
;   expects heap to be init'ed.
_framebufferInit:
    
    ; allocate 1280
    heap_allocate 1280
    mov r10, rax ; save pointer
    
    ; open file /dev/fb0
    file_open .fbfileName, 2, 0644o

    ; save fd
    mov [fb_file_descriptor], eax ; 8 bytes saved

    ; read /dev/fb0
    mov rdx, r10 ; load memory pointer
    mov rax, 16 ; ICOCTL
    mov rdi, [fb_file_descriptor]
    mov rsi, 0x4600 ; get framebuffer info
    syscall

    ; save width, height
    mov rbx, 0
    mov ebx, [r10+0] ; width
    
    mov [fb_width], ebx

    mov ebx, [r10+4] ; height
    
    mov [fb_height], ebx
    
    ; calculate size
    mov rbx, 0
    mov ebx, [r10+0] ; width
    imul ebx, [r10+4] ; height
    imul ebx, [r10+24] ; bits pr pixel
    shr ebx, 3 ; div by 8 to get in bytes

    heap_free r10 ; free screen info
    ; save size
    mov [fb_size], ebx
    
    ; allocate size
    heap_allocate [fb_size]
    ; save pointer
    mov [screen_Buffer_address], rax
    
    ret

.fbfileName:
    db "/dev/fb0", 0

%macro framebuffer_init 0

    call _framebufferInit

%endmacro

%endif