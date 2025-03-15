%ifndef HEAP_ALLOCATE
%define HEAP_ALLOCATE

%include "myLib/print_hex.asm"
%include "myLib/print_ascii_value.asm"

; int* {rax} heap_allocate(int {rax})
    ;   return a int* to start of allocated memory in {rax}.
    ;   int {rax} is the size of memory needed
    ;   int {rax} -1 if failed to allocate
_heapAllocate:

    ; header = get_header(0)
    mov rbx, HEAP
    
    ; findSpaceLoop
_findSpaceLoop:
    ; if header.allocated
    mov rcx, [rbx]
    and rcx, 7


    cmp rcx, 2
    je _error

    cmp rcx, 0 ; if allocated go next
    jne _goNextHeader

    ; if header.size < N+16:
    mov rcx, [rbx]
    mov rdx, rax
    add rdx, 16
    cmp rcx, rdx
    jge _allocate

_goNextHeader:
    mov rcx, [rbx] ; get header value

    shr rcx, 3 ; remove flags
    shl rcx, 3
    add rbx, rcx ; skip allocated memory
    add rbx, 16

    jmp _findSpaceLoop

_allocate:

    movzx r8, byte [rbx] ; save the current free space
    ;   header* = N+1
    mov rdx, rax
    inc rdx
    mov byte [rbx], dl
    mov rcx, rbx ; ponter to header
    
    ;   footer = (header+N+16)*
    add rbx, rax
    add rbx, 8 
    mov byte [rbx], dl 
    

    ;   add free header
    add rbx, 8
    mov rdx, rax ; space allocated
    add rdx, 16 ; header and footer
    sub r8, rdx ; calculate free space left
    mov byte [rbx], r8b

    add rbx, r8
    add rbx, 8
    mov byte [rbx], r8b

    ;   return
    add rcx, 8
    mov rax, rcx

    ret

_error:
    mov rax, -1

    ret


%macro heap_allocate 1

    mov rax, %1
    call _heapAllocate

%endmacro

%endif