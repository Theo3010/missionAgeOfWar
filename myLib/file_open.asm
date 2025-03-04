
; input:
;   rdi - file name
;   rsi - flags e.g O_READONLY
;   rdx - permissions
; output:
;   rax - file descriptor
_fileOpen:
    mov rax, 2
    syscall

    ret

%macro file_open 3
    push rdi
    push rsi
    push rdx

    mov rdi, %1
    mov rsi, %2
    mov rdx, %3
    call _fileOpen

    pop rdx
    pop rsi
    pop rdi
%endmacro
