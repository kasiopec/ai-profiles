# AGENTS.md - Codex CLI / Kilo entry point

@include core/shared.md

## Agent-specific notes for Codex and Kilo

- Use `apply_patch` (Codex) or your native file-edit tool (Kilo) for edits; never rewrite an entire file when a hunk suffices.
- When asked to run tests, prefer `./gradlew :app:testDebugUnitTest` over running a single test class unless the user specifies.
- For Compose UI changes, also run `./gradlew :app:lintDebug` and report any new lint errors.
- If a build fails, do not propose edits to `gradle-wrapper.properties` until you've tried the lowest-cost fix (cache invalidation, version catalog entry, dependency alignment).