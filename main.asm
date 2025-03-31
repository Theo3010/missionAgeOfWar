%define PRINT_BUFFER_SIZE 1024
%define HEAP_SIZE 0x2000000 ; ~ 16 MB
%define RED 0x00FF0000
%define GREEN 0x0000FF00
%define BLUE 0x000000FF


%include "myLib/print_flush.asm"
%include "myLib/print.asm"
%include "myLib/print_decimal.asm"
%include "myLib/print_hex.asm"
%include "myLib/print_binary.asm"
%include "myLib/print_ascii_value.asm"
%include "myLib/print_array.asm"
%include "myLib/print_memory.asm"

%include "myLib/exit.asm"
%include "myLib/heap_init.asm"
%include "myLib/heap_allocate.asm"
%include "myLib/heap_realloc.asm"
%include "myLib/heap_free.asm"

%include "myLib/memory_copy.asm"

%include "myLib/move_ascii_cursor.asm"

%include "myLib/get_input.asm"
%include "myLib/to_integer.asm"

%include "myLib/min.asm"

%include "myLib/rand_int.asm"

%include "myLib/get_time.asm"
%include "myLib/sleep.asm"

%include "myLib/raw_mode.asm"
%include "myLib/save_termois.asm"
%include "myLib/reset_termois.asm"

%include "myLib/file_open.asm"
%include "myLib/file_read.asm"
%include "myLib/file_write.asm"
%include "myLib/file_close.asm"

%include "myLib/framebuffer_init.asm"
%include "myLib/framebuffer_fill.asm"
%include "myLib/framebuffer_flush.asm"

%include "myLib/load_image.asm"
%include "myLib/draw_image.asm"


section .data
    allocation db "allocate memory at: ", 0
    errorBmp db "Image file is not a bmp", 10, 0
    PRINT_BUFFER_LENGTH dq 0
    backgroundFile db "images/background.bmp", 0
    troop1 db "images/troop1.bmp", 0
    fbfileName db `/dev/fb0\0`
    fdtext db "filedescriptor: ", 0
    xRes db "X-resolution: ", 0
    yRes db "Y-resolution: ", 0
    bitsPrPixel db "bits per pixel: ", 0
    screenBufferSize db "screenBuffer size (bytes): ", 0

section .bss
    key resb 4
    imageHeader resb 14
    digitPointer resb 8
    time resb 16

    oldTermois resb 48
    rawTermios resb 48

    fb_file_descriptor resb 8
    fb_width resb 8
    fb_height resb 8
    fb_size resb 8
    
    screen_Buffer_address resb 8

    PRINT_BUFFER resb PRINT_BUFFER_SIZE
    HEAP resb HEAP_SIZE

    screen_coordinates resb 4 ; 0 til backgrundImage-screensize

section .text
    global _start


_printHeap:
    mov rax, r11
    sub rax, 8
    print_memory rax, 8, 8
    print_ascii_value 46
    print_ascii_value 46
    print_ascii_value 46
    print_ascii_value 10
    add rax, 0x3e8090
    sub rax, 0x20
    print_memory rax, 8, 8
    print_ascii_value 10
    print_ascii_value 10

    ret


_keyLisener:
    xor rax, rax
    mov [key], rax
    
    get_input key, 4

    cmp dword [key], 113 ; up arrow
    je _gameLoopDone

    cmp dword [key], 0x00435b1b  ; right
    je _turnRight

    cmp dword [key], 0x00445b1b  ; left
    je _turnLeft

    ret

_turnRight:

    cmp dword [screen_coordinates], 1223
    jge _skipTurn

    add dword [screen_coordinates], 50
    ret

_turnLeft:

    cmp dword [screen_coordinates], 0
    jle _skipTurn

    sub dword [screen_coordinates], 50

_skipTurn:
    ret



_drawMain:
    ; get_time

    ; void framebufferFill(int {rcx})
    framebuffer_fill 0x0 ; black

    ; void drawImage(int* {rax}, int {rbx}, int {rcx}, int {r11})
    draw_image r9, 0, 0, [screen_coordinates]
    
    ; void drawImage(int* {rax}, int {rbx}, int {rcx}, int {r11})
    draw_image r10, 0x40, 0x250, 0

    framebuffer_flush

    ret

_start:

    save_termois

    ; void heap_init(void)
    heap_init

    ; void framebuffer_init(void)
    framebuffer_init

    mov byte [screen_coordinates], 0

    raw_mode
    
    ; int* {rax} load_image(char* {rax})
    load_image backgroundFile
    mov r9, rax
    
    ; int* {rax} load_image(char* {rax})
    load_image troop1
    mov r10, rax

_gameloop:

    call _keyLisener

    call _drawMain

_skipRepaint:

    jmp _gameloop

_gameLoopDone:
    reset_termois
    exit