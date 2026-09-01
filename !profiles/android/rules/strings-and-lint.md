# Rule: Strings, lint, and commit messages

## String resources

### No hardcoded strings

- All user-facing strings MUST be defined in `app/src/main/res/values/strings.xml`.
- Never hardcode text in Kotlin files (`Text("...")` in Compose or `"..."` in View code).
- Never hardcode `android:text` in XML layouts.
- Use `stringResource(R.string.name)` in Compose.
- Use `getString(R.string.name)` in Fragments, Activities, and other View-based classes.
- Exception: internal constant keys used for logic/comparison (e.g. `"Weekly"`, `"All"`) may be hardcoded, but user-visible strings must use resources.

### Naming convention

- Use descriptive names: `screen_purpose_description` (e.g. `help_main_screen_title`, `dialog_save`).
- Group strings by feature with XML comments.
- Format strings use `%1$s`, `%2$d` etc. for parameters.

## Lint configuration

### Enforced rules

The project enforces custom lint rules via `app/lint.xml`:

- `HardcodedText` — set to `error` severity. Any hardcoded text in XML or Kotlin fails the build.

### Build configuration

In `app/build.gradle.kts`, the lint block is configured with:

- `abortOnError = true` — build fails on lint errors.
- `warningsAsErrors = true` — warnings are promoted to errors.
- `lintConfig = file("lint.xml")` — uses the custom lint configuration.

### Passing lint

Before committing, run:

```bash
./gradlew :app:lintDebug
```

The build must pass with no new issues.

## Commit messages

### No conventional commit prefixes

- Do NOT use prefixes like `feat:`, `fix:`, `chore:`, `refactor:`, `docs:`, `style:`, `test:`, `build:`, `ci:`, `perf:`, or `revert:`.
- Write commit messages as plain, descriptive sentences.
- Good: `Enable edge-to-edge display and migrate Help screen to Compose`.
- Bad: `feat: enable edge-to-edge and migrate Help to Compose`.

### Message content

- Use imperative mood: `Add feature` not `Added feature` or `Adding feature`.
- Describe what changed and why, not just what files were modified.
- Keep the first line under 72 characters.