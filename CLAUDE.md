# LinkVault — Contexto del Proyecto

## Descripción
App Android (Flutter) para guardar y organizar links desde cualquier app via Share Sheet.
Desarrollador: Rayan / RayanCode28 · Bundle ID: `com.rayancode98.linkvault`

## Stack
- Flutter 3.44.1 (instalado via Homebrew) · Dart 3.12.1
- go_router ^14 · provider ^6 · shared_preferences ^2 · url_launcher ^6 · google_fonts ^6
- sqflite ^2 · http ^1 · html_unescape ^2 · flutter_sharing_intent ^2
- share_plus ^12 · file_picker ^10 · cached_network_image ^3 · package_info_plus ^9
- purchases_flutter ^10 (RevenueCat) · google_mobile_ads ^9 (AdMob)
- firebase_core ^4 · firebase_auth ^6 · firebase_storage ^13 · google_sign_in ^7 (cloud backup Pro)
- flutter_localizations (SDK) + intl — i18n con gen-l10n (ver sección Internacionalización)
  - ⚠️ share_plus/file_picker/package_info_plus están fijados a esas majors por un
    conflicto de `win32` (solo afecta resolución, no Android). No subirlos por separado.
- Target: Android (Google Play Store)

## Diseño — Variación Neon
- Fondo: `#030A06` · Acento: `#00FFD1` (cyan) · Superficie: `#091410`
- Fuente: Plus Jakarta Sans (google_fonts)
- Sombras tipo glow cyan en cards, FAB, chips activos, bottom sheet
- Todos los tokens en `lib/core/theme.dart`

## Estructura
```
lib/
├── main.dart                        # Entry point, SystemUI, init provider+router
├── app.dart                         # MaterialApp.router, listener de Share Intent, scaffoldMessengerKey global
├── core/
│   ├── theme.dart                   # AppColors, AppShadows, AppRadius, AppTextStyles, buildAppTheme()
│   ├── models.dart                  # LinkItem, Collection (inmutables, toMap/fromMap), LinkFilter, parseWebUrl(), formatDate()
│   ├── links_provider.dart          # LinksProvider: CRUD links/colecciones sobre SQLite, search, filtros, export/importJson, límite Free
│   ├── metadata_service.dart        # Fetch Open Graph (og:title/description/image) con límites de tamaño/timeout, UA de navegador
│   ├── purchase_service.dart        # Wrapper RevenueCat: entitlement "Link Vault Pro", offerings, compra, restore; no-op sin API key
│   ├── backup_service.dart          # Cloud backup Pro: Google Sign-In (Firebase Auth) + Cloud Storage (blob JSON users/{uid}/backup.json)
│   └── share_intent_service.dart    # Recibe texto del Share Sheet y extrae la URL
├── l10n/                            # ARB por idioma (en/es/pt/fr/de) + app_localizations*.dart generados (gen-l10n)
├── database/
│   └── database_helper.dart         # sqflite singleton: tablas links + collections, FK ON DELETE SET NULL, seed 2 colecciones
├── features/
│   ├── onboarding/onboarding_screen.dart    # 3 pasos, PageView manual, SharedPreferences 'onboarded'
│   ├── home/
│   │   ├── home_screen.dart                 # AppBar, search bar tappable, FilterChipsBar, lista, FAB → AddLinkSheet
│   │   ├── add_link_sheet.dart              # Bottom sheet: URL + paste + CollectionPicker, valida con parseWebUrl
│   │   ├── link_card.dart                   # Card con thumbnail (og:image), título, dominio, colección, status dot/heart
│   │   └── filter_chips_bar.dart            # All | Unread | Read | ♥ Saved
│   ├── collections/
│   │   ├── collections_screen.dart          # Lista + crear (límite Free 3 → paywall) + long-press rename/delete
│   │   ├── collection_form_sheet.dart       # Crear/renombrar colección con picker de emoji
│   │   └── collection_detail_screen.dart    # Links por collectionId (desde provider), FAB agrega a la colección
│   ├── search/search_screen.dart            # TextField autofocus, busca título/dominio/url/descripción
│   ├── link_detail/
│   │   ├── link_detail_sheet.dart           # Sheet: thumbnail, URL real, badges, Share/Favorite/Edit/Delete(confirm)/Open
│   │   └── edit_link_sheet.dart             # Editar título + colección
│   ├── settings/settings_screen.dart        # Pro banner, Administrar suscripción (Pro), Export/Import JSON, Cloud backup, Rate, Feedback, versión
│   ├── settings/cloud_backup_sheet.dart     # Sheet cloud backup (Pro): sign-in Google, respaldar, restaurar, último respaldo, salir
│   └── paywall/paywall_screen.dart          # Icon+PRO badge, features, pricing cards monthly/yearly, NeonButton
└── shared/
    ├── router.dart                  # GoRouter; MainShell deriva el tab activo de la ruta
    ├── l10n.dart                    # export de AppLocalizations + extensión context.l10n
    └── widgets/
        ├── ad_banner.dart           # Banner AdMob (solo Free); ad unit de test por defecto, override con --dart-define
        ├── app_bottom_nav.dart      # 4 tabs: Links/Collections/Search/Settings, glow en activo
        ├── link_thumbnail.dart      # CachedNetworkImage de og:image → fallback favicon (Google s2) → 🔗
        ├── collection_picker.dart   # DropdownButtonFormField para elegir colección (Sin colección + todas)
        ├── neon_button.dart         # ElevatedButton accent + AppShadows.ctaButton glow
        └── neon_bg.dart             # RadialGradient cyan sutil en parte superior
```

