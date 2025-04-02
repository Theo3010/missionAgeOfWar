_init:
    save_termois

    ; void heap_init(void)
    heap_init

    ; void framebuffer_init(void)
    framebuffer_init

    mov byte [camera_coordinates], 0

    raw_mode

    ret