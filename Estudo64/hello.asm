; hello.asm
global main
extern printf

section .data
msg db 'Hello, world!', 0

section .text
main:
    ; printf(msg)
    mov rcx, msg    ; primeiro parâmetro para printf
    call printf
    xor eax, eax
    ret
