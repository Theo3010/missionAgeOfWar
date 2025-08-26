%include "lib/queue.asm"

_init:
    save_termois

    ; void heap_init(void)
    heap_init

    ; void framebuffer_init(void)
    framebuffer_init

    ; create unit queue
    queue_init 5, 8 ; 5 elements, each 8 bytes

    mov qword [unitQueue], rax ; save pointer to unit queue

    mov byte [isRunning], 1
    mov byte [camera_coordinates], 0x20
    mov word [nextAgeExpRequirement], 4000
    mov word [PlayerHealth], 500
    mov word [EnemyHealth], 500
    mov qword [HUDbuttonmsgPtr], _HUDmenutext.trainUnit

    raw_mode

    ret