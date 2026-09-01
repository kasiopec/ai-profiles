# Rule: Architecture and code organization

## File organization

### One file, one responsibility

- Interfaces, enums, and sealed classes each live in their own file.
- Exception: very small, private, or highly specific internal helper classes.
- UI state pattern: in the `ui` layer, `*UiState` and `*UiEvent` for the same feature can share a single `*UiState.kt` file, but any associated enums or secondary interfaces must live in their own files.

### Feature-based packaging

- Organize code by feature (e.g. `ui.home`, `ui.goals`) rather than layer-only.
- Each feature package contains its ViewModel, screens (Composables), and state definitions together.

## UI layer (Jetpack Compose)

### Dumb UI

Composables only:

- Observe state.
- Emit events.
- Handle visual styling.

No business logic, no database calls, no direct navigation inside Composables.

### Unidirectional data flow

- `StateFlow` for state.
- `Channel` / `Flow` for side effects.
- State flows down to Composables; events flow up to the ViewModel.

## Data layer

### Repository pattern

- All data operations go through a Repository.
- ViewModels never interact with `DatabaseHelper` or `EventOperations` directly.

## Dependency injection

- Hilt for all DI.
- Never instantiate ViewModels manually.
- Use `@Inject constructor` for class dependencies.

## Coding style

### Kotlin first

- Prefer `val` over `var`.
- Use `data object` for singleton sealed interface members (Kotlin 1.9+).
- Use `data class` for state containers.