## Navegación (go_router)
| Ruta | Pantalla |
|------|----------|
| `/onboarding` | OnboardingScreen (solo si `onboarded == false` en SharedPreferences) |
| `/` | HomeScreen (dentro de MainShell con BottomNav) |
| `/collections` | CollectionsScreen |
| `/search` | SearchScreen |
| `/settings` | SettingsScreen |
| `/collections/:id` | CollectionDetailScreen (push sobre el shell; resuelve la colección desde el provider) |
| `/paywall` | PaywallScreen (push sobre el shell) |

Link detail, add link, edit link y collection form NO son rutas — son bottom sheets
(`showLinkDetailSheet`, `showAddLinkSheet`, `showEditLinkSheet`, `showCollectionFormSheet`).

## Internacionalización
- 5 idiomas: en (plantilla), es, pt, fr, de — ARB en `lib/l10n/`, config en `l10n.yaml`
  (`nullable-getter: false`). La app sigue el idioma del dispositivo automáticamente
  (fallback: inglés). Los `app_localizations*.dart` se regeneran con `flutter gen-l10n`
  (también en cada build por `generate: true` en pubspec).
- Acceso en widgets: `context.l10n.<clave>` via la extensión de `lib/shared/l10n.dart`.
- Para agregar un string: añadirlo a `app_en.arb` (con metadata si lleva placeholders),
  traducirlo en los otros 4 ARB y correr `flutter gen-l10n`.
- Fechas localizadas con `DateFormat.yMMMd(locale)` (intl) en link_card y link_detail_sheet;
  `formatDate()` de models.dart queda como formato fijo en inglés (lo usan los tests).
- El snackbar del Share Intent (app.dart) localiza usando `scaffoldMessengerKey.currentContext`.

## Seguridad — reglas que ya aplica el código
- `parseWebUrl()` en `models.dart` es la única puerta de validación de URLs: solo
  http/https, host con punto. TODO lo que llega a `launchUrl` o a la red pasa por ahí
  (input manual, share intent, import JSON, og:image).
- `MetadataService` limita respuesta a 512 KB, timeout 8 s, máx 4 redirects, solo text/html.
- SQLite siempre con `whereArgs` parametrizados (nunca interpolar strings en SQL).
- `importJson` valida tipo por tipo, re-valida URLs, cap 5 MB / 5000 links / 200 colecciones,
  deduplica por URL. Lanza `FormatException` si no es backup de LinkVault.
- Delete de link pide confirmación con AlertDialog.

## Estado del Proyecto

### ✅ Completado (Sesión 1)
- UI completa con diseño Neon, router, onboarding, APK debug
- Repositorio en GitHub: https://github.com/RayanCode28/linkvault

