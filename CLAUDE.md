# LinkVault — Contexto del Proyecto

## Descripción
App Android (Flutter) para guardar y organizar links desde cualquier app via Share Sheet.
Desarrollador: Rayan / RayanCode28 · Bundle ID: `com.rayancode98.linkvault`

## Stack
- Flutter 3.44.1 (instalado via Homebrew) · Dart 3.12.1
- go_router ^14 · provider ^6 · shared_preferences ^2 · url_launcher ^6 · google_fonts ^6
- Target: Android (Google Play Store)

## Diseño — Variación Neon
- Fondo: `#030A06` · Acento: `#00FFD1` (cyan) · Superficie: `#091410`
- Fuente: Plus Jakarta Sans (google_fonts)
- Sombras tipo glow cyan en cards, FAB, chips activos, bottom sheet
- Todos los tokens en `lib/core/theme.dart`

## Estructura
```
lib/
├── main.dart                        # Entry point, SystemUI, async router init
├── app.dart                         # MaterialApp.router + ChangeNotifierProvider
├── core/
│   ├── theme.dart                   # AppColors, AppShadows, AppRadius, AppTextStyles, buildAppTheme()
│   ├── models.dart                  # LinkItem, Collection, LinkFilter enum
│   ├── mock_data.dart               # mockLinks (7 items), mockCollections (6 items)
│   └── links_provider.dart          # LinksProvider (ChangeNotifier): filtered, search, byCollection, toggleFavorite, markRead, deleteLink
├── features/
│   ├── onboarding/onboarding_screen.dart    # 3 pasos, PageView manual, SharedPreferences 'onboarded'
│   ├── home/
│   │   ├── home_screen.dart                 # AppBar, search bar tappable, FilterChipsBar, ListView, FAB
│   │   ├── link_card.dart                   # Card con thumbnail, título, dominio, colección, status dot/heart
│   │   └── filter_chips_bar.dart            # All | Unread | Read | ♥ Saved
│   ├── collections/
│   │   ├── collections_screen.dart          # Lista colecciones + fila "New collection" (→ paywall)
│   │   └── collection_detail_screen.dart    # LinkCards filtradas por collectionId
│   ├── search/search_screen.dart            # TextField autofocus, FilterChipsBar, resultados en tiempo real
│   ├── link_detail/link_detail_sheet.dart   # showModalBottomSheet: thumbnail, meta, badges, 5 acciones
│   ├── settings/settings_screen.dart        # Banner Pro, secciones APPEARANCE/DATA/ABOUT
│   └── paywall/paywall_screen.dart          # Icon+PRO badge, features, pricing cards monthly/yearly, NeonButton
└── shared/
    ├── router.dart                  # GoRouter: /onboarding, /, /collections, /search, /settings, /collections/:id, /paywall
    └── widgets/
        ├── app_bottom_nav.dart      # 4 tabs: Links/Collections/Search/Settings, glow en activo
        ├── link_thumbnail.dart      # Container 60x60 con thumbBg + thumbEmoji centrado
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
| `/collections/:id` | CollectionDetailScreen (push sobre el shell) |
| `/paywall` | PaywallScreen (push sobre el shell) |

Link detail NO es ruta — se abre con `showLinkDetailSheet(context, link)`.

## Estado del Proyecto

### ✅ Completado (Sesión 1)
- Proyecto Flutter creado y configurado
- pubspec.yaml con todas las dependencias
- Design tokens completos (theme.dart)
- Modelos y mock data (7 links, 6 colecciones)
- LinksProvider con ChangeNotifier
- Todas las pantallas implementadas con diseño Neon
- Router go_router con gate de onboarding
- APK debug compilado y verificado ✅
- Repositorio en GitHub: https://github.com/RayanCode28/linkvault

### 🔲 Pendiente (próximas sesiones)
1. **SQLite** — reemplazar mock_data con sqflite; crear `lib/database/database_helper.dart`
   - Tablas: `links` y `collections` (esquema en el doc de reconstrucción)
   - LinksProvider debe leer/escribir desde DB en vez de lista en memoria
2. **Share Sheet** — recibir links desde otras apps
   - Agregar `flutter_sharing_intent` al pubspec
   - Configurar `AndroidManifest.xml` con intent-filter para `text/plain`
   - `launchMode="singleTask"` en MainActivity
3. **Fetch Open Graph** — al guardar un link, obtener título/imagen/descripción
   - Agregar `http` y `html_unescape` al pubspec
   - Parsear meta tags og:title, og:image, og:description
4. **RevenueCat** — paywall funcional
   - Agregar `purchases_flutter` y `purchases_ui_flutter`
   - Entitlement: `Link Vault Pro` · Producto: `lifetime` · API test key: `test_DOJBOjwrlqTWnvHPBcPdJrUChQW`
   - Reactivar límite de 3 colecciones con check real de isPro()
5. **AdMob** — banner en Home solo para usuarios Free
   - Agregar `google_mobile_ads`
6. **Imágenes reales en thumbnails** — usar `cached_network_image` para og:image
7. **Add Link dialog** — el FAB del Home debe abrir un dialog para pegar URL manualmente
8. **Export/Import JSON** — funcionalidad de backup en Settings
9. **Onboarding assets** — las 3 pantallas usan arte vectorial generado en código (no imágenes externas)

## Comandos Útiles
```bash
# Correr en emulador (desde la carpeta del proyecto)
cd "/Users/bsalgado/Desktop/Brayan/Link Vault/linkvault"
flutter run

# Build APK debug
flutter build apk --debug

# Build AAB para Play Store
flutter build appbundle --release

# Limpiar cache
flutter clean && flutter pub get
```

## Servicios Externos
| Servicio | Estado | Notas |
|----------|--------|-------|
| Google Play Console | En verificación | Bundle ID: com.rayancode98.linkvault |
| RevenueCat | Configurado (test) | Ver API key arriba |
| GitHub | Activo | github.com/RayanCode28/linkvault |

## Notas Importantes
- `withOpacity` genera warnings de deprecación en Flutter 3.44 — ignorar por ahora, son solo `info`
- El bot nav actualiza el índice visual con `setState` y navega con `context.go()` — si el índice se desincroniza al usar `context.push()`, es esperado (push no vive dentro del shell)
- Para testing: agregar `await prefs.setBool('onboarded', false)` en main.dart para resetear onboarding
