/*
(Opcionalmente, una HIPÓTESIS de trabajo (QUE es lo que se deseas "probar") en caso de
que la naturaleza del trabajo lo amerite).

Las hipotesis indican lo que tratamos de probar y se definen como explicaciones
tentativas del fenomeno investigativo. Se derivan de la teoria existente y deben
formularse a manera de porposiciones. Son respuestas provisionales a las preguntas de
investigacion.

La hipotesis es una suposicion que puede ser puesta a prueba. Al ser formuladas, el
investigador no esta totalmente seguro de que vayan a comprobarse. Una hipotesis
presenta una formulacion (afirmativa) e las relaciones entre dos o mas variables.

Las características que debe reunir una hipótesis son:

- Las hipótesis deben referirse a una situación real. Las hipótesis sólo pueden
  someterse a prueba en un universo y un contexto bien definidos.

- Las variables o términos de las hipótesis deben ser comprensibles, precisos y lo más
  concreto posible.

- La relación entre las variables propuestas por una hipótesis debe ser clara y
  verosímil (lógica).

- Los términos o variables de las hipótesis deben ser observables y medibles, así como
  la relación planteada entre ellos, es decir, tener referentes en la realidad.
*/

= Hipotesis

El presente estudio plantea las siguientes hipótesis de trabajo, derivadas de los
avances teóricos en algoritmos SSSP y la necesidad de validación empírica en contextos
de redes de transporte:

- El algoritmo determinista con complejidad $O(m log^(2/3) n)$ exhibe tiempos de
  ejecución inferiores a los del algoritmo de Dijkstra en grafos dispersos que simulan
  redes de transporte público, cuando se mantienen pesos estáticos en las aristas.

- La escalabilidad del algoritmo $O(m log^(2/3) n)$ es superior a la de Dijkstra al
  incrementar el número de nodos ($n$) y aristas ($m$) en grafos dispersos, permitiendo
  un mejor manejo de datos masivos en sistemas de transporte urbano.

- Las limitaciones inherentes al modelo de comparación y suma no comprometen la
  viabilidad práctica de estos algoritmos para la planificación de rutas en entornos
  reales de transporte público, siempre que se consideren escenarios con pesos
  deterministas y sin variables dinámicas.
