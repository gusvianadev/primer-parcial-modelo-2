#include "utils.h"
#include "ejs.h"

// Funciones auxiliares para crear datos de prueba

Biblioteca crearBibliotecaEjemplo(void) {
    Biblioteca bib;
    bib.cantidad_libros = 3;
    bib.libros = malloc(sizeof(Libro) * bib.cantidad_libros);
    if (!bib.libros) {
        perror("malloc");
        exit(EXIT_FAILURE);
    }
    snprintf(bib.nombre, sizeof(bib.nombre), "Biblioteca Central");
    
    bib.libros[0] = crearLibro("1984", "George Orwell", 1949, CATEGORIA_FICCION, 328, true, 4.5f);
    bib.libros[1] = crearLibro("Sapiens", "Yuval Harari", 2011, CATEGORIA_HISTORIA, 443, false, 4.8f);
    bib.libros[2] = crearLibro("El Principito", "Antoine de Saint-Exupéry", 1943, CATEGORIA_FICCION, 96, true, 4.7f);
    
    return bib;
}

Biblioteca crearBibliotecaVacia(void) {
    Biblioteca bib;
    bib.cantidad_libros = 0;
    bib.libros = NULL;
    snprintf(bib.nombre, sizeof(bib.nombre), "Biblioteca Vacía");
    return bib;
}

Biblioteca crearBibliotecaMultiple(void) {
    Biblioteca bib;
    bib.cantidad_libros = 5;
    bib.libros = malloc(sizeof(Libro) * bib.cantidad_libros);
    if (!bib.libros) {
        perror("malloc");
        exit(EXIT_FAILURE);
    }
    snprintf(bib.nombre, sizeof(bib.nombre), "Biblioteca Municipal");
    
    bib.libros[0] = crearLibro("Cien años de soledad", "Gabriel García Márquez", 1967, CATEGORIA_FICCION, 417, true, 4.9f);
    bib.libros[1] = crearLibro("Cosmos", "Carl Sagan", 1980, CATEGORIA_CIENCIA, 365, true, 4.6f);
    bib.libros[2] = crearLibro("El arte de la guerra", "Sun Tzu", -500, CATEGORIA_HISTORIA, 273, false, 4.3f);
    bib.libros[3] = crearLibro("Brief History of Time", "Stephen Hawking", 1988, CATEGORIA_CIENCIA, 256, true, 4.5f);
    bib.libros[4] = crearLibro("Don Quijote", "Miguel de Cervantes", 1605, CATEGORIA_FICCION, 863, true, 4.2f);
    
    return bib;
}

void liberarBiblioteca(Biblioteca *bib) {
    if (bib->libros) {
        free(bib->libros);
        bib->libros = NULL;
    }
    bib->cantidad_libros = 0;
}

Libro crearLibro(const char *titulo, const char *autor, uint32_t anio, Categoria cat, uint32_t paginas, bool disponible, float rating) {
    Libro libro;
    snprintf(libro.titulo, sizeof(libro.titulo), "%s", titulo);
    snprintf(libro.autor, sizeof(libro.autor), "%s", autor);
    libro.anio = anio;
    libro.categoria = cat;
    libro.paginas = paginas;
    libro.disponible = disponible;
    libro.rating = rating;
    return libro;
}
