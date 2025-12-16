#import "./unsaac/unsaac.typ": src_block, src_file, tesis


#show: tesis.with(
  // course: [Algoritmos Avanzados],
  title: [Evaluación del rendimiento de Dijkstra y un algoritmo $O(m log^(2/3) n)$ para
    la planificación óptima de trayectos en redes de transporte público],
  orientator: [Raul Huillca Huallparimachi],
  date: none,
  authors: (
    "Alegria Sallo Daniel Rodrigo",
    "Huahuachampi Hinojosa Zahid",
    "Puma Potocino Jose Francisco",
  ),
)

// ÍNDICE
#set page(footer: context [
  #h(1fr) #counter(page).display("I") #h(1fr)
])
#outline(title: "Índice General")
#pagebreak()

// CONTENIDO
#counter(page).update(1)
#set page(footer: context [
  #h(1fr) #counter(page).display("1")
])
#set grid(columns: 2)

#include "main.typ"

#pagebreak()
#bibliography("refs.bib", title: "BIBLIOGRAFÍA")
