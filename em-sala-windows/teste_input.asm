; teste_input.asm - NASM 32 bits (Windows)
; Compilar: nasm -f win32 teste_input.asm -o teste_input.obj
; Linkar:   gcc -m32 teste_input.obj -o teste_input.exe
; Executar: ./teste_input.exe

global  _main
extern  _printf
extern  _scanf

section .data
    prompt  db "Digite dois inteiros (separados por espaco ou Enter): ", 0
    fmt_in  db "%d %d", 0
    fmt_out db "Soma = %d", 10, 0   ; 10 = newline

section .bss
    a   resd 1
    b   resd 1
    s   resd 1

section .text
_main:
    push    ebp
    mov     ebp, esp

    ; imprime prompt
    push    dword prompt
    call    _printf
    add     esp, 4

    ; lê dois inteiros: scanf("%d %d", &a, &b)
    push    dword b
    push    dword a
    push    dword fmt_in
    call    _scanf
    add     esp, 12

    ; soma os dois números
    mov     eax, [a]
    add     eax, [b]
    mov     [s], eax

    ; imprime o resultado
    push    dword [s]
    push    dword fmt_out
    call    _printf
    add     esp, 8

    ; fim
    mov     eax, 0
    mov     esp, ebp
    pop     ebp
    ret
