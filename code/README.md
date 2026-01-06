# Visualizador de Algoritmos SSSP

Herramienta interactiva para comparar algoritmos de camino más corto con fuente única (SSSP) en OpenStreetMap.

## Características

- **Integración con OpenStreetMap**: Selecciona cualquier región en el mapa para generar un grafo
- **Selección Interactiva de Nodos**: Haz clic en el mapa para seleccionar nodos de origen y destino
- **Múltiples Algoritmos**:
  - Dijkstra con Heap Binario - O((m + n) log n)
  - Ran et al. (2025) - O(m log^(2/3) n) inspirado en divide-y-conquista
- **Métricas de Rendimiento**: Comparación de tiempos de ejecución para análisis de algoritmos
- **Comparación de Algoritmos**: Ejecuta todos los algoritmos y compáralos lado a lado

## Uso

1. Abre `index.html` en un navegador web moderno
2. Haz clic en "Seleccionar Región" y arrastra en el mapa para definir el área del grafo
3. Ajusta el número de nodos y la densidad de aristas según sea necesario
4. Haz clic en "Seleccionar Nodos" y selecciona dos nodos (origen y destino)
5. Elige un algoritmo y haz clic en "Ejecutar Algoritmo"

## Estructura del Proyecto

### Interfaz Web
- `index.html` - Estructura HTML principal
- `app.js` - Lógica principal de la aplicación y gestión de la interfaz
- `graph.js` - Estructura de datos de grafo, implementaciones de MinHeap y PriorityQueue
- `styles.css` - Estilos de tema oscuro

### Integración de Algoritmos
- `algorithms.js` - Registro de algoritmos y coordinación de interfaz WASM
- `hooks/` - Inicialización y ejecución de módulos WASM
  - `dijkstra.js` - Hook de ejecución del algoritmo de Dijkstra
  - `ran2025.js` - Hook de ejecución del algoritmo Ran2025

### C3 / WebAssembly (Implementaciones de Alto Rendimiento)
- `algorithms/` - Implementaciones en C3 compiladas a WebAssembly
  - `dijkstra.c3` - Algoritmo de Dijkstra con cola de prioridad de heap binario
  - `ran2025.c3` - Algoritmo inspirado en Ran et al. (2025)
  - `common.c3` - Estructuras de datos compartidas e implementación de cola de prioridad
  - `Makefile` - Configuración de construcción para compilación a WebAssembly
  - `build/` - Módulos WebAssembly compilados

## Arquitectura

El proyecto utiliza una arquitectura híbrida para un rendimiento óptimo:

1. **Capa JavaScript** (`app.js`, `algorithms.js`) - Gestiona la interfaz, carga de grafos y coordinación de algoritmos
2. **Hooks WASM** (`hooks/`) - Gestiona inicialización de módulos WebAssembly, asignación de memoria y serialización de parámetros
3. **Núcleo de Alto Rendimiento** (`algorithms/`) - Algoritmos en C3 compilados a WebAssembly para computación rápida

## Construir Módulos WebAssembly

Desde el directorio `algorithms/`:

```bash
make                    # Construir todos los módulos (modo release)
make BUILD_TYPE=debug   # Construir con símbolos de depuración
make dijkstra          # Construir algoritmo específico
make clean             # Limpiar artefactos de construcción
```

Requiere compilador C3 (c3c) versión 1.0+

## Agregar Nuevos Algoritmos

Para agregar un nuevo algoritmo:

1. Implementar en C3: Crea `algorithms/mialgoritmo.c3` con función `void mialgoritmo_execute(...)`
2. Crear hook: Agrega `hooks/mialgoritmo.js` con función `initializeMialgoritmoModule()`
3. Registrar: En `algorithms.js`, llama a:
   ```javascript
   registerAlgorithm('mialgoritmo', mialgoritmFunction, 'Mi Nombre de Algoritmo', 'Descripción');
   ```

## Basado en Investigación

- Ran et al. (2025): "Shortest Paths in O(m log^(2/3) n) Time"
- Implementa conceptos: divide-y-conquista, reducción de frontera, BMSSP
