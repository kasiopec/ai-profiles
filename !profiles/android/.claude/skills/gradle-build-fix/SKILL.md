# Skill: gradle-build-fix (Claude mirror)

Use when `./gradlew <task>` fails and the error message mentions dependency resolution, version conflicts, missing plugins, or compilation errors after a sync.

## Preconditions

- Confirm the wrapper exists: `ls gradlew`.
- Confirm Java toolchain matches: `java -version` should be 17+ unless `build.gradle.kts` specifies otherwise.

## Workflow

1. Capture the failing command and full output.
2. Classify the error:
   - `Could not resolve <dep>` → version catalog issue.
   - `Plugin <id> not found` → plugin not declared in version catalog or `pluginManagement` block.
   - `e: file.kt:line:col` → Kotlin compilation error, not a Gradle problem.
   - `Unsupported class file major version` → wrong Java toolchain.
3. For version catalog issues:
   - Open `gradle/libs.versions.toml`.
   - Add or correct the version under `[versions]`.
   - Add or correct the library alias under `[libraries]`.
   - Re-run `./gradlew --refresh-dependencies <task>`.
4. For plugin issues:
   - Confirm the plugin id and version exist in the catalog or `pluginManagement`.
   - Apply via `alias(libs.plugins.<alias>)`.
5. For Kotlin compilation errors: stop — surface the error to the user; do not modify source files inside this skill.

## Stop conditions

- Build succeeds on the same task that previously failed.
- After 3 distinct fix attempts, stop and report what was tried.

## Do not

- Edit `gradle-wrapper.properties` to bump Gradle version without user approval.
- Disable lint or R8 to "make it compile".

## Source

Mirrored from `!profiles/android/skills/gradle-build-fix/SKILL.md`. Keep both files in sync.