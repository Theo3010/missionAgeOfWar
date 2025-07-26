_saveTermois:
	push rax
	push rdi
	push rsi
	push rdx

	push rcx
	push r11

	mov rax, 16
	mov rdi, 0
	mov rsi, 0x5401
	mov rdx, oldTermois
	syscall

	xor r10, r10         ; r10 = 0
	mov r11, 1           ; r11 = 1
	test rax, rax
	cmovz r10, r11       ; if rax == 0, r10 = 1 else r10 = 0
	mov [isTermoisSaved], r10

	pop r11
	pop rcx
	
	pop rdx
	pop rsi
	pop rdi
	pop rax

    ret


%macro save_termois 0
    call _saveTermois
%endmacro