section .data

section .text

global _start

_start:
    ; mov destino, origem -> eax = 1
    mov eax, 0x1                  ; Só coloquei em hexadecimal 0x1 = 1
    mov ebx, 0x0                  ; SO o valor de retorno é 0
    int 0x80                      ; Manda o block de informação e processa os dados