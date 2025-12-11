// Implementación en C del ejercicio 1
#include "../ejs.h"
#include <stdlib.h>

uint64_t buscarLibrosDisponibles(Biblioteca *biblioteca, Categoria categoria, ListaIndices *resultado) {
    // Primero contamos cuántos libros cumplen con los criterios
    uint64_t count = 0;
    for (uint64_t i = 0; i < biblioteca->cantidad_libros; i++) {
        if (biblioteca->libros[i].categoria == categoria && biblioteca->libros[i].disponible) { count++; }
    }

    // Si no hay libros que cumplan, inicializamos resultado y retornamos 0
    if (count == 0) {
        resultado->indices = NULL;
        resultado->cantidad = 0;
        return 0;
    }

    // Asignamos memoria para los índices
    resultado->indices = malloc(sizeof(uint32_t) * count);
    if (!resultado->indices) {
        perror("malloc");
        exit(EXIT_FAILURE);
    }

    // Llenamos el array con los índices de los libros que cumplen
    uint64_t idx = 0;
    for (uint64_t i = 0; i < biblioteca->cantidad_libros; i++) {
        if (biblioteca->libros[i].categoria == categoria && biblioteca->libros[i].disponible) {
            resultado->indices[idx++] = (uint32_t)i;
        }
    }

    resultado->cantidad = count;
    return count;
}
