%ifndef LOADAUDIO
%define LOADAUDIO

%include "lib/mem/heap_allocate.asm"
%include "lib/files/file_open.asm"
%include "lib/files/file_read.asm"
%include "lib/files/file_close.asm"
%include "lib/error.asm"

; void* {rax} load_audio(char* {rdi})
; loads audio from a file and returns a pointer to the audio data
;   Requires .wav file format
_loadAudio:

    ; open file
    file_open rdi, 0, 0644o
    mov rdi, rax ; save file descriptor


    ; read header (44 bytes)
    file_read rdi, audioHeader, 12

    ; check if file is a valid .wav file
    mov eax, dword [audioHeader+8] ; get format
    cmp eax, 0x45564157 ; check if "WAVE" format
    jne _errorLoadingWav

    ; get audio file size
    xor rbx, rbx ; clear rbx
    mov ebx, dword [audioHeader+4] ; file size
    sub rbx, 12 ; remove header size (12 bytes)

    heap_allocate rbx ; allocate space for audio data

    file_read rdi, rax, rbx ; read audio data into heap

    file_close rdi ; close file

    ; return pointer to audio data in rax

    ret



_errorLoadingWav:
    throw_error .errorWav
    ret


.errorWav:
     db "Error: Not a valid .wav file", 10, 0


%macro load_audio 1
    push rdi

    mov rdi, %1 ; file name
    call _loadAudio

    pop rdi
%endmacro


%endif