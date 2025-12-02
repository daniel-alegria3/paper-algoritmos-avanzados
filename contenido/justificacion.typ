/*
La justificación consiste en fundamentar la importancia del problema que aborda y la
necesidad de realizar el trabajo práctico para hallar la solución al mismo.

La función principal es exponer las diferentes razones (impacto, beneficios, aportes
teóricos, cambios o relevancias social) por las que es plausible llevar a cabo dicho
trabajo - más información ver guía.
*/

= Justificacion

La optimización de rutas en redes de transporte público representa un desafío crítico en
la ingeniería moderna, dado el impacto directo que tiene sobre la eficiencia operativa
de las ciudades y la calidad de vida de los usuarios. El problema de encontrar la ruta
más eficiente se modela matemáticamente como el problema de caminos más cortos con
fuente única (SSSP), una de las áreas más estudiadas en la teoría de grafos y las
ciencias de la computación.

Históricamente, el algoritmo de Dijkstra ha sido el estándar para resolver este
problema, ofreciendo una solución exacta con una complejidad temporal de
$O(m + n log n)$. Sin embargo, el crecimiento exponencial de los datos en sistemas de
transporte masivo y la necesidad de respuestas en tiempo real exigen explorar nuevas
fronteras algorítmicas. Recientemente, se han logrado avances teóricos significativos,
destacando el desarrollo de un algoritmo determinista en el modelo de comparación y suma
que opera en un tiempo de $O(m log^(2/3) n)$.

Esta investigación se justifica por la necesidad imperativa de validar empíricamente si
este avance teórico, que promete superar a Dijkstra específicamente en grafos dispersos,
se traduce en una mejora tangible al ser aplicado a la topología propia de las redes de
transporte público. Dado que las redes viales y de transporte se comportan
estructuralmente como grafos dispersos (donde $m << n^2$), la evaluación de este nuevo
algoritmo podría representar un cambio de paradigma en la planificación de itinerarios
urbanos. Por lo tanto, este estudio no solo busca cerrar la brecha entre la teoría de
complejidad reciente y la ingeniería aplicada, sino también evaluar la viabilidad
práctica y las limitaciones de implementar soluciones de complejidad subóptima en
entornos reales.
