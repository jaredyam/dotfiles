export LC_ALL=en_US.UTF-8
export TERMINFO=/usr/share/terminfo

# This speeds up pasting w/ autosuggest
# https://github.com/zsh-users/zsh-autosuggestions/issues/238
pasteinit() {
    OLD_SELF_INSERT=${${(s.:.)widgets[self-insert]}[2,3]}
    zle -N self-insert url-quote-magic # I wonder if you'd need `.url-quote-magic`?
}

pastefinish() {
    zle -N self-insert $OLD_SELF_INSERT
}
zstyle :bracketed-paste-magic paste-init pasteinit
zstyle :bracketed-paste-magic paste-finish pastefinish

# homebrew auto-update
export HOMEBREW_NO_AUTO_UPDATE=true

# mysql
export PATH="/usr/local/mysql/bin:$PATH"

# rbenv
eval "$(rbenv init -)"

# If you come from bash you might have to change your $PATH.
# export PATH=$HOME/bin:/usr/local/bin:$PATH

# Path to your oh-my-zsh installation.
export ZSH="$HOME/.oh-my-zsh"

# Set name of the theme to load --- if set to "random", it will
# load a random theme each time oh-my-zsh is loaded, in which case,
# to know which specific one was loaded, run: echo $RANDOM_THEME
# See https://github.com/ohmyzsh/ohmyzsh/wiki/Themes
ZSH_THEME="spaceship"
# Customize spaceship theme
SPACESHIP_PROMPT_ADD_NEWLINE=”false”
SPACESHIP_CHAR_SYMBOL=("$ ")
SPACESHIP_CONDA_SYMBOL="🐍 "
SPACESHIP_TIME_SHOW="true"
SPACESHIP_DIR_PREFIX="📂 "
SPACESHIP_EXIT_CODE_SHOW="true"
SPACESHIP_EXIT_CODE_PREFIX="["
SPACESHIP_EXIT_CODE_SUFFIX="] "
SPACESHIP_EXIT_CODE_SYMBOL="#"

# Set list of themes to pick from when loading at random
# Setting this variable when ZSH_THEME=random will cause zsh to load
# a theme from this variable instead of looking in ~/.oh-my-zsh/themes/
# If set to an empty array, this variable will have no effect.
# ZSH_THEME_RANDOM_CANDIDATES=( "robbyrussell" "agnoster" )

# Uncomment the following line to use case-sensitive completion.
# CASE_SENSITIVE="true"

# Uncomment the following line to use hyphen-insensitive completion.
# Case-sensitive completion must be off. _ and - will be interchangeable.
# HYPHEN_INSENSITIVE="true"

# Uncomment the following line to disable bi-weekly auto-update checks.
# DISABLE_AUTO_UPDATE="true"

# Uncomment the following line to automatically update without prompting.
# DISABLE_UPDATE_PROMPT="true"

# Uncomment the following line to change how often to auto-update (in days).
# export UPDATE_ZSH_DAYS=13

# Uncomment the following line if pasting URLs and other text is messed up.
# DISABLE_MAGIC_FUNCTIONS=true

# Uncomment the following line to disable colors in ls.
# DISABLE_LS_COLORS="true"

# Uncomment the following line to disable auto-setting terminal title.
# DISABLE_AUTO_TITLE="true"

# Uncomment the following line to enable command auto-correction.
ENABLE_CORRECTION="true"

# Uncomment the following line to display red dots whilst waiting for completion.
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
# Standard plugins can be found in ~/.oh-my-zsh/plugins/*
# Custom plugins may be added to ~/.oh-my-zsh/custom/plugins/
# Example format: plugins=(rails git textmate ruby lighthouse)
# Add wisely, as too many plugins slow down shell startup.
plugins=(git sudo z jsontools history python sublime vscode xcode macos colored-man-pages colorize zsh-syntax-highlighting zsh-autosuggestions gitignore git-prompt poetry conda-zsh-completion)

source $ZSH/oh-my-zsh.sh

# User configuration

# You may need to manually set your language environment
export LANG=en_US.UTF-8

# Preferred editor for local and remote sessions
export EDITOR="subl -w"
# if [[ -n $SSH_CONNECTION ]]; then
#   export EDITOR='vim'
# else
#   export EDITOR='mvim'
# fi

# Compilation flags
# export ARCHFLAGS="-arch x86_64"

