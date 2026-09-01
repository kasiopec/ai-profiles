# Shared Android conventions

This document is the single source of truth. All agent-specific entry files
(`AGENTS.md`, `CLAUDE.md`, `GEMINI.md`) include this file via `@include`.

## Tech stack assumptions

- Kotlin (latest stable).
- Jetpack Compose for UI.
- Gradle Kotlin DSL (`.gradle.kts`).
- AndroidX libraries.
- minSdk 24, targetSdk = latest stable.
- Java 17 toolchain.

## Skill priorities

When work touches these areas, load the matching skill before writing code:

- **Modern Android development.** Jetpack Compose for reactive UIs, Material 3, state handling. Hilt for DI. Kotlin coroutines + Flow (`StateFlow`, `SharedFlow`, `Channel`).
- **Architecture and patterns.** MVVM/MVI with strict unidirectional data flow. Clean separation between UI, domain (Repositories), and data (SQLite/Room). Feature-based packaging.
- **Refactoring and migration.** Safely convert XML / ViewBinding and Multi-Activity setups to single-Activity Compose. Enforce the dumb-UI pattern in Composables.
- **Standards enforcement.** Auto-check new code against the rules in `rules/architecture.md` and `rules/strings-and-lint.md`.

## Architecture rules

See `rules/architecture.md`. Key points:

- One type per file (interfaces, enums, sealed classes). UI state files are the exception.
- Feature-based packaging (`ui.home`, `ui.goals`).
- Composables are dumb: observe state, emit events, handle styling. No business logic, no DB calls, no direct navigation.
- Unidirectional data flow: `StateFlow` down, events up via `Channel`/`Flow`.
- All data access through Repositories. ViewModels never touch `DatabaseHelper` or `EventOperations`.
- Hilt for DI. `@Inject constructor`. No manual ViewModel instantiation.
- Kotlin-first: `val` over `var`, `data object` for sealed-interface singletons, `data class` for state.

## Strings, lint, and commits

See `rules/strings-and-lint.md`. Key points:

- All user-facing strings live in `res/values/strings.xml`. Use `stringResource(R.string.name)` in Compose.
- `HardcodedText` lint rule is set to `error`. Lint must pass before commit.
- No conventional-commit prefixes. Imperative mood, first line under 72 chars.

## Gradle

See `rules/gradle-conventions.md`.

## Kotlin style

See `rules/kotlin-style.md`.

## What NOT to do

- Do not introduce RxJava.
- Do not add new dependencies without justification in a comment or commit message.
- Do not modify `gradle-wrapper.jar` or `gradle.properties` without discussing.
- Do not use `kapt` for new modules — use KSP.
- Do not commit secrets. Never hardcode API keys. Use `local.properties` + `BuildConfig` fields.

## File layout convention

```
app/src/main/java/<package>/
  data/        # repositories, network, db
  domain/      # use cases, models
  ui/          # composables, viewmodels (feature-based: ui.home, ui.goals)
  di/          # hilt modules
app/src/test/          # unit
app/src/androidTest/  # instrumented
```

## Tests

- JUnit5 + Turbine for Flow + Compose UI testing. Robolectric only when unavoidable.
- Fakes over mocks; `UnconfinedTestDispatcher`; no `Thread.sleep`.

## Available skills in this profile

- `skills/gradle-build-fix/SKILL.md` — fix common Gradle build failures.
- `skills/compose-preview/SKILL.md` — add `@Preview` to Composables.
- `skills/agp-9-upgrade/SKILL.md` — migrate a project to AGP 9.
- `skills/android-cli/SKILL.md` — use Google's `android` CLI tool.
- `skills/edge-to-edge/SKILL.md` — implement edge-to-edge support.
- `skills/migrate-xml-views-to-jetpack-compose/SKILL.md` — migrate XML layouts to Compose.
- `skills/unslop/SKILL.md` — cut AI tells from generated writing. Apply to any prose the agent produces.

## Available agents in this profile

- `agents/bug-reviewer.md` — diff-only logic-bug reviewer (BLOCKER/MAJOR only).
- `agents/convention-reviewer.md` — enforces rules from this profile with verbatim citations.
- `agents/security-reviewer.md` — security + behavior-deviation + missing-coverage reviewer.
- `agents/skip-checker.md` — classifies whether a diff can skip review.
- `agents/issue-validator.md` — independent YES/NO validation of one finding.
- `agents/verify-audit.md` — linter pass over a `/verify` report.