#import "./charged-ieee/lib.typ": ieee
#show: ieee.with(
  title: [Evaluación del rendimiento de Dijkstra y un algoritmo $O(m log^(2/3) n)$ para la
    planificación óptima de trayectos en redes de transporte público],
  // abstract: [
  // ],
  authors: (
    (
      name: "Alegria Sallo Daniel Rodrigo",
      // department: [Co-Founder],
      // organization: [Typst GmbH],
      // location: [Berlin, Germany],
      email: "215270@unsaac.edu.pe",
    ),
    (
      name: "Huahuachampi Hinojosa Zahid",
      email: "200878@unsaac.edu.pe",
    ),
    (
      name: "Puma Potocino Jose Francisco",
      email: "164248@unsaac.edu.pe",
    ),
  ),
  // index-terms: ("SSSP", "Dijkstra", "Overview", "Compilation"),
  figure-supplement: [Fig.],
  // bibliography: bibliography("refs.bib"),
)

#import "@preview/slashion:0.1.1": slash-frac
#show math.equation.where(block: false): slash-frac

#set table(
  stroke: (x, y) => if y == 0 {
    (bottom: 0.7pt + black)
    (top: 0.7pt + black)
  },
  align: (x, y) => (
    if x > 0 { center } else { left }
  ),
)

#show regex("---"): it => it.text.replace(" ", "")

#include "main.typ"

