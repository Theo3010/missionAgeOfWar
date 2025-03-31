%ifndef FILE_CLOSE
%define FILE_CLOSE


; void fileClose(fd {rdi})
_fileClose:
    push rax

    mov rax, 3
    syscall

    pop rax
    ret

%macro file_close 1
    push rdi

    mov rdi, %1
    call _fileClose

    pop rdi
%endmacro

%endif