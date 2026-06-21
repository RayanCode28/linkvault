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
   limpio, 15 tests ✓. APK release arm64 generado para probar en móvil real.
6. **Fix crash del build release** (commit aparte):
   - AGP 9 activaba R8/minify por defecto → eliminaba clases de WorkManager/Room que usa
     `google_mobile_ads` por reflexión → crash al arrancar. Solución: `isMinifyEnabled = false`
     + `isShrinkResources = false` en el buildType release (`android/app/build.gradle.kts`).
     Dart ya viene AOT, no hace falta minificar el wrapper Android. **Este fix se queda.**
   - ⚠️ **RevenueCat crashea si la `test_` key va en un build RELEASE** (regla de RevenueCat;
     la test key solo vale en debug). Para probar release HOY (sin la `goog_` aún): compilar
     SIN la key (`flutter build apk --release --split-per-abi`, sin `--dart-define-from-file`).
   - 🔧 **HACK LOCAL (NO committeado): `provider.setPro(true)` TEMP en `main.dart`** para
     poder entrar a Cloud backup en ese release sin key. Vive solo en el working tree; `git
     status` lo muestra como `lib/main.dart` modificado. Quitar antes del release real.

### ✅ Completado (Sesión 11) — commit f06b9ef
1. **main.dart limpio** (commit 9ab753b) — quitados los bloques TEMP de testing (reset de
   onboarding/tour cada arranque). El `provider.setPro(true)` ya no estaba. Sin bloques TEMP.
2. **Cloud backup validado end-to-end en móvil real** — sign-in Google + respaldar/restaurar
   contra Firebase funcionó con la cuenta del dev. ✅
3. **Política de privacidad** — `lib/features/settings/privacy_policy_screen.dart` (ruta
   `/privacy`, fila 🔒 en Ajustes→Acerca de). Texto legal completo localizado en 5 idiomas
   (el texto vive en el propio archivo, keyed por idioma + fallback en; solo la etiqueta
   `privacyPolicy` en ARB), redactado según las actividades reales (datos locales, fetch OG,
   cloud backup Firebase, compras Play+RevenueCat, AdMob, terceros, retención, menores).
   - `docs/privacy-policy.html` — mismo texto, para hospedar en **GitHub Pages** (repo ya
     hecho **PÚBLICO**). URL esperada: `https://rayancode28.github.io/linkvault/privacy-policy.html`.
     ⚠️ Falta activar Pages (Settings→Pages, branch `main` carpeta `/docs`) y pegar la URL en
     Play Console (Contenido de la app + Data Safety).
   - Correo de contacto UNIFICADO en toda la app (política + feedback de Ajustes) =
     **lunasoftapps@gmail.com** (commits 2ca11e0 + 1e5d1f5).
4. **Play App Signing en Firebase** (commit f06b9ef) — SHA-1
   `14:E6:D1:3A:18:94:10:C8:E3:5F:5F:47:A3:B3:75:C9:1E:C3:5C:1A` y SHA-256 de la clave de
   firma de Play agregadas a Firebase; `google-services.json` actualizado y committeado
   (conserva también las huellas de debug/upload para builds locales).
5. **AAB de prueba interna PUBLICADO en Play Console** — `app-release.aab` v1.2.0+1, firmado
   con upload keystore, **SIN `dart_defines`** (RevenueCat no-op → corre Free; evita el crash
   de la `test_` key en release). AdMob con IDs de test. Estado en Play:
   **"disponible para verificadores internos"**. Advertencia de "archivo de desofuscación
   faltante" → ignorable (minify desactivado, no hay mapping). El requisito de **12 testers ×
   14 días NO aplica a prueba interna** (es para prueba cerrada → producción con cuenta
   personal nueva).
   - ⚠️ Pendiente del dev: abrir el enlace de participación en el móvil (cuenta tester) e
     instalar; verificar que arranca sin crash, guardar/compartir links, ver pantalla de
     privacidad. Pro/cloud backup pedirá Pro (esperado, sin key en esta build).

