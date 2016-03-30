setopt appendhistory
setopt autocd
setopt correct_all
setopt extendedglob
setopt hist_expire_dups_first
setopt hist_find_no_dups
setopt hist_ignore_all_dups
setopt hist_save_no_dups
setopt interactive_comments
setopt pushd_ignore_dups

bindkey -e

export EDITOR=vi
export USE_EDITOR=$EDITOR
export VISUAL=$EDITOR
# FIXME: check first if they are available
export LC_ALL=en_US.UTF-8

is_linux () {
  [[ $('uname') == 'Linux' ]];
}

is_osx () {
  [[ $('uname') == 'Darwin' ]]
}

fpath=(/usr/share/zsh/vendor-completions/ $fpath)

if is_osx; then
  export HOMEBREW_CASK_OPTS="--appdir=/Applications"
  if [[ ! -f '/usr/local/bin/brew' ]]; then
    ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
    brew tap homebrew/boneyard
  fi
elif is_linux; then
  local BREW_PREFIX=$HOME/.linuxbrew
  export PATH=$BREW_PREFIX/bin:$BREW_PREFIX/sbin:$BREW_PREFIX/share/python:$PATH
  if [[ ! -d $BREW_PREFIX ]]; then
    ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Linuxbrew/linuxbrew/go/install)"
    brew doctor
    mkdir -p $BREW_PREFIX/share/zsh/site-functions
    ln -s $BREW_PREFIX/Library/Contributions/brew_zsh_completion.zsh $BREW_PREFIX/share/zsh/site-functions/_brew
  fi

  export PYTHONPATH=$BREW_PREFIX/lib/python2.7/site-packages:$PYTHONPATH
  export XDG_DATA_DIRS=$BREW_PREFIX/share:$XDG_DATA_DIRS
  export XML_CATALOG_FILES=$BREW_PREFIX/etc/xml/catalog
  fpath=($BREW_PREFIX/share/zsh/site-functions $fpath)
fi

PROMPT_LEAN_TMUX=""
ENHANCD_COMMAND="ecd"

my_zgen() {
  if [[ ! -f ~/.zgen.zsh ]]; then
    printf "Install zgen? [y/N]: "
    if read -q; then
      echo;
      curl -L https://raw.githubusercontent.com/tarjoilija/zgen/master/zgen.zsh > ~/.zgen.zsh
    fi
  fi

  source ~/.zgen.zsh

  if ! zgen saved; then
    echo "Creating zgen save"


    zgen oh-my-zsh plugins/command-not-found
    zgen oh-my-zsh plugins/extract
    zgen oh-my-zsh plugins/pip
    zgen oh-my-zsh plugins/python
    zgen oh-my-zsh plugins/ssh-agent
    zgen oh-my-zsh plugins/sudo
    zgen oh-my-zsh plugins/vagrant
    zgen oh-my-zsh plugins/virtualenv

    zgen load b4b4r07/enhancd
    zgen load caarlos0/zsh-mkc
    zgen load joel-porquet/zsh-dircolors-solarized
    zgen load marzocchi/zsh-notify
    zgen load mrowa44/emojify
    zgen load oconnor663/zsh-sensible
    zgen load rimraf/k
    zgen load sharat87/autoenv
    zgen load zlsun/solarized-man
    zgen load zsh-users/zsh-completions
    zgen load zsh-users/zsh-history-substring-search
    zgen load zsh-users/zsh-syntax-highlighting

    zgen load DoomHammer/gogh themes/solarized.dark.sh overall

    if [[ `brew ls --versions fzf|wc -l` -gt 0 ]]; then
      zgen load $(brew --prefix fzf)/shell
    fi

    zgen load miekg/lean

    zgen save
  fi

  alias emojify=~/.zgen/mrowa44/emojify-master/emojify
}

