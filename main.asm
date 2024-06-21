%include "macros.asm"

global main

extern printMatriz

section .data
    bienvenido db  "~~~~~~~~~~ ¡Bienvenido al juego el Zorro y las Ocas! ~~~~~~~~~~",0
    txtSiguientePos db "Ingrese la siguiente posición: ",0
    txtPosicionInvalida db "Posicion inválida.",0
    txtCantidadDeOcasMuertas db 10,"Cantidad de ocas muertas: %d",10,0
    txtCantidadMovimientosZorro db "Cantidad de movimientos del zorro:",0
    txtIngresePosOca db "Ingrese la posición de la oca a mover (<fila> <columna>): ",0
    txtGanoZorro db "--------> ¡JUEGO FINALIZADO! El zorro ha ganado. <--------",0
    txtGanoOca db "--------> ¡JUEGO FINALIZADO! Las ocas han ganado. <--------",0
    txtCadaMovimiento db "%d ",0
    formato db "%d %d",0
    matriz db -1,-1,  "O","O","O",  -1,-1,
           db -1,-1,  "O","O","O",  -1,-1,
           db "O","O","O","O","O","O","O",
           db "O"," "," "," "," "," ","O",
           db "O"," "," ","X"," "," ","O",
           db -1,-1,  " "," "," ",  -1,-1,
           db -1,-1,  " "," "," ",  -1,-1
    cantOcasMuertas db 0
    cantMovimientosZorro times 8 db 0
    posZorro dq 4,3
    turnoZorro db "~~~~~~ Turno del zorro ~~~~~~",0
    turnoOca db "~~~~~~ Turno de la oca ~~~~~~",0
    controles db "CONTROLES",10,
              db "Arriba:    W",10,"Abajo:     S",10,
              db "Izquierda: A",10,"Derecha:   D",10,
              db "Noroeste:  Q",10,"Noreste:   E",10,
              db "Suroeste:  Z",10,"Sureste:   X",10,
              db "Salir:     P",0
    formatoEstadisticas db "%c: %d | ",0
    letrasEstadisticas db "W","S","D","A","Q","E","Z","X",0
    salirFlag db 0

section .bss
    zorroAcabaDeComerOca? resb 1  
    posicionSiguiente resb 2
    nuevaPosicion   resq 2
    posOca      resq 2
    stringAux   resb 20

section .text

main:
    mPuts   bienvenido
    mPuts   controles
    mPrintMatriz matriz
inicio:
    mPuts   turnoZorro
    sub     rsp,8
    call    moverZorro
    add     rsp,8
    cmp     byte[salirFlag],1
    je      retorno
    mPrintMatriz matriz 
    cmp     byte[cantOcasMuertas],12
    je      printGanoZorro
    cmp     byte[zorroAcabaDeComerOca?],1
    je      inicio

    mPuts   turnoOca
    sub     rsp,8
    call    moverOca
    add     rsp,8
    cmp     byte[salirFlag],1
    je      retorno
    mPrintMatriz matriz
    sub     rsp,8
    call    verificarZorroAcorralado
    add     rsp,8
    cmp     bx,1
    je      printGanoOca

    jmp     inicio

printGanoZorro:
    mPuts   txtGanoZorro
    sub     rsp,8
    call    mostrarEstadisticas
    add     rsp,8
    ret

printGanoOca:
    mPuts   txtGanoOca
    sub     rsp,8
    call    mostrarEstadisticas
    add     rsp,8
    ret

mostrarEstadisticas:

    mPuts   txtCantidadMovimientosZorro
    mov     r14,0
loopEstadisticas:
 
    mov     rdi,formatoEstadisticas
    movzx   rsi,byte[letrasEstadisticas+r14]
    movzx   rdx,byte[cantMovimientosZorro+r14]
    mPrintf
    inc     r14
    cmp     r14,8
    jne     loopEstadisticas

    mov     rdi,txtCantidadDeOcasMuertas
    movzx   rsi,byte[cantOcasMuertas]
    mPrintf

    ret