### ✅ Completado (Sesión 12)
1. **Prueba interna validada en móvil real** — la build de prueba interna (`v1.2.0+1`, sin
   keys) se instaló desde el enlace de participación y arrancó sin crash; flujo básico OK
   (guardar/compartir links, pantalla de privacidad). Pro/cloud backup pidió Pro, como se
   esperaba en esa build. ✅
2. **GitHub Pages ACTIVO** — la política de privacidad ya se sirve pública (HTTP 200):
   `https://rayancode28.github.io/linkvault/privacy-policy.html` (`<title>LinkVault — Privacy
   Policy</title>` confirmado). No hizo falta tocar el repo: `docs/privacy-policy.html` ya
   estaba committeado.
   - ⚠️ **ÚNICO pendiente accionable ahora (manual en Play Console):** pegar esa URL en
     (a) **Contenido de la app → Política de privacidad** y (b) **Seguridad de los datos
     (Data Safety)** + completar el formulario. Declarar: datos locales (links), fetch Open
     Graph (metadata), cloud backup Firebase (opcional/Pro, login Google), compras
     (Play+RevenueCat), AdMob (solo Free). Sin cambios de código.

### ✅ Completado (Sesión 13) — commit dc68444
**Foco: llenar las declaraciones y la ficha de Play Console (con asistencia, campo por campo).**
1. **Detalles de acceso (App access) → "No (sin restricciones)".** Decisión estratégica clave:
   esta sección es para **muros de login**, y LinkVault **no tiene** (se usa todo sin cuenta).
   Pro NO está atado a un login in-app: en `purchase_service.dart` RevenueCat usa **App User ID
   anónimo** (no hace `logIn` con Firebase/Google), así que Pro vive en la **cuenta de Google
   Play del dispositivo**. Por eso "dar un usuario de prueba con Pro" NO activa Pro al revisor;
   el IAP lo revisa Google por su lado. (Se descartó la ruta "Sí + credenciales".)
2. **Clasificación de contenido (IARC):** compra de productos digitales = **Sí**; artículos
   aleatorios/cajas de botín = **No**; recompensas monetarias/tarjetas/cripto/NFT = **No**.
3. **Público objetivo y contenido:** grupo etario **solo 18+**; **restringir acceso a menores =
   Sí** (queda FUERA del programa Diseñado para Familias). No apela a niños.
4. **Seguridad de los datos (Data Safety) — llenada por IMPORTACIÓN CSV.** Play exporta/importa
   un CSV (`~/Downloads/data_safety_export.csv`). Se generó el lleno con script:
   `~/Downloads/data_safety_export_filled.csv`. Respuestas: recopila datos = Sí; encriptados en
   tránsito = Sí; método de cuenta = **OAuth** (Google Sign-In); borrado por el usuario = **No**;
   URL de eliminación de cuenta agregada. **10 tipos de datos declarados**: Nombre, Correo, ID de
   usuario, Historial de compras, Otro contenido del usuario (respaldo de links), Ubicación
   aproximada, Interacciones en la app, ID de dispositivo, Registros de fallos, Diagnóstico.
   Criterio: Firebase/RevenueCat = **solo Recopila** (proveedor de servicio); **AdMob =
   Recopila + Comparte** (Publicidad+Estadísticas+Seguridad). Nombre/Correo/backup = **Opcional**;
   ID/compras/AdMob = **Obligatorio**. ⚠️ El campo `..._EPHEMERAL` exige valor explícito → se puso
   **`false`** en los 10 (no efímeros). Script en `/tmp/fill_ds.py` (regenerable).
5. **ID de publicidad = Sí** (AdMob inyecta `AD_ID`); finalidades: Publicidad, Estadísticas,
   Seguridad/prevención de fraudes.
