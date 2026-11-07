# NOVA SCAO - acceso corporativo v3.0

Actualización **visual** del inicio de sesión sobre la base funcional 2.9.

- Logotipo NOVA extraído de la imagen de referencia facilitada (Instagram), no tipografía genérica.
- Cabecera NOVA / SCAO, formulario de acceso más claro, iconos y detalles de construcción.
- Se conservan los IDs de autenticación y el resto de la lógica de Supabase, jornadas y camión.
- Incluye los íconos Android personalizados aprobados anteriormente (casco, NOVA y SCAO).
- Caché del service worker actualizado para cargar el nuevo HTML.

## Sustituir en GitHub

En el repositorio `Nicolasbueno31/SCAO-cuadrilla`, subir **todos los archivos descomprimidos** (no el ZIP) a la raíz de la rama `main`, reemplazando los existentes. Si se prefiere una actualización mínima, sustituir únicamente `index.html`, `sw.js` y agregar `nova-logo-blanco.png` (el logo ya está integrado en HTML, así que el PNG es opcional).

Abrir https://nicolasbueno31.github.io/SCAO-cuadrilla/ y verificar inicio de sesión. Una PWA instalada puede necesitar recarga o reinstalación si conserva caché antiguo.

**Seguridad:** GitHub Pages es público. No publicar secretos ni contraseñas. Antes de producción validar RLS y una jornada de prueba.
