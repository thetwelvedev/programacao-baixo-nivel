section .data
    msg db "Hello, 64-bit world!", 0xA
    len equ $ - msg

section .text
    global main

main:
    ; write(1, msg, len)
    mov rax, 1        ; syscall write
    mov rdi, 1        ; stdout
    mov rsi, msg      ; endereço da string
    mov rdx, len      ; tamanho
    syscall

    ; return 0 (exit code)
    mov eax, 0
    ret
