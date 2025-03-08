#set document(
	title: "philOS",
	author: "Matteo Bertolino, Alessandro Demichelis",
	description: "Documentazione unica di philOS",
	keywords: "Hardware, software, sistemi operativi, retrocomputing, circuiti, i8086",
	date: auto
)

#set page(
	paper: "a4",
	margin: (top: 2.5cm, bottom: 2.5cm, right: 2cm, left: 2cm),
	header: context {
		if counter(page).get().first() == 1 [
			08/03/2025
			#h(1fr)
			Revisione Nº0
		]else[
			#align(right)[philOS]
		]
	}
)

#set par(
	justify: true,
	leading: 2.5mm,
)

#set text(
	font: "New Computer Modern",
	lang: "it",
	size: 12pt
)

#set heading(numbering: ("I.1"))

#align(center)[
	*\/ / / VERSIONE TOTALMENTE PROVVISORIA / / \/*
]

#align(center + horizon, block[
	#image("../../res/banner.png",width: 50%)
	#text(24pt)[*philOS*] \
	#text[Matteo Bertolino, Alessandro Demichelis]
])

#set page(numbering: "1")

#pagebreak()
#outline()
#pagebreak()

#include "sections/1_introduzione.typ"
#include "sections/2_dfd.typ"
#include "sections/3_specifiche.typ"
#include "sections/4_tecnologie.typ"
#include "sections/5_organizzazione.typ"
#include "sections/6_interfaccia.typ"
#include "sections/7_contributi.typ"
#include "sections/8_collaudo.typ"

#pagebreak()
#bibliography("references.yaml")
