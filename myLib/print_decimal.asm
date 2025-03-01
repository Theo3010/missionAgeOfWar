
; input:
;   rax number to be printed
; output:
;   add number to print buffer

_printDecimal:
    push rax
    push rbx
    push rcx
    push rdx
    push r10

    mov rbx, 0 ; counter

    mov rcx, PRINT_BUFFER ; address of the print buffer 
    add rcx, [PRINT_BUFFER_LENGTH] ; add the length of current buffer

_loopDigit:
    mov rdx, 0
    
    mov r10, 10
    div r10 ; div rax with 10 = 14 | 2

    add rdx, 48

    push rdx
    inc rbx
    
    cmp rax, 0
    je _loopAddBuffer

    jmp _loopDigit

_loopAddBuffer:
    pop rax ; get number of stack

    mov [rcx], rax ; add to bufffer
    inc rcx ; move buffer pointer

    ; add one to the total length of buffer
    mov rdx, 1
    add [PRINT_BUFFER_LENGTH], rdx

    dec rbx ; counter
    cmp rbx, 0
    jne _loopAddBuffer

    pop r10
    pop rdx
    pop rcx
    pop rbx
    pop rax

    ret

%macro print_decimal 1
    push rax

    mov rax, %1
    call _printDecimal

    pop rax
%endmacro