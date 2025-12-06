; Implementación en ASM del ejercicio 3
global contarPaginasTotales

section .data
    ; TODO: Definir offsets y tamaños de estructuras
    LIBRO_TITULO_OFFSET equ 0
    LIBRO_AUTOR_OFFSET equ 0
    LIBRO_ANIO_OFFSET equ 0
    LIBRO_CATEGORIA_OFFSET equ 0
    LIBRO_PAGINAS_OFFSET equ 0
    LIBRO_DISPONIBLE_OFFSET equ 0
    LIBRO_RATING_OFFSET equ 0
    LIBRO_SIZE equ 0

    BIBLIO_LIBROS_OFFSET equ 0
    BIBLIO_CANTIDAD_LIBROS_OFFSET equ 0
    BIBLIO_NOMBRE_OFFSET equ 0
    BIBLIO_SIZE equ 0

    LISTA_INDICES_OFFSET equ 0
    LISTA_CANTIDAD_OFFSET equ 0
    LISTA_SIZE equ 0

section .text

contarPaginasTotales:
    ; TODO: Implementar
    xor rax, rax
    ret

