/* Tests del Ejercicio 2: ordenarPorRating */

#include <stdio.h>
#include <stdlib.h>
#include <stdint.h>
#include <stdbool.h>
#include <string.h>

#include "../ejs.h"
#include "../utils.h"

/* Test 1: Ordenar lista simple */
TEST(test_ej2_ordenar_simple) {
    Biblioteca bib = crearBibliotecaEjemplo();
    uint32_t indices_arr[] = {0, 1, 2};
    ListaIndices entrada = {indices_arr, 3};
    
    ListaIndices *resultado = TEST_CALL_S(ordenarPorRating, &bib, &entrada);
    
    TEST_ASSERT(resultado != NULL);
    TEST_ASSERT(resultado->cantidad == 3);
    // Orden esperado: Sapiens (4.8), El Principito (4.7), 1984 (4.5)
    TEST_ASSERT(resultado->indices[0] == 1);
    TEST_ASSERT(resultado->indices[1] == 2);
    TEST_ASSERT(resultado->indices[2] == 0);
    
    free(resultado->indices);
    free(resultado);
    liberarBiblioteca(&bib);
}

/* Test 2: Lista vacía */
TEST(test_ej2_lista_vacia) {
    Biblioteca bib = crearBibliotecaEjemplo();
    ListaIndices entrada = {NULL, 0};
    
    ListaIndices *resultado = TEST_CALL_S(ordenarPorRating, &bib, &entrada);
    
    TEST_ASSERT(resultado == NULL);
    
    liberarBiblioteca(&bib);
}

/* Test 3: Ordenar biblioteca múltiple */
TEST(test_ej2_ordenar_multiple) {
    Biblioteca bib = crearBibliotecaMultiple();
    uint32_t indices_arr[] = {0, 1, 2, 3, 4};
    ListaIndices entrada = {indices_arr, 5};
    
    ListaIndices *resultado = TEST_CALL_S(ordenarPorRating, &bib, &entrada);
    
    TEST_ASSERT(resultado != NULL);
    TEST_ASSERT(resultado->cantidad == 5);
    // Primer elemento debe ser el de mayor rating (Cien años: 4.9)
    TEST_ASSERT(resultado->indices[0] == 0);
    
    free(resultado->indices);
    free(resultado);
    liberarBiblioteca(&bib);
}

int main(int argc, char *argv[]) {
    (void)argc; (void)argv;
    printf("Corriendo los tests del ejercicio 2...\n");
    
    test_ej2_ordenar_simple();
    test_ej2_lista_vacia();
    test_ej2_ordenar_multiple();
    
    tests_end("Ejercicio 2");
    return 0;
}
