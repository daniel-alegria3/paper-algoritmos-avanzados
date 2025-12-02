#import "utils.typ": fecha

#let tesis(
  title: none,
  orientator: none,
  date: none,
  authors: (),
  doc,
) = {
  let fontsize = 12pt

  let margin = 2.54cm
  let margin_side_ratio = 2%
  let caratula_margin_ratio = 2%

  let escudos_ratio = 50%

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

  //================================ {General} =================================
  set page(
    paper: "a4",
    margin: (
      rest: margin,
      // inside: margin + margin_side_ratio,
      // outside: margin - margin_side_ratio,
      inside: 3.81cm,
      // left: 3.81cm,
    ),
    // header: align(right + horizon)[
    //   _ #title _
    // ],
    // numbering: "1",
    // columns: 2,
  )
  set text(
    font: "TeX Gyre Termes",
    size: fontsize,
    spacing: 0.35em,
    lang: "es",
    region: "pe",
  )
  set par(
    // first-line-indent: 1.2em,
    first-line-indent: 1.27cm,
    spacing: 1.5em,
    leading: 0.65em,
    justify: true,
  )
  set heading(
    numbering: "1.",
  )
  set document()

  //=============================== {Overrides} ================================
  show outline.entry.where(
    level: 1,
  ): set block(above: 1.4em)

  show heading.where(
    level: 1,
  ): set block(below: 1em)

  set list(
    indent: 1.2em,
    spacing: 0.85em,
  )

  set enum(
    indent: 1.2em,
    spacing: 0.85em,
  )

  // TODO: https://discord.com/channels/1054443721975922748/1388236879115321404
  set enum(
    full: true,
    numbering: (..args) => {
      let nums = args.pos()
      let style_per_level = ("1.", "a)", "(i)")
      numbering(
        style_per_level.at(nums.len() - 1, default: "1."),
        nums.at(nums.len() - 1),
      )
    },
  )


  // show heading: it => [
  //   #set align(center)
  //   #set text(13pt, weight: "regular")
  //   #block(smallcaps(it.body))
  // ]
  //
  // show heading.where(
  //   level: 2
  // ): it => text(
  //   size: 11pt,
  //   weight: "regular",
  //   style: "italic",
  //   it.body + [.],
  // )

  //================================ {Caratula} ================================
  page(
    // margin: (
    //   rest: margin + caratula_margin_ratio,
    // ),
  )[
    #place(
      float: true,
      auto,
      scope: "parent",
      clearance: 2em,
    )[
      #let _fontsize = 10pt

      #set par(first-line-indent: 0em)
      #set text(size: _fontsize)

      #image("./escudos/unsaac_logo.png", width: escudos_ratio)

      #text(_fontsize * 1.35)[
        UNIVERSIDAD NACIONAL DE SAN ANTONIO ABAD DEL CUSCO
      ]

      #v(1.5em)

      #text(_fontsize * 1.35)[
        PLAN DE TESIS
      ]

      #let _stroke = 2.5pt
      #text(_fontsize * 1.35)[
        #line(length: 100%, stroke: _stroke)
        #smallcaps([*#title*])
        #line(length: 100%, stroke: _stroke)
      ]

      #v(2.5em)
      #text(_fontsize * 1.2)[
        #set par(justify: false)

        #grid(
          columns: 1,
          row-gutter: 1.5em,
          align: left,
          [
            Para optar al título profesional de: \
            #h(1em) #smallcaps([Ingeniero Informático y de Sistemas]) \
          ],
          [
            Presentado Por: \
            #for author in authors [
              #h(1em) #smallcaps([#author]) \
            ]
          ],
          [
            #if orientator != none [
              Asesor: \
              #h(1em) #smallcaps([#orientator]) \
            ]
          ],
        )


      ]


      #v(1fr)
      // # NOTE: bottom is not what puts it near foot of page
      #text(_fontsize * 1.2)[
        Perú, #if (date != none) {date} else {fecha(datetime.today())}
      ]

      #v(1em)

      #text(_fontsize * 1.0)[
        ESCUELA PROFESIONAL DE INGENIERÍA INFORMÁTICA Y DE SISTEMAS
      ]

      #text(_fontsize * 0.86)[
        FACULTAD DE INGENIERÍA ELÉCTRICA, ELECTRÓNICA, INFORMÁTICA Y MECÁNICA
      ]
    ]
  ]
  pagebreak()

  //============================= {Document Body} ==============================
  doc
}

//============================== {Other modules} ===============================
#let src_block(title: none, content) = {
  let stroke = black + 0.5pt
  let radius = 5pt
  show raw: set text(
    font: "TeX Gyre Cursor",
    ligatures: false,
    size: 1em * 1.25,
    spacing: 100%,
  )
  block(stroke: stroke, radius: radius, clip: true, fill: rgb("#f2f2f2"))[
    #if title != none {
      block(
        stroke: stroke,
        inset: 0.5em,
        below: 0em,
        radius: (top-left: radius, bottom-right: radius),
        clip: true,
        fill: rgb("#d8d8d8"),
        title,
      )
    }
    #block(
      width: 100%,
      inset: (rest: 0.5em),
      clip: true,
      content,
    )
  ]
}

/// This uses a hack, path handling may be improved in the future
/// https://forum.typst.app/t/why-are-paths-always-relative-to-the-current-file/306/5
#let src_file(..path, lang: "txt") = {
  let filename = path.at(0)
  src_block(
    title: filename,
    raw(read(..path), lang: lang),
  )
}

