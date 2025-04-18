%ifndef TEXT_COPY
%define TEXT_COPY

_textCopy:
    push rdx
    push r10

    ; get bit from rax
    movzx rdx, byte [rax] ; 8 bits

_textCopyRow:
    ; if 0 then no pixel
    mov r10, r8 ; copy of font size
    
    test rdx, 0b10000000 ; check if last bit is 1.
    jz _noPixel

    ; else then pixel
    ; then color pixel font color
_textCopyColoring:
    mov dword [rbx], r9d ; color
    add rbx, 4 ; move one pixel
    ; repeat font size times
    dec r10
    jnz _textCopyColoring

    jmp _nextChar

_noPixel:
    ; move pointer of rbx font size
    mov r10, r8
    shl r10, 2 ; font_size * 4 (due to pixel size)
    add rbx, r10 ; add font size

    ; mov dword [rbx], 0x00FFFFFF ; color
    ; add rbx, 4 ; move one pixel
    ; ; repeat font size times
    ; dec r10
    ; jnz _noPixel

_nextChar:
    shl rdx, 1 ; next bit
    dec rcx
    jnz _textCopyRow

    pop r10
    pop rdx

    ret


%macro text_copy 5

    push rax
    push rbx
    push rcx
    push r8
    push r9

    mov rax, %1
    mov rbx, %2
    mov rcx, %3
    mov r8, %4
    mov r9, %5
    call _textCopy

    pop r9
    pop r8
    pop rcx
    pop rbx
    pop rax

%endmacro

%endif