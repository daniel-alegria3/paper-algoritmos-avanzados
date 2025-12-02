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
