%include "lib/io/print_flush.asm"
%include "lib/grafics/framebuffer_flush.asm"
%include "lib/terminal/reset_termois.asm"
%include "lib/exit.asm"

_cleanAndExit:
    mov byte [isRunning], 0

    print_flush
    framebuffer_flush
    reset_termois

    exit