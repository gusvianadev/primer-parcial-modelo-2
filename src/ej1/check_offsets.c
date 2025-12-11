#include "../ejs.h"
#include <stdio.h>
#include <stddef.h>

int main() {
    printf("=== LIBRO ===\n");
    printf("LIBRO_TITULO_OFFSET: %zu\n", offsetof(Libro, titulo));
    printf("LIBRO_AUTOR_OFFSET: %zu\n", offsetof(Libro, autor));
    printf("LIBRO_ANIO_OFFSET: %zu\n", offsetof(Libro, anio));
    printf("LIBRO_CATEGORIA_OFFSET: %zu\n", offsetof(Libro, categoria));
    printf("LIBRO_PAGINAS_OFFSET: %zu\n", offsetof(Libro, paginas));
    printf("LIBRO_DISPONIBLE_OFFSET: %zu\n", offsetof(Libro, disponible));
    printf("LIBRO_RATING_OFFSET: %zu\n", offsetof(Libro, rating));
    printf("LIBRO_SIZE: %zu\n", sizeof(Libro));
    
    printf("\n=== BIBLIOTECA ===\n");
    printf("BIBLIO_LIBROS_OFFSET: %zu\n", offsetof(Biblioteca, libros));
    printf("BIBLIO_CANTIDAD_LIBROS_OFFSET: %zu\n", offsetof(Biblioteca, cantidad_libros));
    printf("BIBLIO_NOMBRE_OFFSET: %zu\n", offsetof(Biblioteca, nombre));
    printf("BIBLIO_SIZE: %zu\n", sizeof(Biblioteca));
    
    printf("\n=== LISTA_INDICES ===\n");
    printf("LISTA_INDICES_OFFSET: %zu\n", offsetof(ListaIndices, indices));
    printf("LISTA_CANTIDAD_OFFSET: %zu\n", offsetof(ListaIndices, cantidad));
    printf("LISTA_SIZE: %zu\n", sizeof(ListaIndices));
    
    return 0;
}
