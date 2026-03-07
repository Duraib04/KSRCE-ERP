'use strict';
const MANIFEST = 'flutter-app-manifest';
const TEMP = 'flutter-temp-cache';
const CACHE_NAME = 'flutter-app-cache';

const RESOURCES = {".vercel/project.json": "f7213876d21cd70f225b86c66af8f9f2",
".vercel/README.txt": "2b13c79d37d6ed82a3255b83b6815034",
"assets/AssetManifest.bin": "235b061aafc010bd309be38eb0bf9b09",
"assets/AssetManifest.bin.json": "c2f080ea89f8e1626742c761fd887423",
"assets/assets/data/assignments.json": "9c3415c62682906687268537e95e19c7",
"assets/assets/data/attendance.json": "9c3415c62682906687268537e95e19c7",
"assets/assets/data/certificates.json": "9c3415c62682906687268537e95e19c7",
"assets/assets/data/classes.json": "9c3415c62682906687268537e95e19c7",
"assets/assets/data/complaints.json": "9c3415c62682906687268537e95e19c7",
"assets/assets/data/courses.json": "9c3415c62682906687268537e95e19c7",
"assets/assets/data/course_diary.json": "9c3415c62682906687268537e95e19c7",
"assets/assets/data/course_outcomes.json": "9c3415c62682906687268537e95e19c7",
"assets/assets/data/departments.json": "9c3415c62682906687268537e95e19c7",
"assets/assets/data/events.json": "9c3415c62682906687268537e95e19c7",
"assets/assets/data/event_registrations.json": "9c3415c62682906687268537e95e19c7",
"assets/assets/data/exams.json": "9c3415c62682906687268537e95e19c7",
"assets/assets/data/faculty.json": "9c3415c62682906687268537e95e19c7",
"assets/assets/data/faculty_timetable.json": "9c3415c62682906687268537e95e19c7",
"assets/assets/data/fees.json": "9c3415c62682906687268537e95e19c7",
"assets/assets/data/leave.json": "9c3415c62682906687268537e95e19c7",
"assets/assets/data/leave_balance.json": "9c3415c62682906687268537e95e19c7",
"assets/assets/data/library.json": "9c3415c62682906687268537e95e19c7",
"assets/assets/data/mentor_assignments.json": "9c3415c62682906687268537e95e19c7",
"assets/assets/data/notifications.json": "9c3415c62682906687268537e95e19c7",
"assets/assets/data/placements.json": "9c3415c62682906687268537e95e19c7",
"assets/assets/data/placement_applications.json": "9c3415c62682906687268537e95e19c7",
"assets/assets/data/profile_edit_requests.json": "9c3415c62682906687268537e95e19c7",
"assets/assets/data/research.json": "9c3415c62682906687268537e95e19c7",
"assets/assets/data/results.json": "9c3415c62682906687268537e95e19c7",
"assets/assets/data/students.json": "9c3415c62682906687268537e95e19c7",
"assets/assets/data/syllabus.json": "9c3415c62682906687268537e95e19c7",
"assets/assets/data/timetable.json": "9c3415c62682906687268537e95e19c7",
"assets/assets/data/users.json": "9c3415c62682906687268537e95e19c7",
"assets/assets/images/KSRCE-CAMPUS-AERIAL.jpeg": "d41d8cd98f00b204e9800998ecf8427e",
"assets/assets/images/ksrce-logo.png": "d41d8cd98f00b204e9800998ecf8427e",
"assets/FontManifest.json": "7b2a36307916a9721811788013e65289",
"assets/fonts/MaterialIcons-Regular.otf": "e7069dfd19b331be16bed984668fe080",
"assets/NOTICES": "eedce2054c0416783dcdf44dddb88791",
"assets/shaders/ink_sparkle.frag": "2815c3cf1e7af2d8a2d328064a62e3a0",
"assets/shaders/stretch_effect.frag": "f0ab847ccb98001d214e09f120664284",
"canvaskit/canvaskit.js": "641b694a3d4f81f9c4cd562b221ded72",
"canvaskit/canvaskit.js.symbols": "5ac6692eacf6a90e5de54522a70dd641",
"canvaskit/canvaskit.wasm": "eb571c4cc957666a698bd1a856d53d81",
"canvaskit/chromium/canvaskit.js": "d6970eccb3777f05b732363c4e766457",
"canvaskit/chromium/canvaskit.js.symbols": "7d124093f1409261a159258d224a3c18",
"canvaskit/chromium/canvaskit.wasm": "533ff3807d882670fc06967af5a0926f",
"canvaskit/skwasm.js": "3f6bc70ea7a8a644f16861bdf2c870fe",
"canvaskit/skwasm.js.symbols": "4953dd114fe01b604cd61e517cc98f30",
"canvaskit/skwasm.wasm": "95989e9ced48dda2578d80ef264f79f4",
"canvaskit/skwasm_heavy.js": "2e2c45e6061c1b34527f3a9466863449",
"canvaskit/skwasm_heavy.js.symbols": "4f3e7b50bdd2e496f52fcd6f03d019c7",
"canvaskit/skwasm_heavy.wasm": "b5cc8903b4ee7ceec6978e6baef06f8c",
"canvaskit/wimp.js": "91ca0f796f022b2b89d7795dadd1e114",
"canvaskit/wimp.js.symbols": "f5c5baac10073771e1a5249838cbc54a",
"canvaskit/wimp.wasm": "f4dedb91b4ff16f46bcaef14904e0065",
"favicon.png": "935e396d6aeccd2481ee71f20b8d4391",
"flutter.js": "a84fb19d509ce3514a76dee32608551c",
"flutter_bootstrap.js": "6e795aa054bf7efe1f0bae13efafa91e",
"icons/Icon-192.png": "89c9130f0622ccb6fe954ecb0c3b3bea",
"icons/Icon-512.png": "f9fcd7d81f6610045993a7f0f4098f3a",
"index.html": "fd490c2e0e64f4199c6b0fa4b9626f19",
"/": "fd490c2e0e64f4199c6b0fa4b9626f19",
"main.dart.js": "9c7335fb5c6a59678a3f52c916a7ce1e",
"manifest.json": "ee4df06a40eb1f7b2cd972a37d356313",
"vercel.json": "b9c9c809ee4fcc21ce946db27539d7d2",
"version.json": "edad47372b0c3944a744982874519936"};
// The application shell files that are downloaded before a service worker can
// start.
const CORE = ["main.dart.js",
"index.html",
"flutter_bootstrap.js",
"assets/AssetManifest.bin.json",
"assets/FontManifest.json"];

