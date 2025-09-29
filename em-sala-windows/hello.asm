
segment .data
    ; String de mensagem. No 32 bits, o formato pode ser mais simples ou depender do SO.
    ; Usamos 0xA (LF) e 0 para terminar, comum no Linux ou com o uso de printf.
    msg db "Hello world!", 0xA, 0

segment .text
global _main
extern _printf

; A função 'ExitProcess' geralmente não é usada diretamente em montagens simples de 32 bits para Linux.
; O retorno de 'main' é o suficiente.
; No Windows, você precisaria de 'ExitProcess' e de um setup diferente para a pilha.

_main:
    ; Configuração do Stack Frame (convenção comum, embora nem sempre estritamente necessária)
    push    ebp
    mov     ebp, esp

    ; Chamada da função printf
    ; Em 32-bits (convenção cdecl), os argumentos são empilhados da direita para a esquerda.
    push    msg        ; Primeiro e único argumento: o endereço da string 'msg'
    call    _printf     ; Chama a printf
    add     esp, 4     ; Limpa o argumento da pilha (4 bytes para o endereço)

    ; Retorno
    ; O valor de retorno (0 neste caso) é colocado em EAX
    mov     eax, 0     ; Retorno 0 (sucesso)
    leave              ; Desfaz 'mov ebp, esp' e 'pop ebp'
    ret                ; Retorna ao chamador (geralmente o sistema operacional)