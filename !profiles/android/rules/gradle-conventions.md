# Rule: Gradle conventions

Applies to all `*.gradle.kts` files, `libs.versions.toml`, and `gradle.properties`.

## Version catalog

- All versions live in `gradle/libs.versions.toml`. Never inline versions in module build files.
- Library aliases: `<group>-<artifact>` style, e.g. `androidx-core-ktx`, `kotlinx-coroutines-android`.
- Bundle aliases (BOMs) for groups that ship together: `androidx-compose-bom`, `androidx-room-bom`.

## Modules

- One `build.gradle.kts` per module, no shared root build script logic for module-specific config.
- `app` module applies `com.android.application`. Library modules apply `com.android.library`.
- Compose-enabled modules apply `org.jetbrains.kotlin.plugin.compose` (Kotlin 2.0+) or `composeOptions { kotlinCompilerExtensionVersion = ... }` on older setups.

## Plugins

- Apply plugins with the version catalog, e.g. `alias(libs.plugins.android.application)`.
- Never `apply plugin: 'kotlin-android'` style (legacy Groovy DSL).

## Build types

- `debug`: `isMinifyEnabled = false`, `applicationIdSuffix = ".debug"`.
- `release`: R8 enabled, `proguard-rules.pro` referenced, signing config from environment.

## Dependencies

- Use `implementation`, `api`, `testImplementation`, `androidTestImplementation` deliberately.
- Never `compileOnly` for AndroidX.
- Prefer BOM-managed groups; let the BOM resolve versions.

## What NOT to do

- No `kapt { correctErrorTypes = true }` workarounds for KSP-migratable processors.
- No `buildscript { dependencies { classpath(...) } }` in module files — plugins only.
- No commented-out dependency blocks; delete them.