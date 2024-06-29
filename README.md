# TP-Orga (GRUPO 1)

Para ensamblar, compilar y ejecutar:
```bash
nasm main.asm -f elf64
nasm printMatriz.asm -f elf64
gcc main.o printMatriz.o -no-pie -o main
./main
```
