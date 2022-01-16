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

# openjdk
export CPPFLAGS="-I/usr/local/opt/openjdk/include"

# openssl
export LD_LIBRARY_PATH=$(brew --prefix openssl)/lib
export CPATH=$(brew --prefix openssl)/include
export PKG_CONFIG_PATH=$(brew --prefix openssl)/lib/pkgconfig
export PATH="/usr/local/opt/openssl@1.1/bin:$PATH"

# To link Rubies to Homebrew's OpenSSL 1.1 (which is upgraded) add the following
export RUBY_CONFIGURE_OPTS="--with-openssl-dir=$(brew --prefix openssl@1.1)"

# homebrew auto-update
export HOMEBREW_NO_AUTO_UPDATE=true

# java
export JENV_ROOT="/usr/local/Cellar/jenv/"
if which jenv > /dev/null;
  then eval "$(jenv init -)";
fi

# mysql
export PATH="/usr/local/mysql/bin:$PATH"

# rbenv
eval "$(rbenv init -)"

# go
export GOPATH="$HOME/go"

# If you come from bash you might have to change your $PATH.
# export PATH=$HOME/bin:/usr/local/bin:$PATH

# Path to your oh-my-zsh installation.
export ZSH="$HOME/.oh-my-zsh"

# Set name of the theme to load --- if set to "random", it will
# load a random theme each time oh-my-zsh is loaded, in which case,
# to know which specific one was loaded, run: echo $RANDOM_THEME
# See https://github.com/ohmyzsh/ohmyzsh/wiki/Themes
# ZSH_THEME="robbyrussell"
ZSH_THEME="spaceship"

SPACESHIP_PROMPT_ADD_NEWLINE=”true”
SPACESHIP_CHAR_SYMBOL=(" \u203d ")
SPACESHIP_CHAR_PREFIX=('🌈 👉')
SPACESHIP_PROMPT_DEFAULT_PREFIX=”$USER”
SPACESHIP_PROMPT_FIRST_PREFIX_SHOW=”true”
SPACESHIP_USER_SHOW=”true”
SPACESHIP_CHAR_COLOR_SUCCESS=("#ffd700")
SPACESHIP_CHAR_COLOR_FAILURE=("#ff5f00")
SPACESHIP_VI_MODE_SHOW="false"
SPACESHIP_CONDA_SYMBOL="🐍 "
SPACESHIP_TIME_SHOW="true"
SPACESHIP_TIME_COLOR="green"
SPACESHIP_DIR_PREFIX="📂 "

# echo "\ue0b0 \u00b1 \ue0a0 \u27a6 \u2718 \u26a1 \u2699"
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
plugins=(git sudo z jsontools history python sublime vscode xcode macos colored-man-pages colorize ruby rbenv zsh-syntax-highlighting zsh-autosuggestions gitignore git-prompt)

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
  for DIR in "$@"
  do
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

# make Apple icons
function mkicn() {
  cd Desktop
  ICONSET="$1.iconset"
  mkdir "$ICONSET"
  mv icon*.png "$ICONSET"
  iconutil -c icns "$ICONSET"
  rm -rf "$ICONSET"
}

# quick create a python script
function pyscript() {
  echo "#\!/usr/bin/env python3" > $1
  chmod +x $1
  subl $1
}

# quick create a web project
function mkweb() {
  mkd $1
  echo '<!DOCTYPE html>
<html>
  <head>
    <meta charset="utf-8">
    <meta name="viewport" content="width=device-width">
    <title>A new project</title>
    <link href="style.css" rel="stylesheet" type="text/css" />
  </head>
  <body>
    <script src="script.js"></script>
  </body>
</html>' > index.html
  touch style.css
  touch script.js
}

