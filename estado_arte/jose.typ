#import "./clib.typ": estado_arte_seccion

== #estado_arte_seccion("anagreh2021")
*El problema:* Algoritmos tradicionales de rutas más cortas revelan información privada
(ubicaciones, estructura de mapas).

- Implementa procesamiento paralelo con vectores SIMD
- Mantiene los datos secretos entre múltiples servidores

Significativamente mejor rendimiento que trabajos previos en rutas que preservan
privacidad.

- *Algoritmo Radius-Stepping*: mejora los límites teóricos del algoritmo
- *Algoritmo Stepping*: Usa vectores para representar grafos y procesar en paralelo
  (SIMD)
- *Algoritmo SImd*: es Matriz de adyacencia del grafo Radios de vértices [r] y vértice
  fuente s

- *La complejidad de Tiote*: se basa en el radio r. En el cual el radio puede determinar
  el nùmero de pasos y subpasos en el càlculo. En el cual el algoritmo contiene los
  resultados para deducir el paràmetro inlcuida la estructura del grafico y los radios
  utilizados

  $
    r &= Omega: 0(n + log m) \
    r &= inf: O(log m) \
    r &= Delta: O(log n + log m) \
  $

== #estado_arte_seccion("dhulipala2018")
Este trabajo demuestra que los algoritmos paralelos de grafos teóricamente eficientes
pueden procesar de manera eficaz grafos de gran escala, incluyendo el grafo web de
hipervínculos con 3.5 mil millones de vértices y 128 mil millones de aristas, en una
sola máquina compartida de memoria con un terabyte de RAM, en cuestión de minutos.

Los métodos empleados en este trabajo incluyen el desarrollo de una interfaz de alto
nivel para el procesamiento de grafos y la implementación de algoritmos paralelos
teóricamente eficientes para diversos problemas en grafos. Asimismo, el artículo
incorpora una primitiva de reducción para evitar contención y una suma prefija sobre A
con el fin de optimizar los algoritmos.

== #estado_arte_seccion("wang2021")
El algoritmo sssp, presenta un nuevo algoritmo para el problema para el camino más corto
desde un único origen (SSSP) en GPU, lo que permite una implementación eficiente y de
alta calidad en GPU. Supera en rendimiento a soluciones previas, siendo hasta 2.9 veces
más rápida, en el cual analiza cómo implementar eficientemente algoritmos SSSP (como
Dijkstra, Bellman-Ford y delta-stepping) en GPU, destacando tres consideraciones clave:

- Gestión de memoria
- Sincronización
- Granularidad

Estrategias de gestión de acceso y organización de la cola de trabajo en GPU
para optimizar algoritmos SSSP:

- Modelo SRMW (Single Read Multiple Write)
- Gestión de colas
- Asignación dinámica de memoria 
- Cola de trabajo ordenada


Contribuciones principales:

+ Desacoplar operaciones irregulares: Convertir prioridades de datos altamente
  irregulares en operaciones regulares

+ Expresar operaciones paralelas: Encontrar formas eficientes para GPU mediante enfoques
  mandatorios para desarrolladores En esencia: Metodología exitosa para adaptar
  algoritmos irregulares (como SSSP) a arquitecturas GPU mediante reestructuración
  fundamental que sacrifica algo de complejidad algorítmica por ganancias masivas de
  rendimiento paralelo.

== #estado_arte_seccion("andreiana2020")

Se describe el algoritmo de Dijkstra con una cola de prioridad que almacena las
distancias y mínimas del origen.

También se detalla el proceso de relajación de aristas y cómo se actualizan las
distancias.

Se menciona la importancia del método DECREASE-KEY en estructuras de datos complejas y
cómo evitarlo en el cual pueden mejorar el rendimiento. Además, se presentan
experimentos para comparar distintas implementaciones del algoritmo con grafos de
diferente densidad.

También realiza una comparación entre diferentes implementaciones del algoritmo de
Dijkstra, enfocándose en cómo las estructuras de datos de la cola de prioridad afectan
su rendimiento en distintos tipos de grafos (dispersos y densos). Se analizan las
ventajas y desventajas de usar montones binarios y montones de Fibonacci.

#align(center)[
  #grid(
    columns: (1fr, 1fr),
    gutter: 5pt,
    image("../imgs/edge1.png"), image("../imgs/edge2.png"),
  )
]


== #estado_arte_seccion("khanda2022")
- Busca resolver la ruta más corta desde un vértice origen a todos los demás en un grafo
  ponderado.

Su metodologia consiste en dos pasos principales:
- El primero, identificar en paralelo los subgrafos afectados por los cambios en los
  bordes.
- Segundo, actualizar estos subgrafos mediante un proceso iterativo que evita
  sincronizaciones garantizando convergencia a la solución óptima.


=== Algoritmos principales:

- *Dijkstra:* O(V²) secuencial, mantiene árbol SSSP con vértices no explorados en cola
  de prioridad.

- *Bellman-Ford:* Relaja todos los bordes iterativamente, maneja pesos negativos

=== Algoritmos paralelos recientes:
Enfoques basados en GPU y técnicas de actualización incremental.

=== Desafío actual:
Los algoritmos existentes luchan con:
- Escalabilidad para grafos masivos
- Paralelización eficiente
- Balance entre complejidad computacional y de memoria

#align(center)[
  #image("../imgs/vmfb.png")
]

