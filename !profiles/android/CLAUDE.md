# CLAUDE.md - Claude Code entry point

@include core/shared.md

## Agent-specific notes for Claude Code

- Sub-agents live in `.claude/agents/*.md` (mirrored from `agents/`). Prefer invoking `code-reviewer` after any non-trivial code change.
- Skills live in `.claude/skills/*/SKILL.md` (mirrored from `skills/`). Use the `Skill` tool to load a skill before attempting its workflow.
- Use plan mode for changes touching Gradle build files, DI modules, or module boundaries.
- When refactoring, prefer extracting a small helper over inlining conditional branches.
- Respect the project's existing module structure — don't create a new module without asking.