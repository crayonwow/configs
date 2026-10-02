#!/usr/bin/env bash
# Provision a fresh Fedora install into this dotfiles setup.
#
#   ./bootstrap.sh              run every stage
#   ./bootstrap.sh links        run one or more stages by name
#   ./bootstrap.sh --host x86   force a host profile instead of autodetecting
#
# Every stage is idempotent: re-running it is the normal way to pick up
# changes, not a recovery action.

set -euo pipefail

DOT_FILES="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
STAGES=(repos packages links services user)

log()  { printf '\n\033[1;34m==>\033[0m %s\n' "$*"; }
info() { printf '    %s\n' "$*"; }
warn() { printf '\033[1;33m    warning:\033[0m %s\n' "$*" >&2; }

# ---------------------------------------------------------------- host profile

detect_host() {
    if [[ -r /proc/device-tree/model ]] && grep -qi apple /proc/device-tree/model; then
        echo asahi-mbp
    else
        echo x86
    fi
}

# --------------------------------------------------------------------- stages

stage_repos() {
    log "Third-party repositories"

    # Terra: mangowm, satty, monaspace-nerd-fonts, ghostty. Not noctalia --
    # stock Fedora carries a newer build.
    if ! dnf repolist --enabled 2>/dev/null | grep -q '^terra'; then
        info "adding Terra"
        sudo dnf install -y --nogpgcheck \
            --repofrompath "terra,https://repos.fyralabs.com/terra\$releasever" \
            terra-release
    else
        info "Terra already enabled"
    fi

    local rel; rel=$(rpm -E %fedora)

    if ! rpm -q rpmfusion-free-release >/dev/null 2>&1; then
        info "adding RPM Fusion"
        sudo dnf install -y \
            "https://mirrors.rpmfusion.org/free/fedora/rpmfusion-free-release-${rel}.noarch.rpm" \
            "https://mirrors.rpmfusion.org/nonfree/fedora/rpmfusion-nonfree-release-${rel}.noarch.rpm"
    else
        info "RPM Fusion already enabled"
    fi

    # lazygit has no Fedora package; COPR is the only source.
    sudo dnf copr enable -y dejan/lazygit

    if [[ ! -f /etc/yum.repos.d/docker-ce.repo ]]; then
        info "adding Docker CE"
        sudo dnf config-manager addrepo \
            --from-repofile=https://download.docker.com/linux/fedora/docker-ce.repo
    else
        info "Docker CE already enabled"
    fi

    # Fedora dropped kubernetes-client; kubectl comes from upstream.
    if [[ ! -f /etc/yum.repos.d/kubernetes.repo ]]; then
        info "adding Kubernetes"
        sudo tee /etc/yum.repos.d/kubernetes.repo >/dev/null <<'EOF'
[kubernetes]
name=Kubernetes
baseurl=https://pkgs.k8s.io/core:/stable:/v1.34/rpm/
enabled=1
gpgcheck=1
gpgkey=https://pkgs.k8s.io/core:/stable:/v1.34/rpm/repodata/repomd.xml.key
EOF
    else
        info "Kubernetes already enabled"
    fi
}

stage_packages() {
    log "Packages"
    local list pkgs=()
    for list in base desktop dev; do
        mapfile -t -O "${#pkgs[@]}" pkgs < <(
            grep -vE '^\s*(#|$)' "$DOT_FILES/packages/${list}.list"
        )
    done
    info "installing ${#pkgs[@]} packages"
    sudo dnf install -y "${pkgs[@]}"
}

# link <source-relative-to-repo> <destination>
link() {
    local src="$DOT_FILES/$1" dst="$2"
    [[ -e "$src" ]] || { warn "missing in repo: $1"; return; }
    mkdir -p "$(dirname "$dst")"
    # Replace a real file, but never silently clobber one without a backup.
    if [[ -e "$dst" && ! -L "$dst" ]]; then
        warn "$dst exists as a real file; backing up to $dst.bak"
        mv "$dst" "$dst.bak"
    fi
    ln -sfn "$src" "$dst"
    info "$dst -> $1"
}

