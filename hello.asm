section .data
    msg db 'Hello World!', 10, 0
section .text
    global _main
    extern _printf
_main:
    push msg
    call _printf
    add esp, 4
    ret