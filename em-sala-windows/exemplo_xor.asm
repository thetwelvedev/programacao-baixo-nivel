; Arquivo: hello_Word32.asm (Versão Corrigida)
bits 32

extern _printf
extern _exit

section .data
    mensagem db "O resultado da paridade e: %d", 10, 0

section .text
    global _main

verificar_paridade:
    MOV  AH, AL         ; Copia AL para AH (preservar original)
    
    ; Passo 1:
    MOV  AL, AH         ; Restaura valor
    SHR  AL, 4          ; Desloca 4 bits para direita
    XOR  AL, AH         ; XOR com original (acumula paridade)
    
    ; Passo 2:
    MOV  AH, AL         ; Salva resultado parcial
    SHR  AL, 2          ; Desloca 2 bits
    XOR  AL, AH         ; XOR acumula paridade de 4 bits
    
    ; Passo 3:
    MOV  AH, AL         ; Salva resultado
    SHR  AL, 1          ; Desloca 1 bit
    XOR  AL, AH         ; XOR acumula paridade total
    
    ; Passo 4:
    AND  AL, 01h        ; Máscara mantém apenas bit 0
    
    RET
;==============================================================================

;==============================================================================
; FUNÇÃO PRINCIPAL DO PROGRAMA (32-BIT)
;==============================================================================
_main:
    push ebp
    mov  ebp, esp

    MOV  AL, 0xB5       ; Exemplo: 10110101b (ímpar)
    CALL verificar_paridade

    movzx eax, al
    push eax
    push mensagem
    call _printf
    add esp, 8

    push 0
    call _exit