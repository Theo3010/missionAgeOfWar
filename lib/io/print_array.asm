%ifndef PRINT_ARRAY
%define PRINT_ARRAY

%include "lib/io/print_decimal.asm"
%include "lib/io/print_ascii_value.asm"


; void printArray(int* {rax}, int {rbx})
;   prints thte array in {rax} and width length {rbx} to the PRINT BUFFER.
_printArray:
    push rdx

    print_ascii_value 91 ; [
    
_printArrayLoop:
    movzx rdx, byte [rax]

    print_decimal rdx
    
    inc rax
    dec rbx
    jz _printArrayDone

    print_ascii_value 44 ; ,
    print_ascii_value 32 ; space

    jmp _printArrayLoop

_printArrayDone:
    print_ascii_value 93 ; ]
    
    pop rdx
    
    ret

%macro print_array 2
    push rax
    push rbx

    mov rax, %1
    mov rbx, %2
    call _printArray

    pop rax
    pop rbx
%endmacro

%endif