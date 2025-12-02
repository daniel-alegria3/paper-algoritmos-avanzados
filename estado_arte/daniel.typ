#import "./clib.typ": estado_arte_seccion

== #estado_arte_seccion("ran2025")
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


== #estado_arte_seccion("ran2023")
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



== #estado_arte_seccion("gan2024")
Este trabajo presenta TianheStar, un motor ultra-rápido para SSSP diseñado para
búsquedas en grafos sobre la supercomputadora Tianhe. Se demuestra que puede recorrer la
red carretera de EE. UU. en menos de 0.1 segundos.

Los experimentos muestran que el sistema TianheGraph alcanza un rendimiento
sobresaliente en cómputo de grafos dentro del entorno exaescala de Tianhe. Además, los
resultados en el benchmark Graph500 confirman su eficacia, superando a otros sistemas
como Tianhe-2 y K computer.



== #estado_arte_seccion("bringmann2023")
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
$O((m + n log log n) log^2 n log(n W))$ con alta probabilidad, y detecta ciclos negativos
cuando existen.


== #estado_arte_seccion("kumawat2021")
Este estudio demuestra que el rendimiento varía entre los distintos algoritmos que
resuelven variantes del problema shortest path (SPP).

Se realiza una revisión de la literatura sobre algoritmos clásicos, analizando su
complejidad temporal y desempeño. También se aplican técnicas de teoría de grafos para
modelar y resolver instancias de SPP. Además, se implementan y comparan métodos como
Dijkstra, Bellman-Ford y enfoques híbridos basados en algoritmos genéticos y de colonia
de hormigas, evaluando métricas como tiempo y precisión.



== #estado_arte_seccion("alves2020")
Este trabajo también examina la variabilidad de desempeño entre diferentes
algoritmos de
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
