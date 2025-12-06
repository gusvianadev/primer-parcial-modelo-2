# Segundo Parcial Modelo - Organización del Computador II

## Tema: Sistema de Gestión de Biblioteca Digital

Este parcial modelo consiste en implementar funciones para un sistema de gestión de biblioteca digital que permite buscar, ordenar y analizar información sobre libros.

## Estructuras de Datos

### Libro
```c
typedef struct {
    char titulo[128];
    char autor[64];
    uint32_t anio;
    Categoria categoria;
    uint32_t paginas;
    bool disponible;
    float rating;
} Libro;
```

### Biblioteca
```c
typedef struct {
    Libro *libros;
    uint64_t cantidad_libros;
    char nombre[64];
} Biblioteca;
```

### Categorias
```c
typedef enum {
    CATEGORIA_FICCION = 0,
    CATEGORIA_NO_FICCION,
    CATEGORIA_CIENCIA,
    CATEGORIA_HISTORIA,
    CATEGORIA_CANTIDAD
} Categoria;
```

### ListaIndices
```c
typedef struct {
    uint32_t* indices;
    uint64_t cantidad;
} ListaIndices;
```

## Ejercicios

### Ejercicio 1: buscarLibrosDisponibles

**Prototipo:**
```c
uint64_t buscarLibrosDisponibles(Biblioteca *biblioteca, Categoria categoria, ListaIndices *resultado);
```

**Descripción:**
Implementar una función que busque todos los libros disponibles de una categoría específica en la biblioteca y almacene los índices de estos libros en la estructura `resultado` provista.

**Parámetros:**
- `biblioteca`: Puntero a la estructura Biblioteca que contiene el array de libros
- `categoria`: Categoría de libros a buscar (CATEGORIA_FICCION, CATEGORIA_NO_FICCION, CATEGORIA_CIENCIA, CATEGORIA_HISTORIA)
- `resultado`: Puntero a estructura ListaIndices donde se almacenarán los índices encontrados

**Retorno:**
- Número de libros encontrados (uint64_t)
- La estructura `resultado` es modificada con:
  - `indices`: Array dinámico con los índices de los libros que cumplen los criterios (debe ser reservado con malloc)
  - `cantidad`: Número de libros encontrados

**Condiciones:**
- Un libro es considerado disponible si su campo `disponible` es `true` (valor distinto de 0)
- Los índices deben aparecer en el mismo orden en que aparecen los libros en la biblioteca
- Si no se encuentran libros, `resultado->cantidad = 0` y `resultado->indices` puede ser NULL
- La memoria para el array de índices debe ser reservada dinámicamente con malloc
- El llamador es responsable de liberar la memoria del array `resultado->indices`

**Ejemplo:**
```
Biblioteca con 5 libros:
[0] "1984" - CATEGORIA_FICCION - disponible: true
[1] "Sapiens" - CATEGORIA_HISTORIA - disponible: false
[2] "El Principito" - CATEGORIA_FICCION - disponible: true
[3] "Foundation" - CATEGORIA_FICCION - disponible: false
[4] "Cosmos" - CATEGORIA_CIENCIA - disponible: true

buscarLibrosDisponibles(biblioteca, CATEGORIA_FICCION, &resultado) -> retorna 2
resultado = {indices: [0, 2], cantidad: 2}
```

---

### Ejercicio 2: ordenarPorRating

**Prototipo:**
```c
ListaIndices *ordenarPorRating(const Biblioteca *biblioteca, const ListaIndices *entrada);
```

**Descripción:**
Implementar una función que cree una nueva lista de índices ordenada según el rating (calificación) de los libros de mayor a menor. La función **no modifica** la lista de entrada, sino que crea una copia ordenada.

**Parámetros:**
- `biblioteca`: Puntero a la estructura Biblioteca que contiene los libros
- `entrada`: Puntero a la estructura ListaIndices con los índices a ordenar

**Retorno:**
- Puntero a una nueva estructura `ListaIndices` con los índices ordenados
- Si la lista de entrada está vacía (`cantidad = 0`), retornar `NULL`
- La nueva estructura y su array de índices deben ser reservados con malloc

