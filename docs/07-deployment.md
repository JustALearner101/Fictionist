# 07 — Deployment

Build and release process for Fictionist. V1 is a fully local app — no server, no cloud, no Play Store. Ship a signed APK directly.

---

## Build Configurations

Flutter provides three build modes. Use the right one for the right job.

| Mode | Command | Use Case |
|---|---|---|
| Debug | `flutter run` | Development. Hot reload, assertions, DevTools. |
| Profile | `flutter run --profile` | Performance profiling. Release-compiled but with observatory. |
| Release | `flutter build apk --release` | Production. Tree-shaken, optimized, minified. |

### APK vs App Bundle

```bash
# Fat APK — single file, sideload-ready
flutter build apk --release

# App Bundle — Play Store upload (smaller per-device APKs)
flutter build appbundle --release
```

V1 uses APK. Switch to App Bundle when targeting Play Store in a future phase.

---

## Signing

### Generate a Keystore

```bash
keytool -genkey -v \
  -keystore fictionist-release.jks \
  -keyalg RSA -keysize 2048 \
  -validity 10000 \
  -alias fictionist
```

> [!CAUTION]
> Never commit the keystore or passwords to version control. Lose the keystore = lose the ability to update the app on Play Store.

### key.properties

Create `android/key.properties` (gitignored):

```properties
storePassword=<your-store-password>
keyPassword=<your-key-password>
keyAlias=fictionist
storeFile=../keystores/fictionist-release.jks
```

### build.gradle Configuration

In `android/app/build.gradle`:

```groovy
def keystoreProperties = new Properties()
def keystorePropertiesFile = rootProject.file('key.properties')
if (keystorePropertiesFile.exists()) {
    keystoreProperties.load(new FileInputStream(keystorePropertiesFile))
}

android {
    // ...

    signingConfigs {
        release {
            keyAlias keystoreProperties['keyAlias']
            keyPassword keystoreProperties['keyPassword']
            storeFile keystoreProperties['storeFile'] ? file(keystoreProperties['storeFile']) : null
            storePassword keystoreProperties['storePassword']
        }
    }

    buildTypes {
        release {
            signingConfig signingConfigs.release
            minifyEnabled true
            shrinkResources true
            proguardFiles getDefaultProguardFile('proguard-android-optimize.txt'), 'proguard-rules.pro'
        }
    }
}
```

---

## Build Variants

Two logical variants controlled via `--dart-define`. No flavors needed for V1.

| Variant | Mode | Logging | DB Name | Banner |
|---|---|---|---|---|
| `dev` | Debug | Verbose, Riverpod provider observers | `fictionist_dev.db` | Debug banner on |
| `prod` | Release | Errors only | `fictionist.db` | No banner |

### Usage

```bash
# Dev build
flutter run --dart-define=ENV=dev

# Prod build
flutter build apk --release --dart-define=ENV=prod
```

### Reading the Flag

```dart
class AppConfig {
  static const String environment = String.fromEnvironment(
    'ENV',
    defaultValue: 'dev',
  );

  static bool get isDev => environment == 'dev';
  static bool get isProd => environment == 'prod';

  /// Separate DB per variant — no dev data leaking into prod.
  static String get databaseName =>
      isDev ? 'fictionist_dev.db' : 'fictionist.db';
}
```

> [!TIP]
> Using `--dart-define` instead of flavors keeps the build config simple and avoids duplicating `AndroidManifest.xml` files. Sufficient for a solo-dev project.

---

## Code Generation

Fictionist uses `build_runner` for:

- **Drift** — database table definitions, DAOs, migration code
- **Freezed** — immutable domain entities, union types, `copyWith`

### Commands

```bash
# One-shot generation (CI, pre-build)
dart run build_runner build --delete-conflicting-outputs

# Watch mode (during development)
dart run build_runner watch --delete-conflicting-outputs
```

### Rules

