%macro mPrintf 0
    sub     rsp,8
    call    printf
    add     rsp,8
%endmacro

%macro mPuts 1
    mov     rdi,%1
    sub     rsp,8
    call    puts
    add     rsp,8
%endmacro

%macro mGets 1
    mov     rdi,%1
    sub     rsp,8
    call    gets
    add     rsp,8
%endmacro

%macro mSscanf 3
    mov     rdi,%1
    mov     rsi,%2
    mov     rdx,%3
    sub     rsp,8
    call    sscanf
    add     rsp,8
%endmacro

%macro mSscanf2 4
    mov     rdi,%1
    mov     rsi,%2
    mov     rdx,%3
    mov     rcx,%4
    sub     rsp,8
    call    sscanf
    add     rsp,8
%endmacro

%macro mImprimirNumeroFila 0
    sub     rsp,8
    call    imprimirNumeroFila
    add     rsp,8
%endmacro

%macro mPrintMatriz 1
    mov     rdi,%1
    sub     rsp,8
    call    printMatriz
    add     rsp,8
%endmacro

%macro mHayEspacioLibre? 2
    mov    rdx,%1
    imul   rdx,7
    mov    rax,%2
    cmp    byte[matriz+rdx+rax]," "
%endmacro

extern  printf
extern  puts
extern  gets
extern  sscanf
