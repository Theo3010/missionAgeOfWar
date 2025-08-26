%ifndef RIFFREADER
%define RIFFREADER


; void* {rax} riff_reader(void* data {rdi}, int target {rsi})
; reads the riff chucks for a given chunk type
;   data: pointer to the start of the riff data (first chuck)
;   target: the chunk type to search for
;   returns: The pointer to the start of the chunk data if found, otherwise 0
_riffReader:

    mov rdx, rdi ; save original data pointer

_riffReaderLoop:
    ; check the chuckid
    cmp dword [rdi], esi
    je _riffReaderReturn

    ; get chunk size
    xor rax, rax
    mov eax, dword [rdi+4] ; size of chunk data
    add rax, 8 ; add size of chunk header (4 bytes for type, 4 bytes for size)
    add rdi, rax ; move to next chunk

    mov rax, rdi
    sub rax, rdx ; calculate the offset from the start of the data
    cmp rax, 0xfff ; check if we have reached the end of the data
    jae _riffError ; if so, return 0

    jmp _riffReaderLoop

_riffReaderReturn:
    ; return the offset to the start of the chunk data
    mov rax, rdi ; set return value to the pointer to the chunk data
    ret

_riffError:
    throw_error .errorRiff
    ret

.errorRiff:
    db "Error: Invalid RIFF data or chunk not found", 10, 0


%macro riff_reader 2

    push rdi
    push rsi

    mov rdi, %1 ; data pointer
    mov rsi, %2 ; target chunk type

    call _riffReader

    pop rsi
    pop rdi

%endmacro

%endif