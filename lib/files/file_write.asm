%ifndef FILE_WRITE
%define FILE_WRITE


; int {rax} fileWrite(fd {rdi}, char* {rsi}, size_t {rdx})
;   takes file descriptor in {rax} and char pointer in {rbx} and the amount of data to write in {rcx}
;   returns the amount of written data. 
_fileWrite:

    push rcx
    push r11

    mov rax, 1 ; sys_write
    syscall

    pop r11
    pop rcx
    
    ret


%macro file_write 3
    push rdi
    push rsi
    push rdx

    mov rdi, %1
    mov rsi, %2
    mov rdx, %3
    call _fileWrite

    pop rdi
    pop rsi
    pop rdx

%endmacro

%endif