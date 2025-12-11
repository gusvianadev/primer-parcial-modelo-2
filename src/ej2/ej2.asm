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
; ListaIndices *ordenarPorRating(const Biblioteca *biblioteca, const ListaIndices *entrada)
; Parámetros:
;   rdi: const Biblioteca *biblioteca
;   rsi: const ListaIndices *entrada
;
; Valor de retorno:
;   rax: ListaIndices* (o NULL si entrada->cantidad == 0)

extern malloc
extern free

global ordenarPorRating
ordenarPorRating:
.prologo:
    push    rbp
    mov     rbp, rsp

    push    r12
    push    r13
    push    r14
    push    r15
    push    rbx

.cuerpo:
    ; Guardar parámetros
    mov     r12,    rdi                     ; r12 = biblioteca
    mov     r13,    rsi                     ; r13 = entrada

    ; Verificar si entrada->cantidad == 0
    mov     rax,    [r13 + LISTA_CANTIDAD_OFFSET]
    test    rax,    rax
    jz      .return_null

    ; Guardar cantidad en r14
    mov     r14,    rax                     ; r14 = entrada->cantidad

    ; Llamar a malloc(sizeof(ListaIndices)) = malloc(16)
    mov     rdi,    LISTA_SIZE
    sub     rsp,    8                       ; Alinear stack
    call    malloc
    add     rsp,    8

    test    rax,    rax
    jz      .return_null                    ; Si malloc falla, retornar NULL

    mov     r15,    rax                     ; r15 = resultado (estructura ListaIndices)

    ; Llamar a malloc(sizeof(uint32_t) * cantidad)
    mov     rax,    r14
    shl     rax,    2                       ; rax = cantidad * 4
    mov     rdi,    rax
    sub     rsp,    8
    call    malloc
    add     rsp,    8

    test    rax,    rax
    jz      .cleanup_resultado              ; Si falla, liberar resultado

    ; Guardar el puntero al array de índices
    mov     [r15 + LISTA_INDICES_OFFSET],   rax     ; resultado->indices = malloc(...)
    mov     [r15 + LISTA_CANTIDAD_OFFSET],  r14     ; resultado->cantidad = entrada->cantidad

    ; Copiar los índices de entrada a resultado
    ; for (uint64_t i = 0; i < entrada->cantidad; i++)
    mov     rbx,    0                       ; rbx = i
    mov     r8,     [r13 + LISTA_INDICES_OFFSET]    ; r8 = entrada->indices
    mov     r9,     [r15 + LISTA_INDICES_OFFSET]    ; r9 = resultado->indices

.copy_loop:
    cmp     rbx,    r14
    jge     .copy_loop_end

    mov     eax,    [r8 + rbx*4]            ; eax = entrada->indices[i]
    mov     [r9 + rbx*4],   eax             ; resultado->indices[i] = eax

    inc     rbx
    jmp     .copy_loop

.copy_loop_end:
    ; Implementar bubble sort
    ; for (uint64_t i = 0; i < resultado->cantidad - 1; i++)
    mov     rbx,    0                       ; rbx = i (outer loop)

.outer_loop:
    mov     rax,    r14
    dec     rax                             ; rax = cantidad - 1
    cmp     rbx,    rax
    jge     .outer_loop_end

    ; for (uint64_t j = 0; j < resultado->cantidad - 1 - i; j++)
    xor     r10,    r10                     ; r10 = j (inner loop)

.inner_loop:
    mov     rax,    r14
    dec     rax
    sub     rax,    rbx                     ; rax = cantidad - 1 - i
    cmp     r10,    rax
    jge     .inner_loop_end

    ; Obtener índices
    mov     r9,     [r15 + LISTA_INDICES_OFFSET]    ; r9 = resultado->indices
    mov     eax,    [r9 + r10*4]            ; eax = indices[j] = idx1
    mov     edx,    [r9 + r10*4 + 4]        ; edx = indices[j+1] = idx2

    ; Obtener ratings
    ; rating1 = biblioteca->libros[idx1].rating
    mov     r8,     [r12 + BIBLIO_LIBROS_OFFSET]    ; r8 = biblioteca->libros
    movsxd  rcx,    eax                     ; rcx = idx1 (extender con signo a 64 bits)
    imul    rcx,    LIBRO_SIZE              ; rcx = idx1 * LIBRO_SIZE
    lea     r11,    [r8 + rcx]              ; r11 = &libros[idx1]
    movss   xmm0,   dword [r11 + LIBRO_RATING_OFFSET]     ; xmm0 = rating1

    ; rating2 = biblioteca->libros[idx2].rating
    movsxd  rcx,    edx                     ; rcx = idx2
    imul    rcx,    LIBRO_SIZE
    lea     r11,    [r8 + rcx]              ; r11 = &libros[idx2]
    movss   xmm1,   dword [r11 + LIBRO_RATING_OFFSET]     ; xmm1 = rating2

    ; Comparar: si rating1 < rating2, intercambiar
    comiss  xmm0,   xmm1                    ; Comparar xmm0 con xmm1
    jae     .no_swap                        ; Si rating1 >= rating2, no intercambiar

    ; Intercambiar indices[j] y indices[j+1]
    mov     [r9 + r10*4],       edx         ; indices[j] = idx2
    mov     [r9 + r10*4 + 4],   eax         ; indices[j+1] = idx1

.no_swap:
    inc     r10
    jmp     .inner_loop

.inner_loop_end:
    inc     rbx
    jmp     .outer_loop

.outer_loop_end:
    ; Retornar resultado
    mov     rax,    r15
    jmp     .epilogo

.return_null:
    xor     rax,    rax
    jmp     .epilogo

.cleanup_resultado:
    ; Liberar resultado si falla malloc de indices
    mov     rdi,    r15
    sub     rsp,    8
    call    free
    add     rsp,    8
    xor     rax,    rax
    jmp     .epilogo

.epilogo:
    pop     rbx
    pop     r15
    pop     r14
    pop     r13
    pop     r12

    pop     rbp
    ret