### ✅ Completado (Sesión 2)
1. SQLite (`lib/database/database_helper.dart`) — reemplaza mock_data (eliminado); DB vacía con 2 colecciones seed (Watch later, Read later)
2. Share Sheet — `flutter_sharing_intent`, intent-filter `text/plain`, `launchMode="singleTask"`, snackbar "Link saved"
3. Fetch Open Graph — título/descripción/imagen al guardar (en background, el link aparece al instante)
4. Thumbnails reales — `cached_network_image` con fallback 🔗
5. Add Link dialog — FAB en Home y en detalle de colección
6. Export/Import JSON — Settings (share_plus / file_picker), con validación estricta
7. CRUD de colecciones — crear/renombrar/eliminar; límite Free de 3 (`kFreeCollectionLimit`) → paywall; `LinksProvider.isPro` stub para RevenueCat
8. Edit link (título + colección), Share, Open (URL real validada), Delete con confirmación
9. Settings: Rate (Play Store), Feedback (mailto), versión desde package_info_plus
10. Tests unitarios en `test/widget_test.dart` (parseWebUrl, extractUrl, parser OG, modelo) — `flutter test` ✅
11. `flutter analyze` limpio (0 issues) — se aplicó `dart fix` (const, withValues)

### ✅ Completado (Sesión 3)
1. i18n completo — 5 idiomas (en/es/pt/fr/de) con gen-l10n, selección automática por idioma del sistema
2. CollectionPicker pasó de chips horizontales a dropdown (afecta Add Link y Edit Link)
3. Miniaturas: UA de navegador en MetadataService (sitios que bloqueaban el UA custom ya
   devuelven Open Graph), acepta 2xx/xhtml, y LinkThumbnail cae a favicon del dominio
   (`google.com/s2/favicons`) cuando no hay og:image, antes del emoji 🔗
4. Settings: fila Language muestra el idioma activo; toasts con guards `mounted`

### ✅ Completado (Sesión 4)
1. **RevenueCat** — paywall funcional (`purchases_flutter ^10`)
   - `lib/core/purchase_service.dart`: configure + listener de CustomerInfo; entitlement `Link Vault Pro`
   - API key vía `--dart-define=REVENUECAT_API_KEY=goog_xxx` (nunca en el repo); sin key todo es no-op y la app corre como Free
   - `LinksProvider.isPro` real (`setPro`); paywall carga offerings (precios reales de la store), compra con manejo de cancelado/fallo, "Restaurar compras", estado "Ya eres Pro"; banner de Settings cambia según isPro
   - 11 strings nuevos × 5 idiomas (se eliminaron `startFreeTrial`/`trialNote`)
2. **AdMob** — `lib/shared/widgets/ad_banner.dart` al pie de Home, solo usuarios Free
   - App ID de TEST hardcodeado en AndroidManifest.xml (reemplazar por el real antes del release)
   - Ad unit de test por defecto; real vía `--dart-define=ADMOB_BANNER_ID=ca-app-pub-xxx/yyy`
3. **Firma release** — keystore en `android/app/upload-keystore.jks` + `android/key.properties` (ambos gitignored)
   - `build.gradle.kts` lee key.properties; sin él (CI/clones) cae a debug keys
   - ⚠️ HACER BACKUP del keystore y key.properties fuera del repo — si se pierden no se puede actualizar la app en Play
   - `ndkVersion` fijado a 28.2.13676358 (el instalado); se instaló cmdline-tools en el SDK → `flutter doctor` Android ✓
   - `flutter build appbundle --release` ✓ (AAB firmado con el keystore propio, libs stripped + símbolos en BUNDLE-METADATA)

### ✅ Completado (Sesión 9) — commit 3750f99
1. **Detalle del enlace** — imagen de portada full-bleed: toca el borde superior y los
   laterales con las esquinas superiores redondeadas (`AppRadius.sheetTop`); el tirador
   flota sobre la imagen. `LinkThumbnail` ahora acepta `width`/`height`/`borderRadius`.
2. **Card de enlaces (link_card.dart)** — rediseño horizontal:
   - Miniatura pegada al borde izquierdo, de borde a borde, altura completa (recorte vía
     `Container clipBehavior: Clip.antiAlias`); ancho 88, altura fija del card 88 (todos
     los cards miden igual, con o sin metadata)
   - Título en `Flexible` con `maxLines: 2` + elipsis (no desborda nunca)
   - Corazón de favorito superpuesto arriba-izquierda (`Stack`+`Positioned`, fontSize 10,
     con sombra), simétrico al punto verde de no-leído de la derecha
