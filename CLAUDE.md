# LinkVault — Contexto del Proyecto

## Descripción
App Android (Flutter) para guardar y organizar links desde cualquier app via Share Sheet.
Desarrollador: Rayan / RayanCode28 · Bundle ID: `com.rayancode98.linkvault`

## Stack
- Flutter 3.44.1 (instalado via Homebrew) · Dart 3.12.1
- go_router ^14 · provider ^6 · shared_preferences ^2 · url_launcher ^6 · google_fonts ^6
- sqflite ^2 · http ^1 · html_unescape ^2 · flutter_sharing_intent ^2
- share_plus ^12 · file_picker ^10 · cached_network_image ^3 · package_info_plus ^9
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
│   ├── metadata_service.dart        # Fetch Open Graph (og:title/description/image) con límites de tamaño/timeout
│   └── share_intent_service.dart    # Recibe texto del Share Sheet y extrae la URL
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
│   ├── settings/settings_screen.dart        # Pro banner, Export/Import JSON, Rate (Play Store), Feedback (mailto), versión real
│   └── paywall/paywall_screen.dart          # Icon+PRO badge, features, pricing cards monthly/yearly, NeonButton
└── shared/
    ├── router.dart                  # GoRouter; MainShell deriva el tab activo de la ruta
    └── widgets/
        ├── app_bottom_nav.dart      # 4 tabs: Links/Collections/Search/Settings, glow en activo
        ├── link_thumbnail.dart      # CachedNetworkImage de og:image con fallback 🔗
        ├── collection_picker.dart   # Chips horizontales para elegir colección (None + todas)
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

### 🔲 Pendiente (próximas sesiones)
1. **RevenueCat** — paywall funcional
   - Agregar `purchases_flutter` y `purchases_ui_flutter`
   - Entitlement: `Link Vault Pro` · Producto: `lifetime` · API key de test en RevenueCat dashboard (no committearla al repo)
   - Conectar `LinksProvider.isPro` al entitlement real
2. **AdMob** — banner en Home solo para usuarios Free (`google_mobile_ads`)
3. **Firma release** — crear keystore propio y `key.properties` (NO committear); `build.gradle.kts` aún firma release con debug keys
4. **Onboarding assets** — las 3 pantallas usan arte vectorial generado en código (no imágenes externas)
5. (Opcional) Tema claro / idioma — las filas de Settings son informativas por ahora

## Comandos Útiles
```bash
# Correr en emulador (desde la carpeta del proyecto)
cd "/Users/bsalgado/Desktop/Brayan/Link Vault/linkvault"
flutter run

# Tests y análisis
flutter test
flutter analyze

# Build APK debug
flutter build apk --debug

# Build AAB para Play Store (requiere firma release real)
flutter build appbundle --release

# Limpiar cache
flutter clean && flutter pub get
```

## Servicios Externos
| Servicio | Estado | Notas |
|----------|--------|-------|
| Google Play Console | En verificación | Bundle ID: com.rayancode98.linkvault |
| RevenueCat | Configurado (test) | API key en el dashboard de RevenueCat — no committearla |
| GitHub | Activo | github.com/RayanCode28/linkvault |

## Notas Importantes
- Gradle directo requiere `JAVA_HOME="/Applications/Android Studio.app/Contents/jbr/Contents/Home"` (no hay JDK del sistema); `flutter build` lo resuelve solo
- Para testing: agregar `await prefs.setBool('onboarded', false)` en main.dart para resetear onboarding
- El emoji/color de thumbnail ya no existe en el modelo — el thumbnail es og:image o 🔗
