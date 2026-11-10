# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## What this is

Personal Linux dotfiles (CachyOS, niri Wayland compositor, Noctalia shell). No build, lint, or test suite.

## Layout: GNU Stow packages

Each top-level directory is a stow package whose contents mirror `$HOME`:
`<pkg>/.config/<app>/...` → `~/.config/<app>/...`. Deploy with `stow <pkg>` from the repo root.

- `niri`, `kitty`, `fastfetch` are stowed as whole-directory symlinks (`~/.config/niri -> ../dotfiles/niri/.config/niri`), so edits here take effect live and new files in those dirs appear in `~/.config` immediately.
- `fish` is stowed per-file (`~/.config/fish/` is a real dir holding untracked `fish_variables`, `completions/`, etc.). `config.fish` sources the CachyOS default config, which already adds `~/.local/bin` etc. to `PATH`. Session-wide env vars (e.g. `QT_QPA_PLATFORMTHEME`) belong in niri's `environment {}` block, not fish. After adding a file to a package, re-run `stow -R <pkg>` to link it.

## Noctalia-generated files (do not commit)

Noctalia writes theme files that are gitignored and must stay untracked:
- `niri/.config/niri/noctalia.kdl` — colors for focus-ring/border/tab-indicator; pulled into the main config via `include "noctalia.kdl"` at the end of `config.kdl`. Put color overrides elsewhere; this file gets regenerated.
- `kitty/.config/kitty/themes/noctalia.conf` (included by `kitty.conf`) and `current-theme.conf`.

## niri config

`niri/.config/niri/config.kdl` is the main file (KDL). Shell actions are invoked via `noctalia msg ...` (e.g. `noctalia msg panel-toggle launcher`, `noctalia msg session lock`) — this is the Noctalia v5 IPC syntax; older `qs -c noctalia-shell ipc call ...` forms are outdated. Keybinds use `hotkey-overlay-title` so they show in the overlay/cheatsheet.

Validate after editing (niri also hot-reloads on save and logs parse errors):

```sh
niri validate -c niri/.config/niri/config.kdl
```

Output names (e.g. `eDP-2`) come from `niri msg outputs`.
