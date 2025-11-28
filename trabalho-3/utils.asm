; utils.asm
; Trabalho Prático 3 - Funções utilitárias
; Sistema: Windows (x86)

; Exportar funções para serem usadas por outros módulos
GLOBAL CalcularSoma
GLOBAL EncontrarMaior
GLOBAL ImprimirDebug

SECTION .text

; =========================================
; CalcularSoma
; =========================================
; Descrição: Calcula a soma de todos os elementos de um vetor
; Parâmetros de entrada:
;   ESI = endereço do vetor (array de WORD)
;   ECX = tamanho do vetor (número de elementos)
; Retorno:
;   EAX = soma de todos os elementos (expandido para 32 bits)
; Registradores modificados: EAX, EBX, ECX, ESI
; =========================================
CalcularSoma:
    PUSH EBX                    ; Preservar EBX
    
    XOR EAX, EAX                ; EAX = 0 (acumulador da soma)
    XOR EBX, EBX                ; EBX = 0 (usado para extensão de sinal)
    
    ; Verificar se o vetor está vazio
    TEST ECX, ECX
    JZ .fim_soma
    
.loop_soma:
    ; Carregar elemento atual (WORD = 16 bits)
    MOVSX EBX, WORD [ESI]       ; Carregar com extensão de sinal (suporta negativos)
    
    ; Adicionar ao acumulador
    ADD EAX, EBX
    
    ; Avançar para próximo elemento (cada elemento é WORD = 2 bytes)
    ADD ESI, 2
    
    ; Decrementar contador e continuar se não for zero
    DEC ECX
    JNZ .loop_soma
    
.fim_soma:
    POP EBX                     ; Restaurar EBX
    RET


; =========================================
; EncontrarMaior
; =========================================
; Descrição: Encontra o maior valor em um vetor
; Parâmetros de entrada:
;   ESI = endereço do vetor (array de WORD)
;   ECX = tamanho do vetor (número de elementos)
; Retorno:
;   EAX = maior valor encontrado (expandido para 32 bits)
; Registradores modificados: EAX, EBX, ECX, ESI
; =========================================
EncontrarMaior:
    PUSH EBX                    ; Preservar EBX
    
    ; Verificar se o vetor está vazio
    TEST ECX, ECX
    JZ .fim_maior
    
    ; Inicializar com o primeiro elemento
    MOVSX EAX, WORD [ESI]       ; EAX = primeiro elemento (com extensão de sinal)
    ADD ESI, 2                  ; Avançar para próximo elemento
    DEC ECX                     ; Decrementar contador
    JZ .fim_maior               ; Se era o único elemento, terminar
    
.loop_maior:
    ; Carregar elemento atual
    MOVSX EBX, WORD [ESI]       ; EBX = elemento atual (com extensão de sinal)
    
    ; Comparar com o maior atual
    CMP EBX, EAX
    JLE .nao_e_maior            ; Se EBX <= EAX, pular atualização
    
    ; Elemento atual é maior, atualizar
    MOV EAX, EBX
    
.nao_e_maior:
    ; Avançar para próximo elemento
    ADD ESI, 2
    
    ; Decrementar contador e continuar se não for zero
    DEC ECX
    JNZ .loop_maior
    
.fim_maior:
    POP EBX                     ; Restaurar EBX
    RET


; =========================================
; ImprimirDebug
; =========================================
; Descrição: Função de debug (placeholder)
; Esta função seria usada para imprimir informações de depuração
; Por enquanto, apenas retorna (não faz nada)
; Parâmetros: nenhum
; Retorno: nenhum
; =========================================
ImprimirDebug:
    ; Em uma implementação real, esta função poderia:
    ; - Imprimir mensagens no console
    ; - Salvar estado dos registradores
    ; - Escrever logs em arquivo
    
    ; Por enquanto, apenas retorna
    RET