1. **Run before every build.** Generated files must be up-to-date or the build fails.
2. **Gitignore generated files.** Add these patterns to `.gitignore`:

```gitignore
# build_runner output
*.g.dart
*.freezed.dart
*.drift.dart
```

3. **CI must regenerate.** Any CI pipeline runs `build_runner build` as a step before `flutter build`.

> [!IMPORTANT]
> If you see "part of" errors or missing method errors after pulling, run `build_runner build` first. This is the single most common "it doesn't compile" cause.

---

## Release Checklist

Run through this every time before cutting a release.

```
[ ] All tests pass: flutter test
[ ] No analysis warnings: flutter analyze (zero issues)
[ ] Version bumped in pubspec.yaml (semver: major.minor.patch+buildNumber)
[ ] CHANGELOG.md updated with user-facing changes
[ ] build_runner ran: dart run build_runner build --delete-conflicting-outputs
[ ] Release APK built: flutter build apk --release --dart-define=ENV=prod
[ ] APK installed and tested on physical device
[ ] Smoke test: create entity, add fields, link relationships, search, export JSON
[ ] Git tag created: git tag -a v1.0.0 -m "Release 1.0.0"
[ ] Tag pushed: git push origin v1.0.0
```

### Versioning Convention

```yaml
# pubspec.yaml
version: 1.0.0+1
#        ^     ^
#        |     Build number (increment every build, Play Store requires unique)
#        Semver (user-facing version)
```

- **Patch** (1.0.x): Bug fixes, minor UI tweaks
- **Minor** (1.x.0): New features, non-breaking
- **Major** (x.0.0): Breaking changes, major rewrites (Phase 3+)

---

## Distribution

### V1 — Direct APK Sideload

No Play Store. Distribute the signed APK directly:

1. Build the release APK
2. Share via file transfer, GitHub Releases, or direct download link
3. Users install with "Allow unknown sources" enabled

This is the fastest path to getting the app into real hands for feedback.

### Future — Google Play Store

When ready (likely Phase 3+), the Play Store submission requires:

| Requirement | Status |
|---|---|
| App Bundle signed with upload key | Signing setup done (see above) |
| Privacy policy URL | Needed — no user data collected, but policy still required |
| Store listing (screenshots, description) | Not started |
| Content rating questionnaire | Not started |
| Target API level compliance | API 26+ (already compliant) |
| Data safety form | Needed — declare "no data collected/shared" |

> [!NOTE]
> Google Play requires targeting a recent API level (within 1 year of latest). Keep `targetSdkVersion` current even during V1.

---

## Minimum Requirements

| Requirement | Value | Notes |
|---|---|---|
| Android minSdk | API 26 (Android 8.0) | Required for `java.time`, modern SQLite |
| Android targetSdk | Latest stable | Keep current for Play Store compliance |
| Flutter SDK | 3.x | Minimum 3.22+ recommended |
| Dart SDK | 3.x | Comes with Flutter |
| Java/JDK | 17 | Required by AGP 8.x |
| Gradle | 8.x | Bundled with Flutter project |

### Why API 26+

- `java.time` APIs available without desugaring
- SQLite version supports FTS5 natively
- Notification channels required (future use)
- Drops ~3% of Android devices (acceptable trade-off)

---

## Project Structure — Build Files

```
android/
├── app/
│   ├── build.gradle          # App-level build config, signing, minSdk
│   ├── proguard-rules.pro    # ProGuard/R8 keep rules
│   └── src/
│       └── main/
│           └── AndroidManifest.xml
├── build.gradle              # Project-level build config
├── gradle.properties         # JVM args, AndroidX flags
├── key.properties            # Signing credentials (GITIGNORED)
└── keystores/
    └── fictionist-release.jks  # Release keystore (GITIGNORED)
```

### .gitignore Additions

```gitignore
# Signing
android/key.properties
android/keystores/

# Generated code
*.g.dart
*.freezed.dart
*.drift.dart

# Build outputs
build/
.dart_tool/
```
