segment .data
    msg db "Hello world!", 0xA, 0

segment .text
global _main
extern _printf

_main:
    push    ebp
    mov     ebp, esp

    push    msg        
    call    _printf     
    add     esp, 4     

    mov     eax, 0     
    leave              
    ret               