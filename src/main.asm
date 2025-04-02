; defines
%define PRINT_BUFFER_SIZE 1024
%define HEAP_SIZE 0x2000000 ; ~ 32 MB

; includes
%include "lib/io/print_flush.asm"
%include "lib/io/print_ascii_value.asm"
%include "lib/io/print_hex.asm"
%include "lib/io/print_decimal.asm"
%include "lib/io/print_array.asm"
%include "lib/io/print.asm"
%include "lib/io/get_input.asm"

%include "lib/files/file_open.asm"
%include "lib/files/file_read.asm"
%include "lib/files/file_close.asm"

%include "lib/grafics/draw_image.asm"
%include "lib/grafics/load_image.asm"
%include "lib/grafics/framebuffer_init.asm"
%include "lib/grafics/framebuffer_fill.asm"
%include "lib/grafics/framebuffer_flush.asm"

%include "lib/mem/heap_init.asm"
%include "lib/mem/heap_allocate.asm"
%include "lib/mem/heap_free.asm"

%include "lib/terminal/raw_mode.asm"
%include "lib/terminal/save_termois.asm"
%include "lib/terminal/reset_termois.asm"

%include "lib/clock_tick.asm"
%include "lib/exit.asm"

%include "src/events.asm"
%include "src/render.asm"
%include "src/init.asm"
; section
section .data
    background db "images/background.bmp", 0
    troop1 db "images/troop1.bmp", 0
    base1 db "images/base1.bmp", 0
    PRINT_BUFFER_LENGTH dq 0

section .bss
    key resb 8
    
    clock_time resb 16
    time resb 16

    rawTermios resb 48
    oldTermois resb 48

    fb_file_descriptor resb 8
    fb_width resb 8
    fb_height resb 8
    fb_size resb 8

    screen_Buffer_address resb 8

    imageHeader resb 14
    
    PRINT_BUFFER resb PRINT_BUFFER_SIZE
    HEAP resb HEAP_SIZE

    camera_coordinates resb 4

section .text
    global _start

; code
_start:
    
    call _init

    ; int* {rax} loadImage(char* {rax})
    load_image background
    mov r9, rax

    load_image troop1
    mov r10, rax

    load_image base1
    mov r11, rax

    ; while (true)
_whileLoop:
    ;   events (key inputs)
    call _keyLisener
    
    clock_tick 60 ; fps
    cmp rax, 0
    je _whileLoop ; no render

    call _render

    jmp _whileLoop
    
    exit