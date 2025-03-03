%include "myLib/print.asm"
%include "myLib/print_flush.asm"

_resetRawMode:

	mov rax, [oldTermois]
	
	test rax, rax
	jz _failReset

	mov rax, 16
	mov rdi, 0
	mov rsi, 0x5402
	mov rdx, oldTermois
	syscall

    ret

_failReset:
	print .failMsg
	print_flush

	ret


.failMsg:
	db "You need first save termios!", 10, 0


%macro reset_termois 0
    call _resetRawMode
%endmacro
