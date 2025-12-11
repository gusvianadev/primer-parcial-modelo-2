// Implementación en C del ejercicio 3
#include "../ejs.h"

uint32_t contarPaginasTotales(Biblioteca *biblioteca, uint32_t indice_actual, bool *visitados) {
    // Caso base: índice fuera de rango
    if (indice_actual >= biblioteca->cantidad_libros) { return 0; }

    // Si el libro ya fue visitado, no contar sus páginas
    if (visitados[indice_actual]) {
        // Continuar con el siguiente libro
        return contarPaginasTotales(biblioteca, indice_actual + 1, visitados);
    }

    // Marcar como visitado
    visitados[indice_actual] = true;

    // Obtener páginas del libro actual
    uint32_t paginas_actuales = biblioteca->libros[indice_actual].paginas;

    // Llamada recursiva para el siguiente libro y sumar páginas
    uint32_t paginas_siguientes = contarPaginasTotales(biblioteca, indice_actual + 1, visitados);

    return paginas_actuales + paginas_siguientes;
}
