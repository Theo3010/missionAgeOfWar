
; input:
;   rdi - file name
;   rsi - flags e.g O_READONLY
;   rdx - permissions
_fileOpen:
    mov rax, 2
    syscall

    ret

%macro file_open 3
    mov rdi, %1
    mov rsi, %2
    mov rdx, %3
    call _fileOpen
%endmacro
