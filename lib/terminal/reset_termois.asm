%ifndef RESETRAWMODE
%define RESETRAWMODE

%include "lib/io/print.asm"
%include "lib/io/print_flush.asm"

; void resetRawMode(void)
;	resets the terminal back the the terminal settings when save_termois as called.
_resetRawMode:

	push rax
	push rdi
	push rsi
	push rdx

	push rcx
	push r11

	; get old settings
	mov rax, [oldTermois]
	
	; test if the setting was saved
	test rax, rax
	jz _failReset

	; set back the old settings
	mov rax, 16
	mov rdi, 0
	mov rsi, 0x5402
	mov rdx, oldTermois
	syscall

	pop r11
	pop rcx

	pop rdx
	pop rsi
	pop rdi
	pop rax

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


%endif