// During install, the TEMP cache is populated with the application shell files.
self.addEventListener("install", (event) => {
  self.skipWaiting();
  return event.waitUntil(
    caches.open(TEMP).then((cache) => {
      return cache.addAll(
        CORE.map((value) => new Request(value, {'cache': 'reload'})));
    })
  );
});
// During activate, the cache is populated with the temp files downloaded in
// install. If this service worker is upgrading from one with a saved
// MANIFEST, then use this to retain unchanged resource files.
self.addEventListener("activate", function(event) {
  return event.waitUntil(async function() {
    try {
      var contentCache = await caches.open(CACHE_NAME);
      var tempCache = await caches.open(TEMP);
      var manifestCache = await caches.open(MANIFEST);
      var manifest = await manifestCache.match('manifest');
      // When there is no prior manifest, clear the entire cache.
      if (!manifest) {
        await caches.delete(CACHE_NAME);
        contentCache = await caches.open(CACHE_NAME);
        for (var request of await tempCache.keys()) {
          var response = await tempCache.match(request);
          await contentCache.put(request, response);
        }
        await caches.delete(TEMP);
        // Save the manifest to make future upgrades efficient.
        await manifestCache.put('manifest', new Response(JSON.stringify(RESOURCES)));
        // Claim client to enable caching on first launch
        self.clients.claim();
        return;
      }
      var oldManifest = await manifest.json();
      var origin = self.location.origin;
      for (var request of await contentCache.keys()) {
        var key = request.url.substring(origin.length + 1);
        if (key == "") {
          key = "/";
        }
        // If a resource from the old manifest is not in the new cache, or if
        // the MD5 sum has changed, delete it. Otherwise the resource is left
        // in the cache and can be reused by the new service worker.
        if (!RESOURCES[key] || RESOURCES[key] != oldManifest[key]) {
          await contentCache.delete(request);
        }
      }
      // Populate the cache with the app shell TEMP files, potentially overwriting
      // cache files preserved above.
      for (var request of await tempCache.keys()) {
        var response = await tempCache.match(request);
        await contentCache.put(request, response);
      }
      await caches.delete(TEMP);
      // Save the manifest to make future upgrades efficient.
      await manifestCache.put('manifest', new Response(JSON.stringify(RESOURCES)));
      // Claim client to enable caching on first launch
      self.clients.claim();
      return;
    } catch (err) {
      // On an unhandled exception the state of the cache cannot be guaranteed.
      console.error('Failed to upgrade service worker: ' + err);
      await caches.delete(CACHE_NAME);
      await caches.delete(TEMP);
      await caches.delete(MANIFEST);
    }
  }());
});
// The fetch handler redirects requests for RESOURCE files to the service
// worker cache.
self.addEventListener("fetch", (event) => {
  if (event.request.method !== 'GET') {
    return;
  }
  var origin = self.location.origin;
  var key = event.request.url.substring(origin.length + 1);
  // Redirect URLs to the index.html
  if (key.indexOf('?v=') != -1) {
    key = key.split('?v=')[0];
  }
  if (event.request.url == origin || event.request.url.startsWith(origin + '/#') || key == '') {
    key = '/';
  }
  // If the URL is not the RESOURCE list then return to signal that the
  // browser should take over.
  if (!RESOURCES[key]) {
    return;
  }
  // If the URL is the index.html, perform an online-first request.
  if (key == '/') {
    return onlineFirst(event);
  }
  event.respondWith(caches.open(CACHE_NAME)
    .then((cache) =>  {
      return cache.match(event.request).then((response) => {
        // Either respond with the cached resource, or perform a fetch and
        // lazily populate the cache only if the resource was successfully fetched.
        return response || fetch(event.request).then((response) => {
          if (response && Boolean(response.ok)) {
            cache.put(event.request, response.clone());
          }
          return response;
        });
      })
    })
  );
});
self.addEventListener('message', (event) => {
  // SkipWaiting can be used to immediately activate a waiting service worker.
  // This will also require a page refresh triggered by the main worker.
  if (event.data === 'skipWaiting') {
    self.skipWaiting();
    return;
  }
  if (event.data === 'downloadOffline') {
    downloadOffline();
    return;
  }
});
// Download offline will check the RESOURCES for all files not in the cache
// and populate them.
async function downloadOffline() {
  var resources = [];
  var contentCache = await caches.open(CACHE_NAME);
  var currentContent = {};
  for (var request of await contentCache.keys()) {
    var key = request.url.substring(origin.length + 1);
    if (key == "") {
      key = "/";
    }
    currentContent[key] = true;
  }
  for (var resourceKey of Object.keys(RESOURCES)) {
    if (!currentContent[resourceKey]) {
      resources.push(resourceKey);
    }
  }
  return contentCache.addAll(resources);
}
// Attempt to download the resource online before falling back to
// the offline cache.
function onlineFirst(event) {
  return event.respondWith(
    fetch(event.request).then((response) => {
      return caches.open(CACHE_NAME).then((cache) => {
        cache.put(event.request, response.clone());
        return response;
      });
    }).catch((error) => {
      return caches.open(CACHE_NAME).then((cache) => {
        return cache.match(event.request).then((response) => {
          if (response != null) {
            return response;
          }
          throw error;
        });
      });
    })
  );
}
