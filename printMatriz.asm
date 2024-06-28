%include "macros.asm"

global printMatriz

section .data
    saltoLinea db 10,0
    formatChar db "[%c]",0
    espacios db "   ",0
    cuatroEspacios db "     ",0
    cadena db "%s",0
    formatNumero db " %d ",0
    pipe db " | ",0
    vCorta db " v ",0
    nFila dq 1
    txtFila db "%d--->",0
section .bss
    
section .text

printMatriz:
    mov     r15,rdi ;r15 es la direccion de la matriz
    mov     r12,0 ;indice de la r15
    mov     r13,1 ;indice de la columna para salto de linea
    mPuts   espacios
    sub     rsp,8
    call    ponerNumerosColumnas
    add     rsp,8
    mImprimirNumeroFila
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
    mov     qword[nFila],1
    mPuts   espacios
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
    cmp     r12,48
    je      continuar
    mImprimirNumeroFila
    jmp     continuar
;---------------------------------------
ponerNumerosColumnas:
    mov    rdi,cadena
    mov    rsi,cuatroEspacios
    mPrintf
    mov    r11,0
numeroColumnaLoop:
    inc    r11
    mov    rdi,formatNumero
    mov    rsi,r11
    mPrintf
    cmp    r11,7
    jl     numeroColumnaLoop
    mov    rdi,cadena
    mov    rsi,saltoLinea
    mPrintf

    mov    rdi,cadena
    mov    rsi,cuatroEspacios
    mPrintf
    mov    r11,0
pipeLoop:
    inc    r11
    mov    rdi,pipe
    mov    rsi,r11
    mPrintf
    cmp    r11,7
    jl     pipeLoop
    mov    rdi,cadena
    mov    rsi,saltoLinea
    mPrintf 

    mov    rdi,cadena
    mov    rsi,cuatroEspacios
    mPrintf
    mov    r11,0
flechaLoop:
    inc    r11
    mov    rdi,vCorta
    mov    rsi,r11
    mPrintf
    cmp    r11,7
    jl     flechaLoop
    mov    rdi,cadena
    mov    rsi,saltoLinea
    mPrintf 
    ret

imprimirNumeroFila:
    mov     rdi,txtFila
    mov     rsi,[nFila]
    mPrintf
    inc     qword[nFila]
    ret
