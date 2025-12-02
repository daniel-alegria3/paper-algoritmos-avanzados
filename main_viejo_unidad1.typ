// =======================
// CONTENIDO
// =======================

= INTRODUCCIÓN
---
El problema de los caminos más cortos desde una sola fuente (SSSP, por sus
siglas en inglés) constituye un pilar fundamental dentro de la teoría de grafos
y de la informática teórica. Su importancia trasciende lo académico, pues
encuentra aplicaciones directas en redes de comunicación, sistemas de
transporte, optimización de recursos, biología computacional, entre otros
campos. Desde mediados del siglo XX, algoritmos como Dijkstra y Bellman-Ford han
servido como referentes clásicos para abordar esta tarea, ofreciendo soluciones
prácticas aunque limitadas en ciertos escenarios, como la presencia de aristas
con pesos negativos o la necesidad de procesar grafos de gran tamaño.

En las últimas décadas, el desarrollo de nuevos algoritmos ha buscado superar
estas limitaciones. Destacan los enfoques de escalamiento y optimización
algebraica, que permitieron obtener complejidades subcuadráticas e incluso
cercanas a lineales, aunque a costa de un alto nivel de complejidad técnica y
dificultades en la implementación. Recientemente, algoritmos deterministas como
el de complejidad $O(m log^(2/3) n)$ han emergido como alternativas
prometedoras, ofreciendo una mejora significativa respecto a Dijkstra en ciertos
contextos, y acercando la posibilidad de un rendimiento más uniforme en
diferentes tipos de grafos.

En este marco, el presente proyecto tiene como propósito analizar
comparativamente el algoritmo determinista de complejidad $O(m log^(2/3) n)$
frente a Dijkstra y otros algoritmos presentes en la bibliografía actual. El
estudio no se limitará a un contraste teórico, sino que explorará también sus
aplicaciones potenciales en grafos dispersos y densos, evaluando tanto sus
ventajas como sus limitaciones. Con ello, se busca aportar una visión crítica
que contribuya a comprender mejor el estado actual del problema SSSP y las
perspectivas que ofrecen los avances recientes para el diseño de algoritmos más
eficientes.

= ASPECTOS GENERALES

== DESCRIPCIÓN DEL PROBLEMA
El problema de los caminos más cortos desde una sola fuente (SSSP) constituye
uno de los tópicos más relevantes en la teoría de algoritmos y en aplicaciones
prácticas de grafos. A lo largo de décadas, algoritmos como Dijkstra y
Bellman-Ford han sido los referentes principales para su resolución, aunque cada
uno presenta limitaciones: el primero no maneja aristas con pesos negativos y el
segundo resulta ineficiente en grafos grandes debido a su alta complejidad. En
años recientes se han propuesto enfoques más avanzados, incluyendo algoritmos
deterministas con complejidad mejorada como el de $O(m log^(2/3) n)$, que abren
nuevas posibilidades de eficiencia en contextos distribuidos y de gran escala.
Sin embargo, persiste la necesidad de comparar rigurosamente estos métodos
frente a los algoritmos clásicos, evaluando no solo la complejidad teórica sino
también su rendimiento en distintos tipos de grafos (dispersos, densos, con
pesos negativos o positivos). Esta brecha de análisis motiva la presente
investigación, orientada a determinar en qué escenarios los avances recientes
superan efectivamente a las soluciones tradicionales.

= OBJETIVOS
== OBJETIVO GENERAL
Comparar el algoritmo deterministe con complejidad $O(m log^(2/3) n)$ para SSSP
con el algoritmo de Dijkstra y otros algoritmos presentes en la bibliografía
actual, evaluando sus ventajas en distintos contextos. 

== OBJETIVOS ESPECÍFICOS
- Analizar la complejidad computacional y fundamentos teóricos de los algoritmos de SSSP clásicos y recientes. 
- Identificar en qué escenarios prácticos el algoritmo $O(m log^(2/3) n)$ supera a Dijkstra. 
- Revisar los aportes más recientes en la literatura sobre algoritmos de caminos más cortos. 
- Evaluar críticamente las limitaciones y posibles aplicaciones de estos
  algoritmos en grafos dispersos y densos. 

= Algoritmo SSSP de complejidad $O(m log^(2/3) n)$
== Resumen del algoritmo
El problema de _single-source shortest paths_ (SSSP) en grafos dirigidos
con pesos no negativos ha sido históricamente dominado por el algoritmo de
Dijkstra, cuya complejidad óptima conocida en el modelo de comparación-adición
es $O(m + n log n)$ cuando se emplean estructuras avanzadas de colas de
prioridad como los heaps de Fibonacci. Sin embargo, esta cota está
intrínsecamente limitada por la denominada _sorting barrier_, es decir, la
necesidad de mantener un orden total sobre los vértices.

En este trabajo se introduce el primer algoritmo determinista para SSSP en
grafos dirigidos que rompe dicha barrera, alcanzando una complejidad temporal de $O(m log^(2/3) n)$

=== Ideas Fundamentales
El diseño del algoritmo combina características de Dijkstra y Bellman-Ford
mediante un enfoque recursivo de _divide-and-conquer_. La estrategia
central consiste en reducir el tamaño de la frontera de vértices que deben
procesarse, evitando mantener un orden total entre todos ellos:

- *Reducción de frontera:* 
  en lugar de manipular una cola de prioridad de tamaño potencialmente
  $Theta(n)$, se selecciona un subconjunto de _pivotes_, cuya cardinalidad
  se limita a $abs(U) / (log^(Omega(1)) n)$ para un conjunto de interés $U$.
    
- *Subrutina BMSSP:*
  se define un problema auxiliar denominado *Bounded Multi-Source Shortest
  Path*, que extiende la relajación de Bellman-Ford pero acotada por un límite
  superior $B$ en las distancias. Esta subrutina asegura el progreso eficiente
  al completar bloques de vértices.

- *Parámetros óptimos:*
  fijando $k = floor(log^(1/3) n)$ y $t = floor(log^(2/3) n)$, la recursión
  alcanza una profundidad de $O(log^(1/3) n)$, garantizando la cota de $O(m
  log^(2/3) n)$.

== Comparacion inicial con el Algoritmo de Dijkstra
#figure(
  caption: [Comparación entre Dijkstra y el nuevo algoritmo],
  table(
    columns: (1fr, 1.5fr, 1.7fr),
    align: (left, left, left),
    table.header([*Aspecto*], [*Dijkstra*], [*Algoritmo $O(m log^(2/3) n)$*]),
    [Complejidad], [$O(m + n log n)$], [$O(m log^(2/3) n)$],
    [Determinismo], [Sí], [Sí],
    [Modelo], [Comparación-adición], [Comparación-adición],
    [Técnica clave], [Cola de prioridad con orden total], [Reducción de frontera + recursión],
    [Limitación], [Barrera de ordenamiento $n log n$], [Rompe la barrera],
  )
)

== Discusión

En grafos dispersos ($m = Theta(n)$), el nuevo algoritmo supera de manera
asintótica a Dijkstra, reduciendo la complejidad de $O(n log n)$ a $O(n
log^(2/3) n)$. Esto demuestra que, en el modelo de comparación-adición,
Dijkstra no es óptimo para SSSP en grafos dirigidos, y establece un nuevo
paradigma donde la ordenación total ya no es un requisito indispensable.


= ESTADO DEL ARTE
#include "./estado_arte/daniel.typ"
#include "./estado_arte/zaith.typ"
#include "./estado_arte/jose.typ"

#bibliography("refs.bib", title: "BIBLIOGRAFÍA", full: true)