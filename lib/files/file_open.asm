%ifndef FILEOPEN
%define FILEOPEN

; fd {rax} fileOpen(char* {rdi}, int {rsi}, int {rdx})
;   takes a file name in {rdi}, flags in {rsi} and permissions in {rdx}.
;   returns a file descriptor
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


%endif