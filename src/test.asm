%define PRINT_BUFFER_SIZE 1024
%define HEAP_SIZE 0x2000000 ; ~ 16 MB

%include "lib/io/print_flush.asm"
%include "lib/io/print.asm"
%include "lib/io/print_decimal.asm"
%include "lib/io/print_hex.asm"
%include "lib/io/print_binary.asm"
%include "lib/io/print_ascii_value.asm"
%include "lib/io/print_array.asm"
%include "lib/io/print_memory.asm"
%include "lib/io/get_input.asm"

%include "lib/mem/heap_init.asm"
%include "lib/mem/heap_allocate.asm"
%include "lib/mem/heap_realloc.asm"
%include "lib/mem/heap_free.asm"
%include "lib/mem/memory_copy.asm"

%include "lib/math/min.asm"
%include "lib/math/rand_int.asm"

%include "lib/exit.asm"
%include "lib/to_integer.asm"
%include "lib/get_time.asm"
%include "lib/sleep.asm"

%include "lib/terminal/move_ascii_cursor.asm"
%include "lib/terminal/raw_mode.asm"
%include "lib/terminal/save_termois.asm"
%include "lib/terminal/reset_termois.asm"

%include "lib/files/file_open.asm"
%include "lib/files/file_read.asm"
%include "lib/files/file_write.asm"
%include "lib/files/file_close.asm"

%include "lib/grafics/framebuffer_init.asm"
%include "lib/grafics/framebuffer_fill.asm"
%include "lib/grafics/framebuffer_flush.asm"
%include "lib/grafics/load_image.asm"
%include "lib/grafics/draw_image.asm"


section .data
    errorBmp db "Image file is not a bmp", 10, 0
    PRINT_BUFFER_LENGTH dq 0
    fbfileName db `/dev/fb0\0`

section .bss
    key resb 4
    imageHeader resb 14
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

section .text
    global _start


_start:

    exit