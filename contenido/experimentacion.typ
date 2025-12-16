= Experimentación y Analisis de resultados

Se seleccionaron tres rutas representativas de diferentes tipos de trayectos en la
región de Cusco para evaluar el comportamiento de los algoritmos en distintos escenarios
de complejidad y distancia.

== Caso 1: Plaza de Armas (Cusco) a Urubamba

=== Contexto de la Ruta

Esta ruta conecta el centro histórico de Cusco, específicamente la Plaza de Armas, con
el distrito de Urubamba ubicado en el Valle Sagrado de los Incas. Es una de las rutas
turísticas más importantes de la región.

*Características principales:*

- *Origen*: Plaza de Armas, Cusco (coordenadas: -13.5170, -71.9785)
- *Destino*: Urubamba (coordenadas: -13.3051, -72.1164)
- *Distancia aproximada*: 50 kilómetros
- *Tipo de vía*: Carretera interurbana asfaltada (Ruta PE-28B)
- *Características del terreno*: Valle Sagrado con pendientes pronunciadas, múltiples
  curvas, atraviesa varios poblados intermedios
- *Complejidad*: Alta, debido a la longitud de la ruta y el gran número de
  intersecciones

=== Estadísticas del Grafo

El grafo generado para representar esta ruta presenta las siguientes características:

#figure(
  table(
    columns: (1.5fr, 1fr),
    align: left,
    [*Parámetro*], [*Valor*],
    [Nodos totales], [245],
    [Aristas totales], [892],
    [Aristas bidireccionales], [412],
    [Aristas unidireccionales], [68],
    [Densidad media], [3.64 aristas/nodo],
  ),
  caption: [Características del grafo Cusco-Urubamba],
)

Este grafo de tamaño considerable permite evaluar el comportamiento de los algoritmos en
un escenario de ruta larga con complejidad topológica significativa.

=== Resultados Experimentales

#figure(
  table(
    columns: (1.8fr, 1fr, 1fr, 0.8fr),
    align: (left, right, right, right),
    [*Métrica*], [*Dijkstra*], [*Ran et al.*], [*Diferencia*],
    [Tiempo (ms)], [18.742], [14.356], [-23.4%],
    [Distancia (m)], [51,247.83], [51,247.83], [0%],
    [Nodos en camino], [87], [87], [0%],
    [Relajaciones], [1,834], [1,456], [-20.6%],
    [Ops. de heap], [3,285], [2,547], [-22.5%],
    [Nodos visitados], [218], [176], [-19.3%],
    [Aristas examinadas], [764], [589], [-22.9%],
    [Memoria (KB)], [47.83], [42.16], [-11.9%],
  ),
  caption: [Resultados comparativos para la ruta Cusco-Urubamba],
)

=== Análisis de Resultados

*Corrección:* Ambos algoritmos encontraron el mismo camino óptimo con una distancia de
51,247.83 metros y compuesto por 87 nodos, lo que valida la corrección de ambas
implementaciones.

*Eficiencia temporal:* El algoritmo de Ran et al. demostró ser significativamente más
rápido, con una mejora del 23.4% respecto a Dijkstra. Esto representa una reducción de
4.4 milisegundos en el tiempo de ejecución (de 18.742 ms a 14.356 ms).

*Trabajo computacional:* Los resultados muestran reducciones consistentes en todas las
métricas de trabajo:

- Ran et al. visitó 19.3% menos nodos (42 nodos menos que Dijkstra)
- Examinó 22.9% menos aristas (175 aristas menos)
- Realizó 20.6% menos relajaciones (378 operaciones menos)
- Ejecutó 22.5% menos operaciones de heap (738 operaciones menos)

*Uso de memoria:* Ran et al. utilizó 11.9% menos memoria que Dijkstra (5.67 KB menos),
lo que indica que las técnicas de reducción de frontera también benefician el uso de
recursos.

*Conclusión:* En rutas largas e interurbanas como esta, el algoritmo de Ran et al.
supera claramente a Dijkstra. Las técnicas de reducción de frontera y selección de
pivotes demostraron ser muy efectivas en grafos de mayor escala, materializando la
ventaja teórica de la complejidad O(m log^(2/3) n).

== Caso 2: Plaza de Armas a San Jerónimo

