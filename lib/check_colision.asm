%ifndef CHECKCOLISION
%define CHECKCOLISION

; void checkColision(unit {rbx}, unit {rcx})
; check if there is colision between the two units
; requirments:
;   the first unit {rbx} is the unit of the left side.
;   the secund unit {rcx} is a unit to the right of the first unit
; returns:
;   sets the z flag
;       z = 1 no colision
;       z = 0 colision
_checkColision:

    push rdx
    push rdi

    ; get first unit's far colision point
    mov dx, word [rbx+12]

    ; get secund unit's near colision point
    mov di, word [rcx+10]

    add dx, 16 ; colision offset

    cmp dx, di
    jge _colision

    mov rdx, 0
    test rdx, rdx ; zf = 0

    pop rdi
    pop rdx

    ret

_colision:
    mov rdx, 1
    test rdx, rdx ; zf = 1

    pop rdi
    pop rdx

    ret


%macro check_colision 2

    push rbx
    push rcx

    mov rbx, %1
    mov rcx, %2
    call _checkColision

    pop rcx
    pop rbx 
%endmacro


%endif