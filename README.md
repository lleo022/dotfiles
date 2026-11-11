# dotfiles

My Linux desktop setup: **CachyOS** + **niri** tiling compositor + **Noctalia** shell

## Setting up a new machine

**1. Install CachyOS**, then clone this repo into your home folder:

```sh
git clone <this repo> ~/dotfiles
cd ~/dotfiles
```

**2. Install packages**

```sh
paru -S --needed - < pkglist-1-core.txt    # needed for this setup to work
paru -S --needed - < pkglist-2-apps.txt    # everyday apps
paru -S --needed - < pkglist-3-extra.txt   # occasional apps + KDE Plasma as a fallback
```

**3. Build Noctalia**:

```sh
cd ~/noctalia-shell
just build release
sudo just install release
```

**4. Link configs:**

```sh
cd ~/dotfiles
mkdir -p ~/.config/systemd/user/niri.service.d   # must be a real folder, not a link
stow niri noctalia kitty fish fastfetch xremap
systemctl --user enable --now xremap.service
```

If stow complains about a file that already exists, move or delete that file first, then run it again.

**5. Add personal settings.** Create `~/dotfiles/noctalia/.config/noctalia/local.toml` (untracked):

```toml
[location]
address = "Your City"

[lockscreen_widgets.widget.lockscreen-widget-0000000000000002.settings]
title = "Welcome back, <name>"
```

**6. Log out, then pick niri** on the login screen. Choose a wallpaper with `Super + Shift + W`, and Noctalia themes everything to match.