6. **Funciones financieras = ninguna.**
7. **Etiquetas de la app:** **Productividad + Bloc de notas** (el catálogo cerrado de Play NO
   tiene "bookmark/read later/organizador"; esas dos son las más fieles). Categoría: Productividad.
8. **Detalles de contacto:** correo `lunasoftapps@gmail.com`; teléfono **vacío** (opcional, es
   público); sitio web `https://rayancode28.github.io/linkvault/`.
9. **Ficha de Play Store (idioma predeterminado = ESPAÑOL):** copy lista en español (nombre
   `LinkVault: Guarda Links` 23 chars; descripción corta 72/80; descripción larga 2976/4000).
   Traducida del documento ASO (`~/Desktop/Brayan/linkvault-aso-document.md`).
10. **Nuevas páginas en GitHub Pages (docs/, committeadas + LIVE HTTP 200):**
    - `docs/account-deletion.html` → `https://rayancode28.github.io/linkvault/account-deletion.html`
      (borrado de cuenta/datos vía correo; la app solo tiene `signOut`, NO borra el blob de la
      nube — el borrado real es por correo a 30 días).
    - `docs/index.html` → landing Neon en la **raíz** `https://rayancode28.github.io/linkvault/`
      (hero + 6 features + 3 pasos + footer con privacidad/eliminación/contacto). Sin botón GitHub.

### 🔲 Pendiente (próximas sesiones)
-1. **Recursos gráficos de la ficha** (Play los exige, NO son texto): **ícono 512×512** PNG,
   **gráfico destacado 1024×500**, **mín. 2 capturas** (idealmente las 5 del plan ASO sección 3).
   Bloquea publicar la ficha.
0. **Pegar URL de privacidad en Play Console** (Contenido de la app + Data Safety) — manual,
   sin código. Es lo único accionable sin esperar verificaciones de cuentas.
1. **Probar cloud backup en móvil real** — ✅ HECHO en sesión 11 (sign-in + respaldar/restaurar).
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
4. ~~Quitar los 2 bloques TEMP de main.dart~~ — ✅ HECHO (sesión 11, main.dart limpio).
5. ~~Política de privacidad~~ — ✅ pantalla + HTML listos (sesión 11), **GitHub Pages activo
   (sesión 12)**. Solo falta pegar la URL pública en Play Console (ver punto 0).
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
| Google Play Console | Aprobada · prueba interna PUBLICADA | Bundle ID: com.rayancode98.linkvault. AAB v1.2.0+1 "disponible para verificadores internos". Play App Signing activo (SHA-1 14:E6:D1:3A…). Faltan subs + Play↔RevenueCat + RTDN para producción |
| RevenueCat | Test Store OK | Org "Lunasof Apps"; entitlement `Link Vault Pro`; offering Monthly+Yearly. `test_` key en `dart_defines.json` (gitignored). Falta conectar Play → key `goog_` |
| Firebase | Activo (Blaze) | Proyecto `linkvault-e0799`; Auth Google + Cloud Storage; reglas publicadas. `google-services.json` en `android/app/` con SHA-1/256 de Play App Signing + debug/upload (committeado) |
| AdMob | En verificación | IDs de TEST en código; reemplazar al activarse la cuenta |
| GitHub | Activo (**PÚBLICO**) | github.com/RayanCode28/linkvault. **GitHub Pages activo (HTTP 200)** → landing raíz `https://rayancode28.github.io/linkvault/` + `/privacy-policy.html` + `/account-deletion.html` (todo en `docs/`) |

## Notas Importantes
- Gradle directo requiere `JAVA_HOME="/Applications/Android Studio.app/Contents/jbr/Contents/Home"` (no hay JDK del sistema); `flutter build` lo resuelve solo
- Para testing: agregar `await prefs.setBool('onboarded', false)` en main.dart para resetear onboarding
- El emoji/color de thumbnail ya no existe en el modelo — el thumbnail es og:image o 🔗
