%ifndef PRINT_MATRIX
%define PRINT_MATRIX

%include "myLib/print_decimal.asm"
%include "myLib/print_ascii_value.asm"

_printMatrix:
    push rdx

    print_ascii_value 91
    mov r8, rbx
    
_printMatrixLoop:
    movzx rdx, byte [rax]

    
    print_decimal rdx
    
    inc rax
    dec rbx
    jz _printMatrixDone

    print_ascii_value 44
    print_ascii_value 32

    jmp _printMatrixLoop

_printMatrixDone:
    print_ascii_value 93
    
    pop rdx
    
    ret



%macro print_array 2
    push rax
    push rbx
    push rcx

    mov rax, %1
    mov rbx, %2
    call _printMatrix

    pop rax
    pop rbx
    pop rcx
%endmacro

%endif