# Clone zcomet if necessary
if [[ ! -f ${ZDOTDIR:-${HOME}}/.zcomet/bin/zcomet.zsh ]]; then
  command git clone https://github.com/agkozak/zcomet.git ${ZDOTDIR:-${HOME}}/.zcomet/bin
fi

source ${ZDOTDIR:-${HOME}}/.zcomet/bin/zcomet.zsh

# set sane options
zcomet load willghatch/zsh-saneopt

zcomet load ohmyzsh plugins/ssh-agent
zcomet load --no-submodules prezto modules/history

zcomet load zsh-users/zsh-completions
zcomet load zsh-users/zsh-autosuggestions
zcomet load --no-submodules prezto modules/completion

zcomet load ohmyzsh plugins/gitfast
zcomet load --no-submodules prezto modules/archive

zcomet load zsh-users/zsh-history-substring-search

zcomet load Aloxaf/fzf-tab
zcomet load olets/zsh-abbr
zcomet load djui/alias-tips
zcomet load zdharma-continuum/fast-syntax-highlighting

# vi mode
ZVM_INIT_MODE=sourcing
zcomet load jeffreytse/zsh-vi-mode

ZSH_AUTOSUGGEST_STRATEGY=(match_prev_cmd history completion)

bindkey '^[[A' history-substring-search-up
bindkey '^[[B' history-substring-search-down

# Vi
bindkey -M vicmd "k" history-substring-search-up
bindkey -M vicmd "j" history-substring-search-down

OS="$(uname)"
if [[ "$OS" == "Linux" ]]; then
  eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"
  export WHALEBREW_INSTALL_PATH=/home/linuxbrew/.linuxbrew/bin
fi

source ${HOME}/.local/share/sh/homebrew.sh
if [[ "$OS" == "Darwin" ]]; then
  eval "$($(homebrew_location)/bin/brew shellenv)"
fi

eval "$(starship init zsh)"
eval "$(zoxide init zsh)"

setopt pushd_ignore_dups

# Load user config from ~/.zsh.after
if [ -d $HOME/.zsh.after/ ]; then
  if [ "$(ls -A $HOME/.zsh.after/)" ]; then
    for config_file ($HOME/.zsh.after/*.zsh) source $config_file
  fi
fi

zcomet compinit
