# Déplacé Maison — Technical Interview Project

[Déplacé Maison] - (https://web.archive.org/web/20220122002134/https://www.deplacemaison.com/)

---

## Stack

- **Flutter 3 / Dart 3** — target web
- **go_router** — navegacion declarativa
- **visibility_detector** — animaciones de entrada al hacer scroll

## Fuentes

Las fuentes no se instalan via pub, van directamente en `assets/fonts/`:

- `FingerPaint-Regular.ttf`
- `HedvigLettersSans-Regular.ttf`

Descargalas de [Google Fonts] - (https://fonts.google.com) y colocalas en esa carpeta antes de correr el proyecto.


## Notas

- El efecto de cursor animado (estela, burbujas, orbitales) **solo funciona en navegadores web**; usa `dart:html` internamente y no compila para escritorio o movil.
- El widget `WayArchive` replica visualmente la barra del [Wayback Machine](https://web.archive.org) de Internet Archive como detalle estetico.
- Los datos del repositorio (`WayArchiveRepository`) son estaticos y representativos; no consumen ninguna API.