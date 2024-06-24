%include "macros.asm"

global main

extern printMatriz

section .data
    bienvenido db  "~~~~~~~~~~ ¡Bienvenido al juego el Zorro y las Ocas! ~~~~~~~~~~",0
    elegirSimboloZorro db "Elija el símbolo para el zorro: ",0
    elegirSimboloOcas db "Elija el símbolo para las ocas: ",0
    elegirOrientacion db "Elija la orientación del tablero (N(Norte)/ S(Sur)/ E(Este)/ O(Oeste): ",0
    txtPersonalizarSimbolos db "¿Desea personalizar los simbolos del juego? (S/N): ",0
    txtPersonalizarOrientacion db "¿Desea personalizar la orientación del tablero? (S/N): ",0
    afirmacion db "S",0
    negacion db "N",0
    ocasDistintoAZorro db "El símbolo de las ocas no puede ser igual al del zorro.",0
    txtOrientacionInvalida db "Orientación inválida.",0
    txtSiguientePos db "Ingrese la siguiente posición: ",0
    txtPosicionInvalida db "Posicion inválida.",0
    txtCantidadDeOcasMuertas db 10,"Cantidad de ocas muertas: %d",10,0
    txtCantidadMovimientosZorro db "Cantidad de movimientos del zorro:",0
    txtIngresePosOca db "Ingrese la posición de la oca a mover (<fila> <columna>): ",0
    txtGanoZorro db "--------> ¡JUEGO FINALIZADO! El zorro ha ganado. <--------",0
    txtGanoOca db "--------> ¡JUEGO FINALIZADO! Las ocas han ganado. <--------",0
    txtCadaMovimiento db "%d ",0
    formato db "%d %d",0
    simboloZorro db "X",0
    simboloOca db "O",0
    oriecionTrablero db "N",0 ;N : Norte
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
    simboloZorroNuevo resb 1
    simboloOcaNuevo resb 1
    orientacionNueva resb 1
    personalizarSimbolos resb 1
    personalizarOrientacion resb 1

section .text

main:
    mPuts   bienvenido

opcionConfigurarSimbolos:
    mPuts   txtPersonalizarSimbolos
    mGets   personalizarSimbolos
    mov     r15b,[personalizarSimbolos]
    cmp     r15b,[afirmacion]
    je      setearZorro
    jne     opcionOrientacion
setearZorro:
    mPuts   elegirSimboloZorro
    mGets   simboloZorroNuevo
    jmp setearOcas
reelegirOca:
    mPuts   ocasDistintoAZorro
setearOcas:
    mPuts   elegirSimboloOcas
    mGets   simboloOcaNuevo
    mov    r15b,[simboloZorroNuevo]
    cmp    r15b,[simboloOcaNuevo]
    je     reelegirOca

setearMatriz:
    mov     r15,matriz ;r15 es la direccion de la matriz
    mov     r12,0 ;indice de la r15
modificarMatriz:
    mov     al,[r15+r12]
    cmp     al,[simboloOca]
    je      cambiarOca
    mov     al,[r15+r12]
    cmp     al,[simboloZorro]
    je      cambiarZorro
incrementarIndice:
    inc     r12
    cmp     r12,49
    jne     modificarMatriz
    je      setearOcasYZorro
cambiarOca:
    mov     r13b,[simboloOcaNuevo]
    mov     [r15+r12],r13b
    jmp     incrementarIndice
cambiarZorro:
    mov     r13b,[simboloZorroNuevo]
    mov     [r15+r12],r13b
    jmp     incrementarIndice

setearOcasYZorro:
    mov     r13b,[simboloOcaNuevo]
    mov     [simboloOca],r13b
    mov     r13b,[simboloZorroNuevo]
    mov    [simboloZorro],r13b
    jmp     opcionOrientacion

