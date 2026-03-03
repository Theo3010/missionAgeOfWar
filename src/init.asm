%include "lib/queue.asm"

_init:
    save_termois

    ; void heap_init(void)
    heap_init

    ; void framebuffer_init(void)
    framebuffer_init

    ; create unit queue
    queue_init 5 ; 5 elements, each 8 bytes
    mov qword [unitQueue], rax ; save pointer to unit queue

    queue_init 10 ; 10 elements, each 8 bytes
    mov qword [unitsSpawnedPtr], rax

    heap_allocate 18

    mov qword [rax], _bases.baseAge1 ; pointer to the base data
    mov word [rax+8], 0x870 ; postion
    mov word [rax+10], 0x850 ; near colistion point
    mov word [rax+12], 0x890 ; far colistion point
    mov ebx, dword [_bases.baseAge1+1]
    mov dword [rax+14], ebx

    mov [EnemyBase], rax ; base struct

    mov byte [isRunning], 1
    mov byte [camera_coordinates], 0x20
    mov word [PlayerHealth], 500
    mov qword [HUDbuttonmsgPtr], _HUDmenutext.trainUnit

    raw_mode

    ret