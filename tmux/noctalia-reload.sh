#!/usr/bin/env sh
# post_hook for the noctalia tmux template: re-source the top-level config
# in running servers. noctalia's own re-render only updates the style
# options it sets; oh-my-tmux bakes colours into format strings and rebuilds
# them only when the whole config is parsed again.

set -eu

command -v tmux >/dev/null 2>&1 || exit 0

for config in "$HOME/.tmux.conf" \
              "${XDG_CONFIG_HOME:-$HOME/.config}/tmux/tmux.conf" \
              "$HOME/.config/tmux/tmux.conf"; do
    [ -f "$config" ] && break
    config=""
done
[ -n "$config" ] || exit 0

socket_dir="${TMUX_TMPDIR:-/tmp}/tmux-$(id -u)"
[ -d "$socket_dir" ] || exit 0

for socket in "$socket_dir"/*; do
    [ -S "$socket" ] || continue

    # Only touch servers that actually loaded this config.
    loaded=$(tmux -N -S "$socket" display-message -p '#{config_files}' 2>/dev/null) || continue
    case ",$loaded," in
        *",$config,"*) tmux -N -S "$socket" source-file "$config" >/dev/null 2>&1 || true ;;
    esac
done
