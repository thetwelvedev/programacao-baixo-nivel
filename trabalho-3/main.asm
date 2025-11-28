; main.asm 
; Trabalho Prático 3 - Arquivo principal
; Sistema: Windows (x86)

; Constante para controle de debug
%define DEBUG_MODE 1

; Constante para tamanho do vetor
TAMANHO_VETOR EQU 5

; Declaração de funções externas (importadas de utils.asm)
EXTERN CalcularSoma
EXTERN EncontrarMaior
EXTERN ImprimirDebug

; Segmento de dados inicializados
SECTION .data
    meuVetor DW 10, 5, -20, 50, 1

; Segmento de dados não inicializados
SECTION .bss
    resultadoSoma RESD 1    ; 4 bytes para resultado da soma
    resultadoMaior RESD 1   ; 4 bytes para o maior valor

; Segmento de código
SECTION .text
    GLOBAL _start

_start:
    ; Ponto de entrada do programa
    
    ; === Montagem Condicional para Debug ===
%if DEBUG_MODE == 1
    ; Se modo debug está ativo, chama função de debug
    CALL ImprimirDebug
%endif
    
    ; === Calcular Soma do Vetor ===
    ; Preparar parâmetros:
    ; ESI = endereço do vetor
    ; ECX = tamanho do vetor
    
    ; Método seguro para obter endereço do vetor
    MOV ESI, meuVetor           ; Carrega endereço do vetor em ESI
    MOV ECX, TAMANHO_VETOR      ; ECX = 5
    
    ; Chamar função CalcularSoma
    CALL CalcularSoma
    
    ; Armazenar resultado (retornado em EAX)
    MOV DWORD [resultadoSoma], EAX
    
    ; === Encontrar Maior Valor do Vetor ===
    ; Preparar parâmetros (mesmos de antes)
    MOV ESI, meuVetor           ; Carrega endereço do vetor em ESI
    MOV ECX, TAMANHO_VETOR      ; ECX = 5
    
    ; Chamar função EncontrarMaior
    CALL EncontrarMaior
    
    ; Armazenar resultado (retornado em EAX)
    MOV DWORD [resultadoMaior], EAX
    
    ; Caso INT 21h não funcione, loop infinito como fallback
    JMP $