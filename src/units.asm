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
    imul rbx, 18
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

    mov word [rax + 10], 0x150 ; unit colision point

    mov rbx, 0x170
    add bx, word [rcx+16]

    mov word [rax + 12], bx ; unit colision point

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
    push rdx

    mov rdx, rax ; save unit

    dec rbx
    queue_peek rcx, rbx
    
    cmp rax, -1 ; no unit ahead
    jne _unitCheckNext

    check_colision rdx, [EnemyBase] ; check for the enemyBase
    jnz _unitUpdateAttack

    jmp _unitWalk

_unitCheckNext:

    ; unit ahead
    check_colision rdx, rax ; rdx (current unit), rax (unit ahead)
    jnz _unitUpdateAttack

_unitWalk:

    mov rax, [rdx]

    xor rbx, rbx

    mov bl, byte [rax+13]

    add word [rdx+8], bx  ; normal value 4
    add word [rdx+10], bx
    add word [rdx+12], bx

    jmp _unitsUpdateLoopEnd

_unitUpdateAttack:
    mov rdx, [rdx] ; unit data
    mov rbx, [EnemyBase] ; enemy base pointer
    mov ecx, dword [rbx+14] ; enemy base health

    cmp ecx, 5
    jle _unitsUpdateLoopEnd

    sub ecx, dword [rdx+9] ; enemy base - unit dmg
    mov dword [rbx+14], ecx ; update enemy base health

_unitsUpdateLoopEnd:

    pop rdx
    pop rcx
    pop rbx

    ret



; void unitsUpdate(void)
;   updates each unit
_unitsUpdate:
    sleep 50_000 ; 0.05 s

    cmp byte [isRunning], 0
    je _unitsUpdateReturn

    queue_peek [unitQueue], 1
    cmp rax, -1
    je _unitsSpawnSkip
    
    mov rax, [rax] ; get the unit data

    xor rbx, rbx
    xor rcx, rcx
    mov cl, byte [rax+14]
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
    queue_peek [unitsSpawnedPtr], 1 ; get unit spawned

    cmp rax, -1
    je _unitsUpdate
    
    foreach [unitsSpawnedPtr], _unitsUpdateLoop
    
    jmp _unitsUpdate


_unitsUpdateReturn:

    ret

_units:

.clubman:
    db 7       ; unit type / image id (1 bytes - byte)
    dd 15      ; unit cost (4 bytes - dword)
    dd 50      ; unit health (4 bytes - dword)
    dd 15      ; unit damage (4 bytes - dword)
    db 20      ; unit speed (1 byte - byte)
    db 20      ; unit spawn speed (1 byte)
    db 0       ; height offset (1 byte )
    dw 0x20    ; collision offset (2 byte)


.slingshot:    ; numbers need to be validated
    db 11      ; unit type / image id (1 bytes - byte)
    dd 25      ; unit cost (4 bytes - dword)
    dd 50      ; unit health (4 bytes - dword)
    dd 15      ; unit damage (4 bytes - dword)
    db 20      ; unit speed (1 byte - byte)
    db 20      ; unit spawn speed (1 byte)
    db 0       ; height offset (1 byte )
    dw 0x20    ; collision offset (2 byte)


.dinorider:   ; numbers need to be validated
    db 12     ; unit type / image id (1 bytes - byte)
    dd 100    ; unit cost (4 bytes - dword)
    dd 50     ; unit health (4 bytes - dword)
    dd 15     ; unit damage (4 bytes - dword)
    db 20     ; unit speed (1 byte - byte)
    db 50     ; unit spawn speed (1 byte)
    db 42     ; height offset (1 byte )
    dw 0xa0   ; collision offset (2 byte)


_bases:

.baseAge1:
    db 1 ; image id
    dd 510 ; base health


_turrets:

.TurretSlotCost:
    dd 1000
    dd 3000
    dd 7500
    dd 0xffff

.rockSling:
    db 14      ; unit type / image id (1 byte)
    dd 100    ; unit cost (4 bytes)
    dd 0      ; unit damage (4 bytes)
    dd 0      ; attack speed (4 bytes)

.eggAutomatic:
    db 0      ; unit type / image id (1 byte)
    dd 200    ; unit cost (4 bytes)
    dd 0      ; unit damage (4 bytes)
    dd 0      ; attack speed (4 bytes)

.primitiveCatapult:
    db 0      ; unit type / image id (1 byte)
    dd 500    ; unit cost (4 bytes)
    dd 0      ; unit damage (4 bytes)
    dd 0      ; attack speed (4 bytes)

_ageData:

.expRequirement:
    dd 4000
    dd 16000
    dd 32000
    dd 64000 