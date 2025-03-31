%ifndef PRINT
%define PRINT

%include "lib/io/print_ascii_value.asm"

; void print(char* {rax})
;   takes a char pointer in {rax} and prints to PRINT BUFFER
_print:
    push rdx

_printloop:
    mov dl, byte [rax] ; first char into dl

    cmp dl, 0 ; cmp to 0 - end of line char.
    je _printdone

    push rax
    
    mov al, dl
    call _printAsciiValue
    
    pop rax

    inc rax ; msg pointer

    jmp _printloop

_printdone:
    pop rdx

    ret

%macro print 1
    push rax

    mov rax, %1
    call _print

    pop rax
%endmacro

%endif