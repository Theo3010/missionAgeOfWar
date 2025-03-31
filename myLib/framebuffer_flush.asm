%ifndef FRMAEBUFFER_FLUSH
%define FRMAEBUFFER_FLUSH


; void framebufferFlush(void)
;   write screenbuffer (my buffer located on the heap) to the framebuffer (/dev/fb0).
_framebufferFlush:
	push rax
	push rdi
	push rsi
	push rdx

	push rcx
	push r11

    file_write [fb_file_descriptor], [screen_Buffer_address], [fb_size] ; write to /dev/fb0

    ; go back to top of the framebuffer file (/dev/fb0)
	mov rax, 8 ; sys_lseek
	movzx rdi, byte [fb_file_descriptor]
	mov rsi, 0
	mov rdx, 0 ; start of file
	syscall

	pop r11
	pop rcx

	pop rdx
	pop rsi
	pop rdi
	pop rax

    ret


%macro framebuffer_flush 0
    call _framebufferFlush
%endmacro

%endif
