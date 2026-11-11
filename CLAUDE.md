# Repository guide for coding agents

This file provides guidance to AI coding agents (and humans) working in this repository.

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

## Noctalia config (v5)

`noctalia/.config/noctalia/` (whole-dir symlink) holds `config.toml` (custom palettes would go in `palettes/`). Noctalia v5 merges every `*.toml` there, then applies GUI overrides from `~/.local/state/noctalia/settings.toml` (untracked, app-managed, wins over `config.toml`). Noctalia never writes into `~/.config/noctalia/`, so nothing there needs ignoring.

- `settings.toml` may not exist; Noctalia creates it on the first change made in its Settings UI, wallpaper picker, or avatar picker (or via `noctalia msg` setters).
- To capture GUI changes into the repo: copy the keys you want from `settings.toml` into `config.toml` (or `local.toml` if personal), then delete `settings.toml`. Do **not** pipe `noctalia config export` into `config.toml`: it merges `local.toml` too and would leak personal values into git.
- Validate: `noctalia config validate` (merged) or `noctalia config validate <file>`.
- Personal/machine-specific values (location address, lockscreen greeting, `shell.avatar_path`) live in gitignored `local.toml` beside `config.toml`; Noctalia deep-merges all `*.toml` in the dir. Keep personal data and specific image paths out of `config.toml`. Without `local.toml`, Noctalia falls back to the AccountsService avatar.
- Wallpaper: the actual wallpaper lives only in `settings.toml` (UI picks). `config.toml` sets `wallpaper.default.path = "color:#000000"` as a portable solid-black fallback; don't put image paths there.
- Paths in config may use `~` (expanded by Noctalia). Never track `wallpaper.last` / `wallpaper.monitors.*` (runtime picks).
- Don't trim `[idle.behavior.*]` entries to only changed keys: a defined behavior replaces the built-in one wholesale (action/timeout become empty/0). Verify cleanups by diffing `noctalia config export full` before/after.
- Old v4 files (`settings.json`, `colors.json`, `plugins/`) are not used by v5; don't recreate them.

## niri config

`niri/.config/niri/config.kdl` is the main file (KDL). Shell actions are invoked via `noctalia msg ...` (e.g. `noctalia msg panel-toggle launcher`, `noctalia msg session lock`) — this is the Noctalia v5 IPC syntax; older `qs -c noctalia-shell ipc call ...` forms are outdated. Keybinds use `hotkey-overlay-title` so they show in the overlay/cheatsheet.

Validate after editing (niri also hot-reloads on save and logs parse errors):

```sh
niri validate -c niri/.config/niri/config.kdl
```

Output names (e.g. `eDP-2`) come from `niri msg outputs`.
