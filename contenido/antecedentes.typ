/*
En esta sección se va desde aspectos generales a aspectos específicos (como un embudo).
No se olvide que es la primera parte que tiene contacto con el lector y que hará que
este se interese en el tema a investigar. El objetivo de esta sección es llevar al
lector hacie el tema que se va a tratar en forma específica y dejar la puerta abierta a
otras investigaciones.

== Trabajos Relacionados

Antecedentes o esbozo del estado del arte. Reflejan los avances y el Estado actual del
conocimiento en un área determinada y sirve de modelo o ejemplo para futuras
investigaciones. Se refieren a todos los trabajos de investigación que anteceden a
nuestro, es decir, aquellos trabajos donde se hayan manejado las mismas variables o se
hallan comparaciones y tener ideas sobre cómo se trató el problema en esa oportunidad.

En typst se cita usando `@` y nombre de la entrada bib cita en `refs.bib`. Ejemplo
`@ran2025` @ran2025
*/

#import "./clib.typ": estado_arte_seccion
= Antecedentes

== Evolución Histórica del Problema de Caminos Más Cortos

El problema de encontrar el camino más corto entre dos puntos en una red ha sido un
desafío fundamental en matemáticas y ciencias de la computación desde hace décadas.
Originado en el siglo XIX con el trabajo de Gaspard Monge sobre rutas óptimas, el
problema se formalizó matemáticamente en la teoría de grafos durante el siglo XX. El
algoritmo de Dijkstra, propuesto en 1959, representó un hito al proporcionar una
solución eficiente para grafos con pesos no negativos, convirtiéndose en el estándar
para aplicaciones prácticas como navegación y redes de transporte.

A lo largo de las décadas siguientes, la investigación se centró en optimizaciones del
algoritmo clásico, incluyendo mejoras en estructuras de datos como montículos de
Fibonacci, que redujeron la complejidad de $O(m log n)$ a $O(m + n log n)$. Sin embargo,
la barrera teórica de $O(m + n log n)$ permaneció intacta hasta principios del siglo
XXI, cuando avances en algoritmos aleatorizados y deterministas comenzaron a explorar
complejidades subóptimas.

== Avances Recientes en Algoritmos Deterministas

En los últimos años, la comunidad científica ha logrado romper la cota inferior
tradicional mediante algoritmos que operan en modelos de computación específicos, como
el modelo de comparación y suma. Estos avances han abierto nuevas posibilidades para el
procesamiento eficiente de grafos a gran escala, particularmente en dominios dispersos
como las redes de transporte urbano. La investigación actual se enfoca en validar
empíricamente si estas mejoras teóricas se traducen en beneficios prácticos, dejando
abierta la puerta a futuras exploraciones en algoritmos cuánticos y paralelización
masiva.

== Trabajos Relacionados

/*** Daniel ***/
=== #estado_arte_seccion("ran2025")
Este es el primer resultado que presenta un algoritmo determinista que rompe la cota de
tiempo $O(m + n log n)$, alcanzando una complejidad temporal de $O(m log^(2/3)n)$.

El algoritmo utiliza un enfoque de divide-and-conquer, particionando el conjunto de
vértices en piezas más pequeñas y calculando recursivamente las distancias a un conjunto
de vértices más cercanos. El algoritmo también emplea una técnica de frontier reduction,
que reduce el tamaño de la frontera por un factor de $1/(log^(Omega(1))(n))$, lo que
permite una aceleración significativa.

El algoritmo está diseñado para resolver el problema bounded multi-source shortest path
(BMSSP). Funciona dividiendo recursivamente el problema en subproblemas más pequeños
hasta que se alcanza el límite o el tamaño del conjunto de vértices llega a un cierto
umbral. El algoritmo utiliza una data structure para gestionar de manera eficiente los
vértices y sus distancias. El algoritmo BMSSP es un procedimiento recursivo que toma
parámetros $l$, $B$, y $S$ y retorna $B'$ y $U$. Los pasos principales del algoritmo
involucran encontrar un pivot set $P$, inicializar $D$, y llamar recursivamente a BMSSP
sobre subconjuntos de $S$.


