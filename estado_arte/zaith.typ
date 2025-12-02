// #set page(width: 21cm, height: 29.7cm, margin: 2.5cm) // Modificar en 'caratula.typ' si se desea
// #set text(lang: "es") // Ya esta en 'caratula.typ'
// #set par(leading: 1.5em) // Modificar en 'caratula.typ' si desea
// #set par(justify: true, first-line-indent: 0em) // ya esta en 'caratula.typ

#import "./clib.typ": estado_arte_seccion

== #estado_arte_seccion("bernstein2020")

*Resumen:*  
Este trabajo aborda el problema del camino más corto desde una sola fuente (SSSP) en grafos dirigidos ponderados bajo el modelo decremental (solo eliminaciones de aristas). Históricamente, el algoritmo clásico de Even y Shiloach alcanzaba un tiempo total de actualización de O(mn), considerado casi óptimo. El artículo presenta un marco que reduce SSSP en grafos generales a SSSP en DAGs, introduciendo el concepto de orden topológico aproximado.

*Metodología y aportes:*  
- Desarrollo de una estructura de datos decremental con aproximación \(1 + \u{03B5}).  
- Logran tiempos totales de actualización:  

  $tilde(O) (n^2 log W/ \u{03B5})$

- Tiempo total en grafos dispersos:

  $tilde(O) (m n^(2/3) log^3 W / \u{03B5})$

- Sus algoritmos responden consultas de distancia en $O(1)$ y devuelven el camino en tiempo proporcional a su longitud.  
- Supone un adversario *oblivious* y los resultados son aleatorizados.

*Conclusión:*  
Constituye el primer algoritmo casi óptimo para decremental SSSP en grafos dirigidos densos. El marco propuesto abre camino a futuras investigaciones en problemas dinámicos de caminos más cortos, especialmente gracias a la reducción sistemática de grafos generales a DAG.

== #estado_arte_seccion("dong2021")

*Resumen:*  
El problema de SSSP en paralelo es notoriamente complejo. El algoritmo Δ-stepping, aunque ampliamente usado, carece de dos teóricas  en el peor caso y depende fuertemente de la elección del parámetro Δ. Este trabajo presenta un marco general de algoritmos de *stepping* que unifica variantes como Δ-stepping y Radius-stepping, además de proponer neuvas variantes:  ρ-stepping y Δ\*-stepping

*Metodología y aportes:*  
- Definición del ADT LaB-PQ para manejar extracciones por lotes de claves.  
- Propuesta y análisis de *ρ-stepping* (sin necesidad de búsqueda exhaustiva de parámetros) y *Δ\*-stepping*.  
- Resultados experimentales:  
  - En grafos sociales/web: ρ-stepping fue 1.3x – 2.6x más rápido.  
  - En grafos de carreteras: Δ\*-stepping obtuvo mejoras cercanas al 14%.

*Conclusión:*  
El marco de stepping y LaB-PQ simplifica el diseño de algoritmos paralelos para SSSP y ofrece tanto eficiencia práctica como garantías teóricas. Representa un avance significativo respecto a Δ-stepping en escenarios reales

== #estado_arte_seccion("rao2024")

*Resumen:*  
Proponen *ACIC (Asynchronous Continuous Introspection and Control)*, un enfoque asincrónico adaptativo para SSSP a gran escala que reduce sincronizaciones y trabajo especulativo mediante histogramas globales y umbrales adaptativos.

*Metodología y aportes:*  
- UACIC combina reducciones y broadcasts asincrónicos para ajustar dinámicamente parámetros de ejecución.  
- Utiliza programación dirigida en Charm++ y una librería de agregación de mensajes (Tramlib).
- Propone umbrales adaptativos (tpq y ttram) para controlar el flujo de actualizaciones y reducir cálculos redundantes.
- Comparación experimental frente a Δ-stepping en dos tipos de grafos: 
  - En grafos aleatorios, ACIC es 1.36x–1.90x más rápido.
  - En grafos scale-free, Δ-stepping sigue siendo 2.5x–3.5x más rápido debido a problemas de balance de carga.

*Conclusión:*  
ACIC muestra gran potencial como enfoque asincrónico para SSSP en sistemas distribuidos de gran escala, especialmente en grafos aleatorios. Aunque aún preliminares, sus resultados indican la posibilidad de impactar a un rango mayor de algoritmos de grafo.

== #estado_arte_seccion("bernstein2025")

*Resumen:*  
El trabajo aborda el problema de caminos más cortos con pesos negativos desde una sola fuente (SSSP), considerado abierto durante décadas. Algoritmos previos como Bellman-Ford y los de escalamiento eran poco eficientes, mientras que los avances más recientes dependían de técnicas algebraicas y de optimización continua, difíciles de implementar. Los autores presentan el primer algoritmo combinatorio y simple con tiempo casi lineal $O (m log^8 n log W)$ en expectativa, cerrando una brecha histórica en la teoría de grafos.

*Metodología y aportes:*  
- Uso de técnicas combinatorias puras (sin recurrir a optimización continua ni álgebra pesada).
- Introducción de nuevas descomposiciones de grafos y estrategias elementales de actualización.
- Comparación con algoritmos previos: conserva eficiencia casi lineal lograda por enfoques algebraicos, pero con implementación más sencilla.
- Primer avance significativo en más de 30 años hacia un SSSP negativo “práctico” en teoría algorítmica.

*Resultados:*
- Complejidad esperada $O (m log^8 n log W)$
- Supera a Bellman-Ford y a las técnicas escalamiento. 
- Alcanzó simplicidad combinatoria comparable con la eficiencia de métodos algebraicos. 

*Conclusión:*  
El aporte redefine el estado del arte: demuestra que la eficiencia casi lineal para SSSP con pesos negativos puede lograrse con herramientas combinatorias accesibles, reduciendo la brecha entre teoría avanzada y aplicabilidad práctica.