export ZSH="$HOME/.oh-my-zsh"
export DOT_FILES="$HOME/configs"

export PATH=$PATH:/usr/local/go/bin
export PATH=$PATH:$(go env GOPATH)/bin
export GRPC_PYTHON_BUILD_SYSTEM_OPENSSL=1
export GRPC_PYTHON_BUILD_SYSTEM_ZLIB=1
export MANPAGER="nvim +Man!"

# Set name of the theme to load --- if set to "random", it will
# load a random theme each time oh-my-zsh is loaded, in which case,
# to know which specific one was loaded, run: echo $RANDOM_THEME
# See https://github.com/ohmyzsh/ohmyzsh/wiki/Themes
# ZSH_THEME="minimal"
# ZSH_THEME="imajes"
# ZSH_THEME="robbyrussell"
ZSH_THEME="spaceship"
SPACESHIP_GOLANG_COLOR="green"

# Set list of themes to pick from when loading at random
# Setting this variable when ZSH_THEME=random will cause zsh to load
# a theme from this variable instead of looking in $ZSH/themes/
# If set to an empty array, this variable will have no effect.
# ZSH_THEME_RANDOM_CANDIDATES=( "robbyrussell" "agnoster" )

# Uncomment the following line to use case-sensitive completion.
# CASE_SENSITIVE="true"

# Uncomment the following line to use hyphen-insensitive completion.
# Case-sensitive completion must be off. _ and - will be interchangeable.
HYPHEN_INSENSITIVE="true"

# Uncomment the following line to disable bi-weekly auto-update checks.
DISABLE_AUTO_UPDATE="false"

# Uncomment the following line to automatically update without prompting.
# DISABLE_UPDATE_PROMPT="true"

# Uncomment the following line to change how often to auto-update (in days).
# export UPDATE_ZSH_DAYS=13

# Uncomment the following line if pasting URLs and other text is messed up.
# DISABLE_MAGIC_FUNCTIONS="true"

# Uncomment the following line to disable colors in ls.
# DISABLE_LS_COLORS="true"

# Uncomment the following line to disable auto-setting terminal title.
# DISABLE_AUTO_TITLE="true"

# Uncomment the following line to enable command auto-correction.
ENABLE_CORRECTION="true"

# Uncomment the following line to display red dots whilst waiting for completion.
# Caution: this setting can cause issues with multiline prompts (zsh 5.7.1 and newer seem to work)
# See https://github.com/ohmyzsh/ohmyzsh/issues/5765
# COMPLETION_WAITING_DOTS="true"

# Uncomment the following line if you want to disable marking untracked files
# under VCS as dirty. This makes repository status check for large repositories
# much, much faster.
# DISABLE_UNTRACKED_FILES_DIRTY="true"

# Uncomment the following line if you want to change the command execution time
# stamp shown in the history command output.
# You can set one of the optional three formats:
# "mm/dd/yyyy"|"dd.mm.yyyy"|"yyyy-mm-dd"
# or set a custom format using the strftime function format specifications,
# see 'man strftime' for details.
# HIST_STAMPS="mm/dd/yyyy"

# Would you like to use another custom folder than $ZSH/custom?
# ZSH_CUSTOM=/path/to/new-custom-folder

# Which plugins would you like to load?
# Standard plugins can be found in $ZSH/plugins/
# Custom plugins may be added to $ZSH_CUSTOM/plugins/
# Example format: plugins=(rails git textmate ruby lighthouse)
# Add wisely, as too many plugins slow down shell startup.

# User configuration

# export MANPATH="/usr/local/man:$MANPATH"

# You may need to manually set your language environment
#export LANG=en_US.UTF-8

# Preferred editor for local and remote sessions
# if [[ -n $SSH_CONNECTION ]]; then
#   export EDITOR='vim'
# else
#   export EDITOR='mvim'
# fi

# Compilation flags
# export ARCHFLAGS="-arch x86_64"

ZSH_AUTOSUGGEST_HIGHLIGHT_STYLE="fg=#663399,standout"
ZSH_AUTOSUGGEST_BUFFER_MAX_SIZE="20"
ZSH_AUTOSUGGEST_USE_ASYNC=1

