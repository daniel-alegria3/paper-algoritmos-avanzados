#let estado_arte_seccion(bib_label) = {
  import "@preview/citegeist:0.2.0": load-bibliography
  let bib = load-bibliography(read("../refs.bib"))
  let entry = bib.at(bib_label)
  let reference = ref(label(bib_label))
  let title = entry.fields.title
  let year = entry.fields.year

  let given = entry.parsed_names.author.at(0).family
  let family = entry.parsed_names.author.at(0).given

  // [#family et al. (#year) #reference]

  [#family et al. (#year) #emph[#title] #reference]
  // [#title #reference]
  // [#year #year #reference]
  // [#entry.author #entry.year #reference]
}
