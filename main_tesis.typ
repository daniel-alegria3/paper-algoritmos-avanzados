#import "./unsaac/unsaac.typ": src_block, src_file, tesis


#show: tesis.with(
  // course: [Algoritmos Avanzados],
  title: [Algoritmos para Camino Mas Corto de Fuente Unica],
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
#include "main.typ"

