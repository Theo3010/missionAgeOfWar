_init:
    save_termois

    ; void heap_init(void)
    heap_init

    ; void framebuffer_init(void)
    framebuffer_init

    mov byte [camera_coordinates], 0x20
    mov word [nextAgeExpRequirement], 4000
    mov word [PlayerHealth], 500
    mov word [EnemyHealth], 250
    mov qword [HUDbuttonmsgPtr], _HUDmenutext.trainUnit

    raw_mode

    ret