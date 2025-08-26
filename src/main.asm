; defines
%define PRINT_BUFFER_SIZE 1024
%define HEAP_SIZE 0x10000000 ; ~256 MB
%define FALSE 0
%define TRUE 1

; includes
%include "lib/io/print_flush.asm"
%include "lib/io/print_ascii_value.asm"
%include "lib/io/print_hex.asm"
%include "lib/io/print_decimal.asm"
%include "lib/io/print_array.asm"
%include "lib/io/print.asm"
%include "lib/io/print_memory.asm"
%include "lib/io/print_registers.asm"
%include "lib/io/get_input.asm"

%include "lib/debug/save_registers.asm"

%include "lib/files/file_open.asm"
%include "lib/files/file_read.asm"
%include "lib/files/file_close.asm"

%include "lib/grafics/draw_image.asm"
%include "lib/grafics/load_image.asm"
%include "lib/grafics/framebuffer_init.asm"
%include "lib/grafics/framebuffer_fill.asm"
%include "lib/grafics/framebuffer_flush.asm"
%include "lib/grafics/multi_load_images.asm"

%include "lib/mem/heap_init.asm"
%include "lib/mem/heap_allocate.asm"
%include "lib/mem/heap_free.asm"

%include "lib/terminal/raw_mode.asm"
%include "lib/terminal/save_termois.asm"
%include "lib/terminal/reset_termois.asm"
%include "lib/terminal/move_ascii_cursor.asm"

%include "lib/audio/play_audio.asm"
%include "lib/audio/load_audio.asm"

%include "lib/clock_tick.asm"
%include "lib/exit.asm"
%include "lib/to_string.asm"
%include "lib/threading.asm"

%include "src/units.asm"
%include "src/events.asm"
%include "src/render.asm"
%include "src/init.asm"

; section
section .data
    imagesPath db "../images/", 0
    audioMusicFile db "../audio/00_GloriousMorning.wav", 0
    PRINT_BUFFER_LENGTH dq 0

    clear_screen db `\e[2J`, 0

section .bss
    debugMode resb 4
    registers resb 120

    isRunning resb 2

    key resb 8
    
    clock_time resb 16
    time resb 16

    rawTermios resb 48
    oldTermois resb 48
    
    isTermoisSaved resb 2

    fb_file_descriptor resb 8
    fb_width resb 8
    fb_height resb 8
    fb_size resb 8

    screen_Buffer_address resb 8

    imageHeader resb 14
    audioHeader resb 12
    
    camera_coordinates resb 8

    imagesPointer resb 8

    FolderInfoBuffer resb 4096

    PlayerExp resb 8
    PlayerGold resb 8
    PlayerAge resb 8
    PlayerHealth resb 8
    specialAbiltyCooldown resb 8
    nextAgeExpRequirement resb 8
    
    unitQueue resb 8
    unitQueueLength resb 8

    unitsSpawned resb 8
    
    menuHover resb 8
    menuSelected resb 8
    HUDbuttonmsgPtr resb 8
    
    EnemyHealth resb 8

    PRINT_BUFFER resb PRINT_BUFFER_SIZE
    HEAP resb HEAP_SIZE
    STRINGBUFFER resb 24

section .text
    global _start

_backgroundmusic:
    load_audio audioMusicFile

_backgroundmusicLoop:
    play_audio rax

    cmp byte [isRunning], 1
    je _backgroundmusicLoop

    ret

; code
_start:

    call _init

    create_thread _backgroundmusic, 0

    create_thread _unitsUpdate, 0

    sleep 1_000_000 ; sleep 1 sec.

    multi_load_images imagesPath
    mov qword [imagesPointer], rax ; save pointer to images

_whileLoop:
    ;   events (key inputs)
    call _keyLisener

    cmp byte [debugMode], 1
    je _mainDebugMode

    clock_tick 60 ; fps
    cmp rax, 0
    je _whileLoop ; no render

    add qword [PlayerGold], 1
    add qword [PlayerExp], 1
    
    call _render

    cmp dword [specialAbiltyCooldown], 0
    jle _whileLoop ; skip if cooldown is finished
    sub dword [specialAbiltyCooldown], 1

    jmp _whileLoop
    
    call _cleanAndExit


_mainDebugMode:

    clock_tick 1 ; fps
    cmp rax, 0
    je _whileLoop ; no print

    reset_termois

    move_ascii_cursor 2, 0
    print clear_screen
    print_registers

    print_flush

    raw_mode

    jmp _whileLoop

    ; call _cleanAndExit