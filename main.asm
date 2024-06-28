%include "macros.asm"

global main

extern printMatriz

section .data
    txtBienvenido db  "~~~~~~~~~~~~~~~~~~ ¡BIENVENIDO AL JUEGO EL ZORRO Y LAS OCAS! ~~~~~~~~~~~~~~~~~~",0
    txtBloqMayus db "ATENCIÓN: El bloqueo de mayúsculas debe estar activado para jugar con facilidad.",0
    txtParaSalirDelJuego db "Para salir del juego puede presionar la tecla 'P' en cualquier instante de la partida.",0
    txtControles db "Luego de iniciar la partida, podrá acceder a ayuda de comandos al presionar la tecla 'H' en cualquier momento.",0
    txtComoGuardarPartida db "Se podrá guardar la partida actual inmediatamente luego del turno de cualquiera de los jugadores con la tecla 'G'.",0
    txtElegirSimboloZorro db "Elija el símbolo para el zorro:",0
    txtElegirSimboloOcas db "Elija el símbolo para las ocas:",0
    txtDeseaCargarPartida db "Crear una nueva partida -----> N",10, "Cargar una partida guardada -> C",10, "Salir -----------------------> P",0
    txtIngreseOpcion db "Ingrese una opción:",0
    txtElegirOrientacion db "~ Orientaciones del tablero ~",10,"N --> Norte",10,"S --> Sur",10,"E --> Este",10,"O --> Oeste",0
    txtPersonalizarSimbolos db "¿Desea personalizar los simbolos del juego? (S/N):",0
    txtPersonalizarOrientacion db "¿Desea personalizar la orientación del tablero? (S/N):",0
    txtOcasDistintoAZorro db "¡ERROR! El símbolo de las ocas no puede ser igual al del zorro.",0
    txtOrientacionInvalida db "Orientación inválida.",0
    txtOpcionInvalida db "Opción inválida.",0
    txtSiguientePos db "Ingrese la siguiente posición:",0
    txtPosicionInvalida db "Posicion inválida.",0
    txtCantidadDeOcasMuertas db "Cantidad de ocas muertas: %d",10,0
    txtCantidadMovimientosZorro db "Cantidad de movimientos del zorro:",0
    txtIngresePosOca db "Ingrese la posición de la oca a mover (<fila> <columna>):",0
    txtGanoZorro db "--------> ¡JUEGO FINALIZADO! El zorro ha ganado. <--------",0
    txtGanoOca db "--------> ¡JUEGO FINALIZADO! Las ocas han acorralado al zorro. <--------",0
    txtNombrePartidaGuardar db "Ingrese un nombre para guardar la partida:",0
    txtErrorAlAbrirArchivo db "Error al abrir el archivo.",0
    txtNombrePartidaAbrir db "Ingrese el archivo de la partida a cargar:",0
    txtExitoPartidaGuardada db "¡EXITO! La partida se ha guardado correctamente.",0
    txtCadaMovimiento db "%d ",0
    txtNombreDeLaPartidaCargada db "============ Partida: %s ============",10,0
    txtPartidaIniciada db "============ Partida iniciada ============",0
    turnoZorro db "~~~~~~ Turno del zorro ~~~~~~",0
    turnoOca db "~~~~~~ Turno de la oca ~~~~~~",0
    txtOrientacionActual db "Orientación actual del tablero: %s",10,0
    txtGoodBye db "Good-Bye!",0
    txtEspacio db " ",0
    formato db "%d %d",0
    modoEscritura db "wb",0
    modoLectura db "rb",0
    simboloZorro db "X"
    simboloOca db "O"
    orientancionTablero db "N",0
    cantOcasMuertas db 0
    cantMovimientosZorro times 8 db 0
    posZorro dq 4,3
    controles db "              ~~ CONTROLES ~~",10,10,
              db "   Arriba:       W",10,"   Abajo:        S",10,
              db "   Izquierda:    A",10,"   Derecha:      D",10,
              db "   Noroeste:     Q",10,"   Noreste:      E",10,
              db "   Suroeste:     Z",10,"   Sureste:      X",10,
              db "   Salir:        P",10,"   Guardar:      G",10,0
    formatoEstadisticas db "%c: %d | ",0
    letrasEstadisticas db "W","S","D","A","Q","E","Z","X",0
    salirFlag db 0
    matriz db -1,-1,  "O","O","O",  -1,-1,
           db -1,-1,  "O","O","O",  -1,-1,
           db "O","O","O","O","O","O","O",
           db "O"," "," "," "," "," ","O",
           db "O"," "," ","X"," "," ","O",
           db -1,-1,  " "," "," ",  -1,-1,
           db -1,-1,  " "," "," ",  -1,-1

    orSur  db -1,-1,  " "," "," ",  -1,-1,
           db -1,-1,  " "," "," ",  -1,-1,
           db "O"," "," ","X"," "," ","O",
           db "O"," "," "," "," "," ","O",
           db "O","O","O","O","O","O","O",
           db -1,-1,  "O","O","O",  -1,-1,
           db -1,-1,  "O","O","O",  -1,-1

    orEste db -1,-1,  "O","O","O",  -1,-1,
           db -1,-1,  " "," ","O",  -1,-1,
           db " "," "," "," ","O","O","O",
           db " "," ","X"," ","O","O","O",
           db " "," "," "," ","O","O","O",
           db -1,-1,  " "," ","O",  -1,-1,
           db -1,-1,  "O","O","O",  -1,-1

   orOeste db -1,-1,  "O","O","O",  -1,-1,
           db -1,-1,  "O"," "," ",  -1,-1,
           db "O","O","O"," "," "," "," ",
           db "O","O","O"," ","X"," "," ",
           db "O","O","O"," "," "," "," ",
           db -1,-1,  "O"," "," ",  -1,-1,
           db -1,-1,  "O","O","O",  -1,-1   

