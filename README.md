# Evaluación del Rendimiento de Dijkstra y un Algoritmo O(m log^(2/3) n) para la Planificación Óptima de Trayectos en Redes de Transporte Público

## Descripción

Este proyecto evalúa empíricamente el desempeño del algoritmo de Dijkstra contra un algoritmo determinista con complejidad O(m log^(2/3) n) (Ran et al., 2025) en grafos dispersos que representan redes de transporte público. El estudio utiliza datos geográficos reales de Cusco, Perú.

## Resultados Principales

- Dijkstra con heap binario es **11.5% más rápido** que el algoritmo alternativo
- Dijkstra produce caminos **18% más cortos**
- A mayor complejidad del grafo, la ventaja de Dijkstra se acentúa
- Los beneficios teóricos del nuevo algoritmo no se materializan a la escala urbana típica

## Experimentación y Análisis de Resultados

Se ejecutaron los algoritmos en una zona de fácil prueba, con un terreno plano sin muchas irregularidades. Cada prueba comenzó con distancias cortas e incrementó progresivamente hasta alcanzar aproximadamente 300 kilómetros.

### Resultados de Rendimiento

| Algoritmo | Tiempo (ms) |
|-----------|------------|
| Dijkstra (Binary Heap) | 41.38 |
| Ran et al. (2025) | 46.15 |

![Comparación de tiempo, distancia y nro. de nodos de los algoritmos](./contenido/imgs/algo_comparacion_grafico.png)

Los resultados obtenidos en las 13 pruebas realizadas muestran un comportamiento
consistente de ambos algoritmos, permitiendo una comparación clara de su
eficiencia en diferentes escenarios de complejidad creciente.

## Conclusión

A pesar de las mejoras asintóticas teóricas, el algoritmo clásico de Dijkstra
sigue siendo la opción más eficiente y práctica para aplicaciones de transporte
público en redes urbanas típicas.

## Implementación

Para detalles sobre el código, algoritmos implementados y guía de uso, consulta:

[Implementación - code/README.md](./code/README.md)

Los algoritmos están implementados en JavaScript con interfaz web interactiva para pruebas y visualización.
