%include "macros.asm"

global main

extern printMatriz

section .data
    bienvenido db  "Bienvenido!",0
    txtSiguientePos db "Ingrese la siguiente posicion: ",0
    txtPosicionInvalida db "Posicion invalida.",0
    matriz db -1,-1,  "O","O","O",  -1,-1,
           db -1,-1,  "O","O","O",  -1,-1,
           db "O","O","O","O","O","O","O",
           db "O"," "," "," "," "," ","O",
           db "O"," "," ","X"," "," ","O",
           db -1,-1,  " "," "," ",  -1,-1,
           db -1,-1,  " "," "," ",  -1,-1
    cantOcasMuertas db 0
    posZorro dq 4,3
    turnoZorro db "Turno del zorro:",0
    controles db "Arriba: W",10,"Abajo: S",10,
              db "Izquierda: A",10,"Derecha: D",10,
              db "Noroeste: Q",10,"Noreste: E",10,
              db "Suroeste: Z",10,"Sureste: X",0
section .bss
    posicionSiguiente resb 2
    nuevaPosicion   resq 1
section .text

main:
    mPuts   bienvenido

inicio:    
    mov     rdi,matriz
    sub     rsp,8
    call    printMatriz
    add     rsp,8

    sub     rsp,8
    call    moverPieza
    add     rsp,8
    inc     byte[cantOcasMuertas]
    cmp     byte[cantOcasMuertas],12
    jne     inicio

    ret


moverPieza:

    mPuts  txtSiguientePos
    mGets  posicionSiguiente
    cmp    byte[posicionSiguiente],"W"
    je     arriba
    cmp    byte[posicionSiguiente],"S"
    je     abajo
    cmp    byte[posicionSiguiente],"A"
    je     izquierda
    cmp    byte[posicionSiguiente],"D"
    je     derecha
    cmp    byte[posicionSiguiente],"Q"
    je     noroeste
    cmp    byte[posicionSiguiente],"E"
    je     noreste
    cmp    byte[posicionSiguiente],"Z"
    je     suroeste
    cmp    byte[posicionSiguiente],"X"
    je     sureste
    jmp    moverPieza

mover:
    mov     rdx,[nuevaPosicion]
    imul    rdx,7
    mov     rax,[nuevaPosicion+8]
    cmp     byte[matriz+rdx+rax],-1
    je      verificarAntesDeMover
    mov     cl,"X"
    mov     [matriz+rdx+rax],cl

    mov     rdx,[posZorro]
    imul    rdx,7
    mov     rax,[posZorro+8]
    mov     cl," "
    mov     [matriz+rdx+rax],cl

    mov     rdx,[nuevaPosicion]
    mov     [posZorro],rdx
    mov     rdx,[nuevaPosicion+8]
    mov     [posZorro+8],rdx
      

    ret

arriba:
    mov    rdx,[posZorro]
    dec    rdx
    mov    [nuevaPosicion],rdx
    mov    rdx,[posZorro+8]
    mov    [nuevaPosicion+8],rdx
    jmp    verificarSiLaPosicionEsValida
 
abajo:
    mov    rdx,[posZorro]
    inc    rdx
    mov    [nuevaPosicion],rdx
    mov    rdx,[posZorro+8]
    mov    [nuevaPosicion+8],rdx
    jmp    verificarSiLaPosicionEsValida

derecha:
    mov    rdx,[posZorro]
    mov    [nuevaPosicion],rdx
    mov    rdx,[posZorro+8]
    inc    rdx
    mov    [nuevaPosicion+8],rdx
    jmp    verificarSiLaPosicionEsValida

izquierda:
    mov    rdx,[posZorro]
    mov    [nuevaPosicion],rdx
    mov    rdx,[posZorro+8]
    dec    rdx
    mov    [nuevaPosicion+8],rdx
    jmp    verificarSiLaPosicionEsValida

noroeste:
    mov    rdx,[posZorro]
    dec    rdx
    mov    [nuevaPosicion],rdx
    mov    rdx,[posZorro+8]
    dec    rdx
    mov    [nuevaPosicion+8],rdx
    jmp    verificarSiLaPosicionEsValida

noreste:
    mov    rdx,[posZorro]
    dec    rdx
    mov    [nuevaPosicion],rdx
    mov    rdx,[posZorro+8]
    inc    rdx
    mov    [nuevaPosicion+8],rdx
    jmp    verificarSiLaPosicionEsValida

suroeste:
    mov    rdx,[posZorro]
    inc    rdx
    mov    [nuevaPosicion],rdx
    mov    rdx,[posZorro+8]
    dec    rdx
    mov    [nuevaPosicion+8],rdx
    jmp    verificarSiLaPosicionEsValida

sureste:
    mov    rdx,[posZorro]
    inc    rdx
    mov    [nuevaPosicion],rdx
    mov    rdx,[posZorro+8]
    inc    rdx
    mov    [nuevaPosicion+8],rdx
    jmp    verificarSiLaPosicionEsValida

verificarAntesDeMover:
    mPuts txtPosicionInvalida
    jmp   moverPieza

verificarSiLaPosicionEsValida:
    cmp     qword[nuevaPosicion],0
    jl      verificarAntesDeMover
    cmp     qword[nuevaPosicion],7
    jge     verificarAntesDeMover
    cmp     qword[nuevaPosicion+8],0
    jl      verificarAntesDeMover
    cmp     qword[nuevaPosicion+8],7
    jge     verificarAntesDeMover
    jmp     mover
    
