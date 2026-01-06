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


// --- TÍTULO PRINCIPAL ---
= 4. MARCO TEÓRICO
// --- SECCIÓN A ---
== *Fundamentos de Teoría de Grafos*

=== Definición Formal y Ponderación
Una red de transporte se modela como un grafo dirigido $G = (V, E, w)$
@eswiki:grafos.

- *Vértices ($V$):* Conjunto finito de nodos con cardinalidad $n = |V|$.
- *Aristas ($E$):* Conjunto de pares ordenados $(u, v)$ que representan conexiones
  directas, con cardinalidad $m = |E|$.
- *Función de Peso ($w$):* Mapeo $w: E -> RR$ que asigna un costo a cada arista.

En el contexto de Duan et al. (2025) @ran2025 y Dijkstra, se asume $w(e) >= 0$. En el contexto de
Bernstein et al. (2025), se permite $w(e) < 0$, siempre que no existan ciclos negativos
alcanzables desde la fuente.

=== Densidad y Esparcimiento
La eficiencia de los algoritmos modernos depende de la relación entre $m$ y $n$. Se
define la densidad del grafo como $D = m / (n(n-1))$.

Las redes de transporte se clasifican como *grafos dispersos* (sparse graphs), donde
$m = O(n)$ o $m << n^2$. Esta propiedad topológica es la premisa fundamental para el
algoritmo de Duan et al. @ran2025, cuya complejidad $O(m log^(2/3) n)$ explota la baja
conectividad promedio para superar a los enfoques clásicos.

// --- SECCIÓN B ---
== *El Estándar Clásico y la "Barrera de Ordenamiento"*

=== Principio de Relajación (Dijkstra)
El algoritmo de Dijkstra @enwiki:dijkstra de basa en la propiedad de subestructura óptima y la relajación
de aristas. Para un nodo $v$, se mantiene una cota superior $d[v]$ de la distancia más
corta desde la fuente $s$. La relajación de una arista $(u, v)$ actualiza esta cota:

$ d[v] arrow.l min(d[v], d[u] + w(u, v)) $

El algoritmo garantiza la optimalidad al seleccionar siempre el nodo con la menor $d[v]$
tentativa usando una cola de prioridad.

=== La Barrera de Ordenamiento (Sorting Barrier)
Históricamente, se conjeturó que resolver SSSP en grafos dirigidos requería ordenar los
vértices por su distancia, imponiendo una cota inferior de $Omega(n log n)$ en el modelo
de comparación. Esta limitación teórica, conocida como la "Barrera de Ordenamiento",
sugiere que ningún algoritmo determinista podría ser más rápido que el tiempo necesario
para ordenar los nodos. La complejidad clásica $O(m + n log n)$ de Dijkstra refleja esta
barrera.

// --- SECCIÓN C ---
== *Nuevos Paradigmas Algorítmicos*

Para fundamentar la comparación de rendimientos en este proyecto, es necesario definir
los principios matemáticos que permiten a los nuevos algoritmos romper las barreras
clásicas.

=== Reducción de Frontera (Paradigma de Duan et al.)
El algoritmo de Duan et al. (2025) @ran2025 supera la barrera de ordenamiento mediante la técnica
de *Reducción de Frontera* (Frontier Reduction).

- *Concepto:* En lugar de mantener un orden total de todos los vértices activos en una
  cola de prioridad global, el algoritmo identifica un conjunto reducido de vértices
  "pivote" que aproximan la geometría del grafo.
- *Mecanismo:* El problema SSSP se reduce a problemas más pequeños denominados _Bounded
  Multi-Source Shortest Path_ (BMSSP). Matemáticamente, esto permite disminuir el tamaño
  de la frontera activa por un factor polinomial en cada nivel de recursión, evitando el
  costo logarítmico completo ($log n$) asociado al ordenamiento de nodos no críticos.
- *Complejidad Resultante:* $O(m log^(2/3) n)$.

=== Reponderación vía Funciones de Precio (Paradigma de Bernstein et al.)
Para grafos con pesos negativos, Bernstein et al. (2025) @bernstein2025 utilizan un enfoque
combinatorio basado en *Funciones de Precio* (Price Functions), inspirado en el
algoritmo de Johnson.

- *Definición:* Una función de precio es un mapeo $phi: V -> RR$. Se define el "peso
  reducido" de una arista como:
  $ w_phi (u, v) = w(u, v) + phi(u) - phi(v) $

  Si $phi$ es factible, entonces $w_phi (u, v) >= 0$ para toda arista.

- *Innovación:* El algoritmo utiliza una *Descomposición de Bajo Diámetro* (Low-Diameter
  Decomposition) para calcular estas funciones $phi$ de manera eficiente y casi-lineal,
  permitiendo transformar el problema de pesos negativos en una serie de instancias de
  pesos positivos resolubles con variantes de Dijkstra.

=== Asincronía y Ejecución Especulativa (Paradigma de Rao et al.)
En el contexto de alto rendimiento, Rao et al. (2024) @rao2024 desafían el modelo síncrono (donde
todos los procesadores esperan en barreras).

- *$Delta$-Stepping:* Los algoritmos paralelos clásicos dividen las distancias en
  "cubos" de ancho $Delta$. Los nodos en el cubo $[i Delta, (i+1) Delta]$ se procesan en
  paralelo.
- *Control Adaptativo (ACIC):* Rao introduce la *Introspección Continua*. En lugar de
  barreras rígidas, el algoritmo monitorea métricas globales (histogramas de actividad)
  para permitir la *Ejecución Especulativa*: procesar nodos de cubos futuros antes de
  terminar el actual. Esto introduce el riesgo de "trabajo desperdiciado" (re-cálculos
  de nodos si llega una mejor ruta tarde), pero matemáticamente se demuestra que, con
  umbrales adaptativos, la ganancia en paralelismo supera al costo del retrabajo.

// --- SECCIÓN D ---
== *Métricas de Evaluación de Rendimiento*

Para comparar objetivamente estos algoritmos heterogéneos, se definen las siguientes
métricas:

- *Tiempo de Ejecución ($T$):* Tiempo de reloj (_Wall-clock time_) desde el inicio hasta
  la convergencia del algoritmo.
- *Speedup ($S$):* Relación de mejora de velocidad del nuevo algoritmo ($T_("new")$)
  respecto a la línea base de Dijkstra ($T_("base")$):
  $ S = T_("base") / T_("new") $
- *Eficiencia de Trabajo:* Medida del número total de operaciones elementales
  (relajaciones de aristas) realizadas. En algoritmos especulativos (como el de Rao), la
  eficiencia disminuye si hay mucho retrabajo, aunque el tiempo total mejore por
  paralelismo.
- *Escalabilidad:* Capacidad del algoritmo para mantener su rendimiento al incrementar
  $n$ y $m$. Se evalúa observando la curva de crecimiento de $T$ en función del tamaño
  del grafo.

