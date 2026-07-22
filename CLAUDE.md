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
│   │   ├── home_screen.dart                 # AppBar, búsqueda in-place (TextField filtra la lista), FilterChipsBar, lista, FAB → AddLinkSheet
│   │   ├── add_link_sheet.dart              # Bottom sheet: URL + paste + CollectionPicker, valida con parseWebUrl
│   │   ├── link_card.dart                   # Card con thumbnail (og:image), título, dominio, colección, status dot/heart
│   │   └── filter_chips_bar.dart            # All | Unread | Read | ♥ Saved
│   ├── collections/
│   │   ├── collections_screen.dart          # Lista + crear (límite Free 3 → paywall) + long-press rename/delete
│   │   ├── collection_form_sheet.dart       # Crear/renombrar colección con picker de emoji
│   │   └── collection_detail_screen.dart    # Links por collectionId (desde provider), FAB agrega a la colección
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

### ✅ Completado (Sesión 14) — sin commits de código (trabajo en consolas)
1. **Cuenta de Google Play 100% APROBADA.**
2. **Recursos gráficos + contenido de la ficha** — el dev generó ícono 512×512, gráfico
   destacado 1024×500 (estilo Neon: fondo `#030A06`, acento `#00FFD1`) y capturas; llenó el
   contenido de la ficha en Play Console.
3. **Suscripciones Pro creadas y ACTIVAS** (Monetizar→Productos→Suscripciones):
   - `linkvault_pro_monthly` — "LinkVault Pro (Mensual)" — plan base `monthly`, **P1M**, **$1.99 USD**
   - `linkvault_pro_yearly` — "LinkVault Pro (Anual)" — plan base `yearly`, **P1Y**, **$9.99 USD**
   - Ambas: categoría fiscal "Ventas de apps digitales", cumplimiento "Servicio", gracia 7 días,
     suspensión auto, "volver a suscribirse" Permitir. USD base + autoconversión por región.
     Sin free trial al inicio (se añade luego en Ofertas). Google retiene 15% (primeros $1M/año).
   - **Identificadores para RevenueCat** (formato `suscripción:planBase`):
     `linkvault_pro_monthly:monthly` y `linkvault_pro_yearly:yearly` → entitlement `Link Vault Pro`,
     offering `default`. El paywall carga precios reales de la store, NADA hardcodeado que tocar.
4. **Plan de prueba cerrada (12 testers × 14 días):** el dev contratará 12 personas. La build
   de prueba interna actual corre Free (sin keys). Para que prueben TODO (Pro/cloud backup) hay
   que **compilar un AAB NUEVO CON la key `goog_`** (subir versionCode, ej. `1.2.1+2`) y agregar
   a los 12 como **License testers** (compras de prueba SIN cobro real). AdMob: dejar IDs de TEST
   en esa build. Ficha es compartida (no se rehace); subir versiones nuevas NO reinicia el contador.

### ✅ Completado (Sesión 15) — sin commits (`.gitignore` modificado, sin commit todavía)
**Foco: avanzar la integración Play ↔ RevenueCat. Fases 1, 2 y parte de 3 hechas; faltan
productos + `goog_` (bloqueado por propagación de permisos de Google, hasta 24h).**

1. **Correo de Verificación de Desarrolladores de Android (Play)** — Google registró
   automáticamente LinkVault con la clave de Play App Signing. **NO hay nada que hacer**: la
   app aparece "Registrada" en la página principal de la cuenta. El correo solo pediría acción
   si distribuyeras fuera de Play (no es el caso). Confirmado por el dev.
2. **FASE 1 ✅ — Service Account en Google Cloud creado.**
   - Proyecto: `linkvault-e0799` (reusando el de Firebase, decisión deliberada para no duplicar
     consolas/facturación).
   - SA: **`revenuecat-play-integration@linkvault-e0799.iam.gserviceaccount.com`**.
   - Clave JSON descargada y movida al proyecto como **`revenuecat-service-account.json`**
     (raíz). **Gitignored** vía patrón nuevo `*-service-account*.json` en `.gitignore` (+ línea
     explícita del archivo). Original en `~/Downloads` ya **borrada** — única copia vive en el
     working tree, NO en repo. `git check-ignore` verificado.
   - **API "Google Play Android Developer" habilitada** en el mismo proyecto GCloud.
