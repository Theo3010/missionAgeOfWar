%ifndef QUEUE
%define QUEUE

; working queue
; missing:
;   - dynamic memory size
;   - error handling

; void* {rax} _queueInit(int {rbx}, size_t {rcx})
;   amount of elements {rbx} and size (byte) of each element {rcx}
_queueInit:

    heap_allocate 24
    ; head = dword {rax}
    ; tail = dword {rax+4}
    ; size_t = dword {rax+8}
    ; total_amount = dword {rax+12}
    ; arrayPtr = qword {rax+16}
    
    ; tail
    mov dword [rax+4], ecx

    ; size_t
    mov dword [rax+8], ecx

    ; amount
    inc ebx ; queue takes one extra space for head
    mov dword [rax+12], ebx
    
    push rax ; save pointer

    imul rcx, rbx
    heap_allocate rcx
    mov rbx, rax

    pop rax
    ; arrayPtr = rax
    mov [rax+16], rbx

    ; return rax = queue

    ret


%macro queue_init 2
    push rbx
    push rcx

    mov rbx, %1
    mov rcx, %2
    call _queueInit

    pop rcx
    pop rbx
%endmacro

; void queueAdd[T](void* {rax}, T {rbx})
;   adds element {rbx} to the queue {rax}. (The size (byte) of the element has to be <= queue's element size)
_queueAdd:
    push rcx
    push rdx

    ; check if tail == head then error
    mov ecx, dword [rax] ; head
    mov edx, dword [rax+4] ; tail

    cmp ecx, edx ; head, tail
    je _queueAddError

    ; array
    mov rcx, [rax+16]

    ; array[tail] = element
    add rcx, rdx
    push rdx

    mov edx, dword [rax+8]
_queueAddLoop:
    mov byte [rcx], bl
    inc rcx
    shr rbx, 8 ; 0x00 0x00 0x00
    dec edx
    jnz _queueAddLoop

    pop rdx

    ; get size_t
    mov rbx, [rax+8]

    ; update tail
    add rdx, rbx
    mov dword [rax+4], edx


    ; check if tail is over
    mov ebx, dword [rax+8] ; size_t
    imul ebx, dword [rax+12] ; total size = size_t * amount
    cmp edx, ebx ; tail, total size
    jge _queueTailWrap

    jmp _queueTailWrapSkip
_queueTailWrap:
    mov dword [rax+4], 0

_queueTailWrapSkip:

    pop rdx
    pop rcx

    ret

_queueAddError:
    throw_error .addErrorMsg

.addErrorMsg:
    db "Queue overflow: Too many elements added to queue", 0

%macro queue_add 2
    push rax
    push rbx

    mov rax, %1
    mov rbx, %2
    call _queueAdd

    pop rbx
    pop rax
%endmacro

; T {rax} queuePop[T](void* {rax})
;   return next element of the queue {rax}.
_queuePop:

    push rbx
    push rcx

    push rax ; save queue pointer

    ; get head
    mov ebx, dword [rax]

    ; update head
    mov ecx, dword [rax+8] ; size_T
    add ecx, ebx
    mov dword [rax], ecx

    ; get array
    mov rcx, [rax+16]

    add rcx, rbx

    mov ebx, dword [rax+8]
    add rcx, rbx
    dec rcx
    xor rax, rax
_queuePopLoop:
    shl rax, 8
    mov al, byte [rcx]
    dec rcx
    
    dec ebx
    jnz _queuePopLoop

    mov rcx, rax
    pop rax ; queue pointer

    ; check if head is over
    mov edx, [rax] ; head
    mov rbx, [rax+8] ; size_t
    imul rbx, [rax+12] ; total size = size_t * amount
    cmp edx, ebx ; head, total size
    jge _queueHeadWrap

    jmp _queueHeadWrapSkip
_queueHeadWrap:
    mov dword [rax], 0

_queueHeadWrapSkip:

    mov rax, rcx ; return rax

    pop rcx
    pop rbx

    ret

_queuePopNoElementError:
    throw_error .queueNoElementErrorMsg


.queueNoElementErrorMsg:
    db "queue underflow: No elements in queue", 0


%macro queue_pop 1

    mov rax, %1
    call _queuePop
%endmacro


%endif