3. **Share intent** — al compartir un enlace a la app ya NO se guarda en silencio: abre el
   modal Agregar enlace con la URL pegada y obliga a elegir/crear colección. Se agregó
   `rootNavigatorKey` en `router.dart` para abrir el sheet desde `app.dart`.
4. **Colección obligatoria al agregar** — `AddLinkSheet` valida colección (acepta `initialUrl`);
   `CollectionPicker` ganó `allowNone` (false al agregar, con hint) y `onCreateNew` (ítem
   "Nueva colección" inline → form o paywall si llegó al límite Free). `showCollectionFormSheet`
   devuelve la `Collection` creada. Editar enlace sigue permitiendo "Sin colección".
5. **Exportar local** — `settings_screen` usa `FilePicker.platform.saveFile` (con `bytes`):
   guarda el JSON directo en el almacenamiento del móvil vía el diálogo del sistema, sin
   share sheet. Probado y funcionando. Import/export local son Free (solo "Cloud backup" es Pro).
6. **Home** — barra de búsqueda + filtros (`FilterChipsBar`) fijos fuera del `CustomScrollView`;
   solo la lista hace scroll.
7. **Colecciones** — separador (`Divider`) + encabezado "Mis colecciones" tras la fila virtual
   "Sin categoría" (solo si hay colecciones del usuario).
8. 4 strings nuevos × 5 idiomas: `selectCollectionHint`, `collectionRequired`, `exportSaved`,
   `myCollections`. `flutter analyze` limpio, 15 tests ✓.

### ✅ Completado (Sesión 10) — commit 4c8fc67
1. **RevenueCat — cuenta creada y validada (Test Store)**
   - Organización **"Lunasof Apps"**; entitlement renombrado a `Link Vault Pro` (debe
     coincidir con `kProEntitlement`); offering `default` **Current** con packages
     **Monthly + Yearly** (modelo de precios elegido: Mensual + Anual, sin lifetime).
   - Probado en emulador y móvil con la **`test_` key** (Test Store / `SimulatedStore`):
     compra Pro funciona, `isPro` se activa. La key de producción `goog_` aparecerá al
     conectar Google Play (pendiente de verificación de Play).
2. **`--dart-define-from-file`** — la key vive en `dart_defines.json` (gitignored, NO subir).
   Se corre con `flutter run --dart-define-from-file=dart_defines.json`. La run config de
   Android Studio (`.idea/runConfigurations/main_dart.xml`) ya pasa ese flag.
   ⚠️ El botón Run del IDE / tocar el ícono en el emulador SIN la key → app corre como Free
   (RevenueCat es no-op; `isPro` no persiste, se deriva de RevenueCat en cada arranque).
3. **Botón "Administrar suscripción"** en Ajustes (solo Pro, bajo el banner Pro) → abre
   `https://play.google.com/store/account/subscriptions` (cancelar/cambiar plan). Reusa
   `_openUrl`. Cancelaciones/reembolsos los gestiona Google; la app baja a Free sola al
   expirar el entitlement (local-first, ya implementado). Falta configurar **RTDN** (Pub/Sub)
   en Play↔RevenueCat para revocar al instante en reembolsos.
4. **Cloud backup (Pro) con Firebase** — proyecto **`linkvault-e0799`**
   - `core/backup_service.dart`: Google Sign-In (Firebase Auth) + Cloud Storage; un blob
     `users/{uid}/backup.json` con el `exportJson()`. Local-first, best-effort en `try/catch`,
     restaura con `importJson` (valida/capa 5MB). Web client ID hardcodeado (de google-services).
   - `features/settings/cloud_backup_sheet.dart`: sign-in, respaldar, restaurar (con confirm),
     último respaldo, cerrar sesión. La fila ☁️ de Ajustes: Pro abre el sheet, Free → paywall.
   - `Firebase.initializeApp()` en `main.dart` (guardado con try/catch).
   - Gradle: plugin `com.google.gms.google-services` en `settings.gradle.kts` + app; archivo
     `android/app/google-services.json` **committeado** (repo privado).
   - Firebase consola: Auth Google habilitado; SHA-1/256 de **debug + release** agregados;
     Cloud Storage en plan **Blaze** (prepago $30 reembolsable + alerta de presupuesto);
     reglas de Storage publicadas (cada uid solo accede a su archivo).
   - Deps nuevas: `firebase_core`/`firebase_auth`/`firebase_storage`, `google_sign_in ^7`
     (API v7: `GoogleSignIn.instance.initialize`/`authenticate`). `win32` NO se tocó.