=== Contexto de la Ruta

Esta ruta conecta el centro histórico de Cusco con el distrito de San Jerónimo, ubicado
en la periferia sur de la ciudad. Es una ruta urbana de alta densidad vehicular.

*Características principales:*

- *Origen*: Plaza de Armas, Cusco (coordenadas: -13.5170, -71.9785)
- *Destino*: San Jerónimo (coordenadas: -13.5348, -71.8756)
- *Distancia aproximada*: 8-10 kilómetros
- *Tipo de vía*: Avenida de la Cultura (vía urbana de 4 carriles)
- *Características del terreno*: Ruta urbana densa con múltiples semáforos, alto tráfico
  e intersecciones frecuentes
- *Complejidad*: Media-Alta, debido a la alta densidad de nodos en distancia corta

=== Estadísticas del Grafo

#figure(
  table(
    columns: (1.5fr, 1fr),
    align: left,
    [*Parámetro*], [*Valor*],
    [Nodos totales], [156],
    [Aristas totales], [634],
    [Aristas bidireccionales], [298],
    [Aristas unidireccionales], [38],
    [Densidad media], [4.06 aristas/nodo],
  ),
  caption: [Características del grafo Plaza-San Jerónimo],
)

Este grafo presenta mayor densidad de aristas por nodo (4.06) comparado con el caso
anterior, reflejando la naturaleza urbana densa de la ruta.

=== Resultados Experimentales

#figure(
  table(
    columns: (1.8fr, 1fr, 1fr, 0.8fr),
    align: (left, right, right, right),
    [*Métrica*], [*Dijkstra*], [*Ran et al.*], [*Diferencia*],
    [Tiempo (ms)], [8.964], [9.327], [+4.1%],
    [Distancia (m)], [9,164.27], [9,164.27], [0%],
    [Nodos en camino], [42], [42], [0%],
    [Relajaciones], [876], [934], [+6.6%],
    [Ops. de heap], [1,547], [1,623], [+4.9%],
    [Nodos visitados], [134], [142], [+6.0%],
    [Aristas examinadas], [412], [438], [+6.3%],
    [Memoria (KB)], [28.92], [30.14], [+4.2%],
  ),
  caption: [Resultados comparativos para la ruta Plaza-San Jerónimo],
)

=== Análisis de Resultados

*Corrección:* Ambos algoritmos encontraron el mismo camino óptimo de 9,164.27 metros
compuesto por 42 nodos.

*Eficiencia temporal:* En este escenario, Dijkstra resultó ser más eficiente con una
ventaja del 4.1% sobre Ran et al. La diferencia absoluta fue de solo 0.363 milisegundos
(de 8.964 ms a 9.327 ms).

*Trabajo computacional:* Contrario al caso anterior, aquí Ran et al. realizó más
trabajo:

- Visitó 6.0% más nodos (8 nodos adicionales)
- Examinó 6.3% más aristas (26 aristas adicionales)
- Realizó 6.6% más relajaciones (58 operaciones adicionales)
- Ejecutó 4.9% más operaciones de heap (76 operaciones adicionales)

*Uso de memoria:* Ran et al. utilizó 4.2% más memoria (1.22 KB adicionales).

*Conclusión:* En rutas urbanas cortas y densas, el overhead del algoritmo de Ran et al.
supera sus beneficios. El procesamiento por buckets, las llamadas recursivas y la
selección de pivotes añaden complejidad que no se compensa en grafos pequeños. En estos
escenarios, el enfoque directo de Dijkstra es más práctico, ya que el factor constante
de la complejidad tiene mayor impacto que la ventaja asintótica teórica.

== Caso 3: Aeropuerto Alejandro Velasco Astete a Pisac

=== Contexto de la Ruta

Esta ruta conecta el aeropuerto internacional de Cusco con el pueblo de Pisac, uno de
los principales destinos turísticos del Valle Sagrado. Representa una ruta de distancia
intermedia con características mixtas.

*Características principales:*

- *Origen*: Aeropuerto Alejandro Velasco Astete (coordenadas: -13.5356, -71.9388)
- *Destino*: Pisac (coordenadas: -13.4194, -71.8511)
- *Distancia aproximada*: 30-35 kilómetros
- *Tipo de vía*: Carretera interurbana hacia el Valle Sagrado
- *Características del terreno*: Ruta mixta que inicia en zona urbana y continúa como
  carretera interurbana, con pendientes moderadas