**Comportamiento:**
- Crear una nueva lista que contenga los mismos índices que `entrada`
- Ordenar los índices según el rating de los libros correspondientes
- El ordenamiento debe ser **descendente** (mayor rating primero)
- Si dos libros tienen el mismo rating, mantener el orden original relativo (stable sort)
- La lista de `entrada` no debe ser modificada
- El llamador es responsable de liberar tanto la estructura retornada como su array de índices

**Consideraciones:**
- Se puede usar cualquier algoritmo de ordenamiento
- El rating es un valor `float` entre 0.0 y 5.0
- La lista puede estar vacía (`cantidad = 0`), en cuyo caso retornar NULL

**Ejemplo:**
```
Biblioteca:
[0] "1984" - rating: 4.5
[1] "Sapiens" - rating: 4.8
[2] "El Principito" - rating: 4.7
[3] "Cosmos" - rating: 4.6

Lista entrada: {indices: [0, 1, 2, 3], cantidad: 4}
Lista retornada: {indices: [1, 2, 3, 0], cantidad: 4}
(Sapiens: 4.8, El Principito: 4.7, Cosmos: 4.6, 1984: 4.5)
```

---

### Ejercicio 3: contarPaginasTotales

**Prototipo:**
```c
uint32_t contarPaginasTotales(Biblioteca *biblioteca, uint32_t indice_actual, bool *visitados);
```

**Descripción:**
Implementar una función **recursiva** que cuente el número total de páginas de todos los libros en la biblioteca, comenzando desde un índice específico y evitando contar libros duplicados mediante el array de visitados.

**Parámetros:**
- `biblioteca`: Puntero a la estructura Biblioteca
- `indice_actual`: Índice del libro actual a procesar (comienza en 0 para contar todos los libros)
- `visitados`: Array de booleanos que marca qué libros ya fueron contados (true = visitado, false = no visitado)

**Retorno:**
- Número total de páginas de todos los libros desde `indice_actual` hasta el final (sin duplicados)

**Comportamiento:**
- La función debe ser **recursiva**
- Caso base: cuando `indice_actual >= biblioteca->cantidad_libros`, retornar 0
- Para cada libro en el índice actual:
  - Si el libro ya fue visitado (`visitados[indice_actual] == true`), no contar sus páginas
  - Si no fue visitado, marcarlo como visitado (`visitados[indice_actual] = true`) y sumar sus páginas
  - Continuar recursivamente con el siguiente índice (`indice_actual + 1`)
- La función recorre todos los libros de la biblioteca secuencialmente

**Consideraciones:**
- El array `visitados` tiene tamaño `biblioteca->cantidad_libros`
- El array `visitados` debe ser inicializado en `false` (calloc) antes de la primera llamada
- El array `visitados` es manejado por el llamador (no debe ser liberado por esta función)
- Para contar todas las páginas de la biblioteca, llamar con `indice_actual = 0`
- La recursión procesa los libros uno por uno: 0, 1, 2, ..., cantidad_libros-1

**Ejemplo:**
```
Biblioteca:
[0] "1984" - 328 páginas
[1] "Sapiens" - 443 páginas
[2] "El Principito" - 96 páginas

visitados inicial: [false, false, false]

contarPaginasTotales(biblioteca, 0, visitados) -> 867 páginas
(328 + 443 + 96 = 867)

Después de la llamada, visitados = [true, true, true]
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

1. En `buscarLibrosDisponibles`: La estructura `resultado` es provista por el llamador, pero el array `resultado->indices` debe ser reservado con malloc y liberado por el llamador después de usar
2. En `ordenarPorRating`: La función retorna una nueva lista, tanto la estructura como el array de índices deben ser liberados por el llamador. La lista de entrada no es modificada.
3. En `contarPaginasTotales`: El array `visitados` es manejado por el llamador y debe tener tamaño `biblioteca->cantidad_libros`, inicializado con calloc
4. Todos los índices en `ListaIndices` son índices válidos en el array `biblioteca->libros`
5. Los strings en `Libro` (`titulo`, `autor`) son arrays fijos de caracteres, no punteros dinámicos

## Recursos

- Archivos de cabecera: `src/ejs.h`, `src/utils.h`
- Funciones de utilidad en: `src/utils.c`
- Tests en: `ej*/test.c`

¡Buena suerte! 🚀
