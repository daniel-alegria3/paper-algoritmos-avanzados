= Metodología

La presente investigación adopta un diseño experimental de enfoque cuantitativo,
orientado a evaluar y comparar el rendimiento computacional de dos algoritmos de caminos
mínimos en escenarios controlados que simulan redes de transporte. A continuación, se
detallan los materiales, la arquitectura de software y el protocolo experimental
utilizado.

El codigo fuente de la implementacion del codigo esta en
https://github.com/daniel-alegria3/paper-algoritmos-avanzados/tree/main/code y este se
puede probar en vivo en https://daniel-alegria3.github.io/paper-algoritmos-avanzados/

== Entorno Experimental (Hardware y Software)
Dado que el rendimiento de los algoritmos de grafos es altamente dependiente de la
arquitectura subyacente, se estableció un entorno de pruebas estandarizado para
garantizar la reproducibilidad de las mediciones temporales.

=== Especificaciones de Hardware
Las pruebas experimentales se ejecutaron en una estación de trabajo independiente con
las siguientes características técnicas, correspondientes al modelo Acer Aspire
A315-57G:

- *Procesador (CPU):* Intel Core i5 (10th Gen) con arquitectura x64. Frecuencia base
  ~1.0 GHz con capacidad de *Turbo Boost*.
- *Memoria RAM:* 8 GB DDR4 (7.97 GB de memoria física total disponible).
- *Sistema Operativo:* Microsoft Windows 11 Home Single Language (Versión 10.0.26100,
  Compilación 26100).

=== Entorno de Ejecución (Runtime)
Este estudio evalúa el comportamiento de los algoritmos en un entorno web moderno,
relevante para aplicaciones de *SaaS* (Software as a Service) de transporte.
- *Lenguaje de Programación:* JavaScript (ECMAScript 2015+).
- *Motor de Ejecución:* V8 JavaScript Engine (Google Chrome / Node.js runtime).
- *Justificación:* El uso de JavaScript permite la visualización en tiempo real sobre
  mapas interactivos y evalúa la viabilidad de implementar algoritmos complejos
  directamente en el lado del cliente (_client-side_).

== Materiales y Conjuntos de Datos
Para la construcción de los grafos de prueba, se prescindió de datos sintéticos puros y
se optó por datos geográficos reales para garantizar la validez ecológica del estudio.

- *Fuente de Datos:* OpenStreetMap (OSM).
- *Extracción:* Se seleccionaron regiones urbanas reales mediante una interfaz de
  selección rectangular (bounding box).
- *Topología del Grafo:*
  - *Nodos ($V$):* Intersecciones viales extraídas de la base de datos de OSM.
  - *Aristas ($E$):* Segmentos de vía que conectan las intersecciones.
  - *Pesos ($w$):* Distancia geodésica calculada entre coordenadas (latitud/longitud).
- *Característica:* Los grafos resultantes son *dispersos* ($m approx k dot n$),
  representando fielmente la estructura de una red vial donde el grado promedio de los
  nodos es bajo (típicamente entre 2 y 4).

== Implementación de los Algoritmos
Se desarrollaron dos implementaciones *ad-hoc* en JavaScript puro, sin depender de
librerías externas de optimización, para asegurar una comparación justa bajo las mismas
condiciones de intérprete.

=== Algoritmo de Dijkstra (Línea Base)
Se implementó la versión estándar del algoritmo utilizando una *Cola de Prioridad
Binaria* (_Binary Heap_).
- *Estructura de Datos:* Un *Binary Heap* personalizado (`PriorityQueue` en `graph.js`)
  para las operaciones de `extract-min` en tiempo logarítmico.
- *Gestión de Conjuntos:* Uso de estructuras nativas `Map` y `Set` de JavaScript para el
  control de distancias y nodos visitados, optimizando la búsqueda y actualización de
  claves.

=== Algoritmo Aproximado $O(m log^(2/3) n)$
Se desarrolló una implementación algorítmica experimental (`ran2025Algorithm` en
`algorithms.js`) que aproxima la estructura jerárquica propuesta en la literatura
teórica reciente para grafos dispersos. Debido a la complejidad de implementar
estructuras de datos teóricas de bajo nivel en un lenguaje de alto nivel como JS, se
diseñó una simulación funcional que incorpora los siguientes principios:

+ *Bucketización Recursiva:* Cálculo del factor $log^(2/3) n$ para determinar el tamaño
  dinámico de los "buckets" o cubos de procesamiento.
+ *Reducción de Frontera:* Selección parcial de nodos vecinos (pivotes) para limitar el
  espacio de búsqueda inmediato.
+ *Mecanismo Híbrido:* Un sistema de *fallback* que revierte a una fase de relajación
  tradicional si la búsqueda jerárquica no converge dentro de los límites calculados por
  nivel.

== Procedimiento y Métricas de Evaluación
El protocolo experimental para la recolección de datos se diseñó para minimizar el ruido
introducido por el sistema operativo y el *Garbage Collector* del navegador.

- *Métrica Principal:* Tiempo de ejecución de CPU (*Wall-clock time*), medido en
  milisegundos.
- *Instrumento de Medición:* Se utilizó la API de alta resolución `performance.now()`,
  la cual ofrece una precisión de sub-milisegundos, superior a la función `Date.now()`.
- *Protocolo de Repetición:* Para cada par origen-destino y tamaño de grafo:
  + Se ejecuta el algoritmo una primera vez para "calentar" el motor JIT (Just-In-Time
    Compiler) de V8.
  + Se realizan $N=10$ ejecuciones secuenciales.
  + Se descartan los valores atípicos (mejor y peor tiempo) y se calcula el promedio
    aritmético de las ejecuciones restantes para obtener el dato final.
