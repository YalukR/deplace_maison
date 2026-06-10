# Déplacé Maison — Flutter Web UI Replica
[Déplacé Maison](https://web.archive.org/web/20220122002134/https://www.deplacemaison.com/)

---

## Stack
- **Flutter 3 / Dart 3** — target web
- **go_router** — navegación declarativa
- **visibility_detector** — animaciones de entrada al hacer scroll

## Fuentes
Las fuentes no se instalan via pub, van directamente en `assets/fonts/`:
- `FingerPaint-Regular.ttf`
- `HedvigLettersSans-Regular.ttf`

Descárgalas de [Google Fonts](https://fonts.google.com) y colócalas en esa carpeta antes de correr el proyecto.

## Cómo correr el proyecto
```bash
flutter run -d chrome
```

## Notas
- El efecto de cursor animado (estela, burbujas, orbitales) **solo funciona en navegadores web**; usa `dart:html` internamente y no compila para escritorio o móvil.
- El widget `WayArchive` replica visualmente la barra del [Wayback Machine](https://web.archive.org) de Internet Archive como detalle estético.
- Los datos del repositorio (`WayArchiveRepository`) son estáticos y representativos; no consumen ninguna API.