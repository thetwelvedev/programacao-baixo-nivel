bits 64
default rel

segment .data
    msg db "Hello world!", 0xA, 0   ; \n no lugar de 0xd 0xa

segment .text
global main
extern printf

main:
    push    rbp
    mov     rbp, rsp
    sub     rsp, 32

    lea     rdi, [rel msg]  ; Linux x86_64 usa RDI para o 1º argumento
    xor     eax, eax        ; printf é variadic, limpar RAX
    call    printf

    mov     eax, 0          ; valor de retorno do main = 0
    leave
    ret