5. 14 strings nuevas × 5 idiomas (manageSubscription + 13 de cloud backup). `flutter analyze`
   limpio, 15 tests ✓. APK release arm64 (24 MB) generado para probar en móvil real.

### 🔲 Pendiente (próximas sesiones)
1. **Probar cloud backup en móvil real** — sign-in con Google + respaldar/restaurar contra
   Firebase (APK release ya instalado). Confirmar que funciona end-to-end.
2. **AdMob** (cuenta en verificación) — al activarse: crear app (manual, sin Play) + ad unit
   Banner; reemplazar App ID de test en `AndroidManifest.xml` (línea ~41) por el real
   (`ca-app-pub-xxx~yyy`); el ad unit real va por `--dart-define=ADMOB_BANNER_ID=` SOLO en
   release (en dev se dejan los de test para no arriesgar ban por auto-clics).
3. **Google Play** (cuenta en verificación) — al activarse:
   - Crear suscripciones `linkvault_pro_monthly` / `linkvault_pro_yearly` (mismos IDs en RevenueCat).
   - Conectar Play↔RevenueCat (Service Account JSON) → aparece la key `goog_`; ponerla en
     `dart_defines.json` para release.
   - Agregar a Firebase la **SHA-1 de Play App Signing** (Google re-firma el AAB) o Google
     Sign-In falla en la app publicada.
   - Configurar RTDN (Pub/Sub) para revocar entitlement en reembolsos.
   - Probar compras sandbox (tester licenciado), subir AAB.
4. **Quitar bloque TEMP** de `main.dart` (resetea onboarding/tour cada arranque) antes del AAB de release.
5. **Política de privacidad** — URL pública (obligatoria por anuncios + compras + datos).
6. **Onboarding assets** — las 3 pantallas usan arte vectorial generado en código (no imágenes externas)
7. (Opcional) Tema claro — la fila de Settings es informativa por ahora

## Comandos Útiles
```bash
# Correr en emulador (desde la carpeta del proyecto)
cd "/Users/bsalgado/Desktop/Brayan/Link Vault/linkvault"
flutter run

# Tests y análisis
flutter test
flutter analyze

# Correr con keys (RevenueCat) — necesario para probar Pro/cloud backup
flutter run --dart-define-from-file=dart_defines.json

# Build APK release para probar en móvil (liviano; arm64 = teléfonos modernos)
flutter build apk --release --split-per-abi --dart-define-from-file=dart_defines.json
#  → build/app/outputs/flutter-apk/app-arm64-v8a-release.apk

# Build AAB para Play Store (firma con android/app/upload-keystore.jks via key.properties)
# Para producción usar dart_defines.json con la key goog_ real + ADMOB real:
flutter build appbundle --release \
  --dart-define-from-file=dart_defines.json \
  --dart-define=ADMOB_BANNER_ID=ca-app-pub-xxx/yyy

# Limpiar cache
flutter clean && flutter pub get
```

## Servicios Externos
| Servicio | Estado | Notas |
|----------|--------|-------|
| Google Play Console | En verificación | Bundle ID: com.rayancode98.linkvault |
| RevenueCat | Test Store OK | Org "Lunasof Apps"; entitlement `Link Vault Pro`; offering Monthly+Yearly. `test_` key en `dart_defines.json` (gitignored). Falta conectar Play → key `goog_` |
| Firebase | Activo (Blaze) | Proyecto `linkvault-e0799`; Auth Google + Cloud Storage; reglas publicadas. `google-services.json` en `android/app/` (committeado, repo privado) |
| AdMob | En verificación | IDs de TEST en código; reemplazar al activarse la cuenta |
| GitHub | Activo (privado) | github.com/RayanCode28/linkvault |

## Notas Importantes
- Gradle directo requiere `JAVA_HOME="/Applications/Android Studio.app/Contents/jbr/Contents/Home"` (no hay JDK del sistema); `flutter build` lo resuelve solo
- Para testing: agregar `await prefs.setBool('onboarded', false)` en main.dart para resetear onboarding
- El emoji/color de thumbnail ya no existe en el modelo — el thumbnail es og:image o 🔗
