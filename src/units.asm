%include "lib/queue.asm"
%include "lib/to_string.asm"
%include "lib/grafics/set_text.asm"
%include "lib/check_colision.asm"

%include "lib/foreach.asm"

; void _unitCreate(int unitType {rbx})
; creates a unit of type unitType
_unitCreate:

    cmp rbx, -1
    je _unitCreateReturn

    ; check if unit queue is full
    queue_length [unitQueue]
    cmp rax, 5 ; if length >= 5, return
    jae _unitCreateReturn ; if full, return

    ; find unit data
    imul rbx, 15
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

_unitCreateReturn:

    ret


%macro unit_create 1
    mov rbx, %1 ; unit type
    call _unitCreate
%endmacro


_unitsUpdateLoop:
    push rbx
    push rcx

    check_colision rax, [EnemyBase]
    jnz _unitUpdateAttack

    add word [rax+8], 4 ; normal value 4
    add word [rax+10], 4
    add word [rax+12], 4

    jmp _unitsUpdateLoopEnd

_unitUpdateAttack:
    mov rax, [rax] ; unit data
    mov rbx, [EnemyBase] ; enemy base pointer
    mov ecx, dword [rbx+14] ; enemy base health

    cmp ecx, 5
    jle _unitsUpdateLoopEnd

    sub ecx, dword [rax+9] ; enemy base - unit dmg
    mov dword [rbx+14], ecx ; update enemy base health

_unitsUpdateLoopEnd:

    pop rcx
    pop rbx

    ret



; void unitsUpdate(void)
;   updates each unit
_unitsUpdate:
    sleep 50_000 ; 0.05 s

    cmp byte [isRunning], 0
    je _unitsUpdateReturn

    queue_peek [unitQueue]
    cmp rax, -1
    je _unitsSpawnSkip
    
    mov rax, [rax] ; get the unit data

    xor rbx, rbx
    xor rcx, rcx
    mov cl, byte [rax+14]
    inc cl
    mov bl, byte [unitSpawingTimer]
    cmp byte [unitSpawingTimer], 0 ; if r10 is 0, then set it to the unit spawn timer
    cmovle rbx, rcx
    mov byte [unitSpawingTimer], bl

    dec byte [unitSpawingTimer] ; each loop dec timer once

    cmp byte [unitSpawingTimer], 0 ; when timer hit 0 then spawn unit  
    jg _unitsSpawnSkip

    queue_pop [unitQueue]
    mov rbx, rax
    queue_add [unitsSpawnedPtr], rbx

_unitsSpawnSkip:

    ; units movement
    queue_peek [unitsSpawnedPtr] ; get unit spawned

    cmp rax, -1
    je _unitsUpdate
    
    foreach [unitsSpawnedPtr], _unitsUpdateLoop
    
    jmp _unitsUpdate


_unitsUpdateReturn:

    ret

_units:


.clubman:
    db 7 ; unit type / image id (1 bytes - byte)
    dd 15 ; unit cost (4 bytes - dword)
    dd 50 ; unit health (4 bytes - dword)
    dd 15 ; unit damage (4 bytes - dword)
    db 1 ; unit speed (1 byte - byte)
    db 20 ; unit spawn speed (1 byte)


.slingshot: ; numbers need to be validated
    db 11 ; unit type / image id (1 bytes - byte)
    dd 25 ; unit cost (4 bytes - dword)
    dd 50 ; unit health (4 bytes - dword)
    dd 15 ; unit damage (4 bytes - dword)
    db 1 ; unit speed (1 byte - byte)
    db 20 ; unit spawn speed (1 byte)

.dinorider: ; numbers need to be validated
    db 11 ; unit type / image id (1 bytes - byte)
    dd 100 ; unit cost (4 bytes - dword)
    dd 50 ; unit health (4 bytes - dword)
    dd 15 ; unit damage (4 bytes - dword)
    db 1 ; unit speed (1 byte - byte)
    db 50 ; unit spawn speed (1 byte)


_bases:

.baseAge1:
    db 1 ; image id
    dd 510 ; base health

