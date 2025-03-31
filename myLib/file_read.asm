
; void file_read(file descriptor {rdi}, buffer {rsi}, length {rdx});
;   reads file content
_fileRead:
    push rax
    push r11

    mov rax, 0 ; sys_read
    syscall

    pop r11
    pop rax

    ret


%macro file_read 3
    push rdi
    push rsi
    push rdx

    mov rdi, %1
    mov rsi, %2
    mov rdx, %3
    call _fileRead

    pop rdx
    pop rsi
    pop rdi

%endmacro