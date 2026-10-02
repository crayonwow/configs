# Moving to a new laptop

Target: x86_64 Fedora, installed from the Sway Spin, then migrated to
mango + noctalia. The Sway session stays installed as a fallback.

## 1. On the new machine

```sh
sudo dnf install -y git
git clone <this repo> ~/configs
cd ~/configs && ./bootstrap.sh
```

`bootstrap.sh` autodetects the host profile (`x86` on anything that isn't
an Apple board) and runs five stages: `repos packages links services user`.
Any stage can be re-run on its own.

Before the first mango login, fill in `host/x86/mango.conf` — it ships
empty on purpose, because the display scale and input device names are
only knowable on the actual hardware:

```sh
mmsg get all-monitors    # real output name and resolution
mmsg get all-devices     # touchpad and keyboard identifiers
```

Note: `mmsg` needs `MANGO_INSTANCE_SIGNATURE` set to the full socket path
(`/run/user/$UID/mango-<pid>.sock`). Mango exports it inside its own
session; from an outside shell you have to set it yourself.

## 2. State that bootstrap.sh deliberately does not touch

None of this is in git, and all of it disappears silently if forgotten.

- `~/.ssh/` — `id_ed25519` and `known_hosts`. Copy over an encrypted
  channel, then `chmod 600`.
- `configs/completions/env` — gitignored, and currently holds a live
  Sentry token in plaintext. Worth rotating during the move rather than
  copying as is.
- `configs/work/` — gitignored work shell config, sourced by `.zshrc`.
- `~/.kube/config` and `~/.config/k9s/`
- `~/.docker/config.json` — registry credentials
- `~/.zsh_history`
- `~/.local/share/atuin` or asdf tool versions, if still in use
- Browser profiles, if not synced through an account
- Pritunl VPN profiles

## 3. Things that intentionally do not come along

- `host/asahi-mbp/` — Apple-specific: the 1.5x built-in display scale and
  the matching XWayland DPI.
- `macos/` — aerospace and Homebrew lists, kept only for a Mac.
- `sway.d/status.sh` — reads `/sys/class/power_supply/macsmc-battery`,
  which does not exist on x86. Under noctalia the battery widget reads
  UPower instead, so nothing replaces this file.

## 4. Noctalia configuration

Noctalia has two layers and they behave differently:

- `~/.config/noctalia/*.toml` — read-only to noctalia, merged alphabetically.
  This is what the repo tracks, as `noctalia/config.toml`.
- `~/.local/state/noctalia/settings.toml` — written by the GUI, by atomic
  replace. A symlink here does not survive the first settings change, so
  this layer is deliberately untracked.

settings.toml loads last and wins. On a machine that has been configured
through the GUI it shadows the tracked file; on a fresh install state is
empty, so the tracked config applies in full.

Workflow: configure in the GUI, then run `./noctalia/sync.sh` to capture
the result into the repo. The script validates the export and points out
values tied to the current machine.

Those host-specific values need review on the new laptop:

- `[wallpaper.*] path` — absolute paths into ~/Pictures
- `[wallpaper.monitors.<output>]` and `lockscreen-login-box@<output>` —
  keyed by output name, currently eDP-1
- `cx`, `cy`, `placement_width`, `placement_height` — lockscreen widget
  geometry, in pixels of the current 2016x1260 panel

## 5. Verifying the desktop before trusting it

```sh
noctalia config validate
systemctl --user status pipewire wireplumber
```

Check in particular: lock screen unlocks (PAM), screen sharing works
(xdg-desktop-portal-wlr), the battery widget appears (UPower), and the
app launcher finds .desktop entries.
