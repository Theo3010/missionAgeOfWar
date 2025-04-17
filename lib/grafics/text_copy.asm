%ifndef TEXT_COPY
%define TEXT_COPY

_textCopy:
    push rdx

    ; rax
    ; 8 bytes

_textCopyLoop:
    ; take element from rax
    movzx rdx, byte [rax]
    
    inc rax ; move pointer

    mov r8, 200 ; font size
    
    cmp rdx, 0
    je _textCopyskip

    mov rdx, 0x00FF0000 ; font color
_textCopyFontSize:

    ; place ement at rbx
    mov dword [rbx], edx

_textCopyskip:
    add rbx, 4 ; move pointer (one pixel)

    dec r8
    jnz _textCopyFontSize

    ; dec rcx
    dec rcx
    jnz _textCopyLoop

    pop rdx
    ret


%macro text_copy 5

    push rax
    push rbx
    push rcx

    mov rax, %1
    mov rbx, %2
    mov rcx, %3
    call _textCopy

    pop rcx
    pop rbx
    pop rax

%endmacro

%endif