3. **FASE 2 ✅ — Service Account invitado en Play Console** con permisos mínimos:
   - ☑ Ver la información de la app (requerido por Play como prerequisito; auto-marca también
     "Ver información de calidad" — no se puede desmarcar, no afecta).
   - ☑ Ver los datos financieros
   - ☑ Administrar los pedidos y las suscripciones
   - **Sin Administrador**, ni Versiones, ni Play Store, ni nada de escritura — principio de
     mínimo privilegio.
4. **FASE 3 (parcial) — RevenueCat configurado, productos pendientes.**
   - **Proyecto renombrado** en RevenueCat de "Lunasof Apps" (duplicaba la org) a **"LinkVault"**.
     Solo cosmético, no afecta keys/IDs/entitlement/código.
   - **App de Google Play creada en RevenueCat** con package `com.rayancode98.linkvault`.
     Campo "Financial reports bucket ID" dejado VACÍO (solo sirve para importar historial
     de ventas viejas; LinkVault no tiene).
   - **JSON del SA subido a RevenueCat** correctamente.
   - ⚠️ Apareció warning **Pub/Sub (RTDN)** — **DECISIÓN: POSTPONER**. Suscripciones funcionan
     igual sin RTDN; solo los refunds/cancels tardan minutos/horas en revocarse en lugar de
     segundos. Aceptable para prueba cerrada (12 testers). **Cerrar antes del lanzamiento
     público a producción** (queda en pendientes abajo).
   - ⏳ "**Credentials need attention**" (3 APIs en rojo: subscriptions/inappproducts/monetization)
     al terminar la subida del JSON. **Es la propagación de permisos del SA en Play**
     (oficial Google: hasta 24h; típicamente 5–30 min). NO es error — solo esperar. Al pasar
     a verde, retomamos creación de productos.

### ✅ Completado (Sesión 16) — sin commits aún (`.gitignore` + `pubspec.yaml` + CLAUDE.md modificados)
**Foco: cerrar Play ↔ RevenueCat end-to-end + AAB v1.2.1+2 con `goog_` publicado en
pista Alpha + testers de Fiverr enrolados. Todo el flujo Pro ya es comprable en sandbox.**

1. **FASE 3 COMPLETADA en RevenueCat** (credenciales pasaron a verde tras propagación, < 24h):
   - **Productos creados vía "Import Products"** (RevenueCat los trajo automáticamente
     desde Play con los IDs correctos `linkvault_pro_monthly:monthly` /
     `linkvault_pro_yearly:yearly`; Backwards compatible quedó en `Sí` para ambos —
     coincide con Play, no se tocó). Más rápido que el formulario manual.
   - **Entitlement `Link Vault Pro`**: se hizo **Detach** de los 2 productos viejos de
     Test Store (sesión 10) y se hizo **Attach** de los 2 nuevos de LinkVault Android.
   - **Offering `default`**: en cada package (Monthly $rc_monthly / Yearly $rc_annual) el
     slot LinkVault Android se vinculó al producto correspondiente; el slot Test Store
     se puso en `No product` (limpieza, ya no se usa).
2. **API key `goog_BZTfYEtKHSskkbORYrniCsFOETI`** copiada y pegada en `dart_defines.json`
   (reemplazó la `test_` anterior). Archivo sigue gitignored.
3. **`pubspec.yaml`** subido de `1.2.0+1` → **`1.2.1+2`** (versionCode +1 obligatorio).
4. **AAB compilado y firmado** (`build/app/outputs/bundle/release/app-release.aab`, 68 MB)
   con `flutter build appbundle --release --dart-define-from-file=dart_defines.json`.
   - Warnings de KGP/cupertino_icons son de siempre, no rompen.
   - Firmado con `upload-keystore.jks` + `key.properties` (intactos).
   - AdMob con IDs de TEST (cuenta aún en verificación, no se pasa `ADMOB_BANNER_ID`).
