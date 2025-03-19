%ifndef HEAP_ALLOCATE
%define HEAP_ALLOCATE

; int* {rax} heap_allocate(int {rax})
    ;   return a int* to start of allocated memory in {rax}.
    ;   int {rax} is the size of memory needed
    ;   int {rax} -1 if failed to allocate
_heapAllocate:
    push rbx
    push rcx
    push rdx
    push r8
    push r9

    ; header = get_header(0)
    mov rbx, HEAP
    
    ; findSpaceLoop
_findSpaceLoop:
    ; if header.allocated
    mov rcx, [rbx]
    and rcx, 7

    cmp rcx, 0 ; if allocated go next
    jne _goNextHeader

    ; if header.size > N+16:
    mov rcx, [rbx]
    mov rdx, rax
    add rdx, 16
    cmp rcx, rdx
    jg _allocate

    ; if header.size > N
    mov rcx, [rbx]
    mov r9, 1
    cmp rcx, rax
    jge _allocate

_goNextHeader:
    mov rcx, [rbx] ; get header value

    shr rcx, 3 ; remove flags
    shl rcx, 3
    add rbx, rcx ; skip allocated memory
    
    add rbx, 8 ; footer

    ; check for out of memory
    mov rcx, rbx
    sub rcx, HEAP
    add rcx, 8

    cmp rcx, HEAP_SIZE ; check out of memory footer
    je _errorHeap
    
    add rbx, 8 ; go to next header

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

    cmp r9, 1 ; check if any free space left
    je _skipFreeSpace

    ;   add free header
    add rbx, 8
    mov rdx, rax ; space allocated
    add rdx, 16 ; header and footer
    sub r8, rdx ; calculate free space left
    mov byte [rbx], r8b

    ; add free footer
    add rbx, r8
    add rbx, 8
    mov byte [rbx], r8b


_skipFreeSpace:
    mov r9, 0 ; reset flag
    
    ;   return
    add rcx, 8
    mov rax, rcx

    jmp _doneHeap

_errorHeap:
    mov rax, -1

_doneHeap:
    pop r9
    pop r8
    pop rdx
    pop rcx
    pop rbx
    ret


%macro heap_allocate 1

    mov rax, %1
    call _heapAllocate

%endmacro

%endif