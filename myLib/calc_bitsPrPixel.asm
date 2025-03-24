%ifndef CALCBITPRPIXEL
%define CALCBITPRPIXEL

; int {rax} calcBitPrPixel(void)
;   asumes that there is info at adress [framebufferInfo]
;   returns bits per pixels
_calcBitPrPixel:
    push rbx

    mov rbx, 0
    mov ebx, [framebufferInfo+0]
    imul ebx, [framebufferInfo+4]
    imul ebx, [framebufferInfo+24]
    shr ebx, 3
    mov rax, rbx

    pop rbx
    ret

%macro calc_Bit_Pr_Pixel 0
    call _calcBitPrPixel
%endmacro

%endif