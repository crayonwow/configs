#!/usr/bin/env sh
# Feed noctalia's palette into oh-my-tmux's theme variables, which it reads
# from the environment. Without this the status line keeps oh-my-tmux's own
# colours: it bakes them into format strings as #[fg=...], which override
# the style options noctalia sets.
#
# Reads the rendered theme file directly, not the @noctalia_* options.

set -eu

theme="${XDG_CONFIG_HOME:-$HOME/.config}/tmux/themes/noctalia.conf"
[ -r "$theme" ] || exit 0

# Pull one @noctalia_<role> value out of the generated file.
c() {
    sed -n "s/^set -gq @noctalia_$1 \"\\(.*\\)\"\$/\\1/p" "$theme"
}

set_var() {
    [ -n "$2" ] || return 0
    tmux setenv -g "$1" "$2"
}

surface_low=$(c surface_container_low)
surface=$(c surface_container)
surface_high=$(c surface_container_high)
on_surface=$(c on_surface)
on_surface_variant=$(c on_surface_variant)
outline_variant=$(c outline_variant)
primary=$(c primary)
on_primary=$(c on_primary)
primary_container=$(c primary_container)
on_primary_container=$(c on_primary_container)
secondary_container=$(c secondary_container)
on_secondary_container=$(c on_secondary_container)
tertiary_container=$(c tertiary_container)
on_tertiary_container=$(c on_tertiary_container)

# status line
set_var tmux_conf_theme_status_fg "$on_surface_variant"
set_var tmux_conf_theme_status_bg "$surface_low"

# windows: inactive, current, last, bell
set_var tmux_conf_theme_window_status_fg "$on_surface_variant"
set_var tmux_conf_theme_window_status_bg "$surface"
set_var tmux_conf_theme_window_status_current_fg "$on_primary"
set_var tmux_conf_theme_window_status_current_bg "$primary"
set_var tmux_conf_theme_window_status_last_fg "$primary"
set_var tmux_conf_theme_window_status_last_bg "$surface"
set_var tmux_conf_theme_window_status_bell_fg "$on_tertiary_container"
set_var tmux_conf_theme_window_status_bell_bg "$tertiary_container"

# panes
set_var tmux_conf_theme_pane_border "$outline_variant"
set_var tmux_conf_theme_pane_active_border "$primary"
set_var tmux_conf_theme_pane_indicator "$primary"
set_var tmux_conf_theme_pane_active_indicator "$primary"
set_var tmux_conf_theme_focused_pane_bg "$surface"

# messages and copy mode
set_var tmux_conf_theme_message_fg "$on_primary_container"
set_var tmux_conf_theme_message_bg "$primary_container"
set_var tmux_conf_theme_message_command_fg "$on_secondary_container"
set_var tmux_conf_theme_message_command_bg "$secondary_container"
set_var tmux_conf_theme_mode_fg "$on_secondary_container"
set_var tmux_conf_theme_mode_bg "$secondary_container"

set_var tmux_conf_theme_clock_colour "$primary"

# The left and right status segments each take a comma-separated triplet,
# one entry per segment, so they have to be built rather than assigned.
set_var tmux_conf_theme_status_left_fg "$on_primary,$on_secondary_container,$on_tertiary_container"
set_var tmux_conf_theme_status_left_bg "$primary,$secondary_container,$tertiary_container"
set_var tmux_conf_theme_status_right_fg "$on_surface_variant,$on_surface,$on_primary"
set_var tmux_conf_theme_status_right_bg "$surface,$surface_high,$primary"
