%define PRINT_BUFFER_SIZE 1024
%define HEAP_SIZE 0x1000000 ; ~ 16 MB


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


%include "myLib/get_input.asm"
%include "myLib/to_integer.asm"


%include "myLib/rand_int.asm"

%include "myLib/get_time.asm"
%include "myLib/sleep.asm"

%include "myLib/file_open.asm"
%include "myLib/file_read.asm"
%include "myLib/file_write.asm"
%include "myLib/file_close.asm"

%include "myLib/get_screenInfo.asm"
%include "myLib/calc_bitsPrPixel.asm"


section .data
    allocation db "allocate memory at: ", 0
    PRINT_BUFFER_LENGTH dq 0
    fbfileName db `/dev/fb0\0`
    xRes db "X-resolution: ", 0
    yRes db "Y-resolution: ", 0
    bitsPrPixel db "bits per pixel: ", 0
    screenBufferSize db "screenBuffer size (bytes): ", 0

section .bss
    input resb 16
    digitPointer resb 8
    time resb 16

    framebufferInfo resb 1280

    PRINT_BUFFER resb PRINT_BUFFER_SIZE
    HEAP resb HEAP_SIZE

section .text
    global _start


_printHeap:
    mov rax, HEAP
    print_memory rax, 8, 8
    print_ascii_value 46
    print_ascii_value 46
    print_ascii_value 46
    print_ascii_value 10
    add rax, HEAP_SIZE - 0x40
    print_memory rax, 8, 8
    print_ascii_value 10
    print_ascii_value 10

    ret

_start:

    file_open fbfileName, 2, 0644o ; fd rax = /dev/fb0
    mov r15, rax

    get_screenInfo framebufferInfo, rax ; read framebuffer info from /dev/fb0

    calc_Bit_Pr_Pixel ; int rax = bits per pixel

    mov rbx, rax
    mov r10, rax
    shr rbx, 3 ; div with 8

    heap_init ; init heap

    heap_allocate rax ; int* rax = heap memory

    push rax ; save pointer

_loopsiloop:
    mov rcx, 0x00FF0000 ; red
    mov [rax], rcx ; set pixel to red
    add rax, 8 ; jump to next pixel
    dec rbx
    jnz _loopsiloop

    pop rax ; get base pointer of screenbuffer
    file_write r15, rax, r10 ; r15 is fd | rax is screenbuffer | r10 is size.

    file_close r15 ; close file.

    print_flush

    exit