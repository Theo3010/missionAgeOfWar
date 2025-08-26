%ifndef HEAP_ALLOCATE
%define HEAP_ALLOCATE

%include "lib/error.asm"

; void* {rax} heap_allocate(int {rax})
    ;   return a void* to start of allocated memory in {rax}.
    ;   int {rax} is the amount of bytes memory needed.
    ;   int {rax} -1 if failed to allocate.
_heapAllocate:
    push rbx
    push rcx
    push rdx
    push r8
    push r9

    ; size magic
    mov rbx, rax
    test rax, 15
    jz _doneSizeMagic

    and rax, 15
    cmp rax, 8
    jle _eight

    mov rax, rbx
    shr rax, 4
    shl rax, 4
    add rax, 16
    jmp _doneSizeMagic

_eight:
    mov rax, rbx
    shr rax, 3
    shl rax, 3
    add rax, 8

_doneSizeMagic:
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

    cmp rcx, HEAP_SIZE ; check out of memory
    je _errorHeap
    
    add rbx, 8 ; go to next header

    jmp _findSpaceLoop

_allocate:

    mov r8, [rbx] ; save the current free space
    ;   header* = N+1
    mov rdx, rax
    inc rdx
    mov [rbx], rdx
    mov rcx, rbx ; ponter to header
    
    ;   footer = (header+N+16)*
    add rbx, rax
    add rbx, 8 
    mov [rbx], rdx 

    cmp r9, 1 ; check if any free space left
    je _skipFreeSpace

    ;   add free header
    add rbx, 8
    mov rdx, rax ; space allocated
    add rdx, 16 ; header and footer
    sub r8, rdx ; calculate free space left
    mov [rbx], r8

    ; add free footer
    add rbx, r8
    add rbx, 8
    mov [rbx], r8


_skipFreeSpace:
    mov r9, 0 ; reset flag
    
    ;   return
    add rcx, 8
    mov rax, rcx

    jmp _doneHeap

_errorHeap:
    throw_error .errorHeapMsg
    mov rax, -1


.errorHeapMsg:
    db "ERROR: Heap error. Remember to call 'heap_init' before any use of heap. The heap may be out of memory", 0

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