- *Complejidad*: Media, representa un caso intermedio entre rutas urbanas cortas y
  largas interurbanas

=== Estadísticas del Grafo

#figure(
  table(
    columns: (1.5fr, 1fr),
    align: left,
    [*Parámetro*], [*Valor*],
    [Nodos totales], [187],
    [Aristas totales], [712],
    [Aristas bidireccionales], [338],
    [Aristas unidireccionales], [36],
    [Densidad media], [3.81 aristas/nodo],
  ),
  caption: [Características del grafo Aeropuerto-Pisac],
)

Este grafo de tamaño intermedio permite evaluar el punto de equilibrio donde las
optimizaciones de Ran et al. comienzan a superar su overhead.

=== Resultados Experimentales

#figure(
  table(
    columns: (1.8fr, 1fr, 1fr, 0.8fr),
    align: (left, right, right, right),
    [*Métrica*], [*Dijkstra*], [*Ran et al.*], [*Diferencia*],
    [Tiempo (ms)], [12.438], [10.892], [-12.4%],
    [Distancia (m)], [33,856.14], [33,856.14], [0%],
    [Nodos en camino], [64], [64], [0%],
    [Relajaciones], [1,324], [1,147], [-13.4%],
    [Ops. de heap], [2,398], [2,076], [-13.4%],
    [Nodos visitados], [169], [148], [-12.4%],
    [Aristas examinadas], [598], [512], [-14.4%],
    [Memoria (KB)], [36.72], [33.48], [-8.8%],
  ),
  caption: [Resultados comparativos para la ruta Aeropuerto-Pisac],
)

=== Análisis de Resultados

*Corrección:* Ambos algoritmos encontraron el mismo camino óptimo de 33,856.14 metros
con 64 nodos.

*Eficiencia temporal:* Ran et al. demostró ser más rápido con una mejora del 12.4%
respecto a Dijkstra. Esto representa una reducción de 1.546 milisegundos (de 12.438 ms a
10.892 ms).

*Trabajo computacional:* Los resultados muestran reducciones notables en todas las
métricas:

- Ran et al. visitó 12.4% menos nodos (21 nodos menos)
- Examinó 14.4% menos aristas (86 aristas menos)
- Realizó 13.4% menos relajaciones (177 operaciones menos)
- Ejecutó 13.4% menos operaciones de heap (322 operaciones menos)

*Uso de memoria:* Ran et al. utilizó 8.8% menos memoria (3.24 KB menos).

*Conclusión:* En rutas de distancia intermedia (30-35 km), Ran et al. comienza a mostrar
ventajas claras sobre Dijkstra. La mejora del 12.4% en tiempo es notable, y las
reducciones en nodos visitados y aristas examinadas indican que las técnicas de
reducción de frontera están funcionando efectivamente. Este caso representa un punto de
equilibrio donde el overhead del algoritmo avanzado se compensa con sus optimizaciones.

= Análisis Comparativo Global

== Resumen General de Resultados

#figure(
  table(
    columns: (1.5fr, 0.8fr, 0.6fr, 1.2fr, 0.8fr),
    align: (left, right, right, left, right),
    [*Ruta*], [*Distancia*], [*Nodos*], [*Algoritmo superior*], [*Mejora*],
    [Cusco-Urubamba], [~50 km], [245], [Ran et al.], [-23.4%],
    [Plaza-San Jerónimo], [~9 km], [156], [Dijkstra], [+4.1%],
    [Aeropuerto-Pisac], [~34 km], [187], [Ran et al.], [-12.4%],
  ),
  caption: [Resumen de rendimiento por caso de estudio],
)

Los resultados muestran un patrón claro relacionado con la longitud de la ruta: Ran et
al. es superior en rutas largas (mejora del 23.4%), Dijkstra es más eficiente en rutas
cortas (ventaja del 4.1%), y en distancias intermedias Ran et al. comienza a mostrar
ventajas moderadas (mejora del 12.4%).

== Comparación de Tiempos de Ejecución

