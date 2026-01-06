= Metodología

Esta investigación compara experimentalmente el rendimiento de dos algoritmos de caminos
mínimos en redes de transporte mediante una arquitectura híbrida JavaScript-WASM.

El codigo fuente de la implementacion del codigo esta en
https://github.com/daniel-alegria3/paper-algoritmos-avanzados/tree/main/code y este se
puede probar en vivo en https://daniel-alegria3.github.io/paper-algoritmos-avanzados/

== Entorno Experimental (Hardware y Software)
Dado que el rendimiento de los algoritmos de grafos es altamente dependiente de la
arquitectura subyacente, se estableció un entorno de pruebas estandarizado para
garantizar la reproducibilidad de las mediciones temporales.

=== Especificaciones de Hardware
Estación de trabajo Acer Aspire A315-57G:
- *CPU:* Intel Core i5 (10th Gen), ~1.0 GHz base con Turbo Boost.
- *RAM:* 8 GB DDR4.
- *SO:* Windows 11 Home (v10.0.26100).

=== Entorno de Ejecución
- *Lenguaje:* JavaScript (ECMAScript 2015+) para aplicación; C3 compilado a WASM para
  algoritmos.
- *Motor:* V8 (Google Chrome) con módulos WASM nativos.
- *Compilación:* C3 (c3c v1.0+) a WebAssembly sin overhead de interpretación.
- *Justificación:* JavaScript + WASM permite UI ágil con visualización en tiempo real,
  mientras algoritmos ejecutan a velocidad nativa (_near-native performance_), evaluando
  viabilidad de implementaciones complejas en el cliente (_client-side_).

== Materiales y Conjuntos de Datos
Datos geográficos reales de OpenStreetMap (OSM) para validez ecológica:
- *Fuente:* OpenStreetMap; regiones urbanas seleccionadas por bounding box.
- *Nodos ($V$):* Intersecciones viales de OSM.
- *Aristas ($E$):* Segmentos de vía; pesos: distancia geodésica (lat/lon).
- *Característica:* Grafos dispersos ($m approx k dot n$); grado promedio bajo (2-4).

== Implementación de los Algoritmos
Arquitectura híbrida JavaScript + WASM (C3 compilado) sin librerías externas:

=== Arquitectura de Ejecución
+ *Aplicación (JavaScript):* UI (`app.js`), carga de grafos (`graph.js`), coordinación
  (`algorithms.js`).
+ *Hooks (WASM):* Inicialización, memoria, marshaling (`hooks/dijkstra.js`,
  `hooks/ran2025.js`).
+ *Núcleo (C3/WASM):* Algoritmos compilados (`algorithms/dijkstra.c3`,
  `algorithms/ran2025.c3`) invocados vía API WebAssembly.

=== Algoritmo de Dijkstra (Línea Base)
Versión estándar en C3 con Binary Heap:
- *Heap:* Compilado en WASM (`common.c3`) para `extract-min` en $O(\\log n)$.
- *Memoria:* Arreglos pre-asignados en memoria lineal WASM (distancias, visitados,
  precedentes, cola).
- *Adyacencia:* Índices compactos (`adjacency_offset`, `adjacency_count`) para acceso
  eficiente a vecinos.

=== Algoritmo Ran et al. (2025) $O(m log^(2/3) n)$
Implementación en C3 (`ran2025.c3`) del algoritmo de frontera reducida:
+ *Bucketización:* Factor $log^(2/3) n$ calculado en tiempo de ejecución para buckets
  por nivel.
+ *Reducción de Frontera:* Pivotes selectivos limitan crecimiento exponencial.
+ *Límites Expandibles:* `currentBound` aumenta gradualmente para explorar regiones.
+ *Fallback:* Revierte a Dijkstra si no converge, garantizando corrección.

== Procedimiento y Métricas de Evaluación
- *Métrica:* Tiempo de ejecución (wall-clock, ms) vía `performance.now()`, incluyendo
  invocación WASM.
- *Protocolo:* Para cada par origen-destino:
  + Primer ejecutable: calentar JIT V8 y compilar WASM.
  + $N=10$ ejecuciones secuenciales.
  + Descartar mejor/peor; promediar restantes.
- *Nota:* Overhead marshaling JavaScript-WASM negligible vs. tiempos de ejecución.
