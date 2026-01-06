= Experimentación y Análisis de Resultados

Se ejecutaron los algoritmos en una zona de fácil prueba, con un terreno plano sin
muchas irregularidades. Cada prueba comenzó con distancias cortas e incrementó
progresivamente hasta alcanzar aproximadamente 300 kilómetros.

#figure(
  image("./imgs/algo_comparacion_grafico.png"),
  caption: [Comparación de tiempo, distancia y nro. de nodos de los algoritmos],
)

#figure(
  table(
    columns: (1fr, 1fr),
    align: (left, right),
    table.header([*Algoritmo*], [*Tiempo (ms)*]),
    [Dijkstra (Binary Heap)], [41.38],
    [Ran et al. (2025)], [46.15],
    table.hline(),
  ),
  caption: [Promedio de cada prueba],
)

Los resultados obtenidos en las 13 pruebas realizadas muestran un comportamiento
consistente de ambos algoritmos, permitiendo una comparación clara de su eficiencia en
diferentes escenarios de complejidad creciente.

/*
== Análisis de Resultados

=== Rendimiento en Velocidad

El algoritmo de Dijkstra con heap binario ejecuta en promedio 41.38 ms, mientras que Ran
et al. requiere 46.15 ms, representando una mejora del 11.5% en tiempo de ejecución.
Esta ventaja se acentúa significativamente en grafos de mayor tamaño: en la prueba 3,
Dijkstra es 3.9 veces más rápido (20 ms vs 78 ms).

=== Calidad de las Soluciones

Dijkstra no solo es más rápido, sino que también produce caminos más cortos
consistentemente. En casos específicos, la ventaja es pronunciada:

- Test 1: 10.74 km vs 11.88 km
- Test 2: 28.75 km vs 52.32 km (Ran produce un camino 82% más largo)
- Test 3: 88.97 km vs 94.44 km

=== Escalabilidad

El comportamiento del algoritmo de Dijkstra se mantiene superior a medida que aumenta la
complejidad del problema. Incluso en casos donde ambos algoritmos comparten tiempos de
ejecución similares, Dijkstra continúa proporcionando caminos significativamente más
cortos.

== Conclusión

El algoritmo de Dijkstra con implementación de heap binario es más eficiente que el
algoritmo propuesto por Ran et al. (2025) tanto en velocidad de ejecución como en
calidad de soluciones. El método clásico demuestra un dominio completo sobre la
propuesta alternativa en todas las métricas evaluadas.
*/
