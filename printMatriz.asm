%include "macros.asm"

global printMatriz

section .data
    saltoLinea db 10,0
    formatChar db "[%c]",0
    espacios db "   ",0
    cadena db "%s",0
section .bss

section .text

printMatriz:
    mov     r15,rdi ;r15 es la direccion de la matriz
    mov     r12,0 ;indice de la r15
    mov     r13,1 ;indice de la columna para salto de linea
inicio:
    cmp     byte[r15+r12],-1
    je      imprimirEspacios
    mov     rdi,formatChar
    mov     rsi,[r15+r12]
    mPrintf
continuar:
    cmp     r13,7  ;me fijo si estoy en la ultima columna e imprimo un salto de linea
    je      imprimirSalto
    inc     r13
    inc     r12
    cmp     r12,49
    jne     inicio 
    ret

imprimirEspacios:
    mov     rdi,cadena
    mov     rsi,espacios
    mPrintf
    jmp     continuar

imprimirSalto:
    mov     rdi,cadena
    mov     rsi,saltoLinea
    mPrintf 
    mov     r13,0
    jmp     continuar
