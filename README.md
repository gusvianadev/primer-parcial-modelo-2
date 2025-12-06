# Segundo Parcial Modelo - Organización del Computador II

## Tema: Sistema de Gestión de Biblioteca Digital

Este parcial modelo consiste en implementar funciones para un sistema de gestión de biblioteca digital que permite buscar, ordenar y analizar información sobre libros.

## Estructuras de Datos

### Libro
```c
typedef struct {
    char* titulo;
    char* autor;
    uint32_t anio;
    Categoria categoria;
    uint32_t paginas;
    uint8_t disponible;
    float rating;
} Libro;
```

### Biblioteca
```c
typedef struct {
    Libro** libros;
    uint32_t cantidad;
} Biblioteca;
```

### Categorias
```c
typedef enum {
    FICCION,
    NO_FICCION,
    CIENCIA,
    HISTORIA,
    ARTE
} Categoria;
```

### ListaIndices
```c
typedef struct {
    uint32_t* indices;
    uint32_t cantidad;
} ListaIndices;
```

## Ejercicios

### Ejercicio 1: buscarLibrosDisponibles

**Prototipo:**
```c
ListaIndices* buscarLibrosDisponibles(Biblioteca* biblioteca, Categoria categoria);
```

**Descripción:**
Implementar una función que busque todos los libros disponibles de una categoría específica en la biblioteca y retorne una lista con los índices de estos libros.

**Parámetros:**
- `biblioteca`: Puntero a la estructura Biblioteca que contiene el array de libros
- `categoria`: Categoría de libros a buscar (FICCION, NO_FICCION, CIENCIA, HISTORIA, ARTE)

**Retorno:**
- Puntero a una estructura `ListaIndices` que contiene:
  - `indices`: Array dinámico con los índices de los libros que cumplen los criterios
  - `cantidad`: Número de libros encontrados

**Condiciones:**
- Un libro es considerado disponible si su campo `disponible` es `1`
- Los índices deben aparecer en el mismo orden en que aparecen los libros en la biblioteca
- Si no se encuentran libros, retornar una lista con `cantidad = 0` e `indices = NULL`
- La memoria para la estructura ListaIndices y el array de índices debe ser reservada dinámicamente

**Ejemplo:**
```
Biblioteca con 5 libros:
[0] "1984" - FICCION - disponible: 1
[1] "Sapiens" - HISTORIA - disponible: 1
[2] "Dune" - FICCION - disponible: 0
[3] "Foundation" - FICCION - disponible: 1
[4] "Cosmos" - CIENCIA - disponible: 1

buscarLibrosDisponibles(biblioteca, FICCION) -> {indices: [0, 3], cantidad: 2}
```

---

### Ejercicio 2: ordenarPorRating

**Prototipo:**
```c
void ordenarPorRating(Biblioteca* biblioteca, ListaIndices* lista);
```

**Descripción:**
Implementar una función que ordene una lista de índices de libros según su rating (calificación) de mayor a menor. La función debe modificar el array de índices in-place.

**Parámetros:**
- `biblioteca`: Puntero a la estructura Biblioteca que contiene los libros
- `lista`: Puntero a la estructura ListaIndices con los índices a ordenar

**Comportamiento:**
- Ordenar los índices en el array `lista->indices` según el rating de los libros correspondientes
- El ordenamiento debe ser **descendente** (mayor rating primero)
- Si dos libros tienen el mismo rating, mantener el orden original relativo (stable sort)
- Modificar el array `lista->indices` directamente (ordenamiento in-place)

**Consideraciones:**
- Se puede usar cualquier algoritmo de ordenamiento
- El rating es un valor `float` entre 0.0 y 5.0
- La lista puede estar vacía (`cantidad = 0`)

