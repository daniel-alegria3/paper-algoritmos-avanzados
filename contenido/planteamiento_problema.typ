/*
La problemática inicia cuando el sujeto detecta una necesidad concreta, falta de
conocimiento o una contradicción entre los enfoques disponibles.

El problema de investigación se refiere a al descripción amplia y detallada de una
realidad en la cual diversas variables o factores se relacionan, hechos-causas y
consecuencias, y se concluye con una pregunta de investigación, que en esencia es la
síntesis de la situación descrita. Es la conclusión a la que se llega después de haber
descrito la situación problemática

== Descripción del problema
== Identificación del problema
== Formulación del problema

=== Problema General
Se sugiere que sea el titulo de la tesis en forma de pregunta. Se hace una pregunta la
cual es respondida por la tesis. ¿Qué es lo difícil?

=== Problemas Especificos
(Se sugiere que sean pocos pero sustanciales) El estudio toma en cuenta los siguientes
problemas específicos:

- Primer problema especifico.
- Segundo problema especifico.
- Tercer problema especifico.
*/

= Problema de Investigación

== Descripción del problema

La optimización de rutas en redes de transporte público representa un desafío crítico en
la ingeniería moderna, dado el impacto directo que tiene sobre la eficiencia operativa
de las ciudades y la calidad de vida de los usuarios. El problema de encontrar la ruta
más eficiente se modela matemáticamente como el problema de caminos más cortos con
fuente única (SSSP), una de las áreas más estudiadas en la teoría de grafos y las
ciencias de la computación. Históricamente, el algoritmo de Dijkstra ha sido el
estándar para resolver este problema, ofreciendo una solución exacta con una
complejidad temporal de $O(m + n log n)$. Sin embargo, el crecimiento exponencial de
los datos en sistemas de transporte masivo y la necesidad de respuestas en tiempo real
exigen explorar nuevas fronteras algorítmicas. Recientemente, se han logrado avances
teóricos significativos, destacando el desarrollo de un algoritmo determinista en el
modelo de comparación y suma que opera en un tiempo de $O(m log^(2/3) n)$.

== Identificación del problema

El problema central radica en la brecha existente entre los avances teóricos en
algoritmos SSSP y su validación empírica en aplicaciones prácticas, particularmente en
grafos dispersos que caracterizan las redes de transporte público. A pesar de las
promesas de complejidad subóptima, no existe evidencia concluyente de que estos
algoritmos superen consistentemente a Dijkstra en escenarios reales, considerando
factores como la escalabilidad, el rendimiento práctico y las limitaciones
computacionales.

== Formulación del problema

=== Problema General
¿De qué manera el algoritmo determinista con complejidad $O(m log^(2/3) n)$ supera al
algoritmo de Dijkstra en términos de rendimiento empírico y escalabilidad en grafos
dispersos representativos de redes de transporte público?

=== Problemas Específicos
- ¿Cuáles son las diferencias prácticas en tiempo de ejecución y escalabilidad entre el
  algoritmo $O(m log^(2/3) n)$ y Dijkstra al procesar grafos dispersos y densos que
  simulan redes de transporte?
- ¿En qué contextos específicos de grafos dispersos el nuevo algoritmo demuestra
  ventajas significativas sobre Dijkstra?
- ¿Cuáles son las limitaciones inherentes de estos algoritmos que afectan su
  implementación en sistemas de transporte reales con pesos estáticos?
