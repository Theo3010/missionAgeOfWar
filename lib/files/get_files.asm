%ifndef GETFILES
%define GETFILES

%include "lib/io/string_length.asm"
%include "lib/mem/heap_realloc.asm"
%include "lib/mem/memory_copy.asm"

; char* {rax} getFiles(char* {rdi} )
; Reads files from a directory and returns a list of file names.
_getFiles:

    push rbx
    push rcx
    push rsi

    push r11

    mov rax, 2 ; sys_open
    mov rsi, 0 ; flags
    syscall
    mov rbx, rax

    mov r10, 0 ; size of filenames
    heap_allocate 4096 ; allocate buffer for file names {rax}

    mov r9, rax ; save pointer to list

_getFilesRead:
    mov rax, 217 ; sys_getdents64
    mov rdi, rbx ; fd
    mov rsi, FolderInfoBuffer
    mov rdx, 4096
    syscall

    test rax, rax
    je _getFilesdone

    mov rcx, rax

    mov rsi, FolderInfoBuffer

_getFilesLoop:
    movzx rdx, word [rsi + 16] ; reclen

    mov rdi, rsi
    add rdi, 19 ; offset of file name

    cmp byte [rdi], 46
    je _getfilesnext ; skip any directory with '.' as start

    string_length rdi ; get length of file name {rax}
    add r10, rax ; increase total size
    inc r10 ; increase file count for null-terminator

    ; if r10 > 4096
    cmp r10, 4096
    jle _getFilesContinue

    push rax
    heap_realloc r9, r10 ; reallocate buffer for file names
    mov r9, rax ; update pointer to list
    pop rax

_getFilesContinue:
    push rcx
    mov rcx, rax ; save size of file name

    mov rax, r9 ; save base pointer to list

    add r9, r10 ; move to end of list
    sub r9, rcx ; move to start of current file name
    dec r9 ; null-terminate the string

    memory_copy rdi, r9, rcx ; copy file name to list
    mov byte [r9 + rcx + 1], 0 ; null-terminate the string
    
    mov r9, rax ; restore pointer to list

    pop rcx
    ; move back to start of r9 list

_getfilesnext:

    add rsi, rdx
    sub rcx, rdx
    jg _getFilesLoop
    jmp _getFilesRead

_getFilesdone:
    ; add end of list character
    mov byte [r9 + r10], 0xFF ; null-terminate the list
    inc r10

    ; if r10 > 4096
    cmp r10, 4096
    jge _getfilesNoHeapchange


    heap_realloc r9, r10 ; reallocate buffer for file names
    mov r9, rax ; update pointer to list

_getfilesNoHeapchange:
    mov rax, 3
    mov rdi, rbx ; fd
    syscall

    mov rax, r9 ; return the heap pointer

    pop r11
    
    pop rsi
    pop rcx
    pop rbx

    ret


%macro get_files 1
    push rdi

    mov rdi, %1 ; char* path
    call _getFiles

    pop rdi
%endmacro

%endif