5. **Pista de prueba cerrada "Alpha" en Play Console**:
   - Países: **177 + Resto del mundo** (todos).
   - Lista de probadores: se subió el **CSV de testers que mandó el seller de Fiverr**.
   - **License testers**: la MISMA lista se seleccionó en Configuración → Pruebas de
     licencias con respuesta `LICENSED` (compras sandbox sin cobro real). Una sola lista
     para los 2 propósitos (testers de pista + license testers) — más limpio que mantener
     dos espejos.
   - Versión `2 (1.2.1)` enviada a Google para revisión.
6. **Enlace de participación enviado al seller de Fiverr.** Seller confirmó recepción y
   empezará a enrolar a los testers en cuanto Google publique (4–12h típicos). Primer
   update de progreso esperado en 2-3 días; reporte final en 14 días.
7. **Decisión sobre demo Pro account para testers**: NO se da credencial de Pro. La app
   no tiene login in-app; Pro vive en la cuenta de Google Play del tester. La forma
   correcta de que prueben Pro es justamente License testers (compras sandbox). Se
   explicó al seller en el mensaje de respuesta.
8. **`.gitignore`** confirmado con el patrón `*-service-account*.json` de sesión 15
   (queda en este commit junto con `pubspec.yaml` y la documentación).

### ✅ Completado (Sesión 17) — AAB v1.2.2+4 (fixes de testers) subido a Alpha
**Foco: implementar el primer lote de feedback de testers (Oppo CPH2127, Android 12) uno
por uno con prueba entre cada punto, + AAB nuevo que cumple el update mínimo obligatorio de
la ventana de prueba cerrada.** Todo probado en emulador por el dev. `flutter analyze` limpio,
15 tests ✓.
1. **Fix favoritos (el más importante)** — `LinksProvider.toggleFavorite` hacía `await` de la
   escritura en SQLite ANTES de `notifyListeners`, así que en móviles de gama baja el corazón
   no respondía al primer toque (el usuario tocaba 2-3 veces). Ahora es **actualización
   optimista**: `_replace(updated)` refresca UI y notifica primero, luego persiste en DB. Arregla
   también una carrera latente. `markRead` tiene el mismo patrón pero NO se tocó (no reportado).
2. **Confirmación al cerrar sesión** — `cloud_backup_sheet.dart` `_signOut` ahora muestra
   `AlertDialog` (confirmar en color danger) antes de salir. 2 strings nuevas × 5 idiomas
   (`signOutConfirmTitle` / `signOutConfirmBody`).
3. **Pantalla de inicio (splash)** — antes fondo blanco/default → destello blanco. Ahora
   fondo oscuro de marca + ícono centrado, en TODAS las versiones de Android:
   - `res/values/colors.xml` (nuevo): `splash_bg = #FF030A06` (AppColors.bg).
   - `drawable/launch_background.xml` + `drawable-v21/`: color + `@mipmap/ic_launcher_foreground`
     centrado (Android ≤11).
   - `res/values-v31/styles.xml` + `res/values-night-v31/` (nuevos): SplashScreen API de
     **Android 12+** (`windowSplashScreenBackground` + `windowSplashScreenAnimatedIcon`). Sin
     esto Android 12 mostraba splash claro por defecto. **Este era el caso del tester del Oppo.**
   - Nota: el splash nativo NO admite texto arbitrario; "nombre de la app" quedó fuera (se haría
     con un splash en Flutter si se pide). El dev aprobó "fondo oscuro + ícono".
