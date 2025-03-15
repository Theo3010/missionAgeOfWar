%define PRINT_BUFFER_SIZE 1024
%define HEAP_SIZE 128


%include "myLib/exit.asm"
%include "myLib/heap_init.asm"
%include "myLib/heap_allocate.asm"

%include "myLib/print_flush.asm"
%include "myLib/print.asm"
%include "myLib/print_decimal.asm"
%include "myLib/print_hex.asm"
%include "myLib/print_binary.asm"
%include "myLib/print_ascii_value.asm"
%include "myLib/print_array.asm"
%include "myLib/print_memory.asm"

; %include "myLib/get_input.asm"
; %include "myLib/to_integer.asm"


; %include "myLib/rand_int.asm"

; %include "myLib/get_time.asm"
; %include "myLib/sleep.asm"

; %include "myLib/raw_mode.asm"
; %include "myLib/save_termois.asm"
; %include "myLib/reset_termois.asm"

; %include "myLib/file_open.asm"
; %include "myLib/file_close.asm"
; %include "myLib/file_read.asm"


section .data
    error db "Got a number outside range ", 0
    msg2 db "2 secounds has pased", 10, 0
    num db "142", 10, 0
    allocation db "allocate memory at: ", 0
    clear_screen db 27, 91, 50, 74, 0
    filename db "test.txt", 0
    PRINT_BUFFER_LENGTH dq 0

section .bss
    input resb 16
    digitPointer resb 8
    time resb 16

    oldTermois resb 48
    rawTermios resb 48
    key resb 4

    PRINT_BUFFER resb PRINT_BUFFER_SIZE
    HEAP resb HEAP_SIZE

section .text
    global _start


_start:

    heap_init

    heap_allocate 16
    heap_allocate 24

    print allocation
    print_hex rax
    print_ascii_value 10
    print_memory HEAP, 8, 16

    print_flush

    exit