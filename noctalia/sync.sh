#!/usr/bin/env bash
# Copy the live noctalia config into this repo. Run after changing things
# in the GUI; nothing calls it automatically.
#
# The GUI layer (~/.local/state/noctalia/settings.toml) is rewritten by
# atomic replace, so it cannot be symlinked -- hence copying. It also loads
# last, so the tracked file only takes effect on a machine with empty state.

set -euo pipefail

DOT_FILES="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
target="$DOT_FILES/noctalia/config.toml"
tmp="$(mktemp)"
trap 'rm -f "$tmp"' EXIT

command -v noctalia >/dev/null || { echo "noctalia is not installed" >&2; exit 1; }
pgrep -x noctalia >/dev/null || { echo "noctalia is not running; start it first" >&2; exit 1; }

# Public repo: personal tables, subtables included, stay out.
private_tables='^(location|calendar[.]account)([.]|$)'

noctalia config export | awk -v re="$private_tables" '
    /^[[:space:]]*\[/ {
        name = $0
        gsub(/^[[:space:]]*\[+|\]+[[:space:]]*$/, "", name)
        skip = (name ~ re)
    }
    !skip
' > "$tmp"
noctalia config validate "$tmp" >/dev/null || { echo "exported config does not validate" >&2; exit 1; }

if cmp -s "$tmp" "$target"; then
    echo "no change"
    exit 0
fi

cp "$tmp" "$target"
echo "updated $target"

# These keys are tied to this specific machine and need review before they
# mean anything on another one.
if grep -qE 'eDP-|/home/|placement_|cx = |cy = ' "$target"; then
    echo
    echo "host-specific values captured, review before relying on them elsewhere:"
    grep -nE 'eDP-|/home/|placement_|cx = |cy = ' "$target" | sed 's/^/  /'
fi