=== #estado_arte_seccion("ran2023")
Este trabajo presenta un nuevo algoritmo randomized para el problema single-source
shortest path (SSSP), con un tiempo de ejecución $O(m sqrt(log n dot.c log(log n)))$ en
el modelo comparison-addition, siendo el primer algoritmo en romper la cota temporal
para grafos sparse con pesos reales usando el algoritmo de Dijkstra con Fibonacci heaps.
El algoritmo es más rápido que la cota temporal previa de $O(m+n log n)$ para grafos
sparse con pesos reales.

Los resultados del estudio incluyen el desarrollo de un nuevo algoritmo, llamado Bundle
Dijkstra, que alcanza una complejidad temporal de $O(m sqrt(log n dot log(log n)))$.

El algoritmo mejorado de bundle construction logra un tiempo de ejecución de
$O(m sqrt(log n dot log(log n)))$ con alta probabilidad, rompiendo la cota inferior de
$Omega(m+n log n)$.


=== #estado_arte_seccion("gan2024")
Este trabajo presenta TianheStar, un motor ultra-rápido para SSSP diseñado para
búsquedas en grafos sobre la supercomputadora Tianhe. Se demuestra que puede recorrer la
red carretera de EE. UU. en menos de 0.1 segundos.

Los experimentos muestran que el sistema TianheGraph alcanza un rendimiento
sobresaliente en cómputo de grafos dentro del entorno exaescala de Tianhe. Además, los
resultados en el benchmark Graph500 confirman su eficacia, superando a otros sistemas
como Tianhe-2 y K computer.


=== #estado_arte_seccion("bringmann2023")
Este trabajo reexamina el problema fundamental de Single-Source Shortest Paths (SSSP)
con posibles aristas de peso negativo, logrando reducir el tiempo de ejecución en casi
seis factores logarítmicos. También desarrolla un algoritmo para calcular el mínimo
ciclo medio con la misma eficiencia.

Para ello combina varias técnicas: optimización del algoritmo BNW, métodos de escalado y
descomposición, y análisis de drift. El enfoque incluye dividir el grafo en subtareas,
emplear la cola de prioridad de Thorup para acelerar Dijkstra, y analizar la función de
drift para garantizar la corrección.

Los aportes principales son un algoritmo mejorado para SSSP con pesos negativos, uno
nuevo para ciclos mínimos, y una construcción para Low-Diameter Decompositions en grafos
dirigidos, todos con tiempos optimizados. El algoritmo propuesto resuelve SSSP en
$O((m + n log log n) log^2 n log(n W))$ con alta probabilidad, y detecta ciclos
negativos cuando existen.


=== #estado_arte_seccion("kumawat2021")
Este estudio demuestra que el rendimiento varía entre los distintos algoritmos que
resuelven variantes del problema shortest path (SPP).

Se realiza una revisión de la literatura sobre algoritmos clásicos, analizando su
complejidad temporal y desempeño. También se aplican técnicas de teoría de grafos para
modelar y resolver instancias de SPP. Además, se implementan y comparan métodos como
Dijkstra, Bellman-Ford y enfoques híbridos basados en algoritmos genéticos y de colonia
de hormigas, evaluando métricas como tiempo y precisión.


/*
=== #estado_arte_seccion("alves2020")
Este trabajo también examina la variabilidad de desempeño entre diferentes algoritmos de
SPP. Se introducen SP1, SP2 y ParSP2, que aprovechan información adicional sobre la
estructura del grafo para optimizar resultados. Entre las modificaciones propuestas está
el uso de un conjunto $R$ de vértices fijados pero no explorados, y una variable `pred`
que controla el número de aristas entrantes aún no relajadas.

Los experimentos muestran que SP1, SP2 y ParSP2 superan a algoritmos como Dijkstra y
Δ-stepping en rendimiento y eficiencia. En particular, SP1 logra complejidad
$O(e + n log n)$ con Fibonacci heaps en grafos dirigidos, mientras que SP2 alcanza
$O(e)$ en grafos acíclicos dirigidos y no ponderados.

SP2 destaca por superar de manera consistente a Dijkstra, con aceleraciones entre 7% y
46%. ParSP2 escala bien al aumentar el número de hilos, especialmente en grafos grandes.
En general, los algoritmos muestran mejoras significativas y mantienen un buen
comportamiento frente al crecimiento del tamaño de las instancias.


/*** Zaith ***/
=== #estado_arte_seccion("bernstein2020")
*Resumen:*
Este trabajo aborda el problema del camino más corto desde una sola fuente (SSSP) en
grafos dirigidos ponderados bajo el modelo decremental (solo eliminaciones de aristas).
Históricamente, el algoritmo clásico de Even y Shiloach alcanzaba un tiempo total de
actualización de O(mn), considerado casi óptimo. El artículo presenta un marco que
reduce SSSP en grafos generales a SSSP en DAGs, introduciendo el concepto de orden
topológico aproximado.

