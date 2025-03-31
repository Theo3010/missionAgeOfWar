%ifndef MOVE_ASCII_CURSOR
%define MOVE_ASCII_CURSOR

_moveAsciiCursor:

    print_ascii_value 27 ; backslash (note: dangerous even in comments)
    print_ascii_value 91 ; e
    print_decimal rax    ; colum
    print_ascii_value 59 ; ;
    print_decimal rbx    ; row
    print_ascii_value 72 ; H
    
    ret

%macro move_ascii_cursor 2
    push rax
    push rbx

    mov rax, %1
    mov rbx, %2

    call _moveAsciiCursor

    pop rbx
    pop rax

%endmacro


%endif