section .bss
    zorroAcabaDeComerOca? resb 1  
    posicionSiguiente resb 2
    nuevaPosicion   resq 2
    posOca      resq 2
    stringAux   resb 30
    simboloZorroNuevo resw 2
    simboloOcaNuevo resw 2
    opcion resw 4
    turnoActual resb 1

section .text

main:
    mPuts   txtBienvenido
    mPuts   txtBloqMayus
    mPuts   txtControles
    mPuts   txtParaSalirDelJuego
    mPuts   txtComoGuardarPartida
    mPuts   txtDeseaCargarPartida
ingreseOpcion:
    mPuts   txtIngreseOpcion
    mGets   opcion
    cmp     byte[opcion],"N"
    je      opcionOrientacion
    cmp     byte[opcion],"P"
    je      salir
    cmp     byte[opcion],"C"
    je      cargarPartida
    jmp     opcionInvalida


opcionInvalida:
    mPuts   txtOpcionInvalida
    jmp     ingreseOpcion

opcionOrientacion:
    mPuts   txtPersonalizarOrientacion
    mGets   opcion
    cmp     byte[opcion],"S"
    je      pedirOrientacion
    cmp     byte[opcion],"N"
    je      opcionConfigurarSimbolos
    cmp     byte[opcion],"P"
    je      salir
    jmp     opcionOrientacion

orientacionInvalida:
    mPuts   txtOrientacionInvalida

pedirOrientacion:
    mPuts   txtElegirOrientacion
    mPuts   txtIngreseOpcion
    mGets   opcion
    cmp     byte[opcion],"N"
    je      mostrarInicio
    cmp     byte[opcion],"S"
    je      cambiarAorientacionSur
    cmp     byte[opcion],"E"
    je      cambiarAorientacionEste
    cmp     byte[opcion],"O"
    je      cambiarAorientacionOeste
    jmp     orientacionInvalida

cambiarAorientacionSur:
    mov     r12,0
    mov     r13,orSur
    mov     byte[orientancionTablero],"S"
    mov     qword[posZorro],2
    mov     qword[posZorro+8],3
    jmp     loopOrientacion   

cambiarAorientacionEste:
    mov     r12,0
    mov     r13,orEste
    mov     byte[orientancionTablero],"E"
    mov     qword[posZorro],3
    mov     qword[posZorro+8],2
    jmp     loopOrientacion    