*Metodología y aportes:*
- Desarrollo de una estructura de datos decremental con aproximación \(1 + \u{03B5}).
- Logran tiempos totales de actualización:

  $tilde(O) (n^2 log W/ \u{03B5})$

- Tiempo total en grafos dispersos:

  $tilde(O) (m n^(2/3) log^3 W / \u{03B5})$

- Sus algoritmos responden consultas de distancia en $O(1)$ y devuelven el camino en
  tiempo proporcional a su longitud.
- Supone un adversario *oblivious* y los resultados son aleatorizados.

*Conclusión:*
Constituye el primer algoritmo casi óptimo para decremental SSSP en grafos dirigidos
densos. El marco propuesto abre camino a futuras investigaciones en problemas dinámicos
de caminos más cortos, especialmente gracias a la reducción sistemática de grafos
generales a DAG.

=== #estado_arte_seccion("dong2021")

*Resumen:*
El problema de SSSP en paralelo es notoriamente complejo. El algoritmo Δ-stepping,
aunque ampliamente usado, carece de dos teóricas en el peor caso y depende fuertemente
de la elección del parámetro Δ. Este trabajo presenta un marco general de algoritmos de
*stepping* que unifica variantes como Δ-stepping y Radius-stepping, además de proponer
neuvas variantes: ρ-stepping y Δ\*-stepping

*Metodología y aportes:*
- Definición del ADT LaB-PQ para manejar extracciones por lotes de claves.
- Propuesta y análisis de *ρ-stepping* (sin necesidad de búsqueda exhaustiva de
  parámetros) y *Δ\*-stepping*.
- Resultados experimentales:
  - En grafos sociales/web: ρ-stepping fue 1.3x – 2.6x más rápido.
  - En grafos de carreteras: Δ\*-stepping obtuvo mejoras cercanas al 14%.

*Conclusión:*
El marco de stepping y LaB-PQ simplifica el diseño de algoritmos paralelos para SSSP y
ofrece tanto eficiencia práctica como garantías teóricas. Representa un avance
significativo respecto a Δ-stepping en escenarios reales

=== #estado_arte_seccion("rao2024")

*Resumen:*
Proponen *ACIC (Asynchronous Continuous Introspection and Control)*, un enfoque
asincrónico adaptativo para SSSP a gran escala que reduce sincronizaciones y trabajo
especulativo mediante histogramas globales y umbrales adaptativos.

*Metodología y aportes:*
- UACIC combina reducciones y broadcasts asincrónicos para ajustar dinámicamente
  parámetros de ejecución.
- Utiliza programación dirigida en Charm++ y una librería de agregación de mensajes
  (Tramlib).
- Propone umbrales adaptativos (tpq y ttram) para controlar el flujo de actualizaciones
  y reducir cálculos redundantes.
- Comparación experimental frente a Δ-stepping en dos tipos de grafos:
  - En grafos aleatorios, ACIC es 1.36x–1.90x más rápido.
  - En grafos scale-free, Δ-stepping sigue siendo 2.5x–3.5x más rápido debido a
    problemas de balance de carga.

*Conclusión:*
ACIC muestra gran potencial como enfoque asincrónico para SSSP en sistemas distribuidos
de gran escala, especialmente en grafos aleatorios. Aunque aún preliminares, sus
resultados indican la posibilidad de impactar a un rango mayor de algoritmos de grafo.

=== #estado_arte_seccion("bernstein2025")

