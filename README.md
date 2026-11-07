# NOVA SCAO — PWA para GitHub Pages

Versión base: **2.9**. Aplicación estática HTML/CSS/JavaScript con autenticación Supabase y registro guiado de jornadas.

## Publicación

1. Ingresar a https://github.com/new e iniciar sesión en la cuenta autorizada por NOVA.
2. Crear repositorio, por ejemplo `nova-scao-app`.
3. Subir **los archivos de esta carpeta al nivel raíz** del repositorio (no subir solo el ZIP ni una carpeta contenedora).
4. Ir a **Settings → Pages → Build and deployment**.
5. Elegir **Deploy from a branch**, rama **main** y carpeta **/(root)**. Guardar.
6. Abrir la URL publicada indicada por GitHub, que generalmente tiene el formato `https://USUARIO.github.io/nova-scao-app/`.
7. En Chrome para Android, abrir la URL HTTPS y elegir el menú ⋮ → **Instalar aplicación** o **Agregar a pantalla principal** (según el navegador).

## Archivos que deben estar en la raíz

- `index.html`: interfaz, carga guiada y comunicación con Supabase.
- `manifest.webmanifest`: nombre e iconos de instalación.
- `sw.js`: caché del entorno gráfico (no cachea llamadas de Supabase).
- `icon-192.png`, `icon-512.png`: iconos.
- `.nojekyll`: desactiva procesamiento Jekyll.

## Seguridad y operación

- GitHub Pages **no ofrece control de acceso al sitio por sí mismo**: la URL se puede visitar. La pantalla de inicio de sesión y las políticas RLS de Supabase deben proteger los datos reales.
- Este proyecto incluye la **URL de Supabase y su clave pública publishable** en el HTML. Son valores diseñados para cliente. **No publicar jamás secretos, service_role, contraseñas, archivos .env ni respaldos con datos reales**.
- En GitHub Free, la publicación Pages requiere repositorio **público**; un repositorio privado con Pages requiere un plan habilitado, y la visibilidad del sitio debe verificarse por separado.
- La primera instalación requiere conexión. El modo offline almacena datos locales cuando el navegador lo permite, pero la sincronización requiere conectividad y autenticación vigente.
- Los registros locales dependen del origen (URL) y perfil del navegador. Cambiar la URL del sitio no migra automáticamente los datos IndexedDB.
- n8n **no debe exponerse** por GitHub Pages. El servidor interno de NOVA continúa consultando Supabase en forma independiente.
- Antes de utilizar en producción verificar políticas RLS, usuarios autorizados, restricción efectiva de duplicados por fecha, recuperación de datos, permisos de edición de obras y el circuito de confirmación de procesamiento en n8n.
- Esta versión todavía conserva edición de catálogos en almacenamiento local; el catálogo centralizado de obras con permisos de administrador está pendiente y **no debe considerarse terminado**.

## Actualizaciones

Reemplazar los archivos en GitHub. Cuando se cambie la aplicación, actualizar la constante `CACHE` de `sw.js` (ej.: `nova-scao-v2-10-github-pages`) para separar versiones de caché. Recargar desde el dispositivo tras la publicación.

## Prueba inicial sugerida

1. Comprobar `manifest.webmanifest` y `sw.js` en la URL publicada.
2. Verificar que la pantalla de acceso sea la primera tras el splash.
3. Iniciar sesión con un usuario de prueba de Supabase, sin insertar credenciales en código.
4. Probar una jornada de prueba y comprobar su confirmación en Supabase.
5. Verificar que una segunda carga de la misma fecha sea rechazada.
6. Verificar la instalación PWA en Android y los mensajes de error sin conexión.

**Nota:** No se incluye ningún documento SQL administrativo, datos de empleados exportados ni credenciales privadas dentro del paquete de publicación.
