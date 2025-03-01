; input:
;   rax - mimium number
;   rbx - maxium number
; output:
;   rax - a random number between rax and rbx (inclusive)
_randInt:
    push rdx
    push rcx

    inc rbx ; inc the max by one - due to moduls can never produce the number itself

_randLoop:
    rdrand rcx ; random number (usually big number)
    jnc _randLoop

    sub rbx, rax ; get the diff between min and max
    
    push rax ; save min
    mov rax, rcx ; move (big) random number into rax

    mov rdx, 0 ; due to division rdx:rax/reg
    div rbx ; divide big number with dif to get a number in the interval [0, diff] (saved in rdx)
    
    pop rax ; restore min
    add rdx, rax ; then add min to the interval to get [min, max]

    mov rax, rdx ; return rax

    pop rcx
    pop rdx

    ret


%macro rand_int 2
    push rbx
    
    mov rax, %1
    mov rbx, %2
    call _randInt

    pop rbx
%endmacro