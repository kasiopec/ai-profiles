# install

Wire a profile from this submodule into the consumer's project root.

## Usage

```powershell
# From your Android project's repo root
pwsh .ai/profiles/install/install.ps1 -Profile android
```

## What it writes

A single `AGENTS.md` at the project root that routes to the profile. Nothing else is copied into the consumer repo.

## Uninstall

```powershell
pwsh .ai/profiles/install/uninstall.ps1 -Profile android
```

Removes the router file and (optionally) the `.ai/profiles` submodule entry from `.gitmodules`.

## Flags

- `-Profile <name>` — required. Profile folder under `!profiles/` (without `!`).
- `-SubmodulePath <path>` — default `.ai/profiles`. Path where the submodule was added.
- `-RouterName <filename>` — default `AGENTS.md`. File written at project root.