my_zplug() {
  if [ "$1" = "2" ]; then
    zplug_repo=b4b4r07/zplug2
    zplug_dir=~/.zplug2
    zplug_init=init.zsh
    zplug_cmd=use
  else
    zplug_repo=b4b4r07/zplug
    zplug_dir=~/.zplug
    zplug_init=zplug
    zplug_cmd=of
  fi
  if [ ! -d "$zplug_dir" ]; then
    printf "Install zplug? [y/N]: "
    if read -q; then
      echo;
      git clone "https://github.com/$zplug_repo" "$zplug_dir"
      source "$zplug_dir"/"$zplug_init"
      # manage zplug by itself
      zplug update --self
    fi
  fi

  if [ -f "$zplug_dir"/"$zplug_init" ]; then
    source "$zplug_dir"/"$zplug_init"

    # Make sure you use double quotes
    zplug "$zplug_repo"

    zplug "plugins/command-not-found", from:oh-my-zsh, ignore:oh-my-zsh.sh
    zplug "plugins/extract", from:oh-my-zsh, ignore:oh-my-zsh.sh
    zplug "plugins/pip", from:oh-my-zsh, ignore:oh-my-zsh.sh
    zplug "plugins/python", from:oh-my-zsh, ignore:oh-my-zsh.sh
    zplug "plugins/ssh-agent", from:oh-my-zsh, ignore:oh-my-zsh.sh
    zplug "plugins/sudo", from:oh-my-zsh, ignore:oh-my-zsh.sh
    zplug "plugins/vagrant", from:oh-my-zsh, ignore:oh-my-zsh.sh
    zplug "plugins/virtualenv", from:oh-my-zsh, ignore:oh-my-zsh.sh

    zplug "b4b4r07/enhancd"
    zplug "caarlos0/zsh-mkc"
    zplug "joel-porquet/zsh-dircolors-solarized"
    zplug "marzocchi/zsh-notify"
    zplug "mrowa44/emojify", as:command
    zplug "oconnor663/zsh-sensible"
    zplug "rimraf/k"
    zplug "sharat87/autoenv"
    zplug "zlsun/solarized-man"
    zplug "zsh-users/zsh-completions"
    zplug "zsh-users/zsh-history-substring-search"
    zplug "zsh-users/zsh-syntax-highlighting", nice:19

    zplug "DoomHammer/gogh", $zplug_cmd:"themes/solarized.dark.sh", at:"overall"

    if [[ `brew ls --versions fzf|wc -l` -gt 0 ]]; then
      zplug "$(brew --prefix fzf)/shell", from:local
    fi

    zplug "miekg/lean"

    # Install plugins if there are plugins that have not been installed
    if ! zplug check --verbose; then
      printf "Install zsh plugins? [y/N]: "
      if read -q; then
        echo; zplug install
      fi
    fi

    # Then, source plugins and add commands to $PATH
    zplug load # --verbose
  fi
}

case $ZSH_PLUGIN_MANAGER in
  zplug)
    my_zplug
    ;;
  zplug2)
    my_zplug 2
    ;;
  zgen|*)
    my_zgen
    ;;
esac

if [[ ! -f $HOME/.zsh-dircolors.config ]]; then
  setupsolarized dircolors.256dark
fi

if [[ ! -d ~/.tmux/plugins/tpm ]]; then
  git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm
fi
if [[ `tmux -V |cut -d ' ' -f2` -ge 2.1 ]]; then
  alias tmux='tmux -2 -f ~/.config/tmux/tmux-2.1.conf'
else
  alias tmux='tmux -2 -f ~/.config/tmux/tmux-2.0.conf'
fi

# TMUX
if [[ -z $TMUX ]]; then
  # Attempt to discover a detached session and attach it, else create a new session
  CURRENT_USER=$(whoami)
  if tmux has-session -t $CURRENT_USER 2>/dev/null; then
    tmux attach-session -t $CURRENT_USER
  else
    tmux new-session -s $CURRENT_USER
  fi
fi

if which exa >/dev/null 2>&1; then
  alias ls='exa'
elif which ls++ >/dev/null 2>&1; then
  alias ls='ls++'
else
  alias ls='ls --color=auto'
fi

if which nvim >/dev/null 2>&1; then
  alias vim='nvim'
fi

alias ll='ls -l'
if which vim >/dev/null 2>&1; then
  alias vi='vim'
fi

if [[ ! -z $TMUX ]]; then
  alias fzf='fzf-tmux'
fi

if [[ -x `which ag` ]]; then
  export FZF_DEFAULT_COMMAND='ag -l -g ""'
  export FZF_CTRL_T_COMMAND="$FZF_DEFAULT_COMMAND"
fi
export FZF_DEFAULT_OPTS="--extended-exact"

# v - open files in ~/.viminfo and ~/.nviminfo
v() {
  local files
  files=$(grep --no-filename '^>' ~/.viminfo ~/.nviminfo | cut -c3- |
          while read line; do
            [ -f "${line/\~/$HOME}" ] && echo "$line"
          done | fzf -d -m -q "$*" -1) && vim ${files//\~/$HOME}
}
