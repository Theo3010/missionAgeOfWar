%ifndef PRINT
%define PRINT

%include "myLib/print_ascii_value.asm"

; intput
;   rax - msg to save to buffer
; output
;   
_print:
    push rdx

_printloop:
    mov dl, byte [rax] ; first char into dl

    cmp dl, 0 ; cmp to 0 - end of line char.
    je _printdone

    push rax
    
    movzx rax, dl
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