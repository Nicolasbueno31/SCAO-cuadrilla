// NOVA SCAO v2.9 - GitHub Pages. Solo cachea archivos del mismo sitio.
// Las solicitudes a Supabase nunca son interceptadas ni cacheadas.
const CACHE = 'nova-scao-v2-9-github-pages';
const SHELL = ['./index.html', './manifest.webmanifest', './icon-192.png', './icon-512.png'];
self.addEventListener('install', event => {
  event.waitUntil(caches.open(CACHE).then(cache => cache.addAll(SHELL)));
  self.skipWaiting();
});
self.addEventListener('activate', event => {
  event.waitUntil(caches.keys().then(keys => Promise.all(keys
    .filter(key => key.startsWith('nova-scao-') && key !== CACHE)
    .map(key => caches.delete(key)))));
  self.clients.claim();
});
self.addEventListener('fetch', event => {
  const req = event.request;
  if (req.method !== 'GET') return;
  const url = new URL(req.url);
  if (url.origin !== self.location.origin) return;
  const base = new URL('./', self.registration.scope).pathname;
  const assets = new Set(SHELL.map(x => new URL(x, self.registration.scope).pathname));
  if (url.pathname === base) {
    event.respondWith(fetch(new URL('./index.html', self.registration.scope))
      .then(resp => { if (resp.ok) { const copy = resp.clone(); caches.open(CACHE).then(c => c.put('./index.html', copy)); } return resp; })
      .catch(() => caches.match('./index.html')));
    return;
  }
  if (!assets.has(url.pathname)) return;
  event.respondWith(fetch(req).then(resp => {
    if (resp.ok) { const copy = resp.clone(); caches.open(CACHE).then(c => c.put(req, copy)); }
    return resp;
  }).catch(() => caches.match(req)));
});
