; input:
;   rdi - file decriptor
_fileClose:
    mov rax, 3
    syscall

    ret


%macro file_close 1
    mov rdi, %1
    call _fileClose
%endmacro