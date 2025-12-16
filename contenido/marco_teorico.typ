/*
(En este apartado el estudiante debe presentar en forma breve los temas que se abordarán
en el marco teórico. El marco teórico se desprende de las palabras clave y del titulo.
Debe ser totalmente acotado. Ésta sección describe conceptos relacionados a
procesamiento de trayectorias y detección de trayectorias anómalas .

La teoría general está constituida por un conjunto de proposiciones lógicamente
interrelacionadas que se utilizan para explicar procesos y fenómenos. Este marco
conceptual implica una visión de la

sociedad, del lugar que las personas ocupan en ella y las características que asumen las
relaciones entre el todo y las partes. Al llevar implícitos los supuestos acerca del
carácter de la sociedad, la teoría social, al igual que el paradigma, también influyen
acerca de lo que puede o no ser investigado, condiciona las preguntas que nos hacemos y
el modo en que intentamos responderlas.

Destaca la estrecha relación que existe entre teoría, práctica, proceso de
investigación, realidad, entorno, y revela las teorías y evidencias empíricas
relacionadas con la investigación (estado del arte). La investigación puede iniciar una
teoría nueva, reformar una existente o simplemente definir con más claridad, conceptos o
variables ya existentes.

== Primer subtitulo
Aquí debe llenar tu contenido

== Segundo subtitulo
Segundo contenido, etc.
*/

= Marco Teórico
Esta sección describe los fundamentos matemáticos y computacionales necesarios para el
análisis de la optimización de rutas. Se abordan conceptos relacionados con la teoría de
grafos aplicada a redes de transporte, la definición formal del problema de caminos
mínimos y la clasificación de los algoritmos deterministas según su complejidad
asintótica en el modelo de comparación y suma.

== Modelado de Redes de Transporte mediante Grafos

La abstracción matemática de una red de transporte público es un requisito fundamental
para la aplicación de algoritmos de optimización. En el contexto de esta investigación,
el sistema se modela formalmente como un *grafo dirigido y ponderado*, denotado por la
terna $G = (V, E, w)$.

/*
A continuación, se detallan los componentes de este modelo algebraico:

+ *Conjunto de Vértices ($V$):* Representa los puntos de interés discretos dentro de la
  red. En el dominio del transporte público, cada vértice $v_i in V$ corresponde a una
  entidad física georreferenciada, tal como un paradero de autobús, una estación de
  metro o una intersección vial crítica. La cardinalidad del conjunto se denota como
  $n = |V|$, definiendo el tamaño del espacio de búsqueda en términos de locaciones.

+ *Conjunto de Aristas ($E$):* Representa las conexiones directas entre los vértices.
  Dado que el flujo del transporte tiene un sentido específico (rutas de ida y vuelta o
  calles de sentido único), $E$ se define como un subconjunto del producto cartesiano
  $V times V$. Cada arista es un par ordenado $e = (u, v) in E$, que indica la
  existencia de un tramo transitable directamente desde el nodo $u$ hacia el nodo $v$.
  La cardinalidad de este conjunto es $m = |E|$.

+ *Función de Peso ($w$):* Para resolver el problema de caminos mínimos, es necesario
  cuantificar el "costo" de transitar por una arista. Se define una función de
  ponderación no negativa $w: E -> RR^+ union {0}$. El valor $w(u, v)$ representa la
  impedancia del arco, la cual puede modelar:
  - La distancia física (en kilómetros).
  - El tiempo de viaje esperado (considerando velocidad promedio).
  - El costo monetario del trayecto.

  La condición de no negatividad ($w(e) >= 0$) es una restricción teórica necesaria para
  garantizar la corrección del algoritmo de Dijkstra (1959), el cual no procesa
  correctamente ciclos negativos.

=== Topología y Densidad del Grafo
Un aspecto crítico para el análisis de complejidad computacional en este proyecto es la
*densidad del grafo*. Las redes de transporte urbano exhiben una topología particular
que las diferencia de otros tipos de redes (como las redes sociales o redes web).

Se clasifican matemáticamente como *grafos dispersos* (_sparse graphs_). Esta propiedad
implica que el número de aristas $m$ es proporcional al número de nodos $n$, cumpliendo
la condición asintótica:

$ m << n^2 $

En una red de transporte real, un paradero específico solo está conectado físicamente
con sus paraderos adyacentes inmediatos (el anterior y el siguiente en la ruta), y no
con todos los demás paraderos de la ciudad. Por lo tanto, el *grado promedio* de los
nodos es bajo y constante, independientemente del tamaño total de la ciudad.

Esta característica es la justificación central para comparar el algoritmo de Dijkstra,
cuya complejidad es $O(m + n log n)$, frente a nuevos avances teóricos diseñados
específicamente para grafos dispersos con complejidad $O(m log^(2/3) n)$. En grafos
densos (donde $m approx n^2$), la ventaja de los algoritmos de complejidad subóptima se
diluiría; sin embargo, en la topología dispersa del transporte público, la reducción en
el término logarítmico promete una optimización significativa en el tiempo de
procesamiento de trayectorias.
*/

== Problema del Camino Más Corto con Fuente Única (SSSP)

El problema SSSP (_Single-Source Shortest Path_) constituye el núcleo algorítmico de los
sistemas de navegación y planificación de transporte. Formalmente, dado un grafo
$G=(V, E, w)$ y un nodo origen distinguido $s in V$, el objetivo es determinar una ruta
$P$ hacia cada nodo destino $v in V$ tal que la suma de los pesos de sus aristas
constituyentes sea mínima.