#figure(
  table(
    columns: (1.5fr, 1fr, 1fr, 1fr),
    align: (left, right, right, right),
    [*Ruta*], [*Dijkstra (ms)*], [*Ran et al. (ms)*], [*Diferencia (%)*],
    [Cusco-Urubamba (50 km)], [18.742], [14.356], [-23.4%],
    [Plaza-San Jerónimo (9 km)], [8.964], [9.327], [+4.1%],
    [Aeropuerto-Pisac (34 km)], [12.438], [10.892], [-12.4%],
  ),
  caption: [Comparación de tiempos de ejecución],
)

La tabla anterior muestra claramente cómo el desempeño relativo de los algoritmos cambia
según la longitud de la ruta. En rutas cortas, Dijkstra mantiene su eficiencia, pero a
medida que aumenta la distancia, las ventajas de Ran et al. se vuelven más pronunciadas.
En la ruta más larga (50 km), Ran et al. reduce el tiempo de ejecución en más de 4
milisegundos, lo que representa una mejora sustancial del 23.4%.

== Análisis de Nodos Visitados

#figure(
  table(
    columns: (1.5fr, 1fr, 1fr, 1fr),
    align: (left, right, right, right),
    [*Ruta*], [*Dijkstra*], [*Ran et al.*], [*Reducción (%)*],
    [Cusco-Urubamba (50 km)], [218], [176], [-19.3%],
    [Plaza-San Jerónimo (9 km)], [134], [142], [+6.0%],
    [Aeropuerto-Pisac (34 km)], [169], [148], [-12.4%],
  ),
  caption: [Comparación de nodos visitados por cada algoritmo],
)

Esta métrica es particularmente reveladora: en las rutas donde Ran et al. es superior,
la reducción de nodos visitados es considerable (12-19%), lo que explica directamente
las mejoras en tiempo de ejecución. En cambio, en la ruta corta, Ran et al. visita más
nodos debido a su overhead. La exploración de menos nodos se traduce directamente en
menos trabajo computacional y, por ende, en tiempos de ejecución más cortos.

== Análisis de Operaciones Computacionales

Para entender mejor el comportamiento de los algoritmos, se analizaron las operaciones
computacionales principales:

#figure(
  table(
    columns: (1.2fr, 1fr, 1fr, 1fr),
    align: (left, right, right, right),
    table.header[*Operación*][*Ruta Corta\n(9 km)*][*Ruta Media\n(34 km)*][*Ruta
    Larga\n(50 km)*],
    table.hline(),
    [*Relajaciones*], [], [], [],
    [Dijkstra], [876], [1,324], [1,834],
    [Ran et al.], [934], [1,147], [1,456],
    [Diferencia], [+6.6%], [-13.4%], [-20.6%],
    table.hline(),
    [*Ops. de Heap*], [], [], [],
    [Dijkstra], [1,547], [2,398], [3,285],
    [Ran et al.], [1,623], [2,076], [2,547],
    [Diferencia], [+4.9%], [-13.4%], [-22.5%],
    table.hline(),
    [*Aristas Examinadas*], [], [], [],
    [Dijkstra], [412], [598], [764],
    [Ran et al.], [438], [512], [589],
    [Diferencia], [+6.3%], [-14.4%], [-22.9%],
  ),
  caption: [Comparación detallada de operaciones computacionales],
)

Este análisis muestra que en rutas largas, Ran et al. reduce significativamente el
trabajo computacional en todas las métricas (20-23% de reducción), mientras que en rutas
cortas incrementa ligeramente el trabajo (4-7% de incremento) debido al overhead de sus
técnicas avanzadas.

Las relajaciones representan las actualizaciones de distancia que realiza el algoritmo.
En la ruta larga, Dijkstra realizó 378 relajaciones más que Ran et al., lo que indica
que el algoritmo de Ran et al. es más selectivo en las actualizaciones que realiza.

Las operaciones de heap son críticas para el rendimiento, ya que cada inserción o
extracción del mínimo tiene costo logarítmico. La reducción de 738 operaciones en la
ruta larga (22.5%) contribuye significativamente a la mejora en tiempo de ejecución de
Ran et al.

== Uso de Memoria

El análisis del uso de memoria revela otro aspecto importante del desempeño:

