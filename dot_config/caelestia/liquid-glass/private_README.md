# Caelestia Liquid Glass (HyprGlass + Caelestia.Blobs SDF)

Documentación técnica y guía de reproducción del efecto **Apple Liquid Glass** en **Caelestia Shell (Quickshell)** sobre **Hyprland 0.56.2**.

---

## Arquitectura del Efecto (3 Capas)

### 1. Lente Refractiva de Contorno en Compositor (`HyprGlass v0.11.0`)
- Se utiliza el plugin `hyprnux/hyprglass` (rama `hyprland-0.56`) cargado en `~/.config/caelestia/hypr-user.lua`.
- Configurado sobre el layer surface `caelestia-drawers` con `mask_mode = "contour"`, `mask_threshold = 0.20`, `mask_feather = 0.12` y `live_resample = true`.
- **Importante (Orden de configuración en Lua)**: `hg.preset("caelestia_glass", ...)` **debe** declararse antes de `hg.config({ default_preset = "caelestia_glass" })`, de lo contrario Hyprland entra en *Safe Mode* al no existir aún el preset cuando se valida `hg.config`.
- **Parche de bordes de pantalla (`patches/hyprglass-edge-clamp.patch`)**:
  1. `src/Shaders.hpp` (`contouredt.frag`): En vez de devolver `vec2(0.0, FAR)` fuera del framebuffer (`p < 0` o `p >= fieldSize`), se hace `clamp(ivec2(p), ivec2(0), ivec2(fieldSize) - 1)`. Esto evita que el borde exterior físico del monitor (`x=0, y=0, x=1920, y=1080`) sea tratado como un segundo borde de cristal y elimine la banda refractiva pegada al marco de `10px`.
  2. `src/GlassRenderer.cpp` (`sampleBackground`): En lugar de limpiar el padding fuera del monitor con `glClearColor(0,0,0,0)` (que al desenfocarse sangraba negro/transparente hacia el borde), se replican los texels del borde del monitor mediante `glBlitFramebuffer(..., GL_NEAREST)`.

### 2. Bisel Óptico Analítico SDF en `Caelestia.Blobs` (`blob.frag`)
- El shader nativo `plugin/src/Caelestia/Blobs/shaders/blob.frag` evalúa la distancia firmada exacta `mergedSdf` de todos los paneles metaball (`smin`) y el marco perimetral (`BlobInvertedRect`).
- Se añadió iluminación especular direccional (luz principal superior-izquierda + contra-reflejo Fresnel inferior-derecha), dispersión cromática sutil y un surco cáustico interior (`causticTrough`) acotado a `0..4.5px` del contorno interior (`mergedSdf == 0`).
- **Prevención de costuras internas (`smin`)**:
  - Se conserva `d *= scale` completo en el escalado de proximidad al borde para que las uniones internas (`dashBg` con `dFrame`) tengan distancia negativa profunda (`~ -32.8px`) y no entren en la banda de `0..4.5px`.
  - Se filtra por magnitud de gradiente (`validEdge = smoothstep(0.35, 0.75, length(vec2(dFdx(mergedSdf), dFdy(mergedSdf)))) * outerEdgeMask`) para suprimir puntos de silla internos y el borde exterior del monitor (`invertedOuter`).
- **Prevención de bandas oscuras al pasar el mouse (FBO Alpha)**:
  - Todos los `BlobRect` se renderizan dentro de un mismo FBO (`blobLayer` en `ContentWindow.qml`) y expanden su geometría por `1.5 * smoothFactor`. Por ello, `blob.frag` **debe** emitir `alpha = 1.0` en el interior del SDF (`vec4(glassRgb * alpha, alpha) * qt_Opacity`), dejando que la transparencia (`0.36`) la aplique uniformemente `blobLayer` (`opacity: root.surfaceColour.a`).
- **Overlay sin `sudo` (`QML2_IMPORT_PATH`)**:
  - Se enlaza `~/.local/share/caelestia-qml/Caelestia` hacia `/usr/lib/qt6/qml/Caelestia/*` reemplazando `Blobs` y `lib/libcaelestia-blobs.so` por los artefactos compilados en `~/shell/build`.

### 3. Tarjetas Internas y Coexistencia con HyprGlass (`~/.config/quickshell/caelestia`)
- `components/StyledRect.qml`: Añade borde cristalino de `1px` (`Qt.rgba(1, 1, 1, 0.22)`) directamente en la propiedad `border` del `Rectangle` raíz (sin `Rectangle` hijos que ignoren `topLeftRadius`/`topRightRadius`).
- `services/Colours.qml`: En `reloadHyprRules()`, evita inyectar `blur = true` nativo de Hyprland sobre `caelestia-drawers` cuando `hl.plugin.hyprglass` está cargado, evitando corrupción de scanlines en Intel Xe KMD y conflicto con el motor de blur de HyprGlass.
- `modules/drawers/ContentWindow.qml`: Activa `layer.smooth: true` en `blobLayer`.

---

## Reinstalación / Actualización Automática

Ejecutar:
```bash
~/.config/caelestia/liquid-glass/setup-liquid-glass.sh
```
