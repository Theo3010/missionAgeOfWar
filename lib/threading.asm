%ifndef THREADING
%define THREADING


; int* thread_id {rax} create_thread(void *function {r14}, void* argv {rdx});
_createThread:

    push rdi
    push rsi

    push rcx
    push r11
    
    ; new stack
    heap_allocate 4096

    ; point to top of stack - 8
    add rax, 4096
    mov rsi, rax

    ; sys_clone
    mov rax, 56 ; sys_clone
    mov rdi, 0x100                 ; CLONE_VM
    or  rdi, 0x200                 ; | CLONE_FS
    or  rdi, 0x400                 ; | CLONE_FILES  
    or  rdi, 0x800                 ; | CLONE_SIGHAND
    or  rdi, 0x10000               ; | CLONE_THREAD
    syscall

    ; branch
    cmp rax, 0
    jne _createThreadReturn

    ; child call function(arg) | args rdx
    call r14

    exit

_createThreadReturn:
    ; rax = thread id

    pop r11
    pop rcx

    pop rsi
    pop rdi

    ret

%macro create_thread 2
    push r14
    push rdx

    mov r14, %1
    mov rdx, %2
    call _createThread

    pop rdx
    pop r14
%endmacro

%endif