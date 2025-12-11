section .data

section .text

; ------------------------
; Offsets de Structs
; ------------------------
LIBRO_TITULO_OFFSET equ 0
LIBRO_AUTOR_OFFSET equ 128
LIBRO_ANIO_OFFSET equ 192
LIBRO_CATEGORIA_OFFSET equ 196
LIBRO_PAGINAS_OFFSET equ 200
LIBRO_DISPONIBLE_OFFSET equ 204
LIBRO_RATING_OFFSET equ 208
LIBRO_SIZE equ 212

BIBLIO_LIBROS_OFFSET equ 0
BIBLIO_CANTIDAD_LIBROS_OFFSET equ 8
BIBLIO_NOMBRE_OFFSET equ 16
BIBLIO_SIZE equ 80

LISTA_INDICES_OFFSET equ 0
LISTA_CANTIDAD_OFFSET equ 8
LISTA_SIZE equ 16

; ------------------------
; Signatura de la función
; ------------------------
; uint32_t contarPaginasTotales(Biblioteca *biblioteca, uint32_t indice_actual, bool *visitados)
; Parámetros:
;   rdi: Biblioteca *biblioteca
;   rsi: uint32_t indice_actual (32 bits, pero pasado en 64)
;   rdx: bool *visitados
;
; Valor de retorno:
;   rax: uint32_t (total de páginas)

global contarPaginasTotales
contarPaginasTotales:
.prologo:
    push    rbp
    mov     rbp, rsp

    push    r12
    push    r13
    push    r14
    push    r15

.cuerpo:
    ; Guardar parámetros en registros no volátiles
    mov     r12,    rdi                     ; r12 = biblioteca
    mov     r13d,   esi                     ; r13d = indice_actual (32 bits)
    mov     r14,    rdx                     ; r14 = visitados

    ; Caso base: indice_actual >= biblioteca->cantidad_libros
    mov     r15,    [r12 + BIBLIO_CANTIDAD_LIBROS_OFFSET]  ; r15 = cantidad_libros
    cmp     r13,    r15                     ; indice_actual >= cantidad_libros?
    jge     .return_zero

    ; Verificar si ya fue visitado: visitados[indice_actual]
    movzx   eax,    byte [r14 + r13]        ; al = visitados[indice_actual]
    test    al,     al
    jnz     .ya_visitado                    ; Si ya fue visitado, saltar

    ; Marcar como visitado
    mov     byte    [r14 + r13],    1       ; visitados[indice_actual] = true

    ; Obtener páginas del libro actual
    ; &libros[indice_actual] = libros + indice_actual * LIBRO_SIZE
    mov     r8,     [r12 + BIBLIO_LIBROS_OFFSET]    ; r8 = libros
    movsxd  rax,    r13d                    ; rax = indice_actual (extender a 64 bits)
    imul    rax,    LIBRO_SIZE              ; rax = indice_actual * LIBRO_SIZE
    lea     r9,     [r8 + rax]              ; r9 = &libros[indice_actual]
    mov     r15d,   [r9 + LIBRO_PAGINAS_OFFSET]     ; r15d = paginas_actuales

    ; Llamada recursiva: contarPaginasTotales(biblioteca, indice_actual + 1, visitados)
    mov     rdi,    r12                     ; primer parámetro: biblioteca
    mov     esi,    r13d
    inc     esi                             ; segundo parámetro: indice_actual + 1
    mov     rdx,    r14                     ; tercer parámetro: visitados

    ; Stack alignment:
    ; Al entrar: CALL empuja 8 bytes
    ; push rbp: +8 = 16 (alineado)
    ; push r12, r13, r14, r15: +32 = 48 (alineado a 16)
    call    contarPaginasTotales

    ; rax contiene el resultado de la llamada recursiva (paginas_siguientes)
    ; Sumar las páginas actuales
    add     eax,    r15d                    ; return paginas_actuales + paginas_siguientes
    jmp     .epilogo

.ya_visitado:
    ; Si ya fue visitado, solo hacer la llamada recursiva sin sumar páginas
    mov     rdi,    r12                     ; primer parámetro: biblioteca
    mov     esi,    r13d
    inc     esi                             ; segundo parámetro: indice_actual + 1
    mov     rdx,    r14                     ; tercer parámetro: visitados

    call    contarPaginasTotales
    ; rax ya tiene el valor de retorno
    jmp     .epilogo

.return_zero:
    xor     eax,    eax
    jmp     .epilogo

.epilogo:
    pop     r15
    pop     r14
    pop     r13
    pop     r12

    pop     rbp
    ret