cambiarAorientacionOeste:
    mov     r12,0
    mov     r13,orOeste
    mov     byte[orientancionTablero],"O"
    mov     qword[posZorro],3
    mov     qword[posZorro+8],4
    jmp     loopOrientacion

loopOrientacion:
    mov     al,[r13+r12]
    mov     [matriz+r12],al
    inc     r12
    cmp     r12,49
    jne     loopOrientacion

;--------------------------------------------------

opcionConfigurarSimbolos:
    mPuts   txtPersonalizarSimbolos
    mGets   opcion
    cmp     byte[opcion],"S"
    je      setearZorro
    cmp     byte[opcion],"N"
    je      mostrarInicio
    cmp     byte[opcion],"P"
    je      salir
    jmp     opcionConfigurarSimbolos

setearZorro:
    mPuts   txtElegirSimboloZorro
    mGets   simboloZorroNuevo
setearOcas:
    mPuts   txtElegirSimboloOcas
    mGets   simboloOcaNuevo
    mov     r15b,[simboloZorroNuevo]
    cmp     r15b,[simboloOcaNuevo]
    jne     setearMatriz

reelegirOca:
    mPuts   txtOcasDistintoAZorro
    jmp     setearZorro

setearMatriz:
    mov     r12,0 ;indice de la matriz
modificarMatriz:
    mov     al,[matriz+r12]
    cmp     al,[simboloOca]
    je      cambiarOca
    mov     al,[matriz+r12]
    cmp     al,[simboloZorro]
    je      cambiarZorro
incrementarIndice:
    inc     r12
    cmp     r12,49
    jne     modificarMatriz
    je      setearOcasYZorro
cambiarOca:
    mov     r13b,[simboloOcaNuevo]
    mov     [matriz+r12],r13b
    jmp     incrementarIndice
cambiarZorro:
    mov     r13b,[simboloZorroNuevo]
    mov     [matriz+r12],r13b
    jmp     incrementarIndice

setearOcasYZorro:
    mov     r13b,[simboloOcaNuevo]
    mov     [simboloOca],r13b
    mov     r13b,[simboloZorroNuevo]
    mov     [simboloZorro],r13b


mostrarInicio:
    mPuts   txtPartidaIniciada
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
turnoLaOca:
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
    mov     rdi,txtCantidadDeOcasMuertas
    movzx   rsi,byte[cantOcasMuertas]
    mPrintf

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
    mPuts   txtEspacio

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

mostrarHelpEnZorro:
    mPuts   controles

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
    cmp    byte[posicionSiguiente],"G"
    je     llamarGuardarPartidaEnZorro
    cmp    byte[posicionSiguiente],"H"
    je     mostrarHelpEnZorro
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

    inc     byte[r15] ;r15 = cantMovimientosZorro+2

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
    mov    r15,cantMovimientosZorro+0
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
    mPuts   txtPosicionInvalida
    jmp     moverZorro

salir:
    inc     byte[salirFlag]
    mPuts   txtGoodBye
    ret


;-------------------------------- OCA ----------------------------------------- 

mostrarHelpEnOca:
    mPuts   controles

moverOca:
    mPuts   txtIngresePosOca
    mGets   stringAux
    cmp     byte[stringAux],"P"
    je      salir
    cmp     byte[stringAux],"G"
    je      llamarGuardarPartidaEnOca
    cmp     byte[stringAux],"H"
    je      mostrarHelpEnOca
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
    jne     printErrorOca ;Comparo el valor de la matriz en la posición ingresada y verifico si hay una oca

seleccionarOpcionOca:
    mPuts  txtSiguientePos
    mGets  posicionSiguiente
    cmp    byte[posicionSiguiente],"P"
    je     salir
    cmp    byte[posicionSiguiente],"G"
    je     llamarGuardarPartidaEnOca
    cmp    byte[posicionSiguiente],"H"
    je     mostrarHelpEnOca
    cmp    byte[orientancionTablero],"N"
    je     movimientoOcaConTableroNorte
    cmp    byte[orientancionTablero],"S"
    je     movimientoOcaConTableroSur
    cmp    byte[orientancionTablero],"E"
    je     movimientoOcaConTableroEste
    cmp    byte[orientancionTablero],"O"
    je     movimientoOcaConTableroOeste

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
    jne    printErrorOca
    mov    [nuevaPosicion],r12
    mov    [nuevaPosicion+8],r13
    mHayEspacioLibre? r12, r13
    je     movimientoValidoOca
    jmp    printErrorOca