verificarZorroAcorralado:
    mov     bx,1

    mov     r10,-1
    mov     r11,0
    call    calcularCadaCostadoDelZorro
    cmp     bx,0
    je      retorno

    mov     r10,1
    mov     r11,0
    call    calcularCadaCostadoDelZorro
    cmp     bx,0
    je      retorno

    mov     r10,0
    mov     r11,1
    call    calcularCadaCostadoDelZorro
    cmp     bx,0
    je      retorno

    mov     r10,0
    mov     r11,-1
    call    calcularCadaCostadoDelZorro
    cmp     bx,0
    je      retorno
    
    mov     r10,-1
    mov     r11,-1
    call    calcularCadaCostadoDelZorro
    cmp     bx,0
    je      retorno

    mov     r10,-1
    mov     r11,1
    call    calcularCadaCostadoDelZorro
    cmp     bx,0
    je      retorno

    mov     r10,1
    mov     r11,-1
    call    calcularCadaCostadoDelZorro
    cmp     bx,0
    je      retorno

    mov     r10,1
    mov     r11,1
    call    calcularCadaCostadoDelZorro
    cmp     bx,0
    je      retorno

    ret


calcularCadaCostadoDelZorro:
    mov     r12,[posZorro]
    mov     r13,[posZorro+8]
    add     r12,r10
    add     r13,r11
    call    verificarSiLaPosicionEsValida
    cmp     ax,1
    jne     retorno
    mHayEspacioLibre? r12, r13
    je      elZorroNoEstaAcorralado
    add     r12,r10
    add     r13,r11
    call    verificarSiLaPosicionEsValida
    cmp     ax,1
    jne     retorno
    mHayEspacioLibre? r12, r13
    je      elZorroNoEstaAcorralado
retorno:
    ret

elZorroNoEstaAcorralado:
    mov     bx,0
    ret

moverZorro:
    mov    byte[zorroAcabaDeComerOca?],0
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
    cmp    byte[posicionSiguiente],"P"
    je     salir
    jmp    msgMovimientoInvalidoZorro

movimientoValidoZorro:

    mov     rdx,[nuevaPosicion]
    imul    rdx,7
    mov     rax,[nuevaPosicion+8]
    mov     byte[matriz+rdx+rax],"X"

    mov     rdx,[posZorro]
    imul    rdx,7
    mov     rax,[posZorro+8]
    mov     byte[matriz+rdx+rax]," "

    mov     rdx,[nuevaPosicion]
    mov     [posZorro],rdx
    mov     rdx,[nuevaPosicion+8]
    mov     [posZorro+8],rdx

    inc    byte[r15]

    ret

calcularMovimientoZorro:
    mov    r12,[posZorro]
    mov    r13,[posZorro+8]
    add    r12,r10
    add    r13,r11
    call   verificarSiLaPosicionEsValida
    cmp    ax,1
    jne    msgMovimientoInvalidoZorro
    mov    [nuevaPosicion],r12
    mov    [nuevaPosicion+8],r13
    mHayEspacioLibre? r12, r13;me fijo si hay un espacio libre, si no lo hay, es porque estoy tratando de saltar una oca
    je     movimientoValidoZorro;y si no, me fijo si puedo saltar sobre una oca
    add    r12,r10
    add    r13,r11
    call   verificarSiLaPosicionEsValida
    cmp    ax,1
    jne    msgMovimientoInvalidoZorro
    mHayEspacioLibre? r12, r13;si hay una oca, no puedo saltar
    jne    msgMovimientoInvalidoZorro
    mov    rdx,[nuevaPosicion]
    imul   rdx,7
    mov    rax,[nuevaPosicion+8]
    mov    byte[matriz+rdx+rax]," "
    mov    [nuevaPosicion],r12
    mov    [nuevaPosicion+8],r13
    inc    byte[cantOcasMuertas]
    inc    byte[zorroAcabaDeComerOca?]
    jmp    movimientoValidoZorro

arriba:
    mov    r10,-1
    mov    r11,0
    mov    r15,cantMovimientosZorro
    jmp    calcularMovimientoZorro
 
abajo:
    mov    r10,1
    mov    r11,0
    mov    r15,cantMovimientosZorro+1
    jmp    calcularMovimientoZorro