# Set personal aliases, overriding those provided by oh-my-zsh libs,
# plugins, and themes. Aliases can be placed here, though oh-my-zsh
# users are encouraged to define aliases within the ZSH_CUSTOM folder.
# For a full list of active aliases, run `alias`.
#
# Example aliases
# alias zshconfig="mate ~/.zshrc"
# alias ohmyzsh="mate ~/.oh-my-zsh"

# mkdir & cd
function mkd() {
    mkdir -p "$@" && cd "$1"
}

# make python package subdirectories
function mkp() {
    mkdir -p "$@"
    for DIR in "$@"; do
        touch "$DIR/__init__.py"
    done
}

# colorls
source $(dirname $(gem which colorls))/tab_complete.sh
alias ls="colorls --light --sort-dirs --report --dark"
alias lc='colorls -lA --sd'
function tree() {
    if [ "$1" -eq -1 ]; then
        colorls --tree
    else
        colorls --tree="${1:-1}"
    fi
}

# sublime
function sublnp() {
    mkdir "$1"
    cd "$1"
    stn
}

# cd & tree (used for WIP Python project)
function cd() {
    builtin cd "$1"
    if [ -n "$PYTHONPATH" ]; then
        conda activate "$PYTHONPATH/.venv"
        init_cfg_file="$PYTHONPATH/init_project_config.sh"
        if [ -f "$init_cfg_file" ] && ! type cdr >/dev/null 2>&1; then source "$init_cfg_file"; fi
        __conda_activated="True"
    elif [ -n "$__conda_activated" ] && [ -z "$PYTHONPATH" ]; then
        conda deactivate
        unset __conda_activated
    fi
    tree
}

# quick create a python script
function pyscript() {
    echo "#\!/usr/bin/env python3" >$1
    chmod +x $1
    subl $1
}

# fzf
[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh

# Delete multiple files with FZF
function rmf() {
    ls | fzf -m | while read filename; do rm -f $filename; done
}

# conda activate environment with fzf auto-prompting available envs
function conda-activate() {
    conda activate $(conda env list | awk 'NF && !/^#/ {print $1}' | fzf)
}
alias conda-deactivate='conda deactivate'

# conda create environment with fzf auto-prompting available python versions
function conda-create-env() {
    local envname="$1"
    local dirname=$(basename $PWD)
    local response
    [ -z "$envname" ] &&
        read -k 1 "response?No environment name passed in, set it to the current directory name:"$'\n\t'"$dirname (y/[n])? " &&
        echo &&
        case "$response" in
        y | Y | $'\n') envname="$dirname" ;;
        n | N) read "envname?Please enter a name for the new environment: " ;;
        *) echo "Invalid option given." && return 1 ;;
        esac
    conda create -n "$envname" "python=$(conda search python | fzf | awk '{print $2}')"
    [ $(conda env list | grep "$envname" | awk '{print $1}') = "$envname" ] &&
        conda activate "$envname" &&
        echo "Successfully activated environment: $envname"
}

# conda remove environment with fzf auto-prompting available envs
function conda-remove-env() {
    conda env remove --name $(conda env list | awk 'NF && !/^#/ {print $1}' | fzf)
}

# cheat
function cheat() {
    command cheat $1 | bat --theme=base16 --language=bash --style=plain
}

# fzf + preview
function fzf-pre() {
    fzf --preview 'bat {-1} --color=always'
}

# git diff + fzf
function git-diff-fzf() {
    preview="git diff $@ --color=always -- {-1}"
    git diff "$@" --name-only | fzf -m --ansi --preview $preview
}

# mv items to trash by default
function trash() {
    mv -fv "$@" ~/.Trash
}

# generate figlet ASCII-art chars
function pysec() {
    if [[ $2 == -a ]]; then
        result=$(figlet "$1" | boxes -d shell -a hcvc -p v1 -s 70 | sed '2d')
    elif [[ $2 == -d ]]; then
        result=$(figlet "$1" | boxes -d shell -a hcvc -s 70 | sed '2d')
    else
        result=$(figlet "$1" | boxes -d shell -a hcvc -s 70)
    fi
    echo $result | pbcopy
}

# save file as gist
function gist() {
    hub gist create --public -o -c "$1"
    __url=$(pbpaste)
    git clone "$__url" && mv "${__url##*/}" "${1%.*}" && rm "$1" && cd "${1%.*}"
}