movimientoOcaConTableroNorte:

    cmp    byte[posicionSiguiente],"S"
    je     abajoOca
    cmp    byte[posicionSiguiente],"A"
    je     izquierdaOca
    cmp    byte[posicionSiguiente],"D"
    je     derechaOca

    jmp    printErrorOca

movimientoOcaConTableroSur:

    cmp    byte[posicionSiguiente],"W"
    je     arribaOca
    cmp    byte[posicionSiguiente],"A"
    je     izquierdaOca
    cmp    byte[posicionSiguiente],"D"
    je     derechaOca

    jmp    printErrorOca

movimientoOcaConTableroEste:

    cmp    byte[posicionSiguiente],"A"
    je     izquierdaOca
    cmp    byte[posicionSiguiente],"W"
    je     arribaOca
    cmp    byte[posicionSiguiente],"S"
    je     abajoOca

    jmp    printErrorOca

movimientoOcaConTableroOeste:

    cmp    byte[posicionSiguiente],"D"
    je     derechaOca
    cmp    byte[posicionSiguiente],"W"
    je     arribaOca
    cmp    byte[posicionSiguiente],"S"
    je     abajoOca

    jmp    printErrorOca

arribaOca:
    mov    r10,-1
    mov    r11,0
    jmp    calcularMovimientoOca

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

printErrorOca:
    mPuts txtPosicionInvalida
    jmp   moverOca

;----------------------------------- GUARDAR PARTIDA

llamarGuardarPartidaEnZorro:
    mov     byte[turnoActual],1
    sub     rsp,8
    call    guardarPartida
    add     rsp,8
    jmp     moverZorro

llamarGuardarPartidaEnOca:
    mov     byte[turnoActual],0
    sub     rsp,8
    call    guardarPartida
    add     rsp,8
    jmp     moverOca


guardarPartida:
    mPuts   txtNombrePartidaGuardar
    mGets   stringAux
    
    mFopen  stringAux,modoEscritura 
    cmp     rax,0
    je      errorAlAbrirArchivo

    mov     r12,rax 
    
    mFwrite matriz,1,49,r12
    mFwrite simboloZorro,1,1,r12
    mFwrite simboloOca,1,1,r12
    mFwrite orientancionTablero,1,1,r12
    mFwrite cantOcasMuertas,1,1,r12
    mFwrite cantMovimientosZorro,1,8,r12
    mFwrite posZorro,8,2,r12
    mFwrite turnoActual,1,1,r12

    mFclose r12
    mPuts   txtExitoPartidaGuardada

    ret

errorAlCrearArchivo:
    mPuts   txtErrorAlAbrirArchivo
    jmp     guardarPartida
     
;----------------------------------- CARGAR PARTIDA

cargarPartida:

    mPuts   txtNombrePartidaAbrir
    mGets   stringAux

    mFopen  stringAux,modoLectura
    cmp     rax,0
    je      errorAlAbrirArchivo

    mov     r12,rax

    mFread  matriz,1,49,r12
    mFread  simboloZorro,1,1,r12
    mFread  simboloOca,1,1,r12
    mFread  orientancionTablero,1,1,r12
    mFread  cantOcasMuertas,1,1,r12
    mFread  cantMovimientosZorro,1,8,r12
    mFread  posZorro,8,2,r12
    mFread  turnoActual,1,1,r12

    mFclose r12

    mov     rdi,txtNombreDeLaPartidaCargada
    mov     rsi,stringAux
    mPrintf 

    mov     rdi,txtOrientacionActual
    mov     rsi,orientancionTablero
    mPrintf

    mPuts   controles
    mPrintMatriz matriz
    cmp     byte[turnoActual],1
    je      inicio
    jmp     turnoLaOca

errorAlAbrirArchivo:

    mPuts   txtErrorAlAbrirArchivo
    jmp     ingreseOpcion    