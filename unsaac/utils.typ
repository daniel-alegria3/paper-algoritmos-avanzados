#let fecha(date) = {
  // Temp fix for 'lang: es' not working on datetime()
  let months = (
    "Enero",
    "Febrero",
    "Marzo",
    "Abril",
    "Mayo",
    "Junio",
    "Julio",
    "Agosto",
    "Septiembre",
    "Octubre",
    "Noviembre",
    "Diciembre",
  )
  [#months.at(date.month() - 1) del #date.year()]
}

