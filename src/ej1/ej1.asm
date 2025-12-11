section .data
    count:      dq  0       ; uint64_t count
    idx:        dq  0       ; uint64_t idx para segundo loop

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
; Constantes útiles
; ------------------------
FALSE       EQU     0
TRUE        EQU     1

; ------------------------
; Signatura de la función
; ------------------------
; uint64_t buscarLibrosDisponibles(Biblioteca *biblioteca, Categoria categoria, ListaIndices *resultado)
; Parámetros:
;   rdi: Biblioteca *biblioteca
;   rsi: Categoria categoria (uint32_t, pero pasado en 64 bits)
;   rdx: ListaIndices *resultado
;
; Valor de retorno:
;   rax: uint64_t count

extern malloc

global buscarLibrosDisponibles
buscarLibrosDisponibles:
.prologo:
    push    rbp
    mov     rbp, rsp

    push    r12
    push    r13
    push    r14
    push    r15

.reinicializaciones:
    mov     qword   [count],    0
    mov     qword   [idx],      0

.cuerpo:
    ; Guardar parámetros en registros no volátiles
    mov     r12,    rdi                     ; r12 = biblioteca
    mov     r13,    rsi                     ; r13 = categoria
    mov     r14,    rdx                     ; r14 = resultado

    ; Primer loop: contar cuántos libros cumplen
    ; for (uint64_t i = 0; i < biblioteca->cantidad_libros; i++)
    mov     r15,    0                       ; r15 = i
    mov     r8,     [r12 + BIBLIO_CANTIDAD_LIBROS_OFFSET]  ; r8 = cantidad_libros
    mov     r9,     [r12 + BIBLIO_LIBROS_OFFSET]           ; r9 = libros (puntero base)

.primer_loop:
    cmp     r15,    r8                      ; i < cantidad_libros?
    jge     .primer_loop_end

    ; Calcular dirección del libro actual: libros + i * LIBRO_SIZE
    mov     rax,    r15
    imul    rax,    LIBRO_SIZE              ; rax = i * LIBRO_SIZE
    lea     r10,    [r9 + rax]              ; r10 = &libros[i]

    ; Verificar categoria: libros[i].categoria == categoria?
    mov     eax,    [r10 + LIBRO_CATEGORIA_OFFSET]
    cmp     eax,    r13d                    ; categoria es uint32_t
    jne     .primer_loop_continue

    ; Verificar disponible: libros[i].disponible == true?
    movzx   eax,    byte [r10 + LIBRO_DISPONIBLE_OFFSET]
    test    al,     al
    jz      .primer_loop_continue

    ; Si llegamos aquí, el libro cumple ambas condiciones
    inc     qword   [count]

.primer_loop_continue:
    inc     r15
    jmp     .primer_loop

.primer_loop_end:
    ; Verificar si count == 0
    mov     rax,    [count]
    test    rax,    rax
    jz      .count_is_zero

    ; Llamar a malloc(sizeof(uint32_t) * count)
    ; sizeof(uint32_t) = 4 bytes
    mov     rax,    [count]
    shl     rax,    2                       ; rax = count * 4
    mov     rdi,    rax                     ; primer parámetro para malloc
    
    ; Stack alignment:
    ; Al entrar a la función: CALL empuja 8 bytes (dirección de retorno)
    ; push rbp: +8 = 16 (alineado)
    ; push r12, r13, r14, r15: +32 = 48 (alineado a 16)
    ; El stack ya está alineado correctamente para CALL
    call    malloc

    ; Verificar si malloc falló (en un parcial real podríamos omitir esto)
    test    rax,    rax
    jz      .malloc_failed

    ; Guardar el puntero retornado por malloc
    mov     [r14 + LISTA_INDICES_OFFSET],   rax     ; resultado->indices = malloc(...)

    ; Segundo loop: llenar el array con los índices
    mov     r15,    0                       ; r15 = i (índice en biblioteca)
    mov     qword   [idx],  0               ; idx = 0 (índice en resultado)
    mov     r8,     [r12 + BIBLIO_CANTIDAD_LIBROS_OFFSET]  ; r8 = cantidad_libros
    mov     r9,     [r12 + BIBLIO_LIBROS_OFFSET]           ; r9 = libros (puntero base)
    mov     r11,    [r14 + LISTA_INDICES_OFFSET]           ; r11 = resultado->indices

.segundo_loop:
    cmp     r15,    r8                      ; i < cantidad_libros?
    jge     .segundo_loop_end

    ; Calcular dirección del libro actual: libros + i * LIBRO_SIZE
    mov     rax,    r15
    imul    rax,    LIBRO_SIZE
    lea     r10,    [r9 + rax]              ; r10 = &libros[i]

    ; Verificar categoria
    mov     eax,    [r10 + LIBRO_CATEGORIA_OFFSET]
    cmp     eax,    r13d
    jne     .segundo_loop_continue

    ; Verificar disponible
    movzx   eax,    byte [r10 + LIBRO_DISPONIBLE_OFFSET]
    test    al,     al
    jz      .segundo_loop_continue

    ; Si cumple, guardar índice: resultado->indices[idx++] = i
    mov     rax,    [idx]
    mov     dword   [r11 + rax*4],  r15d    ; indices[idx] = i (uint32_t)
    inc     qword   [idx]

.segundo_loop_continue:
    inc     r15
    jmp     .segundo_loop

.segundo_loop_end:
    ; resultado->cantidad = count
    mov     rax,    [count]
    mov     [r14 + LISTA_CANTIDAD_OFFSET],  rax

    ; Retornar count
    mov     rax,    [count]
    jmp     .epilogo

.count_is_zero:
    ; resultado->indices = NULL
    mov     qword   [r14 + LISTA_INDICES_OFFSET],   0
    ; resultado->cantidad = 0
    mov     qword   [r14 + LISTA_CANTIDAD_OFFSET],  0
    ; return 0
    xor     rax,    rax
    jmp     .epilogo

.malloc_failed:
    ; En caso de fallo de malloc (no debería pasar en tests)
    xor     rax,    rax
    jmp     .epilogo

.epilogo:
    pop     r15
    pop     r14
    pop     r13
    pop     r12

    pop     rbp
    ret
