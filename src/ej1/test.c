/* Tests del Ejercicio 1: buscarLibrosDisponibles */

#include <stdio.h>
#include <stdlib.h>
#include <stdint.h>
#include <stdbool.h>
#include <string.h>

#include "../ejs.h"
#include "../utils.h"

/* Test 1: Buscar libros disponibles de FICCION en biblioteca ejemplo */
TEST(test_ej1_buscar_ficcion_disponibles) {
    Biblioteca bib = crearBibliotecaEjemplo();
    ListaIndices resultado = {NULL, 0};
    
    uint64_t count = TEST_CALL_I(buscarLibrosDisponibles, &bib, CATEGORIA_FICCION, &resultado);
    
    TEST_ASSERT(count == 2); // 1984 y El Principito están disponibles
    TEST_ASSERT(resultado.cantidad == 2);
    TEST_ASSERT(resultado.indices != NULL);
    TEST_ASSERT(resultado.indices[0] == 0);
    TEST_ASSERT(resultado.indices[1] == 2);
    
    free(resultado.indices);
    liberarBiblioteca(&bib);
}

/* Test 2: Buscar en categoría sin libros disponibles */
TEST(test_ej1_categoria_sin_disponibles) {
    Biblioteca bib = crearBibliotecaEjemplo();
    ListaIndices resultado = {NULL, 0};
    
    uint64_t count = TEST_CALL_I(buscarLibrosDisponibles, &bib, CATEGORIA_HISTORIA, &resultado);
    
    TEST_ASSERT(count == 0); // Sapiens no está disponible
    TEST_ASSERT(resultado.cantidad == 0);
    
    liberarBiblioteca(&bib);
}

/* Test 3: Biblioteca vacía */
TEST(test_ej1_biblioteca_vacia) {
    Biblioteca bib = crearBibliotecaVacia();
    ListaIndices resultado = {NULL, 0};
    
    uint64_t count = TEST_CALL_I(buscarLibrosDisponibles, &bib, CATEGORIA_FICCION, &resultado);
    
    TEST_ASSERT(count == 0);
    TEST_ASSERT(resultado.cantidad == 0);
    
    liberarBiblioteca(&bib);
}

/* Test 4: Búsqueda en biblioteca con múltiples libros */
TEST(test_ej1_biblioteca_multiple) {
    Biblioteca bib = crearBibliotecaMultiple();
    ListaIndices resultado = {NULL, 0};
    
    uint64_t count = TEST_CALL_I(buscarLibrosDisponibles, &bib, CATEGORIA_CIENCIA, &resultado);
    
    TEST_ASSERT(count == 2); // Cosmos y Brief History disponibles
    TEST_ASSERT(resultado.cantidad == 2);
    TEST_ASSERT(resultado.indices != NULL);
    
    free(resultado.indices);
    liberarBiblioteca(&bib);
}

int main(int argc, char *argv[]) {
    (void)argc; (void)argv;
    printf("Corriendo los tests del ejercicio 1...\n");
    
    test_ej1_buscar_ficcion_disponibles();
    test_ej1_categoria_sin_disponibles();
    test_ej1_biblioteca_vacia();
    test_ej1_biblioteca_multiple();
    
    tests_end("Ejercicio 1");
    return 0;
}
