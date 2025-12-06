/* Tests del Ejercicio 3: contarPaginasTotales */

#include <stdio.h>
#include <stdlib.h>
#include <stdint.h>
#include <stdbool.h>
#include <string.h>

#include "../ejs.h"
#include "../utils.h"

/* Test 1: Contar páginas en biblioteca ejemplo */
TEST(test_ej3_contar_simple) {
    Biblioteca bib = crearBibliotecaEjemplo();
    bool *visitados = calloc(bib.cantidad_libros, sizeof(bool));
    TEST_ASSERT(visitados != NULL);
    
    uint32_t total = TEST_CALL_I(contarPaginasTotales, &bib, 0u, visitados);
    
    // Total: 328 + 443 + 96 = 867
    TEST_ASSERT(total == 867u);
    
    free(visitados);
    liberarBiblioteca(&bib);
}

/* Test 2: Biblioteca vacía */
TEST(test_ej3_biblioteca_vacia) {
    Biblioteca bib = crearBibliotecaVacia();
    bool *visitados = NULL;
    
    uint32_t total = TEST_CALL_I(contarPaginasTotales, &bib, 0u, visitados);
    
    TEST_ASSERT(total == 0u);
    
    liberarBiblioteca(&bib);
}

/* Test 3: Contar páginas en biblioteca múltiple */
TEST(test_ej3_contar_multiple) {
    Biblioteca bib = crearBibliotecaMultiple();
    bool *visitados = calloc(bib.cantidad_libros, sizeof(bool));
    TEST_ASSERT(visitados != NULL);
    
    uint32_t total = TEST_CALL_I(contarPaginasTotales, &bib, 0u, visitados);
    
    // Total: 417 + 365 + 273 + 256 + 863 = 2174
    TEST_ASSERT(total == 2174u);
    
    free(visitados);
    liberarBiblioteca(&bib);
}

/* Test 4: Índice fuera de rango */
TEST(test_ej3_indice_invalido) {
    Biblioteca bib = crearBibliotecaEjemplo();
    bool *visitados = calloc(bib.cantidad_libros, sizeof(bool));
    TEST_ASSERT(visitados != NULL);
    
    uint32_t total = TEST_CALL_I(contarPaginasTotales, &bib, 99u, visitados);
    
    TEST_ASSERT(total == 0u);
    
    free(visitados);
    liberarBiblioteca(&bib);
}

int main(int argc, char *argv[]) {
    (void)argc; (void)argv;
    printf("Corriendo los tests del ejercicio 3...\n");
    
    test_ej3_contar_simple();
    test_ej3_biblioteca_vacia();
    test_ej3_contar_multiple();
    test_ej3_indice_invalido();
    
    tests_end("Ejercicio 3");
    return 0;
}
