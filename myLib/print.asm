; intput
;   rax - msg to save to buffer
; output
;   
_print:
    push rcx
    push rbx
    push rdx

    mov rcx, PRINT_BUFFER ; pointer to memory
    add rcx, [PRINT_BUFFER_LENGTH]

_printloop:
    mov dl, byte [rax] ; first char into dl

    cmp dl, 0 ; cmp to 0 - end of line char.
    je _printdone

    mov [rcx], dl ; move char into PRINT BUFFER

    mov rbx, 1
    add [PRINT_BUFFER_LENGTH], rbx ; add 1 to total print buffer length

    inc rax ; msg pointer
    inc rcx ; print buffer pointer

    push rax ; save msg

    mov rax, PRINT_BUFFER_SIZE ; total size
    mov rbx, [PRINT_BUFFER_LENGTH] ; current length
    sub rax, rbx ; calculate space left
    cmp rax, 10 ; if within 10 chars left, flush
    jge _noFlush
    
    call _printFlush
    mov rcx, PRINT_BUFFER

_noFlush:
    pop rax ; load counter
   
    jmp _printloop

_printdone:
    pop rcx
    pop rbx
    pop rdx

    ret

%macro print 1
    push rax

    mov rax, %1
    call _print

    pop rax
%endmacro