# publish public repo in GitHub
function create-public-repo() {
    hub create && git branch -M main && git push -u origin main
}

# publish private repo in Github
function create-private-repo() {
    hub create -p && git branch -M main && git push -u origin main
}

# init folder as a sublime project if needed
function subl() {
    sublime_project_file="${1##*/}.sublime-project"
    if [ "$1" = "." ] && [ -f "${PWD##*/}.sublime-project" ]; then
        command subl "${PWD##*/}.sublime-project"
    elif [ "$1" = ".." ] && [ -f "../$(pwd | awk -F'/' '{print $(NF-1)}').sublime-project" ]; then
        command subl "../$(pwd | awk -F'/' '{print $(NF-1)}').sublime-project"
    elif [ -f "$1/$sublime_project_file" ]; then
        command subl "$1/$sublime_project_file"
    else
        command subl "$1"
    fi
}

# clear python compiled
function pyclear() {
    # {} puts the founded directory names in front of rm command.
    # + make it like: rm dir1 dir2 dir3 ... instead of rm dir1; rm dir2 ...
    find . -type d -name __pycache__ -exec rm -r {} +
}

# change python env name
function rename-env() {
    mv $1 $2
    gsed -i "s:$(head -1 $2/bin/pip):#\!$PWD/$2/bin/python:" $2/bin/*
}

# install python dependencies with writing requirements.txt
function pip-install() {
    for var in "$@"; do
        pip install "$var" && pip freeze | grep -i "^$var==" >>"${PYTHONPATH:-.}/requirements.txt"
    done
    awk -i inplace '!a[$0]++' ${PYTHONPATH:-.}/requirements.txt
}

# uninstall python packages with clearing the corresponding line in the requirements.txt
function pip-uninstall() {
    for var in "$@"; do
        pip uninstall $var
        gsed -i "/$var==./d" ${PYTHONPATH:-.}/requirements.txt
    done
}

# write requirements needed for development
function pip-install-dev() {
    for var in "$@"; do
        pip install "$var" && pip freeze | grep -i "^$var==" >>"${PYTHONPATH:-.}/requirements_dev.txt"
    done
    awk -i inplace '!a[$0]++' ${PYTHONPATH:-.}/requirements_dev.txt
}
function pip-uninstall-dev() {
    for var in "$@"; do
        pip uninstall $var
        gsed -i "/$var==./d" ${PYTHONPATH:-.}/requirements_dev.txt
    done
}

# convert paper title to path-compatible filename
function ptitle2fname {
    [ $# -ne 1 ] && echo "expected only one <paper-title> argument, but got $#" && return 1
    echo -n "$1" | tr ' \n' '__'
}

function ptitle2fname-auto {
    ptitle="$(pbpaste | tr '\n' ' ')"
    echo "[paper title]\n$ptitle"
    fname="$(ptitle2fname "$ptitle" | tee >(pbcopy))"
    echo "[filename]\n$fname"
}

# update homebrew manually
alias updateall='brew update && brew upgrade && brew cleanup && gem update && gem cleanup && brew doctor'

# list path of environment variable
alias path='echo -e ${PATH//:/\\n}'

alias notebook='jupyter notebook'
alias init-envrc='echo "export PYTHONPATH=$PWD" > .envrc && direnv allow'

# vscode
alias code='code-insiders'

alias dotfiles='git --git-dir=$HOME/.dotfiles/ --work-tree=$HOME'
alias dotfiles-lazy='lazygit --git-dir=$HOME/.dotfiles/ --work-tree=$HOME'

export PATH="/usr/local/sbin:$PATH"

# direnv
eval "$(direnv hook zsh)"

# poetry config
export PATH="$HOME/.poetry/bin:$PATH"
fpath+=~/.zfunc

# >>> conda initialize >>>
# !! Contents within this block are managed by 'conda init' !!
__conda_setup="$('/Users/joeyam/miniconda3/bin/conda' 'shell.zsh' 'hook' 2>/dev/null)"
if [ $? -eq 0 ]; then
    eval "$__conda_setup"
else
    if [ -f "/Users/joeyam/miniconda3/etc/profile.d/conda.sh" ]; then
        . "/Users/joeyam/miniconda3/etc/profile.d/conda.sh"
    else
        export PATH="/Users/joeyam/miniconda3/bin:$PATH"
    fi
fi
unset __conda_setup
# <<< conda initialize <<<

# hub
eval "$(hub alias -s)"
