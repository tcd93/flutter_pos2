'use strict';
const MANIFEST = 'flutter-app-manifest';
const TEMP = 'flutter-temp-cache';
const CACHE_NAME = 'flutter-app-cache';

const RESOURCES = {"main.dart.js": "14a1b9b9758b0a3840d7c3565550165e",
"assets/AssetManifest.bin": "4486f2e9ef1e15f444d714b9cfea33c7",
"assets/shaders/ink_sparkle.frag": "4096b5150bac93c41cbc9b45276bd90f",
"assets/assets/icon/icon-adaptive.png": "59ec5767b950cf9b0896f480f41a7e0d",
"assets/assets/icon/icon-ios.png": "b3dca4b56c89d3d854dce857df286be5",
"assets/assets/icon/icon-legacy.png": "40b90697a472234e39e910117bc89282",
"assets/assets/food/pad_thai.jpg": "14aab7e9dd8e79b9f240f53dd562df53",
"assets/assets/food/pizza.jpg": "fe553a3edae7ca9b697d0c76b12fadd4",
"assets/assets/food/pho.jpg": "65a72f1d1f143da24d247c8a82540df3",
"assets/assets/food/apple.jpg": "69780400dcde8c6804afb30fe7029a89",
"assets/assets/food/dumpling.jpg": "89539014ccdcc4d3806301db0ac30754",
"assets/assets/food/cat.jpg": "bd446d6227d32fac88537453727d9d32",
"assets/assets/food/icecream.jpg": "bfe43725294af4cba35c43f1c34ac11b",
"assets/assets/food/vegetable.jpg": "40c2ca9e940b6634ff073d19ecb2c992",
"assets/assets/fonts/RobotoMono/RobotoMono-Regular.ttf": "a3649815e40709ca063e69bcf09d5851",
"assets/assets/fonts/RobotoMono/RobotoMono-Medium.ttf": "2d469915578f1e15aaf935f1f7156c96",
"assets/assets/fonts/RobotoMono/RobotoMono-Bold.ttf": "03c05bc5031fec52ca6644cf6278de6f",
"assets/assets/fonts/Quicksand/Quicksand-Regular.ttf": "678b12a6a938c32eb5fa88f2f439c2df",
"assets/assets/fonts/Quicksand/Quicksand-Medium.ttf": "f65d1a07e0f4521c99d900e31e4bc530",
"assets/assets/fonts/Quicksand/Quicksand-Bold.ttf": "809cd8ab97c465b57cb1a44b1795f12c",
"assets/assets/fonts/Rubik/Rubik-Medium.ttf": "1c834b4058e2737bb9f88a07ccddc8bc",
"assets/assets/fonts/Rubik/Rubik-Regular.ttf": "db5c7abfb1b57df0ae8ff1c236cbd810",
"assets/assets/fonts/Rubik/Rubik-Bold.ttf": "d43efa6b8630dd2a1dcc1b35e8f9db41",
"assets/assets/fonts/Rubik/Rubik-Italic.ttf": "5c0f34ddd45e3cf75ce29a3b9595ded8",
"assets/assets/unavailable.png": "f12714d0cd50936c14e34996cdf7fdda",
"assets/FontManifest.json": "50714b421c5787e2b2e32f1ac6cd1b4b",
"assets/AssetManifest.json": "41c24b096164c69e32ce306e1c59ea44",
"assets/packages/cupertino_icons/assets/CupertinoIcons.ttf": "89ed8f4e49bcdfc0b5bfc9b24591e347",
"assets/NOTICES": "de1c4caf8f5626097786edd67eac6781",
"assets/fonts/MaterialIcons-Regular.otf": "30041bbd71b8c86b2f5f860787173c6d",
"assets/AssetManifest.bin.json": "1ace95bbd19f3f6a4beb8dba42226bf0",
"version.json": "bbb0b872172d49fa75b85ce9c87b5c9b",
"flutter.js": "7d69e653079438abfbb24b82a655b0a4",
"canvaskit/canvaskit.wasm": "73584c1a3367e3eaf757647a8f5c5989",
"canvaskit/chromium/canvaskit.wasm": "143af6ff368f9cd21c863bfa4274c406",
"canvaskit/chromium/canvaskit.js": "0ae8bbcc58155679458a0f7a00f66873",
"canvaskit/skwasm.wasm": "2fc47c0a0c3c7af8542b601634fe9674",
"canvaskit/skwasm.worker.js": "bfb704a6c714a75da9ef320991e88b03",
"canvaskit/canvaskit.js": "eb8797020acdbdf96a12fb0405582c1b",
"canvaskit/skwasm.js": "87063acf45c5e1ab9565dcf06b0c18b8",
"index.html": "77afe41a98f66433950c4e6aa0ac306b",
"/": "77afe41a98f66433950c4e6aa0ac306b",
"favicon.png": "5dcef449791fa27946b3d35ad8803796",
"drift_worker.js": "dbaa92b41d5be5dc52f32207f7bd0d1f",
"icons/Icon-512.png": "96e752610906ba2a93c65f8abe1645f1",
"icons/Icon-maskable-192.png": "c457ef57daa1d16f64b27b786ec2ea3c",
"icons/Icon-192.png": "ac9a721a12bbc803b44f645561ecb1e1",
"icons/Icon-maskable-512.png": "301a7604d45b3e739efc881eb04896ea",
"manifest.json": "be69db5ad45f6e74a12907ab99acf7d6",
"sqlite3.wasm": "59b0b16e9818fad51d4ec7c1400fd1dd",
"sqlite3.debug.wasm": "a7919daa0652b9df059f2dec1d2cb55e"};
// The application shell files that are downloaded before a service worker can
// start.
const CORE = ["main.dart.js",
"index.html",
"assets/AssetManifest.json",
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
