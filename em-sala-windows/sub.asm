extern _printf
extern _exit

section .data
    fmt_saida db "Subtracao entre %d e %d e %d", 10, 0
section .text
    global _main

_main:
    MOV EAX, 10 
    MOV EBX, 5
    SUB EAX, EBX
    PUSH EAX
    PUSH EBX
    PUSH 10
    PUSH fmt_saida
    CALL _printf
    ADD ESP, 16
    PUSH 0
    CALL _exit