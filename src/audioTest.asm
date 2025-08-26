section .data
    dsp_device db '/dev/dsp', 0
    
    ; OSS ioctl commands - try alternative values if these don't work
    SNDCTL_DSP_RESET     equ 0x5000
    SNDCTL_DSP_SETFMT    equ 0xC0045005
    SNDCTL_DSP_CHANNELS  equ 0xC0045006
    SNDCTL_DSP_SPEED     equ 0xC0045002
    SNDCTL_DSP_GETBLKSIZE equ 0x80045004
    
    ; Alternative ioctl values (some systems use these)
    ; SNDCTL_DSP_SETFMT    equ 0x40045005
    ; SNDCTL_DSP_CHANNELS  equ 0x40045006
    ; SNDCTL_DSP_SPEED     equ 0x40045002
    
    ; Audio format constants
    AFMT_S16_LE equ 0x10      ; 16-bit signed little endian
    AFMT_U8     equ 0x08      ; 8-bit unsigned (fallback)
    
    ; Audio parameters
    format dd AFMT_S16_LE
    channels dd 2             ; stereo
    sample_rate dd 44100
    block_size dd 0
    
    ; Debug messages
    msg_opened db 'Device opened successfully', 10, 0
    msg_reset db 'Reset successful', 10, 0
    msg_format db 'Format set successful', 10, 0
    msg_channels db 'Channels set successful', 10, 0
    msg_speed db 'Speed set successful', 10, 0
    msg_blocksize db 'Block size retrieved', 10, 0

section .bss
    dsp_fd resq 1

section .text
    global _start

; Debug print function
print_msg:
    push rax
    push rdi
    push rsi
    push rdx
    
    mov rax, 1                ; sys_write
    mov rdi, 1                ; stdout
    ; rsi already contains message pointer
    mov rdx, 50               ; max length
    
    ; Find string length
    mov rcx, 0
find_len:
    cmp byte [rsi + rcx], 0
    je write_msg
    inc rcx
    cmp rcx, 50
    jl find_len
    
write_msg:
    mov rdx, rcx
    syscall
    
    pop rdx
    pop rsi
    pop rdi
    pop rax
    ret

_start:
    ; Open /dev/dsp with error checking
    mov rax, 2                ; sys_open
    mov rdi, dsp_device
    mov rsi, 2                ; O_RDWR
    mov rdx, 0
    syscall
    
    cmp rax, 0
    js open_error
    
    mov [dsp_fd], rax
    mov r12, rax
    
    ; Print success message
    mov rsi, msg_opened
    call print_msg

    ; Try RESET first (this often fails on some systems, so we'll skip it)
    ; Some systems don't support reset, so let's comment it out initially
    ; mov rax, 16
    ; mov rdi, r12
    ; mov rsi, SNDCTL_DSP_RESET
    ; mov rdx, 0
    ; syscall
    ; cmp rax, 0
    ; js reset_error

    ; Set audio format - this is critical
    mov rax, 16
    mov rdi, r12
    mov rsi, SNDCTL_DSP_SETFMT
    mov rdx, format
    syscall
    
    cmp rax, 0
    js format_ioctl_error
    
    mov rsi, msg_format
    call print_msg

    ; Set channels
    mov rax, 16
    mov rdi, r12
    mov rsi, SNDCTL_DSP_CHANNELS
    mov rdx, channels
    syscall
    
    cmp rax, 0
    js channels_ioctl_error
    
    mov rsi, msg_channels
    call print_msg

    ; Set sample rate
    mov rax, 16
    mov rdi, r12
    mov rsi, SNDCTL_DSP_SPEED
    mov rdx, sample_rate
    syscall
    
    cmp rax, 0
    js speed_ioctl_error
    
    mov rsi, msg_speed
    call print_msg

    ; Get block size (optional)
    mov rax, 16
    mov rdi, r12
    mov rsi, SNDCTL_DSP_GETBLKSIZE
    mov rdx, block_size
    syscall
    
    ; Don't fail on this one, just continue
    mov rsi, msg_blocksize
    call print_msg

    jmp cleanup

open_error:
    mov rax, 60
    mov rdi, 1                ; exit code 1 - open failed
    syscall

format_ioctl_error:
    mov rax, 60
    mov rdi, 10               ; exit code 10 - format ioctl failed
    syscall

channels_ioctl_error:
    mov rax, 60
    mov rdi, 11               ; exit code 11 - channels ioctl failed
    syscall

speed_ioctl_error:
    mov rax, 60
    mov rdi, 12               ; exit code 12 - speed ioctl failed
    syscall

cleanup:
    mov rax, 3                ; sys_close
    mov rdi, r12
    syscall
    
    mov rax, 60               ; sys_exit
    mov rdi, 0                ; success
    syscall