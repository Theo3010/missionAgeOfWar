%ifndef TOSTRING
%define TOSTRING

; char* {rax} toString(int {rax})
;   converts the integer to a string
_toString:

    push rbx
    push rcx
    push rdx

    mov rcx, 0 ; digit counter
    mov rbx, 10 ; digit base

_toStringLoop1:
    mov rdx, 0
    div rbx ; rax = 14, rdx = 2
    push rdx
    inc rcx
    
    cmp rax, 0
    jnz _toStringLoop1

    mov rbx, STRINGBUFFER

_toStringLoop2:
    pop rdx ; rdx = 1
    add rdx, 48
    mov byte [rbx], dl
    inc rbx
    dec rcx
    jnz _toStringLoop2

    mov byte [rbx], 0

    mov rax, STRINGBUFFER    

    pop rdx
    pop rcx
    pop rbx

    ret


%macro to_string 1
    
    mov rax, %1
    call _toString

%endmacro


%endif