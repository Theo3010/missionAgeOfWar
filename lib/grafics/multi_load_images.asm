%ifndef MULTI_LOAD_IMAGES
%define MULTI_LOAD_IMAGES

%include "lib/grafics/load_image.asm"
%include "lib/files/get_files.asm"

%include "lib/io/string_concat.asm"

%include "lib/mem/heap_allocate.asm"

%include "lib/math/sort.asm"
%include "lib/nextzero.asm"

; void* {rax} multi_load_images(char* folderPath {rdi});
_multiLoadImages:

    ; get files in folderPath
    get_files rdi

    ; sort files
    sort rax
    mov rdi, rax ; save pointer to sorted files

    ; get the number of files
    mov rcx, 0
_getfilescount:
    inc rcx
    next_zero rax
    cmp rax, -1
    jne _getfilescount

    ; 8 bytes (one pointer) for each image
    shl rcx, 3 ; multiply by 8 to get the size in bytes


    ; make a heap allocation for the pointer of each image
    heap_allocate rcx
    mov rbx, rax ; save pointer to the allocated memory

    ; load each image one by one and save the pointer to the list
_nultiloadImageloop:

    ; get the relative path of the image
    string_concat imagesPath, rdi

    load_image rax

    mov [rbx], rax ; save the pointer to the image in the list
    add rbx, 8 ; move to the next pointer in the list
    
    next_zero rdi
    mov rdi, rax ; update rdi to the next image name
    cmp rdi, -1
    jne _nultiloadImageloop

    sub rbx, rcx
    mov rax, rbx ; return the pointer to the list of images

    ret

%macro multi_load_images 1
    push rdi
    
    mov rdi, %1
    call _multiLoadImages
    
    pop rdi
%endmacro

%endif