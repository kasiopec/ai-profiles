# .claude mirror

Claude Code reads `.claude/agents/*.md` and `.claude/skills/*/SKILL.md` natively. To let the `Skill` and sub-agent tools pick these up without the orchestrator hand-loading them, every canonical agent/skill in `agents/` and `skills/` is mirrored here.

## Layout

```
.claude/
├── agents/
│   ├── code-reviewer.md   ← mirrors ../../agents/code-reviewer.md
│   └── test-writer.md     ← mirrors ../../agents/test-writer.md
└── skills/
    ├── gradle-build-fix/SKILL.md  ← mirrors ../../skills/gradle-build-fix/SKILL.md
    └── compose-preview/SKILL.md   ← mirrors ../../skills/compose-preview/SKILL.md
```

## Sync rule

The mirror is **manual** today. Each mirrored file ends with:

> Source: Mirrored from `!profiles/android/<path>`. Keep both files in sync.

When you edit a canonical file in `agents/` or `skills/`, copy the change into the matching file under `.claude/`. A future `scripts/sync-claude-mirror.ps1` can automate this; until then, run:

```powershell
pwsh install/sync-claude-mirror.ps1 -Profile android
```

(The sync script will be added when you ask; for now the mirror is the source of truth for Claude Code.)