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

// --- TÍTULO PRINCIPAL ---
= ANTECEDENTES

// --- SUBSECCIÓN A ---
== *Evolución Reciente del Problema*

Históricamente, el algoritmo de Dijkstra ha dominado la resolución del problema de caminos más cortos (SSSP) con una complejidad de $O(m + n log n)$. Sin embargo, en los últimos años (2024-2025), la investigación ha roto barreras teóricas que permanecieron estancadas durante décadas, tanto en algoritmos deterministas secuenciales como en enfoques paralelos y de pesos negativos.

// --- SUBSECCIÓN B ---
== *Trabajos Relacionados*

// PAPER 1: DUAN
=== *Duan et al. (2025): Breaking the Sorting Barrier for Directed Single-Source Shortest Paths*
#v(1em)
*Resumen:*
Este trabajo presenta el primer algoritmo determinista en el modelo de comparación y suma que logra romper la barrera de clasificación de Dijkstra para grafos dirigidos con pesos no negativos. Los autores desafían la creencia de que el ordenamiento total de vértices es estrictamente necesario.

*Metodología y aportes:*
- El núcleo de su propuesta es la reducción del problema SSSP a una variante denominada _Bounded Multi-Source Shortest Path_ (BMSSP). A diferencia de Dijkstra, que mantiene una cola de prioridad global, este enfoque particiona recursivamente el grafo y utiliza un conjunto de "pivotes" para estimar distancias.
- Introducen una técnica innovadora de reducción de fronteras que disminuye el tamaño del conjunto de vértices activos mediante un factor polinomial en cada paso recursivo. Esto permite que el algoritmo "salte" pasos de ordenamiento innecesarios, procesando bloques de nodos de manera más eficiente que la extracción uno a uno de un montículo binario tradicional.
- Implementan una estructura jerárquica de "buckets" (cubetas) aproximados para evitar el cuello de botella de la cola de prioridad.

*Resultados:*
- Se logra una complejidad temporal de $O(m log^(2/3) n)$.
- Este resultado es asintóticamente superior a la cota clásica de $O(m + n log n)$ en grafos dispersos, marcando el primer avance determinista en este ámbito en más de 60 años.

*Conclusión:*
El algoritmo de Dijkstra no es óptimo para SSSP en grafos dispersos. Es posible superar sus limitaciones teóricas mediante estructuras jerárquicas que evitan el ordenamiento total, abriendo una nueva vía para algoritmos deterministas de alta eficiencia.

#v(1em)

// PAPER 2: BERNSTEIN
=== *Bernstein et al. (2025): Negative-Weight Single-Source Shortest Paths in Near-Linear Time*
#v(1em)
*Resumen:*
El estudio aborda el problema SSSP en grafos con pesos negativos, históricamente considerado mucho más difícil que el caso estándar. Los autores buscan superar la barrera de complejidad que obligaba a usar algoritmos lentos como Bellman-Ford o métodos de escalado complejos.

*Metodología y aportes:*
- La importancia de este avance yace en su naturaleza puramente combinatoria, contrastando con intentos previos que dependían de métodos de optimización continua o álgebra matricial pesada. Emplean una Descomposición de Bajo Diámetro (_Low-Diameter Decomposition_) adaptada a grafos dirigidos.
- Implementan un esquema de funciones de precio (_price functions_) para reponderar aristas dinámicamente. Esta estrategia permite eliminar temporalmente los pesos negativos sin alterar los caminos más cortos, permitiendo aplicar técnicas similares a Dijkstra en subgrafos locales y corregir posteriormente las distancias globales mediante sincronización de fases.

*Resultados:*
- Alcanzan un tiempo de ejecución de $O(m log^(0.8) n log W)$, considerado "casi lineal".
- Rompen la barrera de $O(m sqrt(n))$ que había permanecido vigente desde 1989 (Gabow y Tarjan), logrando una mejora de casi seis factores logarítmicos en eficiencia.

*Conclusión:*
La eficiencia casi lineal para SSSP con pesos negativos es alcanzable mediante herramientas combinatorias simples. Esto cierra la brecha histórica entre grafos con pesos positivos y negativos.

#v(1em)

// PAPER 3: RAO
=== *Rao et al. (2024): An Adaptive Asynchronous Approach for the Single-Source Shortest Paths Problem*
#v(1em)
*Resumen:*
Este artículo propone ACIC (_Asynchronous Continuous Introspection and Control_), un enfoque diseñado para la escalabilidad en sistemas de computación paralela masiva. Se centra en resolver los problemas de sincronización excesiva de algoritmos tradicionales como $Delta$-stepping.

*Metodología y aportes:*
- Introducen un mecanismo de introspección continua que monitorea métricas del sistema en tiempo real para ajustar adaptativamente los umbrales de control ($t_("pq")$ y $t_("tram")$). En lugar de detener el procesamiento para sincronizar todos los hilos (lo que genera cuellos de botella), el algoritmo utiliza histogramas globales aproximados.
- Este diseño permite una ejecución asíncrona controlada, decidiendo dinámicamente cuándo propagar actualizaciones de distancia. Esto reduce drásticamente el "trabajo especulativo" o desperdiciado (re-cálculos de rutas subóptimas) que es común en enfoques asíncronos puros.

*Resultados:*
- En grafos aleatorios grandes, ACIC supera a las implementaciones estándar de $Delta$-stepping con una aceleración de 1.36x a 1.90x.
- Mantiene la escalabilidad en sistemas distribuidos minimizando el tráfico de mensajes.

*Conclusión:*
La adaptación dinámica y la asincronía controlada son superiores a la sincronización estática en entornos de alto rendimiento. El enfoque ACIC demuestra gran potencial para supercomputadoras y clústeres masivos.
