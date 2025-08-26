%define PRINT_BUFFER_SIZE 1024
%define HEAP_SIZE 0x10000000 ; ~256 MB
%define TRUE 1
%define FALSE 0

%include "lib/io/print_flush.asm"
%include "lib/io/print.asm"
%include "lib/io/print_decimal.asm"
%include "lib/io/print_hex.asm"
%include "lib/io/print_binary.asm"
%include "lib/io/print_ascii_value.asm"
%include "lib/io/print_array.asm"
%include "lib/io/print_memory.asm"
%include "lib/io/get_input.asm"
%include "lib/io/string_concat.asm"
%include "lib/io/print_registers.asm"

%include "lib/debug/save_registers.asm"

%include "lib/mem/heap_init.asm"
%include "lib/mem/heap_allocate.asm"
%include "lib/mem/heap_realloc.asm"
%include "lib/mem/heap_free.asm"
%include "lib/mem/memory_copy.asm"

%include "lib/math/min.asm"
%include "lib/math/rand_int.asm"
%include "lib/math/sort.asm"

%include "lib/exit.asm"
%include "lib/to_integer.asm"
%include "lib/to_string.asm"
%include "lib/get_time.asm"
%include "lib/sleep.asm"
%include "lib/error.asm"
%include "lib/queue.asm"
%include "lib/nextzero.asm"
%include "lib/clock_tick.asm"
%include "lib/world_cords.asm"

%include "lib/terminal/move_ascii_cursor.asm"
%include "lib/terminal/raw_mode.asm"
%include "lib/terminal/save_termois.asm"
%include "lib/terminal/reset_termois.asm"

%include "lib/files/file_open.asm"
%include "lib/files/file_read.asm"
%include "lib/files/file_write.asm"
%include "lib/files/file_close.asm"
%include "lib/files/get_files.asm"

%include "lib/grafics/framebuffer_init.asm"
%include "lib/grafics/framebuffer_fill.asm"
%include "lib/grafics/framebuffer_flush.asm"
%include "lib/grafics/load_image.asm"
%include "lib/grafics/draw_image.asm"
%include "lib/grafics/draw_rect.asm"
%include "lib/grafics/multi_load_images.asm"
%include "lib/grafics/filter.asm"

%include "lib/audio/load_audio.asm"
%include "lib/audio/play_audio.asm"
%include "lib/riff_reader.asm"
%include "lib/threading.asm"

; %include "src/events.asm"
; %include "src/init.asm"


section .data
    imagesPath db "../images/", 0
    audioMusicFile db "../audio/00_GloriousMorning.wav", 0
    errorBmp db "Image file is not a bmp", 10, 0
    PRINT_BUFFER_LENGTH dq 0
    fbfileName db `/dev/fb0\0`
    clear_screen db `\e[2J`, 0

section .bss
    registers resb 120
    debugMode resb 4
    isRunning resb 2

    key resb 4
    imageHeader resb 14
    audioHeader resb 12
    
    clock_time resb 16
    time resb 16
    
    oldTermois resb 48
    rawTermios resb 48
    isTermoisSaved resb 4

    fb_file_descriptor resb 8
    fb_width resb 8
    fb_height resb 8
    fb_size resb 8
    
    screen_Buffer_address resb 8

    PRINT_BUFFER resb PRINT_BUFFER_SIZE
    HEAP resb HEAP_SIZE
    STRINGBUFFER resb 24
    camera_coordinates resb 8
    imagesPointer resb 8

    PlayerExp resb 8
    PlayerGold resb 8
    PlayerAge resb 8
    PlayerHealth resb 8
    nextAgeExpRequirement resb 8
    menuHover resb 8
    menuSelected resb 8
    HUDbuttonmsgPtr resb 8

    FolderInfoBuffer resb 4096

section .text
    global _start


_busyThread:
    sleep 1_000_000
    print_decimal 100
    print_ascii_value 10
    print_flush

    ret

_start:

    heap_init

    create_thread _busyThread, 0
    mov r8, rax ; save PID

    sleep 10_000_000

    print_decimal 42
    print_ascii_value 10
    print_flush

    exit
