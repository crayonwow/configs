#!/bin/sh
# post_hook for the noctalia "mango" template.
#
# The template is written in the 0.18.0 key naming. Terra still builds 0.17.x
# for aarch64, and that version rejects those names, which would leave the
# window decorations stuck on the static colours from host.conf. Fold the ten
# renamed keys back when an older mango is the one installed.
set -eu

out="${XDG_CONFIG_HOME:-$HOME/.config}/mango/noctalia.conf"
[ -f "$out" ] || exit 0

ver=$(mango -v 2>&1 | grep -oE '[0-9]+\.[0-9]+\.[0-9]+' | head -n1 || true)
oldest=$(printf '%s\n0.18.0\n' "${ver:-0.18.0}" | sort -V | head -n1)

if [ "$oldest" != "0.18.0" ]; then
    sed -i \
        -e 's/^root_color/rootcolor/' \
        -e 's/^border_color/bordercolor/' \
        -e 's/^drop_color/dropcolor/' \
        -e 's/^split_color/splitcolor/' \
        -e 's/^focus_color/focuscolor/' \
        -e 's/^maximized_screen_color/maximizescreencolor/' \
        -e 's/^urgent_color/urgentcolor/' \
        -e 's/^scratchpad_color/scratchpadcolor/' \
        -e 's/^global_color/globalcolor/' \
        -e 's/^overlay_color/overlaycolor/' \
        "$out"
fi

mmsg dispatch reload_config 2>/dev/null || true
