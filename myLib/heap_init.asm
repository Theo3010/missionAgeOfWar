%ifndef HEAPINIT
%define HEAPINIT

_heapInit:
    mov rax, HEAP

    mov byte [rax], HEAP_SIZE-16

    add rax, HEAP_SIZE

    mov byte [rax-8], HEAP_SIZE-16

    ret

%macro heap_init 0
    
    call _heapInit
%endmacro

%endif