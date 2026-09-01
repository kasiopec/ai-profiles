# Skill: compose-preview

Use when adding or modifying a `@Composable` that has visual state worth previewing.

## Preconditions

- The module applies the Compose plugin/compiler.
- `androidx.compose.ui:ui-tooling-preview` is on the `implementation` (or `debugImplementation`) classpath.
- `androidx.compose.ui:ui-tooling` on `debugImplementation` for `@Preview` to render in Android Studio.

## Workflow

1. Add one `@Preview` for the happy path using `showBackground = true`.
2. If the composable accepts state that changes meaningfully, add a second `@Preview` for the alternate state. Name functions: `<ComposableName>Preview`, `<ComposableName>DarkPreview`.
3. Group previews in a `Previews.kt` file colocated with the composable, or directly under the composable if the file is small.
4. Use `ui.tooling.preview.Preview` (not the older `androidx.compose.ui.tooling.preview.Preview` — both work, prefer the modern one).

## What to preview

- Stateless leaf components: always.
- Stateful screens: only if you also provide a preview-only fake ViewModel/state.
- Dialogs, sheets: yes — they are often overlooked.

## What NOT to do

- No network calls in previews.
- No `LocalContext.current` without a fake — use `LocalInspectionMode` to guard.
- No `runBlocking` in preview functions.

## Stop conditions

- At least one `@Preview` per public composable.
- Build still compiles: `./gradlew :app:assembleDebug`.