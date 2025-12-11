// Implementación en C del ejercicio 2
#include "../ejs.h"
#include <stdlib.h>

ListaIndices *ordenarPorRating(const Biblioteca *biblioteca, const ListaIndices *entrada) {
    // Si la lista está vacía, retornar NULL
    if (entrada->cantidad == 0) { return NULL; }

    // Crear nueva estructura ListaIndices
    ListaIndices *resultado = malloc(sizeof(ListaIndices));
    if (!resultado) {
        perror("malloc");
        exit(EXIT_FAILURE);
    }

    // Asignar memoria para el array de índices
    resultado->indices = malloc(sizeof(uint32_t) * entrada->cantidad);
    if (!resultado->indices) {
        perror("malloc");
        free(resultado);
        exit(EXIT_FAILURE);
    }

    // Copiar los índices de entrada
    for (uint64_t i = 0; i < entrada->cantidad; i++) { resultado->indices[i] = entrada->indices[i]; }
    resultado->cantidad = entrada->cantidad;

    // Ordenar usando bubble sort (es estable)
    // Orden descendente: mayor rating primero
    for (uint64_t i = 0; i < resultado->cantidad - 1; i++) {
        for (uint64_t j = 0; j < resultado->cantidad - 1 - i; j++) {
            uint32_t idx1 = resultado->indices[j];
            uint32_t idx2 = resultado->indices[j + 1];

            float rating1 = biblioteca->libros[idx1].rating;
            float rating2 = biblioteca->libros[idx2].rating;

            // Si rating1 < rating2, intercambiar (queremos descendente)
            if (rating1 < rating2) {
                resultado->indices[j] = idx2;
                resultado->indices[j + 1] = idx1;
            }
        }
    }

    return resultado;
}
