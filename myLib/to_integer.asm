; int {rax} toInteger(String {rax})
;   returns rax as a decimal integer.
_toInteger:

    push rcx
    push rdx

    mov rcx, 0 ; temp result

_toIntegerLoop:

    push rax ; save msg

    mov dl, byte [rax]

    sub dl, 48 ; convert from ascii value

    cmp dl, 0 ; check for value less than 0
    jle _done ; if so, end of line, jmp to done


    movzx rdx, dl
    push rdx

    mov rax, rcx
    mov rdx, 10
    mul rdx ; rcx (current result) * rbx (digt place)
    mov rcx, rax

    pop rdx
    
    
    add rcx, rdx ; add digit to current sum
    
    pop rax

    inc rax

    jmp _toIntegerLoop

_done:
    mov rax, rcx

    pop rdx
    pop rcx

    ret


%macro to_integer 1
    
    mov rax, %1
    call _toInteger
%endmacro to_integer