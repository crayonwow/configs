export DOT_FILES="$HOME/configs"
export PATH=$PATH:/usr/local/go/bin
export PATH=$PATH:$(go env GOPATH)/bin
export PATH=$HOME/.local/bin:$PATH
export GRPC_PYTHON_BUILD_SYSTEM_OPENSSL=1
export GRPC_PYTHON_BUILD_SYSTEM_ZLIB=1
export MANPAGER="nvim +Man!"
export PATH="${ASDF_DATA_DIR:-$HOME/.asdf}/shims:$PATH"
export TERM='xterm-256color'
export EDITOR='nvim'
export PAGER='bat'
export LANG='en_US.UTF-8'
export LC_ALL='en_US.UTF-8'
export LC_CTYPE=C
export BLOCKSIZE='Mb'
export GREP_COLORS='mt=1;35;49'
export LESSCHARSET='UTF-8'
export OOO_FORCE_DESKTOP='gnome'
export LESS_TERMCAP_mb=$'\E[01;31m'       
export LESS_TERMCAP_md=$'\E[01;38;5;74m'  
export LESS_TERMCAP_me=$'\E[0m'           
export LESS_TERMCAP_so=$'\E[38;5;246m'    
export LESS_TERMCAP_se=$'\E[0m'           
export LESS_TERMCAP_us=$'\E[04;38;5;146m' 
export LESS_TERMCAP_ue=$'\E[0m'  

if [ "$TERM_PROGRAM" != "Apple_Terminal" ]; then
  eval "$(oh-my-posh init zsh --config $DOT_FILES/ohmyposh.yaml)"
fi

if [[ -f "/opt/homebrew/bin/brew" ]] then
  # If you're using macOS, you'll want this enabled
  eval "$(/opt/homebrew/bin/brew shellenv)"
fi

# Set the directory we want to store zinit and plugins
ZINIT_HOME="${XDG_DATA_HOME:-${HOME}/.local/share}/zinit/zinit.git"

# Download Zinit, if it's not there yet
if [ ! -d "$ZINIT_HOME" ]; then
   mkdir -p "$(dirname $ZINIT_HOME)"
   git clone https://github.com/zdharma-continuum/zinit.git "$ZINIT_HOME"
fi

# Source/Load zinit
source "${ZINIT_HOME}/zinit.zsh"

# Add in zsh plugins
zinit light zsh-users/zsh-syntax-highlighting
zinit light zsh-users/zsh-completions
zinit light zsh-users/zsh-autosuggestions
zinit light Aloxaf/fzf-tab

# zinit snippet OMZP::archlinux        
zinit snippet OMZP::aws              
zinit snippet OMZP::brew
zinit snippet OMZP::command-not-found
zinit snippet OMZP::docker
zinit snippet OMZP::docker-compose
zinit snippet OMZP::gh
zinit snippet OMZP::git              
zinit snippet OMZP::golang
zinit snippet OMZP::kubectl
zinit snippet OMZP::kubectx          
zinit snippet OMZP::rust
zinit snippet OMZP::terraform

bindkey -v
bindkey '^p' history-search-backward
bindkey '^n' history-search-forward

HISTSIZE=10000
HISTFILE=~/.zsh_history
SAVEHIST=$HISTSIZE
HISTDUP=erase
setopt appendhistory
setopt sharehistory
setopt hist_ignore_space
setopt hist_ignore_all_dups
setopt hist_save_no_dups
setopt hist_ignore_dups
setopt hist_find_no_dups

# Completion styling
zstyle ':completion:*' matcher-list '' \
  'm:{a-z\-}={A-Z\_}' \
  'r:[^[:alpha:]]||[[:alpha:]]=** r:|=* m:{a-z\-}={A-Z\_}' \
  'r:|?=** m:{a-z\-}={A-Z\_}'
zstyle ':completion:*' list-colors "${(s.:.)LS_COLORS}"
zstyle ':completion:*' menu no
zstyle ':fzf-tab:complete:cd:*' fzf-preview 'ls --color $realpath'
zstyle ':fzf-tab:complete:__zoxide_z:*' fzf-preview 'ls --color $realpath'


alias zshconfig="zim $DOT_FILES"
alias vimconfig="zim ~/.config/nvim/lua"

alias d_connect_test_db="docker exec -it mysql_test_db mysql -uroot -p123qwe"
alias d_create_test_db="docker run --rm --name mysql_test_db -p 3306:3306 -e MYSQL_ROOT_PASSWORD=123qwe -d mysql:latest && sleep 5 && d_connect_test_db"
alias d_connect_test_redis="docker exec -it redis_test_db redis-cli"
alias d_create_test_redis="docker run --rm --network=host --name redis_test_db -d redis --port 7777 && sleep 5 && d_connect_test_redis"

alias dps="docker ps -a --format '{{.Names}} - {{.Status}}'"
alias dsp="docker system prune -af --volumes "

alias gl='git log --format="%Cred%H %Cblue%an %Creset(%ah) %Cgreen%s" --no-merges'

alias swagger2='docker run --rm -it  --user $(id -u):$(id -g) -e GOPATH=$(go env GOPATH):/go -v $HOME:$HOME -w $(pwd) quay.io/goswagger/swagger'
alias n="nvim"
alias ll="eza -lax --icons --header --git --created --modified --color-scale -H --group-directories-first"
alias l="eza"
alias cat="bat -p --theme=OneHalfDark"
alias z="cd"

# example
# update_go 1.21.0
# use only when installed manualy
function update_go { 
    mkdir -p tmp
    cd tmp
    os=$(go env GOOS)
    arch=$(go env GOARCH)
    sudo rm -rf $(go env GOROOT)
    curl -L https://dl.google.com/go/go"$1"."$os"-"$arch".tar.gz >> go.tar.gz
    sudo tar -C /usr/local -xzf go.tar.gz
    cd ..
    rm -rf tmp
    go version
}

# z + nvim - if has args than goes to dir and run nvim. otherwise calls fzf+z to choose dir and starts nvim
function zim { 
    command='zi'
    if [ $# -ne 0 ]
    then
        command='z "$1"'
    fi
    eval ${command} && nvim . && z - >> /dev/null
}

for config_file in $(ls $DOT_FILES/work); do
    source $DOT_FILES/work/$config_file
done

for config_file in $(ls $DOT_FILES/completions); do
    source $DOT_FILES/completions/$config_file
done

source <(fzf --zsh)
eval "$(zoxide init --cmd cd zsh)"
autoload bashcompinit && bashcompinit
autoload -Uz compinit && compinit
complete -C '/usr/local/bin/aws_completer' aws
