%define PRINT_BUFFER_SIZE 1024
%define HEAP_SIZE 0x10000000 ; ~16 MB



%include "lib/exit.asm"
%include "lib/io/print.asm"
%include "lib/io/print_flush.asm"
%include "lib/io/print_memory.asm"
%include "lib/mem/heap_init.asm"
%include "lib/mem/heap_allocate.asm"


%include "lib/foreach.asm"
%include "lib/queue.asm"

section .data
    msg db "Hello, world", 10

section .bss
    isTermoisSaved resb 2
    oldTermois resb 48

    PRINT_BUFFER_LENGTH resb 8
    PRINT_BUFFER resb PRINT_BUFFER_SIZE
    HEAP resb HEAP_SIZE

section .text
    global _start

_start:

    heap_init

    queue_init 5
    mov r10, rax

    queue_add r10, 0x11
    queue_add r10, 0x22
    queue_add r10, 0x33
    queue_add r10, 0x44
    queue_add r10, 0x55

    print_ascii_value 10
    print_flush
    exit


_printEachElement:
    print_hex rax
    print_ascii_value 10
    print_flush
    ret

_error:
    throw_error .starterror

.starterror:
    db "error in queue pop element"