**Ejemplo:**
```
Biblioteca:
[0] "1984" - rating: 4.8
[1] "Sapiens" - rating: 4.5
[2] "Foundation" - rating: 4.9
[3] "Cosmos" - rating: 4.7

Lista entrada: {indices: [0, 1, 2, 3], cantidad: 4}
Lista salida: {indices: [2, 0, 3, 1], cantidad: 4}
(Foundation: 4.9, 1984: 4.8, Cosmos: 4.7, Sapiens: 4.5)
```

---

### Ejercicio 3: contarPaginasTotales

**Prototipo:**
```c
uint32_t contarPaginasTotales(Biblioteca* biblioteca, ListaIndices* lista, 
                               uint32_t indiceActual, uint8_t* visitados);
```

**Descripción:**
Implementar una función **recursiva** que cuente el número total de páginas de los libros en una lista, comenzando desde un índice específico y evitando contar libros duplicados.

**Parámetros:**
- `biblioteca`: Puntero a la estructura Biblioteca
- `lista`: Puntero a ListaIndices con los índices de libros a procesar
- `indiceActual`: Índice actual en el array `lista->indices` (comienza en 0)
- `visitados`: Array de bytes que marca qué libros ya fueron contados (1 = visitado, 0 = no visitado)

**Retorno:**
- Número total de páginas de todos los libros en la lista (sin duplicados)

**Comportamiento:**
- La función debe ser **recursiva**
- Caso base: cuando `indiceActual >= lista->cantidad`, retornar 0
- Para cada libro:
  - Si el libro ya fue visitado (usando el array `visitados`), no contar sus páginas
  - Si no fue visitado, marcarlo como visitado y sumar sus páginas
  - Continuar recursivamente con el siguiente índice

**Consideraciones:**
- El array `visitados` tiene tamaño `biblioteca->cantidad`
- El array `visitados` es inicializado en 0 antes de la primera llamada
- Un libro puede aparecer múltiples veces en la lista, pero solo debe contarse una vez
- La recursión debe procesar la lista secuencialmente (indiceActual + 1)

**Ejemplo:**
```
Biblioteca:
[0] "1984" - 328 páginas
[1] "Sapiens" - 443 páginas
[2] "Foundation" - 255 páginas

Lista: {indices: [0, 1, 2, 0, 1], cantidad: 5}
Visitados inicial: [0, 0, 0]

Resultado: 1026 páginas (328 + 443 + 255)
- El libro [0] aparece dos veces pero solo se cuenta una vez
- El libro [1] aparece dos veces pero solo se cuenta una vez
```

---

## Compilación y Testing

### Activar el entorno de desarrollo
```bash
direnv allow
```

### Compilar un ejercicio específico
```bash
cd ej1  # o ej2, ej3
make
```

### Ejecutar tests
```bash
make test
```

### Ejecutar tests con valgrind
```bash
make valgrind
```

### Script de testing automático
```bash
./tester.sh
```

Este script compila y testea todos los ejercicios automáticamente.

## Criterios de Evaluación

- **Correctitud**: Las funciones deben pasar todos los tests
- **Gestión de memoria**: No debe haber memory leaks (verificar con valgrind)
- **Convención de llamada**: Se debe respetar la ABI de System V AMD64
- **Implementación**: Se debe implementar tanto la versión en C como en ASM
- **Ejercicio 3**: Debe ser implementado de forma recursiva

## Notas Importantes

1. La estructura `ListaIndices` retornada por `buscarLibrosDisponibles` debe ser liberada por el llamador
2. El array `visitados` en `contarPaginasTotales` es manejado por el llamador
3. Todos los índices en `ListaIndices` son índices válidos en el array `biblioteca->libros`
4. Los strings (`titulo`, `autor`) son punteros a memoria dinámica gestionada por las funciones de utilidad

## Recursos

- Archivos de cabecera: `src/ejs.h`, `src/utils.h`
- Funciones de utilidad en: `src/utils.c`
- Tests en: `ej*/test.c`

¡Buena suerte! 🚀