*Resumen:*
El trabajo aborda el problema de caminos más cortos con pesos negativos desde una sola
fuente (SSSP), considerado abierto durante décadas. Algoritmos previos como Bellman-Ford
y los de escalamiento eran poco eficientes, mientras que los avances más recientes
dependían de técnicas algebraicas y de optimización continua, difíciles de implementar.
Los autores presentan el primer algoritmo combinatorio y simple con tiempo casi lineal
$O (m log^8 n log W)$ en expectativa, cerrando una brecha histórica en la teoría de
grafos.

*Metodología y aportes:*
- Uso de técnicas combinatorias puras (sin recurrir a optimización continua ni álgebra
  pesada).
- Introducción de nuevas descomposiciones de grafos y estrategias elementales de
  actualización.
- Comparación con algoritmos previos: conserva eficiencia casi lineal lograda por
  enfoques algebraicos, pero con implementación más sencilla.
- Primer avance significativo en más de 30 años hacia un SSSP negativo “práctico” en
  teoría algorítmica.

*Resultados:*
- Complejidad esperada $O (m log^8 n log W)$
- Supera a Bellman-Ford y a las técnicas escalamiento.
- Alcanzó simplicidad combinatoria comparable con la eficiencia de métodos algebraicos.

*Conclusión:*
El aporte redefine el estado del arte: demuestra que la eficiencia casi lineal para SSSP
con pesos negativos puede lograrse con herramientas combinatorias accesibles, reduciendo
la brecha entre teoría avanzada y aplicabilidad práctica.


/*** Jose ***/
=== #estado_arte_seccion("anagreh2021")
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
    r & = Omega: 0(n + log m) \
    r & = inf: O(log m) \
    r & = Delta: O(log n + log m) \
  $

=== #estado_arte_seccion("dhulipala2018")
Este trabajo demuestra que los algoritmos paralelos de grafos teóricamente eficientes
pueden procesar de manera eficaz grafos de gran escala, incluyendo el grafo web de
hipervínculos con 3.5 mil millones de vértices y 128 mil millones de aristas, en una
sola máquina compartida de memoria con un terabyte de RAM, en cuestión de minutos.

Los métodos empleados en este trabajo incluyen el desarrollo de una interfaz de alto
nivel para el procesamiento de grafos y la implementación de algoritmos paralelos
teóricamente eficientes para diversos problemas en grafos. Asimismo, el artículo
incorpora una primitiva de reducción para evitar contención y una suma prefija sobre A
con el fin de optimizar los algoritmos.

=== #estado_arte_seccion("wang2021")
El algoritmo sssp, presenta un nuevo algoritmo para el problema para el camino más corto
desde un único origen (SSSP) en GPU, lo que permite una implementación eficiente y de
alta calidad en GPU. Supera en rendimiento a soluciones previas, siendo hasta 2.9 veces
más rápida, en el cual analiza cómo implementar eficientemente algoritmos SSSP (como
Dijkstra, Bellman-Ford y delta-stepping) en GPU, destacando tres consideraciones clave:

- Gestión de memoria
- Sincronización
- Granularidad

Estrategias de gestión de acceso y organización de la cola de trabajo en GPU para
optimizar algoritmos SSSP:

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

=== #estado_arte_seccion("andreiana2020")

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
    image("./imgs/edge1.png"), image("./imgs/edge2.png"),
  )
]


=== #estado_arte_seccion("khanda2022")
- Busca resolver la ruta más corta desde un vértice origen a todos los demás en un grafo
  ponderado.

Su metodologia consiste en dos pasos principales:
- El primero, identificar en paralelo los subgrafos afectados por los cambios en los
  bordes.
- Segundo, actualizar estos subgrafos mediante un proceso iterativo que evita
  sincronizaciones garantizando convergencia a la solución óptima.


==== Algoritmos principales:

- *Dijkstra:* O(V²) secuencial, mantiene árbol SSSP con vértices no explorados en cola
  de prioridad.

- *Bellman-Ford:* Relaja todos los bordes iterativamente, maneja pesos negativos

==== Algoritmos paralelos recientes:
Enfoques basados en GPU y técnicas de actualización incremental.

==== Desafío actual:
Los algoritmos existentes luchan con:
- Escalabilidad para grafos masivos
- Paralelización eficiente
- Balance entre complejidad computacional y de memoria

#align(center)[
  #image("./imgs/vmfb.png")
]
*/
