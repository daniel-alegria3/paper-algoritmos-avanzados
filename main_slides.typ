#import "@preview/touying:0.6.1": *
#import themes.metropolis: *
#import "@preview/numbly:0.1.0": numbly

#show: metropolis-theme.with(
  aspect-ratio: "16-9",
  footer: self => self.info.title,
  config-info(
    title: [Algoritmos para Camino Mas Corto de Fuente Unica],
    subtitle: [Docente: Raul Huillca Huallparimachi],
    author: [
      #smallcaps([Integrantes]):
      #grid(
        columns: (1fr, 1.8fr),
        align: (left, left),
        gutter: 5pt,
        inset: (
          y: 7pt,
        ),
        [- Alegria Sallo Daniel Rodrigo], [(215270)],
        [- Huahuachampi Hinojosa Zahid], [(200878)],
        [- Puma Potocino Jose Francisco], [(164248)],
      )
    ],
    date: datetime.today(),
    institution: [UNIVERSIDAD NACIONAL SAN ANTONIO ABAD DEL CUSCO],
    // logo: emoji.city,
  ),
  config-common(
    datetime-format: "[day]-[month]-[year]",
    // handout: true, // omit animations
    // show-notes-on-second-screen: right,
  ),
  config-page(
    // margin: (x: 4em, y: 2em),
    // header-ascent: 0em,
    // footer-descent: 0em,
  ),
)
#set heading(numbering: numbly("{1}.", default: "1.1"))

#title-slide()

#include "main.typ"