zstyle ':completion:*:*:kill:*' menu yes select
zstyle ':completion:*:kill:*' force-list always
zstyle ':completion:*:*:kill:*:processes' list-colors "=(#b) #([0-9]#)*=$color[cyan]=$color[red]"
zstyle ':completion:*:*:kill:*:processes' command 'ps --forest -A -o pid,user,cmd'
zstyle ':completion:*:processes-names' command 'ps axho command' 
zstyle ':completion:*:default' list-colors ${(s.:.)LS_COLORS}
zstyle ':completion:*::::' completer _expand _complete _correct _ignored _approximate
zstyle -e ':completion:*:approximate:*' max-errors 'reply=( $(( ($#PREFIX+$#SUFFIX)/3 )) numeric )'
zstyle ':completion:*:expand:*' tag-order all-expansions
zstyle ':completion:*' verbose yes
zstyle ':completion:*:options' description 'yes'
zstyle ':completion:*:options' auto-description '%d'
zstyle ':completion:*:descriptions' format '> %B%d%b'
zstyle ':completion:*:messages' format '> %d'
zstyle ':completion:*:warnings' format '> Ошибка: нет совпадений для: %d'
zstyle ':completion:*:corrections' format '> %B%d (число ошибок: %e)%b'
zstyle ':completion:*:correct:*' insert-unambiguous true
zstyle ':completion:*:correct:*' original true
zstyle ':completion:*:correct:*' prompt 'исправить на:'
zstyle ':completion:*' prompt 'Исправить (число ошибок: %e) > '
zstyle ':completion:*' group-name ''
zstyle ':completion:*' matcher-list 'm:{a-z}={A-Z}' 'r:|[._-]=** r:|=**' 'l:|=* r:|=*'
zstyle ':completion:*' match-original both
zstyle ':completion:*:matches' group 'yes'
zstyle ':completion:*:*:-subscript-:*' tag-order indexes parameters
zstyle ':completion:*:*:(^rm):*:*files' ignored-patterns '*?.o' '*?.c~''*?.old' '*?.pro'
zstyle ':completion:*:rm:*' ignore-line yes
zstyle ':completion:*:functions' ignored-patterns '_*'
zstyle ':completion:*:incremental:*' completer _complete _correct
zstyle ':completion:*:predict:*' completer _complete
zstyle ':mime:*' x-browsers firefox rekonq google-chrome konqueror chromium-browser
zstyle ':mime:*' tty-browsers w3m elinks links lynx
zstyle -e ':completion:*' hosts 'reply=($myhosts)'
zstyle ':completion:*' insert-tab true
zstyle ':completion:*' select-prompt '%SСтрока: %LЭлемент: %M[%p]%s'
zstyle ':completion:*' list-prompt '%SТекущее положение: %p%s'
zstyle ':completion:*' sort true
zstyle ':completion:*' file-sort name
zstyle ':completion:*' keep-prefix changed
zstyle ':completion:*:man:*' separate-sections true
zstyle ':completion:*:history-words' stop yes
zstyle ':completion:*:history-words' remove-all-dups yes
zstyle ':completion:*:history-words' list false
zstyle ':completion:*:history-words' menu yes select
zstyle ':completion:*' old-menu false
# zstyle ':completion:*' original true
zstyle ':completion:*' substitute 1
zstyle ':completion:*' use-compctl true
zstyle ':completion:*' word true
zstyle ':completion:*' special-dirs true
zstyle ':completion:*' squeeze-slashes true
zstyle ':completion:*:(ssh|scp|ftp):*' hosts $hosts
zstyle ':completion:*:(ssh|scp|ftp):*' users $users
zstyle ':completion:*:complete:-command-::commands' ignored-patterns '*\~'
zstyle ':completion:*:*:*:users' ignored-patterns adm apache bin daemon games gdm halt ident junkbust lp mail mailnull named news nfsnobody nobody nscd ntp operator pcap postgres radvd rpc rpcuser rpm shutdown squid sshd sync uucp vcsa xfs
zstyle ':completion:*:*:docker:*' option-stacking yes
zstyle ':completion:*:*:docker-*:*' option-stacking yes


export TERM='xterm-256color'
export EDITOR='nvim'
export PAGER='less'
export LANG='en_US.UTF-8'
export LC_ALL='en_US.UTF-8'
export LC_CTYPE=C
export BLOCKSIZE='Mb'
export GREP_COLOR='1;35;49'
export LESSCHARSET='UTF-8'
export OOO_FORCE_DESKTOP='gnome'
export LESS_TERMCAP_mb=$'\E[01;31m'       
export LESS_TERMCAP_md=$'\E[01;38;5;74m'  
export LESS_TERMCAP_me=$'\E[0m'           
export LESS_TERMCAP_so=$'\E[38;5;246m'    
export LESS_TERMCAP_se=$'\E[0m'           
export LESS_TERMCAP_us=$'\E[04;38;5;146m' 
export LESS_TERMCAP_ue=$'\E[0m'  


HISTFILE=$ZSH/.zsh-history
SAVEHIST=10000
setopt HIST_IGNORE_ALL_DUPS
setopt HIST_IGNORE_SPACE
setopt INC_APPEND_HISTORY
setopt EXTENDED_HISTORY 
setopt histexpiredupsfirst histfindnodups
setopt CORRECT_ALL
setopt AUTO_CD
setopt SH_WORD_SPLIT
# setopt IGNORE_EOF
setopt NO_BEEP
setopt extended_glob
setopt correct
setopt MENUCOMPLETE
setopt nohup
setopt ZLE
setopt MULTIBYTE
setopt NUMERIC_GLOB_SORT
set -o vi


plugins=(
	git
	docker-compose
	docker
	brew
    golang
    rust
    gh
    pip
    python
    vi-mode
    macos
    poetry
    kubectl
    minikube
    terraform
)

source $ZSH/oh-my-zsh.sh

# Set personal aliases, overriding those provided by oh-my-zsh libs,
# plugins, and themes. Aliases can be placed here, though oh-my-zsh
# users are encouraged to define aliases within the ZSH_CUSTOM folder.
# For a full list of active aliases, run `alias`.
#
# Example aliases
# alias ohmyzsh="mate ~/.oh-my-zsh"
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
alias n="nvim ."
alias ll="eza -lax --icons --header --git --created --modified --color-scale -H --group-directories-first"
alias l="eza"
alias cat="bat --theme=OneHalfDark"

# example
# update_go 1.21.0
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

source <(fzf --zsh)
eval "$(zoxide init zsh)"

source "$DOT_FILES/.zshrc.work"
if [ -d $DOT_FILES/completions ]; then
  for config_file in $DOT_FILES/completions/*; do
    if [ -f "$config_file" ]; then
      source "$config_file"
    fi
  done
fi
