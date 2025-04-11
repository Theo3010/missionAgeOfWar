%ifndef RAWMODE
%define RAWMODE
; termios input flags
%define SYS_IGNBRK 0x1 ; ignore BREAK condition
%define SYS_BRKINT 0x2 ; map BREAK to SIGINTR
%define SYS_PARMRK 0x8 ; mark parity and framing errors
%define SYS_ISTRIP 0x20 ; strip 8th bit off chars
%define SYS_INLCR 0x40 ; map newline to carriage return
%define SYS_IGNCR 0x80 ; ignore carriage return
%define SYS_ICRNL 0x100 ; map carriage return to newline
%define SYS_IXON 0x400 ; enable output flow control

; termios output flags
%define SYS_OPOST 0x1 ; enable ouput processing

; termios control flags
%define SYS_CSIZE 0x30 ; character size mask
%define SYS_CS8 0x30	; 8 bits
%define SYS_PARENB 0x100 ; parity enable

; termios local flags
%define SYS_ECHO 0x8 ; enable echoing
%define SYS_ECHONL 0x40 ; echo newline even if ECHO is off
%define SYS_ICANON 0x2 ; canonicalize input lines
%define SYS_ISIG 0x1 ; enable INTR, QUIT, (D)SUSP signals
%define SYS_IEXTEN 0x8000 ; enable DISCARD and LNEXT

%include "lib/io/print.asm"
%include "lib/io/print_flush.asm"

; void rawMode(void)
;	set the terminal to raw mode (each key gets recived as a number and will not be shown in the terminal)
_rawMode:

	push rax
	push rdi
	push rsi
	push rdx

	push rcx
	push r11

	mov rax, [oldTermois]
	
	test rax, rax
	jz _failRawMode

	; copy base termois
	mov [rawTermios], rax

	; adjust "new" termios for raw mode
	and dword [rawTermios], ~(SYS_IGNBRK+SYS_BRKINT+SYS_PARMRK+SYS_ISTRIP+SYS_INLCR+SYS_IGNCR+SYS_ICRNL+SYS_IXON)
	and dword [rawTermios+4], ~SYS_OPOST
	and dword [rawTermios+8], ~(SYS_CSIZE+SYS_PARENB)
	or dword [rawTermios+8], SYS_CS8
	and dword [rawTermios+12], ~(SYS_ICANON+SYS_ECHO+SYS_ECHONL+SYS_ISIG+SYS_IEXTEN)

	mov rax, 16
	mov rdi, 0
	mov rsi, 0x5402
	mov rdx, rawTermios
	syscall

	pop r11
	pop rcx

	pop rdx
	pop rsi
	pop rdi
	pop rax

    ret

_failRawMode:

	print .failMsg
	print_flush

	ret


.failMsg:
	db "You need first save termios!", 10, 0


%macro raw_mode 0
    call _rawMode
%endmacro

%endif
