= Experimentación y Analisis de resultados

Se corrio el algoritmo

#figure(
  table(
    columns: (1fr, 1fr, 1fr),
    align: center,
    table.header[*Métrica*][*Ruta Corta*][*Ruta Larga*],
    table.hline(),
    [Tiempo], [Dijkstra mejor\n(+4.1%)], [Ran mejor\n(-23.4%)],
    [Nodos visitados], [Dijkstra mejor\n(-6.0%)], [Ran mejor\n(-19.3%)],
    [Operaciones heap], [Dijkstra mejor\n(-4.9%)], [Ran mejor\n(-22.5%)],
    [Memoria], [Dijkstra mejor\n(-4.2%)], [Ran mejor\n(-11.9%)],
  ),
  caption: [Comparación visual del algoritmo superior por métrica y tipo de ruta],
)

#grid(
  gutter: 10pt,
  // image("./imgs/exp04.jpeg"),
)
