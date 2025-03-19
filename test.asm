%define PRINT_BUFFER_SIZE 1024
%define HEAP_SIZE 128


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


; %include "myLib/get_input.asm"
; %include "myLib/to_integer.asm"


; %include "myLib/rand_int.asm"

; %include "myLib/get_time.asm"
; %include "myLib/sleep.asm"

; %include "myLib/raw_mode.asm"
; %include "myLib/save_termois.asm"
; %include "myLib/reset_termois.asm"

%include "myLib/file_open.asm"
%include "myLib/file_close.asm"
%include "myLib/file_read.asm"


section .data
    allocation db "allocate memory at: ", 0
    PRINT_BUFFER_LENGTH dq 0
    fbfileName db "/dev/fb0", 0
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


_start:


    file_open fbfileName, 2, 0644o

    mov rdi, rax
    mov rsi, 0x4600
    mov rdx, framebufferInfo
    mov rax, 16
    syscall

    print xRes
    mov rbx, 0
    mov ebx, [framebufferInfo+0]
    print_decimal rbx
    print_ascii_value 10

    print yRes
    mov rbx, 0
    mov ebx, [framebufferInfo+4]
    print_decimal rbx
    print_ascii_value 10

    print bitsPrPixel
    mov rbx, 0
    mov ebx, [framebufferInfo+24]
    print_decimal rbx
    print_ascii_value 10

    print screenBufferSize
    mov rbx, 0
    mov ebx, [framebufferInfo+0]
    imul ebx, [framebufferInfo+4]
    imul ebx, [framebufferInfo+24]
    shr ebx, 3
    print_decimal rbx
    print_ascii_value 10

    print_flush

    exit