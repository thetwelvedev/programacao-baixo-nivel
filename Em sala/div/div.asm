extern printf
extern exit

section .data
    fmt_saida db "Divisao entre %d e %d e %d", 10, 0
section .text
    global main

main:
    MOV EAX, 10
    XOR EDX, EDX    ; limpar parte alta para a divisão
    MOV EBX, 5
    DIV EBX
    PUSH EAX
    PUSH EBX
    PUSH 10
    PUSH fmt_saida
    CALL printf
    ADD ESP, 16
    PUSH 0
    CALL exit