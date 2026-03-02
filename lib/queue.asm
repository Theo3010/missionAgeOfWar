%ifndef QUEUE
%define QUEUE

%include "lib/error.asm"
%include "lib/mem/heap_allocate.asm"
%include "lib/mem/heap_free.asm"

; 0 - 8 | 8-16 | 16-24 | 24-32 | 32 - 40 | 48 - 56 | 56 - 64 | 64 - 72 | 72 - 80

; void* {rax} queue_init(int {rax})
;   create a queue and returns the pointer to the queue
;   return: pointer to queue
_queueInit:
    
    ; head postion 0 | 8 bytes
    ; tail postion -1 (defualt 10) | 8 bytes
    ; array | 8 bytes
    ; total capacity | 8 bytes
    ; total header size 32 bytes

    push rbx
    push rcx
    
    mov rcx, rax ; total capacity in spaces of 8 each

    heap_allocate 32
    mov rbx, rax

    mov qword [rbx], 0 ; init head
    mov qword [rbx+8], rcx ; init tail 
    mov qword [rbx+24], rcx ; amount of spaces in queue

    shl rcx, 3
    heap_allocate rcx ; allocate 10 spaces of 8 bytes for the array
    mov qword [rbx+16], rax

    mov rax, rbx ; return pointer to queue

    pop rcx
    pop rbx

    ret

%macro queue_init 1

    mov rax, %1
    call _queueInit

%endmacro


; void* {rax} queuePop(Queue {rax})

_queuePop:

    push rbx
    push rcx
    push rdx

    ; get tail
    mov rcx, [rax+8]

    ; move tail
    inc rcx
    cmp rcx, [rax+24]
    jle _queueNoWrap

    ; if out of array then wrap
    mov rcx, 0 ; reset tail postion

_queueNoWrap:
    ; if tail == head then error
    mov rbx, qword [rax] ; head
    cmp rbx, rcx
    je _NoElementInQueueError


    ; get element
    mov rbx, [rax+16] ; get array
    mov rdx, [rbx+rcx*8] ; get element in queue at tail postion
    

    ; update tail
    mov [rax+8], rcx


    ; return element
    mov rax, rdx

    pop rdx
    pop rcx
    pop rbx

    ret


_NoElementInQueueError:
    throw_error .ErrorMsg

.ErrorMsg:
    db "ERROR: No element in queue", 10, 0

%macro queue_pop 1
    mov rax, %1
    call _queuePop
%endmacro


; void queueAdd(Queue {rax}, qword {rbx})
; add element to queue
_queueAdd:

    push rcx
    push rdx

    ; check if head == tail then expand
    mov rcx, [rax] ; header
    mov rdx, [rax+8] ; tail

    cmp rcx, rdx
    jne _queueNoExpand

    push rbx ; save element value

    
    ; create new array size x 2
    mov rcx, [rax+24] ; spaces
    shl rcx, 1 ; double the spaces
    shl rcx, 3 ; rcx spaces of 8 bytes each

    mov rdx, rax ; save queue pointer
    heap_allocate rcx
    mov rcx, rax ; save array pointer


    mov rbx, 0 ; loop counter
    ; for each element pop 
_queueExpandLoop:
    queue_pop rdx
    mov qword [rcx+rbx*8], rax

    
    inc rbx
    cmp rbx, [rdx+24]
    jne _queueExpandLoop
    
    ; free old array
    heap_free [rdx+16]

    ; update array pointer
    mov qword [rdx+16], rcx

    ; update capacity, tail & header
    mov rbx, [rdx+24] ; old capacity
    mov qword [rdx], rbx ; update head | head = old capacity
    shl rbx, 1 ; old capacity x 2
    mov qword [rdx+24], rbx ; update capacity to new capacity size
    mov qword [rdx+8], rbx ; update tail at new capacity size

    mov rax, rdx ; restore queue pointer
    mov rcx, [rax] ; restore head
    pop rbx

_queueNoExpand:

    ; else
    ; add element at head and move head
    mov rdx, [rax+16] ; array
    mov qword [rdx+rcx*8], rbx ; add element to array

    inc rcx ; increment head positon

    cmp rcx, [rax+24]
    jle _queueNoWrapAdd

    ; if out of array then wrap
    mov rcx, 0 ; reset head postion

_queueNoWrapAdd:

    ; if head > end of array then wrap
    mov qword [rax], rcx ; update new head postion

    pop rdx
    pop rcx

    ret


%macro queue_add 2
    push rax
    push rbx

    mov rax, %1
    mov rbx, %2
    call _queueAdd

    pop rbx
    pop rax
%endmacro


; int {rax} queue_length(Queue {rax})
;   take a queue as input and returns the length of items in that queue.
_queueLength:

    push rbx
    push rcx
    push rdx

    mov rbx, [rax] ; head
    dec rbx ; head - 1, since the elment is once slot behind head
    mov rcx, [rax+8] ; tail

    mov rdx, [rax+24] ; capacity
    inc rdx
    sub rbx, rcx; head - tail
    ; if positive dont add capacity
    mov rcx, 0
    cmovns rdx, rcx

    add rbx, rdx ; add capacity (only if negative)

    ; return in rax
    mov rax, rbx

    pop rdx
    pop rcx
    pop rbx

    ret


%macro queue_length 1
    mov rax, %1
    call _queueLength
%endmacro


; void* {rax} queue_peek(Queue {rax}, int {rbx})
; take a queue as input and returns the next element in to queue without change the state of the queue
;   param Queue {rax}: is a pointer to the queue
;   param int {rbx}: is the n'th element in the queue
;   return: returns the element at the n'th element, while keep the state of the queue
_queuePeek:

    push rcx

    mov rcx, rbx
    
    cmp rbx, 0
    je _noElementInQueuePeek

    ; get length of queue
    push rax
    queue_length rax
    mov rbx, rax
    pop rax

    cmp rcx, rbx ; compare length of queue with index
    jg _noElementInQueuePeek

    mov rbx, [rax+8] ; get tail
    ; move tail rbx amount
    add rbx, rcx
    cmp rbx, [rax+24]
    jle _queueNoWrapPeek

    ; if out of array then wrap
    sub rbx, [rax+24] ; subtract capacity (since currently out of bounds rbx > [rax+24])
    dec rbx

_queueNoWrapPeek:
    ; if tail == head then error
    mov rcx, qword [rax] ; head
    cmp rcx, rbx
    je _noElementInQueuePeek

    mov rax, [rax+16] ; get array
    mov rax, [rax+rbx*8] ; get element from array

    pop rcx

    ; return rax
    ret

_noElementInQueuePeek:
    mov rax, -1 ; no element code
    pop rcx

    ret

%macro queue_peek 2

    push rbx

    mov rax, %1
    mov rbx, %2
    call _queuePeek

    pop rbx

%endmacro


%endif