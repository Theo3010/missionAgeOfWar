%ifndef HEAPINIT
%define HEAPINIT

; void heapInit(void)
;   initialize the heap
_heapInit:
    push rax

    mov rax, HEAP ; heap pointer

    mov qword [rax], HEAP_SIZE-16 ; set header

    add rax, HEAP_SIZE ; goto footer

    mov qword [rax-8], HEAP_SIZE-16 ; set footer

    pop rax

    ret

%macro heap_init 0
    
    call _heapInit
%endmacro

%endif