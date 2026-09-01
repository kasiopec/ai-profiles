# Setup summary

This repo hosts reusable AI agent configurations (rules, skills, agents) for Android projects and other targets. Everything is injected into consumer projects via **git submodule + a single router file** — the consumer's own repo never accumulates AI configuration files.

## What the repo contains

```
ai/
├── README.md                      ← public overview
├── .gitignore
├── install/                       ← scripts used from consumer projects
│   ├── README.md
│   ├── install.ps1 / install.sh   ← writes a router file at consumer root
│   ├── uninstall.ps1 / uninstall.sh
│   └── sync-claude-mirror.ps1 / .sh  ← keeps .claude/ mirror in sync
└── !profiles/
    └── android/                   ← one profile per project type
        ├── profile.yaml
        ├── AGENTS.md              ← Codex / Kilo entry (router-aware)
        ├── CLAUDE.md              ← Claude Code entry
        ├── GEMINI.md              ← Gemini CLI entry
        ├── core/shared.md         ← canonical rules, @included by all 3 above
        ├── agents/                ← canonical agent definitions
        │   ├── code-reviewer.md
        │   └── test-writer.md
        ├── rules/                 ← canonical rule documents
        │   ├── kotlin-style.md
        │   └── gradle-conventions.md
        ├── skills/                ← canonical skill definitions
        │   ├── gradle-build-fix/SKILL.md
        │   └── compose-preview/SKILL.md
        └── .claude/               ← mirror so Claude Code discovers them natively
            ├── README.md
            ├── agents/            ← mirrors ../agents/
            └── skills/            ← mirrors ../skills/
```

## Design

| Concern | Decision |
|---|---|
| How is the profile delivered? | Git submodule at `.ai/profiles` in the consumer project. |
| What lands in the consumer's repo? | Exactly one router file (e.g. `AGENTS.md`) at the project root, plus the `.gitmodules` entry. |
| How do different agents find content? | Each agent reads its native file from the consumer root; that file `@include`s the canonical content from the submodule. Claude Code additionally scans `.claude/agents/` and `.claude/skills/` natively, so those are mirrored. |
| Where is the canonical content? | One place: `!profiles/<name>/core/shared.md` and `agents/`, `rules/`, `skills/`. All agent entry files `@include` from there. |
| How are versions tracked? | `profile.yaml` per profile; submodule pinned to a tag/commit by the consumer. |

## Per-agent mapping

| Agent | File the agent reads at consumer root | Native subpaths also honored |
|---|---|---|
| Codex CLI | `AGENTS.md` (router → profile `AGENTS.md` → `core/shared.md`) | — |
| Kilo | same as Codex | also `.kilo/` if present |
| Gemini CLI | `GEMINI.md` (router → profile `GEMINI.md` → `core/shared.md`) | — |
| Claude Code | `CLAUDE.md` (router → profile `CLAUDE.md` → `core/shared.md`) | `.claude/agents/*.md`, `.claude/skills/*/SKILL.md` (mirrored in this repo) |
| Cursor | (not currently generated) | `.cursor/rules/*.mdc` |
| GitHub Copilot | (not currently generated) | `.github/copilot-instructions.md`, `.github/instructions/*.instructions.md` |
| Cline | (not currently generated) | `.clinerules/*.md` |
| Windsurf | (not currently generated) | `.windsurfrules` |
| Aider | (not currently generated) | `CONVENTIONS.md` |

The "currently generated" set covers Codex, Claude, Kilo, Gemini per the original requirement. Cursor / Copilot / Cline / Windsurf / Aider only need a new file under `!profiles/<name>/` if you decide to support them — no installer changes required.

## Adding the android profile to a consumer project

From inside the Android project repo:

```bash
git submodule add <this-repo-url> .ai/profiles
git -C .ai/profiles submodule update --init --recursive
pwsh .ai/profiles/install/install.ps1 -Profile android
```

What happens:

1. A single `AGENTS.md` is written at the consumer's project root.
2. Its content is:

   ```markdown
   # AI Assistant Router

   This project uses the AI profiles submodule. All conventions, agents, and skills
   live in `.ai/profiles/!profiles/android/AGENTS.md`. Do not duplicate them here.
   ```

3. Codex / Kilo / Gemini open `AGENTS.md` and follow the pointer.
4. Claude Code opens `CLAUDE.md` from the submodule directly (no consumer copy needed) and additionally discovers `.claude/agents/` and `.claude/skills/` inside the submodule.
5. The consumer's own git history contains one router line and one submodule reference — no AI configuration is duplicated.

The installer refuses to overwrite an existing `AGENTS.md` unless it was previously written by this tool.

## Removing the profile

```powershell
pwsh .ai/profiles/install/uninstall.ps1 -Profile android -RemoveSubmodule
```

Removes the router file and detaches `.ai/profiles` from `.gitmodules`.

## Keeping the Claude mirror fresh

After editing anything under `agents/` or `skills/`:

```powershell
pwsh install/sync-claude-mirror.ps1 -Profile android
```

This copies canonical `*.md` files into `.claude/agents/` and `skills/*/SKILL.md` into `.claude/skills/`. Without this, Claude Code's `Skill` tool won't see new skills.

## Adding a new profile (e.g. backend, ios)

1. `mkdir !profiles/backend`
2. Copy `!profiles/android/` and rename `AGENTS.md` / `CLAUDE.md` / `GEMINI.md` to suit.
3. Edit `profile.yaml`: change `name`, `description`, `version`, `target_agents`.
4. Replace `core/shared.md` with backend conventions.
5. Replace `agents/`, `rules/`, `skills/`.
6. `pwsh install/sync-claude-mirror.ps1 -Profile backend`
7. Bump `version` in `profile.yaml`.
8. Tag the repo (e.g. `v0.2.0`) so consumers can pin.

Consumers install with: `pwsh .ai/profiles/install/install.ps1 -Profile backend`.

## Files the consumer project will contain

After install, the consumer's git diff is:

```
AGENTS.md            (new — router, ~5 lines)
.gitmodules          (new — points at this repo at .ai/profiles)
.ai/profiles         (new submodule directory)
```

That is the entire surface area. No `.claude/`, no `.cursor/`, no `.github/instructions/` files at the consumer root.

## Quick reference

| Want to… | Run |
|---|---|
| Install into a project | `pwsh .ai/profiles/install/install.ps1 -Profile <name>` |
| Uninstall | `pwsh .ai/profiles/install/uninstall.ps1 -Profile <name> [-RemoveSubmodule]` |
| Refresh Claude mirror after edits | `pwsh install/sync-claude-mirror.ps1 -Profile <name>` |
| Add a new agent (canonical) | edit `!profiles/<name>/agents/<file>.md`, then run sync |
| Add a new skill (canonical) | create `!profiles/<name>/skills/<name>/SKILL.md`, then run sync |
| Add a new rule | write `!profiles/<name>/rules/<file>.md`, reference it from `core/shared.md` |