Una *trayectoria* o camino desde el vértice $v_0$ hasta $v_k$ se define como una
secuencia de vértices $P = chevron.l v_0, v_1, ..., v_k chevron.r$ tal que
$(v_(i-1), v_i) in E$ para todo $i=1, ..., k$. El costo total de dicha trayectoria,
denotado como $w(P)$, es la suma de los costos de sus enlaces individuales:

$ w(P) = sum_(i=1)^k w(v_(i-1), v_i) $

La distancia del camino más corto desde el origen $s$ hasta un vértice $v$, denotada por
$delta(s, v)$, se define como el mínimo costo posible entre todas las trayectorias
existentes que conectan $s$ con $v$. Si no existe camino, la distancia se considera
infinita:

$
  delta(s, v) = cases(
    min {w(P) : s arrow.squiggly v} & "si existe camino",
    infinity & "en caso contrario"
  )
$

En el contexto de esta investigación, la restricción de pesos no negativos
($w(u,v) >= 0$) es axiomática, dado que variables físicas como el tiempo o la distancia
no pueden adoptar valores negativos. Esta propiedad es la que habilita el uso de
algoritmos de enfoque voraz como Dijkstra, descartando la necesidad de algoritmos más
costosos como Bellman-Ford.

== Algoritmos Clásicos: El Estándar de Dijkstra

Propuesto originalmente por Edsger W. Dijkstra en 1959, este algoritmo se ha consolidado
como el método determinista estándar para resolver el SSSP en grafos sin pesos
negativos. Su funcionamiento se basa en una estrategia voraz (_greedy_) que mantiene un
conjunto $S$ de vértices cuya distancia final mínima desde la fuente ya ha sido
determinada.

/*
=== Mecanismo de Relajación
El principio fundamental que gobierna la convergencia del algoritmo es la *relajación de
aristas*. Para cada nodo $v$, se mantiene un atributo $d[v]$ que representa la cota
superior de la distancia del camino más corto hallado hasta el momento. La relajación de
una arista $(u, v)$ consiste en verificar si es posible mejorar el camino hacia $v$
pasando a través de $u$:

$
  "Si " d[v] > d[u] + w(u, v) arrow.r cases(
    d[v] = d[u] + w(u, v),
    pi[v] = u
  )
$

Donde $pi[v]$ denota el predecesor de $v$ en el árbol de caminos mínimos. El algoritmo
selecciona iterativamente el nodo $u in V - S$ con el menor valor de $d[u]$, lo añade a
$S$ y relaja todas sus aristas salientes.

=== Análisis de Complejidad Computacional
La eficiencia del algoritmo de Dijkstra depende críticamente de la estructura de datos
utilizada para implementar la cola de prioridad que gestiona los vértices no visitados.
Se distinguen dos implementaciones principales relevantes para este estudio:

+ *Implementación con Montículos Binarios (_Binary Heaps_):*
  Es la implementación más común en librerías estándar. Las operaciones de extracción
  del mínimo y actualización de claves toman tiempo logarítmico. Su complejidad total es
  $O(m log n)$. En grafos dispersos (donde $m approx n$), esto es muy eficiente, pero el
  factor $log n$ se aplica a todas las aristas.

+ *Implementación con Montículos de Fibonacci (_Fibonacci Heaps_):*
  Teóricamente más avanzada, permite realizar la operación de disminución de clave
  (_decrease-key_) en tiempo amortizado constante $O(1)$. Esto reduce la complejidad
  asintótica a:
  $ O(m + n log n) $

Este análisis es crucial para la justificación del proyecto: en grafos extremadamente
masivos y dispersos, incluso el término $log n$ asociado a $n$ puede ser significativo.
La propuesta de comparar esta línea base contra algoritmos de complejidad
$O(m log^(2/3) n)$ busca demostrar si la reducción en el exponente logarítmico se
traduce en una ventaja tangible para la ingeniería de transporte a gran escala.
*/

== Algoritmos de Complejidad Subóptima y Avances Recientes

En las últimas décadas, la investigación teórica se ha centrado en romper la barrera del
tiempo lineal en modelos de computación específicos. Recientemente, se han desarrollado
algoritmos deterministas en el modelo de *comparación y suma* que logran tiempos de
ejecución más ajustados para grafos dispersos.

El algoritmo objeto de estudio en esta investigación presenta una complejidad de:

$ O(m log^(2/3) n) $

Este avance teórico es significativo porque, matemáticamente, $log^(2/3) n$ crece más
lentamente que $log n$. Por lo tanto, en escenarios donde el número de nodos $n$ es
masivo y la red es dispersa, este algoritmo supera teóricamente a la implementación
clásica de Dijkstra, representando el estado del arte en algoritmos deterministas para
este dominio específico.

== Métricas de Evaluación de Rendimiento

Para validar la aplicabilidad práctica de los algoritmos teóricos en sistemas de
ingeniería real, se deben considerar dos dimensiones de análisis:

- *Complejidad Asintótica (Teórica):* Evaluación del comportamiento del algoritmo
  mediante la notación Big-O ($O$), analizando cómo escala el número de operaciones
  elementales a medida que $n$ y $m$ tienden al infinito.

- *Tiempo de Ejecución (Empírica):* Medición del tiempo de CPU (en milisegundos)
  requerido para calcular las rutas en grafos de prueba. Esta métrica es sensible a las
  constantes ocultas en la notación Big-O y a la arquitectura del hardware, siendo
  crucial para determinar si la ventaja teórica es perceptible en aplicaciones de la
  vida real como la planificación de itinerarios de transporte.
