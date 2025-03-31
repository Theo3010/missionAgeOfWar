%ifndef LOAD_IMAGE
%define LOAD_IMAGE

; int* {rax} loadImage(char* {rax})
;   take a filename in {rax} and load image
;   returns pointer to loaded image
_loadImage:
    push rbx
    push r10

    file_open rax, 0, 0644o ; open file
    mov r10, rax ; save fd

    file_read r10, imageHeader, 14 ; image header

    mov word ax, [imageHeader] ; get file type
    
    cmp ax, 0x4d42 ; check if bmp file
    jne _errorLoadingBmp

    ; get size of bmp
    mov rbx, 0
    mov dword ebx, [imageHeader+2]
    sub ebx, 14 ; remove the 14 allready read byes.

    heap_allocate rbx ; allocate space for the image

    file_read r10, rax, rbx ; read full file into heap
    
    file_close r10

    ; return rax = heap pointer

    pop r10
    pop rbx

    ret


_errorLoadingBmp:
    print errorBmp
    print_flush
    ret

%macro load_image 1
    mov rax, %1
    call _loadImage
%endmacro

%endif
