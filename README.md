# AI Profiles

A repository of reusable AI agent configurations (rules, skills, agents) for different project types. Designed to be injected into any project via **git submodule** — nothing about AI is ever committed to the consumer's own repository.

## Why submodule + router pattern

Each coding agent loads its own conventions file:

| Agent | Reads |
|---|---|
| Codex CLI / Kilo | `AGENTS.md` |
| Claude Code | `CLAUDE.md`, `.claude/agents/*.md`, `.claude/skills/*/SKILL.md` (both paths are kept in sync via `install/sync-claude-mirror.ps1`) |
| Gemini CLI | `GEMINI.md` |
| Cursor | `.cursor/rules/*.mdc` |
| GitHub Copilot | `.github/copilot-instructions.md`, `.github/instructions/*.instructions.md` |
| Cline | `.clinerules/*.md` |
| Windsurf | `.windsurfrules` |
| Aider | `CONVENTIONS.md` |

Most of these read from the **project root**. To avoid scattering AI files into the consumer's repo we:

1. Keep all canonical content under `.ai/` (inside this repo).
2. Drop a single tiny **router file** at the consumer's project root that `@include`s the canonical content.

The consumer's repo contains exactly one AI-related line: the router. Everything else stays in this submodule.

## Repository layout

```
.
├── README.md
├── .gitignore
├── install/                  # scripts to wire the submodule into a consumer project
│   ├── install.ps1
│   ├── install.sh
│   ├── uninstall.ps1
│   └── uninstall.sh
├── !profiles/
│   └── android/              # one profile per project type
│       ├── profile.yaml      # metadata (name, version, target agents)
│       ├── AGENTS.md         # Codex / Kilo entry — @includes shared core
│       ├── CLAUDE.md         # Claude Code entry — @includes shared core
│       ├── GEMINI.md         # Gemini CLI entry — @includes shared core
│       ├── core/             # shared rules shared by every agent shim
│       ├── agents/           # canonical agent definitions (mirrored to .claude/agents/)
│       ├── rules/            # canonical rule documents
│       ├── skills/           # canonical skill definitions (mirrored to .claude/skills/)
│       └── .claude/          # native mirror for Claude Code's sub-agent + skill tools
├── SUMMARY.md            # full setup notes, per-agent mapping, workflows
├── install/
│   ├── install.ps1 / install.sh          # wire a profile into a consumer project
│   ├── uninstall.ps1 / uninstall.sh
│   └── sync-claude-mirror.ps1 / .sh      # refresh .claude/ after editing agents/ or skills/
└── docs/                                # design notes
└── docs/                     # design notes
```

## Quick start — install into an Android project

From inside your Android project's repo:

```bash
git submodule add <this-repo-url> .ai/profiles
git -C .ai/profiles submodule update --init --recursive
pwsh .ai/profiles/install/install.ps1 -Profile android
```

The installer writes a single `AGENTS.md` at your project root containing:

```markdown
# AI Assistant Router

This file delegates to the AI profiles submodule at `.ai/profiles/!profiles/android/`.
Full Android conventions: .ai/profiles/!profiles/android/AGENTS.md
```

That file is **the only** AI-related artifact in the consumer repo. Add it to git or `.gitignore` per your preference — recommended to keep it tracked so all contributors see the same routing.

## Adding a new profile

1. Create `!profiles/<name>/`.
2. Add `profile.yaml` with metadata + target agents.
3. Add `AGENTS.md`, `CLAUDE.md`, `GEMINI.md` (each `@include`s `core/shared.md`).
4. Populate `agents/`, `rules/`, `skills/`.
5. Run `pwsh install/sync-claude-mirror.ps1 -Profile <name>` to populate `.claude/`.
6. Bump version in `profile.yaml`.

See `!profiles/android/` for the canonical example. Full reference in `SUMMARY.md`.

## Reference

- `SUMMARY.md` — full setup notes, per-agent mapping, install/uninstall/sync workflows.

## Versioning

Profiles are versioned independently in `profile.yaml`. Consumers pin to a tag/commit of this repo in their submodule ref.