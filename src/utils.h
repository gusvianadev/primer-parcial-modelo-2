#ifndef TEST_H
#define TEST_H

#include "../test_utils/test-utils.h"
#include "./ejs.h"

//*************************************
// Declaraciones de funciones auxiliares
//*************************************

Biblioteca crearBibliotecaEjemplo(void);
Biblioteca crearBibliotecaVacia(void);
Biblioteca crearBibliotecaMultiple(void);
void liberarBiblioteca(Biblioteca *biblioteca);
Libro crearLibro(const char *titulo, const char *autor, uint32_t anio, Categoria cat, uint32_t paginas, bool disponible, float rating);

#endif
