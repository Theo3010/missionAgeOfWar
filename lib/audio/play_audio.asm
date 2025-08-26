%ifndef PLAYAUDIO
%define PLAYAUDIO

%include "lib/files/ioctl.asm"
%include "lib/riff_reader.asm"

; void playAudio(void* {rdi})
; plays audio from a file
;   Requires pointer to heap memory with audio data

SNDCTL_DSP_SETFMT    equ 0xC0045005
SNDCTL_DSP_CHANNELS  equ 0xC0045006
SNDCTL_DSP_SPEED     equ 0xC0045002

_playAudio:

    push rax
    push rbx
    push r12

    ; open /dev/dsp
    file_open _playAudioLoopDone.dsp_path, 1, 0644o
    mov r12, rax ; save file descriptor

    heap_allocate 4 ; allocate buffer for writing
    mov rbx, rax ; save buffer pointer
    mov word [rbx], 0x10 ; 16-bit


    ; set 16-bit little endian format
    ioctl r12, SNDCTL_DSP_SETFMT, rbx ; SNDCTL_DSP_SETFMT, AFMT_S16_LE

    riff_reader rdi, 0x20746d66 ; read format chunk "fmt " in little-endian
    mov rdi, rax ; save pointer to format chunk

    ; read number of channels
    mov ax, word [rdi+10]
    mov [rbx], ax

    ioctl r12, SNDCTL_DSP_CHANNELS, rbx ; SNDCTL_DSP_CHANNELS, channels

    ; read sample rate
    mov ax, word [rdi+12]
    mov [rbx], ax ; SNDCTL_DSP_SPEED

    ioctl r12, SNDCTL_DSP_SPEED, rbx ; SNDCTL_DSP_SPEED, sample_rate

    riff_reader rdi, 0x61746164 ; read data chunk "data" in little-endian
    mov rdi, rax ; save pointer to data chunk

    mov rcx, [rdi+4] ; get size of audio data
    add rdi, 8 ; move rdi to audio data start

    heap_free rbx

    ; write audio data to /dev/dsp in blocks
    mov rbx, rdi ; switch rbx to audio data pointer

_playAudioLoop:
    cmp byte [isRunning], 0
    je _playAudioLoopDone

    file_write r12, rbx, 4096 ; write audio data to /dev/dsp
    ; rax = amount of written data
    add rbx, rax ; move rdi to next block

    sub rcx, rax ; reduce remaining size
    cmp rcx, 0
    jg _playAudioLoop ; if more data to write, repeat

_playAudioLoopDone:
    file_close r12 ; close /dev/dsp

    pop r12
    pop rbx
    pop rax

    ret


.dsp_path:
    db "/dev/dsp", 0

%macro play_audio 1
    push rdi

    mov rdi, %1 ; audio pointer
    call _playAudio

    pop rdi
%endmacro


%endif