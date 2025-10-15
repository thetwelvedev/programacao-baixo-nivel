; ------------------------------------------------------------
; Programa: Exemplo de strlen em Assembly (Windows)
; Autor: Leonardo
; Descrição:
;   Implementa uma função strlen para calcular o tamanho de uma
;   string terminada em null (caractere 0). O programa utiliza
;   a função ExitProcess da API do Windows para encerrar.
; ------------------------------------------------------------

section .data
    my_string db "Hello, world!", 0   ; String terminada em null

section .text
    global _start                     ; Ponto de entrada do programa
    extern _ExitProcess@4               ; Declara função externa da API Windows

; ------------------------------------------------------------
; Função strlen:
; Entrada: ESI = ponteiro para string (null-terminated)
; Saída:   EAX = tamanho da string (número de caracteres antes do null)
; ------------------------------------------------------------
strlen:
    push edi                ; Preserva EDI (registrador usado pela busca)
    push ecx                ; Preserva ECX (contador)
    cld                     ; Define direção para frente (incrementar ponteiros)
    mov edi, esi            ; EDI aponta para a string recebida
    xor al, al              ; AL = 0 (vamos procurar o terminador null)
    mov ecx, 0xFFFFFFFF     ; Define ECX como tamanho máximo (4GB)
    repne scasb             ; Procura o byte 0 (null terminator)
    not ecx                 ; ECX = ~ECX = (strlen + 1)
    dec ecx                 ; ECX = strlen
    mov eax, ecx            ; Retorna o tamanho em EAX
    pop ecx                 ; Restaura ECX
    pop edi                 ; Restaura EDI
    ret                     ; Retorna à função chamadora

; ------------------------------------------------------------
; Exemplo de uso da função strlen
; ------------------------------------------------------------
_start:
    mov esi, my_string      ; Ponteiro da string em ESI
    call strlen             ; Chama a função strlen
    ; EAX agora contém o tamanho da string (13 no caso de "Hello, world!")

    ; --------------------------------------------------------
    ; Finaliza o programa no Windows:
    ; ExitProcess encerra o processo atual.
    ; Passamos o valor em EAX como código de saída.
    ; --------------------------------------------------------
    push eax                ; Código de saída = tamanho da string
    call _ExitProcess@4        ; Chama a função da API do Windows
