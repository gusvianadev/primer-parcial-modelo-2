#pragma once
#include <assert.h>
#include <ctype.h>
#include <math.h>
#include <stdbool.h>
#include <stdint.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <unistd.h>

//*************************************
// Declaración de estructuras de la biblioteca
//*************************************

typedef enum {
    CATEGORIA_FICCION = 0,
    CATEGORIA_NO_FICCION,
    CATEGORIA_CIENCIA,
    CATEGORIA_HISTORIA,
    CATEGORIA_CANTIDAD
} Categoria;

typedef struct {
    char titulo[128];       // asmdef_offset:LIBRO_TITULO_OFFSET
    char autor[64];         // asmdef_offset:LIBRO_AUTOR_OFFSET
    uint32_t anio;          // asmdef_offset:LIBRO_ANIO_OFFSET
    Categoria categoria;    // asmdef_offset:LIBRO_CATEGORIA_OFFSET
    uint32_t paginas;       // asmdef_offset:LIBRO_PAGINAS_OFFSET
    bool disponible;        // asmdef_offset:LIBRO_DISPONIBLE_OFFSET
    float rating;           // asmdef_offset:LIBRO_RATING_OFFSET
} Libro;                    // asmdef_size:LIBRO_SIZE

typedef struct {
    Libro *libros;              // asmdef_offset:BIBLIO_LIBROS_OFFSET
    uint64_t cantidad_libros;   // asmdef_offset:BIBLIO_CANTIDAD_LIBROS_OFFSET
    char nombre[64];            // asmdef_offset:BIBLIO_NOMBRE_OFFSET
} Biblioteca;                   // asmdef_size:BIBLIO_SIZE

typedef struct {
    uint32_t *indices;          // asmdef_offset:LISTA_INDICES_OFFSET
    uint64_t cantidad;          // asmdef_offset:LISTA_CANTIDAD_OFFSET
} ListaIndices;                 // asmdef_size:LISTA_SIZE

//*************************************
// Declaración de funciones de los ejercicios
//*************************************

uint64_t buscarLibrosDisponibles(Biblioteca *biblioteca, Categoria categoria, ListaIndices *resultado);

ListaIndices *ordenarPorRating(const Biblioteca *biblioteca, const ListaIndices *entrada);

uint32_t contarPaginasTotales(Biblioteca *biblioteca, uint32_t indice_actual, bool *visitados);
