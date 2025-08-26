%include "lib/queue.asm"
%include "lib/to_string.asm"
%include "lib/grafics/set_text.asm"

; void _unitCreate(int unitType {rbx})
; creates a unit of type unitType
_unitCreate:

    ; check if unit queue is full
    mov rax, [unitQueueLength] ; get current length of the queue
    cmp rax, 5 ; if length >= 5, return
    jae _unitCreateReturn ; if full, return

    ; find unit data
    imul rbx, 14
    lea rcx, [_units + rbx] ; rcx = unit

    ; check if money is enough
    mov rax, qword [PlayerGold]
    xor rdx, rdx ; clear rdx
    mov edx, dword [rcx + 1] ; unit cost
    
    cmp rax, rdx ; compare with unit cost
    jb _unitCreateReturn ; if not enough money, return
    
    sub rax, rdx ; subtract unit cost from money
    mov qword [PlayerGold], rax ; update player money

    ; create unit
    heap_allocate 18 ; allocate space for unit structure

    mov qword [rax], rcx ; store ptr to unit data
    mov word [rax + 8], 0x170 ; unit x position
    mov word [rax + 10], 0x160 ; unit colision point
    mov word [rax + 12], 0x180 ; unit colision point

    ; add unit to the units queue
    mov rbx, rax ; swich register due to marco order.
    queue_add [unitQueue], rbx ;
    inc dword [unitQueueLength] ; increment queue length

    mov [unitsSpawned], rax ; save pointer to the created unit

_unitCreateReturn:

    ret


%macro unit_create 1
    mov rbx, %1 ; unit type
    call _unitCreate
%endmacro


; void unitsUpdate(void)
;   updates each unit
_unitsUpdate:
    sleep 500_000 ; walk 1 every 5th secound

    cmp byte [isRunning], 0
    je _unitsUpdateReturn

    mov rax, [unitsSpawned] ; get unit spawned

    test rax, rax
    jz _unitsUpdate
    
    cmp word [rax+8], 0x840
    jge _unitsUpdate

    add word [rax+8], 0x10
    
    jmp _unitsUpdate


_unitsUpdateReturn:

    ret

_units:


.clubman:
    db 7 ; unit type / image id (1 bytes - byte)
    db 15, 0, 0, 0 ; unit cost (4 bytes - dword)
    db 50, 0, 0, 0 ; unit health (4 bytes - dword)
    db 15, 0, 0, 0 ; unit damage (4 bytes - dword)
    db 1 ; unit speed (1 byte - byte)
    db 1 ; unit spawn speed (1 byte)


.slingshot: ; numbers need to be validated
    db 11 ; unit type / image id
    db 20, 0, 0, 0 ; unit cost
    db 30, 0, 0, 0 ; unit health
    db 20, 0, 0, 0 ; unit damage
    db 2 ; unit speed