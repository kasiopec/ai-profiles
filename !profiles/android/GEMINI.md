# GEMINI.md - Gemini CLI entry point

@include core/shared.md

## Agent-specific notes for Gemini CLI

- Gemini loads this file as project context. Use it as the system-level policy.
- For multi-step tasks, break work into todos before writing code.
- Prefer reading `app/build.gradle.kts` and `gradle/libs.versions.toml` first to confirm versions before suggesting a dependency.
- Default to `./gradlew` wrappers; never assume a global Gradle install.