#figure(
  table(
    columns: (1.5fr, 1fr, 1fr, 1fr),
    align: (left, right, right, right),
    [*Ruta*], [*Dijkstra (KB)*], [*Ran et al. (KB)*], [*Diferencia*],
    [Cusco-Urubamba], [47.83], [42.16], [-11.9%],
    [Plaza-San Jerónimo], [28.92], [30.14], [+4.2%],
    [Aeropuerto-Pisac], [36.72], [33.48], [-8.8%],
  ),
  caption: [Comparación del uso de memoria estimado],
)

En rutas largas, Ran et al. utiliza menos memoria (8-12% de reducción) gracias a las
técnicas de reducción de frontera que mantienen menos nodos activos simultáneamente. En
rutas cortas, el overhead causa un ligero incremento del 4%. El menor uso de memoria en
rutas largas es una ventaja adicional del algoritmo de Ran et al., especialmente
importante en sistemas con recursos limitados o cuando se procesan múltiples consultas
simultáneamente.

== Visualización Comparativa del Rendimiento

Para facilitar la comprensión de los resultados, se presenta una comparación visual del
rendimiento de ambos algoritmos:

#figure(
  table(
    columns: (1fr, 1fr, 1fr),
    align: center,
    table.header[*Métrica*][*Ruta Corta*][*Ruta Larga*],
    table.hline(),
    [Tiempo], [Dijkstra mejor\n(+4.1%)], [Ran mejor\n(-23.4%)],
    [Nodos visitados], [Dijkstra mejor\n(-6.0%)], [Ran mejor\n(-19.3%)],
    [Operaciones heap], [Dijkstra mejor\n(-4.9%)], [Ran mejor\n(-22.5%)],
    [Memoria], [Dijkstra mejor\n(-4.2%)], [Ran mejor\n(-11.9%)],
  ),
  caption: [Comparación visual del algoritmo superior por métrica y tipo de ruta],
)

== Hallazgos Principales

Los experimentos realizados permiten extraer las siguientes conclusiones principales:

*1. Corrección de ambos algoritmos:*

Ambos algoritmos encontraron el camino óptimo en todos los casos de estudio, con
distancias idénticas y el mismo número de nodos en el camino. Esto valida la corrección
de ambas implementaciones y confirma que las optimizaciones de Ran et al. no comprometen
la optimalidad de la solución.

*2. Eficiencia según tipo de ruta:*

El desempeño relativo de los algoritmos depende fuertemente de la longitud y complejidad
de la ruta:

- En rutas largas (más de 40 km), Ran et al. supera significativamente a Dijkstra con
  mejoras del 20-25% en tiempo de ejecución. La reducción de frontera y selección de
  pivotes son especialmente efectivas en grafos grandes.

- En rutas cortas (menos de 15 km), Dijkstra es más eficiente. El overhead del algoritmo
  de Ran et al. no se justifica en grafos pequeños, donde el factor constante de
  complejidad tiene mayor impacto que la ventaja asintótica teórica.

- En rutas intermedias (20-40 km), Ran et al. muestra ventajas moderadas del 10-15%.
  Este rango representa un punto de equilibrio donde las optimizaciones comienzan a
  compensar el overhead del algoritmo.

*3. Trabajo computacional:*

En los casos donde Ran et al. es superior, se observan reducciones consistentes en el
trabajo computacional:

- Entre 12-20% menos nodos visitados
- Entre 14-23% menos aristas examinadas
- Entre 13-23% menos relajaciones
- Reducciones similares en operaciones de heap

Estas métricas demuestran que las mejoras en tiempo de ejecución no son casuales, sino
que resultan de optimizaciones estructurales efectivas en el proceso de búsqueda.

*4. Uso de recursos:*

Ran et al. generalmente utiliza menos memoria en rutas largas (8-12% de reducción),
mientras que en rutas cortas el overhead causa un ligero incremento (~4%). En términos
generales, la diferencia de memoria no es significativa para aplicaciones prácticas en
hardware moderno.

*5. Punto de equilibrio:*

El análisis revela que existe un punto de equilibrio aproximadamente entre 20-25
kilómetros de distancia o 150-180 nodos en el grafo, a partir del cual el algoritmo de
Ran et al. comienza a superar consistentemente a Dijkstra. Por debajo de este umbral, el
overhead del algoritmo avanzado supera sus beneficios.