opcionOrientacion:
    mPuts   txtPersonalizarOrientacion
    mGets   personalizarOrientacion
    mov     r15b,[personalizarOrientacion]
    cmp     r15b,[afirmacion]
    jne     mostrarInicio
    je      pedirOrientacion

orientacionInvalida:
    mPuts   txtOrientacionInvalida

pedirOrientacion:
    mPuts   elegirOrientacion
    mGets   orientacionNueva
    cmp     byte[orientacionNueva],"N"
    je      mostrarInicio
    cmp     byte[orientacionNueva],"S"
    je      cambiarAorientacionSur
    cmp    byte[orientacionNueva],"E"
    je     cambiarAorientacionEste
    cmp    byte[orientacionNueva],"O"
    je     cambiarAorientacionOeste
    jmp     orientacionInvalida

cambiarAorientacionSur:
    mov     r15,matriz ;r15 es la direccion de la matriz
    mov     r12,0 ;indice de la r15
    mov     r13,1 ; indice de la columna
    mov     r14,1 ;indice de la fila

modificarMatrizSur:
    mov     al,[r15+r12]
    cmp     al,-1
    je      incrementarIndiceSur
    jmp     rellenarTableroSur

incrementarIndiceSur:
    inc     r13
    cmp     r13,8
    je      resetColumnas
    inc     r12
    cmp     r12,49
    je      mostrarInicio
    jne     modificarMatrizSur
    
resetColumnas:
    mov     r13,0
    inc     r14 ;incremento la fila
    jmp     incrementarIndiceSur

rellenarOca:
    mov     r10b,[simboloOca]
    cmp     [r15+r12],r10b
    je      incrementarIndiceSur
    mov     r10b,[simboloOca]
    mov     [r15+r12],r10b
    jmp     incrementarIndiceSur

rellenarZorro:
    mov     r10b,[simboloZorro]
    mov     [r15+r12],r10b
    mov     qword[posZorro],2
    mov     qword[posZorro+8],3
    jmp     incrementarIndiceSur

rellenarTableroSur:
    cmp     r12,17
    je      rellenarZorro 
    cmp     r12,1
    cmp     r14,5
    je      rellenarOca
    cmp     r14,6
    je      rellenarOca
    cmp     r14,7
    je      rellenarOca
    cmp     r13,1
    je      rellenarOca
    cmp     r13,7
    je      rellenarOca
    jmp     ponerEspacio

ponerEspacio:
    mov   byte[r15+r12]," "
    jmp   incrementarIndiceSur

cambiarAorientacionEste:
    mPuts   orientacionNueva
    jmp     mostrarInicio
    ;falta

cambiarAorientacionOeste:
    mPuts   orientacionNueva
    jmp     mostrarInicio
    ;falta

mostrarInicio:
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
    jmp    txtMovimientoInvalidoZorro

movimientoValidoZorro:

    mov     rdx,[nuevaPosicion]
    imul    rdx,7
    mov     rax,[nuevaPosicion+8]
    mov     r8b,[simboloZorro]
    mov     byte[matriz+rdx+rax],r8b

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
    jne    txtMovimientoInvalidoZorro
    mov    [nuevaPosicion],r12
    mov    [nuevaPosicion+8],r13
    mHayEspacioLibre? r12, r13;me fijo si hay un espacio libre, si no lo hay, es porque estoy tratando de saltar una oca
    je     movimientoValidoZorro;y si no, me fijo si puedo saltar sobre una oca
    add    r12,r10
    add    r13,r11
    call   verificarSiLaPosicionEsValida
    cmp    ax,1
    jne    txtMovimientoInvalidoZorro
    mHayEspacioLibre? r12, r13;si hay una oca, no puedo saltar
    jne    txtMovimientoInvalidoZorro
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

txtMovimientoInvalidoZorro:
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
    mov     r8b,[simboloOca]
    cmp     byte[matriz+rdx+rax],r8b
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
    mov     r8b,[simboloOca]
    mov     byte[matriz+rdx+rax],r8b

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
