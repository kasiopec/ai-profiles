# Rule: Kotlin style

Applies to all Kotlin files in `app/src/`.

## Imports

- One blank line between import groups. Order: AndroidX, third-party, project-internal, `kotlin.*`/`java.*`.
- No wildcard imports.
- Sort alphabetically within each group.

## Formatting

- 4-space indentation. No tabs.
- Max line length 120 (soft limit; harder limit at 140).
- Trailing comma on multi-line argument and parameter lists.

## Naming

- Classes/objects: `PascalCase`.
- Functions and properties: `camelCase`.
- Constants: `UPPER_SNAKE_CASE` only for `const val` at top-level / in `object`.
- Composables: `PascalCase` (function) but can also be named after what they render, e.g. `UserAvatar`.
- Sealed class subtypes: `PascalCase`, no `I` prefix.

## Control flow

- Prefer `when` over `if/else` chains on a single subject.
- Prefer expression bodies for one-liners.
- Use `require` / `check` for preconditions; throw `IllegalArgumentException` only from framework boundary code.

## Nullability

- Prefer non-null types. Use `?:` with explicit fallback, not `!!`.
- Avoid `lateinit` outside of DI/factory code. Prefer `lazy` or constructor injection.

## Coroutines

- Suspend functions named with verb, e.g. `fetchUser(id)`, not `getUserAsync`.
- Never `runBlocking` in production code paths.

## Documentation

- Public API outside `internal` must have KDoc.
- KDoc first line: short summary ending with a period.