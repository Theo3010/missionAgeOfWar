%ifndef STRINGLENGTH
%define STRINGLENGTH

; int {rax} stringLength{char* {rax}}
;   returns the length of the string.
_stringLength:
    push rbx
    push rcx

    mov rbx, 0 ; counter

_stringLengthLoop:
    mov cl, byte [rax]
    inc rax

    cmp cl, 0
    je _stringLengthDone

    inc rbx
    jmp _stringLengthLoop

_stringLengthDone:
    mov rax, rbx

    pop rcx
    pop rbx
    ret

%macro string_length 1

    mov rax, %1
    call _stringLength

%endmacro

%endif