4. **Contraste del botón "cerrar sesión"** — era `textSec` (#5E9278) a 12.5px (muy tenue).
   Ahora `TextButton.icon` con ícono logout + `AppColors.text` (#E4F5EE) a 14px seminegrita.
5. **"Restaurar compras" en Ajustes** (añadido a raíz de una duda del dev sobre "iniciar
   sesión"). **Decisión clave de arquitectura reafirmada:** NO se agrega login genérico. Pro
   está atado a la cuenta de Google Play (App User ID anónimo en RevenueCat), NO a login in-app,
   y así se declaró a Play ("App access = No"). El caso "cambié de móvil" se resuelve con
   **restaurar compras**, no con login. El enlace bajo el banner de Ajustes ahora es dinámico:
   Pro → "Administrar suscripción" (como antes); Free → **"Restaurar compras"** (llama a
   `PurchaseService.restore()`, activa Pro si hay suscripción en esa cuenta Play). Reutiliza
   strings del paywall (`restorePurchases`/`restoreSuccess`/`restoreNothing`/`purchasesUnavailable`),
   nada nuevo que traducir. El sign-in de Google **sigue solo** para cloud backup (Pro).
   - Validado: con cuenta que NO ha comprado, restore dice "No se encontraron compras previas"
     = correcto (solo busca compras existentes). El dev NO está en License testers, así que no
     probó el ciclo de compra completo — se dio por bueno.
6. **Tema claro/sistema y "borrar datos" — APLAZADOS a producción** (post-aprobación). Toda la
   app usa `AppColors` oscuros hardcodeados; tema claro = refactor grande, mal momento a mitad
   de prueba, y contradice "solo oscuro" (sesión 6). El tester lo pidió; se le avisó que llega después.
7. **URL de privacidad en Play Console: YA PEGADA** (lo confirmó el dev). Pendiente 0 cerrado.
8. **`pubspec.yaml` → `1.2.2+4`**. Ojo: `1.2.2+3` (versionCode 3) dio error "ya se usó el código
   de la versión 3" al subir → se subió a **+4**. AAB firmado (upload keystore), key `goog_`,
   AdMob IDs de TEST (cuenta aún en verificación). Copia en `~/Downloads/linkvault-1.2.2+4.aab`.
   Se subió a la MISMA pista **Alpha** (cumple el update mínimo, NO reinicia el contador de 14 días).
9. Mensaje de "qué probar" entregado al seller en ES e inglés (5 puntos de arriba).

### ✅ Completado (Sesión 18) — 2º lote de fixes de testers (reporte QA PDF) — commit 510ceb9
**Reporte QA de Kefayatullah (Fiverr) sobre v1.2.2, Galaxy A15 / Android 16: 3 bugs menores +
1 sugerencia, 0 críticos/mayores. NO exige subida nueva durante la ventana (el update mínimo
ya se cumplió con v1.2.2+4); estos fixes van en el build de producción.** Los 3 verificados en
emulador (Android 17, también simulando A15: 720x1600 + 3 botones + font scale 1.5) con
capturas antes/durante/después. `flutter analyze` limpio, 15 tests ✓. Sin commit/AAB aún.
1. **Fix skip del tour (Issue #1)** — el "Skip pegado a la barra de navegación" NO era el
   onboarding (ese ya usa SafeArea y su Skip va arriba) sino el **spotlight tour**
   (`feature_tour.dart`): `TutorialCoachMark` usa `alignSkip: bottomRight` por defecto →
   chip encimado con el FAB destacado (paso 1), el bottom nav (paso 4) y la barra del
   sistema. Ahora `alignSkip: Alignment.topRight` (consistente con el Skip del onboarding).
   El margen del chip (`top: 6`) delataba que esa era la intención original.
2. **Fix scroll con lista vacía (Issue #2)** — el Home tenía un `SliverToBoxAdapter` de
   130px SIEMPRE (colchón para FAB/ad) → con 0 links el contenido medía viewport+130 y se
   arrastraba. Ahora `physics: NeverScrollableScrollPhysics` cuando está vacío y el spacer
   solo va con items. Search y collection detail ya estaban bien (Center estático).
3. **Fix transiciones transparentes (Issue #3)** — dos causas:
   - `SearchScreen` era la ÚNICA ruta pushada sin `NeonBg` (Scaffold 100% transparente) →
     se envolvió en `NeonBg` como collection detail/paywall/privacy.
   - `FadeUpwardsPageTransitionsBuilder` (theme.dart) es un **fade**: la ruta entrante se
     pinta semitransparente y la anterior se ve debajo (verificado con captura a mitad de
     animación: chips/textos en doble exposición). Ahora `CupertinoPageTransitionsBuilder`
     (slide horizontal, pantalla entrante 100% opaca desde el primer frame). Ojo Flutter
     3.44: ya no lo exporta material — `import 'package:flutter/cupertino.dart' show
     CupertinoPageTransitionsBuilder;`.
3b. **Búsqueda in-place en Home (eliminada la pantalla /search)** — feedback directo del dev:
   aunque el slide ya era opaco, Home y Search eran casi gemelas (misma barra + chips), así
   que CUALQUIER transición entre ellas se leía como superposición. Ahora la barra del Home
   es un `TextField` real que filtra la lista en vivo (busca título/dominio/url/descripción
   via `provider.search` + respeta el filtro activo; borde/ícono accent + botón × al
   escribir; sin resultados → `noResults(query)`). Se borró `lib/features/search/` y la ruta
   `/search` del router. La clave `startTyping` de l10n quedó sin uso (inofensiva). Probado
   end-to-end en emulador (share intent → guardar link → filtrar "flutter" → "zzz" sin
   resultados → limpiar).
4. **Sugerencia S1 identificada** (opcional, no urge): el "keyboard emoji" del reporte es el
   🎬 de "Watch later" (onboarding pág. 3 + colección seed), que a tamaño pequeño parece un
   teclado. Cambiarlo por ícono vectorial Material cuando toque pulir.
5. Dato del emulador: en Android 15+ el `systemNavigationBarColor` oscuro de main.dart se
   ignora (edge-to-edge forzado); la barra de 3 botones sale gris clara del sistema.

### ✅ Completado (Sesión 19) — build de PRODUCCIÓN v1.2.3+5 SIN anuncios
**Contexto: la cuenta de AdMob sigue sin poder verificarse (Google no envía el código SMS al
teléfono del dev). Decisión: lanzar a producción SIN anuncios y reactivarlos en un update
cuando AdMob verifique. NO hay penalización de Play por esto (los anuncios son opcionales).**
1. **Ads apagados por defecto en release** — `ad_banner.dart`: el unit id ya NO tiene fallback
   de test en release; `const adsEnabled = _bannerAdUnitId != ''`. Sin
   `--dart-define=ADMOB_BANNER_ID=...` el banner nunca se crea y `main.dart` NO llama a
   `MobileAds.instance.initialize()` (SDK muerto, cero tráfico de ads). En debug/profile se
   mantiene el unit de TEST de Google como fallback (para desarrollo, igual que antes).
   - El SDK `google_mobile_ads` SIGUE como dependencia (el manifest sigue mergeando el permiso
     `AD_ID`) → las declaraciones de Play (ID de publicidad = Sí, Data Safety con AdMob) se
     quedan COMO ESTÁN, siguen siendo consistentes. Lo único a cambiar en Play Console:
     **"¿Contiene anuncios?" → No** (App content → Anuncios); volver a "Sí" al reactivar.
   - **Reactivar ads después** = crear app+ad unit en AdMob, reemplazar el App ID de test en
     `AndroidManifest.xml` (~línea 41) por el real, recompilar con
     `--dart-define=ADMOB_BANNER_ID=ca-app-pub-xxx/yyy` y flip "Contiene anuncios = Sí".
     Cero cambios de código Dart.
2. **`pubspec.yaml` → `1.2.3+5`**. AAB firmado compilado con
   `flutter build appbundle --release --dart-define-from-file=dart_defines.json` (solo la key
   `goog_` de RevenueCat, SIN ADMOB_BANNER_ID). Copia en `~/Downloads/linkvault-1.2.3+5.aab`.
3. `flutter analyze` limpio, 15 tests ✓.
4. ⚠️ **Antes de enviar a producción quedan 2 cosas** (ver Pendientes): configurar **RTDN**
   (obligatorio, decidido en sesión 15) y flip de "¿Contiene anuncios?" a No.
5. **Guía de producción entregada al dev** (trabajo de consolas, en curso):
   - **RTDN en 3 fases**: (A) GCloud IAM → rol **`roles/pubsub.admin`** al SA
     `revenuecat-play-integration@…` — ojo: es "Administrador de Pub/Sub" a secas, NO
     "Pub/Sub Lite" (producto distinto; filtrar por el ID `pubsub.admin` en el buscador de
     roles); (B) RevenueCat → app LinkVault (Play Store) → "Connect to Google" crea el topic
     y da el Topic ID; (C) Play Console → Monetizar → Configuración de monetización → pegar
     Topic ID + "Enviar notificación de prueba".
   - **Flip anuncios**: Contenido de la app → Anuncios → "¿Contiene anuncios?" = **No**
     (resto de declaraciones intactas). Volver a "Sí" al reactivar AdMob.
   - **Solicitar acceso a producción**: respuestas del formulario redactadas (12 testers QA
     de Fiverr, hallazgos reportados, 2 updates durante la ventana v1.2.1→v1.2.2).
   - **Notas de la versión** para el release de producción (pegar al subir el AAB):
     ```
     <es-419>
     ¡Bienvenido a LinkVault! Guarda y organiza links desde cualquier app.
     • Guarda enlaces al instante desde el menú Compartir
     • Organízalos en colecciones con vista previa automática
     • Búsqueda integrada, favoritos y modo leído/no leído
     • LinkVault Pro: colecciones ilimitadas y respaldo en la nube
     </es-419>
     <en-US>
     Welcome to LinkVault! Save and organize links from any app.
     • Save links instantly from the Share menu
     • Organize them into collections with automatic previews
     • Built-in search, favorites, and read/unread tracking
     • LinkVault Pro: unlimited collections and cloud backup
     </en-US>
     ```
   - Advertencia de "archivo de desofuscación" al subir el AAB = ignorable (como siempre).
   - Próximo objetivo del dev tras enviar: preparar cuentas de redes sociales para difusión.

### ✅ Completado (Sesión 20) — RTDN Play↔RevenueCat CONFIGURADO end-to-end
**Foco: cerrar el pendiente obligatorio de RTDN antes de producción. Todo trabajo de consolas
guiado paso a paso; sin cambios de código.**
1. **Fase A — rol Pub/Sub en GCloud:** el primer intento del dev quedó guardado en el lugar
   equivocado (la consola mostraba "Administrador de Pub/Sub" en el SA pero la API devolvía
   403 `IAM_PERMISSION_DENIED` — casi seguro se otorgó en Cuentas de servicio → pestaña
   Permisos, que concede sobre el SA *como recurso*, no sobre el proyecto). Se re-otorgó desde
   **IAM → "+ Otorgar acceso"** (principal `revenuecat-play-integration@…` + rol
   `roles/pubsub.admin`, sin condición) → activo al instante.
   - **Truco de diagnóstico reutilizable**: script Python local (stdlib + openssl, sin gcloud)
     que firma el JWT del SA con `revenuecat-service-account.json`, saca token OAuth y llama a
     la API de Pub/Sub. Permitió confirmar que el 403 era real de Google (no caché de
     RevenueCat) y ver el momento exacto en que el permiso quedó vivo. Cloud Shell NO sirvió
     (bug del gcloud nuevo: "Regional Access Boundary… Gaia id not found").
   - La **API Cloud Pub/Sub** ya estaba habilitada en `linkvault-e0799` (verificado).
2. **Fase B — RevenueCat "Connect to Google"**: con el permiso vivo, el desplegable (antes
   vacío + popup de "no permissions") ofreció el topic sugerido y conectó a la primera.
   Verificado por API: topic **`projects/linkvault-e0799/topics/Play-Store-Notifications`**
   creado, con `google-play-developer-notifications@system.gserviceaccount.com` como
   **Pub/Sub Publisher** y la suscripción **`RevenueCat-Subscriber-app36d0efaeb2`** escuchando.
3. **Fase C — Play Console**: Monetizar con Play → Configuración de monetización → Topic ID
   pegado (ojo: respeta MAYÚSCULAS, `Play-Store-Notifications`), alcance **"Suscripciones,
   compras anuladas y todos los productos únicos"** (lo que recomienda RevenueCat; future-proof
   si algún día hay producto único), **"Enviar notificación de prueba" → OK**. Desde ahora los
   refunds/cancels revocan el entitlement Pro en segundos.
4. **Flip de anuncios HECHO** — Contenido de la app → Anuncios → "¿Contiene anuncios?" = **No**
   (enviado a revisión vía Vista general de publicación). Resto de declaraciones intactas
   (AD_ID = Sí, Data Safety con AdMob siguen siendo consistentes porque el SDK va empaquetado).
5. **Solicitud de acceso a producción ENVIADA** (Dashboard → "Solicitar acceso a producción").
   El seller mandó una guía del cuestionario (`~/Downloads/Production Application Guide.pdf`,
   9 preguntas). Se respondió con textos personalizados para LinkVault (máx 300 chars por
   campo, verificados por script): reclutamiento = proveedor de testing de pago (Fiverr, 12
   testers, license testers); Q2 = "Fácil"; engagement = 2 rondas de feedback + reporte QA
   formal; público = adultos 18+; valor = guardar links en 2 toques + colecciones + Pro;
   Q6 instalaciones = 0–10k; cambios = 2 updates v1.2.1→v1.2.2 con el 100% de hallazgos;
   listo para producción = 0 bugs críticos/mayores en reporte QA final + compras validadas
   en sandbox. NO se subió AAB nuevo antes de solicitar (no hace falta: Google evalúa la
   prueba cerrada ya completada con v1.2.2+4).
6. **SIGUIENTE SESIÓN — cuando Google apruebe el acceso** (horas a ~7 días): pista
   **Producción** → Crear versión → subir `~/Downloads/linkvault-1.2.3+5.aab` + notas de
   versión de sesión 19 → enviar a revisión (advertencia de desofuscación = ignorable).
   Tras publicar: preparar redes sociales para difusión.

### ✅ Completado (Sesión 21) — 🚀 v1.2.3+5 ENVIADA A PRODUCCIÓN (en revisión)
1. **Google APROBÓ el acceso a producción** (confirmado por el dev el 22-jul-2026).
2. La copia del AAB en Downloads se había borrado; se restauró desde
   `build/app/outputs/bundle/release/app-release.aab` (68 MB, build del 11-jul, es el
   v1.2.3+5 con key `goog_` y sin anuncios) → `~/Downloads/linkvault-1.2.3+5.aab`.
3. **El dev creó la versión de Producción en Play Console**: AAB v5 (1.2.3) subido, notas
   de versión de sesión 19 (es-419 + en-US) pegadas, **enviada a revisión**. Estado actual:
   "cambios de lanzamiento en revisión". Revisión típica del primer release: 1–7 días.
4. Al publicarse: las compras pasan a ser reales para usuarios normales (license testers
   siguen en sandbox); la app corre sin anuncios y con Pro/RTDN operativos.
5. **SIGUIENTE**: cuando pase a "Disponible en Google Play" → preparar redes sociales para
   difusión; luego pendientes post-lanzamiento (AdMob cuando verifique, tema claro,
   borrar datos).

### ✅ Completado (Sesión 22) — 🎉 v1.2.3+5 DISPONIBLE GLOBALMENTE en Google Play
1. **LinkVault publicada y disponible al público en Google Play** (confirmado por el dev,
   22-jul-2026). La revisión de producción pasó; la app corre sin anuncios, con Pro
   (RevenueCat) y RTDN operativos, y compras ya reales para usuarios normales (los
   License testers del seller siguen en sandbox).
2. Con la app en vivo, el foco pasa de desarrollo/Play Console a **marketing y
   adquisición de usuarios**.
3. **Decisión de marketing:** un solo perfil de empresa ("casa de apps", no un perfil por
   app individual) para promocionar LinkVault ahora y futuras apps del dev bajo la misma
   marca — consolida audiencia/esfuerzo de contenido en vez de fragmentar por app.
4. **SIGUIENTE:** preparar cuentas de redes sociales y contenido (video corto) para el
   lanzamiento, bajo ese perfil único.

### 🔲 Pendiente (próximas sesiones)
0. ✅ **URL de privacidad en Play Console — HECHO** (confirmado por el dev en sesión 17).
0b. ✅ **Update mínimo de versionCode — HECHO** (AAB v1.2.2+4 subido a Alpha en sesión 17).
1. **AdMob — POSTPUESTO a post-lanzamiento** (sesión 19: verificación de teléfono bloqueada,
   Google no envía el SMS; producción sale SIN anuncios). Al verificarse la cuenta: crear app
   (manual, sin Play) + ad unit Banner; reemplazar App ID de test en `AndroidManifest.xml`
   (línea ~41) por el real (`ca-app-pub-xxx~yyy`); compilar con
   `--dart-define=ADMOB_BANNER_ID=` SOLO en release (en dev quedan los de test para no
   arriesgar ban por auto-clics); y en Play Console flip "¿Contiene anuncios?" → Sí.
2. **Tema claro/oscuro/sistema + "borrar datos"** (pedido por testers, APLAZADO en sesión 17
   a post-aprobación) — tema claro implica refactor grande de la paleta (todo `AppColors` es
   oscuro hardcodeado). Hacer en producción, no durante la prueba cerrada.
3. ✅ **RTDN (Pub/Sub) — HECHO en sesión 20** (topic `Play-Store-Notifications`, publisher de
   Google Play + suscripción de RevenueCat verificados por API, notificación de prueba OK).
4. ✅ **Updates del seller — PROCESADOS** (1er lote sesión 17, reporte QA final sesión 18;
   guía de envío a producción entregada en sesión 19).
5. ✅ **Promover a producción — HECHO en sesión 21, PUBLICADA en sesión 22**: Google aprobó
   el acceso, la versión v1.2.3+5 se envió a revisión (22-jul-2026) y ya está **disponible
   globalmente en Google Play**. Siguiente: redes sociales para difusión (perfil único de
   empresa, ver sesión 22).
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
| Google Play Console | **🎉 v1.2.3+5 DISPONIBLE GLOBALMENTE** (publicada, sesión 22 — enviada a revisión 22-jul-2026, sesión 21) | Bundle ID: com.rayancode98.linkvault. Subs `linkvault_pro_monthly` ($1.99, plan base `monthly`) + `linkvault_pro_yearly` ($9.99, plan base `yearly`) ACTIVAS y vinculadas a RevenueCat, compras ya reales en producción. Play App Signing activo (SHA-1 14:E6:D1:3A…). Service Account de RevenueCat con permisos mínimos (Ver info app + Ver datos financieros + Administrar pedidos). Pista **Alpha** (histórica, testers Fiverr) queda con AAB v1.2.2+4. URL de privacidad pegada (Contenido + Data Safety). **RTDN activo** (topic Play-Store-Notifications + suscripción RC, sesión 20). Sin anuncios (AdMob postpuesto). Foco ahora: marketing/adquisición de usuarios |
| RevenueCat | **Conectado end-to-end** | Org "Lunasof Apps", proyecto **"LinkVault"**; entitlement `Link Vault Pro` con productos `linkvault_pro_monthly:monthly` + `linkvault_pro_yearly:yearly` (LinkVault Android, importados vía "Import Products" desde Play); offering `default` con packages Monthly/Yearly apuntando a esos productos. `goog_BZTfYEtKHSskkbORYrniCsFOETI` en `dart_defines.json` (gitignored, sin la `test_`). **RTDN ACTIVO** (sesión 20): topic `projects/linkvault-e0799/topics/Play-Store-Notifications` + suscripción `RevenueCat-Subscriber-app36d0efaeb2`; SA con rol `pubsub.admin` a nivel proyecto; notificación de prueba OK |
| Firebase | Activo (Blaze) | Proyecto `linkvault-e0799`; Auth Google + Cloud Storage; reglas publicadas. `google-services.json` en `android/app/` con SHA-1/256 de Play App Signing + debug/upload (committeado) |
| AdMob | Bloqueado (verificación SMS falla) → POSTPUESTO | Producción sale SIN anuncios (ads apagados en release desde v1.2.3+5 salvo `--dart-define=ADMOB_BANNER_ID`); SDK sigue en el app (AD_ID intacto, declaraciones de Play sin cambios). Al verificar: App ID real en manifest + dart-define + "Contiene anuncios = Sí" |
| GitHub | Activo (**PÚBLICO**) | github.com/RayanCode28/linkvault. **GitHub Pages activo (HTTP 200)** → landing raíz `https://rayancode28.github.io/linkvault/` + `/privacy-policy.html` + `/account-deletion.html` (todo en `docs/`) |

## Notas Importantes
- Gradle directo requiere `JAVA_HOME="/Applications/Android Studio.app/Contents/jbr/Contents/Home"` (no hay JDK del sistema); `flutter build` lo resuelve solo
- Para testing: agregar `await prefs.setBool('onboarded', false)` en main.dart para resetear onboarding
- El emoji/color de thumbnail ya no existe en el modelo — el thumbnail es og:image o 🔗