derecha:
    mov    r10,0
    mov    r11,1
    mov    r15,cantMovimientosZorro+2
    jmp    calcularMovimientoZorro

izquierda:
    mov    r10,0
    mov    r11,-1
    mov    r15,cantMovimientosZorro+3
    jmp    calcularMovimientoZorro
    
noroeste:
    mov    r10,-1
    mov    r11,-1
    mov    r15,cantMovimientosZorro+4
    jmp    calcularMovimientoZorro

noreste:
    mov    r10,-1
    mov    r11,1
    mov    r15,cantMovimientosZorro+5
    jmp    calcularMovimientoZorro

suroeste:
    mov    r10,1
    mov    r11,-1
    mov    r15,cantMovimientosZorro+6
    jmp    calcularMovimientoZorro

sureste:
    mov    r10,1
    mov    r11,1
    mov    r15,cantMovimientosZorro+7
    jmp    calcularMovimientoZorro
 
posicionInvalida:
    mov     ax,0;se devuelve 0 en ax si es inválida
    ret

verificarSiLaPosicionEsValida:

    cmp     r12,0
    jl      posicionInvalida
    cmp     r12,7
    jge     posicionInvalida
    cmp     r13,0
    jl      posicionInvalida
    cmp     r13,7
    jge     posicionInvalida
    imul    r14,r12,7
    cmp     byte[matriz+r14+r13],-1
    je      posicionInvalida    

    mov     ax,1;se devuelve 1 si la posición es válida
    ret

msgMovimientoInvalidoZorro:
    mPuts txtPosicionInvalida
    jmp   moverZorro

salir:
    inc byte[salirFlag]
    ret


;-------------------------------- OCA ----------------------------------------- 

moverOca:
    mPuts   txtIngresePosOca
    mGets   stringAux
    cmp     byte[stringAux],"P"
    je      salir
    mSscanf2 stringAux,formato,posOca,posOca+8
    cmp     rax,2
    jne     moverOca
    dec     qword[posOca]
    dec     qword[posOca+8]

    mov     rdx,[posOca]
    imul    rdx,7
    mov     rax,[posOca+8]
    cmp     byte[matriz+rdx+rax],"O"
    jne     printError ;Comparo el valor de la matriz en la posición ingresada y verifico si hay una oca
    
seleccionarOpcionOca:
    mPuts  txtSiguientePos
    mGets  posicionSiguiente
    cmp    byte[posicionSiguiente],"S"
    je     abajoOca
    cmp    byte[posicionSiguiente],"A"
    je     izquierdaOca
    cmp    byte[posicionSiguiente],"D"
    je     derechaOca
    cmp    byte[posicionSiguiente],"P"
    je     salir
    jmp    printError

movimientoValidoOca:

    mov     rdx,[nuevaPosicion]
    imul    rdx,7
    mov     rax,[nuevaPosicion+8]
    mov     byte[matriz+rdx+rax],"O"

    mov     rdx,[posOca]
    imul    rdx,7
    mov     rax,[posOca+8]
    mov     byte[matriz+rdx+rax]," "

    mov     rdx,[nuevaPosicion]
    mov     [posOca],rdx
    mov     rdx,[nuevaPosicion+8]
    mov     [posOca+8],rdx

    ret

calcularMovimientoOca:
    mov    r12,[posOca]
    mov    r13,[posOca+8]
    add    r12,r10
    add    r13,r11
    call   verificarSiLaPosicionEsValida
    cmp    ax,1
    jne    printError
    mov    [nuevaPosicion],r12
    mov    [nuevaPosicion+8],r13
    mHayEspacioLibre? r12, r13
    je     movimientoValidoOca
    jmp    printError

abajoOca:
    mov    r10,1
    mov    r11,0
    jmp    calcularMovimientoOca   

derechaOca:
    mov    r10,0
    mov    r11,1
    jmp    calcularMovimientoOca  

izquierdaOca:
    mov    r10,0
    mov    r11,-1
    jmp    calcularMovimientoOca  

printError:
    mPuts txtPosicionInvalida
    jmp   moverOca