# fzf
[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh

# Delete multiple files with FZF
function rmf() {
    ls | fzf -m | while read filename; do rm -f $filename; done
}

# conda activate environment with fzf auto-prompting available envs
function conda-activate() {
  conda activate $(conda info --env | fzf | awk '{print $1}')
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
  conda remove -n $(conda info --env | fzf | awk '{print $1}') --all
}

# Usage: $ mk-thesis-entry lee2010.pdf lecun2014.pdf ...
function mk-thesis-entry() {
    for THESIS in "$@"; do
        temp=${THESIS%.*}
        basename=${temp##*/}
        mkdir -p $temp && mv $THESIS $_ && touch $prefix/$basename-notes.md
    done
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
    if [[  $2 == -a ]]; then
      result=$(figlet "$1" | boxes -d shell -a hcvc -p v1 -s 70 | sed '2d')
    elif [[ $2 == -d ]]; then
      result=$(figlet "$1" | boxes -d shell -a hcvc -s 70 | sed '2d')
    else
      result=$(figlet "$1" | boxes -d shell -a hcvc -s 70)
    fi
    echo $result | pbcopy
}

# quick create leetcode problem python script
function leetcode() {
    if [ -z $@ ];then
        filename=$(pbpaste)
    else
        filename=$@
    fi
    filename=$(echo $filename | tr '[:upper:]' '[:lower:]')
    echo $filename | tr ' ' '_'| pbcopy
    echo $filename.py | tr ' ' '-' | xargs subl
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

# send iMessages
function iMessage() {
    osascript -e "tell application \"Messages\" to send \"${@:2}\" to buddy \"$1\""
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

# open the latest added/modified paper
function paper() {
    paper_dir="$HOME/Library/Mobile Documents/com~apple~CloudDocs/Papers"
    newest_paper=$paper_dir/$(command ls -t "$paper_dir" | head -1)
    url=$(python -c "from pathlib import Path; print(Path(\"$newest_paper\").resolve().as_uri())")
    echo "file url has been copied to the clipboard:"
    echo $url | tee >(pbcopy)
    open $newest_paper
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

# hugo
function hugo-new {
    [[ $PWD != ~/Projects/jaredyam.github.io ]] && cd ~/Projects/jaredyam.github.io
    [ -z "$1" ] && echo "expected assign a blog name (a.k.a. *.md)" && return 1
    [[ $# != 1 ]] && echo "warning: expected create only one blog at once, will create $1 only"
    if [[ ${1: -3} != .md ]];then
      filename=$1.md
    else
      filename=$1
    fi
    hugo new blogs/$filename
    subl content/blogs/$filename
}

function hugo-preview {
    [[ $PWD != ~/Projects/jaredyam.github.io ]] && cd ~/Projects/jaredyam.github.io
    filename=$(find content/blogs -type f -name '*.md' -exec ls -t {} + | awk '{print $NF}' | head -1)
    filename=${filename##*/}
    filename=${filename%.*}
    open http://localhost:1313/blogs/$filename && hugo server -D
}

function hugo-open-recent {
    [[ $PWD != ~/Projects/jaredyam.github.io ]] && cd ~/Projects/jaredyam.github.io
    filename=$(find content/blogs -type f -name '*.md' -exec ls -t {} + | fzf)
    subl $filename
}

function hugo-delete {
    [[ $PWD != ~/Projects/jaredyam.github.io ]] && cd ~/Projects/jaredyam.github.io
    filename=$(find content/blogs -type f -name '*.md' -exec ls -t {} + | fzf)
    echo "remove: $filename" && trash $filename
}

# activate a virtualenv environment
function venv {
    source .venv/bin/activate
}

# convert PDF title string to a path-compatible filename
function title2fname {
    [ $# -ne 1 ] && echo "expected one <title> argument, but got $#" && return 1
    echo "$1" | tr -dc '[:alnum:]-_ \n' | tr ' \n' '__' | tr '[[:upper:]]' '[[:lower:]]' |sed 's/^_*//' | sed 's/_*$//' | tee >(pbcopy)
}

# update homebrew manually
alias updateall='brew update && brew upgrade && brew cleanup && gem update && gem cleanup && brew doctor'

# list path of environment variable
alias path='echo -e ${PATH//:/\\n}'
alias today='date +"%Y%m%d" | pbcopy'

alias s='. ~/.zshrc'
alias a='. activate'
alias d='conda deactivate'
alias v='nvim'
alias f='v `fzf -i`'
alias notebook='jupyter notebook'
alias init-envrc='echo "export PYTHONPATH=$PWD" > .envrc && direnv allow'

# vscode
alias code='code-insiders'

# typora
alias typora='open -a typora'

alias dotfiles='git --git-dir=$HOME/.dotfiles/ --work-tree=$HOME'
alias dotfiles-lazy='lazygit --git-dir=$HOME/.dotfiles/ --work-tree=$HOME'

export PATH="/usr/local/sbin:$PATH"
# git latex diff
export PATH="/usr/local/Cellar/git/2.26.2_1/libexec/git-core/git-latexdiff:$PATH"

# direnv
eval "$(direnv hook zsh)"

# poetry config
export PATH="$HOME/.poetry/bin:$PATH"
fpath+=~/.zfunc

# anaconda
# export PATH="/usr/local/anaconda3/bin:$PATH"  # commented out by conda initialize
# >>> conda initialize >>>
# !! Contents within this block are managed by 'conda init' !!
__conda_setup="$('/Users/joeyam/miniconda3/bin/conda' 'shell.zsh' 'hook' 2> /dev/null)"
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

# tmux
[[ -z $TMUX ]] || conda deactivate; conda activate

# rm duplicate paths
PATH=$(echo "$PATH" | awk -v RS=':' -v ORS=":" '!a[$1]++{if (NR > 1) printf ORS; printf $a[$1]}')

# hub
eval "$(hub alias -s)"
