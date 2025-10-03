<h1>
  <img src="https://cdn.jsdelivr.net/gh/simple-icons/simple-icons/icons/assemblyscript.svg" alt="Assembly x86" width="40" style="vertical-align: middle;"> 
  Comandos para rodar o Assembly x86
</h1>

## Arquitetira de 32 bits

### Windows

```bash
nasm -f win32 hello.asm -o hello.obj
gcc hello.obj -o hello.exe
.\hello.exe
```
### Linux

```bash
nasm -f elf32 hello.asm -o hello.o
ld -m elf_i386 hello.o -o hello
./hello
```

```bash
nasm -f elf32 hello.asm -o hello.o
gcc -m32 hello.o -o hello
./hello
```

## Arquitetira de 64 bits

### Linux

```bash
nasm -f elf64 hello.asm -o hello.o
gcc hello.o -no-pie -o hello
./hello
```