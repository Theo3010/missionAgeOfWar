%ifndef ERROR
%define ERROR

%include "lib/terminal/reset_termois.asm"
%include "lib/terminal/move_ascii_cursor.asm"
%include "lib/io/print.asm"
%include "lib/io/print_ascii_value.asm"
%include "lib/io/print_flush.asm"
%include "lib/exit.asm"

; void throwError(char* {rax})
;   error msg in {rax}
_throwError:
    ; clean up
    reset_termois

    ; clear screen
    move_ascii_cursor 0, 0
    print .clearScreen

    ; error msg
    move_ascii_cursor 2, 0
    print rax
    print_ascii_value 10
    print_flush
    
    ; exit
    exit

.clearScreen:
    db `\e[2J`, 0


%macro throw_error 1

    mov rax, %1
    jmp _throwError
%endmacro

%endif