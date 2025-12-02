/*
(Se recomienda presentar los alcances y limitaciones en forma de puntos, se espera una
redacción clara y detallada)

Los alcances y algunas limitaciones del estudio se presentan en los siguientes párrafos.

== Alcances
Los alcances de este estudio pueden resumirse en:

- Primer Alcance.
- Segundo Alcance.
- Tercer Alcance.

== Limitaciones

Algunas limitaciones de este estudio pueden resumirse en:

- Primera limitación.
- Segunda limitación.
- Tercera limitación.
*/

= Alcances y Limitaciones

== Alcance

El presente proyecto de investigación se enmarca en el análisis comparativo y la
evaluación de rendimiento algorítmico aplicado a grafos que simulan redes de transporte.
El estudio abarcará los siguientes puntos:

- *Algoritmos bajo estudio:* Se implementará y analizará el algoritmo clásico de
  Dijkstra frente al algoritmo determinista reciente de complejidad $O(m log^(2/3) n)$.

- *Dominio de Datos:* Las pruebas experimentales se realizarán sobre grafos generados
  aleatoriamente que emulen las características de densidad de una red de transporte
  público (grafos dispersos), así como en escenarios de grafos densos para establecer
  puntos de control y ruptura de eficiencia.

- *Métricas de Evaluación:* El análisis se centrará en la complejidad computacional
  práctica (tiempo de ejecución de CPU) y la escalabilidad de ambos algoritmos al
  incrementar el volumen de nodos ($n$) y aristas ($m$).

- *Marco Teórico:* La investigación incluirá una revisión exhaustiva del estado del
  arte, analizando al menos 16 artículos científicos que fundamenten los avances
  recientes en algoritmos SSSP y su diferenciación con los enfoques clásicos.

== Limitaciones

A pesar del rigor metodológico, la investigación está sujeta a las siguientes
restricciones:

- *Modelo de Computación:* El análisis teórico se restringe al modelo de comparación y
  suma. No se considerarán optimizaciones dependientes de arquitecturas de hardware
  específicas (como paralelismo en GPU) ni modelos de computación cuántica.

- *Variables de Tráfico Dinámico:* Para efectos de la comparación algorítmica
  fundamental, se asumirán pesos estáticos o deterministas en las aristas. No se
  contempla en esta fase la integración de variables estocásticas en tiempo real (como
  accidentes imprevistos o congestión fluctuante) que requieran re-cálculos dinámicos
  complejos, centrándose exclusivamente en la eficiencia del cálculo de la ruta base.

- *Entorno de Ejecución:* Los resultados de tiempo absoluto dependerán de las
  especificaciones de hardware del equipo de pruebas; sin embargo, las conclusiones se
  basarán en el comportamiento asintótico y las tasas de crecimiento relativo entre los
  algoritmos comparados.

- *Complejidad de Implementación:* El estudio se limita a la implementación de
  prototipos funcionales para la validación académica, sin llegar al despliegue de un
  sistema de producción comercial completo.
