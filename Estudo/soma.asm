global _somar_asm ; Torna o rótulo visível para o Linker
section .text
_somar_asm:
; === PRÓLOGO (Setup do Stack Frame) ===
push ebp ; Salva o EBP antigo (do chamador)
mov ebp, esp ; EBP agora aponta para o topo da pilha
push ebx ; Salvar
mov eax, [ebp + 8]
mov ebx, [ebp + 12]
add eax, ebx
pop ebx ; Restaurar
; ... lógica da função aqui ...
; === EPÍLOGO (Limpeza) ===
pop ebp ; Restaura o EBP antigo
ret ; Retorna (EIP volta para o C)