stage_links() {
    log "Symlinks (host profile: $HOST)"

    link .zshrc              "$HOME/.zshrc"
    link .gitconfig          "$HOME/.gitconfig"
    link .tmux.conf.local    "$HOME/.config/tmux/tmux.conf.local"
    link lazygit.yml         "$HOME/.config/lazygit/config.yml"
    link alacritty.toml      "$HOME/.config/alacritty/alacritty.toml"
    link config.ghostty      "$HOME/.config/ghostty/config"

    link mango/config.conf   "$HOME/.config/mango/config.conf"
    link "host/$HOST/mango.conf" "$HOME/.config/mango/host.conf"

    # Only the ~/.config layer is safe to symlink; the GUI rewrites the
    # state layer by atomic replace. Refresh with noctalia/sync.sh.
    link noctalia/config.toml "$HOME/.config/noctalia/config.toml"

    # The zz- prefix is load-bearing: *.toml merge alphabetically and
    # config.toml ends up holding a stale copy of this.
    link noctalia/zz-local.toml "$HOME/.config/noctalia/zz-local.toml"

    # Must live under ~/.config: noctalia expands $XDG_CONFIG_HOME in path
    # fields, but not $HOME.
    link tmux/noctalia-theme.tmpl    "$HOME/.config/noctalia/templates/tmux.conf"
    link git/delta-dark.gitconfig    "$HOME/.config/noctalia/templates/delta-dark.gitconfig"
    link git/delta-light.gitconfig   "$HOME/.config/noctalia/templates/delta-light.gitconfig"
    link lazygit/noctalia-theme.tmpl "$HOME/.config/noctalia/templates/lazygit.yml"

    link sway.d/config       "$HOME/.config/sway/config"
}

stage_services() {
    log "Services"

    local unit
    for unit in sshd docker NetworkManager bluetooth; do
        sudo systemctl enable --now "$unit".service
        info "$unit: $(systemctl is-active "$unit".service)"
    done

    for unit in pipewire pipewire-pulse wireplumber; do
        systemctl --user enable --now "$unit".service
        info "$unit (user): $(systemctl --user is-active "$unit".service)"
    done

    if ! getent group docker | grep -q "\b$USER\b"; then
        sudo usermod -aG docker "$USER"
        warn "added $USER to the docker group; log out and back in for it to apply"
    fi
}

stage_user() {
    log "User environment"

    if [[ "$SHELL" != *zsh ]]; then
        info "setting login shell to zsh"
        chsh -s "$(command -v zsh)"
    fi

    local nvim="$HOME/.config/nvim"
    if [[ ! -d "$nvim/.git" ]]; then
        info "cloning neovim config"
        git clone https://github.com/crayonwow/astronvim_config "$nvim"
    else
        info "neovim config present"
    fi

    local tmux="$HOME/.config/tmux"
    if [[ ! -f "$tmux/tmux.conf" ]]; then
        info "installing oh-my-tmux"
        git clone --depth 1 https://github.com/gpakosz/.tmux "$tmux/oh-my-tmux"
        ln -sfn "$tmux/oh-my-tmux/.tmux.conf" "$tmux/tmux.conf"
    else
        info "tmux config present"
    fi

    if ! command -v oh-my-posh >/dev/null; then
        info "installing oh-my-posh"
        curl -s https://ohmyposh.dev/install.sh | bash -s -- -d "$HOME/.local/bin"
    else
        info "oh-my-posh present"
    fi

    # zinit bootstraps itself from .zshrc on first interactive shell.
    info "zinit will install itself on first zsh start"

    warn "not handled here, copy by hand: ~/.ssh, work/, completions/, kube configs"
}

# ----------------------------------------------------------------------- main

HOST=""
requested=()
while [[ $# -gt 0 ]]; do
    case "$1" in
        --host) [[ $# -ge 2 ]] || { echo "--host needs a profile name" >&2; exit 1; }
                HOST="$2"; shift 2 ;;
        -h|--help) sed -n '2,10p' "${BASH_SOURCE[0]}" | sed 's/^# \?//'; exit 0 ;;
        *) requested+=("$1"); shift ;;
    esac
done

HOST="${HOST:-$(detect_host)}"
[[ -d "$DOT_FILES/host/$HOST" ]] || { echo "unknown host profile: $HOST" >&2; exit 1; }

[[ ${#requested[@]} -gt 0 ]] || requested=("${STAGES[@]}")
for stage in "${requested[@]}"; do
    if [[ ! " ${STAGES[*]} " == *" $stage "* ]]; then
        echo "unknown stage: $stage (have: ${STAGES[*]})" >&2
        exit 1
    fi
    "stage_$stage"
done

log "Done."
